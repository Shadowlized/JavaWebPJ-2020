package com.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "NavDropdownServlet")
public class NavDropdownServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean loggedIn = false;
        Cookie [] cookies = request.getCookies();
        String cookieName = ""; String cookieValue = "";
        if (cookies != null && cookies.length > 0){
            for(Cookie cookie: cookies){
                cookieName = cookie.getName();
                if(cookieName.equals("username")){
                    loggedIn = true;
                    cookieValue = cookie.getValue();
                }
            }
        }
        if(!loggedIn){
            response.getWriter().write("<a href='login.jsp'><button class='dropdown-button'>Login</button></a>");
        }else{
            response.getWriter().write("<button class=\"dropdown-button\">"+ cookieValue + "</button>" +
                    "<div class=\"dropdown-content\">" +
                    "<a href=\"upload.jsp\"><img src=\"img/icons/upload.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;Upload</a>" +
                    "<a href=\"myphotos.jsp\"><img src=\"img/icons/myphotos.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;My Photos</a>" +
                    "<a href=\"favorites.jsp\"><img src=\"img/icons/favorites.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;Favorites</a>" +
                    "<a href=\"friendlist.jsp\"><img src=\"img/icons/friends.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;FriendList</a>" +
                    "<a href=\"settings.jsp\"><img src=\"img/icons/settings.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;Settings</a>" +
                    "<a href=\"logout.jsp\"><img src=\"img/icons/login.png\" alt=\"\" width=\"20px\" height=\"20px\">&nbsp;&nbsp;Logout</a>" +
                    "</div>");
        }
    }
}
