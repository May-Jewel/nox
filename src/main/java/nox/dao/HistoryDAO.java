package nox.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import nox.config.DBConnection;
import nox.model.HistoryItem;
import nox.service.ActivityLogger;

@Repository
public class HistoryDAO {

    /**
     * Log any user activity into history
     *
     * @param featureType frontend key ("transcribe", "translate", "summary", "todo", "qna")
     *                    -> normalized to uppercase ENUM value before insert
     */
    public boolean logActivity(int userId, String featureType, String title, String inputText, String outputText, String metadataJson) {
        String sql = "INSERT INTO activity_history (user_id, feature_type, title, input_text, output_text, metadata) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setString(2, ActivityLogger.normalizeFeature(featureType));
            pstmt.setString(3, title != null ? title : "Untitled Activity");
            pstmt.setString(4, inputText);
            pstmt.setString(5, outputText);
            pstmt.setString(6, metadataJson != null ? metadataJson : "{}");

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Fetch history filtered by feature type and time range
     * @param filterRange Options: "today", "7days", "30days", "all"
     * @param featureType Options: "ALL", "TRANSCRIBE", "TRANSLATE", "SUMMARY", "TODO", "QNA"
     */
    public List<HistoryItem> getUserHistory(int userId, String featureType, String filterRange) {
        List<HistoryItem> historyList = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT id, feature_type, title, input_text, output_text, metadata, created_at "
                                            + "FROM activity_history WHERE user_id = ? ");

        // 1. Feature Filter
        if (featureType != null && !featureType.equalsIgnoreCase("ALL")) {
            sql.append("AND feature_type = ? ");
        }

        // 2. Time-Based Filter
        if ("today".equalsIgnoreCase(filterRange)) {
            sql.append("AND created_at >= CURDATE() ");
        } else if ("7days".equalsIgnoreCase(filterRange)) {
            sql.append("AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) ");
        } else if ("30days".equalsIgnoreCase(filterRange)) {
            sql.append("AND created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) ");
        }

        sql.append("ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            pstmt.setInt(paramIndex++, userId);

            if (featureType != null && !featureType.equalsIgnoreCase("ALL")) {
                pstmt.setString(paramIndex++, featureType.toUpperCase());
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    HistoryItem item = new HistoryItem();
                    item.setId(rs.getInt("id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setFeatureType(rs.getString("feature_type"));
                    item.setTitle(rs.getString("title"));
                    item.setInputText(rs.getString("input_text"));
                    item.setOutputText(rs.getString("output_text"));
                    item.setMetadata(rs.getString("metadata"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    historyList.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return historyList;
    }
}
