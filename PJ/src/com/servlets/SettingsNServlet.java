package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "SettingsNServlet")
public class SettingsNServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        String cookieName = ""; String cookieValue = "";
        if (cookies != null && cookies.length > 0){
            for(Cookie cookie: cookies){
                cookieName = cookie.getName();
                if(cookieName.equals("username")){
                    cookieValue = cookie.getValue();
                }
            }
        }
        String sql = "UPDATE traveluser SET PermitVisit=0 WHERE UserName=?";
        DAO.update(sql,cookieValue);
        request.getSession().setAttribute("message","已设置收藏界面为私密！");
        response.sendRedirect("settings.jsp");
    }

}
