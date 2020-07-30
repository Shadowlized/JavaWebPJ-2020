<%@ page import="com.DAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.JDBCTools" %>
<%@ page import="com.PicProperties" %>
<%@ page import="java.util.List" %>
<%@ page import="com.mysql.jdbc.ResultSetMetaData" %>
<%@ page import="com.PagesProperties" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Favorites</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/favorites.css" rel="stylesheet" type="text/css">
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
        <%
            String friendUID = request.getParameter("uid");
            String friendName = "";
            boolean friendPermits = true;
            if(friendUID == null){
        %>
        <h2>My Favorites</h2>
        <%
            } else {
                DAO dao = new DAO();
                String sql = "SELECT UserName FROM traveluser WHERE UID=?";
                friendName = dao.getForValue(sql,friendUID);
                sql = "SELECT PermitVisit FROM traveluser WHERE UID=?";
                int judge = (Integer)dao.getForValue(sql,friendUID);
                if(judge == 1)
                    friendPermits = true;
                else
                    friendPermits = false;

        %>
        <h2><%=friendName%>'s Favorites</h2>
        <% } %>
    </div>
    <div id="div-main">
        <%
            if(friendUID == null){
        %>
        <div class="div-favorites-footprints">
            <h2>My Footprints<span id="footprint-span">
            <%
                Cookie [] cookies = request.getCookies();
                if(cookies != null && cookies.length > 0){
                    DAO dao = new DAO();
                    for(Cookie c: cookies){
                        String cookieName = c.getName();
                        if(cookieName.startsWith("DETAILS_ID_")){
                            String imageID = c.getValue();
                            String sql = "SELECT Title FROM travelimage WHERE ImageID=?";
                            String title = dao.getForValue(sql,imageID);
                            out.print("<a href='details.jsp?id="+imageID+"'>"+title+"</a>&nbsp;&nbsp;|&nbsp;&nbsp;");
                        }
                    }
                }
            %>
        </span></h2>
        </div>
        <%  }
        if(friendUID == null || friendPermits){
            Cookie[] cookies = request.getCookies();
            String cookieName = ""; String cookieUsernameValue = "";
            if (cookies != null && cookies.length > 0){
                for(Cookie cookie: cookies){
                    cookieName = cookie.getName();
                    if(cookieName.equals("username")){
                        cookieUsernameValue = cookie.getValue();
                        session.setAttribute("username",cookieUsernameValue);
                    }
                }
            }

            DAO dao = new DAO();
            String sql = "SELECT UID FROM traveluser WHERE UserName=?";

            int uid = 0;
            if(friendUID == null){
                uid = dao.getForValue(sql,cookieUsernameValue);
            } else {
                uid = dao.getForValue(sql,friendName);
            }

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            try{
                connection = JDBCTools.getConnection();
                sql = "SELECT ImageID FROM travelimagefavor WHERE UID=?";
                preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1,uid);
                resultSet = preparedStatement.executeQuery();

                boolean run = false;

                int i = 0;//i即图片个数
                while(resultSet.next()){
                    run = true;

                    PicProperties picProperties = new PicProperties();
                    Object currentImageID = resultSet.getObject(1);
                    picProperties.setPicProperties((Integer)currentImageID);
                    i++;
                %>
                    <div class="div-favorites" id="id<%=i%>">
                        <a href='details.jsp?id=<%=picProperties.getImageID()%>'>
                            <img src='img/normal-medium/<%=picProperties.getPath()%>' alt='' class='img-favorites'></a>
                            <div class='description'><h3><%=picProperties.getTitle()%></h3><span><%=picProperties.getDescription()%></span><br>
                            <% if(friendUID == null){%>
                                <form action='${pageContext.request.contextPath}/favoritesDeleteServlet?id=<%=picProperties.getImageID()%>' method='post' role='form'><input type='submit' value='Remove' class='remove'></form>
                            <% } %>
                            </div>
                    </div>
                <%
                }
                if(!run){
                    if (friendUID == null) {
                        out.print("<div class='div-favorites'><h1>您还未添加图片至收藏夹！</h1></div>");
                    } else {
                        out.print("<div class='div-favorites'><h1>您的好友 "+ friendName +" 还未添加图片至收藏夹！</h1></div>");
                    }
                }

                //*****分页 打印下方页码链接*****
                PagesProperties pagesProperties = new PagesProperties();
                out.print(pagesProperties.getPrintPagesString(6, i));

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JDBCTools.releaseDB(resultSet, preparedStatement, connection);
            }
         } else {
                    out.print("<div class='div-favorites'><h1>您的好友 "+ friendName +" 设置了好友访问权限！</h1></div>");
                }
        %>

    </div>
</section>

<footer>
    Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
</footer>
</body>
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/pages.js"></script>
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