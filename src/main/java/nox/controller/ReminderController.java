package nox.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import nox.config.DBConnection;
import nox.model.User;

@RestController
@RequestMapping({"/api/reminder", "/reminder"})
public class ReminderController {

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final ObjectMapper mapper = new ObjectMapper();

    @PostMapping
    public Map<String, Object> createReminder(@RequestBody String body, HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        try {
            Payload p = parsePayload(body);

            int reminderId = -1;
            try (Connection con = DBConnection.getConnection()) {
                if (p.todoId != null) {
                    validateTodo(con, p.todoId, userId);
                }

                String sql = "INSERT INTO reminders "
                           + "(user_id, todo_id, reminder_text, due_date, reminder_time, "
                           + " fcm_token, offset_type, custom_offset_minutes) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    if (p.todoId != null) {
                        ps.setInt(2, p.todoId);
                    } else {
                        ps.setNull(2, java.sql.Types.INTEGER);
                    }
                    ps.setString(3, p.text);
                    ps.setString(4, p.dueDate != null ? p.dueDate.format(FORMATTER) : null);
                    ps.setString(5, p.reminderTime.format(FORMATTER));
                    ps.setString(6, p.token);
                    ps.setString(7, p.offsetType);
                    if (p.customOffsetMinutes != null) {
                        ps.setLong(8, p.customOffsetMinutes);
                    } else {
                        ps.setNull(8, java.sql.Types.BIGINT);
                    }
                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) reminderId = keys.getInt(1);
                    }
                }
            }

            result.put("success", true);
            result.put("message", "Reminder saved successfully");
            result.put("id", reminderId > 0 ? reminderId : null);
            result.put("todoId", p.todoId);
            result.put("reminderTime", p.reminderTime.format(FORMATTER));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage() != null ? e.getMessage() : "Unknown error");
        }

        return result;
    }

    @PutMapping
    public Map<String, Object> updateReminder(@RequestBody String body, HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        try {
            Payload p = parsePayload(body);
            if (p.id <= 0) throw new IllegalArgumentException("Reminder id is required.");

            int updated;
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                         "UPDATE reminders SET reminder_text = ?, due_date = ?, reminder_time = ?, "
                       + " offset_type = ?, custom_offset_minutes = ?, fcm_token = ? "
                       + "WHERE id = ? AND user_id = ?")) {
                ps.setString(1, p.text);
                ps.setString(2, p.dueDate != null ? p.dueDate.format(FORMATTER) : null);
                ps.setString(3, p.reminderTime.format(FORMATTER));
                ps.setString(4, p.offsetType);
                if (p.customOffsetMinutes != null) {
                    ps.setLong(5, p.customOffsetMinutes);
                } else {
                    ps.setNull(5, java.sql.Types.BIGINT);
                }
                ps.setString(6, p.token);
                ps.setInt(7, p.id);
                ps.setInt(8, userId);
                updated = ps.executeUpdate();
            }

            if (updated == 0) {
                result.put("success", false);
                result.put("message", "Reminder not found.");
                return result;
            }

            result.put("success", true);
            result.put("message", "Reminder updated successfully");
            result.put("id", p.id);
            result.put("reminderTime", p.reminderTime.format(FORMATTER));

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", e.getMessage() != null ? e.getMessage() : "Unknown error");
        }

        return result;
    }

    @GetMapping
    public Map<String, Object> listReminders(
            @RequestParam(value = "todoId", required = false) Integer filterTodoId,
            HttpSession session) {

        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        try (Connection con = DBConnection.getConnection()) {
            purgeExpired(con, userId);
        } catch (Exception e) {
            System.err.println("ReminderController failed to purge expired reminders: " + e.getMessage());
        }

        String sql = "SELECT r.id, r.todo_id, r.reminder_text, r.due_date, r.reminder_time, "
                   + "r.offset_type, r.custom_offset_minutes, r.sent, r.created_at "
                   + "FROM reminders r WHERE r.user_id = ?"
                   + (filterTodoId != null ? " AND r.todo_id = ?" : "")
                   + " ORDER BY r.reminder_time ASC, r.id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            if (filterTodoId != null) ps.setInt(2, filterTodoId);

            List<Object> items = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("id", rs.getInt("id"));
                    item.put("todoId", rs.getObject("todo_id") != null ? rs.getInt("todo_id") : null);
                    item.put("reminderText", rs.getString("reminder_text"));
                    item.put("dueDate", rs.getString("due_date"));
                    item.put("reminderTime", rs.getString("reminder_time"));
                    item.put("offsetType", rs.getString("offset_type"));
                    item.put("customOffsetMinutes",
                            rs.getObject("custom_offset_minutes") != null ? rs.getLong("custom_offset_minutes") : null);
                    item.put("sent", rs.getBoolean("sent"));
                    item.put("createdAt", rs.getString("created_at"));
                    items.add(item);
                }
            }

            result.put("success", true);
            result.put("items", items);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Failed to load reminders.");
        }

        return result;
    }

    @DeleteMapping
    public Map<String, Object> deleteReminder(@RequestParam(value = "id", required = false) String idParam,
                                              HttpSession session) {
        Map<String, Object> result = new LinkedHashMap<>();

        Integer userId = resolveUserId(session);
        if (userId == null) {
            result.put("success", false);
            result.put("message", "Not logged in.");
            return result;
        }

        if (idParam == null || idParam.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Reminder id is required.");
            return result;
        }

        try {
            int id = Integer.parseInt(idParam.trim());

            int deleted;
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                         "DELETE FROM reminders WHERE id = ? AND user_id = ?")) {
                ps.setInt(1, id);
                ps.setInt(2, userId);
                deleted = ps.executeUpdate();
            }

            if (deleted == 0) {
                result.put("success", false);
                result.put("message", "Reminder not found.");
                return result;
            }

            result.put("success", true);
            result.put("deleted", deleted);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Failed to delete reminder.");
        }

        return result;
    }

    private Payload parsePayload(String body) throws IOException {
        JsonNode json = mapper.readTree(body);

        Payload p = new Payload();
        p.id = json.hasNonNull("id") && json.get("id").canConvertToInt() ? json.get("id").asInt() : -1;
        p.text = json.hasNonNull("text") ? json.get("text").asText().trim() : "";
        if (p.text.isEmpty()) throw new IllegalArgumentException("Reminder text is required.");
        p.token = json.hasNonNull("token") ? json.get("token").asText() : "";
        String ot = json.hasNonNull("offsetType") ? json.get("offsetType").asText().trim().toUpperCase() : "EXACT";
        p.offsetType = ot.isEmpty() ? "EXACT" : ot;
        p.todoId = json.hasNonNull("todoId") && json.get("todoId").canConvertToInt()
                ? json.get("todoId").asInt() : null;
        p.customOffsetMinutes = json.hasNonNull("customOffsetMinutes")
                ? json.get("customOffsetMinutes").asLong() : null;

        String dueDateStr = json.hasNonNull("dueDate") ? json.get("dueDate").asText() : null;
        p.dueDate = parseDateTime(dueDateStr);

        p.reminderTime = computeReminderTime(json, p.dueDate, p.offsetType, p.customOffsetMinutes);
        if (!"CUSTOM".equals(p.offsetType)) p.customOffsetMinutes = null;

        return p;
    }

    private LocalDateTime computeReminderTime(JsonNode json, LocalDateTime dueDate,
                                              String offsetType, Long customOffsetMinutes) {
        switch (offsetType) {
            case "10_MIN_BEFORE":
                requireDueDate(dueDate, offsetType);
                return dueDate.minusMinutes(10);
            case "1_HOUR_BEFORE":
                requireDueDate(dueDate, offsetType);
                return dueDate.minusHours(1);
            case "1_DAY_BEFORE":
                requireDueDate(dueDate, offsetType);
                return dueDate.minusDays(1);
            case "CUSTOM":
                requireDueDate(dueDate, offsetType);
                if (customOffsetMinutes == null) {
                    throw new IllegalArgumentException("customOffsetMinutes is required for CUSTOM.");
                }
                return dueDate.minusMinutes(customOffsetMinutes);
            case "EXACT":
            default:
                if (dueDate != null) return dueDate;
                if (json.hasNonNull("reminderTime")) {
                    return parseDateTime(json.get("reminderTime").asText());
                }
                throw new IllegalArgumentException("Either dueDate or reminderTime must be provided.");
        }
    }

    private LocalDateTime parseDateTime(String text) {
        if (text == null || text.trim().isEmpty()) return null;
        String s = text.trim().replace("T", " ");
        if (s.length() == 16) {
            s = s + ":00";
        }
        return LocalDateTime.parse(s, FORMATTER);
    }

    private void purgeExpired(Connection con, int userId) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(
                "DELETE FROM reminders WHERE user_id = ? AND reminder_time <= NOW()")) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    private void requireDueDate(LocalDateTime dueDate, String offsetType) {
        if (dueDate == null) {
            throw new IllegalArgumentException("dueDate is required for offset " + offsetType);
        }
    }

    private void validateTodo(Connection con, int todoId, int userId) throws Exception {
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT id FROM todo_list WHERE id = ? AND user_id = ?")) {
            ps.setInt(1, todoId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new IllegalArgumentException("Todo list item not found.");
                }
            }
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
            System.err.println("ReminderController user lookup failed: " + e.getMessage());
        }
        return null;
    }

    private static class Payload {
        int id = -1;
        String text;
        String token;
        String offsetType;
        Integer todoId;
        Long customOffsetMinutes;
        LocalDateTime dueDate;
        LocalDateTime reminderTime;
    }
}
