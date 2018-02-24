package com.ccp.utils;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;

public class TxQueryRunner extends QueryRunner {

	@Override
	public int[] batch(String sql, Object[][] params) throws SQLException {
		/*
		 * 1.得到连接
		 * 2.执行父类方法,传递父类对象
		 * 3.释放连接
		 * 4.返回值
		 */
		Connection conn = JDBCUtil.getConnection();
		int[] result = super.batch(conn,sql, params);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public <T> T insert(String sql, ResultSetHandler<T> rsh, Object... params)
			throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		T result = super.insert(conn, sql, rsh, params);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public <T> T insert(String sql, ResultSetHandler<T> rsh) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		T result = super.insert(conn, sql, rsh);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public <T> T insertBatch(String sql, ResultSetHandler<T> rsh, Object[][] params) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		T result = super.insertBatch(conn, sql, rsh, params);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public <T> T query(String sql, ResultSetHandler<T> rsh, Object... params) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		T result = super.query(conn, sql, rsh, params);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public <T> T query(String sql, ResultSetHandler<T> rsh) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		T result = super.query(conn, sql, rsh);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public int update(String sql, Object... params) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		int result = super.update(conn, sql, params);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public int update(String sql, Object param) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		int result = super.update(conn, sql, param);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

	@Override
	public int update(String sql) throws SQLException {
		Connection conn = JDBCUtil.getConnection();
		int result = super.update(conn, sql);
		JDBCUtil.releaseConnection(conn);
		return result;
	}

}
