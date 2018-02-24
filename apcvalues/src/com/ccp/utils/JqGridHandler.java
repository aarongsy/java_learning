package com.ccp.utils;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class JqGridHandler {
	public String getJqGridJsonStr(List<Map<String, Object>> list,int page,int rows){
		if(list==null||list.isEmpty()||page<1||rows<1)return null;
		int totalRow = list.size();
		int fromIndex = (page-1)*rows;
		int toIndex = 0;
		if(page*rows>=totalRow){
			toIndex = totalRow;
		}else{
			toIndex = page*rows;
		}
		List<Map<String, Object>> sublist = list.subList(fromIndex, toIndex);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Timestamp.class, new JsonDateValueProcessor());
		JSONArray jarr = JSONArray.fromObject(sublist, jsonConfig);
		
		JSONObject json = new JSONObject();
		int totalPage = totalRow%rows==0?totalRow/rows:totalRow/rows+1;
		json.put("page", page);
		json.put("total", totalPage);
		json.put("records", totalRow);
		json.put("rows", jarr.toString());
		return json.toString();
	}
}
