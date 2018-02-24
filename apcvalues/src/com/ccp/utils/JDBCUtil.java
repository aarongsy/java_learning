package com.ccp.utils;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.mchange.v2.c3p0.ComboPooledDataSource;

public class JDBCUtil {
	//配置文件的默认配置，要求必须有c3p0-config.xml
	private static ComboPooledDataSource dataSource = new ComboPooledDataSource();
	//事务专用连接
	private static ThreadLocal<Connection> tl = new ThreadLocal<Connection>();
	
	/**
	 * 使用连接池返回一个连接对象
	 * @return
	 * @throws SQLException
	 */
	public static Connection getConnection() throws SQLException{
		Connection conn =  tl.get();
		//当conn不等于null,说明已经调用过startTransaction(),表示开启了事务
		if(conn!=null) return conn;
		return dataSource.getConnection();
	}
	
	/**
	 * 返回连接池对象
	 * @return
	 */
	public static DataSource getDataSource(){
		return dataSource;
	}
	
	/**
	 * 1.获取一个Connection,设置它为不自动提交事务
	 * 2.还要保证dao中使用的连接是刚创的事务连接
	 * --------------
	 * 1.创建一个Connection,设置为手动提交
	 * 2.把这个Connection给dao用
	 * 3.还要让commitTransaction或rollbackTransaction可以获取到
	 * @throws SQLException
	 */
	public static void startTransaction() throws SQLException{
		Connection conn = tl.get();
		if(conn!=null) throw new SQLException("已经开启事务，不要重复开启");
		/*
		 * 1.给conn赋值
		 * 2.给conn设置为手动提交
		 */
		conn = getConnection();//给conn赋值，表示事务已经开启了
		conn.setAutoCommit(false);
		
		tl.set(conn);//把当前线程的连接保存起来
	}
	
	/**
	 * 提交事务
	 * 1.获取startTransaction提供的Connection,然后调用rollback方法
	 * @throws SQLException
	 */
	public static void commitTransaction() throws SQLException{
		Connection conn = tl.get();//获取当前线程的专用连接
		if(conn==null) throw new SQLException("还没有开始事务，不能提交");
		/*
		 * 1.直接使用conn.commit()
		 */
		conn.commit();
		conn.close();
		//从tl中移除
		tl.remove();
	}
	
	/**
	 * 回滚事务
	 * @throws SQLException
	 */
	public static void rollbackTransaction() throws SQLException{
		Connection conn = tl.get();
		/*
		 * 1.直接使用conn.collback();
		 */
		conn.rollback();
		conn.close();
		tl.remove();
	}
	
	public static void releaseConnection(Connection connection) throws SQLException{
		Connection conn = tl.get();
		/*
		 * 判断是不是事务专用，如果是，就不关闭
		 * 如果并不是事务专用，就关闭
		 */
		if(conn==null) connection.close();
		if(conn!=connection) connection.close();
	}

}
