package com;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

import org.junit.Test;

public class JDBCTools {

    @Test
    public void testStatement() throws SQLException {
        Connection conn = null; Statement statement = null;
        try{
            conn = getConnection();
            String sql = "INSERT INTO travelimagefavor VALUES ('1001','2','3');";
            Statement statement1 = conn.createStatement();
            statement1.executeUpdate(sql);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try{
                if(statement !=null){
                    statement.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally{
                if(conn != null){
                    conn.close();
                }
            }
        }
    }

    public static Connection getConnection() throws Exception {
        Properties properties = new Properties();
        InputStream inputStream = JDBCTools.class.getClassLoader().getResourceAsStream("jdbc.properties");
        properties.load(inputStream);

        String user = properties.getProperty("user");
        String password = properties.getProperty("password");
        String driver = properties.getProperty("driver");
        String jdbcUrl = properties.getProperty("jdbcUrl");

        Class.forName(driver);
        return DriverManager.getConnection(jdbcUrl, user, password);
    }

    public static void update(String sql, Object ... args) throws Exception{
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        try{
            connection = JDBCTools.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < args.length; i++){
                preparedStatement.setObject(i+1, args[i]);
            }
            preparedStatement.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            JDBCTools.releaseDB(null, preparedStatement, connection);
        }
    }

    public static void releaseDB(ResultSet resultSet, Statement statement, Connection connection){
        if(resultSet != null){
            try{
                resultSet.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        if(statement != null){
            try{
                statement.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        if(connection != null){
            try{
                connection.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

    }

    public static void releaseConnection(Connection connection){
        try {
            if(connection != null){
                connection.close();
            }
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

}
