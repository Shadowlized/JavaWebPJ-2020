<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/login.css" rel="stylesheet" type="text/css">
</head>
<body>
    <header>
        <img src="img/avatar.jpg" alt="" class="avatar">
        <h1>Login to Fisher</h1>
    </header>
    <section>
        <%
            Cookie [] cookies = request.getCookies();
            String cookieName = ""; String cookieValueU = ""; String cookieValueP = "";
            if (cookies != null && cookies.length > 0){
                for(Cookie cookie: cookies){
                    cookieName = cookie.getName();
                    if(cookieName.equals("usernameForm")){
                        cookieValueU = cookie.getValue();
                    }
                    if(cookieName.equals("passwordForm")){
                        cookieValueP = cookie.getValue();
                    }
                }
            }
        %>
        <font color="red">
            <%= session.getAttribute("message") == null ? "" : session.getAttribute("message") %><%session.setAttribute("message",null);%>
        </font>
        <form action='<%= request.getContextPath() %>/loginServlet' method='post' role='form'>
            <h2>Username/Email:</h2>
            <p>
                <input type="text" name="username" id="username" value="<%= cookieValueU %>" required>
            </p>
            <h2>Password:</h2>
            <p>
                <input type="password" name="password" id="password" value="<%= cookieValueP %>" required>
            </p>
            <h2>Captcha:</h2>
            <p>
                <input type="text" name="CHECK_CODE_PARAM_NAME" id="captcha" required>
                <img alt="" width="80px" src="<%= request.getContextPath() %>/validateColorServlet" >
            </p>
            <p>
                <input type="submit" value="Login" id="login-submit">
            </p>
        </form>
    </section>
    <p id="register-link">New to Fisher? <a href="register.jsp">Create a new account!</a></p>
    <p class="register-link2"><a href="index.jsp">Homepage</a></p>
    <footer>
        Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
    </footer>
</body>
</html>