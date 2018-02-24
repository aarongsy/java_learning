package com.ccp.service;

import com.ccp.dao.BPageDao;
import com.ccp.utils.BPageHandler;

public class BPageService {
	private BPageDao dao = new BPageDao();
	
	public String initBPage(int pageNumber,int pageSize){
		BPageHandler bph = new BPageHandler();
		String jsonStr = bph.getBPageJsonStr(dao.getCurrentTanks(),dao.getAllThreshold(), pageNumber, pageSize);
		if(jsonStr==null||jsonStr.trim().isEmpty())return "{\"pageNumber\":1,\"pageSize\":1,\"totalRow\":1,\"totalPage\":1,\"msg\":\"系统错误，请联系管理员！\"}";
		return jsonStr;
	}
	
	public String bPage(int pageNumber,int pageSize,String num,String startTime,String endTime){
		BPageHandler bph = new BPageHandler();
		String jsonStr = bph.getBPageJsonStr(dao.getListByPageNumberAndPageSize(num, startTime, endTime),dao.getAllThreshold(), pageNumber, pageSize);
		if(jsonStr==null||jsonStr.trim().isEmpty())return "{\"pageNumber\":1,\"pageSize\":1,\"totalRow\":1,\"totalPage\":1,\"msg\":\"未查询到数据，请更换查询条件！\"}";
		return jsonStr;
	}
}
