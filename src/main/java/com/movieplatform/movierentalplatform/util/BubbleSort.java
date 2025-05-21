package com.movieplatform.movierentalplatform.util;

import com.movieplatform.movierentalplatform.model.Movie;

import java.util.List;

public class BubbleSort {

    public static void sortByRating(List<Movie> movies) {
        int n = movies.size();
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (movies.get(j).getRating() < movies.get(j + 1).getRating()) {
                    Movie temp = movies.get(j);
                    movies.set(j, movies.get(j + 1));
                    movies.set(j + 1, temp);
                }
            }
        }
    }
}