package com.ccp.utils;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

public class BPageHandler {
	
	public String getBPageJsonStr(List<Map<String, Object>> list,List<Map<String, Object>> thres,int pageNumber,int pageSize){
		if(list==null||thres==null||list.isEmpty()||pageNumber<1||pageSize<1)return null;
		
		JSONArray thresJArr = JSONArray.fromObject(thres);
		JSONObject thresJson = new JSONObject();
		for (int i = 0; i < thresJArr.size(); i++) {
			JSONObject jobj = thresJArr.getJSONObject(i);
			thresJson.put(jobj.get("tanknum"), jobj);
		}
		
		int totalRow = list.size();
		int fromIndex = (pageNumber-1)*pageSize;
		int toIndex = 0;
		if(pageNumber*pageSize>=totalRow){
			toIndex = totalRow;
		}else{
			toIndex = pageNumber*pageSize;
		}
		List<Map<String, Object>> sublist = list.subList(fromIndex, toIndex);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Timestamp.class, new JsonDateValueProcessor());
		JSONArray jarr = JSONArray.fromObject(sublist, jsonConfig);
		JSONObject json = new JSONObject();
		int totalPage = totalRow%pageSize==0?totalRow/pageSize:totalRow/pageSize+1;
		json.put("pageNumber", pageNumber);
		json.put("pageSize", pageSize);
		json.put("totalRow", totalRow);
		json.put("totalPage", totalPage);
		json.put("list", jarr.toString());
		json.put("threshold", thresJson.toString());
		return json.toString();
	}

}
