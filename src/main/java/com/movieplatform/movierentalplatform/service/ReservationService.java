package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Reservation;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
public class ReservationService {

    public boolean reserveMovie(String username, int movieId) {
        List<Movie> movies = FileHandler.readMovies();
        Movie movie = movies.stream().filter(m -> m.getId() == movieId).findFirst().orElse(null);
        if (movie == null || movie.isAvailable()) {
            return false;
        }

        List<Reservation> reservations = FileHandler.readReservations();
        boolean alreadyReserved = reservations.stream()
                .anyMatch(r -> r.getUsername().equals(username) && r.getMovieId() == movieId);
        if (alreadyReserved) {
            return false;
        }

        reservations.add(new Reservation(username, movieId, LocalDate.now()));
        FileHandler.writeReservations(reservations);
        return true;
    }

    public boolean cancelReservation(String username, int movieId) {
        List<Reservation> reservations = FileHandler.readReservations();
        int initialSize = reservations.size();
        reservations.removeIf(r -> r.getUsername().equals(username) && r.getMovieId() == movieId);
        if (reservations.size() < initialSize) {
            FileHandler.writeReservations(reservations);
            return true;
        }
        return false;
    }

    public boolean hasReserved(String username, int movieId) {
        List<Reservation> reservations = FileHandler.readReservations();
        return reservations.stream()
                .anyMatch(r -> r.getUsername().equals(username) && r.getMovieId() == movieId);
    }
}