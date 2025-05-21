package com.movieplatform.movierentalplatform;

import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MovierentalplatformApplication {

	public static void main(String[] args) {
		FileHandler.initializeFiles(); // Ensure data files exist
		SpringApplication.run(MovierentalplatformApplication.class, args);
	}
}