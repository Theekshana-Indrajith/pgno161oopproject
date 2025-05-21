<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reserve Movie - CinemaScope</title>
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
            background: linear-gradient(rgba(10, 15, 43, 0.85), rgba(28, 37, 38, 0.85)),
            url('https://images.unsplash.com/photo-1524712245354-2c4e5e7121c0?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')
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
            color: #00b8e6;
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
            text-align: center;
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

        .reservation-section {
            margin-left: 250px;
            padding: 100px 30px 30px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .reservation-section h2 {
            font-size: 2.5rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
            color: #00d4ff;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
            margin-bottom: 15px;
        }

        .reservation-card {
            background: rgba(31, 42, 68, 0.7);
            border-radius: 10px;
            overflow: hidden;
            max-width: 800px;
            width: 100%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            margin-bottom: 40px;
            position: relative;
            transition: all 0.3s ease;
            display: flex;
            align-items: flex-start;
            gap: 20px;
            padding: 20px;
        }

        .reservation-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 212, 255, 0.2);
        }

        .reservation-card img {
            width: 200px;
            aspect-ratio: 2 / 3;
            object-fit: cover;
            display: block;
            border-radius: 8px;
        }

        .reservation-info {
            flex: 1;
            text-align: left;
            padding: 0;
        }

        .reservation-info h3 {
            font-size: 2rem;
            font-weight: 700;
            color: #00d4ff;
            margin-bottom: 15px;
        }

        .reservation-info p {
            color: #b0c4de;
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .reservation-info p strong {
            color: #fff;
        }

        .reservation-info .rating {
            display: flex;
            align-items: center;
            gap: 5px;
            color: #ffcc00;
            margin-bottom: 15px;
        }

        .reservation-info .btn {
            font-size: 0.9rem;
            padding: 8px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .reservation-info .btn-success {
            background: #28a745;
            color: #fff;
            border: none;
        }

        .reservation-info .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
        }

        .reservation-info .btn-secondary {
            background: #ff3b5f;
            color: #fff;
            border: none;
            margin-left: 10px;
        }

        .reservation-info .btn-secondary:hover {
            background: #e63557;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(255, 59, 95, 0.4);
        }

        .reservation-info .btn-disabled {
            background: #6c757d;
            color: #fff;
            border: none;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .reservation-info .btn-disabled:hover {
            background: #5a6268;
            transform: none;
            box-shadow: none;
        }

        .reservation-info .already-reserved {
            color: #ff3b5f;
            font-weight: 600;
            margin-top: 10px;
            text-align: center;
        }

        .alert {
            max-width: 800px;
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

        .loading-spinner {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 200px;
            height: calc(200px * 3 / 2);
            display: flex;
            justify-content: center;
            align-items: center;
            background: rgba(31, 42, 68, 0.7);
            z-index: 10;
            border-radius: 8px;
        }

        .loading-spinner::after {
            content: '';
            width: 40px;
            height: 40px;
            border: 5px solid #00d4ff;
            border-top: 5px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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

            .reservation-section {
                margin-left: 200px;
            }

            footer {
                margin-left: 200px;
                width: calc(100% - 200px);
            }

            .reservation-section {
                padding: 80px 15px 40px;
            }

            .reservation-section h2 {
                font-size: 2rem;
            }

            .reservation-card {
                flex-direction: column;
                align-items: center;
                gap: 15px;
                padding: 15px;
            }

            .reservation-card img {
                width: 150px;
            }

            .loading-spinner {
                width: 150px;
                height: calc(150px * 3 / 2);
                top: 15px;
                left: 15px;
            }

            .reservation-info {
                text-align: center;
            }

            .reservation-info h3 {
                font-size: 1.8rem;
            }

            .reservation-info p {
                font-size: 0.9rem;
            }

            .reservation-info .btn {
                padding: 8px 12px;
                font-size: 0.85rem;
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

            .reservation-section {
                margin-left: 0;
                padding-top: 180px;
            }

            footer {
                margin-left: 0;
                width: 100%;
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
            <a class="nav-link active" href="/movies/explore"><i class="fas fa-film"></i> Explore Movies</a>
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
            <a class="nav-link btn-home" href="/"><i class="fas fa-home"></i> Back to Home</a>
        </li>
        <li>
            <a class="nav-link btn-logout" href="/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </li>
    </ul>
</nav>

<!-- Reservation Section -->
<section class="reservation-section">
    <div class="page-header">
        <h2>Reserve Movie</h2>
        <p>Reserve a movie to be notified when it becomes available</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${fn:escapeXml(error)}</div>
    </c:if>

    <c:if test="${empty movie}">
        <div class="alert alert-danger">Movie not found.</div>
    </c:if>

    <c:if test="${not empty movie}">
        <div class="reservation-card">
            <div class="loading-spinner" id="loading-spinner"></div>
            <c:set var="thumbnailPath" value="${fn:escapeXml(movie.thumbnailPath)}"/>
            <c:choose>
                <c:when test="${not empty thumbnailPath and thumbnailPath != ''}">
                    <img src="${pageContext.request.contextPath}/images/${thumbnailPath}"
                         alt="${fn:escapeXml(movie.title)}"
                         class="movie-thumbnail"
                         loading="lazy"
                         onload="console.log('Loaded image: ${pageContext.request.contextPath}/images/${thumbnailPath}')"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default.jpg'; console.error('Failed to load image: ${pageContext.request.contextPath}/images/${thumbnailPath}')">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default.jpg"
                         alt="${fn:escapeXml(movie.title)}"
                         class="movie-thumbnail"
                         loading="lazy"
                         onload="console.log('Loaded default image for ${fn:escapeXml(movie.title)}')"
                         onerror="console.error('Failed to load default image for ${fn:escapeXml(movie.title)}')">
                </c:otherwise>
            </c:choose>
            <div class="reservation-info">
                <h3>${fn:escapeXml(movie.title)}</h3>
                <p><strong>Category:</strong> ${fn:escapeXml(movie.categoryName)}</p>
                <p><strong>Year:</strong> ${movie.year}</p>
                <div class="rating">
                    <i class="fas fa-star"></i>
                    <span>${movie.rating}/5</span>
                </div>
                <p><strong>Available Copies:</strong> ${movie.totalCopies - movie.rentedCopies}/${movie.totalCopies}</p>
                <c:if test="${user.role == 'ADMIN'}">
                    <p><strong>Added By:</strong> ${fn:escapeXml(movie.createdBy)}</p>
                </c:if>
                <c:choose>
                    <c:when test="${alreadyReserved}">
                        <p class="already-reserved">You have already reserved this movie!</p>
                        <a href="/movies/explore" class="btn btn-secondary">Back to Explore</a>
                    </c:when>
                    <c:otherwise>
                        <form action="/reserve/${movie.id}" method="post">
                            <p>Would you like to reserve this movie? You will be notified when it becomes available.</p>
                            <button type="submit" class="btn btn-success" onclick="return confirm('Are you sure you want to reserve ${fn:escapeXml(movie.title)}?');">Confirm Reservation</button>
                            <a href="/movies/explore" class="btn btn-secondary">Cancel</a>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
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
    document.addEventListener('DOMContentLoaded', () => {
        const spinner = document.getElementById('loading-spinner');
        const img = document.querySelector('.movie-thumbnail');

        if (!img) {
            spinner.style.display = 'none';
            return;
        }

        if (img.complete) {
            spinner.style.display = 'none';
        } else {
            img.addEventListener('load', () => {
                spinner.style.display = 'none';
            });
            img.addEventListener('error', () => {
                spinner.style.display = 'none';
            });
        }

        setTimeout(() => {
            if (spinner.style.display !== 'none') {
                console.warn('Image loading timeout');
                spinner.style.display = 'none';
            }
        }, 5000);
    });
</script>
</body>
</html>