package com.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "MyPhotosModifyServlet")
public class MyPhotosModifyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String imageID = request.getParameter("id");
        request.getSession().setAttribute("imageUploadID",imageID);
        response.sendRedirect(request.getContextPath() + "/upload.jsp");
        //request.getRequestDispatcher("/upload.jsp").forward(request,response);
    }

}
