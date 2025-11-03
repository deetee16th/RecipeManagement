<%-- 
    Document   : home
    Created on : Nov 3, 2025, 10:49:23 PM
    Author     : Tarooo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Recipe, model.Category, java.util.List" %>
<%!
    // Helper method to convert difficulty to Vietnamese
    public String getDifficultyInVietnamese(String difficulty) {
        if (difficulty == null) return "";
        switch (difficulty.toLowerCase()) {
            case "easy": return "Dễ";
            case "medium": return "Trung Bình";
            case "hard": return "Khó";
            default: return difficulty; // Already in Vietnamese
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Recipe Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        List<Recipe> recipes = (List<Recipe>) request.getAttribute("recipes");
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        String keyword = (String) request.getAttribute("keyword");
        Integer selectedCategoryId = (Integer) request.getAttribute("selectedCategoryId");
    %>
    
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="home">
                <strong>Quản Lý Công Thức Nấu Ăn</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active fw-bold" href="home">Trang Chủ</a>
                    </li>
                    <% if (user.isAdmin()) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="admin">Quản Lý</a>
                    </li>
                    <% } %>
                </ul>
                <span class="navbar-text text-white me-3">
                    Xin chào, <strong><%= user.getFullName() %></strong>
                </span>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="logout">Đăng Xuất</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container mt-4">
        <!-- Search and Filter -->
        <div class="row mb-4">
            <div class="col-md-8">
                <form action="home" method="get" class="mb-3">
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" 
                               placeholder="Tìm kiếm công thức..." 
                               value="<%= keyword != null ? keyword : "" %>">
                        <button class="btn btn-primary" type="submit">Tìm Kiếm</button>
                    </div>
                </form>
            </div>
            <div class="col-md-4">
                <form action="home" method="get">
                    <select class="form-select" name="categoryId" onchange="this.form.submit()">
                        <option value="">Tất cả danh mục</option>
                        <% if (categories != null) {
                            for (Category category : categories) { %>
                                <option value="<%= category.getCategoryId() %>" 
                                    <%= selectedCategoryId != null && selectedCategoryId == category.getCategoryId() ? "selected" : "" %>>
                                    <%= category.getCategoryName() %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </form>
            </div>
        </div>
        
        <!-- Recipe List -->
        <h2 class="mb-4">Danh Sách Công Thức</h2>
        
        <% if (recipes == null || recipes.isEmpty()) { %>
            <div class="alert alert-info">Không tìm thấy công thức nào!</div>
        <% } else { %>
            <div class="row">
                <% for (Recipe recipe : recipes) { 
                    String imageUrl = recipe.getImageUrl();
                    if (imageUrl != null && !imageUrl.isEmpty()) {
                        // Check if it's a full URL or just a filename
                        if (!imageUrl.startsWith("http://") && !imageUrl.startsWith("https://")) {
                            imageUrl = "images/" + imageUrl;
                        }
                    }
                %>
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm hover-card">
                            <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) { %>
                                <img src="<%= imageUrl %>" class="card-img-top" alt="<%= recipe.getRecipeName() %>" style="height: 200px; object-fit: cover;">
                            <% } else { %>
                                <div class="bg-secondary text-white text-center" style="height: 200px; display: flex; align-items: center; justify-content: center;">
                                    <span>No Image</span>
                                </div>
                            <% } %>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title"><%= recipe.getRecipeName() %></h5>
                                <p class="card-text text-muted small"><%= recipe.getDescription() %></p>
                                <div class="mt-auto">
                                    <p class="mb-1">
                                        <span class="badge bg-info"><%= recipe.getCategoryName() %></span>
                                        <span class="badge bg-warning text-dark"><%= getDifficultyInVietnamese(recipe.getDifficulty()) %></span>
                                    </p>
                                    <p class="mb-2">
                                        <small>⏱️ <%= recipe.getCookingTime() %> phút | 🍽️ <%= recipe.getServings() %> người</small>
                                    </p>
                                    <a href="recipe-detail?id=<%= recipe.getRecipeId() %>" class="btn btn-primary btn-sm">Xem Chi Tiết</a>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
