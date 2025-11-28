package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    // Public URLs that do not require authentication
    private static final String[] PUBLIC_URLS = {
        "/login",
        "/logout",
        ".css",
        ".js",
        ".png",
        ".jpg"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // Cast to HTTP request/response
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get full request URI and context path
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        // Remove context path to get actual path
        String path = uri.substring(contextPath.length());

        // 1. Allow public URLs
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Check if user is logged in
        HttpSession session = httpRequest.getSession(false); // do NOT create session

        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        if (loggedIn) {
            // User authenticated → continue request
            chain.doFilter(request, response);
        } else {
            // User NOT logged in → redirect to login page
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        System.out.println("AuthFilter destroyed");
    }

    // Helper: Check if URL is public
    private boolean isPublicUrl(String path) {
        for (String publicUrl : PUBLIC_URLS) {
            if (path.contains(publicUrl)) {
                return true;
            }
        }
        return false;
    }
}
