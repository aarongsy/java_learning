<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	String caldate=StringHelper.null2String(request.getParameter("caldate"));	
	String liquid=StringHelper.null2String(request.getParameter("liquid"));
	//String isfirst=StringHelper.null2String(request.getParameter("isfirst"));
	String area=StringHelper.null2String(request.getParameter("area"));
	String datform = "uf_yz_liqusesteam"; 
	String qcform = "uf_yz_liqbeginread"; //ÆÚ³õ±í
	String readform = "uf_yz_liqreading";  //uf_yz_liqreadingsub
	System.out.println("action="+action+" caldate="+caldate+" liquid="+liquid+" area="+area);
	
	String getvalsql="";
	String err="";
	
	float C3=0;
	float C4=0;
	float C5=0;
	float C6=0;
	float C7=0;
	float C8=0;
	float C9=0;
	float C10=0;
	float C11=0;
	float C12=0;
	float C13=0;
	float C14=0;
	float C15=0;
	float C16=0;
	float C17=0;
	float C18=0;
	float C19=0;

	float D3=0;
	float D4=0;
	float D5=0;
	float D6=0;
	float D7=0;
	float D8=0;
	float D9=0;
	float D10=0;
	float D11=0;
	float D12=0;
	float D13=0;
	float D14=0;
	float D15=0;
	float D16=0;
	float D17=0;
	float D18=0;
	float D19=0;	
	
	JSONObject jo = new JSONObject();
	
	if(action.equals("getvalue")){
		getvalsql ="select BQDS.liqitemid itemid,BQDS.liqitemname itemname,BQDS.readdate caldate,BQDS.readval val,SQDR.readdate lastdate,SQDR.readval lastval from ( select a.comtype area,a.stateflag sflag,b.reading readval,a.readdate readdate, b.liqitem liqitemname,b.liqitemid liqitemid from uf_yz_liqreading a,uf_yz_liqreadingsub b where a.requestid=b.requestid and a.liquid ='"+liquid+"' and to_date(a.readdate,'yyyy-mm-dd')=(to_date('"+caldate+"','yyyy-mm-dd') ) and a.stateflag='40285a9049d58e9e0149ea20d3cf6c79' and a.comtype='"+area+"' ) BQDS left join ( select a.comtype area,a.stateflag sflag,b.reading readval,a.readdate readdate,b.liqitemid liqitemid from uf_yz_liqreading a,uf_yz_liqreadingsub b where a.requestid=b.requestid ) SQDR on BQDS.liqitemid=SQDR.liqitemid and  (to_date(BQDS.readdate,'yyyy-mm-dd')=to_date(SQDR.readdate,'yyyy-mm-dd')+1 ) and BQDS.sflag=SQDR.sflag and BQDS.area=SQDR.area order by itemid asc";
		List list = baseJdbc.executeSqlForList(getvalsql);		
		if(list.size()==0){			
			err = "1";			
		}else if(list.size()<17){
			err = "2";			
		}else if(list.size()==17){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String itemname = StringHelper.null2String(map.get("itemname"));
				String itemid = StringHelper.null2String(map.get("itemid"));				
				String val = StringHelper.null2String(map.get("val"));				
				String lastdate = StringHelper.null2String(map.get("lastdate"));
				String lastval = StringHelper.null2String(map.get("lastval"));
				//System.out.println("itemid:"+itemid+" " +itemname + " "+caldate+"reading:" +val+" "+lastdate+"reading:" +lastval);
				if(val.equals("") || val.equals("null") || val.equals(null) || lastval.equals("") || lastval.equals("null") || lastval.equals(null) ){					
					err = "3";					
					break;
				}else{
					if(itemid.equals("ZQ001")){
						C3 = Float.parseFloat(lastval);
						D3 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ002")){
						C4 = Float.parseFloat(lastval);
						D4 = Float.parseFloat(val);							
					}else if(itemid.equals("ZQ003")){
						C5 = Float.parseFloat(lastval);
						D5 = Float.parseFloat(val);							
					}else if(itemid.equals("ZQ004")){
						C6 = Float.parseFloat(lastval);
						D6 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ005")){
						C7 = Float.parseFloat(lastval);
						D7 = Float.parseFloat(val);							
					}else if(itemid.equals("ZQ006")){
						C8 = Float.parseFloat(lastval);						
						D8 = Float.parseFloat(val);							
					}else if(itemid.equals("ZQ007")){
						C9 = Float.parseFloat(lastval);
						D9 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ008")){
						C10 = Float.parseFloat(lastval);
						D10 = Float.parseFloat(val);							
					}else if(itemid.equals("ZQ009")){
						C11 = Float.parseFloat(lastval);
						D11 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ010")){
						C12 = Float.parseFloat(lastval);
						D12 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ011")){
						C13 = Float.parseFloat(lastval);
						D13 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ012")){
						C14 = Float.parseFloat(lastval);
						D14 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ013")){
						C15 = Float.parseFloat(lastval);
						D15 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ014")){
						C16 = Float.parseFloat(lastval);
						D16 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ015")){
						C17 = Float.parseFloat(lastval);
						D17 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ016")){
						C18 = Float.parseFloat(lastval);
						D18 = Float.parseFloat(val);						
					}else if(itemid.equals("ZQ017")){
						C19 = Float.parseFloat(lastval);
						D19 = Float.parseFloat(val);						
					}else{
						err = "4";						
						break;					
					}					
				}
			}
					
		}	
		if(err.equals("")){
			float AD3 = D5-C5;
			float AD8 = D8-C8;
			float AD9 = D8-C8;
			float AD11 = (float)((D10-C10)/1.2);
			float AD12 = D11-C11;
			float AD13 = D12-C12;
			float AD14 = D13-C13;
			float AD15 = D14-C14;
			float AD16 = D15-C15;
			float AD17 = D16-C16;
			float AD18 = D17-C17;
			float AD19 = D18-C18;
			float AD20 = D19-C19;
			float AD21 = AD3+AD11+AD12+AD18+AD19+AD20;
			jo.put("D3",String.valueOf(AD3));
			jo.put("D8",String.valueOf(AD8));
			jo.put("D9",String.valueOf(AD9));
			jo.put("D11",String.valueOf(AD11));
			jo.put("D12",String.valueOf(AD12));
			jo.put("D13",String.valueOf(AD13));
			jo.put("D14",String.valueOf(AD14));
			jo.put("D15",String.valueOf(AD15));
			jo.put("D16",String.valueOf(AD16));
			jo.put("D17",String.valueOf(AD17));
			jo.put("D18",String.valueOf(AD18));
			jo.put("D19",String.valueOf(AD19));
			jo.put("D20",String.valueOf(AD20));
			jo.put("D21",String.valueOf(AD21));
			jo.put("msg","true");	

		}else{
			jo.put("msg","false");
			jo.put("err",err);		
		}
	}	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
