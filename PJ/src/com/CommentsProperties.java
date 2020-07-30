package com;

import com.DAO;
import com.JDBCTools;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Date;
import java.util.List;

public class CommentsProperties {
    private int imageID;
    private String username;
    private String comment;
    private Date dateTime;
    private int likes;

    public int getImageID() {
        return imageID;
    }

    public void setImageID(int imageID) {
        this.imageID = imageID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public int getLikes() {
        return likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public void setCommentProperties(int picID,String uName){
        DAO dao = new DAO();
        imageID = picID;
        username = uName;
        String sql = "SELECT Comment FROM travelcomments WHERE ImageID=? AND UserName=?";
        comment = dao.getForValue(sql,picID,uName);
        sql = "SELECT DateTime FROM travelcomments WHERE ImageID=? AND UserName=?";
        dateTime = dao.getForValue(sql,picID,uName);
        sql = "SELECT Likes FROM travelcomments WHERE ImageID=? AND UserName=?";
        likes = dao.getForValue(sql,picID,uName);
    }

}
