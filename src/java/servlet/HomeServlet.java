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
import java.util.List;
import model.Category;
import model.Recipe;

/**
 *
 * @author Tarooo
 */
public class HomeServlet extends HttpServlet {
   
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
            out.println("<title>Servlet HomeServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeServlet at " + request.getContextPath () + "</h1>");
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
        System.out.println("\n[HomeServlet] Loading home page...");
        System.out.println("Connecting to database to fetch recipes...");
        
        RecipeDAO recipeDAO = new RecipeDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        // Lấy parameter tìm kiếm và category
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        
        List<Recipe> recipes;
        
        // Tìm kiếm hoặc lọc theo category
        if (keyword != null && !keyword.trim().isEmpty()) {
            recipes = recipeDAO.searchRecipes(keyword.trim());
            request.setAttribute("keyword", keyword);
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                recipes = recipeDAO.getRecipesByCategory(categoryId);
                request.setAttribute("selectedCategoryId", categoryId);
            } catch (NumberFormatException e) {
                recipes = recipeDAO.getAllRecipes();
            }
        } else {
            recipes = recipeDAO.getAllRecipes();
        }
        
        // Lấy danh sách categories
        List<Category> categories = categoryDAO.getAllCategories();
        
        System.out.println("Found " + recipes.size() + " recipes");
        System.out.println("Rendering home.jsp...\n");
        
        request.setAttribute("recipes", recipes);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("home.jsp").forward(request, response);
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
        doGet(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
