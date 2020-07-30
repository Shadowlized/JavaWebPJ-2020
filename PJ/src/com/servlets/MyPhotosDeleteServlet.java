package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "MyPhotosDeleteServlet")
public class MyPhotosDeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Object uid = session.getAttribute("UID");
        String imageID = request.getParameter("id");
        String sql = "DELETE FROM travelimage WHERE UID=? AND ImageID=?";
        DAO.update(sql,uid,imageID);
        response.sendRedirect(request.getContextPath() + "/myphotos.jsp");
    }

}
