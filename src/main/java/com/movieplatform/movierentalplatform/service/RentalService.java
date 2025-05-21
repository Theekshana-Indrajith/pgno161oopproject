package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Rental;
import com.movieplatform.movierentalplatform.model.Reservation;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RentalService {

    private static final int MAX_RENTAL_LIMIT = 10;

    public boolean rentMovie(String username, int movieId) {
        List<Movie> movies = FileHandler.readMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == movieId).findFirst().orElse(null);
        if (movie == null || !movie.isAvailable()) {
            return false;
        }

        List<Rental> rentals = FileHandler.readRentals();
        long activeRentals = rentals.stream()
                .filter(r -> r.getUsername().equals(username) && !r.isReturned())
                .count();
        if (activeRentals >= MAX_RENTAL_LIMIT) {
            return false;
        }

        movie.setRentedCopies(movie.getRentedCopies() + 1);
        FileHandler.writeMovies(movies);

        rentals.add(new Rental(username, movieId, LocalDate.now(), false));
        FileHandler.writeRentals(rentals);
        return true;
    }

    public boolean returnMovie(String username, int movieId) {
        List<Rental> rentals = FileHandler.readRentals();
        Rental rental = rentals.stream()
                .filter(r -> r.getUsername().equals(username) && r.getMovieId() == movieId && !r.isReturned())
                .findFirst()
                .orElse(null);
        if (rental == null) {
            return false;
        }

        rental.setReturned(true);
        FileHandler.writeRentals(rentals);

        List<Movie> movies = FileHandler.readMovies();
        Movie movie = movies.stream()
                .filter(m -> m.getId() == movieId)
                .findFirst()
                .orElse(null);
        if (movie != null) {
            movie.setRentedCopies(movie.getRentedCopies() - 1);
            FileHandler.writeMovies(movies);


            List<Reservation> reservations = FileHandler.readReservations();
            List<Reservation> movieReservations = reservations.stream()
                    .filter(r -> r.getMovieId() == movieId)
                    .sorted(Comparator.comparing(Reservation::getReservationDate))
                    .collect(Collectors.toList());

            if (!movieReservations.isEmpty() && movie.isAvailable()) {
                Reservation nextReservation = movieReservations.get(0);
                String reservedUser = nextReservation.getUsername();


                rentals.add(new Rental(reservedUser, movieId, LocalDate.now(), false));
                movie.setRentedCopies(movie.getRentedCopies() + 1);
                FileHandler.writeRentals(rentals);
                FileHandler.writeMovies(movies);


                reservations.remove(nextReservation);
                FileHandler.writeReservations(reservations);
            }
        }
        return true;
    }
}