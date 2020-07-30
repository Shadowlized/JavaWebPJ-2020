package com;

import com.DAO;
import com.JDBCTools;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.List;

public class PicProperties {
    private int imageID;
    private String title;
    private String description;
    private int cityCode;
    private String iso;
    private int uid;
    private String username;
    private String path;
    private String content;
    private int uploadDate;
    private String city;
    private String country;

    public PicProperties(){
        init();
    }
    public void init(){
        imageID = 6;
        title = "No Title";
        description = "No Description Provided.";
        cityCode = 6062069;
        iso = "No iso";
        uid = 1;
        username = "No username";
        path = "No path";
        content = "No content";
        uploadDate = 19700101;
        city = "City Unregistered";
        country = "Country Unregistered";
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getCityCode() {
        return cityCode;
    }

    public void setCityCode(int cityCode) {
        this.cityCode = cityCode;
    }

    public String getIso() {
        return iso;
    }

    public void setIso(String iso) {
        this.iso = iso;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(int uploadDate) {
        this.uploadDate = uploadDate;
    }

    public int getFavoriteCount(int picID){
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        //用于对每张图片收藏数计数
        int favoriteCount = 0;

        try {
            connection = JDBCTools.getConnection();

            String sql = "SELECT * FROM travelimagefavor WHERE ImageID=" + picID;
            preparedStatement = connection.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                favoriteCount++;
            }

        }catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }

        return favoriteCount;
    }

    public void setPicProperties(int picID){
        init();
        DAO dao = new DAO();
        imageID = picID;
        String sql = "SELECT Title FROM travelimage WHERE ImageID=" + picID;
        title = dao.getForValue(sql);
        sql = "SELECT Description FROM travelimage WHERE ImageID=" + picID;
        description = dao.getForValue(sql);
        sql = "SELECT CityCode FROM travelimage WHERE ImageID=" + picID;
        cityCode = dao.getForValue(sql);
        sql = "SELECT Country_RegionCodeISO FROM travelimage WHERE ImageID=" + picID;
        iso = dao.getForValue(sql);
        sql = "SELECT UID FROM travelimage WHERE ImageID=" + picID;
        uid = dao.getForValue(sql);
        sql = "SELECT PATH FROM travelimage WHERE ImageID=" + picID;
        path = dao.getForValue(sql);
        sql = "SELECT Content FROM travelimage WHERE ImageID=" + picID;
        content = dao.getForValue(sql);
        sql = "SELECT UploadDate FROM travelimage WHERE ImageID=" + picID;
        uploadDate = dao.getForValue(sql);

        sql = "SELECT UserName FROM traveluser WHERE UID=" + uid;
        username = dao.getForValue(sql);

        sql = "SELECT AsciiName FROM geocities WHERE GeoNameID=" + cityCode;
        city = dao.getForValue(sql);

        sql = "SELECT Country_RegionName FROM geocountries_regions WHERE ISO=?" ;
        country = dao.getForValue(sql,iso);

    }

    //用不了，beanutils导的包有问题
    /*
    public PicProperties getPicProperties(int picID){
        DAO dao = new DAO();
        String sql = "SELECT ImageID, Title, Description, CityCode, Country_RegionCodeISO, UID, PATH, Content, UploadDate FROM travelimage WHERE ImageID=" + picID;
        List<PicProperties> picPropertiesList = dao.getForList(PicProperties.class,sql);
        return picPropertiesList.get(1);
    }*/


}
