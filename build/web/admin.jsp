<%-- 
    Document   : admin
    Created on : Nov 3, 2025, 10:49:17 PM
    Author     : Tarooo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Recipe, java.util.List" %>
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
    <title>Quản Lý - Recipe Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect("login");
            return;
        }
        
        List<Recipe> recipes = (List<Recipe>) request.getAttribute("recipes");
        String success = request.getParameter("success");
    %>
    
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="admin">
                <strong>Admin Panel</strong>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active fw-bold" href="admin">Quản Lý</a>
                    </li>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Quản Lý Công Thức</h2>
            <a href="admin?action=add" class="btn btn-success">+ Thêm Công Thức Mới</a>
        </div>
        
        <% if (success != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <% if ("add".equals(success)) { %>
                    Thêm công thức thành công!
                <% } else if ("update".equals(success)) { %>
                    Cập nhật công thức thành công!
                <% } else if ("delete".equals(success)) { %>
                    Xóa công thức thành công!
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <% if (recipes == null || recipes.isEmpty()) { %>
            <div class="alert alert-info">Chưa có công thức nào!</div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Tên Công Thức</th>
                            <th>Danh Mục</th>
                            <th>Độ Khó</th>
                            <th>Thời Gian</th>
                            <th>Người Tạo</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Recipe recipe : recipes) { %>
                            <tr>
                                <td><%= recipe.getRecipeId() %></td>
                                <td><%= recipe.getRecipeName() %></td>
                                <td><span class="badge bg-info"><%= recipe.getCategoryName() %></span></td>
                                <td><span class="badge bg-warning text-dark"><%= getDifficultyInVietnamese(recipe.getDifficulty()) %></span></td>
                                <td><%= recipe.getCookingTime() %> phút</td>
                                <td><%= recipe.getCreatedByName() %></td>
                                <td>
                                    <a href="recipe-detail?id=<%= recipe.getRecipeId() %>" class="btn btn-sm btn-info">Xem</a>
                                    <a href="admin?action=edit&id=<%= recipe.getRecipeId() %>" class="btn btn-sm btn-warning">Sửa</a>
                                    <a href="admin?action=delete&id=<%= recipe.getRecipeId() %>" 
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc muốn xóa công thức này?')">Xóa</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


