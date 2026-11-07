<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.university.dao.DatabaseConnection" %>
<%
    if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Portal - University Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>Admin Portal (Control Center)</h1>
        <a href="index.jsp" class="btn logout-btn">Logout</a>
    </header>
    <div class="container">
        <h2>Welcome, Admin <%= adminName %></h2>
        <p><strong>Managed Departments:</strong> (1) CSE, (2) ECE, (3) ME, (4) Business Administration, (5) Law</p>

        <h3>1. Allot & Schedule Daily Routine</h3>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="add_routine">
            <div class="form-group">
                <label>Department:</label>
                <select name="dept_id">
                    <option value="1">CSE</option>
                    <option value="2">ECE</option>
                    <option value="3">ME</option>
                    <option value="4">Business Administration</option>
                    <option value="5">Law</option>
                </select>
            </div>
            <div class="form-group">
                <label>Semester:</label>
                <input type="text" name="semester" placeholder="Sem 2" required>
            </div>
            <div class="form-group">
                <label>Day of Week:</label>
                <input type="text" name="day" placeholder="Monday" required>
            </div>
            <div class="form-group">
                <label>Time Slot:</label>
                <input type="text" name="time" placeholder="10:00 AM - 11:00 AM" required>
            </div>
            <div class="form-group">
                <label>Subject Name:</label>
                <input type="text" name="subject" required>
            </div>
            <div class="form-group">
                <label>Faculty Assigned Name:</label>
                <input type="text" name="faculty" required>
            </div>
            <button type="submit">Publish Routine</button>
        </form>

        <h3>2. Allot Faculty Syllabus (Semester-wise)</h3>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="add_syllabus">
            <div class="form-group">
                <label>Department:</label>
                <select name="dept_id">
                    <option value="1">CSE</option>
                    <option value="2">ECE</option>
                    <option value="3">ME</option>
                    <option value="4">Business Administration</option>
                    <option value="5">Law</option>
                </select>
            </div>
            <div class="form-group">
                <label>Semester:</label>
                <input type="text" name="semester" placeholder="Sem 2" required>
            </div>
            <div class="form-group">
                <label>Subject Name:</label>
                <input type="text" name="subject_name" required>
            </div>
            <div class="form-group">
                <label>Syllabus Outline:</label>
                <textarea name="syllabus_details" rows="3" required></textarea>
            </div>
            <button type="submit">Upload Syllabus</button>
        </form>

        <h3>3. Broadcast Global Notification</h3>
        <form action="AdminServlet" method="post">
            <input type="hidden" name="action" value="post_notification">
            <div class="form-group">
                <label>Title:</label>
                <input type="text" name="title" required>
            </div>
            <div class="form-group">
                <label>Message:</label>
                <textarea name="message" rows="3" required></textarea>
            </div>
            <button type="submit">Send Notification</button>
        </form>

        <h3>System Users Directory (Linked with Faculty & Students)</h3>
        <table>
            <tr><th>User ID</th><th>Name</th><th>Role</th><th>Enrollment / ID</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM users");
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getString("role") %></td>
                <td><%= rs.getString("enrollment_no") %></td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='4'>Error loading users</td></tr>"); }
            %>
        </table>
    </div>
</body>
</html>