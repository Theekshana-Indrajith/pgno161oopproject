package com.movieplatform.movierentalplatform.util;

import com.movieplatform.movierentalplatform.model.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.time.LocalDate;
import java.util.*;

public class FileHandler {

    private static final String DATA_DIR = "C:/Users/CYBORG/Desktop/Movie Rental and Review Platform/Movie Rental and Review Platform/src/main/data/";
    public static final String IMAGES_DIR = DATA_DIR + "images/";
    private static final String USERS_FILE = DATA_DIR + "users.txt";
    private static final String MOVIES_FILE = DATA_DIR + "movies.txt";
    private static final String CATEGORIES_FILE = DATA_DIR + "categories.txt";
    private static final String RENTALS_FILE = DATA_DIR + "rentals.txt";
    private static final String REVIEWS_FILE = DATA_DIR + "reviews.txt";
    private static final String RECENTLY_WATCHED_FILE = DATA_DIR + "recentlyWatched.txt";
    private static final String RESERVATIONS_FILE = DATA_DIR + "reservations.txt";

    public static void initializeFiles() {
        File dir = new File(DATA_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        File imagesDir = new File(IMAGES_DIR);
        if (!imagesDir.exists()) {
            imagesDir.mkdirs();
        }
        createFileWithHeader(USERS_FILE, "#name,username,email,password,role,pendingRole");
        createFileWithHeader(MOVIES_FILE, "#id,title,categoryId,year,price,totalCopies,rentedCopies,rating,createdBy,thumbnailPath");
        createFileWithHeader(CATEGORIES_FILE, "#id,name");
        createFileWithHeader(RENTALS_FILE, "#username,movieId,rentalDate,returned");
        createFileWithHeader(REVIEWS_FILE, "#id,username,movieId,rating,comment");
        createFileWithHeader(RECENTLY_WATCHED_FILE, "#username,movieId1,movieId2,...");
        createFileWithHeader(RESERVATIONS_FILE, "#username,movieId,reservationDate");
    }

    private static void createFileWithHeader(String filePath, String header) {
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                file.createNewFile();

                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    writer.write(header);
                    writer.newLine();
                }
                System.out.println("Created new file with header: " + filePath);
            } catch (IOException e) {
                System.err.println("Failed to create file: " + filePath);
                e.printStackTrace();
            }
        }
    }

    public static List<User> readUsers() {
        List<User> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(USERS_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",", 6);
                try {
                    if (parts.length >= 5) {
                        String name = parts[0];
                        String username = parts[1];
                        String email = parts[2];
                        String password = parts[3];
                        String role = parts[4];
                        String pendingRole = parts.length > 5 && !parts[5].isEmpty() ? parts[5] : null;
                        User user = new User(name, username, email, password, role);
                        user.setPendingRole(pendingRole);
                        users.add(user);
                    } else if (parts.length == 3) {
                        String username = parts[0];
                        String password = parts[1];
                        String role = parts[2];
                        users.add(new User("[Unknown]", username, "unknown@example.com", password, role));
                    } else {
                        System.err.println("Invalid user format at line " + lineNumber + ": " + line);
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing user at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readUsers: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public static void writeUsers(List<User> users) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(USERS_FILE))) {

            writer.write("#name,username,email,password,role,pendingRole");
            writer.newLine();
            for (User user : users) {
                String pendingRole = user.getPendingRole() != null ? user.getPendingRole() : "";
                writer.write(String.format("%s,%s,%s,%s,%s,%s",
                        user.getName(),
                        user.getUsername(),
                        user.getEmail(),
                        user.getPassword(),
                        user.getRole(),
                        pendingRole));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + users.size() + " users to " + USERS_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeUsers: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static List<Category> readCategories() {
        List<Category> categories = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(CATEGORIES_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",");
                try {
                    if (parts.length == 2) {
                        int id = Integer.parseInt(parts[0]);
                        String name = parts[1];
                        categories.add(new Category(id, name));
                    } else {
                        System.err.println("Invalid category format at line " + lineNumber + ": " + line);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing category at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readCategories: " + e.getMessage());
            e.printStackTrace();
        }
        return categories;
    }

    public static void writeCategories(List<Category> categories) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(CATEGORIES_FILE))) {
            writer.write("#id,name");
            writer.newLine();
            for (Category category : categories) {
                writer.write(String.format("%d,%s",
                        category.getId(),
                        category.getName()));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + categories.size() + " categories to " + CATEGORIES_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeCategories: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static List<Movie> readMovies() {
        List<Movie> movies = new ArrayList<>();
        long startTime = System.currentTimeMillis();
        System.out.println("Starting readMovies");
        try (BufferedReader reader = new BufferedReader(new FileReader(MOVIES_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",", -1);
                try {
                    if (parts.length >= 10) {
                        int id = Integer.parseInt(parts[0]);
                        String title = parts[1];
                        int categoryId = Integer.parseInt(parts[2]);
                        int year = Integer.parseInt(parts[3]);
                        double price = Double.parseDouble(parts[4]);
                        int totalCopies = Integer.parseInt(parts[5]);
                        int rentedCopies = Integer.parseInt(parts[6]);
                        double rating = Double.parseDouble(parts[7]);
                        String createdBy = parts[8].isEmpty() ? null : parts[8];
                        String thumbnailPath = parts[9].isEmpty() ? "" : parts[9];
                        Movie movie = new Movie(id, title, categoryId, year, price, totalCopies, rentedCopies, rating, createdBy, thumbnailPath);
                        if (!thumbnailPath.isEmpty()) {
                            File thumbnailFile = new File(IMAGES_DIR + thumbnailPath);
                            if (!thumbnailFile.exists()) {
                                System.err.println("Thumbnail file not found for movie ID " + id + ": " + thumbnailPath);
                                movie.setThumbnailPath("");
                            }
                        }
                        movies.add(movie);
                    } else if (parts.length == 9) {
                        int id = Integer.parseInt(parts[0]);
                        String title = parts[1];
                        int categoryId = Integer.parseInt(parts[2]);
                        int year = Integer.parseInt(parts[3]);
                        double price = Double.parseDouble(parts[4]);
                        int totalCopies = Integer.parseInt(parts[5]);
                        int rentedCopies = Integer.parseInt(parts[6]);
                        double rating = Double.parseDouble(parts[7]);
                        String createdBy = parts[8].isEmpty() ? null : parts[8];
                        movies.add(new Movie(id, title, categoryId, year, price, totalCopies, rentedCopies, rating, createdBy, ""));
                    } else if (parts.length == 7) {
                        int id = Integer.parseInt(parts[0]);
                        String title = parts[1];
                        int categoryId = 0;
                        int year = Integer.parseInt(parts[3]);
                        double price = Double.parseDouble(parts[4]);
                        boolean available = Boolean.parseBoolean(parts[5]);
                        double rating = Double.parseDouble(parts[6]);
                        int totalCopies = 1;
                        int rentedCopies = available ? 0 : 1;
                        movies.add(new Movie(id, title, categoryId, year, price, totalCopies, rentedCopies, rating, null, ""));
                    } else {
                        System.err.println("Invalid movie format at line " + lineNumber + ": " + line);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing movie at line " + lineNumber + ": " + line + ". " + e.getMessage());
                } catch (Exception e) {
                    System.err.println("Unexpected error at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readMovies: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Completed readMovies with " + movies.size() + " movies in " + (System.currentTimeMillis() - startTime) + "ms");
        return movies;
    }

    public static void writeMovies(List<Movie> movies) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(MOVIES_FILE))) {
            writer.write("#id,title,categoryId,year,price,totalCopies,rentedCopies,rating,createdBy,thumbnailPath");
            writer.newLine();
            for (Movie movie : movies) {
                String createdBy = movie.getCreatedBy() != null ? movie.getCreatedBy() : "";
                String thumbnailPath = movie.getThumbnailPath() != null ? movie.getThumbnailPath() : "";
                writer.write(String.format("%d,%s,%d,%d,%.2f,%d,%d,%.2f,%s,%s",
                        movie.getId(),
                        movie.getTitle(),
                        movie.getCategoryId(),
                        movie.getYear(),
                        movie.getPrice(),
                        movie.getTotalCopies(),
                        movie.getRentedCopies(),
                        movie.getRating(),
                        createdBy,
                        thumbnailPath));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + movies.size() + " movies to " + MOVIES_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeMovies: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static List<Rental> readRentals() {
        List<Rental> rentals = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(RENTALS_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",");
                try {
                    if (parts.length == 4) {
                        String username = parts[0];
                        int movieId = Integer.parseInt(parts[1]);
                        LocalDate rentalDate = LocalDate.parse(parts[2]);
                        boolean returned = Boolean.parseBoolean(parts[3]);
                        rentals.add(new Rental(username, movieId, rentalDate, returned));
                    } else {
                        System.err.println("Invalid rental format at line " + lineNumber + ": " + line);
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing rental at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readRentals: " + e.getMessage());
            e.printStackTrace();
        }
        return rentals;
    }

    public static void writeRentals(List<Rental> rentals) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RENTALS_FILE))) {
            writer.write("#username,movieId,rentalDate,returned");
            writer.newLine();
            for (Rental rental : rentals) {
                writer.write(String.format("%s,%d,%s,%b",
                        rental.getUsername(),
                        rental.getMovieId(),
                        rental.getRentalDate(),
                        rental.isReturned()));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + rentals.size() + " rentals to " + RENTALS_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeRentals: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static List<Review> readReviews() {
        List<Review> reviews = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(REVIEWS_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;

                try {
                    List<String> parts = splitCSVLine(line);
                    if (parts.size() == 5) {
                        int id = Integer.parseInt(parts.get(0));
                        String username = parts.get(1);
                        int movieId = Integer.parseInt(parts.get(2));
                        double rating = Double.parseDouble(parts.get(3));
                        String comment = parts.get(4);
                        Review review = new Review(username, movieId, rating, comment);
                        review.setId(id);
                        reviews.add(review);
                    } else if (parts.size() == 4) {
                        String username = parts.get(0);
                        int movieId = Integer.parseInt(parts.get(1));
                        double rating = Double.parseDouble(parts.get(2));
                        String comment = parts.get(3);
                        Review review = new Review(username, movieId, rating, comment);
                        review.setId(0);
                        reviews.add(review);
                    } else {
                        System.err.println("Invalid review format at line " + lineNumber + ": " + line);
                    }
                } catch (NumberFormatException e) {
                    System.err.println("Error parsing review at line " + lineNumber + ": " + line + ". " + e.getMessage());
                } catch (Exception e) {
                    System.err.println("Unexpected error at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readReviews: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Successfully read " + reviews.size() + " reviews from " + REVIEWS_FILE);
        return reviews;
    }

    public static void writeReviews(List<Review> reviews) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(REVIEWS_FILE))) {
            writer.write("#id,username,movieId,rating,comment");
            writer.newLine();
            for (Review review : reviews) {
                String comment = review.getComment().replace("\"", "\"\""); // Escape quotes in comment
                writer.write(String.format("%d,%s,%d,%.2f,\"%s\"",
                        review.getId(),
                        review.getUsername(),
                        review.getMovieId(),
                        review.getRating(),
                        comment));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + reviews.size() + " reviews to " + REVIEWS_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeReviews: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static List<String> splitCSVLine(String line) {
        List<String> result = new ArrayList<>();
        boolean inQuotes = false;
        StringBuilder field = new StringBuilder();

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);

            if (c == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    field.append('"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == ',' && !inQuotes) {
                result.add(field.toString());
                field = new StringBuilder();
            } else {
                field.append(c);
            }
        }
        result.add(field.toString());

        for (int i = 0; i < result.size(); i++) {
            String value = result.get(i);
            if (value.startsWith("\"") && value.endsWith("\"")) {
                value = value.substring(1, value.length() - 1);
                value = value.replace("\"\"", "\"");
            }
            result.set(i, value);
        }

        return result;
    }

    public static Map<String, Stack<Integer>> readRecentlyWatched() {
        Map<String, Stack<Integer>> recentlyWatchedMap = new HashMap<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(RECENTLY_WATCHED_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",");
                if (parts.length >= 1) {
                    String username = parts[0];
                    Stack<Integer> movieIds = new Stack<>();
                    for (int i = parts.length - 1; i >= 1; i--) {
                        try {
                            movieIds.push(Integer.parseInt(parts[i]));
                        } catch (NumberFormatException e) {
                            System.err.println("Invalid movie ID in recently watched at line " + lineNumber + ": " + parts[i]);
                        }
                    }
                    recentlyWatchedMap.put(username, movieIds);
                } else {
                    System.err.println("Invalid recently watched format at line " + lineNumber + ": " + line);
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readRecentlyWatched: " + e.getMessage());
            e.printStackTrace();
        }
        return recentlyWatchedMap;
    }

    public static void writeRecentlyWatched(Map<String, Stack<Integer>> recentlyWatchedMap) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RECENTLY_WATCHED_FILE))) {
            writer.write("#username,movieId1,movieId2,...");
            writer.newLine();
            for (Map.Entry<String, Stack<Integer>> entry : recentlyWatchedMap.entrySet()) {
                String username = entry.getKey();
                Stack<Integer> movieIds = entry.getValue();
                List<Integer> movieIdList = movieIds.getAll();
                if (!movieIdList.isEmpty()) {
                    StringBuilder line = new StringBuilder(username);
                    for (Integer movieId : movieIdList) {
                        line.append(",").append(movieId);
                    }
                    writer.write(line.toString());
                    writer.newLine();
                }
            }
            System.out.println("Successfully wrote recently watched entries for " + recentlyWatchedMap.size() + " users to " + RECENTLY_WATCHED_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeRecentlyWatched: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static List<Reservation> readReservations() {
        List<Reservation> reservations = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(RESERVATIONS_FILE))) {
            String line;
            int lineNumber = 0;
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                if (line.trim().isEmpty() || line.startsWith("#")) continue;
                String[] parts = line.split(",");
                try {
                    if (parts.length == 3) {
                        String username = parts[0];
                        int movieId = Integer.parseInt(parts[1]);
                        LocalDate reservationDate = LocalDate.parse(parts[2]);
                        reservations.add(new Reservation(username, movieId, reservationDate));
                    } else {
                        System.err.println("Invalid reservation format at line " + lineNumber + ": " + line);
                    }
                } catch (Exception e) {
                    System.err.println("Error parsing reservation at line " + lineNumber + ": " + line + ". " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("IOException in readReservations: " + e.getMessage());
            e.printStackTrace();
        }
        return reservations;
    }

    public static void writeReservations(List<Reservation> reservations) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(RESERVATIONS_FILE))) {
            writer.write("#username,movieId,reservationDate");
            writer.newLine();
            for (Reservation reservation : reservations) {
                writer.write(String.format("%s,%d,%s",
                        reservation.getUsername(),
                        reservation.getMovieId(),
                        reservation.getReservationDate()));
                writer.newLine();
            }
            System.out.println("Successfully wrote " + reservations.size() + " reservations to " + RESERVATIONS_FILE);
        } catch (IOException e) {
            System.err.println("IOException in writeReservations: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static String saveImageFile(MultipartFile file, int movieId) throws IOException {
        if (file.isEmpty()) {
            return "";
        }
        String fileName = movieId + "_" + file.getOriginalFilename().replaceAll("[^a-zA-Z0-9.-]", "_");
        File destFile = new File(IMAGES_DIR + fileName);
        System.out.println("Saving image to: " + destFile.getAbsolutePath());
        file.transferTo(destFile);
        if (destFile.exists() && destFile.length() > 0) {
            System.out.println("Image saved successfully: " + fileName);
            return fileName;
        } else {
            System.err.println("Failed to save image or file is empty: " + fileName);
            throw new IOException("Failed to save image file: " + fileName);
        }
    }
}