package com.university.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.university.dao.DatabaseConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            PreparedStatement pst = conn.prepareStatement("SELECT * FROM users WHERE name=? AND password=? AND role=?");
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, role);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user_id", rs.getInt("user_id"));
                session.setAttribute("username", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));
                session.setAttribute("dept_id", rs.getInt("dept_id"));
                session.setAttribute("enrollment_no", rs.getString("enrollment_no"));

                if ("STUDENT".equals(role)) {
                    response.sendRedirect("student_dashboard.jsp");
                } else if ("FACULTY".equals(role)) {
                    response.sendRedirect("faculty_dashboard.jsp");
                } else if ("ADMIN".equals(role)) {
                    response.sendRedirect("admin_dashboard.jsp");
                }
            } else {
                response.sendRedirect("index.jsp?error=InvalidCredentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}