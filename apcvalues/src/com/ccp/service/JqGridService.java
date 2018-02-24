package com.ccp.service;

import com.ccp.dao.JqGridDao;
import com.ccp.utils.JqGridHandler;

public class JqGridService {
	private JqGridDao dao = new JqGridDao();
	
	public String initJqGrid(int page,int rows){
		JqGridHandler jqGrid = new JqGridHandler();
		String jsonStr = jqGrid.getJqGridJsonStr(dao.getAllTanks(), page, rows);
		if(jsonStr==null||jsonStr.trim().isEmpty())return "{\"pageNumber\":1,\"pageSize\":1,\"totalRow\":1,\"totalPage\":1,\"msg\":\"系统错误，请联系管理员！\"}";
		return jsonStr;
	}
	
	public String initJqGrid1(int page,int rows){
		JqGridHandler jqGrid = new JqGridHandler();
		String jsonStr = jqGrid.getJqGridJsonStr(dao.getAllThreshold(), page, rows);
		if(jsonStr==null||jsonStr.trim().isEmpty())return "{\"pageNumber\":1,\"pageSize\":1,\"totalRow\":1,\"totalPage\":1,\"msg\":\"系统错误，请联系管理员！\"}";
		return jsonStr;
	}
	
	public Object add(String tag,Object...obj){
		if(tag.equalsIgnoreCase("tank"))return dao.addTank(obj);
		else return dao.addThreshold(obj);
	}
	
	public Object edit(String tag,Object...obj){
		if(tag.equalsIgnoreCase("tank"))return dao.editTank(obj);
		else return dao.editThreshold(obj);
	}
	
	public int del(String tag,String tanknum){
		if(tag.equalsIgnoreCase("tank"))return dao.delTank(tanknum);
		else return dao.delThreshold(tanknum);
	}

}
