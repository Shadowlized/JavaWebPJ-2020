<%@ page import="com.DAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.JDBCTools" %><%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 2020/7/12
  Time: 22:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Favorites</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/friendlist.css" rel="stylesheet" type="text/css">
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
        <h2>My Friends</h2>
    </div>
    <div id="div-main">
            <table>
                <tr>
                    <th>Username:</th>
                    <th>Email:</th>
                    <th>Registration Date:</th>
                </tr>
                <%
                    DAO dao = new DAO();
                    Connection connection = null;
                    PreparedStatement preparedStatement = null;
                    ResultSet resultSet = null;

                    try{
                        connection = JDBCTools.getConnection();
                        String sql = "SELECT UID FROM traveluser";
                        preparedStatement = connection.prepareStatement(sql);
                        resultSet = preparedStatement.executeQuery();
                        int j = 0;//j即用户个数
                        while(resultSet.next()){
                            j++;
                        }
                        int [] uidArray = new int[j];
                        sql = "SELECT UID FROM traveluser";
                        preparedStatement = connection.prepareStatement(sql);
                        resultSet = preparedStatement.executeQuery();
                        int k = 0;
                        while(resultSet.next()){
                            uidArray[k] = (Integer)resultSet.getObject(1);
                            k++;
                        }
                        for (int i = 0; i < j ; i++){
                            sql = "SELECT UserName FROM traveluser WHERE UID=?";
                            String friendName = dao.getForValue(sql,uidArray[i]);
                            sql = "SELECT Email FROM traveluser WHERE UID=?";
                            String friendEmail = dao.getForValue(sql,uidArray[i]);
                            sql = "SELECT DateJoined FROM traveluser WHERE UID="+uidArray[i];
                            preparedStatement = connection.prepareStatement(sql);
                            resultSet = preparedStatement.executeQuery();
                            Object friendDate = null;
                            while(resultSet.next()){
                                friendDate = resultSet.getObject(1);
                            }
                            out.print("<tr><td><a href='favorites.jsp?uid=" + uidArray[i] + "'>" + friendName + "</a></td>"+
                                    "<td><a href='favorites.jsp?uid=" + uidArray[i] + "'>" + friendEmail + "</td>" +
                                    "<td>" + friendDate + "</td>" +
                                    "</tr>");
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        JDBCTools.releaseDB(resultSet, preparedStatement, connection);
                    }
                %>

            </table>
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
