<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link href="css/reset.css" rel="stylesheet" type="text/css">
    <link href="css/register.css" rel="stylesheet" type="text/css">
</head>
<body>
    <header>
        <img src="img/avatar.jpg" alt="" class="avatar">
        <h1>Sign up for Fisher</h1>
    </header>
    <section>
        <%
            Cookie [] cookies = request.getCookies();
            String cookieName = ""; String cookieValueU = ""; String cookieValueP = ""; String cookieValueE = ""; String cookieValueC = "";
            if (cookies != null && cookies.length > 0){
                for(Cookie cookie: cookies){
                    cookieName = cookie.getName();
                    if(cookieName.equals("usernameForm")){
                        cookieValueU = cookie.getValue();
                    }
                    if(cookieName.equals("emailForm")){
                        cookieValueE = cookie.getValue();
                    }
                    if(cookieName.equals("passwordForm")){
                        cookieValueP = cookie.getValue();
                    }
                    if(cookieName.equals("cPasswordForm")){
                        cookieValueC = cookie.getValue();
                    }
                }
            }
        %>
        <font color="red">
            <%= session.getAttribute("message") == null ? "" : session.getAttribute("message") %><%session.setAttribute("message",null);%>
        </font>
        <form action='<%= request.getContextPath() %>/registerServlet' method='post' role='form' onsubmit="return signUp();">
            <h2>Username:</h2>
            <p>
                <input type="text" name="username" id="username" value="<%= cookieValueU %>" placeholder="4-15位字母数字'.''_'" required>
            </p>
            <h2>Email:</h2>
            <p>
                <input type="text" name="email" id="email" value="<%= cookieValueE %>" placeholder="邮箱地址" required>
            </p>
            <h2>Password:</h2>
            <p>
                <input type="password" name="password" id="password" value="<%= cookieValueP %>" placeholder="6-12位字母数字特殊字符" onkeyup="pwdStrength(this.value)" onkeypress="pwdStrength(this.value)" onblur="pwdStrength(this.value)"  required>
            </p>
            <table width="215px" border="1" cellspacing="0" cellpadding="1" bordercolor="#eeeeee" height="20px" style="border-radius: 2px; margin-top: 6px; margin-left: 17px;">
                <tr align="center" bgcolor="#f5f5f5">
                    <td width="33%" id="strength_L">Weak</td>
                    <td width="33%" id="strength_M">Medium</td>
                    <td width="33%" id="strength_H">Strong</td>
                </tr>
            </table>
            <h2>Confirm Your Password:</h2>
            <p>
                <input type="password" name="confirm-password" id="confirm-password" value="<%= cookieValueC %>" placeholder="请再次输入密码" required>
            </p>
            <h2>Captcha:</h2>
            <p>
                <input type="text" name="CHECK_CODE_PARAM_NAME" id="captcha" required>
                <img alt="" width="80px" src="<%= request.getContextPath() %>/validateColorServlet" >
            </p>
            <p>
                <input type="submit" value="Sign Up" id="sign-up-submit" onclick= signUp()>
            </p>
        </form>
    </section>
    <footer>
        Copyright @ 2020 Web Fundamentals. All Rights Reserved. 备案号：19302010013吴逸昕
    </footer>
</body>
<script>
    function signUp() {
        let username = document.getElementById("username").value;
        let email = document.getElementById("email").value;
        let password = document.getElementById("password").value;
        let cPassword = document.getElementById("confirm-password").value;
        // 检测
        let patternUser = /[0-9A-Za-z | . | _]{4,15}$/;
        let booUser = patternUser.test(username);
        let patternMail = /\w+[@]\w+[.]\w+/;
        let booMail = patternMail.test(email);
        let patternPass = /^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z\\W]{6,12}$/;
        let booPass = patternPass.test(password);
        // 反馈
        if (!booUser) {
            alert("用户名需为4-15位，仅可含大小写字母、数字、\".\"、\"_\"，且不含特殊字符的组合");
            return false;
        } else if (!booMail){
            alert("邮箱格式不符合规范");
            return false;
        } else if (!booPass){
            alert("密码需为6-12位，含字母、数字，可含特殊字符的组合");
            return false;
        } else if (password !== cPassword){
            alert("两次输入的密码不一致");
            return false;
        } else {
            return true;
        }
    }
    function pwdStrength(pwd) {
        let O_color = "#e8e8e8";
        let L_color = "#ffa181";
        let M_color = "#ffdc74";
        let H_color = "#8ccc73";
        let level = 0, strength = "O";
        if (pwd == null || pwd === '') {
            strength = "O";
            Lcolor = Mcolor = Hcolor = O_color;
        } else {
            var mode = 0;
            if (pwd.length <= 5)
                mode = 0;
            else {
                for (let i = 0; i < pwd.length; i++) {
                    let charMode, charCode;
                    charCode = pwd.charCodeAt(i);
                    // 判断输入密码的类型
                    if (charCode >= 48 && charCode <= 57) //数字
                        charMode = 1;
                    else if (charCode >= 65 && charCode <= 90) //大写
                        charMode = 2;
                    else if (charCode >= 97 && charCode <= 122) //小写
                        charMode = 4;
                    else
                        charMode = 8;
                    mode |= charMode;
                }
                // 计算密码模式
                level = 0;
                for (let i = 0; i < 4; i++) {
                    if (mode & 1)
                        level++;
                    mode >>>= 1;
                }
            }
            switch (level) {
                case 0:
                    strength = "O";
                    Lcolor = Mcolor = Hcolor = O_color;
                    break;
                case 1:
                    strength = "L";
                    Lcolor = L_color;
                    Mcolor = Hcolor = O_color;
                    break;
                case 2:
                    strength = "M";
                    Lcolor = Mcolor = M_color;
                    Hcolor = O_color;
                    break;
                default:
                    strength = "H";
                    Lcolor = Mcolor = Hcolor = H_color;
                    break;
            }
        }
        document.getElementById("strength_L").style.background = Lcolor;
        document.getElementById("strength_M").style.background = Mcolor;
        document.getElementById("strength_H").style.background = Hcolor;
        return strength;
    }
</script>
</html>