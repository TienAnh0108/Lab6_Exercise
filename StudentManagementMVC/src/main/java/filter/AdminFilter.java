package filter;

import model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AdminFilter", urlPatterns = {"/student"})
public class AdminFilter implements Filter {

    // Admin-only actions
    private static final String[] ADMIN_ACTIONS = {
        "new",
        "insert",
        "edit",
        "update",
        "delete"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AdminFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Get the requested action
        String action = req.getParameter("action");

        // If action requires admin role
        if (isAdminAction(action)) {

            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            // Kiểm tra user có phải admin không
            if (user != null && user.isAdmin()) {
                chain.doFilter(request, response);  // cho phép
            } else {
                // Chặn và báo lỗi
                req.setAttribute("error", "You do not have permission to perform this action.");
                req.getRequestDispatcher("error.jsp").forward(req, resp);
            }

        } else {
            // Action không yêu cầu admin → cho phép
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        System.out.println("AdminFilter destroyed.");
    }

    // Check if action matches any admin action
    private boolean isAdminAction(String action) {
        if (action == null) return false;
        for (String adminAction : ADMIN_ACTIONS) {
            if (adminAction.equalsIgnoreCase(action)) {
                return true;
            }
        }
        return false;
    }
}
