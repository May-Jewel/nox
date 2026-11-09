package nox.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import nox.config.DBConnection;
import nox.model.User;

/**
 * UserDAO - Data Access Object for handling Database operations on User table.
 */
@Repository
public class UserDAO {

    /**
     * Registers a new user into MySQL database.
     * @param user User object containing full name, email, and password
     * @return boolean true if inserted successfully, false otherwise
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (fullname, email, password) VALUES (?, ?, ?)";
        boolean isSuccess = false;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getFullname());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                isSuccess = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception ignored) {}
        }

        return isSuccess;
    }

    /**
     * Authenticates user by email and password.
     * @param email User's email
     * @param password User's password
     * @return User object if authentication succeeds, null if authentication fails
     */
    public User loginUser(String email, String password) {
        String sql = "SELECT id, fullname, email, password FROM users WHERE email = ? AND password = ?";
        User user = null;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return null;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setFullname(rs.getString("fullname"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception ignored) {}
        }

        return user;
    }

    /**
     * Checks whether an email already exists in the database.
     * @param email Email to check
     * @return boolean true if exists
     */
    public boolean isEmailRegistered(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        boolean exists = false;

        Connection conn = DBConnection.getConnection();
        if (conn == null) return false;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    exists = true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { conn.close(); } catch (Exception ignored) {}
        }

        return exists;
    }
}
