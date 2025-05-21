package com.movieplatform.movierentalplatform.service;

import com.movieplatform.movierentalplatform.model.Category;
import com.movieplatform.movierentalplatform.util.FileHandler;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    public List<Category> getAllCategories() {
        return FileHandler.readCategories();
    }

    public void addCategory(Category category) {
        List<Category> categories = FileHandler.readCategories();
        category.setId(categories.size() + 1);
        categories.add(category);
        FileHandler.writeCategories(categories);
    }

    public void updateCategory(int id, Category updatedCategory) {
        List<Category> categories = FileHandler.readCategories();
        for (int i = 0; i < categories.size(); i++) {
            if (categories.get(i).getId() == id) {
                updatedCategory.setId(id);
                categories.set(i, updatedCategory);
                break;
            }
        }
        FileHandler.writeCategories(categories);
    }

    public void deleteCategory(int id) {
        List<Category> categories = FileHandler.readCategories();
        categories.removeIf(c -> c.getId() == id);
        FileHandler.writeCategories(categories);
    }
}