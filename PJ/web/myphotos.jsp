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
    <title>My Photos</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/myphotos.css" rel="stylesheet" type="text/css">
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
        <h2>My Photos</h2>
    </div>
    <div id="div-main">
        <%
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
            int uid = dao.getForValue(sql,cookieUsernameValue);
            session.setAttribute("UID",uid);

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            try{
                connection = JDBCTools.getConnection();
                sql = "SELECT ImageID FROM travelimage WHERE UID=?";
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
                <img src='img/large/<%=picProperties.getPath()%>' alt='' class='img-favorites'></a>
                <div class='description'><h3><%=picProperties.getTitle()%></h3><span><%=picProperties.getDescription()%></span><br>
                <form action='${pageContext.request.contextPath}/myPhotosModifyServlet?id=<%=picProperties.getImageID()%>' method='post' role='form'><input type='submit' value='Modify' class='modify'></form>
                <form action='${pageContext.request.contextPath}/myPhotosDeleteServlet?id=<%=picProperties.getImageID()%>' method='post' role='form'><input type='submit' value='Delete' class='delete'></form>
                </div>
        </div>
        <%
                }
                if(!run){
                    out.print("<div class='div-favorites'><h1>您还未上传图片！赶快前往上传页面上传一张吧！</h1></div>");
                }

                //*****分页 打印下方页码链接*****
                PagesProperties pagesProperties = new PagesProperties();
                out.print(pagesProperties.getPrintPagesString(6, i));

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JDBCTools.releaseDB(resultSet, preparedStatement, connection);
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

    //确认是否删除
    $(function(){
       $(".delete").click(function(){
           let content = $(this).parent().parent().find("h3:eq(0)").text();
           let flag = confirm("确定要删 \"" + content + "\" 这张照片吗？");
           return flag;
       });
    });
</script>
</html>