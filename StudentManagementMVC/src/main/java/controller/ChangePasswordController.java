package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate current password
        if (!BCrypt.checkpw(currentPassword, user.getPassword())) {
            request.setAttribute("error", "Current password is incorrect!");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        // Validate new password
        if (newPassword.length() < 8) {
            request.setAttribute("error", "New password must be at least 8 characters!");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password does not match!");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        // Hash new password
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Update in DB
        userDAO.updatePassword(user.getId(), hashedNewPassword);

        request.setAttribute("success", "Password changed successfully!");
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }
}
