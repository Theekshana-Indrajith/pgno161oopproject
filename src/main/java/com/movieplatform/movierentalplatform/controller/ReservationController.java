package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.Category;
import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Reservation;
import com.movieplatform.movierentalplatform.model.User;
import com.movieplatform.movierentalplatform.service.ReservationService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class ReservationController {

    private final ReservationService reservationService;

    @Autowired
    public ReservationController(ReservationService reservationService) {
        this.reservationService = reservationService;
    }

    @GetMapping("/reserve/show/{movieId}")
    public String showReserveMovieForm(@PathVariable int movieId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = FileHandler.readMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == movieId).findFirst().orElse(null);
        if (movie == null) {
            model.addAttribute("error", "Movie not found!");
            return "reserveMovie";
        }

        if (movie.isAvailable()) {
            model.addAttribute("error", "This movie is currently available for rent!");
            return "reserveMovie";
        }

        boolean alreadyReserved = reservationService.hasReserved(user.getUsername(), movieId);
        if (alreadyReserved) {
            model.addAttribute("error", "You have already reserved this movie!");
        }

        List<Category> categories = FileHandler.readCategories();
        Category category = categories.stream()
                .filter(c -> c.getId() == movie.getCategoryId())
                .findFirst()
                .orElse(null);
        movie.setCategoryName(category != null ? category.getName() : "Unknown");

        model.addAttribute("movie", movie);
        model.addAttribute("user", user);
        model.addAttribute("alreadyReserved", alreadyReserved);
        return "reserveMovie";
    }


    @PostMapping("/reserve/{movieId}")
    public String reserveMovie(@PathVariable int movieId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        boolean success = reservationService.reserveMovie(user.getUsername(), movieId);
        if (!success) {
            model.addAttribute("error", "Cannot reserve this movie!");
            return "reserveMovie";
        }

        return "redirect:/movies/explore?success=Movie reserved successfully!";
    }

    @GetMapping("/cancelReservation/{movieId}")
    public String cancelReservation(@PathVariable int movieId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        boolean success = reservationService.cancelReservation(user.getUsername(), movieId);
        if (!success) {
            return "redirect:/profile?error=Failed to cancel reservation!";
        }

        return "redirect:/profile?success=Reservation cancelled successfully!";
    }
}