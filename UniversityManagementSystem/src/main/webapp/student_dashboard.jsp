<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.university.dao.DatabaseConnection" %>
<%
    if (session == null || !"STUDENT".equals(session.getAttribute("role"))) {
        response.sendRedirect("index.jsp");
        return;
    }
    String studentName = (String) session.getAttribute("username");
    String enrollNo = (String) session.getAttribute("enrollment_no");
    int studentId = (Integer) session.getAttribute("user_id");
    int deptId = (Integer) session.getAttribute("dept_id");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Portal - University Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>Student Portal</h1>
        <a href="index.jsp" class="btn logout-btn">Logout</a>
    </header>
    <div class="container">
        <h2>Welcome, <%= studentName %></h2>
        <p><strong>Enrollment Number:</strong> <%= enrollNo %></p>

        <h3>Attendance Overview</h3>
        <table>
            <tr><th>Subject</th><th>Attended / Total Classes</th><th>Percentage</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    PreparedStatement pst = conn.prepareStatement("SELECT * FROM attendance WHERE student_id=?");
                    pst.setInt(1, studentId);
                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
                        int att = rs.getInt("attended_classes");
                        int tot = rs.getInt("total_classes");
                        double pct = tot > 0 ? ((double)att / tot) * 100 : 0.0;
            %>
            <tr>
                <td><%= rs.getString("subject") %></td>
                <td><%= att %> / <%= tot %></td>
                <td><%= String.format("%.2f", pct) %>%</td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='3'>No attendance recorded yet.</td></tr>"); }
            %>
        </table>

        <h3>Semester Grade Graph / Table (SGPA / CGPA)</h3>
        <table>
            <tr><th>Semester</th><th>SGPA</th><th>CGPA</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    PreparedStatement pst = conn.prepareStatement("SELECT * FROM grades WHERE student_id=?");
                    pst.setInt(1, studentId);
                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("semester") %></td>
                <td><%= rs.getDouble("sgpa") %></td>
                <td><%= rs.getDouble("cgpa") %></td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='3'>No grades published yet.</td></tr>"); }
            %>
        </table>

        <h3>Daily Class Routine (Course-wise)</h3>
        <table>
            <tr><th>Day</th><th>Time Slot</th><th>Subject</th><th>Faculty</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    PreparedStatement pst = conn.prepareStatement("SELECT * FROM routine WHERE dept_id=?");
                    pst.setInt(1, deptId);
                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("day_of_week") %></td>
                <td><%= rs.getString("time_slot") %></td>
                <td><%= rs.getString("subject") %></td>
                <td><%= rs.getString("faculty_name") %></td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='4'>Routine not available.</td></tr>"); }
            %>
        </table>

        <h3>Side Desk: Course Syllabus (Semester-wise)</h3>
        <table>
            <tr><th>Semester</th><th>Subject</th><th>Syllabus Details</th></tr>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    PreparedStatement pst = conn.prepareStatement("SELECT * FROM syllabus WHERE dept_id=?");
                    pst.setInt(1, deptId);
                    ResultSet rs = pst.executeQuery();
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("semester") %></td>
                <td><%= rs.getString("subject_name") %></td>
                <td><%= rs.getString("syllabus_details") %></td>
            </tr>
            <%      }
                } catch(Exception e) { out.println("<tr><td colspan='3'>Syllabus not uploaded.</td></tr>"); }
            %>
        </table>

        <h3>Side Desk: Tuition Fee Payment Method</h3>
        <form action="StudentServlet" method="post" style="background:#f8fafc; padding:15px; border:1px solid #cbd5e1; border-radius:4px;">
            <input type="hidden" name="action" value="pay_fee">
            <div class="form-group">
                <label>Select Semester:</label>
                <input type="text" name="semester" placeholder="e.g., Sem 4" required>
            </div>
            <div class="form-group">
                <label>Amount (USD/INR):</label>
                <input type="number" step="0.01" name="amount" required>
            </div>
            <div class="form-group">
                <label>Payment Method:</label>
                <select name="payment_method">
                    <option value="Net Banking">Net Banking</option>
                    <option value="Credit/Debit Card">Credit / Debit Card</option>
                    <option value="UPI / QR">UPI / QR Code</option>
                </select>
            </div>
            <button type="submit">Submit Fee Payment</button>
        </form>

        <h3>Notification Box</h3>
        <ul>
            <%
                try (Connection conn = DatabaseConnection.initializeDatabase()) {
                    Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM notifications ORDER BY date_posted DESC LIMIT 5");
                    while(rs.next()) {
            %>
            <li><strong><%= rs.getString("title") %></strong>: <%= rs.getString("message") %> <em>(<%= rs.getTimestamp("date_posted") %>)</em></li>
            <%      }
                } catch(Exception e) { out.println("<li>No notifications available.</li>"); }
            %>
        </ul>
    </div>
</body>
</html>