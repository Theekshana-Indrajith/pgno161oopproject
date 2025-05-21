<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - CinemaScope</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CinemaScope - Your personalized movie rental platform. Stream, rent, and explore thousands of movies.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #0a0f2b 0%, #1c2526 100%);
            color: #fff;
            line-height: 1.6;
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 250px;
            height: 100vh;
            min-height: 100vh;
            background: #1f2a44;
            padding: 20px;
            z-index: 1000;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.5);
            overflow-y: auto;
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        .sidebar-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: #00d4ff;
            text-decoration: none;
        }

        .sidebar-brand:hover {
            color: #01acd6;
        }

        .sidebar-nav {
            list-style-type: none;
            padding: 0;
        }

        .sidebar-nav .nav-link {
            color: #b0c4de;
            font-size: 1rem;
            font-weight: 400;
            padding: 12px 15px;
            display: flex;
            align-items: center;
            border-radius: 5px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .sidebar-nav .nav-link:hover {
            background: #2a3b5e;
            color: #fff;
        }

        .sidebar-nav .nav-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .sidebar-nav .admin-section {
            margin-top: 20px;
            padding-top: 15px;
            border-top: 3px double #b0c4de;
        }

        .sidebar-nav .admin-section-label {
            font-size: 0.9rem;
            font-weight: 700;
            padding: 10px 15px;
            display: flex;
            align-items: center;
            text-transform: uppercase;
            color: #b0c4de;
        }

        .sidebar-nav .admin-section-label i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }

        .sidebar-nav .admin-link {
            border-left: 4px solid #b0c4de;
            font-weight: 600;
            padding: 10px 15px 10px 20px;
            display: flex;
            align-items: center;
            color: #b0c4de;
            text-decoration: none;
            border-radius: 0 5px 5px 0;
            margin-bottom: 5px;
        }

        .sidebar-nav .admin-link:hover {
            background: #2a3b5e;
            color: #fff;
        }

        .sidebar-nav .admin-link i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
            font-size: 1.1rem;
        }

        .btn-logout, .btn-home {
            background: #ff3b5f;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 0.9rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            margin-top: 20px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-home.disabled {
            background: #555;
            cursor: not-allowed;
        }

        .btn-logout:hover, .btn-home:hover:not(.disabled) {
            background: #e63557;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(255, 59, 95, 0.3);
        }

        .btn-logout i, .btn-home i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        .top-bar {
            position: fixed;
            top: 0;
            left: 250px;
            width: calc(100% - 250px);
            background: #1f2a44;
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
            margin-left: 250px;
            padding-top: 80px;
        }

        .hero-section {
            position: relative;
            height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
            padding: 20px;
            background: url('https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D') no-repeat center center/cover;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to bottom, rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.8));
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 1s ease forwards;
        }

        @keyframes fadeInUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
            letter-spacing: 1px;
        }

        .hero-content p {
            font-size: 1.2rem;
            font-weight: 300;
            margin-bottom: 40px;
            color: #d3d3d3;
        }

        .hero-content .btn-explore {
            background: #00d4ff;
            color: #fff;
            padding: 12px 35px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .hero-content .btn-explore i {
            font-size: 1.2rem;
        }

        .hero-content .btn-explore:hover {
            background: #00b8e6;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.4);
        }

        .movies-section {
            padding: 80px 20px;
        }

        .movies-section h2 {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: #00d4ff;
            margin-bottom: 50px;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
        }

        .movies-grid {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }

        .movie-card {
            width: 200px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .movie-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.3);
        }

        .movie-card a {
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .movie-card h4 {
            font-size: 1.2rem;
            font-weight: 500;
            color: #b0c4de;
        }

        footer {
            background: #1c2526;
            padding: 40px 20px;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-left: 250px;
        }

        footer a {
            color: #b0c4de;
            text-decoration: none;
            margin: 0 15px;
            font-size: 0.9rem;
            font-weight: 400;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #00d4ff;
        }

        footer p {
            color: #666;
            font-size: 0.8rem;
            margin-top: 15px;
        }

        .footer-links {
            margin-bottom: 20px;
        }

        .valuable-things {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .valuable-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.9rem;
            font-weight: 300;
            color: #b0c4de;
        }

        .valuable-item i {
            color: #00d4ff;
            font-size: 1.2rem;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }

            .top-bar {
                left: 200px;
                width: calc(100% - 200px);
            }

            .main-content {
                margin-left: 200px;
            }

            footer {
                margin-left: 200px;
            }

            .hero-section {
                height: 60vh;
            }

            .hero-content h1 {
                font-size: 2.5rem;
            }

            .hero-content p {
                font-size: 1rem;
            }

            .hero-content .btn-explore {
                padding: 10px 25px;
                font-size: 1rem;
            }

            .user-info {
                font-size: 0.8rem;
            }

            .movies-section h2 {
                font-size: 2rem;
            }

            .movie-card {
                width: 150px;
            }

            .movie-card img {
                height: 225px;
            }

            .movie-card h4 {
                font-size: 1rem;
            }

            .valuable-things {
                flex-direction: column;
                gap: 15px;
            }

            .valuable-item {
                font-size: 0.85rem;
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                box-shadow: none;
                overflow-y: visible;
            }

            .top-bar {
                left: 0;
                width: 100%;
            }

            .main-content {
                margin-left: 0;
            }

            footer {
                margin-left: 0;
            }

            .hero-section {
                height: 50vh;
            }
        }
    </style>
