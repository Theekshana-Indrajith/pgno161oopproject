package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.*;
import com.movieplatform.movierentalplatform.service.UserService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import com.movieplatform.movierentalplatform.util.Stack;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        User user = userService.loginUser(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/";
        } else {
            model.addAttribute("error", "Invalid username or password!");
            return "login";
        }
    }

    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(
            @RequestParam String name,
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            Model model) {
        try {
            User user = new User(name, username, email, password, "USER");
            userService.registerUser(user);
            System.out.println("Registered new user: " + username + " with role: USER");
            return "redirect:/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Rental> allRentals = FileHandler.readRentals();
        List<Rental> userRentals = allRentals.stream()
                .filter(rental -> rental.getUsername().equals(user.getUsername()))
                .collect(Collectors.toList());

        List<Reservation> allReservations = FileHandler.readReservations();
        List<Reservation> userReservations = allReservations.stream()
                .filter(reservation -> reservation.getUsername().equals(user.getUsername()))
                .collect(Collectors.toList());

        List<Movie> movies = FileHandler.readMovies();
        Map<Integer, String> movieTitles = movies.stream()
                .collect(Collectors.toMap(Movie::getId, Movie::getTitle, (existing, replacement) -> existing));

        Map<String, Stack<Integer>> recentlyWatchedMap = FileHandler.readRecentlyWatched();
        Stack<Integer> recentlyWatchedStack = recentlyWatchedMap.getOrDefault(user.getUsername(), new Stack<>());
        List<Integer> recentlyWatched = recentlyWatchedStack.getAll();
        Collections.reverse(recentlyWatched);

        model.addAttribute("rentals", userRentals);
        model.addAttribute("reservations", userReservations);
        model.addAttribute("movies", movies);
        model.addAttribute("movieTitles", movieTitles);
        model.addAttribute("recentlyWatched", recentlyWatched);
        model.addAttribute("user", user);

        return "profile";
    }

    @GetMapping("/profile/edit")
    public String showEditProfileForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "profileEdit";
    }

    @PostMapping("/profile/edit")
    public String updateProfile(
            @RequestParam String name,
            @RequestParam String email,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<User> users = FileHandler.readUsers();
        if (users.stream()
                .anyMatch(u -> u.getEmail().equals(email) && !u.getUsername().equals(user.getUsername()))) {
            model.addAttribute("error", "Email already exists!");
            model.addAttribute("user", user);
            return "profileEdit";
        }

        users.stream()
                .filter(u -> u.getUsername().equals(user.getUsername()))
                .findFirst()
                .ifPresent(u -> {
                    u.setName(name);
                    u.setEmail(email);
                });

        FileHandler.writeUsers(users);

        user.setName(name);
        user.setEmail(email);
        session.setAttribute("user", user);

        return "redirect:/profile";
    }

    @GetMapping("/users")
    public String showUsers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<User> users = FileHandler.readUsers();
        model.addAttribute("users", users);
        return "users";
    }

    @PostMapping("/users/promote")
    public String promoteUser(@RequestParam String username, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<User> users = FileHandler.readUsers();
        users.stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst()
                .ifPresent(u -> u.setRole("ADMIN"));
        FileHandler.writeUsers(users);
        System.out.println("Promoted user " + username + " to ADMIN");
        return "redirect:/users";
    }

    @PostMapping("/users/demote")
    public String demoteUser(@RequestParam String username, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<User> users = FileHandler.readUsers();
        users.stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst()
                .ifPresent(u -> u.setRole("USER"));
        FileHandler.writeUsers(users);
        System.out.println("Demoted user " + username + " to USER");
        return "redirect:/users";
    }


    @GetMapping("/users/details/{username}")
    public String showUserDetails(@PathVariable String username, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(currentUser.getRole())) {
            return "redirect:/";
        }

        List<User> users = FileHandler.readUsers();
        User targetUser = users.stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst()
                .orElse(null);

        if (targetUser == null) {
            model.addAttribute("error", "User not found!");
            return "users";
        }

        List<Rental> allRentals = FileHandler.readRentals();
        List<Rental> userRentals = allRentals.stream()
                .filter(rental -> rental.getUsername().equals(username))
                .collect(Collectors.toList());

        List<Movie> movies = FileHandler.readMovies();
        Map<Integer, String> movieTitles = movies.stream()
                .collect(Collectors.toMap(Movie::getId, Movie::getTitle, (existing, replacement) -> existing));

        model.addAttribute("targetUser", targetUser);
        model.addAttribute("rentals", userRentals);
        model.addAttribute("movieTitles", movieTitles);
        return "userDetails";
    }

    @GetMapping("/contact")
    public String showContactPage() {
        return "contact";
    }

    @GetMapping("/users/view/{username}")
    public String viewUserDetails(@PathVariable String username, Model model, HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null || !loggedInUser.getRole().equals("ADMIN")) {
            return "redirect:/login";
        }

        List<User> users = FileHandler.readUsers();
        User targetUser = users.stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst()
                .orElse(null);
        if (targetUser == null) {
            return "redirect:/users";
        }

        List<Rental> rentals = FileHandler.readRentals();
        List<Rental> userRentals = rentals.stream()
                .filter(r -> r.getUsername().equals(username))
                .collect(Collectors.toList());

        List<Movie> allMovies = FileHandler.readMovies();
        Map<Integer, String> movieTitles = new HashMap<>();
        for (Movie movie : allMovies) {
            movieTitles.put(movie.getId(), movie.getTitle());
        }

        List<Category> categories = FileHandler.readCategories();
        List<Movie> moviesAdded = allMovies.stream()
                .filter(m -> m.getCreatedBy() != null && username.equals(m.getCreatedBy().trim()))
                .collect(Collectors.toList());

        for (Movie movie : moviesAdded) {
            Category category = categories.stream()
                    .filter(c -> c.getId() == movie.getCategoryId())
                    .findFirst()
                    .orElse(null);
            movie.setCategoryName(category != null ? category.getName() : "Unknown");
        }

        model.addAttribute("user", loggedInUser);
        model.addAttribute("targetUser", targetUser);
        model.addAttribute("rentals", userRentals);
        model.addAttribute("movieTitles", movieTitles);
        model.addAttribute("moviesAdded", moviesAdded);
        return "userDetails";
    }

    @GetMapping("/admin/create")
    public String showCreateAdminForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/login";
        }
        return "createAdmin";
    }

    @PostMapping("/admin/create")
    public String createAdmin(
            @RequestParam String name,
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/login";
        }

        try {
            User newAdmin = new User(name, username, email, password, "ADMIN");
            userService.registerUser(newAdmin);
            System.out.println("Created new admin: " + username);
            return "redirect:/";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "createAdmin";
        }
    }
}