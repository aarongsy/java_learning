package com.ccp.mi.readtext;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCUtil {
    static Properties pros = null;//配置文件对象，可以帮助读取和处理资源文件中的信息

    static {//加载JDBCUtil类的时候调用
        pros = new Properties();
        try {
            pros.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties"));
            //Class.forName(pros.getProperty("mysqlDriver"));
            //Class.forName(pros.getProperty("oracleDriver"));
            Class.forName(pros.getProperty("sqlServerDriver"));
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
			 //TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    //获取mysql连接
    public static Connection getMysqlConn(){
        try {
            return DriverManager.getConnection(pros.getProperty("mysqlURL"),
                    pros.getProperty("mysqlUser"),pros.getProperty("mysqlPwd"));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    //获取Oracle连接
    public static Connection getOracleConn(){
        try {
            return DriverManager.getConnection(pros.getProperty("oracleURL"),
                    pros.getProperty("oracleUser"),pros.getProperty("oraclePwd"));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    //获取sqlserver连接
    public static Connection getSQLServerConn(){
        try {
            return DriverManager.getConnection(pros.getProperty("sqlServerURL"),
                    pros.getProperty("sqlServerUser"),pros.getProperty("sqlServerPwd"));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    //关闭数据库连接，可以重载多个
    public static void close(ResultSet rs,PreparedStatement ps,Connection conn){
        try {
            if (rs!=null) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps!=null) {
                ps.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn!=null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}