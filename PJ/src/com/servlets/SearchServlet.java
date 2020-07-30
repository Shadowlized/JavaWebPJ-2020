package com.servlets;

import com.DAO;
import com.JDBCTools;
import com.PagesProperties;
import com.PicProperties;
import org.junit.Test;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String filterTC = request.getParameter("filterTC");
        String filterPT = request.getParameter("filterPT");
        String searchContext = request.getParameter("textarea");
        String resultPrint = ""; String i = "0";

        if(searchContext.trim().equals("")){
            resultPrint += "<h1>Please type the keywords you're searching for in the textarea above. </h1>";
            request.setAttribute("StrResultPrint",resultPrint);
            request.setAttribute("i", i);
            request.getRequestDispatcher("/search.jsp").forward(request,response);
        } else {
            String sql = "";
            if(filterPT.equals("filter-popularity")){
                if(filterTC.equals("filter-title")) {
                    sql = "SELECT ImageID from travelimage where Title like '%" + searchContext + "%'";
                } else {
                    sql = "SELECT ImageID from travelimage where Content like '%" + searchContext + "%'";
                }
                    Connection connection = null;
                    PreparedStatement preparedStatement = null;
                    ResultSet resultSet = null;
                    try{
                        connection = JDBCTools.getConnection();

                        preparedStatement = connection.prepareStatement(sql);
                        resultSet = preparedStatement.executeQuery();
                        int j = 0;//j即图片个数
                        while(resultSet.next()){
                            j++;
                        }

                        int [] picIDArray = new int[j]; //二者一一对应，这个是id
                        int [] picFavCountArray = new int[j]; //这个是收藏数
                        int k = 0;
                        if(filterTC.equals("filter-title")) {
                            sql = "SELECT ImageID from travelimage where Title like '%" + searchContext + "%'";
                        } else {
                            sql = "SELECT ImageID from travelimage where Content like '%" + searchContext + "%'";
                        }
                        preparedStatement = connection.prepareStatement(sql);
                        resultSet = preparedStatement.executeQuery();
                        while(resultSet.next()){
                            Object currentImageID = resultSet.getObject(1);
                            picIDArray[k] = (Integer)currentImageID;
                            k++;
                        }
                        for(k = 0; k < j; k++){
                            int currentID = picIDArray[k];
                            sql = "SELECT * FROM travelimagefavor WHERE ImageID=" + currentID;
                            preparedStatement = connection.prepareStatement(sql);
                            resultSet = preparedStatement.executeQuery();
                            while(resultSet.next()){
                                picFavCountArray[k]++;
                            }
                        }

                        //交换picID与收藏数，使得最多的到最前
                        int h = 0;
                        while (j > h){
                            for (k = h; k < j; k++){
                                if (picFavCountArray[h] < picFavCountArray[k]){//数组中的元素跟sum比较，比sum大就把它赋值给sum作为新的比较值
                                    //交换id
                                    int temp = picIDArray[h];
                                    picIDArray[h] = picIDArray[k];
                                    picIDArray[k] = temp;
                                    //交换收藏数
                                    temp = picFavCountArray[h];
                                    picFavCountArray[h] = picFavCountArray[k];
                                    picFavCountArray[k] = temp;
                                }
                            }
                            h++;
                        }

                        for(h = 0; h < j; h++){
                            PicProperties picProperties = new PicProperties();
                            picProperties.setPicProperties(picIDArray[h]);
                            resultPrint += "<div class='div-favorites'id=\"id"+ (h+1) + "\">"+
                                    "                    <a href='details.jsp?id=" + picProperties.getImageID() + "'>" +
                                    "                    <img src='img/normal-medium/"+ picProperties.getPath() + "' alt='' class='img-favorites'></a>" +
                                    "                    <div class='description'><h3>"+ picProperties.getTitle() + "&nbsp;&nbsp;&nbsp;&nbsp;" + picProperties.getUploadDate() + "&nbsp;&nbsp;&nbsp;&nbsp;Likes:&nbsp;" + picFavCountArray[h] +
                                    "                    </h3><span>" + picProperties.getDescription() + "</span><br></div>" +
                                    "              </div>";
                        }
                        if(j == 0){
                            resultPrint += "<h1 style='margin-bottom=100px;'>No Results Found!</h1>";
                        }

                        String temp = j + "a";
                        temp = temp.replace("a","");
                        i = temp;



                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        JDBCTools.releaseDB(resultSet, preparedStatement, connection);
                    }


                } else {//filter-time
                    if(filterTC.equals("filter-title")) {
                        sql = "SELECT ImageID from travelimage where Title like '%" + searchContext + "%' ORDER BY UploadDate DESC";
                    } else {
                        sql = "SELECT ImageID from travelimage where Content like '%" +searchContext+ "%' ORDER BY UploadDate DESC";
                    }
                    try {
                        resultPrint = printPicWithTry(sql, response, resultPrint)[0];
                        i = (i==null)?"0":printPicWithTry(sql, response, resultPrint)[1];
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

            request.setAttribute("StrResultPrint",resultPrint);
            request.setAttribute("i", i);
            request.getRequestDispatcher("/search.jsp").forward(request,response);
        }

    }

    public String[] printPicWithTry(String sql, HttpServletResponse response, String resultPrint) throws IOException, SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String [] returnPrintI = new String[2];
        try{
            connection = JDBCTools.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();


            int i = 0;//i即图片个数
            while(resultSet.next()){
                PicProperties picProperties = new PicProperties();
                Object currentImageID = resultSet.getObject(1);
                picProperties.setPicProperties((Integer)currentImageID);
                i++;
                resultPrint += "<div class='div-favorites'id=\"id"+ i + "\">"+
                        "                    <a href='details.jsp?id=" + picProperties.getImageID() + "'>" +
                        "                    <img src='img/normal-medium/"+ picProperties.getPath() + "' alt='' class='img-favorites'></a>" +
                        "                    <div class='description'><h3>"+ picProperties.getTitle() + "&nbsp;&nbsp;&nbsp;&nbsp;" + picProperties.getUploadDate() +
                        "                    </h3><span>" + picProperties.getDescription() + "</span><br></div>" +
                        "              </div>";

            }
            if(i == 0){
                resultPrint += "<h1>No Results Found!</h1>";
            }

            String temp = i + "a";
            temp = temp.replace("a","");
            returnPrintI[0] = resultPrint;
            returnPrintI[1] = temp;
            return returnPrintI;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }
        return returnPrintI;
    }

}
