package com.ccp.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import com.ccp.utils.TxQueryRunner;

public class BPageDao {
	private QueryRunner qr = new TxQueryRunner();
	
	public List<Map<String, Object>> getCurrentTanks(){
		String sql = "select * from Table_tank1";
		List<Map<String, Object>> list = null;
		try {
			list = qr.query(sql, new MapListHandler());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Map<String, Object>> getListByPageNumberAndPageSize(String num,String startTime,String endTime){
		String sql = "select * from apcbackup where tanknum = '"+num+"' and tanktime between '"+startTime+"' and '"+endTime+"'";
		List<Map<String, Object>> list = null;
		try {
			list = qr.query(sql, new MapListHandler());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
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

}
