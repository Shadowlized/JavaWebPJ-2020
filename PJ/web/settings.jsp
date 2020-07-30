<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 2020/7/24
  Time: 17:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Settings</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/settings.css" rel="stylesheet" type="text/css">
</head>
<body>
<nav>
    <div class="div-left">
        <img src="img/avatar.jpg" alt="" id="avatar-nav" width="28px" height="28px">
        <a href="index.jsp" class="link" id="home-nav">Home</a>
        <a href="search.jsp" class="link" id="search-nav">Search</a>
    </div>
    <div class="dropdown">
        <div id="myAccount"></div>
    </div>
</nav>

<section>
    <div id="div-title">
        <h2>Permit Visit</h2>
    </div>
    <div id="div-main">
        <div class="div-favorites">
            <font color="blue">
                <span style="text-align: center; margin-left: 42%"><%= session.getAttribute("message") == null ? "设置收藏界面访问权限：" : session.getAttribute("message") %><%session.setAttribute("message",null);%></span>
            </font>
            <form action='<%= request.getContextPath() %>/settingsYServlet' method='post' role='form'><input type="submit" value="Yes" class="modify"></form>
            <form action='<%= request.getContextPath() %>/settingsNServlet' method='post' role='form'><input type="submit" value="No" class="delete"></form>
        </div>

    </div>
</section>

<footer>
    Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
</footer>
</body>
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/clickheart.js"></script>
<script>
    $(document).ready(function(){
        $.ajax({
            type: 'POST',
            url: "<%=application.getContextPath()%>/navDropdownServlet",
            async: false,
            success: function (data) {
                $('#myAccount').html(data);
            }
        })
    });
</script>
</html>
