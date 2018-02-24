package com.ccp.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;
import org.apache.commons.dbutils.handlers.ScalarHandler;

import com.ccp.utils.TxQueryRunner;

public class JqGridDao {
	private QueryRunner qr = new TxQueryRunner();
	
	public List<Map<String, Object>> getAllTanks(){
		String sql = "SELECT * FROM Table_tank";
		List<Map<String, Object>> list = null;
		try {
			list = qr.query(sql, new MapListHandler());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
	public Object addTank(Object...obj){
		String sql = "INSERT INTO Table_tank (tank_num,material,tank_heig,tank_temp,tank_weig,tank_pi) VALUES (?,?,?,?,?,?)";
		try {
			return qr.insert(sql, new ScalarHandler<Object>(),obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public int delTank(String tanknum){
		String sql = "DELETE FROM Table_tank WHERE tank_num = ?";
		try {
			return qr.update(sql, tanknum);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
	}
	
	public int editTank(Object...obj){
		String sql = "UPDATE Table_tank SET tank_num = ? , material = ? , tank_heig = ? , tank_temp = ? , tank_weig = ? , tank_pi = ? WHERE tank_num = ?";
		try {
			return qr.update(sql, obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
	}
	
	public Object addThreshold(Object...obj){
		String sql = "INSERT INTO Table_threshold (tanknum,gd,wd,yl,bm) VALUES (?,?,?,?,?)";
		try {
			return qr.insert(sql, new ScalarHandler<Object>(),obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	public List<Map<String, Object>> getAllThreshold(){
		String sql = "SELECT * FROM Table_threshold";
		List<Map<String, Object>> list = null;
		try {
			list = qr.query(sql, new MapListHandler());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
	public int delThreshold(String tanknum){
		String sql = "DELETE FROM Table_threshold WHERE tanknum = ?";
		try {
			return qr.update(sql, tanknum);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
	}
	
	public int editThreshold(Object...obj){
		String sql = "UPDATE Table_threshold SET tanknum = ? , gd = ? , wd = ? , yl = ? , bm = ? WHERE tanknum = ?";
		try {
			return qr.update(sql, obj);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
	}
}
