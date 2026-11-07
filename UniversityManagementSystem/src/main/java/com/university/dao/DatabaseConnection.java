package com.university.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/university_db?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root"; // Change to your MySQL username
    private static final String PASS = "56c63e@payra"; // Change to your MySQL password

    public static Connection initializeDatabase() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
