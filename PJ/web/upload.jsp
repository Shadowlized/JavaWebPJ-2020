<%@ page import="com.PicProperties" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/navigation.css" rel="stylesheet" type="text/css">
    <link href="css/upload.css" rel="stylesheet" type="text/css">
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
    <form id="form" action='<%= request.getContextPath() %>/uploadServlet' method='post' role='form' onsubmit="return checkForm();">
        <div class="div-title">
            <h2>Upload</h2>
        </div>
        <%
            int currentImageID = 0;
            PicProperties picProperties = new PicProperties();
            if(session.getAttribute("imageUploadID") != null){
                currentImageID = Integer.parseInt((String)session.getAttribute("imageUploadID")) ;
                session.setAttribute("modify",1);
                session.setAttribute("imageUploadID",null);
                session.setAttribute("imageUploadIDForServlet",currentImageID);
                picProperties.setPicProperties(currentImageID);
            }
        %>
        <div id="preview">
            <%
                if(currentImageID != 0){
                    out.print("<img width='320px' height='240px' src='img/normal-medium/"+ picProperties.getPath()+ "' alt=''>");
                } else {
                    out.print("<p>Please select a picture to upload.</p>");
                }
            %>
        </div><!--用来放预览图片的DIV-->
        <%
            if(currentImageID == 0){
        %>
        <input type="file" name="upload-file" id="upload-file" onchange="previewImage(this,320,240)" accept="image/*" required>
        <%
            }
        %>
        <h3>Title:</h3>
        <%
            if(currentImageID != 0){
                out.print("<input type='text' name='title' id='title' class='upload-input' value='"+picProperties.getTitle()+"' required>");
            } else {
                out.print("<input type='text' name='title' id='title' class='upload-input' required>");
            }
        %>
        <div class="tri-block">
            <h4>Content:</h4>
            <%
                if(currentImageID != 0){
                    out.print("<select name='content' id='content' value='"+picProperties.getContent()+"' required>");
                } else {
                    out.print("<select name='content' id='content' required>");
                }
            %>
                <option value="0" id="default-content">Select Content</option>
                <option value="scenery" id="scenery">Scenery</option>
                <option value="cities" id="cities">Cities</option>
                <option value="people" id="people">People</option>
                <option value="animals" id="animals">Animals</option>
                <option value="buildings" id="buildings">Buildings</option>
                <option value="wonder" id="wonder">Wonder</option>
                <option value="other" id="other">Other</option>
            </select>
        </div>
        <div class="tri-block">
            <h4>Country/Region:</h4>
            <%
                if(currentImageID != 0){
            %>
            <select name="countrySelect" id="countrySelect" onchange="func1(this)" value="<%=picProperties.getCountry()%>" required>
            <%
                } else {
            %>
            <select name="countrySelect" id="countrySelect" onchange="func1(this)" required>
            <%
                }
            %>
                <option value="0">Select Country</option>
            </select>
        </div>
        <div class="tri-block">
            <h4>City:</h4>
            <%
                if(currentImageID != 0){
                    out.print("<select name='citySelect' id='citySelect' value='"+picProperties.getCity()+"' required>");
                } else {
                    out.print("<select name='citySelect' id='citySelect' required>");
                }
            %>
                <option value="0">Select City</option>
            </select>
        </div>
        <h3>Description:</h3>
        <textarea name="description" id="description" required>
            <%
                if(currentImageID != 0){
                    out.print(picProperties.getDescription());
                }
            %>
        </textarea>
        <br>
        <%
            if(currentImageID != 0){
                //session.setAttribute("imageUploadID",null);
        %>
        <input type="submit" class="submit-button modify" value="Modify">
        <%
            } else {
                //session.setAttribute("imageUploadID",null);
        %>
        <input type="submit" class="submit-button" value="Upload">
        <% } %>
    </form>
</section>


<footer>
    Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
