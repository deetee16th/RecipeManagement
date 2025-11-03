<%-- 
    Document   : recipe-form
    Created on : Nov 3, 2025, 10:49:43 PM
    Author     : Tarooo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Recipe, model.Category, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("recipe") != null ? "Chỉnh Sửa" : "Thêm Mới" %> Công Thức - Recipe Management</title>
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
        
        Recipe recipe = (Recipe) request.getAttribute("recipe");
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        boolean isEdit = (recipe != null);
    %>
    
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-danger">
        <div class="container">
            <a class="navbar-brand" href="admin">
                <strong>🛠️ Admin Panel</strong>
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
                        <a class="nav-link" href="admin">Quản Lý</a>
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
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow">
                    <div class="card-body">
                        <h3 class="card-title mb-4">
                            <%= isEdit ? "Chỉnh Sửa" : "Thêm Mới" %> Công Thức
                        </h3>
                        
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <%= request.getAttribute("error") %>
                            </div>
                        <% } %>
                        
                        <form action="admin" method="post">
                            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                            <% if (isEdit) { %>
                                <input type="hidden" name="recipeId" value="<%= recipe.getRecipeId() %>">
                            <% } %>
                            
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label for="recipeName" class="form-label">Tên Công Thức <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="recipeName" name="recipeName" 
                                           value="<%= isEdit ? recipe.getRecipeName() : "" %>" required>
                                </div>
                                
                                <div class="col-md-4 mb-3">
                                    <label for="categoryId" class="form-label">Danh Mục <span class="text-danger">*</span></label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">Chọn danh mục</option>
                                        <% if (categories != null) {
                                            for (Category category : categories) { %>
                                                <option value="<%= category.getCategoryId() %>"
                                                    <%= isEdit && recipe.getCategoryId() == category.getCategoryId() ? "selected" : "" %>>
                                                    <%= category.getCategoryName() %>
                                                </option>
                                        <%  }
                                        } %>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Mô Tả</label>
                                <textarea class="form-control" id="description" name="description" rows="2"><%= isEdit ? recipe.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="ingredients" class="form-label">Nguyên Liệu <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="ingredients" name="ingredients" rows="6" required><%= isEdit ? recipe.getIngredients() : "" %></textarea>
                                <div class="form-text">Mỗi nguyên liệu một dòng</div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="instructions" class="form-label">Các Bước Thực Hiện <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="instructions" name="instructions" rows="8" required><%= isEdit ? recipe.getInstructions() : "" %></textarea>
                                <div class="form-text">Mỗi bước một dòng</div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="cookingTime" class="form-label">Thời Gian (phút) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="cookingTime" name="cookingTime" 
                                           value="<%= isEdit ? recipe.getCookingTime() : "" %>" required min="1">
                                </div>
                                
                                <div class="col-md-4 mb-3">
                                    <label for="servings" class="form-label">Số Người Ăn <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="servings" name="servings" 
                                           value="<%= isEdit ? recipe.getServings() : "" %>" required min="1">
                                </div>
                                
                                <div class="col-md-4 mb-3">
                                    <label for="difficulty" class="form-label">Độ Khó <span class="text-danger">*</span></label>
                                    <select class="form-select" id="difficulty" name="difficulty" required>
                                        <option value="">Chọn độ khó</option>
                                        <option value="Dễ" <%= isEdit && "Dễ".equals(recipe.getDifficulty()) ? "selected" : "" %>>Dễ</option>
                                        <option value="Trung Bình" <%= isEdit && "Trung Bình".equals(recipe.getDifficulty()) ? "selected" : "" %>>Trung Bình</option>
                                        <option value="Khó" <%= isEdit && "Khó".equals(recipe.getDifficulty()) ? "selected" : "" %>>Khó</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Hình Ảnh</label>
                                <input type="text" class="form-control" id="imageUrl" name="imageUrl" 
                                       value="<%= isEdit && recipe.getImageUrl() != null ? recipe.getImageUrl() : "" %>"
                                       placeholder="vd: pho-bo.jpg hoặc https://example.com/image.jpg">
                                <div class="form-text">
                                    Nhập tên file (đặt trong thư mục images/) hoặc URL đầy đủ từ internet (http://... hoặc https://...)
                                </div>
                            </div>
                            
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <%= isEdit ? "Cập Nhật" : "Thêm Mới" %>
                                </button>
                                <a href="admin" class="btn btn-secondary">Hủy</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
   
</body>
</html>
