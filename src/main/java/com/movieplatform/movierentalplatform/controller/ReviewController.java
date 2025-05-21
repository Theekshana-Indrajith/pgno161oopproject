package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Review;
import com.movieplatform.movierentalplatform.model.User;
import com.movieplatform.movierentalplatform.service.ReviewService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ReviewController {

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    @GetMapping("/review/add/{movieId}")
    public String showReviewForm(@PathVariable int movieId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        List<Movie> movies = FileHandler.readMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == movieId).findFirst().orElse(null);
        if (movie == null) {
            return "redirect:/";
        }
        model.addAttribute("movie", movie);
        model.addAttribute("review", new Review(user.getUsername(), movieId, 0.0, ""));
        return "reviewAdd";
    }

    @PostMapping("/review/add/{movieId}")
    public String addReview(@PathVariable int movieId, @ModelAttribute Review review, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        reviewService.addReview(review);
        return "redirect:/movies/view/" + movieId;
    }

    @PostMapping("/review/delete")
    public String deleteReview(@RequestParam int movieId, @RequestParam int reviewId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Review> reviews = FileHandler.readReviews();
        Review reviewToDelete = reviews.stream()
                .filter(r -> r.getId() == reviewId)
                .findFirst()
                .orElse(null);

        if (reviewToDelete != null) {
            if (user.getRole().equals("ADMIN") || reviewToDelete.getUsername().equals(user.getUsername())) {
                reviewService.deleteReview(reviewId, user.getUsername());
            }
        }
        return "redirect:/movies/view/" + movieId;
    }
}