</footer>
</body>
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/clickheart.js"></script>
<script>
    function checkForm() {
        let pic = document.getElementById("upload-file").value;
        let title = document.getElementById("title").value;
        let content = document.getElementById("content").value;
        let country = document.getElementById("countrySelect").value;
        let city = document.getElementById("citySelect").value;
        let description = document.getElementById("description").value;
        // 反馈
        if (title === "" || country === "0" || city === "0" || description === "" || pic === "" || content === "0"){
            alert("请填写完毕所有信息，然后再点击上传！");
            return false;
        } else {
            return true;
        }
    }

    $(function(){
        $(".submit-button").click(function(){
            let flag = confirm("确定所有信息无误并执行上传操作？");
            return flag;
        });
    });

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
<script src="js/cities.js"></script>
<script type="text/javascript">

    let pro  = document.getElementById("countrySelect");
    let city = document.getElementById("citySelect");

    for (let i in data){
        let option_pro = document.createElement("option");
        option_pro.innerHTML=i;
        option_pro.id=i;
        option_pro.value=i;
        pro.appendChild(option_pro);
    }


    function func1(self){
        let choice = (self.options[self.selectedIndex]).innerHTML;
        let options = city.children;
        for (let k=0; k<options.length; k++){
            city.removeChild(options[k--]);
        }
        for (let i in data[choice]){
            let option_city = document.createElement("option");
            option_city.innerHTML = data[choice][i];
            option_city.id = data[choice][i];
            option_city.value = data[choice][i];
            city.appendChild(option_city);
        }
    }

    document.getElementById("<%=picProperties.getContent()%>").setAttribute("selected","selected");
    document.getElementById("<%=picProperties.getCountry()%>").setAttribute("selected","selected");
    document.getElementById("<%=picProperties.getCity()%>").setAttribute("selected","selected");

</script>
<script type="text/javascript">
    //图片上传预览，非IE则用了HTML5的代码，IE是用了滤镜
    function previewImage(file, MAXWIDTH, MAXHEIGHT){//MAXWIDTH、MAXHEIGHT与放预览图片的DIV——preview的大小相呼应
        var div = document.getElementById('preview');
        if (file.files && file.files[0]) {//HTML5部分
            div.innerHTML = "<img id='imghead'></img>";
            var img = document.getElementById('imghead');
            img.onload = function(){
                var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
                img.width = rect.width;
                img.height = rect.height;
                img.style.marginTop = rect.top + 'px';
            }
            var reader = new FileReader();
            reader.onload = function(evt){
                img.src = evt.target.result;
            }
            reader.readAsDataURL(file.files[0]);
        }
        else //兼容IE
        {
            var sFilter = 'filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="';
            file.select();
            var src = document.selection.createRange().text;
            div.innerHTML = "<img id='imghead'></img>";
            var img = document.getElementById('imghead');
            img.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;
            var rect = clacImgZoomParam(MAXWIDTH, MAXHEIGHT, img.offsetWidth, img.offsetHeight);
            div.innerHTML = "<div style='width:" + rect.width + "px;height:" + rect.height + "px;margin-top:" + rect.top + "px;" + sFilter + src + "\"'></div>";
        }
    }
    //用于计算预览图片的大小
    function clacImgZoomParam(maxWidth, maxHeight, width, height){
        var param = {
            top: 0,
            left: 0,
            width: width,
            height: height
        };
        if (width > maxWidth || height > maxHeight) {
            rateWidth = width / maxWidth;
            rateHeight = height / maxHeight;
            if (rateWidth > rateHeight) {
                param.width = maxWidth;
                param.height = Math.round(height / rateWidth);
            }
            else {
                param.width = Math.round(width / rateHeight);
                param.height = maxHeight;
            }
        }
        param.left = Math.round((maxWidth - param.width) / 2);
        param.top = Math.round((maxHeight - param.height) / 2);
        return param;
    }
</script>

</html>