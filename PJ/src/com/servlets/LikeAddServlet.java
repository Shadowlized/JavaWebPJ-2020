package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LikeAddServlet")
public class LikeAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        DAO dao = new DAO();
        String username = request.getParameter("username");
        Object imageID = session.getAttribute("currentImageID");
        String sql = "SELECT Likes FROM travelcomments WHERE UserName=? AND ImageID=?";
        int likes = dao.getForValue(sql,username,imageID);
        likes++;
        sql = "UPDATE travelcomments SET Likes=? WHERE UserName=? AND ImageID=?";
        DAO.update(sql,likes,username,imageID);
        response.sendRedirect(request.getContextPath() + "/details.jsp?id=" + imageID);
    }

}
