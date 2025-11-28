<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
</head>
<body>

<h2>? Change Password</h2>

<c:if test="${not empty error}">
    <div style="color:red;">${error}</div>
</c:if>

<c:if test="${not empty success}">
    <div style="color:green;">${success}</div>
</c:if>

<form action="change-password" method="post">

    <input type="password" name="currentPassword" placeholder="Current Password" required><br><br>
    <input type="password" name="newPassword" placeholder="New Password" required><br><br>
    <input type="password" name="confirmPassword" placeholder="Confirm Password" required><br><br>

    <button type="submit">Change Password</button>
</form>

</body>
</html>
