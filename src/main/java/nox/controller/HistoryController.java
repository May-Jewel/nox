package nox.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;
import nox.config.DBConnection;
import nox.model.User;

@RestController
@RequestMapping("/api/history")
public class HistoryController {

    private static final int DEFAULT_LIMIT = 8;
    private static final int MAX_LIMIT = 50;
    private static final int PREVIEW_LENGTH = 200;

    private static volatile boolean tableEnsured = false;

    private static void ensureTable() {
        if (tableEnsured) return;
        synchronized (HistoryController.class) {
            if (tableEnsured) return;
            try (Connection conn = DBConnection.getConnection()) {
                if (conn == null) return;
                try (Statement st = conn.createStatement()) {
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
                System.err.println("HistoryController ensureTable failed: " + e.getMessage());
            }
        }
    }

    private static final Map<String, String> FEATURE_MAP = Map.of(
        "transcribe", "TRANSCRIBE",
        "translate",  "TRANSLATE",
        "summary",    "SUMMARY",
        "todo",       "TODO",
        "qna",        "QNA",
        "aichat",     "QNA",
        "tts",        "TTS"
    );

    @GetMapping
    public Map<String, Object> getHistory(
            @RequestParam(value = "id", required = false) String idParam,
            @RequestParam(value = "filter", defaultValue = "all") String filter,
            @RequestParam(value = "timeRange", required = false) String timeRange,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "limit", defaultValue = "8") int limit,
            HttpSession session) {

        Integer userId = resolveUserId(session);
        if (userId == null) {
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Not logged in");
            return err;
        }

        ensureTable();

        if (idParam != null && !idParam.trim().isEmpty()) {
            return fetchDetail(userId, idParam);
        }

        limit = Math.max(1, Math.min(MAX_LIMIT, limit));
        int offset = (page - 1) * limit;

        String where = "WHERE user_id = ?";
        List<Object> params = new ArrayList<>();
        params.add(userId);

        String sanitizedFilter = sanitizeFilter(filter);
        if (!"all".equals(sanitizedFilter) && FEATURE_MAP.containsKey(sanitizedFilter)) {
            where += " AND feature_type = ?";
            params.add(FEATURE_MAP.get(sanitizedFilter));
        }

        if ("today".equalsIgnoreCase(timeRange)) {
            where += " AND created_at >= CURDATE()";
        } else if ("7days".equalsIgnoreCase(timeRange)) {
            where += " AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)";
        } else if ("30days".equalsIgnoreCase(timeRange)) {
            where += " AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)";
        }

        if (search != null && !search.trim().isEmpty()) {
            String like = "%" + search.trim() + "%";
            where += " AND (title LIKE ? OR input_text LIKE ? OR output_text LIKE ?)";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        try (Connection conn = DBConnection.getConnection()) {
            int total = countTotal(conn, where, params);
            List<Map<String, Object>> items = fetchPage(conn, where, params, limit, offset);

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("total", total);
            result.put("page", page);
            result.put("limit", limit);
            result.put("hasMore", offset + items.size() < total);
            result.put("items", items);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Failed to load history.");
            return err;
        }
    }

    @DeleteMapping
    public Map<String, Object> deleteHistory(
            @RequestParam(value = "id", required = false) String idParam,
            @RequestParam(value = "ids", required = false) String idsParam,
            @RequestParam(value = "all", required = false) String allParam,
            HttpSession session) {

        Integer userId = resolveUserId(session);
        if (userId == null) {
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Not logged in");
            return err;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int deleted = 0;

            if ("true".equals(allParam)) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "DELETE FROM activity_history WHERE user_id = ?")) {
                    ps.setInt(1, userId);
                    deleted = ps.executeUpdate();
                }
            } else {
                String ids = idsParam != null ? idsParam : idParam;
                if (ids != null && !ids.trim().isEmpty()) {
                    deleted = deleteByIds(conn, userId, ids);
                }
            }

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("deleted", deleted);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Failed to delete history.");
            return err;
        }
    }

    private Map<String, Object> fetchDetail(Integer userId, String idParam) {
        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Invalid id.");
            return err;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT id, feature_type, title, input_text, output_text, metadata, created_at "
               + "FROM activity_history WHERE id = ? AND user_id = ? LIMIT 1")) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return activityToMap(rs, false);
                } else {
                    Map<String, Object> err = new LinkedHashMap<>();
                    err.put("error", "Activity not found.");
                    return err;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> err = new LinkedHashMap<>();
            err.put("error", "Failed to load activity.");
            return err;
        }
    }

    private Map<String, Object> activityToMap(ResultSet rs, boolean preview) throws Exception {
        Map<String, Object> item = new LinkedHashMap<>();
        item.put("id", rs.getInt("id"));
        item.put("featureType", rs.getString("feature_type"));
        item.put("title", rs.getString("title"));
        item.put("inputData", truncate(rs.getString("input_text"), preview));
        item.put("outputData", truncate(rs.getString("output_text"), preview));
        String metadata = rs.getString("metadata");
        item.put("metadata", metadata != null && !metadata.isEmpty() ? metadata : "{}");
        item.put("createdAt", rs.getString("created_at"));
        return item;
    }

    private String truncate(String value, boolean preview) {
        if (!preview || value == null || value.length() <= PREVIEW_LENGTH) return value;
        return value.substring(0, PREVIEW_LENGTH) + "...";
    }

    private int countTotal(Connection conn, String where, List<Object> params) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM activity_history " + where)) {
            bind(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private List<Map<String, Object>> fetchPage(Connection conn, String where, List<Object> params,
                                                 int limit, int offset) throws Exception {
        String sql = "SELECT id, feature_type, title, input_text, output_text, metadata, created_at "
                   + "FROM activity_history " + where
                   + " ORDER BY created_at DESC, id DESC LIMIT ? OFFSET ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            bind(ps, params);
            ps.setInt(params.size() + 1, limit);
            ps.setInt(params.size() + 2, offset);
            List<Map<String, Object>> items = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(activityToMap(rs, true));
                }
            }
            return items;
        }
    }

    private int deleteByIds(Connection conn, Integer userId, String idsParam) throws Exception {
        String[] raw = idsParam.split(",");
        List<Integer> ids = new ArrayList<>();
        for (String part : raw) {
            try {
                ids.add(Integer.parseInt(part.trim()));
            } catch (NumberFormatException ignored) {}
        }
        if (ids.isEmpty()) return 0;

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) placeholders.append(',');
            placeholders.append('?');
        }

        String sql = "DELETE FROM activity_history WHERE user_id = ? AND id IN (" + placeholders + ")";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 2, ids.get(i));
            }
            return ps.executeUpdate();
        }
    }

    private void bind(PreparedStatement ps, List<Object> params) throws Exception {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private Integer resolveUserId(HttpSession session) {
        if (session == null) return null;

        Object stored = session.getAttribute("userId");
        if (stored instanceof Integer) return (Integer) stored;
        if (stored instanceof Long) return ((Long) stored).intValue();

        Object currentUserObj = session.getAttribute("currentUser");
        if (currentUserObj instanceof User) {
            int id = ((User) currentUserObj).getId();
            if (id > 0) {
                session.setAttribute("userId", id);
                return id;
            }
        }

        String email = (String) session.getAttribute("email");
        if (email == null && currentUserObj instanceof User) {
            email = ((User) currentUserObj).getEmail();
        }
        if (email == null || email.isEmpty()) return null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE email = ? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    session.setAttribute("userId", id);
                    return id;
                }
            }
        } catch (Exception e) {
            System.err.println("HistoryController user lookup failed: " + e.getMessage());
        }
        return null;
    }

    private String sanitizeFilter(String raw) {
        if (raw == null) return "all";
        String value = raw.trim().toLowerCase();
        return FEATURE_MAP.containsKey(value) || "all".equals(value) ? value : "all";
    }
}
