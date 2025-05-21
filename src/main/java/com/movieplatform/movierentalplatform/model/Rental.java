package com.movieplatform.movierentalplatform.model;

import java.time.LocalDate;

public class Rental {
    private String username;
    private int movieId;
    private LocalDate rentalDate;
    private boolean returned;

    public Rental(String username, int movieId, LocalDate rentalDate, boolean returned) {
        this.username = username;
        this.movieId = movieId;
        this.rentalDate = rentalDate;
        this.returned = returned;
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

    public LocalDate getRentalDate() {

        return rentalDate;
    }

    public void setRentalDate(LocalDate rentalDate) {

        this.rentalDate = rentalDate;
    }

    public boolean isReturned() {

        return returned;
    }

    public void setReturned(boolean returned) {

        this.returned = returned;
    }

    @Override
    public String toString() {

        return username + "," + movieId + "," + rentalDate + "," + returned;
    }
}