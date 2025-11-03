<%-- 
    Document   : recipe-detail
    Created on : Nov 3, 2025, 10:49:35 PM
    Author     : Tarooo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Recipe" %>
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
    <title>Chi Tiết Công Thức - Recipe Management</title>
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
        
        Recipe recipe = (Recipe) request.getAttribute("recipe");
        if (recipe == null) {
            response.sendRedirect("home");
            return;
        }
    %>
    
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="home">
                <strong>Recipe Management</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home">Trang Chủ</a>
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
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="home">Trang chủ</a></li>
                <li class="breadcrumb-item active"><%= recipe.getRecipeName() %></li>
            </ol>
        </nav>
        
        <div class="row">
            <div class="col-md-5">
                <% if (recipe.getImageUrl() != null && !recipe.getImageUrl().isEmpty()) {
                    String imageUrl = recipe.getImageUrl();
                    // Check if it's a full URL or just a filename
                    if (!imageUrl.startsWith("http://") && !imageUrl.startsWith("https://")) {
                        imageUrl = "images/" + imageUrl;
                    }
                %>
                    <img src="<%= imageUrl %>" class="img-fluid rounded shadow" alt="<%= recipe.getRecipeName() %>">
                <% } else { %>
                    <div class="bg-secondary text-white text-center rounded shadow" style="height: 400px; display: flex; align-items: center; justify-content: center;">
                        <span>No Image Available</span>
                    </div>
                <% } %>
            </div>
            
            <div class="col-md-7">
                <h1 class="mb-3"><%= recipe.getRecipeName() %></h1>
                <p class="lead text-muted"><%= recipe.getDescription() %></p>
                
                <div class="mb-3">
                    <span class="badge bg-info"><%= recipe.getCategoryName() %></span>
                    <span class="badge bg-warning text-dark"><%= getDifficultyInVietnamese(recipe.getDifficulty()) %></span>
                </div>
                
                <div class="row mb-4">
                    <div class="col-6">
                        <div class="card text-center">
                            <div class="card-body">
                                <h5>⏱️ Thời gian</h5>
                                <p class="mb-0"><%= recipe.getCookingTime() %> phút</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card text-center">
                            <div class="card-body">
                                <h5>🍽️ Khẩu phần</h5>
                                <p class="mb-0"><%= recipe.getServings() %> người</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">📝 Nguyên Liệu</h5>
                        <div><%= recipe.getIngredients().replace("\\n", "<br>").replace("\n", "<br>") %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">👨‍🍳 Các Bước Thực Hiện</h5>
                        <div><%= recipe.getInstructions().replace("\\n", "<br>").replace("\n", "<br>") %></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-4 mb-4">
            <a href="home" class="btn btn-secondary">← Quay lại</a>
            <% if (user.isAdmin()) { %>
                <a href="admin?action=edit&id=<%= recipe.getRecipeId() %>" class="btn btn-warning">Chỉnh sửa</a>
            <% } %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
