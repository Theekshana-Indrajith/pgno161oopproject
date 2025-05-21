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