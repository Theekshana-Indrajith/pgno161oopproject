package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.util.BubbleSort;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MovieService {

    public List<Movie> getAllMovies() {
        return FileHandler.readMovies();
    }

    public List<Movie> getMoviesSortedByRating() {
        List<Movie> movies = new ArrayList<>(FileHandler.readMovies());
        BubbleSort.sortByRating(movies);
        return movies;
    }

    public void addMovie(Movie movie) {
        List<Movie> movies = FileHandler.readMovies();
        int newId = movies.stream().mapToInt(Movie::getId).max().orElse(0) + 1;
        movie.setId(newId);
        movie.setRating(0.0);
        movies.add(movie);
        FileHandler.writeMovies(movies);
    }

    public void updateMovie(int id, Movie updatedMovie) {
        List<Movie> movies = FileHandler.readMovies();
        for (int i = 0; i < movies.size(); i++) {
            if (movies.get(i).getId() == id) {
                updatedMovie.setId(id);
                updatedMovie.setCreatedBy(movies.get(i).getCreatedBy());
                movies.set(i, updatedMovie);
                break;
            }
        }
        FileHandler.writeMovies(movies);
    }

    public void deleteMovie(int id) {
        List<Movie> movies = FileHandler.readMovies();
        movies.removeIf(m -> m.getId() == id);
        FileHandler.writeMovies(movies);
    }
}