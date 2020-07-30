<%@ page import="com.PicProperties" %>
<%@ page import="com.DAO" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.JDBCTools" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.CommentsProperties" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Details</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/details.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        #magnifier{
            width:420px;
            height:300px;
            position:absolute;
            top:210px;
            left:160px;
            font-size:0;
            border:8px solid #ed7100;
            border-radius: 20px;
        }
        #img{
            width:420px;
            height:300px;
        }
        #Browser{
            z-index:100;
            position:absolute;
            background:#555;
        }
        #mag{
            overflow:hidden;
            z-index:100;
        }
    </style>
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

<section style="height: 630px;">
    <div class="div-title">
        <h2>Details</h2>
    </div>
    <div id="div-main">
        <%
            int imageId =  Integer.parseInt(request.getParameter("id"));
            PicProperties currentPic = new PicProperties();
            currentPic.setPicProperties(imageId);
        %>
        <h1><%=currentPic.getTitle()%><span id="author">&nbsp;&nbsp;By <%=currentPic.getUsername()%> <%=currentPic.getUploadDate()/10000%>-<%=(currentPic.getUploadDate()-(currentPic.getUploadDate()/10000)*10000)/100%>-<%=currentPic.getUploadDate()%100%></span></h1>
        <div id="magnifier">
            <img src="img/large/<%=currentPic.getPath()%>" alt="" id="img">
            <div id="Browser"></div>
        </div>
        <div id="mag"><img id="magnifierImg"></div>
        <div class="div-right">
            <div class="div-small">
                <h3>Likes</h3>
                <h4><%=currentPic.getFavoriteCount(imageId)%></h4>
            </div>
            <div class="div-small">
                <h3>Image Details</h3>
                <p>Content: <%=currentPic.getContent()%></p>
                <p>Country: <%=currentPic.getCountry()%></p>
                <p>City: <%=currentPic.getCity()%></p>
            </div>
            <%
                Cookie [] cookies = request.getCookies();
                String cookieName = ""; String cookieUsernameValue = "";

                List<Cookie> detailsCookies = new ArrayList<Cookie>();
                Cookie tempCookie = null;

                if (cookies != null && cookies.length > 0){
                    for(Cookie cookie: cookies){
                        cookieName = cookie.getName();
                        if(cookieName.equals("username")){
                            cookieUsernameValue = cookie.getValue();
                        }
                        //用于历史足迹
                        if(cookieName.startsWith("DETAILS_ID_")){
                            detailsCookies.add(cookie);
                            if(cookie.getName().equals("DETAILS_ID_"+imageId)){
                                tempCookie = cookie;
                            }
                        }
                    }
                }
                if (detailsCookies.size() >= 10 && tempCookie == null){
                    tempCookie = detailsCookies.get(0);
                }
                if (tempCookie != null){
                    tempCookie.setMaxAge(0);
                    response.addCookie(tempCookie);
                }

                String temp = imageId + "a";
                temp = temp.replace("a","");
                Cookie cookie = new Cookie("DETAILS_ID_" + imageId, temp);
                response.addCookie(cookie);

                DAO dao = new DAO();
                Connection connection = null;
                PreparedStatement preparedStatement = null;
                ResultSet resultSet = null;


                if(!"".equals(cookieUsernameValue)){
                String sql = "SELECT UID FROM traveluser WHERE UserName=?";
                int userUID = dao.getForValue(sql,cookieUsernameValue);
                session.setAttribute("ImageID",imageId); //传递给servlet，以供删除收藏操作
                session.setAttribute("UID",userUID);


                boolean isFavorited = false;
                try{
                    connection = JDBCTools.getConnection();
                    sql = "SELECT * FROM travelimagefavor WHERE ImageID=? AND UID=?";
                    preparedStatement = connection.prepareStatement(sql);
                    preparedStatement.setInt(1,imageId);
                    preparedStatement.setInt(2,userUID);
                    resultSet = preparedStatement.executeQuery();
                    while(resultSet.next()){
                        isFavorited = true;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    JDBCTools.releaseDB(resultSet, preparedStatement, connection);
                }
            if(isFavorited){
            %>
            <form action="<%= request.getContextPath() %>/favoriteDeleteServlet" method='post' role='form'><input type="submit" value="× Remove from Favorites" class="favorite"></form>
            <%
                } else {
            %>
            <form action="<%= request.getContextPath() %>/favoriteAddServlet" method='post' role='form'><input type="submit" value="❤ Favorite" class="favorite"></form>
            <%
                }
                }
            %>

        </div>
        <div class="description">
            <b>Description:&nbsp;&nbsp;&nbsp;&nbsp;</b><%=currentPic.getDescription()%>
        </div>
    </div>
</section>

<section>
    <div class="div-title">
        <h2>Comments (by pop and time)</h2>
    </div>
    <%
        connection = null;
        preparedStatement = null;
        resultSet = null;
        boolean commented = false;
        try {
            connection = JDBCTools.getConnection();

            String sql = "SELECT * FROM travelcomments WHERE UserName=? AND ImageID=?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, cookieUsernameValue);
            preparedStatement.setInt(2, imageId);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                commented = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }

        if(!commented && !"".equals(cookieUsernameValue)){
    %>
    <div class="comment-post-div">
        <%
            session.setAttribute("commentUsername",cookieUsernameValue);
            session.setAttribute("currentImageID",imageId);
        %>
        <form action="<%= request.getContextPath() %>/commentServlet" method='post' role='form'>
            <textarea name="comment-box" id="comment-box"></textarea>
            <input type="submit" value="Comment" width="80px" style="margin-bottom: 30px;margin-right: 30px;height: 20px;">
        </form>
    </div>
    <%
        }
        connection = null;
        preparedStatement = null;
        resultSet = null;
        try{
            connection = JDBCTools.getConnection();

            String sql = "SELECT UserName FROM travelcomments WHERE ImageID=? ORDER BY Likes DESC, DateTime DESC";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setInt(1,imageId);
            resultSet = preparedStatement.executeQuery();

            boolean run = false;

            while(resultSet.next()){
                run = true;

                CommentsProperties commentsProperties = new CommentsProperties();
                Object currentUsername = resultSet.getObject(1);
                commentsProperties.setCommentProperties(imageId,(String)currentUsername);
                session.setAttribute("currentImageID",imageId);
    %>
    <div class="div-favorites">
        <h1 style="display: inline-block;float:left;margin-left:50px;color:#555;">Username: <font color="#ed7100"> <%=commentsProperties.getUsername()%></font></h1>
        <h1 style="display: inline-block;float:right;margin-right: 30px;color:#555;">DateTime: <font color="#ed7100"><%=commentsProperties.getDateTime()%></font> &nbsp;&nbsp;&nbsp;&nbsp; Likes: <font color="#ed7100"><%=commentsProperties.getLikes()%></font></h1>
        <div class="comments"><%=commentsProperties.getComment()%></div>
        <form action="<%= request.getContextPath() %>/likeAddServlet" method='post' role='form'><input type="hidden" name="username" value="<%=commentsProperties.getUsername()%>"><input type="submit" value="Like +1" class="like-button"></form>
    </div>
    <%
            }
            if(!run){
                out.print("<div class='div-favorites'><h1 style=\"color:#555;margin-top:40px;\">暂时还无人评论，赶快发表一条吧！</h1></div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }
    %>
</section>

<footer>
    Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
</footer>
</body>
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/magnify.js"></script>
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