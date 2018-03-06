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
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%

	String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select a.supoacode,a.supname,a.supcode,b.creman,b.forcompany,b.comtype,b.xjsdate,b.xjedate,b.xjtype,b.bjtype,b.bjyearmon,b.sdate,b.edate,b.deadline,b.attach from uf_lo_xunjiagys a left join uf_lo_xunjiamian b on a.requestid =b.requestid where a.requestid='"+requestid+"'";	
	String err="";	
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start 内贸询价......");
		for(int i = 0; i < list.size(); i++){
			Map map = (Map)list.get(i);

			String supoacode = StringHelper.null2String(map.get("supoacode")); 
			String supname=StringHelper.null2String(map.get("supname"));
			String supcode=StringHelper.null2String(map.get("supcode"));
			String conenddate=StringHelper.null2String(map.get("conenddate"));
			String creman = StringHelper.null2String(map.get("creman")); 
			String forcompany=StringHelper.null2String(map.get("forcompany"));
			String comtype=StringHelper.null2String(map.get("comtype"));
			String xjsdate=StringHelper.null2String(map.get("xjsdate"));
			String xjedate=StringHelper.null2String(map.get("xjedate"));
			String xjtype=StringHelper.null2String(map.get("xjtype"));
			String bjtype=StringHelper.null2String(map.get("bjtype"));
			String bjyearmon=StringHelper.null2String(map.get("bjyearmon"));
			String sdate=StringHelper.null2String(map.get("sdate"));
			String edate=StringHelper.null2String(map.get("edate"));
			String deadline=StringHelper.null2String(map.get("deadline"));
			String attach=StringHelper.null2String(map.get("attach"));
			String formula="NMBJD-YYYYMM-";
			Date newdate = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
            SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
            SimpleDateFormat sdf2 = new SimpleDateFormat("dd");

            formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
            formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
            formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
            formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));

           String o = NumberHelper.getSequenceNo("40285a8d5898d740015898f7d5a500d6", 3);
                 
       	   String flowno= formula+o+"-"+supcode;
			if(!supoacode.equals("")){
					WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
					RequestInfo rs=new RequestInfo();
					rs.setCreator(supoacode); 
					rs.setTypeid("40285a8d589941dc01589a1ec36d11fa");
					rs.setIssave("1"); 
					Dataset data=new Dataset();
					List<Cell> list1=new ArrayList<Cell>();
					Cell cell1=new Cell();			
					cell1.setName("bjnum");//报价单号
					cell1.setValue(flowno);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("xjnum");//询价单号
					cell1.setValue(requestid);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("xjman");//询价人
					cell1.setValue(creman);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("xjcom");//询价公司
					cell1.setValue(forcompany);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("area");//厂区别
					cell1.setValue(comtype);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("xjsdate");//开始询价时间
					cell1.setValue(xjsdate);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("xjedate");
					cell1.setValue(xjedate);
					list1.add(cell1);

					cell1=new Cell();
					cell1.setName("bjstatus");//报价状态
					cell1.setValue("40285a8d5842e03f015847b78a6a0b78");
					list1.add(cell1);

					cell1=new Cell();	
					cell1.setName("bjman");//报价人
					cell1.setValue(supoacode);
					list1.add(cell1);

					cell1=new Cell();
					cell1.setName("bjcom");
					cell1.setValue(supoacode);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("bjcomjm");
					cell1.setValue(supoacode);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("sttype");//类型
					cell1.setValue(xjtype);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("bjtype");
					cell1.setValue(bjtype);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("bjyear");
					cell1.setValue(bjyearmon);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("psdate");
					cell1.setValue(sdate);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("pedate");
					cell1.setValue(edate);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("bjedate");
					cell1.setValue(deadline);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("attach");
					cell1.setValue(attach);
					list1.add(cell1);

					data.setMaintable(list1);
					rs.setData(data);
					workflowServiceImpl.createRequest(rs);	
				}
				String bjrequestid="";
				String srequest="select requestid from uf_lo_baojiamain where bjnum='"+flowno+"'";
				List listl = baseJdbc.executeSqlForList(srequest);
				if(listl.size()>0){ 
					Map map1 = (Map)listl.get(0);
					bjrequestid=StringHelper.null2String(map1.get("requestid"));
				}
				System.out.println("报价单requestid:"+bjrequestid);
				if(!bjrequestid.equals(""))
				{
					srequest="select sno,lineno,linename,linetype,trantype,hxarea,qygang,qycity,mdgang,mdcity,tranvech,gx,danger,dangerlv,pricetype,stone,etone,require,pro,gl,gxty from uf_lo_xunjiasub where requestid='"+requestid+"'";
					listl = baseJdbc.executeSqlForList(srequest);
					if(listl.size()>0){ 
						for(int j = 0; j < listl.size(); j++){
							Map maps = (Map)listl.get(j);
							String sno=StringHelper.null2String(maps.get("sno"));
							String lineno=StringHelper.null2String(maps.get("lineno"));
							String linename=StringHelper.null2String(maps.get("linename"));
							String linetype=StringHelper.null2String(maps.get("linetype"));
							String trantype=StringHelper.null2String(maps.get("trantype"));
							String hxarea=StringHelper.null2String(maps.get("hxarea"));
							String qygang=StringHelper.null2String(maps.get("qygang"));
							String qycity=StringHelper.null2String(maps.get("qycity"));
							String mdgang=StringHelper.null2String(maps.get("mdgang"));
							String mdcity=StringHelper.null2String(maps.get("mdcity"));
							String tranvech=StringHelper.null2String(maps.get("tranvech"));
							String gx=StringHelper.null2String(maps.get("gx"));
							String danger=StringHelper.null2String(maps.get("danger"));
							String dangerlv=StringHelper.null2String(maps.get("dangerlv"));
							String pricetype=StringHelper.null2String(maps.get("pricetype"));
							String stone=StringHelper.null2String(maps.get("stone"));
							String etone=StringHelper.null2String(maps.get("etone"));
							String require=StringHelper.null2String(maps.get("require"));
							String pro=StringHelper.null2String(maps.get("pro"));
							String gl=StringHelper.null2String(maps.get("gl"));
							String gxty=StringHelper.null2String(maps.get("gxty"));
							String hxty=mdgang;
						    if(gxty.equals("TK")||mdgang.equals(""))
						    {
							  hxty=linename;
						    }

							String insql="insert into uf_lo_baojiachild (id,requestid,sno,lineno,linename,linetype,trantype,hxarea,qygang,gycity,mdgang,mdcity,vehicle,gx,danger,dangerlv,pritype,stone,etone,requir,pro,gl,xjrequstid,yl,curr,gxty,hxty)values((select sys_guid() from dual),'"+bjrequestid+"',"+sno+",'"+lineno+"','"+linename+"','"+linetype+"','"+trantype+"','"+hxarea+"','"+qygang+"','"+qycity+"','"+mdgang+"','"+mdcity+"','"+tranvech+"','"+gx+"','"+danger+"','"+dangerlv+"','"+pricetype+"','"+stone+"','"+etone+"','"+require+"','"+pro+"',"+gl+",'"+requestid+"','0','RMB','"+gxty+"','"+hxty+"')";
							//System.out.println(insql);
							baseJdbc.update(insql);
						}
					}
				}

			}
		}	
			
        System.out.println("auto END 内贸询价......");
		System.out.println(list.size());
	JSONObject jo=new JSONObject();
	jo.put("msg","true");
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();		
%>
