package nox.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Locale;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import nox.config.DBConnection;

/**
 * ActivityLogger - Records every feature run (transcribe, translate, summary, todo, qna)
 * into the activity_history table so users can revisit their history.
 *
 * Any lowercase frontend key is normalized to the uppercase ENUM value
 * ('TRANSCRIBE','TRANSLATE','SUMMARY','TODO','QNA') before insert.
 * Fails silently (logs to stderr) so feature servlets are never blocked by history errors.
 */
public class ActivityLogger {

    public static final String TYPE_TRANSCRIBE = "transcribe";
    public static final String TYPE_TRANSLATE  = "translate";
    public static final String TYPE_SUMMARY    = "summary";
    public static final String TYPE_TODO       = "todo";
    public static final String TYPE_QNA        = "qna";
    public static final String TYPE_TTS        = "tts";

    private static volatile boolean tableEnsured = false;

    private static void ensureTable() {
        if (tableEnsured) return;
        synchronized (ActivityLogger.class) {
            if (tableEnsured) return;
            try (Connection conn = DBConnection.getConnection()) {
                if (conn == null) return;
                try (java.sql.Statement st = conn.createStatement()) {
                    st.executeUpdate(
                        "CREATE TABLE IF NOT EXISTS activity_history ("
                      + "id INT AUTO_INCREMENT PRIMARY KEY, "
                      + "user_id INT NOT NULL, "
                      + "feature_type VARCHAR(32) NOT NULL, "
                      + "title VARCHAR(255), "
                      + "input_text LONGTEXT, "
                      + "output_text LONGTEXT, "
                      + "metadata JSON DEFAULT NULL, "
                      + "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
                      + "INDEX idx_user_created (user_id, created_at)"
                      + ")"
                    );
                }
                tableEnsured = true;
            } catch (Exception e) {
                System.err.println("ActivityLogger ensureTable failed: " + e.getMessage());
            }
        }
    }

    /** Lowercase frontend keys -> uppercase DB ENUM values. */
    private static final Map<String, String> FEATURE_MAP = Map.of(
        "transcribe", "TRANSCRIBE",
        "translate",  "TRANSLATE",
        "summary",    "SUMMARY",
        "todo",       "TODO",
        "qna",        "QNA",
        "aichat",     "QNA",
        "tts",        "TTS"
    );

    /**
     * Inserts an activity row for the currently logged-in user.
     *
     * @param request    current HTTP request (used to resolve the session user)
     * @param featureType feature key, e.g. "transcribe", "qna"
     * @param title      short human-readable title ("Untitled Activity" when null)
     * @param inputData  transcript / source text / prompt / question
     * @param outputData transcribed / translated / summary / tasks / answer
     * @param metadataJson valid JSON string (or null -> "{}")
     */
    public static void log(HttpServletRequest request, String featureType, String title,
                           String inputData, String outputData, String metadataJson) {
        ensureTable();
        try (Connection conn = DBConnection.getConnection()) {
            HttpSession session = request.getSession(false);
            if (session == null) return;

            Integer userId = resolveUserId(session, conn);
            if (userId == null) return;

            String sql = "INSERT INTO activity_history "
                       + "(user_id, feature_type, title, input_text, output_text, metadata) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, normalizeFeature(featureType));
                ps.setString(3, title != null && !title.isEmpty() ? truncate(title, 255) : "Untitled Activity");
                ps.setString(4, truncate(inputData, 20000));
                ps.setString(5, truncate(outputData, 20000));
                ps.setString(6, metadataJson != null && !metadataJson.isEmpty() ? metadataJson : "{}");
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.err.println("ActivityLogger failed: " + e.getMessage());
        }
    }

    /** Overload accepting HttpSession directly (used by Spring MVC controllers). */
    public static void log(HttpSession session, String featureType, String title,
                           String inputData, String outputData, String metadataJson) {
        ensureTable();
        try (Connection conn = DBConnection.getConnection()) {
            if (session == null) return;

            Integer userId = resolveUserId(session, conn);
            if (userId == null) return;

            String sql = "INSERT INTO activity_history "
                       + "(user_id, feature_type, title, input_text, output_text, metadata) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, normalizeFeature(featureType));
                ps.setString(3, title != null && !title.isEmpty() ? truncate(title, 255) : "Untitled Activity");
                ps.setString(4, truncate(inputData, 20000));
                ps.setString(5, truncate(outputData, 20000));
                ps.setString(6, metadataJson != null && !metadataJson.isEmpty() ? metadataJson : "{}");
                ps.executeUpdate();
            }
        } catch (Exception e) {
            System.err.println("ActivityLogger failed: " + e.getMessage());
        }
    }

    /** Backwards-compatible overload without a title. */
    public static void log(HttpServletRequest request, String featureType,
                           String inputData, String outputData, String metadataJson) {
        log(request, featureType, null, inputData, outputData, metadataJson);
    }

    /** Overload accepting HttpSession without a title. */
    public static void log(HttpSession session, String featureType,
                           String inputData, String outputData, String metadataJson) {
        log(session, featureType, null, inputData, outputData, metadataJson);
    }

    /** Maps a lowercase key to the DB ENUM value; uppercases anything unknown. */
    public static String normalizeFeature(String featureType) {
        if (featureType == null) return "QNA";
        String key = featureType.trim().toLowerCase(Locale.ROOT);
        String mapped = FEATURE_MAP.get(key);
        return mapped != null ? mapped : key.toUpperCase(Locale.ROOT);
    }

    /** Prefers session userId, falls back to looking up by session email. */
    private static Integer resolveUserId(HttpSession session, Connection conn) {
        Object stored = session.getAttribute("userId");
        if (stored instanceof Integer) return (Integer) stored;
        if (stored instanceof Long) return ((Long) stored).intValue();

        String email = (String) session.getAttribute("email");
        if (email == null || email.isEmpty()) return null;

        try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE email = ? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    session.setAttribute("userId", id);
                    return id;
                }
            }
        } catch (Exception e) {
            System.err.println("ActivityLogger user lookup failed: " + e.getMessage());
        }
        return null;
    }

    private static String truncate(String value, int maxLength) {
        if (value == null || value.length() <= maxLength) return value;
        return value.substring(0, maxLength);
    }
}
