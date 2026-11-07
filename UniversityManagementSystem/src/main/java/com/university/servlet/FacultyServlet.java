package com.university.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.university.dao.DatabaseConnection;

@WebServlet("/FacultyServlet")
public class FacultyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            if ("mark_attendance".equals(action)) {
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO attendance (student_id, subject, attended_classes, total_classes) VALUES (?, ?, ?, ?)");
                pst.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                pst.setString(2, request.getParameter("subject"));
                pst.setInt(3, Integer.parseInt(request.getParameter("attended")));
                pst.setInt(4, Integer.parseInt(request.getParameter("total")));
                pst.executeUpdate();
            } else if ("upload_grades".equals(action)) {
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO grades (student_id, semester, sgpa, cgpa) VALUES (?, ?, ?, ?)");
                pst.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                pst.setString(2, request.getParameter("semester"));
                pst.setDouble(3, Double.parseDouble(request.getParameter("sgpa")));
                pst.setDouble(4, Double.parseDouble(request.getParameter("cgpa")));
                pst.executeUpdate();
            } else if ("post_notification".equals(action)) {
                PreparedStatement pst = conn.prepareStatement("INSERT INTO notifications (title, message) VALUES (?, ?)");
                pst.setString(1, request.getParameter("title"));
                pst.setString(2, request.getParameter("message"));
                pst.executeUpdate();
            }
            response.sendRedirect("faculty_dashboard.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}