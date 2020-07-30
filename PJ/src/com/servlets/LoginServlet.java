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
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet(name = "LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    /*
    @Test
    public void initializeDate(){
        for(int i=1; i<=82; i++){
            int randomDate = 20200701;
            randomDate = ((int) (Math.random() * (2020 + 1 - 2012)) + 2012) * 10000 + ((int) (Math.random() * (12 + 1 - 1)) + 1) * 100 + (int) (Math.random() * (28 + 1 - 1)) + 1;
            String sql = "UPDATE travelimage SET UploadDate=? WHERE UID=?";
            try {
                JDBCTools.update(sql,randomDate,i);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    */

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //1.获取请求参数：CHECK_CODE_PARAM_NAME
        String paramCode = request.getParameter("CHECK_CODE_PARAM_NAME");
        //2.获取session中的CHECK_CODE_KEY属性值
        String sessionCode = (String)request.getSession().getAttribute("CHECK_CODE_KEY");
        //3.比对，若一致说明验证码正确，不一致说明验证码错误
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        Cookie cookieU = new Cookie("usernameForm", username);
        Cookie cookieP = new Cookie("passwordForm", password);
        cookieU.setMaxAge(3);
        cookieP.setMaxAge(3);
        response.addCookie(cookieU);
        response.addCookie(cookieP);

        DAO dao = new DAO();
        if(!(paramCode != null && paramCode.equals(sessionCode))){
            request.getSession().setAttribute("message","验证码错误！");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            //用户名登录
            String sql1 = "SELECT Pass FROM traveluser WHERE UserName = ?;";
            String sql2 = "SELECT Pass FROM traveluser WHERE Email = ?;";
            String actualPass1 = dao.getForValue(sql1, username);
            String actualPass2 = dao.getForValue(sql2, username);
            //使用用户名登录
            if (actualPass1 != null){
                if (actualPass1.equals(password)){
                    Cookie cookie = new Cookie("username", username);
                    cookie.setMaxAge(24 * 3600);
                    response.addCookie(cookie);
                    request.getRequestDispatcher("/loginRedirect.jsp").forward(request,response);
                    //response.sendRedirect(request.getContextPath() + "/index.jsp");
                } else {
                    redirectLogin(request,response,username,password);
                }
            //使用邮箱登录
            } else if(actualPass2 != null){
                if (actualPass2.equals(password)){
                    //username记录的是表单中用户名/邮箱一栏的字符串，actualUsername则是通过此处username（即实际上的email）获取的真正的username
                    String sql3 = "SELECT UserName FROM traveluser WHERE Email = ?;";
                    String actualUsername = dao.getForValue(sql3, username);
                    Cookie cookie = new Cookie("username", actualUsername);
                    cookie.setMaxAge(24 * 3600);
                    response.addCookie(cookie);
                    request.getRequestDispatcher("/loginRedirect.jsp").forward(request,response);
                } else {
                    redirectLogin(request,response,username,password);
                }
            } else {
                redirectLogin(request,response,username,password);
            }
        }
    }

    private void redirectLogin(HttpServletRequest request, HttpServletResponse response, String username, String password) throws IOException {
        request.getSession().setAttribute("message","用户名和密码错误！");
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

}
