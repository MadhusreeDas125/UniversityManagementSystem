package com.university.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.university.dao.DatabaseConnection;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        int deptId = Integer.parseInt(request.getParameter("dept_id"));

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            // Serial-wise registration ID creation
            String enrollNo = role.substring(0, 3).toUpperCase() + "-" + (System.currentTimeMillis() % 100000);

            PreparedStatement pst = conn.prepareStatement(
                "INSERT INTO users (name, email, password, role, dept_id, enrollment_no) VALUES (?, ?, ?, ?, ?, ?)");
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, password);
            pst.setString(4, role);
            pst.setInt(5, deptId);
            pst.setString(6, enrollNo);
            
            pst.executeUpdate();
            response.sendRedirect("index.jsp?registration=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Registration Error: " + e.getMessage());
        }
    }
}
