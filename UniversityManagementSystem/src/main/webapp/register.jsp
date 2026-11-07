<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>New Registration - University Portal</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>University Management System Portal</h1>
    </header>
    <div class="container" style="max-width: 480px;">
        <h2>New User Registration Form</h2>
        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label>Register For Portal:</label>
                <select name="role" required>
                    <option value="STUDENT">Student</option>
                    <option value="FACULTY">Faculty</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            <div class="form-group">
                <label>Full Name:</label>
                <input type="text" name="name" required>
            </div>
            <div class="form-group">
                <label>Email ID:</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Department:</label>
                <select name="dept_id" required>
                    <option value="1">CSE</option>
                    <option value="2">ECE</option>
                    <option value="3">ME</option>
                    <option value="4">Business Administration</option>
                    <option value="5">Law</option>
                </select>
            </div>
            <button type="submit" style="width: 100%;">Save & Register</button>
        </form>
        <p style="margin-top: 15px; text-align: center;">
            <a href="index.jsp" style="color: #1e3a8a;">Already registered? Login here</a>
        </p>
    </div>
</body>
</html>