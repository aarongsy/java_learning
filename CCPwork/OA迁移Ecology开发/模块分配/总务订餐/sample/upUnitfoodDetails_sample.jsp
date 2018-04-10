<!--%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%-->
<!--%@ page import="weaver.general.Util,java.util.*, weaver.systeminfo.SystemEnv" %--> 
<!--%@page import="org.json.*"%-->
<!--jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /-->
<!--jsp:useBean id="bs" class="weaver.general.BaseBean"/-->
<!--%@ page import="weaver.interfaces.gd.unitfood.service.UnitfoodDetailService" %-->
<!--%@ page import="weaver.conn.RecordSet,weaver.interfaces.gd.unitfood.model.UnitfoodDetail" %-->
<!--%@ page import="java.util.HashMap,java.util.List,java.util.Map,org.json.JSONException,org.json.JSONObject,java.util.ArrayList" %
/app/weaver/ecology/interface/gd/unitfood
-->



<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="java.text.SimpleDateFormat,java.text.DateFormat" %>

<%
	RecordSet rs = new RecordSet();
	try {
		String list = request.getParameter("list");
		String comtype = request.getParameter("comtype");
		JSONArray jsonArr = new JSONArray();
		rs.writeLog("list："+list);
		rs.writeLog("comtype:"+comtype);
		JSONArray json = JSONArray.fromObject(list);
		String strremark = Util.null2String(request.getParameter("strremark"));	
		String userid = Util.null2String(request.getParameter("userid"));
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式	
		SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm"); 
		String curdate = dateFormat.format( now ); 	 
		String curtime = timeFormat.format( now ); 
		
		Map<String, String> retmap = new HashMap<String, String>();	
		JSONObject jo = new JSONObject();
		int errcount = 0;
		int succount = 0;
		String successNo ="";
		String errNo ="";
		String errmsg = "";	
		
		for (int i = 0; i < json.size(); i++) {			
			String No= (String) json.getJSONObject(i).get("No");
			int id =  Util.getIntValue(json.getJSONObject(i).get("Id"));			
			String breakfast= (String) json.getJSONObject(i).get("Breakfast");
			String breakfastsend= (String) json.getJSONObject(i).get("Breakfastsend");
			String noon= (String) json.getJSONObject(i).get("noon");
			String noonsend= (String) json.getJSONObject(i).get("noonsend");
			String dinner= (String) json.getJSONObject(i).get("dinner");
			String dinnersend= (String) json.getJSONObject(i).get("dinnersend");
			StringBuffer buffer = new StringBuffer(4096);
			buffer.append("update uf_oa_ygdcmx set ");
			 buffer.append("breakfast='").append(breakfast.equals("0")?"":breakfast).append("',");
			 buffer.append("breakfastsend='").append(breakfastsend.equals("0")?"":breakfastsend).append("',");
			 buffer.append("noon='").append(noon.equals("0")?"":noon ).append("',");
			 buffer.append("noonsend='").append(noonsend.equals("0")?"":noonsend).append("',");
			 buffer.append("dinner='").append(dinner.equals("0")?"":dinner ).append("',");
			 buffer.append("dinnersend='").append(dinnersend.equals("0")?"":dinnersend).append("',");	
			 //buffer.append("remark='").append(strremark).append("' ");					 
			 buffer.append("comtype='").append(comtype).append("',");
			 buffer.append("modifier='").append(userid).append("',");
			 buffer.append("modifydate='").append(curdate).append("',");
			 buffer.append("modifytime='").append(curtime).append("' ");
			 buffer.append("where id="+id);
			 String upsql = buffer.toString();
			rs.writeLog("upsql="+upsql);
			 Boolean upflag = rs.executeSql(upsql);
			 if(!upflag) {
				 errcount++;
				 if(errcount==1){
					 errNo = No;
				 } else {
					 errNo = errNo +","+No;
				 }
			 }else{
				 succount ++;
				 if(succount==1){
					 successNo = No;
				 } else {
					 successNo = successNo+","+No;
				 }
			 }
		}
	}catch (Exception e) {
		// TODO: handle exception
		out.write("fail" + e);
		errmsg = e.toString();
		e.printStackTrace();
	}
			if( succount==json.size() && errcount==0 && "".equals(errmsg)) {
				retmap.put("msg", "true");
				try {
					jo.put("msg", "true");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				retmap.put("msg", "false");
				try {
					jo.put("msg", "false");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			retmap.put("succount", succount+"");
			try {
				jo.put("succount", succount+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("successNo", successNo);
			try {
				jo.put("successNo", successNo);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errcount", errcount+"");
			try {
				jo.put("errcount", errcount+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errNo", errNo);	
			try {
				jo.put("errNo", errNo);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errmsg", errmsg+"");
			try {
				jo.put("errmsg", errmsg+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
%>	
<%=jo.toString() %>
<%
	/*xxy原始代码，不用了
	public String updateUnitfoodDetailByArray(String strNo,String strDataId,String strBreakfast,String strBreakfastsend,String strnoon,String strnoonsend,String strdinner,String strdinnersend,String strremark,String userid,String update,String uptime,String comtype){
		Map<String, String> retmap = new HashMap<String, String>();	
		JSONObject jo = new JSONObject();
		int errcount = 0;
		int succount = 0;
		String successNo ="";
		String errNo ="";
		String errmsg = "";	
		String a = "strNo="+strNo	+"strDataId="+strDataId+" strBreakfast="+strBreakfast+" strBreakfastsend="+strBreakfastsend+" strnoon="+strnoon+" strnoonsend="+strnoonsend+" strdinner="+strdinner+" strdinnersend="+strdinnersend;
		rs.writeLog("strNo="+strNo	+"strDataId="+strDataId+" strBreakfast="+strBreakfast+" strnoon="+strnoon+" strnoonsend="+strnoonsend+" strdinner="+strdinner+" strdinnersend="+strdinnersend);
		String[] arrNo = strNo.split(",");		
		String[] arrDataId = strDataId.split(",");
		try {
			String[] arrBreakfast = strBreakfast.split(",");
			String[] arrBreakfastsend = strBreakfastsend.split(",");			
			String[] arrnoon = strnoon.split(",");
			String[] arrnoonsend = strnoonsend.split(",");
			String[] arrdinner = strdinner.split(",");
			String[] arrdinnersend = strdinnersend.split(",");
			//String[] arrstrremark = strremark.split(",");
			//System.out.println(arrstrremark.length + " arrstrremark[1]="+arrstrremark[1]);
			
			RecordSet rs = new RecordSet();
			//rs = new RecordSet();
			if ( arrDataId.length >0 ) {
				
				for ( int i=0;i<arrDataId.length;i++ ) {
					int id =  Util.getIntValue(arrDataId[i]);
					StringBuffer buffer = new StringBuffer(4096);
					buffer.append("update uf_oa_ygdcmx set ");
					 buffer.append("breakfast='").append(arrBreakfast[i].equals("0")?"":arrBreakfast[i]).append("',");
					 buffer.append("breakfastsend='").append(arrBreakfastsend[i].equals("0")?"":arrBreakfastsend[i]).append("',");
					 buffer.append("noon='").append(arrnoon[i].equals("0")?"":arrnoon[i] ).append("',");
					 buffer.append("noonsend='").append(arrnoonsend[i].equals("0")?"":arrnoonsend[i]).append("',");
					 buffer.append("dinner='").append(arrdinner[i].equals("0")?"":arrdinner[i] ).append("',");
					 buffer.append("dinnersend='").append(arrdinnersend[i].equals("0")?"":arrdinnersend[i]).append("',");	
					 //buffer.append("remark='").append(arrstrremark[i]).append("' ");					 
					 buffer.append("comtype='").append(comtype).append("',");
					 buffer.append("modifier='").append(userid).append("',");
					 buffer.append("modifydate='").append(update).append("',");
					 buffer.append("modifytime='").append(uptime).append("' ");
					 buffer.append("where id="+id);
					 String upsql = buffer.toString();
					rs.writeLog("upsql="+upsql);
					 Boolean upflag = rs.executeSql(upsql);
					 if(!upflag) {
						 rs.writeLog("weaver.interfaces.gd.unitfood.service.UnitfoodDetailService updateUnitfoodDetailByArray 1  upsql="+upsql);
						//out.write("weaver.interfaces.gd.unitfood.service.UnitfoodDetailService updateUnitfoodDetailByArray   upsql="+upsql);
						 errcount++;
						 if(errcount==1){
							 errNo = arrNo[i];
						 } else {
							 errNo = errNo +","+arrNo[i];
						 }
					 }else{
						 succount ++;
						 if(succount==1){
							 successNo = arrNo[i];
						 } else {
							 successNo = successNo+","+arrNo[i];
						 }
						rs.writeLog("weaver.interfaces.gd.unitfood.service.UnitfoodDetailService updateUnitfoodDetailByArray 2 upsql="+upsql);
					 }
				}
			}
			
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			errmsg = e.toString();
		}
			if( succount==arrDataId.length && errcount==0 && "".equals(errmsg)) {
				retmap.put("msg", "true");
				try {
					jo.put("msg", "true");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} else {
				retmap.put("msg", "false");
				try {
					jo.put("msg", "false");
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			retmap.put("succount", succount+"");
			try {
				jo.put("succount", succount+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("successNo", successNo);
			try {
				jo.put("successNo", successNo);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errcount", errcount+"");
			try {
				jo.put("errcount", errcount+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errNo", errNo);	
			try {
				jo.put("errNo", errNo);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			retmap.put("errmsg", errmsg+"");
			try {
				jo.put("errmsg", errmsg+"");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return jo.toString();
	} */

	/*
	//String strs=request.getParameter("js");
	//JSONObject jsObject=JSONObject.fromObject(strs);
//rs.writeLog("获得JSON:"+jsObject);
//strNo="+strNo	+"&strDataId="+strDataId+"&strBreakfast="+strBreakfast+"&strnoon="+strnoon+"&strnoonsend="+strnoonsend+"&strdinner="+strdinner+"&strdinnersend="+strdinnersend;
	String strNo = Util.null2String(request.getParameter("strNo"));
	String strDataId = Util.null2String(request.getParameter("strDataId"));
	String strBreakfast = Util.null2String(request.getParameter("strBreakfast"));
	String strBreakfastsend = Util.null2String(request.getParameter("strBreakfastsend"));
	String strnoon = Util.null2String(request.getParameter("strnoon"));
	String strnoonsend = Util.null2String(request.getParameter("strnoonsend"));
	String strdinner = Util.null2String(request.getParameter("strdinner"));
	String strdinnersend = Util.null2String(request.getParameter("strdinnersend"));
	String strremark = Util.null2String(request.getParameter("strremark"));	
	String userid = Util.null2String(request.getParameter("userid"));
	String comtype = Util.null2String(request.getParameter("comtype"));
	
	Date now = new Date(); 
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式	
	SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm"); 
	String curdate = dateFormat.format( now ); 	 
	String curtime = timeFormat.format( now ); 
	//bs.writeLog("strNo="+strNo	+"strDataId="+strDataId+" strBreakfast="+strBreakfast+" strnoon="+strnoon+" strnoonsend="+strnoonsend+" strdinner="+strdinner+" strdinnersend="+strdinnersend);
	rs.writeLog("strNo="+strNo	+"strDataId="+strDataId+" strBreakfast="+strBreakfast+" strnoon="+strnoon+" strnoonsend="+strnoonsend+" strdinner="+strdinner+" strdinnersend="+strdinnersend);
	String returnstr = "";	
	try {
		//UnitfoodDetailService app = new UnitfoodDetailService();
		//returnstr = app.updateUnitfoodDetailByArray(strNo, strDataId, strBreakfast, strBreakfastsend, strnoon, strnoonsend, strdinner, strdinnersend, strremark, userid, curdate, curtime, comtype);	
		returnstr = updateUnitfoodDetailByArray(strNo, strDataId, strBreakfast, strBreakfastsend, strnoon, strnoonsend, strdinner, strdinnersend, strremark, userid, curdate, curtime,comtype);	
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} */
	 
%>
<!--%=returnstr %-->