<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.JDBCTools" %>
<%@ page import="com.DAO" %>
<%@ page import="com.PicProperties" %>
<%--
  Created by IntelliJ IDEA.
  User: pc
  Date: 2020/7/12
  Time: 20:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Homepage</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/index.css" rel="stylesheet" type="text/css">
</head>
<body>
    <a name="return-here"><nav>
        <div class="div-left">
            <img src="img/avatar.jpg" alt="" id="avatar-nav" width="28px" height="28px">
            <a href="index.jsp" class="link" id="home-nav">Home</a>
            <a href="search.jsp" class="link" id="search-nav">Search</a>
        </div>
        <div class="dropdown">
            <div id="myAccount"></div>
        </div>
    </nav></a>
    <header>
        <%
            //用于放置读出的五张头图的路径
            String [] pathArray = new String [5];
            int maxKey1 = 1; //假设第一张图片收藏数最多
            int maxKey2 = 2;
            int maxKey3 = 3;
            int maxKey4 = 4;
            int maxKey5 = 5;

            Connection connection = null;
            PreparedStatement preparedStatement = null;
            ResultSet resultSet = null;
            try{
                DAO dao = new DAO();
                connection = JDBCTools.getConnection();
                String sql = "SELECT Max(ImageID)ImageID FROM travelimage";
                int maxID = dao.getForValue(sql);
                //用于对每张图片收藏数计数
                int [] favoriteCountArray = new int [maxID+1];
                //收藏数与对应的图片id
                int max1 = favoriteCountArray[1];
                int max2 = favoriteCountArray[2];
                int max3 = favoriteCountArray[3];
                int max4 = favoriteCountArray[4];
                int max5 = favoriteCountArray[5];

                for(int i = 1; i <= maxID; i++){
                    sql = "SELECT * FROM travelimagefavor WHERE ImageID=" + i;
                    preparedStatement = connection.prepareStatement(sql);
                    resultSet = preparedStatement.executeQuery();
                    while(resultSet.next()){
                        favoriteCountArray[i]++;
                    }
                }


                for (int i = 1; i <= maxID; i++){
                    if (max1 < favoriteCountArray[i]){//数组中的元素跟sum比较，比sum大就把它赋值给sum作为新的比较值
                        max1 = favoriteCountArray[i];
                        maxKey1 = i;
                    }
                }
                for (int i = 1; i <= maxID; i++){
                    if (max2 < favoriteCountArray[i] && (i != maxKey1)){
                        max2 = favoriteCountArray[i];
                        maxKey2 = i;
                    }
                }
                for (int i = 1; i <= maxID; i++){
                    if (max3 < favoriteCountArray[i] && (i != maxKey1) && (i != maxKey2)){
                        max3 = favoriteCountArray[i];
                        maxKey3 = i;
                    }
                }
                for (int i = 1; i <= maxID; i++){
                    if (max4 < favoriteCountArray[i] && (i != maxKey1) && (i != maxKey2) && (i != maxKey3)){
                        max4 = favoriteCountArray[i];
                        maxKey4 = i;
                    }
                }
                for (int i = 1; i <= maxID; i++){
                    if (max5 < favoriteCountArray[i] && (i != maxKey1) && (i != maxKey2) && (i != maxKey3) && (i != maxKey4)){
                        max5 = favoriteCountArray[i];
                        maxKey5 = i;
                    }
                }

                sql = "SELECT PATH FROM travelimage WHERE ImageID=?";
                pathArray[0] = dao.getForValue(sql,maxKey1);
                pathArray[1] = dao.getForValue(sql,maxKey2);
                pathArray[2] = dao.getForValue(sql,maxKey3);
                pathArray[3] = dao.getForValue(sql,maxKey4);
                pathArray[4] = dao.getForValue(sql,maxKey5);

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JDBCTools.releaseDB(resultSet, preparedStatement, connection);
            }
        %>
        <div id="div-header">
        <div class="container">
            <div class="wrap" style="left: 0;">
                <img src="img/large/<%=pathArray[0]%>" id="imgId" onclick=window.location.href="details.jsp?id=<%=maxKey1%>" alt="">
            </div>
            <div class="buttons">
                <span class="on" id="button1"></span>
                <span id="button2"></span>
                <span id="button3"></span>
                <span id="button4"></span>
                <span id="button5"></span>
            </div>
            <a href="javascript:" class="arrow arrow_left" id="prev"><b>&lt;</b></a>
            <a href="javascript:" class="arrow arrow_right" id="next"><b>&gt;</b></a>
        </div>
        </div>
    </header>

    <section>
        <table>
            <tr>
                <%
                    Connection connection2 = null;
                    PreparedStatement preparedStatement2 = null;
                    ResultSet resultSet2 = null;

                    try{
                        DAO dao = new DAO();
                        connection2 = JDBCTools.getConnection();
                        String sql = "SELECT ImageID FROM travelimage ORDER BY UploadDate DESC";
                        preparedStatement2 = connection2.prepareStatement(sql);
                        resultSet2 = preparedStatement2.executeQuery();

                        int i = 0;//i即图片个数
                        while(resultSet2.next() && i < 3){
                            PicProperties picProperties = new PicProperties();
                            Object currentImageID = resultSet2.getObject(1);
                            picProperties.setPicProperties((Integer)currentImageID);
                            i++;
                        %>
                <td>
                    <div><a href="details.jsp?id=<%=picProperties.getImageID()%>"><img src="img/normal-medium/<%=picProperties.getPath()%>" alt="" class="display"></a></div>
                    <h3>Title: <%=picProperties.getTitle()%></h3>
                    <h3>By: <%=picProperties.getUsername()%></h3>
                    <h3>Content: <%=picProperties.getContent()%></h3>
                    <h3>Date Uploaded: <%=picProperties.getUploadDate()/10000%>-<%=(picProperties.getUploadDate()-(picProperties.getUploadDate()/10000)*10000)/100%>-<%=picProperties.getUploadDate()%100%></h3>
                </td>

                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        JDBCTools.releaseDB(resultSet2, preparedStatement2, connection2);
                    }
                %>



            </tr>
        </table>
    </section>

    <aside>
        <a href="#return-here"><img src="img/icons/return-up-fixed.png" alt="" id="return-top-icon"></a>
    </aside>

    <footer>
        <div id="div-footer-1">
            <span>使用条款</span>
            <span>隐私保护</span>
            <span>Cookies</span>
            <span>关于</span>
            <span>联系我们</span>
        </div>
        <div id="div-footer-2">
            Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013 吴逸昕
        </div>
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
<script>
    let picNumber = 1;
    let intervalId = setInterval(nextPic, 3600);

    function nextPic(){
        if (picNumber === 5){
            pic.src = "img/large/<%=pathArray[0]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey1%>";
            }
            document.getElementById("button5").className="off";
            document.getElementById("button1").className="on";
            picNumber = 1;
        } else if (picNumber === 4){
            pic.src = "img/large/<%=pathArray[4]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey5%>";
            }
            document.getElementById("button4").className="off";
            document.getElementById("button5").className="on";
            picNumber = 5;
        } else if (picNumber === 3){
            pic.src = "img/large/<%=pathArray[3]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey4%>";
            }
            document.getElementById("button3").className="off";
            document.getElementById("button4").className="on";
            picNumber = 4;
        } else if (picNumber === 2){
            pic.src = "img/large/<%=pathArray[2]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey3%>";
            }
            document.getElementById("button2").className="off";
            document.getElementById("button3").className="on";
            picNumber = 3;
        } else if (picNumber === 1){
            pic.src = "img/large/<%=pathArray[1]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey2%>";
            }
            document.getElementById("button1").className="off";
            document.getElementById("button2").className="on";
            picNumber = 2;
        }
    }

    function prevPic(){
        if (picNumber === 1){
            pic.src = "img/large/<%=pathArray[4]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey5%>";
            }
            document.getElementById("button1").className="off";
            document.getElementById("button5").className="on";
            picNumber = 5;
        } else if (picNumber === 2){
            pic.src = "img/large/<%=pathArray[0]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey1%>";
            }
            document.getElementById("button2").className="off";
            document.getElementById("button1").className="on";
            picNumber = 1;
        } else if (picNumber === 3){
            pic.src = "img/large/<%=pathArray[1]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey2%>";
            }
            document.getElementById("button3").className="off";
            document.getElementById("button2").className="on";
            picNumber = 2;
        } else if (picNumber === 4){
            pic.src = "img/large/<%=pathArray[2]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey3%>";
            }
            document.getElementById("button4").className="off";
            document.getElementById("button3").className="on";
            picNumber = 3;
        } else if (picNumber === 5){
            pic.src = "img/large/<%=pathArray[3]%>";
            pic.onclick = function(){
                window.location.href="details.jsp?id=<%=maxKey4%>";
            }
            document.getElementById("button5").className="off";
            document.getElementById("button4").className="on";
            picNumber = 4;
        }
    }

    let pic = document.getElementById("imgId");
    document.getElementById("next").onclick = function(){
        nextPic();
        // 让计时器重新等待再切换下一张图片
        clearInterval(intervalId);
        interval();
    };
    document.getElementById("prev").onclick = function(){
        prevPic();
        clearInterval(intervalId);
        interval();
    };

    function interval(){
        intervalId = setInterval(nextPic, 3600);
    }
    document.getElementById("imgId").onmouseover = function () {
        clearInterval(intervalId);
    };
    document.getElementById("imgId").onmouseout = function () {
        interval();
    };

    document.getElementById("button1").onclick = function () {
        pic.src = "img/large/<%=pathArray[0]%>";
        pic.onclick = function(){
            window.location.href="details.jsp?id=<%=maxKey1%>";
        }
        document.getElementById("button" + picNumber).className="off";
        document.getElementById("button1").className="on";
        picNumber = 1;
        clearInterval(intervalId);
        interval();
    };
    document.getElementById("button2").onclick = function () {
        pic.src = "img/large/<%=pathArray[1]%>";
        pic.onclick = function(){
            window.location.href="details.jsp?id=<%=maxKey2%>";
        }
        document.getElementById("button" + picNumber).className="off";
        document.getElementById("button2").className="on";
        picNumber = 2;
        clearInterval(intervalId);
        interval();
    };
    document.getElementById("button3").onclick = function () {
        pic.src = "img/large/<%=pathArray[2]%>";
        pic.onclick = function(){
            window.location.href="details.jsp?id=<%=maxKey3%>";
        }
        document.getElementById("button" + picNumber).className="off";
        document.getElementById("button3").className="on";
        picNumber = 3;
        clearInterval(intervalId);
        interval();
    };
    document.getElementById("button4").onclick = function () {
        pic.src = "img/large/<%=pathArray[3]%>";
        pic.onclick = function(){
            window.location.href="details.jsp?id=<%=maxKey4%>";
        }
        document.getElementById("button" + picNumber).className="off";
        document.getElementById("button4").className="on";
        picNumber = 4;
        clearInterval(intervalId);
        interval();
    };
    document.getElementById("button5").onclick = function () {
        pic.src = "img/large/<%=pathArray[4]%>";
        pic.onclick = function(){
            window.location.href="details.jsp?id=<%=maxKey5%>";
        }
        document.getElementById("button" + picNumber).className="off";
        document.getElementById("button5").className="on";
        picNumber = 5;
        clearInterval(intervalId);
        interval();
    };
</script>

</html>