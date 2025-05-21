package com.movieplatform.movierentalplatform.model;

import java.util.Objects;

public class Review {
    private int id;
    private String username;
    private int movieId;
    private double rating;
    private String comment;


    public Review() {
    }

    public Review(String username, int movieId, double rating, String comment) {
        this.username = username;
        setRating(rating);
        this.movieId = movieId;
        this.comment = comment != null ? comment : "";
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        if (rating < 0.0 || rating > 5.0) {
            throw new IllegalArgumentException("Rating must be between 0.0 and 5.0");
        }
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment != null ? comment : "";
    }

    @Override
    public String toString() {
        return id + "," + username + "," + movieId + "," + rating + "," + (comment != null ? "\"" + comment.replace("\"", "\"\"") + "\"" : "");
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Review review = (Review) o;
        return id == review.id &&
                movieId == review.movieId &&
                Double.compare(review.rating, rating) == 0 &&
                Objects.equals(username, review.username) &&
                Objects.equals(comment, review.comment);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, username, movieId, rating, comment);
    }
}