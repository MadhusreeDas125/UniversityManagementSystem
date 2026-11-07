package com.university.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.university.dao.DatabaseConnection;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            if ("add_routine".equals(action)) {
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO routine (dept_id, semester, day_of_week, time_slot, subject, faculty_name) VALUES (?, ?, ?, ?, ?, ?)");
                pst.setInt(1, Integer.parseInt(request.getParameter("dept_id")));
                pst.setString(2, request.getParameter("semester"));
                pst.setString(3, request.getParameter("day"));
                pst.setString(4, request.getParameter("time"));
                pst.setString(5, request.getParameter("subject"));
                pst.setString(6, request.getParameter("faculty"));
                pst.executeUpdate();
            } else if ("add_syllabus".equals(action)) {
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO syllabus (dept_id, semester, subject_name, syllabus_details) VALUES (?, ?, ?, ?)");
                pst.setInt(1, Integer.parseInt(request.getParameter("dept_id")));
                pst.setString(2, request.getParameter("semester"));
                pst.setString(3, request.getParameter("subject_name"));
                pst.setString(4, request.getParameter("syllabus_details"));
                pst.executeUpdate();
            } else if ("post_notification".equals(action)) {
                PreparedStatement pst = conn.prepareStatement("INSERT INTO notifications (title, message) VALUES (?, ?)");
                pst.setString(1, request.getParameter("title"));
                pst.setString(2, request.getParameter("message"));
                pst.executeUpdate();
            }
            response.sendRedirect("admin_dashboard.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
