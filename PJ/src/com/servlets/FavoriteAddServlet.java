package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "FavoriteAddServlet")
public class FavoriteAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object uid = session.getAttribute("UID");
        Object imageID = session.getAttribute("ImageID");
        String sql = "INSERT INTO travelimagefavor (UID, ImageID) VALUES (?,?)";
        DAO.update(sql,uid,imageID);
        response.sendRedirect(request.getContextPath() + "/details.jsp?id=" + imageID);
    }
}
