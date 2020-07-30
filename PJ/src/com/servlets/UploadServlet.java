package com.servlets;

import com.DAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "UploadServlet")
public class UploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        String cookieName = ""; String cookieUsernameValue = "";
        if (cookies != null && cookies.length > 0){
            for(Cookie cookie: cookies){
                cookieName = cookie.getName();
                if(cookieName.equals("username")){
                    cookieUsernameValue = cookie.getValue();
                }
            }
        }
        DAO dao = new DAO();

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String country = request.getParameter("countrySelect");
        String city = request.getParameter("citySelect");
        String description = request.getParameter("description");

        String sql = "SELECT GeoNameID FROM geocities WHERE AsciiName=?";
        int cityCode = dao.getForValue(sql,city);
        sql = "SELECT ISO FROM geocountries_regions WHERE Country_RegionName=?";
        String iso = dao.getForValue(sql,country);

        Date dNow = new Date( );
        SimpleDateFormat ft1 = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
        SimpleDateFormat ft2 = new SimpleDateFormat ("yyyyMMdd");
        String time = ft1.format(dNow);
        String uploadDate = ft2.format(dNow);

        if(request.getSession().getAttribute("modify") != null){
            //update
            int currentID = (Integer)request.getSession().getAttribute("imageUploadIDForServlet");

            sql = "UPDATE travelimage SET Title=?,Description=?,CityCode=?,Country_RegionCodeISO=?,Content=?,UploadDate=?,Time=?"+
                  " WHERE ImageID=?";
            dao.update(sql,title,description,cityCode,iso,content,uploadDate,time,currentID);
            request.getSession().setAttribute("imageUploadID",null);
            request.getSession().setAttribute("imageUploadIDForServlet",null);//不可省略
            request.getSession().setAttribute("modify",null);
            response.sendRedirect(request.getContextPath() + "/details.jsp?id="+currentID);
        } else {
            //insert into
            sql = "SELECT UID FROM traveluser WHERE UserName=?";
            String username = cookieUsernameValue;
            int uid = dao.getForValue(sql, username);
            sql = "SELECT Max(ImageID)ImageID FROM travelimage";
            int maxID = dao.getForValue(sql);
            int imageID = maxID + 1;
            String path = request.getParameter("upload-file");

            sql = "INSERT INTO travelimage (ImageID,Title,Description,CityCode,Country_RegionCodeISO,UID,Path,Content,UploadDate,Time)"+
                  " VALUES (?,?,?,?,?,?,?,?,?,?)";
            dao.update(sql,imageID,title,description,cityCode,iso,uid,path,content,uploadDate,time);
            request.getSession().setAttribute("imageUploadID",null);
            response.sendRedirect(request.getContextPath() + "/myphotos.jsp");
        }
    }

}
