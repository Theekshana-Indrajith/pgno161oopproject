package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.*;
import com.movieplatform.movierentalplatform.service.MovieService;
import com.movieplatform.movierentalplatform.service.ReviewService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import com.movieplatform.movierentalplatform.util.Stack;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@Controller
public class MovieController {

    private static final int MAX_RECENTLY_WATCHED = 1000;
    private static final int MAX_ADD_LIMIT = 30;

    private final MovieService movieService;
    private final ReviewService reviewService;

    @Autowired
    public MovieController(MovieService movieService, ReviewService reviewService) {
        this.movieService = movieService;
        this.reviewService = reviewService;
    }

    //home
    @GetMapping("/")
    public String home(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "index";
        }
        model.addAttribute("user", user);

        //view top 5 rating movies in recomendSection
        List<Movie> movies = movieService.getAllMovies().stream()
                .sorted((m1, m2) -> Double.compare(m2.getRating(), m1.getRating()))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recommendedMovies", movies);

        return "home";
    }

    @GetMapping("/movie/details")
    public String viewMoviesAddedByUsers(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<Movie> movies = movieService.getAllMovies();
        List<Category> categories = FileHandler.readCategories();
        Map<Integer, String> categoryMap = categories.stream()
                .collect(Collectors.toMap(Category::getId, Category::getName));

        for (Movie movie : movies) {
            movie.setCategoryName(categoryMap.getOrDefault(movie.getCategoryId(), "Unknown"));
            if (!movie.getThumbnailPath().isEmpty()) {
                File thumbnailFile = new File(FileHandler.IMAGES_DIR + movie.getThumbnailPath());
                if (!thumbnailFile.exists()) {
                    System.err.println("Thumbnail file not found for movie ID " + movie.getId() + ": " + movie.getThumbnailPath());
                    movie.setThumbnailPath("");
                }
            }
        }

        model.addAttribute("movies", movies);
        model.addAttribute("user", user);
        return "movieDetails";
    }

    @GetMapping("/movies/explore")
    public String exploreMovies(
            @RequestParam(value = "search", required = false) String search,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        long startTime = System.currentTimeMillis();
        System.out.println("Starting exploreMovies");

        try {
            List<Category> categories = FileHandler.readCategories();
            System.out.println("Read " + categories.size() + " categories in " + (System.currentTimeMillis() - startTime) + "ms");

            List<Movie> movies = movieService.getAllMovies();
            System.out.println("Read " + movies.size() + " movies in " + (System.currentTimeMillis() - startTime) + "ms");

            Map<Integer, String> categoryMap = categories.stream()
                    .collect(Collectors.toMap(Category::getId, Category::getName));
            for (Movie movie : movies) {
                movie.setCategoryName(categoryMap.getOrDefault(movie.getCategoryId(), "Unknown"));
                System.out.println("Movie: " + movie.getTitle() + ", Thumbnail: " + movie.getThumbnailPath());
                if (!movie.getThumbnailPath().isEmpty()) {
                    File thumbnailFile = new File(FileHandler.IMAGES_DIR + movie.getThumbnailPath());
                    if (!thumbnailFile.exists()) {
                        System.err.println("Thumbnail file not found for movie ID " + movie.getId() + ": " + movie.getThumbnailPath());
                        movie.setThumbnailPath("");
                    }
                }
            }

            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.trim().toLowerCase();
                movies = movies.stream()
                        .filter(movie ->
                                movie.getTitle().toLowerCase().contains(searchLower) ||
                                        movie.getCategoryName().toLowerCase().contains(searchLower) ||
                                        String.valueOf(movie.getYear()).contains(searchLower)
                        )
                        .collect(Collectors.toList());
                model.addAttribute("search", search);
                System.out.println("Filtered to " + movies.size() + " movies after search in " + (System.currentTimeMillis() - startTime) + "ms");
            }

            model.addAttribute("movies", movies);
            model.addAttribute("user", user);
            System.out.println("Completed exploreMovies in " + (System.currentTimeMillis() - startTime) + "ms");
            return "exploreMovies";
        } catch (Exception e) {
            System.err.println("Error in exploreMovies: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load movies: " + e.getMessage());
            model.addAttribute("user", user);
            return "exploreMovies";
        }
    }

    @GetMapping("/movies/sort")
    public String sortMovies(
            @RequestParam(value = "search", required = false) String search,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Category> categories = FileHandler.readCategories();
        List<Movie> movies = movieService.getMoviesSortedByRating();

        for (Movie movie : movies) {
            Category category = categories.stream()
                    .filter(c -> c.getId() == movie.getCategoryId())
                    .findFirst()
                    .orElse(null);
            movie.setCategoryName(category != null ? category.getName() : "Unknown");
            if (!movie.getThumbnailPath().isEmpty()) {
                File thumbnailFile = new File(FileHandler.IMAGES_DIR + movie.getThumbnailPath());
                if (!thumbnailFile.exists()) {
                    System.err.println("Thumbnail file not found for movie ID " + movie.getId() + ": " + movie.getThumbnailPath());
                    movie.setThumbnailPath("");
                }
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.trim().toLowerCase();
            movies = movies.stream()
                    .filter(movie ->
                            movie.getTitle().toLowerCase().contains(searchLower) ||
                                    movie.getCategoryName().toLowerCase().contains(searchLower) ||
                                    String.valueOf(movie.getYear()).contains(searchLower)
                    )
                    .collect(Collectors.toList());
            model.addAttribute("search", search);
        }

        model.addAttribute("movies", movies);
        model.addAttribute("user", user);
        return "sortedMovies";
    }

    @GetMapping("/movies/add")
    public String showAddMovieForm(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }
        List<Category> categories = FileHandler.readCategories();
        model.addAttribute("movie", new Movie());
        model.addAttribute("categories", categories);
        return "movieAdd";
    }

    @PostMapping("/movies/add")
    public String addMovie(
            @ModelAttribute Movie movie,
            @RequestParam int totalCopies,
            @RequestParam("thumbnail") MultipartFile thumbnail,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<Movie> movies = movieService.getAllMovies();
        long userAddedMovies = movies.stream()
                .filter(m -> user.getUsername().equals(m.getCreatedBy()))
                .count();
        if (userAddedMovies >= MAX_ADD_LIMIT) {
            model.addAttribute("error", "You have reached the maximum limit of " + MAX_ADD_LIMIT + " movies!");
            List<Category> categories = FileHandler.readCategories();
            model.addAttribute("movie", movie);
            model.addAttribute("categories", categories);
            return "movieAdd";
        }

        try {
            String username = user.getUsername() != null ? user.getUsername() : "unknown";
            movie.setCreatedBy(username);
            movie.setTotalCopies(totalCopies);
            movieService.addMovie(movie);
            if (!thumbnail.isEmpty()) {
                String thumbnailPath = FileHandler.saveImageFile(thumbnail, movie.getId());
                movie.setThumbnailPath(thumbnailPath);
                movieService.updateMovie(movie.getId(), movie);
            }
            return "redirect:/";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to upload thumbnail: " + e.getMessage());
            List<Category> categories = FileHandler.readCategories();
            model.addAttribute("movie", movie);
            model.addAttribute("categories", categories);
            return "movieAdd";
        }
    }

    @GetMapping("/movies/edit/{id}")
    public String showEditMovieForm(@PathVariable int id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = movieService.getAllMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == id).findFirst().orElse(null);
        if (movie == null) {
            return "redirect:/";
        }

        if (!"ADMIN".equals(user.getRole()) && (movie.getCreatedBy() == null || !movie.getCreatedBy().equals(user.getUsername()))) {
            return "redirect:/";
        }

        List<Category> categories = FileHandler.readCategories();
        model.addAttribute("movie", movie);
        model.addAttribute("categories", categories);
        return "movieEdit";
    }

    @PostMapping("/movies/edit/{id}")
    public String updateMovie(
            @PathVariable int id,
            @ModelAttribute Movie updatedMovie,
            @RequestParam int totalCopies,
            @RequestParam("thumbnail") MultipartFile thumbnail,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = movieService.getAllMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == id).findFirst().orElse(null);
        if (movie == null) {
            return "redirect:/";
        }

        if (!"ADMIN".equals(user.getRole()) && (movie.getCreatedBy() == null || !movie.getCreatedBy().equals(user.getUsername()))) {
            return "redirect:/";
        }

        try {
            updatedMovie.setTotalCopies(totalCopies);
            if (!thumbnail.isEmpty()) {
                String thumbnailPath = FileHandler.saveImageFile(thumbnail, id);
                updatedMovie.setThumbnailPath(thumbnailPath);
            } else {
                updatedMovie.setThumbnailPath(movie.getThumbnailPath());
            }
            movieService.updateMovie(id, updatedMovie);
            return "redirect:/movies/explore";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to upload thumbnail: " + e.getMessage());
            List<Category> categories = FileHandler.readCategories();
            model.addAttribute("movie", updatedMovie);
            model.addAttribute("categories", categories);
            return "movieEdit";
        }
    }

    @GetMapping("/movies/categorize")
    public String categorizeMovies(
            @RequestParam(value = "search", required = false) String search,
            Model model,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        long startTime = System.currentTimeMillis();
        System.out.println("Starting categorizeMovies");

        try {

            List<Category> categories = FileHandler.readCategories();
            System.out.println("Read " + categories.size() + " categories in " + (System.currentTimeMillis() - startTime) + "ms");

            List<Movie> movies = movieService.getAllMovies();
            System.out.println("Read " + movies.size() + " movies in " + (System.currentTimeMillis() - startTime) + "ms");


            Map<Integer, String> categoryMap = categories.stream()
                    .collect(Collectors.toMap(Category::getId, Category::getName));

            for (Movie movie : movies) {
                movie.setCategoryName(categoryMap.getOrDefault(movie.getCategoryId(), "Uncategorized"));
                if (!movie.getThumbnailPath().isEmpty()) {
                    File thumbnailFile = new File(FileHandler.IMAGES_DIR + movie.getThumbnailPath());
                    if (!thumbnailFile.exists()) {
                        System.err.println("Thumbnail file not found for movie ID " + movie.getId() + ": " + movie.getThumbnailPath());
                        movie.setThumbnailPath("");
                    }
                }
            }

            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.trim().toLowerCase();
                movies = movies.stream()
                        .filter(movie ->
                                movie.getTitle().toLowerCase().contains(searchLower) ||
                                        movie.getCategoryName().toLowerCase().contains(searchLower) ||
                                        String.valueOf(movie.getYear()).contains(searchLower)
                        )
                        .collect(Collectors.toList());
                model.addAttribute("search", search);
                System.out.println("Filtered to " + movies.size() + " movies after search in " + (System.currentTimeMillis() - startTime) + "ms");
            }


            Map<String, List<Movie>> moviesByCategory = movies.stream()
                    .collect(Collectors.groupingBy(Movie::getCategoryName));

            model.addAttribute("moviesByCategory", moviesByCategory);
            model.addAttribute("user", user);
            System.out.println("Completed categorizeMovies in " + (System.currentTimeMillis() - startTime) + "ms");
            return "categorizeMovies";
        } catch (Exception e) {
            System.err.println("Error in categorizeMovies: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Failed to load categorized movies: " + e.getMessage());
            model.addAttribute("user", user);
            return "categorizeMovies";
        }
    }

    @GetMapping("/movies/delete/{id}")
    public String deleteMovie(@PathVariable int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = movieService.getAllMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == id).findFirst().orElse(null);
        if (movie == null) {
            return "redirect:/";
        }

        if (!"ADMIN".equals(user.getRole()) && (movie.getCreatedBy() == null || !movie.getCreatedBy().equals(user.getUsername()))) {
            return "redirect:/";
        }

        movieService.deleteMovie(id);
        return "redirect:/";
    }

    @GetMapping("/movies/view/{id}")
    public String viewMovie(@PathVariable int id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = movieService.getAllMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == id).findFirst().orElse(null);
        if (movie == null) {
            return "redirect:/";
        }


        List<Review> reviews = reviewService.getReviewsByMovieId(id);
        model.addAttribute("reviews", reviews);

        Map<String, Stack<Integer>> recentlyWatchedMap = FileHandler.readRecentlyWatched();
        Stack<Integer> userRecentlyWatched = recentlyWatchedMap.getOrDefault(user.getUsername(), new Stack<>());
        userRecentlyWatched.getAll().removeIf(movieId -> movieId.equals(id));
        userRecentlyWatched.push(id);
        while (userRecentlyWatched.getAll().size() > MAX_RECENTLY_WATCHED) {
            userRecentlyWatched.pop();
        }
        recentlyWatchedMap.put(user.getUsername(), userRecentlyWatched);
        FileHandler.writeRecentlyWatched(recentlyWatchedMap);

        model.addAttribute("movie", movie);
        model.addAttribute("user", user);
        return "movieView";
    }

    @GetMapping("/recently-watched")
    public String showRecentlyWatched(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Map<String, Stack<Integer>> recentlyWatchedMap = FileHandler.readRecentlyWatched();
        Stack<Integer> userRecentlyWatched = recentlyWatchedMap.getOrDefault(user.getUsername(), new Stack<>());
        List<Integer> recentlyWatched = userRecentlyWatched.getAll();

        List<Movie> allMovies = movieService.getAllMovies();
        Map<Integer, String> movieTitles = new HashMap<>();
        for (Movie movie : allMovies) {
            movieTitles.put(movie.getId(), movie.getTitle());
            if (!movie.getThumbnailPath().isEmpty()) {
                File thumbnailFile = new File(FileHandler.IMAGES_DIR + movie.getThumbnailPath());
                if (!thumbnailFile.exists()) {
                    System.err.println("Thumbnail file not found for movie ID " + movie.getId() + ": " + movie.getThumbnailPath());
                    movie.setThumbnailPath("");
                }
            }
        }

        model.addAttribute("recentlyWatched", recentlyWatched);
        model.addAttribute("movieTitles", movieTitles);
        model.addAttribute("user", user);

        return "recentlyWatched";
    }
}