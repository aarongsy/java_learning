package com.ccp.mi.readtext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

public class CRUD {
	//删除数据
	public boolean deleteTank1Datas(){
		boolean flag = false;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "delete from Table_tank1";
			ps = conn.prepareStatement(sql);
			ps.executeUpdate();
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
	
	//备份数据
	public boolean insertBackup(ArrayList<TankQuery> list){
		boolean flag = false;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "insert into apcbackup(tanknum,material,tankheig,tanktemp,tankweig,tankpi,tanktime) values(?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			for(TankQuery tank : list){
				ps.setString(1, tank.getTanknum());
				ps.setString(2, tank.getMaterial());
				ps.setString(3, tank.getTankheig());
				ps.setString(4, tank.getTanktemp());
				ps.setString(5, tank.getTankweig());
				ps.setString(6, tank.getTankpi());
				ps.setTimestamp(7, to24HourClock(tank.getTimestamp()));
				ps.executeUpdate();
			}
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
	
	//插入数据
	public boolean insert(ArrayList<TankQuery> list){
		boolean flag = false;
		if(list==null||list.size()==0){return flag;}
		insertBackup(list);
		if(!deleteTank1Datas())return flag;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "insert into Table_tank1(tanknum,material,tankheig,tanktemp,tankweig,tankpi,tanktime) values(?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			for(TankQuery tank : list){
				ps.setString(1, tank.getTanknum());
				ps.setString(2, tank.getMaterial());
				ps.setString(3, tank.getTankheig());
				ps.setString(4, tank.getTanktemp());
				ps.setString(5, tank.getTankweig());
				ps.setString(6, tank.getTankpi());
				ps.setTimestamp(7, to24HourClock(tank.getTimestamp()));
				ps.executeUpdate();
			}
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
	
	//修改数据
	public boolean update(ArrayList<TankQuery> list){
		boolean flag = false;
		if(list==null||list.size()==0){return flag;}
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "update Table_tank1 set tank_heig = ?,tank_temp = ?,tank_weig = ?,tank_pi = ?,tank_timestamp = ? where tank_num = ?";
			ps = conn.prepareStatement(sql);
			for(TankQuery tank : list){
				ps.setString(1, tank.getTankheig());
				ps.setString(2, tank.getTanktemp());
				ps.setString(3, tank.getTankweig());
				ps.setString(4, tank.getTankpi());
				ps.setString(5, tank.getTimestamp());
				ps.setString(6, tank.getTanknum());
				ps.executeUpdate();
			}
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
	
	//向文本数据表中插入文本数据
	public void newTxtDatas(ArrayList<Tank> list){
		if(list.size()==0)return;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "insert into Table_txt values(?,?,?)";
			ps = conn.prepareStatement(sql);
			for(Tank tank : list){
				ps.setString(1, tank.getTagname());
				ps.setString(2, tank.getTagvalue());
				ps.setString(3, tank.getTimestamp());
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
	}
	
	//向统计表中插入数据
	public void newTxt1Datas(ArrayList<Tank> list){
		if(list.size()==0)return;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "insert into Table_txt1 values(?,?,?)";
			ps = conn.prepareStatement(sql);
			for(Tank tank : list){
				ps.setString(1, tank.getTagname());
				ps.setString(2, tank.getTagvalue());
				ps.setString(3, tank.getTimestamp());
				ps.executeUpdate();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
	}
	
	//更新txt数据
	public void updateTableDatas(ArrayList<Tank> list){
		if(list.size()==0)return;
		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps1 = null;
		String sql = "update Table_txt set value=?,tanktimestamp=? where tagname=?";
		String sql1 = "update Table_txt set tanktimestamp=?";
		try {
			conn = JDBCUtil.getSQLServerConn();
			ps = conn.prepareStatement(sql);
			ps1 = conn.prepareStatement(sql1);
			ps1.setString(1, list.get(0).getTimestamp());
			ps1.executeUpdate();
			for (Tank tank : list) {
				ps.setString(1, tank.getTagvalue());
				ps.setString(2, tank.getTimestamp());
				ps.setString(3, tank.getTagname());
				ps.executeUpdate();
			}
			} catch (SQLException e) {
				e.printStackTrace();
			} finally{
				JDBCUtil.close(null, ps1, null);
				JDBCUtil.close(null, ps, conn);
			}
	
	}
	
	//过滤tankQuery数据
	public ArrayList<TankQuery> listFilter(ArrayList<TankQuery> list){
		if(list==null||list.size()==0){return null;}
		int count = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "select count(*) from Table_tank1 where tank_num=? and tank_heig = ? and tank_timestamp=?";
			ps = conn.prepareStatement(sql);
			Iterator<TankQuery> it = list.iterator();
			while(it.hasNext()){
				TankQuery tank = it.next();
				ps.setString(1, tank.getTanknum());
				ps.setString(2, tank.getTankheig());
				ps.setString(3, tank.getTimestamp());
				rs = ps.executeQuery();
				if(rs.next()){
					count += rs.getInt(1);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(rs, ps, conn);
		}
		if(count>=list.size()){return null;}
		else {return list;}
	}
	
	//清空文本数据表数据
	public boolean deleteTableDatas(){
		boolean flag = false;
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = JDBCUtil.getSQLServerConn();
			String sql = "delete from Table_txt";
			ps = conn.prepareStatement(sql);
			ps.executeUpdate();
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
	
	//获取TankQuery集合
	public ArrayList<TankQuery> getQueryList(){
		if(!controlTankList())return null;
		ArrayList<TankQuery> list = new ArrayList<TankQuery>();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select tank_num,material,(select value from Table_txt where tagname=tank_heig) tankheig,(select value from Table_txt where tagname=tank_temp) tanktemp,(select value from Table_txt where tagname=tank_weig) tankweig,(select value from Table_txt where tagname=tank_pi) tankpi,(select tanktimestamp from Table_txt where tagname=tank_heig) tanktime from Table_tank";
		try {
			conn = JDBCUtil.getSQLServerConn();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while(rs.next()){
				TankQuery tank = new TankQuery();
				//设置集合
				tank.setMaterial(null2String(rs.getString("material"), "N/A"));
				tank.setTanknum(null2String(rs.getString("tank_num"), "N/A"));
				tank.setTankheig(null2String(rs.getString("tankheig"), "N/A"));
				tank.setTanktemp(null2String(rs.getString("tanktemp"), "N/A"));
				tank.setTankweig(null2String(rs.getString("tankweig"), "N/A"));
				tank.setTankpi(null2String(rs.getString("tankpi"), "N/A"));
				tank.setTimestamp(null2String(rs.getString("tanktime"), "N/A"));
				list.add(tank);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(rs, ps, conn);
		}
		return list;
	}
	
	//是更新txt表，还是删除并更新
	public boolean controlTankList(){
		boolean flag = false;
		ArrayList<Tank> tankList = ReadText.getTankList(ReadText.fileToString());
		if(tankList==null||tankList.size()==0)return flag;
		//ArrayList<Tank> tanks = new ArrayList<Tank>(tankList);
		System.out.println(new Date().toString()+"----原集合大小----"+tankList.size());
		//if(listFilter(tankList).size()==0||tankList.size()==0)return false;
		if(tankList.size()<queryTxtCount()){
			updateTableDatas(tankList);
			//newTxt1Datas(tankList);
			flag = true;
		}else{
			deleteTableDatas();
			newTxtDatas(tankList);
			//newTxt1Datas(tankList);
			flag = true;
		}
		return flag;
	}
	
	//查询储罐信息表总数
	public int queryTxtCount(){
		int count = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "select count(*) from Table_txt";
		try {
			conn = JDBCUtil.getSQLServerConn();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if(rs.next()){
				count = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.close(rs, ps, conn);
		}
		return count;
	}
	
	//null转为指定字符串
	public String null2String(String ifnull,String fixString){
		if(ifnull==null){
			return fixString;
		}
		return ifnull;
	}
	
	//转换时间格式
	public Timestamp to24HourClock(String arg){
		String[] arr = arg.trim().split("\\s+");
		if(arr.length<3)return null;
		String[] date = arr[0].split("/");
		String temp = date[0];
		date[0] = date[2];
		date[2] = date[1];
		date[1] = temp;
		String[] time = arr[1].split("[:：+]");
		String hours = time[0];
		if(arr.length>2&&arr[2].equalsIgnoreCase("am")){
			if(hours.equals("12")){
				time[0] = "0";
			}
		}else if(arr.length>2&&arr[2].equalsIgnoreCase("pm")){
			if(!hours.equals("12")){
				time[0] = String.valueOf(Integer.parseInt(hours)+12);
			}
		}
		try {
			return new Timestamp(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(join("-",date)+" "+join(":",time)).getTime());
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	//String.join()
	public String join(String spliter,String[] arr){
		StringBuilder sb = new StringBuilder();
		for (String str : arr) {
			sb.append(str+spliter);
		}
		return sb.toString().substring(0,sb.toString().length()-1);
	}
	
	//批量修改储罐物料
	public boolean updateMaterials(Map<String,String> map){
		boolean flag = false;
		int count = 0;
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "update Table_tank set material = ? where tank_num = ?";
		try {
			conn = JDBCUtil.getSQLServerConn();
			ps = conn.prepareStatement(sql);
			for (String key : map.keySet()) {
				ps.setString(1, map.get(key));
				ps.setString(2, key);
				count += ps.executeUpdate();
			}
			if(count==63)flag = true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			JDBCUtil.close(null, ps, conn);
		}
		return flag;
	}
}
