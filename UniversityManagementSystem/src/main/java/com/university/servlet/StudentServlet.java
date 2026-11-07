package com.university.servlet;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.university.dao.DatabaseConnection;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("user_id");

        if (studentId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.initializeDatabase()) {
            if ("pay_fee".equals(action)) {
                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO fees (student_id, semester, amount, payment_method, status) VALUES (?, ?, ?, ?, 'Paid')");
                pst.setInt(1, studentId);
                pst.setString(2, request.getParameter("semester"));
                pst.setDouble(3, Double.parseDouble(request.getParameter("amount")));
                pst.setString(4, request.getParameter("payment_method"));
                pst.executeUpdate();
            }
            response.sendRedirect("student_dashboard.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
