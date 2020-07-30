package com;

import org.apache.commons.beanutils.BeanUtils;

import java.security.interfaces.RSAKey;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAO {
    //1.
    public static void update(String sql, Object ... args){
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

    //2.通用查询方法，查询一条记录
    public <T> T get(Class<T> clazz, String sql, Object ... args){
        T entity = null;
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try{
            connection = JDBCTools.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < args.length; i++){
                preparedStatement.setObject(i+1, args[i]);
            }
            resultSet = preparedStatement.executeQuery();

            Map<String, Object> values = new HashMap<String, Object>();
            if(resultSet.next()){
                ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
                int columnCount = resultSetMetaData.getColumnCount();
                for (int i = 0; i < resultSetMetaData.getColumnCount(); i++){
                    String columnLabel = resultSetMetaData.getColumnLabel(i+1);
                    Object columnValue = resultSet.getObject(i+1);
                    values.put(columnLabel, columnValue);
                }
            }
            if(values.size() > 0){
                entity = clazz.newInstance();
            }
            for(Map.Entry<String, Object> entry: values.entrySet()){
                String fieldName = entry.getKey();
                Object value = entry.getValue();
                ReflectionUtils.setFieldValue(entity, fieldName, values);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }

        return entity;
    }

    //3.查询多条记录
    public <T> List<T> getForList(Class<T> clazz, String sql, Object ... args){
        List<T> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try{
            connection = JDBCTools.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            for (int i = 0; i < args.length; i++){
                preparedStatement.setObject(i+1, args[i]);
            }
            resultSet = preparedStatement.executeQuery();

            List<Map<String, Object>> values = new ArrayList<>();
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
            Map<String, Object> map = null;

            while(resultSet.next()){
                map = new HashMap<>();
                int columnCount = resultSetMetaData.getColumnCount();
                for (int i = 0; i < resultSetMetaData.getColumnCount(); i++){
                    String columnLabel = resultSetMetaData.getColumnLabel(i+1);
                    Object columnValue = resultSet.getObject(i+1);
                    map.put(columnLabel, columnValue);
                }
                values.add(map);
            }

            T bean = null;
            if(values.size() > 0){
                for(Map<String, Object> m: values){
                    bean = clazz.newInstance();
                    for(Map.Entry<String, Object> entry: m.entrySet()){
                        String propertyName = entry.getKey();
                        Object value = entry.getValue();
                        BeanUtils.setProperty(bean, propertyName, value);
                    }
                    list.add(bean);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }

        return list;
    }

    //4.返回某条记录的某一个字段的值或一个统计的值（一共有多少条记录等）
    public <E> E getForValue(String sql, Object ... args){
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try{
            connection = JDBCTools.getConnection();
            preparedStatement = connection.prepareStatement(sql);
            for(int i = 0; i < args.length; i++){
                preparedStatement.setObject(i + 1, args[i]);
            }
            resultSet = preparedStatement.executeQuery();

            if(resultSet.next()){
                return (E)resultSet.getObject(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JDBCTools.releaseDB(resultSet, preparedStatement, connection);
        }

        return null;
    }

}
