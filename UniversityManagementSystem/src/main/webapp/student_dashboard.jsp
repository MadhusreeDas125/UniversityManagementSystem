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
    java.util.List<String[]> attendanceRows = new java.util.ArrayList<>();
    java.util.List<String[]> gradeRows = new java.util.ArrayList<>();
    long attendedSum=0, totalSum=0;
    try (Connection c=DatabaseConnection.initializeDatabase(); PreparedStatement ps=c.prepareStatement("SELECT * FROM attendance WHERE student_id=?")) {
        ps.setInt(1,studentId);
        try(ResultSet r=ps.executeQuery()){while(r.next()){
            int a=r.getInt("attended_classes"), t=r.getInt("total_classes");
            attendedSum+=a; totalSum+=t;
            attendanceRows.add(new String[]{r.getString("subject"),a+" / "+t,String.format(java.util.Locale.US,"%.1f%%",t>0?100.0*a/t:0)});
        }}
    } catch(Exception ignored){}
    try (Connection c=DatabaseConnection.initializeDatabase(); PreparedStatement ps=c.prepareStatement("SELECT * FROM grades WHERE student_id=? ORDER BY semester")) {
        ps.setInt(1,studentId);
        try(ResultSet r=ps.executeQuery()){while(r.next()){
            gradeRows.add(new String[]{r.getString("semester"),String.valueOf(r.getDouble("sgpa")),String.valueOf(r.getDouble("cgpa"))});
        }}
    } catch(Exception ignored){}
    double attendancePct=totalSum>0?100.0*attendedSum/totalSum:0;
    double latestCgpa=gradeRows.isEmpty()?0:Double.parseDouble(gradeRows.get(gradeRows.size()-1)[2]);
    StringBuilder points=new StringBuilder();
    for(int i=0;i<gradeRows.size();i++){
        double cg=Double.parseDouble(gradeRows.get(i)[2]);
        double x=gradeRows.size()==1?450:65.0+i*770/(gradeRows.size()-1);
        double y=225-Math.max(0,Math.min(10,cg))*18;
        if(i>0)points.append(" ");
        points.append(String.format(java.util.Locale.US,"%.1f,%.1f",x,y));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Portal - University Management System</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body class="student-page">
    <header class="portal-header"><div class="header-inner">
        <div class="brand"><span class="brand-icon">U</span><div><strong>University Management System</strong><small>University Management System</small></div></div>
        <div class="header-right"><span class="role-pill">Student Portal</span><a href="index.jsp" class="btn logout-btn">Sign out</a></div>
    </div></header>
    <main class="container student-container">
        <section class="welcome-panel"><div><span class="eyebrow">STUDENT DASHBOARD</span><h1>Welcome back, <%= studentName %></h1><p>Here's your academic overview at a glance.</p></div><div class="enrollment-chip"><small>ENROLLMENT NUMBER</small><strong><%= enrollNo %></strong></div></section>
        <div class="stats-grid">
            <div class="stat-card"><span>Overall attendance</span><strong><%= String.format(java.util.Locale.US,"%.1f%%",attendancePct) %></strong><small>Across all recorded subjects</small></div>
            <div class="stat-card"><span>Current CGPA</span><strong><%= gradeRows.isEmpty()?"—":String.format(java.util.Locale.US,"%.2f",latestCgpa) %></strong><small>Out of 10.00</small></div>
            <div class="stat-card"><span>Semesters recorded</span><strong><%= gradeRows.size() %></strong><small>Academic progress</small></div>
            <div class="stat-card"><span>Classes attended</span><strong><%= attendedSum %><span class="stat-total"> / <%= totalSum %></span></strong><small>Total recorded classes</small></div>
        </div>
        <div class="analytics-grid">
            <section class="dashboard-panel"><div class="section-heading"><div><span class="eyebrow">ATTENDANCE</span><h2>Attendance overview</h2></div></div>
                <div class="donut-wrap"><div class="donut" style="--pct:<%= String.format(java.util.Locale.US,"%.2f",attendancePct) %>"><div class="donut-center"><strong><%= String.format(java.util.Locale.US,"%.1f%%",attendancePct) %></strong><small>Attendance</small></div></div><div class="chart-legend"><div><i class="legend-dot present"></i> Attended <strong><%= attendedSum %></strong></div><div><i class="legend-dot absent"></i> Missed <strong><%= Math.max(0,totalSum-attendedSum) %></strong></div></div></div>
                <div class="table-scroll"><table><thead><tr><th>Subject</th><th>Attended / Total</th><th>Attendance</th></tr></thead><tbody>
                <% if(attendanceRows.isEmpty()){ %><tr><td colspan="3" class="empty-state">No attendance recorded yet.</td></tr><% }else{for(String[] row:attendanceRows){ %>
                <tr><td><%= row[0] %></td><td><%= row[1] %></td><td><span class="percent-pill"><%= row[2] %></span></td></tr>
                <% }} %></tbody></table></div>
            </section>
            <section class="dashboard-panel"><div class="section-heading"><div><span class="eyebrow">ACADEMICS</span><h2>CGPA performance</h2></div><span class="subtle-label">Semester trend</span></div>
                <% if(!gradeRows.isEmpty()){ %>
                <div class="line-chart"><svg viewBox="0 0 900 270" role="img" aria-label="CGPA progression by semester" preserveAspectRatio="xMidYMid meet">
                    <% for(int tick=0;tick<=5;tick++){int y=225-tick*36; %><line x1="55" y1="<%= y %>" x2="850" y2="<%= y %>" stroke="#e8edf5" stroke-width="1"/><text x="42" y="<%= y+4 %>" text-anchor="end" fill="#8490a5" font-size="13"><%= tick*2 %></text><% } %>
                    <polyline points="<%= points.toString() %>" fill="none" stroke="#5468e7" stroke-width="4" stroke-linejoin="round" stroke-linecap="round"/>
                    <% for(int i=0;i<gradeRows.size();i++){double x=gradeRows.size()==1?450:65.0+i*770/(gradeRows.size()-1);double y=225-Math.max(0,Math.min(10,Double.parseDouble(gradeRows.get(i)[2])))*18; %>
                    <circle cx="<%= x %>" cy="<%= y %>" r="6" fill="#5468e7" stroke="white" stroke-width="3"><title><%= gradeRows.get(i)[0] %>: <%= gradeRows.get(i)[2] %></title></circle>
                    <text x="<%= x %>" y="252" text-anchor="middle" fill="#64748b" font-size="12"><%= gradeRows.get(i)[0] %></text>
                    <% } %>
                </svg></div>
                <% }else{ %><div class="chart-empty">Your CGPA trend will appear when grades are published.</div><% } %>
                <div class="table-scroll"><table><thead><tr><th>Semester</th><th>SGPA</th><th>CGPA</th></tr></thead><tbody>
                <% if(gradeRows.isEmpty()){ %><tr><td colspan="3" class="empty-state">No grades published yet.</td></tr><% }else{for(String[] row:gradeRows){ %>
                <tr><td><%= row[0] %></td><td><%= row[1] %></td><td><strong><%= row[2] %></strong></td></tr>
                <% }} %></tbody></table></div>
            </section>
        </div>
        <div class="student-sections">
        <section class="dashboard-panel"><h2>Daily class routine</h2>
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

        </section><section class="dashboard-panel"><h2>Course syllabus</h2>
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

        </section><section class="dashboard-panel"><h2>Tuition fee payment</h2>
        <form action="StudentServlet" method="post" class="payment-form">
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

        </section><section class="dashboard-panel"><h2>Latest notifications</h2>
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
        </ul></section></div>
    </main>
</body>
</html>
