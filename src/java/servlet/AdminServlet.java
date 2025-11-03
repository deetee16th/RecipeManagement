/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package servlet;

import dao.CategoryDAO;
import dao.RecipeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Recipe;
import model.User;

/**
 *
 * @author Tarooo
 */
public class AdminServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            response.sendRedirect("home");
            return;
        }
        
        // Lấy action
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteRecipe(request, response);
                break;
            default:
                listRecipes(request, response);
                break;
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addRecipe(request, response);
        } else if ("edit".equals(action)) {
            updateRecipe(request, response);
        } else {
            doGet(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    private void listRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RecipeDAO recipeDAO = new RecipeDAO();
        List<Recipe> recipes = recipeDAO.getAllRecipesForAdmin();
        request.setAttribute("recipes", recipes);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("recipe-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recipeIdStr = request.getParameter("id");
        if (recipeIdStr != null) {
            try {
                int recipeId = Integer.parseInt(recipeIdStr);
                RecipeDAO recipeDAO = new RecipeDAO();
                CategoryDAO categoryDAO = new CategoryDAO();
                
                Recipe recipe = recipeDAO.getRecipeById(recipeId);
                List<Category> categories = categoryDAO.getAllCategories();
                
                request.setAttribute("recipe", recipe);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("recipe-form.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
            }
        }
        response.sendRedirect("admin");
    }
    
    private void addRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        Recipe recipe = new Recipe();
        recipe.setRecipeName(request.getParameter("recipeName"));
        recipe.setDescription(request.getParameter("description"));
        recipe.setIngredients(request.getParameter("ingredients"));
        recipe.setInstructions(request.getParameter("instructions"));
        recipe.setCookingTime(Integer.parseInt(request.getParameter("cookingTime")));
        recipe.setServings(Integer.parseInt(request.getParameter("servings")));
        recipe.setDifficulty(request.getParameter("difficulty"));
        recipe.setImageUrl(request.getParameter("imageUrl"));
        recipe.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        recipe.setCreatedBy(user.getUserId());
        
        RecipeDAO recipeDAO = new RecipeDAO();
        if (recipeDAO.addRecipe(recipe)) {
            response.sendRedirect("admin?success=add");
        } else {
            request.setAttribute("error", "Thêm công thức thất bại!");
            showAddForm(request, response);
        }
    }
    
    private void updateRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Recipe recipe = new Recipe();
        recipe.setRecipeId(Integer.parseInt(request.getParameter("recipeId")));
        recipe.setRecipeName(request.getParameter("recipeName"));
        recipe.setDescription(request.getParameter("description"));
        recipe.setIngredients(request.getParameter("ingredients"));
        recipe.setInstructions(request.getParameter("instructions"));
        recipe.setCookingTime(Integer.parseInt(request.getParameter("cookingTime")));
        recipe.setServings(Integer.parseInt(request.getParameter("servings")));
        recipe.setDifficulty(request.getParameter("difficulty"));
        recipe.setImageUrl(request.getParameter("imageUrl"));
        recipe.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        
        RecipeDAO recipeDAO = new RecipeDAO();
        if (recipeDAO.updateRecipe(recipe)) {
            response.sendRedirect("admin?success=update");
        } else {
            request.setAttribute("error", "Cập nhật công thức thất bại!");
            showEditForm(request, response);
        }
    }
    
    private void deleteRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recipeIdStr = request.getParameter("id");
        if (recipeIdStr != null) {
            try {
                int recipeId = Integer.parseInt(recipeIdStr);
                RecipeDAO recipeDAO = new RecipeDAO();
                recipeDAO.deleteRecipe(recipeId);
            } catch (NumberFormatException e) {
            }
        }
        response.sendRedirect("admin?success=delete");
    }
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
