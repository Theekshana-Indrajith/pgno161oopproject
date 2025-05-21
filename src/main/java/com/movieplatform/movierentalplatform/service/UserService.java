package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.User;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    public User loginUser(String username, String password) {
        List<User> users = FileHandler.readUsers();
        return users.stream()
                .filter(user -> user.getUsername().equals(username) && user.getPassword().equals(password))
                .findFirst()
                .orElse(null);
    }

    public void registerUser(User user) {
        List<User> users = FileHandler.readUsers();
        if (users.stream().anyMatch(u -> u.getUsername().equals(user.getUsername()))) {
            throw new IllegalArgumentException("Username already exists!");
        }
        if (users.stream().anyMatch(u -> u.getEmail().equals(user.getEmail()))) {
            throw new IllegalArgumentException("Email already exists!");
        }
        users.add(user);
        FileHandler.writeUsers(users);
    }
}