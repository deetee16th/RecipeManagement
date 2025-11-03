/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Recipe;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class RecipeDAO {
    
    /**
     * Lấy tất cả recipes
     */
    public List<Recipe> getAllRecipes() {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as created_by_name " +
                     "FROM Recipes r " +
                     "LEFT JOIN Categories c ON r.category_id = c.category_id " +
                     "LEFT JOIN Users u ON r.created_by = u.user_id " +
                     "WHERE r.is_active = 1 " +
                     "ORDER BY r.created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    /**
     * Lấy tất cả recipes (for Admin page - sort by ID)
     */
    public List<Recipe> getAllRecipesForAdmin() {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as created_by_name " +
                     "FROM Recipes r " +
                     "LEFT JOIN Categories c ON r.category_id = c.category_id " +
                     "LEFT JOIN Users u ON r.created_by = u.user_id " +
                     "WHERE r.is_active = 1 " +
                     "ORDER BY r.recipe_id ASC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    /**
     * Lấy recipe theo ID
     */
    public Recipe getRecipeById(int recipeId) {
        String sql = "SELECT r.*, c.category_name, u.full_name as created_by_name " +
                     "FROM Recipes r " +
                     "LEFT JOIN Categories c ON r.category_id = c.category_id " +
                     "LEFT JOIN Users u ON r.created_by = u.user_id " +
                     "WHERE r.recipe_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recipeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractRecipeFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Lấy recipes theo category
     */
    public List<Recipe> getRecipesByCategory(int categoryId) {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as created_by_name " +
                     "FROM Recipes r " +
                     "LEFT JOIN Categories c ON r.category_id = c.category_id " +
                     "LEFT JOIN Users u ON r.created_by = u.user_id " +
                     "WHERE r.category_id = ? AND r.is_active = 1 " +
                     "ORDER BY r.created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    /**
     * Tìm kiếm recipes theo tên
     */
    public List<Recipe> searchRecipes(String keyword) {
        List<Recipe> recipes = new ArrayList<>();
        String sql = "SELECT r.*, c.category_name, u.full_name as created_by_name " +
                     "FROM Recipes r " +
                     "LEFT JOIN Categories c ON r.category_id = c.category_id " +
                     "LEFT JOIN Users u ON r.created_by = u.user_id " +
                     "WHERE r.is_active = 1 AND " +
                     "(r.recipe_name LIKE ? OR r.description LIKE ?) " +
                     "ORDER BY r.created_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                recipes.add(extractRecipeFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return recipes;
    }
    
    /**
     * Thêm recipe mới
     */
    public boolean addRecipe(Recipe recipe) {
        String sql = "INSERT INTO Recipes (recipe_name, description, ingredients, instructions, " +
                     "cooking_time, servings, difficulty, image_url, category_id, created_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, recipe.getRecipeName());
            ps.setString(2, recipe.getDescription());
            ps.setString(3, recipe.getIngredients());
            ps.setString(4, recipe.getInstructions());
            ps.setInt(5, recipe.getCookingTime());
            ps.setInt(6, recipe.getServings());
            ps.setString(7, recipe.getDifficulty());
            ps.setString(8, recipe.getImageUrl());
            ps.setInt(9, recipe.getCategoryId());
            ps.setInt(10, recipe.getCreatedBy());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Cập nhật recipe
     */
    public boolean updateRecipe(Recipe recipe) {
        String sql = "UPDATE Recipes SET recipe_name = ?, description = ?, ingredients = ?, " +
                     "instructions = ?, cooking_time = ?, servings = ?, difficulty = ?, " +
                     "image_url = ?, category_id = ?, updated_date = GETDATE() " +
                     "WHERE recipe_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, recipe.getRecipeName());
            ps.setString(2, recipe.getDescription());
            ps.setString(3, recipe.getIngredients());
            ps.setString(4, recipe.getInstructions());
            ps.setInt(5, recipe.getCookingTime());
            ps.setInt(6, recipe.getServings());
            ps.setString(7, recipe.getDifficulty());
            ps.setString(8, recipe.getImageUrl());
            ps.setInt(9, recipe.getCategoryId());
            ps.setInt(10, recipe.getRecipeId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Xóa recipe (soft delete)
     */
    public boolean deleteRecipe(int recipeId) {
        String sql = "UPDATE Recipes SET is_active = 0 WHERE recipe_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, recipeId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Extract Recipe object từ ResultSet
     */
    private Recipe extractRecipeFromResultSet(ResultSet rs) throws SQLException {
        Recipe recipe = new Recipe();
        recipe.setRecipeId(rs.getInt("recipe_id"));
        recipe.setRecipeName(rs.getString("recipe_name"));
        recipe.setDescription(rs.getString("description"));
        recipe.setIngredients(rs.getString("ingredients"));
        recipe.setInstructions(rs.getString("instructions"));
        recipe.setCookingTime(rs.getInt("cooking_time"));
        recipe.setServings(rs.getInt("servings"));
        recipe.setDifficulty(rs.getString("difficulty"));
        recipe.setImageUrl(rs.getString("image_url"));
        recipe.setCategoryId(rs.getInt("category_id"));
        recipe.setCategoryName(rs.getString("category_name"));
        recipe.setCreatedBy(rs.getInt("created_by"));
        recipe.setCreatedByName(rs.getString("created_by_name"));
        recipe.setCreatedDate(rs.getDate("created_date"));
        recipe.setUpdatedDate(rs.getDate("updated_date"));
        recipe.setActive(rs.getBoolean("is_active"));
        return recipe;
    }
}


