package com.movieplatform.movierentalplatform.model;

import com.movieplatform.movierentalplatform.util.FileHandler;

public class Movie {
    private int id;
    private String title;
    private int categoryId;
    private int year;
    private double price;
    private int totalCopies;
    private int rentedCopies;
    private double rating;
    private String createdBy;
    private String categoryName;
    private String thumbnailPath;

    public Movie() {
        this.totalCopies = 1;
        this.rentedCopies = 0;
        this.rating = 0.0;
        this.categoryId = 0;
        this.thumbnailPath = "";
    }

    public Movie(int id, String title, int categoryId, int year, double price, int totalCopies, int rentedCopies, double rating, String createdBy, String thumbnailPath) {
        this.id = id;
        this.title = title;
        this.categoryId = categoryId;
        this.year = year;
        this.price = price;
        this.totalCopies = totalCopies;
        this.rentedCopies = rentedCopies;
        this.rating = rating;
        this.createdBy = createdBy;
        this.thumbnailPath = thumbnailPath != null ? thumbnailPath : "";
    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return FileHandler.readCategories().stream()
                .filter(category -> category.getId() == this.categoryId)
                .findFirst()
                .map(Category::getName)
                .orElse("Uncategorized");
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getTotalCopies() {
        return totalCopies;
    }

    public void setTotalCopies(int totalCopies) {
        this.totalCopies = totalCopies;
    }

    public int getRentedCopies() {
        return rentedCopies;
    }

    public void setRentedCopies(int rentedCopies) {
        this.rentedCopies = rentedCopies;
    }

    public boolean isAvailable() {
        return rentedCopies < totalCopies;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getThumbnailPath() {

        return thumbnailPath;
    }

    public void setThumbnailPath(String thumbnailPath) {
        this.thumbnailPath = thumbnailPath != null ? thumbnailPath : "";
    }

    @Override
    public String toString() {
        return id + "," + title + "," + categoryId + "," + year + "," + price + "," + totalCopies + "," + rentedCopies + "," + rating + "," + (createdBy != null ? createdBy : "") + "," + (thumbnailPath != null ? thumbnailPath : "");
    }
}