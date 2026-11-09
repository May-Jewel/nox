package nox.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import nox.config.DBConnection;
import nox.model.User;

@RestController
@RequestMapping({"/api/user-defaults", "/user-defaults"})
public class UserDefaultsController {

    private static final String DEFAULT_OFFSET_TYPE = "1_DAY_BEFORE";
    private static final long DEFAULT_DEADLINE_MINUTES = 1440;

    private final ObjectMapper mapper = new ObjectMapper();

    @GetMapping
    public Map<String, Object> getDefaults(HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        Connection con = DBConnection.getConnection();
        if (con == null) {
            result.put("success", false);
            result.put("message", "Database connection unavailable.");
            return result;
        }

        try (PreparedStatement ps = con.prepareStatement(
                     "SELECT default_offset_type, default_offset_minutes, default_deadline_minutes "
                   + "FROM user_settings WHERE user_id = ?")) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                result.put("success", true);
                if (rs.next()) {
                    String ot = rs.getString("default_offset_type");
                    result.put("offsetType", (ot != null && !ot.trim().isEmpty()) ? ot : DEFAULT_OFFSET_TYPE);
                    Object om = rs.getObject("default_offset_minutes");
                    result.put("offsetMinutes", om != null ? rs.getLong("default_offset_minutes") : null);
                    long dm = rs.getLong("default_deadline_minutes");
                    result.put("deadlineMinutes", dm > 0 ? dm : DEFAULT_DEADLINE_MINUTES);
                } else {
                    result.put("offsetType", DEFAULT_OFFSET_TYPE);
                    result.put("offsetMinutes", null);
                    result.put("deadlineMinutes", DEFAULT_DEADLINE_MINUTES);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Failed to load defaults.");
        } finally {
            try { con.close(); } catch (Exception ignored) {}
        }

        return result;
    }

    @PutMapping
    public Map<String, Object> updateDefaults(@RequestBody String body, HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        try {
            JsonNode json = mapper.readTree(body);
            String offsetType = json.hasNonNull("offsetType")
                    ? json.get("offsetType").asText().trim().toUpperCase()
                    : DEFAULT_OFFSET_TYPE;
            Long offsetMinutes = json.hasNonNull("offsetMinutes")
                    ? json.get("offsetMinutes").asLong()
                    : null;
            long deadlineMinutes = json.hasNonNull("deadlineMinutes")
                    ? json.get("deadlineMinutes").asLong()
                    : DEFAULT_DEADLINE_MINUTES;
            if (deadlineMinutes < 1) deadlineMinutes = DEFAULT_DEADLINE_MINUTES;

            String sql = "INSERT INTO user_settings "
                       + "(user_id, default_offset_type, default_offset_minutes, default_deadline_minutes) "
                       + "VALUES (?, ?, ?, ?) "
                       + "ON DUPLICATE KEY UPDATE "
                       + "  default_offset_type       = VALUES(default_offset_type), "
                       + "  default_offset_minutes    = VALUES(default_offset_minutes), "
                       + "  default_deadline_minutes  = VALUES(default_deadline_minutes), "
                       + "  updated_at                = NOW()";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, offsetType);
                if (offsetMinutes != null) {
                    ps.setLong(3, offsetMinutes);
                } else {
                    ps.setNull(3, java.sql.Types.BIGINT);
                }
                ps.setLong(4, deadlineMinutes);
                ps.executeUpdate();
            }

            result.put("success", true);
            result.put("offsetType", offsetType);
            result.put("offsetMinutes", offsetMinutes);
            result.put("deadlineMinutes", deadlineMinutes);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage() != null ? e.getMessage() : "Unknown error");
        }

        return result;
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

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT id FROM users WHERE email = ? LIMIT 1")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    session.setAttribute("userId", id);
                    return id;
                }
            }
        } catch (Exception e) {
            System.err.println("UserDefaultsController user lookup failed: " + e.getMessage());
        }
        return null;
    }
}
