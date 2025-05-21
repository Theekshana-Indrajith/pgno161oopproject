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