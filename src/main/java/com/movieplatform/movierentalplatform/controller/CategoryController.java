package com.movieplatform.movierentalplatform.controller;

import com.movieplatform.movierentalplatform.model.Category;
import com.movieplatform.movierentalplatform.model.Movie;
import com.movieplatform.movierentalplatform.model.User;
import com.movieplatform.movierentalplatform.service.CategoryService;
import com.movieplatform.movierentalplatform.util.FileHandler;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.util.List;

@Controller
public class CategoryController {

    private final CategoryService categoryService;

    @Autowired
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/categories")
    public String showCategories(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "categories";
    }

    @GetMapping("/categories/add")
    public String showAddCategoryForm(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        model.addAttribute("category", new Category());
        return "categoryAdd";
    }

    @PostMapping("/categories/add")
    public String addCategory(@ModelAttribute Category category, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        categoryService.addCategory(category);
        return "redirect:/categories";
    }

    @GetMapping("/categories/edit/{id}")
    public String showEditCategoryForm(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<Category> categories = categoryService.getAllCategories();
        Category category = categories.stream().filter(c -> c.getId() == id).findFirst().orElse(null);
        if (category == null) {
            return "redirect:/categories";
        }

        model.addAttribute("category", category);
        return "categoryEdit";
    }

    @PostMapping("/categories/edit/{id}")
    public String updateCategory(@PathVariable int id, @ModelAttribute Category updatedCategory, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        categoryService.updateCategory(id, updatedCategory);
        return "redirect:/categories";
    }

    @GetMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/";
        }

        List<Movie> movies = FileHandler.readMovies();
        boolean isCategoryInUse = movies.stream().anyMatch(movie -> movie.getCategoryId() == id);
        if (isCategoryInUse) {
            model.addAttribute("error", "Cannot delete category because it is associated with one or more movies.");
            model.addAttribute("categories", categoryService.getAllCategories());
            return "categories";
        }

        categoryService.deleteCategory(id);
        return "redirect:/categories";
    }
}