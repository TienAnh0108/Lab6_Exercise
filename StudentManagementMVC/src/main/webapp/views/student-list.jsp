<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Student List - MVC</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            }

            h1 {
                color: #333;
                margin-bottom: 10px;
                font-size: 32px;
            }

            .subtitle {
                color: #666;
                margin-bottom: 30px;
                font-style: italic;
            }

            .message {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                font-weight: 500;
            }

            .success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .btn {
                display: inline-block;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: 500;
                transition: all 0.3s;
                border: none;
                cursor: pointer;
                font-size: 14px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }

            .btn-danger {
                background-color: #dc3545;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
            }

            .btn-danger:hover {
                background-color: #c82333;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            th {
                font-weight: 600;
                text-transform: uppercase;
                font-size: 13px;
                letter-spacing: 0.5px;
            }

            tbody tr {
                transition: background-color 0.2s;
            }

            tbody tr:hover {
                background-color: #f8f9fa;
            }

            .actions {
                display: flex;
                gap: 10px;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #999;
            }

            .empty-state-icon {
                font-size: 64px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <h1>📚 Student Management System</h1>
            <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>
            <div class="navbar-right">
                <div class="user-info">
                    <span>Welcome, ${sessionScope.fullName}</span>
                    <span class="role-badge role-${sessionScope.role}">
                        ${sessionScope.role}
                    </span>
                </div>
                <a href="dashboard" class="btn-nav">Dashboard</a>
                <a href="logout" class="btn-logout">Logout</a>
            </div>
        </div>
        <div class="container">
            <!-- Success Message -->
            <c:if test="${not empty param.message}">
                <div class="message success">
                    ✅ ${param.message}
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty param.error}">
                <div class="message error">
                    ❌ ${param.error}
                </div>
            </c:if>

            <!-- Add New Student Button -->
            <div style="margin-bottom: 20px;">
                <a href="student?action=new" class="btn btn-primary">
                    ➕ Add New Student
                </a>
            </div>

            <!-- Search Box -->
            <div style="margin-bottom: 20px;">
                <form action="student" method="get" 
                      style="display: flex; gap: 10px; align-items: center;">

                    <!-- Hidden action field -->
                    <input type="hidden" name="action" value="search">

                    <!-- Search input -->
                    <input type="text" 
                           name="keyword" 
                           placeholder="Search by code, name or email..."
                           value="${keyword}"
                           style="padding: 10px; width: 260px; border-radius: 5px; border: 1px solid #ccc;">

                    <!-- Search button -->
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px;">
                        🔍 Search
                    </button>

                    <!-- Clear btn (only show when searching) -->
                    <c:if test="${not empty keyword}">
                        <a href="student?action=list" 
                           class="btn btn-secondary"
                           style="padding: 10px 20px;">
                            Clear
                        </a>
                    </c:if>

                </form>
            </div>

            <!-- Search result message -->
            <c:if test="${not empty keyword}">
                <p class="subtitle" style="margin-bottom: 20px;">
                    Search results for: <strong>${keyword}</strong>
                </p>
            </c:if>

            <!-- Student Table -->
            <!-- ======================= FILTER MAJOR ======================= -->
            <div style="margin-bottom: 20px;">
                <form action="student" method="get" 
                      style="display: flex; gap: 10px; align-items: center;">

                    <input type="hidden" name="action" value="filter">

                    <label style="color:#333; font-weight:600;">Filter by Major:</label>

                    <select name="major"
                            style="padding: 10px; border-radius: 5px; border:1px solid #ccc;">
                        <option value="">All Majors</option>

                        <option value="Computer Science"
                                ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
                            Computer Science
                        </option>
                        <option value="Information Technology"
                                ${selectedMajor == 'Information Technology' ? 'selected' : ''}>
                            Information Technology
                        </option>
                        <option value="Software Engineering"
                                ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>
                            Software Engineering
                        </option>
                        <option value="Business Administration"
                                ${selectedMajor == 'Business Administration' ? 'selected' : ''}>
                            Business Administration
                        </option>
                    </select>

                    <button class="btn btn-primary">Apply</button>

                    <c:if test="${not empty selectedMajor}">
                        <a href="student?action=list" class="btn btn-secondary">Clear</a>
                    </c:if>
                </form>
            </div>

            <!-- ======================= SORT + TABLE ======================= -->

            <c:set var="reverseOrder" value="${order == 'asc' ? 'desc' : 'asc'}" />

            <c:choose>
                <c:when test="${not empty students}">
                    <table>
                        <thead>
                            <tr>
                                <!-- SORTABLE: ID -->
                                <th>
                                    <a href="student?action=sort&sortBy=id&order=${reverseOrder}"
                                       style="color:white; text-decoration:none;">
                                        ID
                                    </a>
                                    <c:if test="${sortBy == 'id'}">
                                        <span>${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </th>

                                <!-- SORTABLE: CODE -->
                                <th>
                                    <a href="student?action=sort&sortBy=student_code&order=${reverseOrder}"
                                       style="color:white; text-decoration:none;">
                                        Student Code
                                    </a>
                                    <c:if test="${sortBy == 'student_code'}">
                                        <span>${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </th>

                                <!-- SORTABLE: NAME -->
                                <th>
                                    <a href="student?action=sort&sortBy=full_name&order=${reverseOrder}"
                                       style="color:white; text-decoration:none;">
                                        Full Name
                                    </a>
                                    <c:if test="${sortBy == 'full_name'}">
                                        <span>${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </th>

                                <!-- SORTABLE: EMAIL -->
                                <th>
                                    <a href="student?action=sort&sortBy=email&order=${reverseOrder}"
                                       style="color:white; text-decoration:none;">
                                        Email
                                    </a>
                                    <c:if test="${sortBy == 'email'}">
                                        <span>${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </th>

                                <!-- SORTABLE: MAJOR -->
                                <th>
                                    <a href="student?action=sort&sortBy=major&order=${reverseOrder}"
                                       style="color:white; text-decoration:none;">
                                        Major
                                    </a>
                                    <c:if test="${sortBy == 'major'}">
                                        <span>${order == 'asc' ? '▲' : '▼'}</span>
                                    </c:if>
                                </th>

                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="student" items="${students}">
                                <tr>
                                    <td>${student.id}</td>
                                    <td><strong>${student.studentCode}</strong></td>
                                    <td>${student.fullName}</td>
                                    <td>${student.email}</td>
                                    <td>${student.major}</td>
                                    <td>
                                        <div class="actions">
                                            <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                                ✏️ Edit
                                            </a>
                                            <a href="student?action=delete&id=${student.id}"
                                               class="btn btn-danger"
                                               onclick="return confirm('Are you sure?')">
                                                🗑️ Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">📭</div>
                        <h3>No students found</h3>
                        <p>Start by adding a new student</p>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </body>
</html>
