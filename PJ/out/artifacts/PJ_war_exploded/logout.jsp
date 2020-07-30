<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 2020/7/24
  Time: 17:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logging Out...</title>
</head>
<body>
<%
    Cookie cookie = new Cookie("username", null);
    cookie.setMaxAge(0);
    response.addCookie(cookie);
    /*
    Cookie [] cookies = request.getCookies();
    String cookieName = "";
    if (cookies != null && cookies.length > 0){
        for(Cookie cookie: cookies){
            cookieName = cookie.getName();
            if(cookieName.equals("username")){
                cookie.setValue(null);
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);
                break;
            }
        }
    }*/
%>
<p style="text-align: center; margin-top: 30px;">
    已退出登录！<br>
    三秒钟后自动跳转至首页！<br><br>
    如果没有跳转，请点击<a href="index.jsp">这里</a>！
    <span><meta http-equiv="refresh" content="3;URL=index.jsp"></span>
</body>
</html>
