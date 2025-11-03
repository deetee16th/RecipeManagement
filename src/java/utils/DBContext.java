/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    
    // Cấu hình kết nối database - Thay đổi theo môi trường của bạn
    private static final String SERVER_NAME = "localhost";
    private static final String PORT = "1433";
    private static final String DATABASE_NAME = "RecipeDB";
    private static final String USER_ID = "sa"; // Thay đổi username của bạn
    private static final String PASSWORD = "sa"; // Thay đổi password của bạn
    
    // Connection string
    private static final String URL = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT 
            + ";databaseName=" + DATABASE_NAME + ";encrypt=false";
    
    /**
     * Tạo kết nối đến SQL Server database
     * @return Connection object
     * @throws SQLException, ClassNotFoundException
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            // Load SQL Server JDBC Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            
            // Tạo connection
            Connection conn = DriverManager.getConnection(URL, USER_ID, PASSWORD);
            
            if (conn != null) {
                System.out.println("Database connected successfully!");
                System.out.println("Database: " + DATABASE_NAME);
                System.out.println("Server: " + SERVER_NAME + ":" + PORT);
            }
            
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("ERROR: SQL Server JDBC Driver not found!");
            throw e;
        } catch (SQLException e) {
            System.err.println("ERROR: Cannot connect to database - " + e.getMessage());
            System.err.println("URL: " + URL);
            throw e;
        }
    }
    
    /**
     * Test connection
     */
    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Kết nối database thành công!");
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Lỗi: " + e.getMessage());
        }
    }
}
