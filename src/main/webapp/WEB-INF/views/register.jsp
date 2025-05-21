<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - CinemaScope</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: url('https://www.plex.tv/wp-content/uploads/2025/03/Watch-Free-Hero-2048x1152-1.png') no-repeat center center/cover;
            background-attachment: fixed;
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(10, 15, 43, 0.5), rgba(28, 37, 38, 0.7));
            z-index: 0;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 1; }
            to { opacity: 1; }
        }

        .login-container {
            position: relative;
            z-index: 2;
            max-width: 450px;
            width: 100%;
            background: rgba(31, 42, 68, 0.61);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.7);
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.8s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .logo {
            font-size: 2.2rem;
            color: #00d4ff;
            margin-bottom: 15px;
            text-shadow: 0 0 10px #00d4ff, 0 0 20px #00b8e6;
        }

        .login-container h2 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: #00d4ff;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
        }

        .close-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            color: #b0c4de;
            font-size: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .close-btn:hover {
            color: #ff3b5f;
            transform: rotate(90deg);
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            font-size: 1rem;
            font-weight: 500;
            color: #b0c4de;
            margin-bottom: 8px;
            display: block;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            font-size: 1rem;
            color: #fff;
            background: rgba(255, 255, 255, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            transition: all 0.4s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: rgba(0, 212, 255, 0.68);
            background: rgba(255, 255, 255, 0.97);
            /*box-shadow: 0 0 15px #00d4ff, 0 0 25px #00b8e6;*/
        }

        .form-group input::placeholder {
            color: #b0c4de;
            opacity: 0.7;
        }

        .btn-primary {
            background: linear-gradient(90deg, #ff3b5f, #e63557);
            color: #fff;
            font-weight: 600;
            padding: 12px 20px;
            border-radius: 50px;
            border: none;
            width: 100%;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: -100%;
            background: rgba(255, 255, 255, 0.2);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { left: -100%; }
            20% { left: 0; }
            100% { left: 100%; }
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(255, 59, 95, 0.6);
        }

        .alert-danger {
            background: rgba(255, 59, 95, 0.3);
            color: #fff;
            border: none;
            border-radius: 10px;
            margin-bottom: 20px;
            padding: 10px;
            animation: fadeIn 0.5s ease-in;
        }

        .register-link {
            margin-top: 20px;
            font-size: 0.9rem;
            color: #b0c4de;
        }

        .register-link a {
            color: #00d4ff;
            text-decoration: none;
            font-weight: 500;
            position: relative;
        }

        .register-link a::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: -2px;
            left: 0;
            background: #00d4ff;
            transition: width 0.3s ease;
        }

        .register-link a:hover::after {
            width: 100%;
        }

        @media (max-width: 576px) {
            .login-container {
                padding: 30px;
            }

            .logo {
                font-size: 1.8rem;
            }

            .login-container h2 {
                font-size: 2rem;
            }

            .form-group input {
                font-size: 0.9rem;
                padding: 10px 12px;
            }

            .btn-primary {
                font-size: 0.9rem;
                padding: 10px 16px;
            }

            .close-btn {
                font-size: 1.3rem;
                top: 10px;
                right: 10px;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <a href="/" class="close-btn" title="Close">×</a>
    <div class="logo">🎬 CinemaScope</div>
    <h2>Join CinemaScope</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>
    <form method="post" action="/register">
        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" class="form-control" placeholder="Enter your name" required>
        </div>
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control" placeholder="Choose a username" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" class="form-control" placeholder="Enter your email" required>
        </div>
        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="Create a password" required>
        </div>
        <button type="submit" class="btn btn-primary">Register</button>
    </form>
    <div class="register-link">
        Already have an account? <a href="/login">Login here</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>