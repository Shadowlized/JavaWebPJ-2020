package com.servlets;

import com.DAO;
import com.JDBCTools;
import org.junit.Test;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Test
    public void testDate(){
        Date dNow = new Date( );
        SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
        System.out.println(ft.format(dNow));
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //1.获取请求参数：CHECK_CODE_PARAM_NAME
        String paramCode = request.getParameter("CHECK_CODE_PARAM_NAME");
        //2.获取session中的CHECK_CODE_KEY属性值
        String sessionCode = (String)request.getSession().getAttribute("CHECK_CODE_KEY");
        //3.比对，若一致说明验证码正确，不一致说明验证码错误
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String cPassword = request.getParameter("confirm-password");
        Cookie cookieU = new Cookie("usernameForm", username);
        Cookie cookieE = new Cookie("emailForm", email);
        Cookie cookieP = new Cookie("passwordForm", password);
        Cookie cookieC = new Cookie("cPasswordForm", cPassword);
        cookieU.setMaxAge(3);
        cookieE.setMaxAge(3);
        cookieP.setMaxAge(3);
        cookieC.setMaxAge(3);
        response.addCookie(cookieU);
        response.addCookie(cookieE);
        response.addCookie(cookieP);
        response.addCookie(cookieC);

        DAO dao = new DAO();
        if(!(paramCode != null && paramCode.equals(sessionCode))){
            request.getSession().setAttribute("message","验证码错误！");
            response.sendRedirect(request.getContextPath() + "/register.jsp");
        } else {
            //用户名登录
            String sql1 = "SELECT UserName FROM traveluser WHERE UserName = ?;";
            String sql2 = "SELECT Email FROM traveluser WHERE Email = ?;";
            String actualU = dao.getForValue(sql1, username);
            String actualE = dao.getForValue(sql2, username);
            if(actualU != null){
                request.getSession().setAttribute("message","该用户名已被注册！");
                response.sendRedirect(request.getContextPath() + "/register.jsp");
            } else if(actualE != null){
                request.getSession().setAttribute("message","该邮箱已被注册！");
                response.sendRedirect(request.getContextPath() + "/register.jsp");
            } else {
                Date dNow = new Date( );
                SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
                String dateTime = ft.format(dNow);
                String sql = "INSERT INTO traveluser (Email, UserName, Pass, State, DateJoined) VALUES (?,?,?,'1',?)";
                try {
                    JDBCTools.update(sql,email,username,password,dateTime);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                Cookie cookie = new Cookie("username", username);
                cookie.setMaxAge(24 * 3600);
                response.addCookie(cookie);
                request.getRequestDispatcher("/registerRedirect.jsp").forward(request,response);
            }

        }
    }

}
