package nox.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // URL to your database created in Workbench
    private static final String URL = System.getenv().getOrDefault("NOX_DB_URL", "jdbc:mysql://localhost:3306/notesassistant?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
    private static final String USER = System.getenv("NOX_DB_USER");
    private static final String PASS = System.getenv("NOX_DB_PASSWORD");

    static {
        try {
            // Explicitly load the MySQL JDBC driver for Tomcat 11
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found in WEB-INF/lib!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.err.println("Database Connection Failed! Check Workbench status or credentials.");
            e.printStackTrace();
        }
        return conn;
    }
}
