package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "CommentServlet")
public class CommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object username = session.getAttribute("commentUsername");
        Object imageID = session.getAttribute("currentImageID");
        String comment = request.getParameter("comment-box");
        Date dNow = new Date( );
        SimpleDateFormat ft1 = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
        String time = ft1.format(dNow);
        String sql = "INSERT INTO travelcomments (UserName,Comment,DateTime,Likes,ImageID) VALUES (?,?,?,?,?)";
        DAO.update(sql,username,comment,time,0,imageID);
        response.sendRedirect(request.getContextPath() + "/details.jsp?id=" + imageID);
    }

}
