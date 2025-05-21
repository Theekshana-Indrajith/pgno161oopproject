package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Rental;
import com.movieplatform.movierentalplatform.model.User;
import com.movieplatform.movierentalplatform.service.MovieService;
import com.movieplatform.movierentalplatform.service.RentalService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class RentalController {

    private final RentalService rentalService;
    private final MovieService movieService;

    @Autowired
    public RentalController(RentalService rentalService, MovieService movieService) {
        this.rentalService = rentalService;
        this.movieService = movieService;
    }

    @GetMapping("/rent/show/{movieId}")
    public String showRentMovieForm(@PathVariable int movieId, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Movie> movies = movieService.getAllMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == movieId).findFirst().orElse(null);
        if (movie == null) {
            model.addAttribute("error", "Movie not found!");
            return "rentMovie";
        }

        if (!movie.isAvailable()) {
            model.addAttribute("error", "No copies available for this movie!");
            return "rentMovie";
        }

        List<Rental> rentals = FileHandler.readRentals();
        long activeRentals = rentals.stream()
                .filter(r -> r.getUsername().equals(user.getUsername()) && !r.isReturned())
                .count();
        if (activeRentals >= 10) {
            model.addAttribute("error", "You have reached the maximum rental limit of 10 movies!");
            return "rentMovie";
        }


        boolean alreadyRented = rentals.stream()
                .anyMatch(r -> r.getUsername().equals(user.getUsername()) && r.getMovieId() == movieId && !r.isReturned());
        model.addAttribute("alreadyRented", alreadyRented);

        model.addAttribute("movie", movie);
        model.addAttribute("user", user);
        return "rentMovie";
    }

    @GetMapping("/rent/confirm/{movieId}")
    public String confirmRentMovie(@PathVariable int movieId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        boolean success = rentalService.rentMovie(user.getUsername(), movieId);
        if (!success) {
            return "redirect:/movies/explore?error=" +
                    (FileHandler.readMovies().stream().filter(m -> m.getId() == movieId).findFirst()
                            .map(m -> !m.isAvailable() ? "No copies available for this movie!" :
                                    "You have reached the maximum rental limit of 10 movies!")
                            .orElse("Movie not found!"));
        }

        return "redirect:/movies/explore?success=Movie rented successfully!";
    }

    @GetMapping("/return/{movieId}")
    public String returnMovie(@PathVariable int movieId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        boolean success = rentalService.returnMovie(user.getUsername(), movieId);
        if (!success) {
            return "redirect:/profile?error=Invalid rental!";
        }

        return "redirect:/profile?success=Movie returned successfully!";
    }
}