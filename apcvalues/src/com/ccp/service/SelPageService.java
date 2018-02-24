package com.ccp.service;

import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import com.ccp.dao.SelPageDao;

public class SelPageService {
	private SelPageDao dao = new SelPageDao();
	
	public String initSelPage(){
		List<Map<String, Object>> list = dao.getNumList();
		if(list==null||list.isEmpty()){
			return "{\"id\":\"无选项，请联系管理员！\",\"name\":\"无选项，请联系管理员！\"}";
		}
		JSONArray jarr = JSONArray.fromObject(list);
		return jarr.toString();
	}
}