</head>
<body>
<!-- Top Bar -->
<div class="top-bar">
    <span class="user-info">Welcome, ${fn:escapeXml(user.name)} (${fn:escapeXml(user.role)})</span>
</div>

<!-- Sidebar -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <a class="sidebar-brand" href="/">CinemaScope</a>
    </div>
    <ul class="sidebar-nav">
        <li>
            <a class="nav-link" href="/movies/explore"><i class="fas fa-film"></i> Explore Movies</a>
        </li>
        <li>
            <a class="nav-link" href="/movies/sort"><i class="fas fa-sort-amount-down"></i> Sort by Rating</a>
        </li>
        <li>
            <a class="nav-link" href="/movies/categorize"><i class="fas fa-th-large"></i> Categorize Movies</a>
        </li>
        <li>
            <a class="nav-link" href="/profile"><i class="fas fa-user"></i> Profile</a>
        </li>
        <li>
            <a class="nav-link" href="/recently-watched"><i class="fas fa-history"></i> Recently Watched</a>
        </li>
        <c:if test="${user.role == 'ADMIN'}">
            <li class="admin-section">
                <div class="admin-section-label">
                    <i class="fas fa-gear"></i> Admin Options
                </div>
            </li>
            <li>
                <a class="nav-link admin-link" href="/movies/add"><i class="fas fa-plus-circle"></i> Add New Movie</a>
            </li>
            <li>
                <a class="nav-link admin-link" href="/users"><i class="fas fa-users"></i> User Details</a>
            </li>
            <li>
                <a class="nav-link admin-link" href="/categories"><i class="fas fa-tags"></i> Categories</a>
            </li>
            <li>
                <a class="nav-link admin-link" href="/movie/details"><i class="fas fa-list"></i> Movie Info</a>
            </li>
            <li>
                <a class="nav-link admin-link" href="/admin/create"><i class="fas fa-user-plus"></i> Create Admin</a>
            </li>
        </c:if>
        <li>
            <a class="nav-link btn-home disabled" href="/"><i class="fas fa-home"></i> Home</a>
        </li>
        <li>
            <a class="nav-link btn-logout" href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
    </ul>
</nav>

<!-- Main Content -->
<div class="main-content">
    <!-- Hero Section -->
    <section class="hero-section">
        <div class="hero-content">
            <h1>Find Your Perfect Movie</h1>
            <p>Rent and stream from a vast library of films tailored to your taste.</p>
            <a href="/movies/explore" class="btn-explore" aria-label="Explore movies now">
                <i class="fas fa-film"></i> Explore Movies
            </a>
        </div>
    </section>

    <!-- Recommended Movies Section -->
    <section class="movies-section">
        <h2>Recommended for You</h2>
        <div class="movies-grid">
            <c:if test="${not empty recommendedMovies}">
                <c:forEach var="movie" items="${recommendedMovies}">
                    <div class="movie-card">
                        <a href="/movies/view/${movie.id}">
                            <img src="${not empty movie.thumbnailPath ? '/images/' : ''}${movie.thumbnailPath}" alt="${fn:escapeXml(movie.title)}" onerror="this.src='https://via.placeholder.com/200x300?text=No+Image';">
                            <h4>${fn:escapeXml(movie.title)}</h4>
                        </a>
                    </div>
                </c:forEach>
            </c:if>
        </div>
    </section>
</div>

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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Fallback image handler
    document.addEventListener('DOMContentLoaded', function() {
        const images = document.querySelectorAll('.movie-card img');
        images.forEach(img => {
            img.onerror = function() {
                this.src = 'https://via.placeholder.com/200x300?text=No+Image';
            };
        });
    });
</script>
</body>
</html>