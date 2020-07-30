<%@ page import="com.PagesProperties" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/search.css" rel="stylesheet" type="text/css">
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

<section class="search">
    <div class="div-title">
        <h2>Search</h2>
    </div>
    <div class="div-favorites-bottom" id="search-div">
        <form action='<%= request.getContextPath() %>/searchServlet' method='post' role='form'>
        <div class="search-div-2">
            <input type="radio" value="filter-title" class="radio" name="filterTC" checked>&nbsp;Filter by Title<br>
            <input type="radio" value="filter-content" class="radio" name="filterTC">&nbsp;Filter by Content<br>
        </div>
        <div class="search-div-2">
            <input type="radio" value="filter-popularity" class="radio" name="filterPT" checked>&nbsp;List by Popularity<br>
            <input type="radio" value="filter-time" class="radio" name="filterPT">&nbsp;List by Time<br>
        </div>
        <textarea name="textarea" placeholder="Type here"></textarea><br>
        <div><input type="submit" value="Filter" class="filter-button"></div>
        </form>
    </div>
</section>

<section class="results">
    <div class="div-title">
        <h2>Results</h2>
    </div>
    <div id="div-main">
        <%
            String resultStr = (String) request.getAttribute("StrResultPrint");
            String i = (String)request.getAttribute("i");
            if(resultStr == null){
                out.print("<h1>Image Loading Area</h1>");
            } else {
                out.print(resultStr);
            }
            if(i != null){
                //*****分页 打印下方页码链接*****
                PagesProperties pagesProperties = new PagesProperties();
                out.print(pagesProperties.getPrintPagesString(8, Integer.parseInt(i))) ;
            }

        %>
    </div>
</section>

<footer>
    Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
</footer>
</body>
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/pages8.js"></script>
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