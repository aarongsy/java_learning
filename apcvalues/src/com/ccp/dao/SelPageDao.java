package com.ccp.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.handlers.MapListHandler;

import com.ccp.utils.TxQueryRunner;

public class SelPageDao {
	private QueryRunner qr = new TxQueryRunner();
	
	public List<Map<String, Object>> getNumList(){
		String sql = "select tank_num as id,tank_num as name from Table_tank";
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
