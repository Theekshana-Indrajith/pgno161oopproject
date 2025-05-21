```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us - CinemaScope</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Contact CinemaScope for support or inquiries. Reach us via email, WhatsApp, or social media.">
    <meta name="keywords" content="CinemaScope, contact, movie rental, streaming, support">
    <meta name="author" content="CinemaScope Team">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(rgba(10, 15, 43, 0.85), rgba(28, 37, 38, 0.85)),
            url('https://images.unsplash.com/photo-1584543515885-b8981dbf0b5d?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')
            no-repeat center center fixed;
            background-size: cover;
            color: #fff;
            line-height: 1.6;
            overflow-x: hidden;
        }

        .top-bar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: rgba(31, 42, 68, 0.9);
            padding: 15px 20px;
            z-index: 900;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
        }

        .user-info {
            color: #fff;
            font-size: 1.4rem;
            font-weight: 400;
        }

        .main-content {
            margin-top: 80px;
            padding: 30px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            background: rgba(10, 15, 43, 0.3);
        }

        .contact-section {
            position: relative;
            max-width: 600px;
            margin: 0 auto;
            background: rgba(31, 42, 68, 0.95);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            text-align: center;
            transition: all 0.4s ease;
            border: 1px solid rgba(0, 212, 255, 0.2);
        }

        .contact-section:hover {
            transform: translateY(-15px);
            box-shadow: 0 20px 40px rgba(0, 212, 255, 0.3);
        }

        .contact-section h2 {
            font-size: 2.8rem;
            font-weight: 700;
            color: #00d4ff;
            margin-bottom: 25px;
            text-shadow: 0 5px 20px rgba(0, 0, 0, 0.8);
            animation: fadeIn 1.5s ease-in-out;
        }

        .btn-close {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #ff3b5f;
            color: #fff;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-close:hover {
            background: #e63557;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(255, 59, 95, 0.3);
        }

        .btn-close i {
            font-size: 1.2rem;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .social-links {
            margin-top: 35px;
        }

        .social-links h3 {
            font-size: 1.6rem;
            font-weight: 500;
            color: #b0c4de;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .social-links a {
            display: flex;
            align-items: center;
            gap: 15px;
            margin: 15px 0;
            color: #b0c4de;
            text-decoration: none;
            font-size: 1.2rem;
            font-weight: 400;
            padding: 12px 20px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .social-links a:hover {
            color: #00d4ff;
            background: rgba(0, 212, 255, 0.1);
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 212, 255, 0.3);
        }

        .social-links i {
            font-size: 1.5rem;
            width: 25px;
            text-align: center;
            color: #00d4ff;
        }

        footer {
            background: linear-gradient(135deg, #1c2526, #0a0f2b);
            padding: 50px 20px;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            width: 100%;
        }

        footer a {
            color: #b0c4de;
            text-decoration: none;
            margin: 0 20px;
            font-size: 1rem;
            font-weight: 400;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #00d4ff;
        }

        footer p {
            color: #666;
            font-size: 0.9rem;
            margin-top: 20px;
            margin-bottom: 0;
        }

        .footer-links {
            margin-bottom: 25px;
        }

        .valuable-things {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .valuable-item {
            display: flex;
            align-items: center;
            gap: 15px;
            font-size: 1rem;
            font-weight: 300;
            color: #b0c4de;
            background: rgba(255, 255, 255, 0.03);
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .valuable-item:hover {
            background: rgba(0, 212, 255, 0.1);
            color: #fff;
        }

        .valuable-item i {
            color: #00d4ff;
            font-size: 1.4rem;
        }

        @media (max-width: 768px) {
            .top-bar {
                padding: 10px 15px;
            }

            .user-info {
                font-size: 1.2rem;
            }

            .main-content {
                padding: 20px;
                margin-top: 60px;
            }

            .contact-section {
                padding: 25px;
            }

            .contact-section h2 {
                font-size: 2.2rem;
            }

            .social-links h3 {
                font-size: 1.4rem;
            }

            .social-links a {
                font-size: 1.1rem;
                padding: 10px 15px;
            }

            .social-links i {
                font-size: 1.3rem;
            }

            .btn-close {
                top: 10px;
                right: 10px;
                padding: 6px 10px;
                font-size: 0.9rem;
            }

            .valuable-things {
                flex-direction: column;
                gap: 20px;
            }

            .valuable-item {
                font-size: 0.9rem;
                padding: 8px 15px;
            }
        }

        @media (max-width: 576px) {
            .top-bar {
                padding: 8px 10px;
            }

            .user-info {
                font-size: 1rem;
            }

            .main-content {
                padding: 15px;
                margin-top: 50px;
            }

            .contact-section {
                padding: 20px;
            }

            .contact-section h2 {
                font-size: 1.8rem;
            }

            .social-links h3 {
                font-size: 1.2rem;
            }

            .social-links a {
                font-size: 1rem;
                padding: 8px 12px;
            }

            .btn-close {
                top: 8px;
                right: 8px;
                padding: 5px 8px;
                font-size: 0.8rem;
            }

            .valuable-item {
                padding: 6px 12px;
            }
        }
    </style>
</head>
<body>
<!-- Top Bar -->
<div class="top-bar">
    <span class="user-info">Welcome, ${fn:escapeXml(user.name)} (${fn:escapeXml(user.role)})</span>
</div>

<!-- Main Content -->
<main class="main-content">
    <div class="contact-section">
        <button class="btn-close" onclick="history.back()" aria-label="Go back to previous page">
            <i class="fas fa-times"></i>
        </button>
        <h2>Contact Us</h2>
        <div class="social-links">
            <h3>Follow Us</h3>
            <a href="https://www.facebook.com/CinemaScope" target="_blank">
                <i class="fab fa-facebook-f"></i> Facebook
            </a>
            <a href="https://www.instagram.com/CinemaScope" target="_blank">
                <i class="fab fa-instagram"></i> Instagram
            </a>
            <a href="https://wa.me/+94711001001" target="_blank">
                <i class="fab fa-whatsapp"></i> WhatsApp (+94 71 100 100 1)
            </a>
            <a href="mailto:cinemascopehelp@gmail.com?subject=Inquiry%20from%20CinemaScope%20User&body=Hello%20CinemaScope%20Team,%0D%0A%0D%0AI%20have%20a%20question%20about...">
                <i class="fas fa-envelope"></i> Email Us (cinemascopehelp@gmail.com)
            </a>
        </div>
    </div>
</main>

<!-- Footer -->
<footer>
    <div class="container text-center">
        <div class="footer-links">
            <a href="/contact">Contact</a>
        </div>
        <div class="valuable-things">
            <div class="valuable-item">
                <i class="fas fa-film"></i>
                <span>Explore Thousands of Movies</span>
            </div>
            <div class="valuable-item">
                <i class="fas fa-clock"></i>
                <span>Stream Anytime, Anywhere</span>
            </div>
            <div class="valuable-item">
                <i class="fas fa-star"></i>
                <span>Ratings & Reviews</span>
            </div>
        </div>
        <p>© 2025 CinemaScope. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
```