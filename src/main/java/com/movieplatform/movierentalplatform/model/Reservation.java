package com.movieplatform.movierentalplatform.model;

import java.time.LocalDate;

public class Reservation {
    private String username;
    private int movieId;
    private LocalDate reservationDate;

    public Reservation(String username, int movieId, LocalDate reservationDate) {
        this.username = username;
        this.movieId = movieId;
        this.reservationDate = reservationDate;
    }


    public String getUsername() {

        return username;
    }

    public void setUsername(String username) {

        this.username = username;
    }

    public int getMovieId() {

        return movieId;
    }

    public void setMovieId(int movieId) {

        this.movieId = movieId;
    }

    public LocalDate getReservationDate() {

        return reservationDate;
    }

    public void setReservationDate(LocalDate reservationDate) {

        this.reservationDate = reservationDate;
    }

    @Override
    public String toString() {

        return username + "," + movieId + "," + reservationDate;
    }
}