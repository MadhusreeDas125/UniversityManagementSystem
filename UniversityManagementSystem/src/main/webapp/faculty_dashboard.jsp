<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.university.dao.DatabaseConnection" %>
<%
    if (session == null || !"FACULTY".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    String facultyName = (String) session.getAttribute("username");
    int facultyId = (Integer) session.getAttribute("user_id");
    int deptId = (Integer) session.getAttribute("dept_id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Faculty Portal - University Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>Faculty Portal</h1>
        <a href="index.jsp" class="btn logout-btn">Logout</a>
    </header>
    <div class="container">
        <h2>Welcome, Prof. <%= facultyName %> (ID: FAC-<%= facultyId %>)</h2>

        <h3>Daily Routine (Assigned by Admin)</h3>
        <table>
            <tr><th>Day</th><th>Time Slot</th><th>Subject</th><th>Semester</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    PreparedStatement pst = conn.prepareStatement("SELECT * FROM routine WHERE dept_id=? AND faculty_name=?");
                    pst.setInt(1, deptId);
                    pst.setString(2, facultyName);
                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("day_of_week") %></td>
                <td><%= rs.getString("time_slot") %></td>
                <td><%= rs.getString("subject") %></td>
                <td><%= rs.getString("semester") %></td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='4'>No routine assigned under your name.</td></tr>"); }
            %>
        </table>

        <h3>Attendance Marking System</h3>
        <form action="FacultyServlet" method="post">
            <input type="hidden" name="action" value="mark_attendance">
            <div class="form-group">
                <label>Student ID:</label>
                <input type="number" name="student_id" required>
            </div>
            <div class="form-group">
                <label>Subject Name:</label>
                <input type="text" name="subject" required>
            </div>
            <div class="form-group">
                <label>Classes Attended:</label>
                <input type="number" name="attended" required>
            </div>
            <div class="form-group">
                <label>Total Classes:</label>
                <input type="number" name="total" required>
            </div>
            <button type="submit">Save Attendance Record</button>
        </form>

        <h3>Grading System (SGPA / CGPA Entry)</h3>
        <form action="FacultyServlet" method="post">
            <input type="hidden" name="action" value="upload_grades">
            <div class="form-group">
                <label>Student ID:</label>
                <input type="number" name="student_id" required>
            </div>
            <div class="form-group">
                <label>Semester:</label>
                <input type="text" name="semester" placeholder="Sem 3" required>
            </div>
            <div class="form-group">
                <label>SGPA:</label>
                <input type="number" step="0.01" name="sgpa" required>
            </div>
            <div class="form-group">
                <label>CGPA:</label>
                <input type="number" step="0.01" name="cgpa" required>
            </div>
            <button type="submit">Submit Grades</button>
        </form>

        <h3>Notification Making System for Students</h3>
        <form action="FacultyServlet" method="post">
            <input type="hidden" name="action" value="post_notification">
            <div class="form-group">
                <label>Notice Title:</label>
                <input type="text" name="title" required>
            </div>
            <div class="form-group">
                <label>Notice Message:</label>
                <textarea name="message" rows="3" required></textarea>
            </div>
            <button type="submit">Broadcast Notification</button>
        </form>
    </div>
</body>
</html>