<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>University Management System - Login</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <header>
        <h1>University Management System Portal</h1>
    </header>
    <div class="container" style="max-width: 420px;">
        <h2>Portal Login</h2>
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label>Select Portal / Role:</label>
                <select name="role" required>
                    <option value="STUDENT">Student Portal</option>
                    <option value="FACULTY">Faculty Portal</option>
                    <option value="ADMIN">Admin Portal</option>
                </select>
            </div>
            <div class="form-group">
                <label>Name / Username:</label>
                <input type="text" name="username" required placeholder="Enter exact registered name">
            </div>
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" style="width: 100%;">Login</button>
        </form>
        <p style="margin-top: 20px; text-align: center;">
            New user? <a href="register.jsp" style="color: #1e3a8a; font-weight: bold;">New Registration</a>
        </p>
    </div>
</body>
</html>