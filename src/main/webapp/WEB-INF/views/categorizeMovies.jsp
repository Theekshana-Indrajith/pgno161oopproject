<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Categorize Movies - CinemaScope</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            background: linear-gradient(rgba(10, 15, 43, 0.96), rgba(28, 37, 38, 0.92)),
            url('https://images.unsplash.com/photo-1559108318-39ed452bb6c9?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')
            no-repeat center center fixed;
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

        .sidebar-nav .nav-link.active {
            background: #2a3b5e;
            color: #fff;
            font-weight: 600;
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

        .btn-logout:hover, .btn-home:hover {
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

        /* Category Navigation Bar */
        .category-nav {
            width: 100%;
            background: rgba(31, 42, 68, 0.95);
            padding: 15px 20px;
            margin: 0 auto 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-left: 250px; /* Align with sidebar */
            max-width: 1200px; /* Match the max-width of category-section */
        }

        .category-nav-list {
            display: flex;
            gap: 20px;
            list-style: none;
            padding: 0;
            margin: 0;
            overflow-x: auto;
            white-space: nowrap;
            -webkit-overflow-scrolling: touch; /* Smooth scrolling on mobile */
        }

        .category-nav-list::-webkit-scrollbar {
            height: 6px;
        }

        .category-nav-list::-webkit-scrollbar-thumb {
            background: #00d4ff;
            border-radius: 3px;
        }

        .category-nav-list::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        .category-nav-item a {
            color: #b0c4de;
            font-size: 1.2rem; /* Increased font size for bigger appearance */
            font-weight: 600;
            text-decoration: none;
            padding: 12px 20px; /* Increased padding for bigger buttons */
            border-radius: 25px; /* Slightly larger radius for prominence */
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
        }

        .category-nav-item a:hover {
            background: #00d4ff;
            color: #fff;
            transform: translateY(-3px); /* Increased hover effect */
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.4); /* Enhanced shadow */
        }

        .category-nav-item a.active {
            background: #00d4ff;
            color: #fff;
            font-weight: 700;
        }

        .search-container {
            max-width: 800px;
            margin: 40px auto 20px; /* Adjusted margin to account for navigation bar */
        }

        .search-form {
            display: flex;
            gap: 10px;
        }

        .search-form .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid #00d4ff;
            color: #fff;
            border-radius: 5px;
            padding: 12px 20px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .search-form .form-control:focus {
            background: rgba(255, 255, 255, 0.2);
            border-color: #00b8e6;
            box-shadow: 0 0 10px rgba(0, 212, 255, 0.3);
            outline: none;
        }

        .search-form .form-control::placeholder {
            color: #b0c4de;
        }

        .search-form .btn-search {
            background: #00d4ff;
            color: #fff;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .search-form .btn-search:hover {
            background: #00b8e6;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.3);
        }

        .movies-section {
            padding: 80px 20px 60px; /* Reduced padding-top since nav is no longer fixed */
            min-height: 100vh;
            margin-left: 250px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .movies-section h2 {
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
            color: #00d4ff;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
            letter-spacing: 1px;
        }

        .category-section {
            margin-bottom: 50px;
            width: 100%;
            max-width: 1200px;
        }

        .category-section h3 {
            font-size: 1.8rem;
            font-weight: 600;
            color: #b0c4de;
            margin-bottom: 20px;
            border-left: 4px solid #00d4ff;
            padding-left: 15px;
        }

        .movies-grid {
            display: flex;
            justify-content: flex-start;
            gap: 30px;
            flex-wrap: wrap;
        }

        .movie-card {
            background: rgba(31, 42, 68, 0.7);
            border-radius: 10px;
            overflow: hidden;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            width: 350px;
        }

        .movie-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 212, 255, 0.2);
        }

        .movie-card img {
            width: 100%;
            aspect-ratio: 2 / 3;
            object-fit: cover;
            display: block;
        }

        .movie-card .movie-info {
            padding: 20px;
        }

        .movie-card .movie-info h4 {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 10px;
            color: #fff;
            text-align: center;
        }

        .movie-card .movie-info p {
            color: #b0c4de;
            margin-bottom: 15px;
            font-size: 0.95rem;
            text-align: center;
        }

        .movie-card .movie-info .rating {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #ffcc00;
            margin-bottom: 15px;
            justify-content: center;
        }

        .movie-card .movie-info .btn-group {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .movie-card .movie-info .btn {
            font-size: 0.9rem;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .movie-card .movie-info .btn-primary {
            background: #00d4ff;
            border: none;
        }

        .movie-card .movie-info .btn-primary:hover {
            background: #00b8e6;
            transform: translateY(-2px);
        }

        .movie-card .movie-info .btn-warning {
            background: #ffcc00;
            color: #000;
            border: none;
        }

        .movie-card .movie-info .btn-warning:hover {
            background: #e6b800;
            transform: translateY(-2px);
        }

        .movie-card .movie-info .btn-danger {
            background: #ff3b5f;
            border: none;
        }

        .movie-card .movie-info .btn-danger:hover {
            background: #e63557;
            transform: translateY(-2px);
        }

        .movie-card .movie-info .btn-success {
            background: #28a745;
            border: none;
        }

        .movie-card .movie-info .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .movie-card .movie-info .btn-info {
            background: #17a2b8;
            border: none;
        }

        .movie-card .movie-info .btn-info:hover {
            background: #138496;
            transform: translateY(-2px);
        }

        .movie-card .availability {
            background: rgba(0, 0, 0, 0.3);
            padding: 8px;
            text-align: center;
            font-size: 0.85rem;
            color: #b0c4de;
        }

        .alert {
            max-width: 1200px;
            margin: 0 auto 20px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
            border: none;
            text-align: center;
        }

        .alert-danger {
            background: rgba(239, 68, 68, 0.2);
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            color: #b0c4de;
            font-size: 1.2rem;
            background: #2a3b5e;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            margin: 0 auto;
        }

        footer {
            background: #1c2526;
            padding: 40px 20px;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-left: 250px;
            width: calc(100% - 250px);
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
            margin-bottom: 0;
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

            .category-nav {
                margin-left: 200px;
            }

            .movies-section {
                margin-left: 200px;
                padding: 80px 15px 40px;
            }

            footer {
                margin-left: 200px;
                width: calc(100% - 200px);
            }

            .movies-section h2 {
                font-size: 2rem;
            }

            .category-section h3 {
                font-size: 1.5rem;
            }

            .movie-card {
                width: 100%;
                max-width: 300px;
            }

            .movie-card .movie-info h4 {
                font-size: 1.2rem;
            }

            .movie-card .movie-info p {
                font-size: 0.8rem;
            }

            .movie-card .movie-info .btn {
                font-size: 0.8rem;
                padding: 5px 10px;
            }

            .movie-card .availability {
                font-size: 0.8rem;
                padding: 5px;
            }

            .user-info {
                font-size: 0.8rem;
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

            .category-nav {
                margin-left: 0;
                width: 100%;
            }

            .movies-section {
                margin-left: 0;
                padding-top: 150px; /* Adjusted for mobile layout */
            }

            .search-form {
                flex-direction: column;
            }

            footer {
                margin-left: 0;
                width: 100%;
            }

            .movie-card {
                width: 100%;
                max-width: 350px;
                margin: 0 auto;
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
            <a class="nav-link active" href="/movies/categorize"><i class="fas fa-th-large"></i> Categorize Movies</a>
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
            <a class="nav-link btn-home" href="/"><i class="fas fa-home"></i> Back to Home</a>
        </li>
        <li>
            <a class="nav-link btn-logout" href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
    </ul>
</nav>

<!-- Movies Section -->
<section class="movies-section">
    <h2>Categorize Movies</h2>

    <!-- Search Bar -->
    <div class="search-container">
        <form class="search-form" action="/movies/categorize" method="get">
            <input type="text" name="search" class="form-control" placeholder="Search by title, category, or year..." value="${fn:escapeXml(search != null ? search : '')}">
            <button type="submit" class="btn btn-search">Search</button>
        </form>
    </div>

    <!-- Category Navigation Bar -->
    <c:if test="${not empty moviesByCategory}">
        <nav class="category-nav">
            <ul class="category-nav-list">
                <c:forEach var="entry" items="${moviesByCategory}">
                    <li class="category-nav-item">
                        <a href="#category-${fn:escapeXml(fn:replace(entry.key, ' ', '-'))}">${fn:escapeXml(entry.key)}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">${fn:escapeXml(param.error)}</div>
    </c:if>

    <c:if test="${empty moviesByCategory}">
        <div class="empty-state">
            <p>No movies available to categorize.</p>
        </div>
    </c:if>
    <c:if test="${not empty moviesByCategory}">
        <c:forEach var="entry" items="${moviesByCategory}">
            <div class="category-section" id="category-${fn:escapeXml(fn:replace(entry.key, ' ', '-'))}">
                <h3>${fn:escapeXml(entry.key)}</h3>
                <div class="movies-grid">
                    <c:forEach var="movie" items="${entry.value}">
                        <div class="movie-card">
                            <c:set var="thumbnailPath" value="${fn:escapeXml(movie.thumbnailPath)}"/>
                            <c:choose>
                                <c:when test="${not empty thumbnailPath and thumbnailPath != ''}">
                                    <img src="${pageContext.request.contextPath}/images/${thumbnailPath}"
                                         alt="${fn:escapeXml(movie.title)}"
                                         class="movie-thumbnail"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg';">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/default.jpg"
                                         alt="${fn:escapeXml(movie.title)}"
                                         class="movie-thumbnail">
                                </c:otherwise>
                            </c:choose>
                            <div class="movie-info">
                                <h4>${fn:escapeXml(movie.title)}</h4>
                                <p>${fn:escapeXml(movie.categoryName)} • ${movie.year}</p>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <span>${movie.rating}/5</span>
                                </div>
                                <div class="btn-group">
                                    <a href="/movies/view/${movie.id}" class="btn btn-primary">View</a>
                                    <c:if test="${movie.isAvailable()}">
                                        <a href="/rent/show/${movie.id}" class="btn btn-success">Rent</a>
                                    </c:if>
                                    <c:if test="${!movie.isAvailable()}">
                                        <a href="/reserve/show/${movie.id}" class="btn btn-warning">Reserve</a>
                                    </c:if>
                                    <a href="/review/add/${movie.id}" class="btn btn-info">Review</a>
                                </div>
                            </div>
                            <div class="availability">
                                Available: ${movie.totalCopies - movie.rentedCopies}/${movie.totalCopies} copies
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </c:if>
</section>

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
    // Smooth scrolling for category links
    document.querySelectorAll('.category-nav-item a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            if (targetElement) {
                const topBarHeight = document.querySelector('.top-bar').offsetHeight;
                const navHeight = document.querySelector('.category-nav').offsetHeight;
                const offset = topBarHeight + navHeight + 20; // Extra padding for visibility
                const elementPosition = targetElement.getBoundingClientRect().top + window.pageYOffset;
                window.scrollTo({
                    top: elementPosition - offset,
                    behavior: 'smooth'
                });
            }
        });
    });
</script>
</body>
</html>