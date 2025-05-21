```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>CinemaScope - Your Movie Haven</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="CinemaScope - Rent and stream thousands of movies anytime, anywhere. Discover classics, new releases, and more!">
    <meta name="keywords" content="movie rental, streaming, CinemaScope, movies, entertainment">
    <meta name="author" content="CinemaScope Team">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous">
    <link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css">
    <style>
        /* Reset and Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: #0d0d1f;
            color: #e0e0e0;
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Header Styles */
        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: rgba(15, 23, 43, 0.9);
            backdrop-filter: blur(10px);
            z-index: 1000;
            padding: 15px 0;
            transition: background 0.3s ease;
        }

        header.scrolled {
            background: #0f172a;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 700;
            color: #00eaff;
            text-decoration: none;
            letter-spacing: 1px;
        }

        .navbar-brand:hover {
            color: #00c4d4;
        }

        .navbar-nav .nav-link {
            color: #e0e0e0;
            font-size: 1rem;
            font-weight: 500;
            margin: 0 15px;
            position: relative;
            transition: color 0.3s ease;
        }

        .navbar-nav .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            background: #00eaff;
            bottom: -5px;
            left: 0;
            transition: width 0.3s ease;
        }

        .navbar-nav .nav-link:hover::after,
        .navbar-nav .nav-link.active::after {
            width: 100%;
        }

        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            color: #00eaff;
        }

        .btn-signup {
            background: linear-gradient(45deg, #00eaff, #007bff);
            color: #fff;
            border: none;
            padding: 10px 25px;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-signup:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 234, 255, 0.4);
        }

        .btn-getStarted {
            background: linear-gradient(45deg, #ff3b5f, #ff6b8b);
            color: #fff;
            border: none;
            padding: 12px 35px;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .btn-getStarted:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(255, 59, 95, 0.5);
        }

        /* Hero Section */
        .hero-section {
            position: relative;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 0 20px;
            background: url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') no-repeat center center/cover;
            background-attachment: fixed;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to bottom, rgba(15, 23, 43, 0.7), rgba(15, 23, 43, 0.9));
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
        }

        .hero-content h1 {
            font-size: 4.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: #00eaff;
            text-shadow: 0 4px 15px rgba(0, 0, 0, 0.7);
            letter-spacing: 2px;
        }

        .hero-content p {
            font-size: 1.4rem;
            font-weight: 300;
            margin-bottom: 40px;
            color: #b0c4de;
        }

        /* Features Section */
        .features-section {
            padding: 80px 20px;
            background: rgba(15, 23, 43, 0.5);
        }

        .features-section h2 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 700;
            color: #00eaff;
            margin-bottom: 50px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 20px rgba(0, 234, 255, 0.3);
        }

        .feature-card i {
            font-size: 2.8rem;
            color: #00eaff;
            margin-bottom: 15px;
        }

        .feature-card h3 {
            font-size: 1.6rem;
            font-weight: 600;
            color: #e0e0e0;
            margin-bottom: 10px;
        }

        .feature-card p {
            font-size: 1rem;
            font-weight: 300;
            color: #b0c4de;
        }

        /* Featured Movies Section */
        .movies-section {
            padding: 80px 20px;
            background: #0d0d1f;
        }

        .movies-section h2 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 700;
            color: #00eaff;
            margin-bottom: 40px;
        }

        .carousel-item img {
            width: 100%;
            height: 350px;
            object-fit: cover;
            border-radius: 10px;
        }

        .carousel-caption h4 {
            font-size: 1.4rem;
            font-weight: 600;
            color: #fff;
            text-shadow: 0 2px 5px rgba(0, 0, 0, 0.7);
        }

        .carousel-control-prev,
        .carousel-control-next {
            width: 5%;
            background: rgba(0, 0, 0, 0.3);
        }

        .carousel-indicators button {
            background-color: #00eaff;
        }

        /* Testimonials Section */
        .testimonials-section {
            padding: 80px 20px;
            background: rgba(15, 23, 43, 0.5);
        }

        .testimonials-section h2 {
            text-align: center;
            font-size: 2.8rem;
            font-weight: 700;
            color: #00eaff;
            margin-bottom: 50px;
        }

        .testimonial-card {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 20px;
            max-width: 400px;
            margin: 0 auto;
            text-align: center;
        }

        .testimonial-card p {
            font-size: 1rem;
            font-style: italic;
            color: #b0c4de;
            margin-bottom: 15px;
        }

        .testimonial-card h4 {
            font-size: 1.2rem;
            font-weight: 500;
            color: #e0e0e0;
        }

        /* Footer */
        footer {
            background: #0f172a;
            padding: 40px 20px;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        footer a {
            color: #b0c4de;
            text-decoration: none;
            margin: 0 15px;
            font-size: 1rem;
            font-weight: 400;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #00eaff;
        }

        .social-links a {
            font-size: 1.5rem;
            margin: 0 10px;
        }

        footer p {
            color: #666;
            font-size: 0.9rem;
            margin-top: 20px;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.8rem;
            }

            .hero-content p {
                font-size: 1.1rem;
            }

            .navbar-nav .nav-link {
                margin: 10px 0;
            }

            .btn-signup {
                padding: 8px 20px;
            }

            .btn-getStarted {
                padding: 10px 25px;
                font-size: 1rem;
            }

            .features-section h2,
            .movies-section h2,
            .testimonials-section h2 {
                font-size: 2.2rem;
            }

            .carousel-item img {
                height: 250px;
            }

            .carousel-caption h4 {
                font-size: 1.2rem;
            }
        }
    </style>
</head>
<body>
<!-- Header -->
<header>
    <nav class="navbar navbar-expand-lg container">
        <a class="navbar-brand" href="/">CinemaScope</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link" href="#features">Features</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#movies">Movies</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/contact">Contact</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-signup" href="/login" aria-label="Sign in to CinemaScope">
                        <i class="fas fa-sign-in-alt"></i> Sign In
                    </a>
                </li>
            </ul>
        </div>
    </nav>
</header>

<!-- Hero Section -->
<section class="hero-section">
    <div class="hero-content" data-aos="fade-up">
        <h1>Discover CinemaScope</h1>
        <p>Your ultimate destination for renting and streaming movies anytime, anywhere.</p>
        <a href="/register" class="btn-getStarted" aria-label="Get started with CinemaScope">
            <i class="fas fa-play"></i> Start Watching
        </a>
    </div>
</section>

<!-- Features Section -->
<section class="features-section" id="features">
    <h2 data-aos="fade-up">Why CinemaScope?</h2>
    <div class="features-grid">
        <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
            <i class="fas fa-film"></i>
            <h3>Vast Library</h3>
            <p>Explore thousands of movies, from timeless classics to the latest blockbusters.</p>
        </div>
        <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
            <i class="fas fa-ticket-alt"></i>
            <h3>Seamless Rentals</h3>
            <p>Rent movies effortlessly and start watching in seconds.</p>
        </div>
        <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
            <i class="fas fa-star"></i>
            <h3>Community Reviews</h3>
            <p>Discover top-rated movies with reviews from our vibrant community.</p>
        </div>
        <div class="feature-card" data-aos="fade-up" data-aos-delay="400">
            <i class="fas fa-mobile-alt"></i>
            <h3>Watch Anywhere</h3>
            <p>Stream on your phone, tablet, laptop, or smart TV with ease.</p>
        </div>
    </div>
</section>

<!-- Featured Movies Section -->
<section class="movies-section" id="movies">
    <h2 data-aos="fade-up">Featured Movies</h2>
    <div id="moviesCarousel" class="carousel slide" data-bs-ride="carousel" data-aos="fade-up">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="2" aria-label="Slide 3"></button>
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="3" aria-label="Slide 4"></button>
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="4" aria-label="Slide 5"></button>
            <button type="button" data-bs-target="#moviesCarousel" data-bs-slide-to="5" aria-label="Slide 6"></button>
        </div>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://s3.amazonaws.com/nightjarprod/content/uploads/sites/344/2024/07/09154033/Fast-and-Furious-poster.png" alt="The Fast and the Furious">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BMjI0OTcwNTU3OF5BMl5BanBnXkFtZTgwODczOTA5NDM@._V1_.jpg" alt="Baaghi 2">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BN2MzOTJiOTItODBjOS00MjVhLWFiOWQtOTVjOTAyM2NkODM2XkEyXkFqcGc@._V1_.jpg" alt="My Fault: London">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://resizing.flixster.com/-XZAfHZM39UwaGJIFWKAE8fS0ak=/v3/t/assets/p28653_p_v10_ae.jpg" alt="The One">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BMjEzN2ZjYjUtZTI3NC00MzMyLWJiNDAtMDBiZGEzNTBiY2RkXkEyXkFqcGc@._V1_.jpg" alt="Lucky Baskhar">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://stat4.bollywoodhungama.in/wp-content/uploads/2023/10/800.jpg" alt="800">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BNTc0YmQxMjEtODI5MC00NjFiLTlkMWUtOGQ5NjFmYWUyZGJhXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg" alt="Dune: Part Two">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BMDBmYTZjNjUtN2M1MS00MTQ2LTk2ODgtNzc2M2QyZGE5NTVjXkEyXkFqcGdeQXVyNzAwMjU2MTY@._V1_.jpg" alt="Oppenheimer">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/I/81cgt1hGG3L.jpg" alt="Deadpool & Wolverine">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://lumiere-a.akamaihd.net/v1/images/p_insideout2_now_available_disneyplus_d24c051c.jpeg" alt="Inside Out 2">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
            <div class="carousel-item">
                <div class="d-flex justify-content-center gap-4 flex-wrap">
                    <div class="movie-card">
                        <img src="https://m.media-amazon.com/images/M/MV5BNTcwYWE1NTYtOWNiYy00NzY3LWIwY2MtNjJmZDkxNDNmOWE1XkEyXkFqcGc@._V1_.jpg" alt="Furiosa: A Mad Max Saga">
                        <div class="carousel-caption"></div>
                    </div>
                    <div class="movie-card">
                        <img src="https://images.justwatch.com/poster/326988382/s718/11-rebels.jpg" alt="11 Rebels">
                        <div class="carousel-caption"></div>
                    </div>
                </div>
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#moviesCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#moviesCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials-section">
    <h2 data-aos="fade-up">What Our Users Say</h2>
    <div class="row g-4 justify-content-center">
        <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
            <div class="testimonial-card">
                <p>"CinemaScope has an amazing selection of movies! I love how easy it is to rent and stream."</p>
                <h4>Jane D.</h4>
            </div>
        </div>
        <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
            <div class="testimonial-card">
                <p>"The user reviews help me pick the best movies every time. Highly recommend!"</p>
                <h4>Mike S.</h4>
            </div>
        </div>
        <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
            <div class="testimonial-card">
                <p>"Streaming on my phone and laptop is seamless. CinemaScope is my go-to for movie nights!"</p>
                <h4>Sarah L.</h4>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-links">
            <a href="/contact">Contact</a>
        </div>
        <p>© 2025 CinemaScope. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({
        duration: 1000,
        once: true
    });

    // Header scroll effect
    window.addEventListener('scroll', () => {
        const header = document.querySelector('header');
        header.classList.toggle('scrolled', window.scrollY > 50);
    });

    // Smooth scroll for nav links
    document.querySelectorAll('.nav-link').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            if (href.startsWith('#')) {
                e.preventDefault();
                const target = document.querySelector(href);
                window.scrollTo({
                    top: target.offsetTop - 70,
                    behavior: 'smooth'
                });
                // Update active class
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                this.classList.add('active');
            }
        });
    });
</script>
</body>
</html>
```