package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.Review;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ReviewService {

    public List<Review> getReviewsByMovieId(int movieId) {
        return FileHandler.readReviews().stream()
                .filter(r -> r.getMovieId() == movieId)
                .collect(Collectors.toList());
    }

    public void addReview(Review review) {
        List<Review> reviews = FileHandler.readReviews();
        int newId = reviews.stream().mapToInt(Review::getId).max().orElse(0) + 1;
        review.setId(newId);
        reviews.add(review);
        FileHandler.writeReviews(reviews);

    }

    public void deleteReview(int reviewId, String username) {
        List<Review> reviews = FileHandler.readReviews();
        Review reviewToDelete = reviews.stream()
                .filter(r -> r.getId() == reviewId)
                .findFirst()
                .orElse(null);
        if (reviewToDelete != null) {
            reviews.remove(reviewToDelete);
            FileHandler.writeReviews(reviews);

        }
    }


}