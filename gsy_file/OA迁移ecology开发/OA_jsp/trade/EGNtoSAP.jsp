<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>

<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	String action=StringHelper.null2String(request.getParameter("action"));
	String  form = "uf_tr_custinfo";
	//if (action.equals("getData")){
		String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
		String companycode = StringHelper.null2String(request.getParameter("companycode"));//公司代码
		String igntypeid = StringHelper.null2String(request.getParameter("igntypeid"));//保证票种类ID
		String start[] = StringHelper.null2String(request.getParameter("start")).split(";");//SAP开始日期
		String end[] = StringHelper.null2String(request.getParameter("end")).split(";");//SAP截止日期
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String sql = "select custtype,custcode,custname,mon,rmbmon,startdate,enddate,risktype,flag,creditmon,usedmon,arrdate,rtf from "+form+" where requestid='"+requestid+"' order by no asc ";
		//类型、客户编码、客户名称、金额、本币金额、SAP额度起始日期、SAP额度结束日期、风险类别、成功标识、信用总额(本币)、SAP已占用额度、SAP总额度到期日、备注
		List list = baseJdbc.executeSqlForList(sql);
		
		if(list.size()>0){
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_SD_CREDIT_CHG";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//建表
			JCoTable retTable = function.getTableParameterList().getTable("SD_CREDIT_CHG");
			for(int i = 0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
				String custtype = StringHelper.null2String(map.get("custtype"));//类别
				String searsql = "select objname from selectitem where id = '"+custtype+"'";
				List cls = baseJdbc.executeSqlForList(searsql);
				if(cls.size() >0)
				{
					Map cmap = (Map)cls.get(0);
					custtype = StringHelper.null2String(cmap.get("objname"));//类别的中文显示名称
				}
				String custcode = StringHelper.null2String(map.get("custcode"));//客户编码
				String custname = StringHelper.null2String(map.get("custname"));//客户名称
				String mon = StringHelper.null2String(map.get("mon"));//金额
				String rmbmon = StringHelper.null2String(map.get("rmbmon"));//本币金额
				String startdate = StringHelper.null2String(map.get("startdate"));//SAP额度起始日期
				startdate = startdate.replace("-","");
				String enddate = StringHelper.null2String(map.get("enddate"));//SAP额度结束日期
				enddate = enddate.replace("-","");
				String risktype = StringHelper.null2String(map.get("risktype"));//风险类别
				String flag = StringHelper.null2String(map.get("flag"));//成功标识
				String creditmon = StringHelper.null2String(map.get("creditmon"));//信用总额(本币)
				String usedmon = StringHelper.null2String(map.get("usedmon"));//SAP已占用额度
				String arrdate = StringHelper.null2String(map.get("arrdate"));//SAP总额度到期日
				arrdate = arrdate.replace("-","");
				String rtf = StringHelper.null2String(map.get("rtf"));//备注
				retTable.appendRow();//增加一行
				retTable.setValue("DFLAG",custtype);//类别
				retTable.setValue("KUNNR",custcode);//客户编码
				retTable.setValue("KKBER",companycode);//公司代码
				retTable.setValue("ZELX",igntypeid);//保证票种类ID
				retTable.setValue("DATE_FROM",start[i]);//SAP额度的起始日期
				retTable.setValue("UEDAT",end[i]);//SAP额度的截止日期
				retTable.setValue("KLIMK",rmbmon);//本币金额
				retTable.setValue("ZNOTES",rtf);//备注
				retTable.setValue("TFLAG",flag);//是否已写入SAP成功标识
				retTable.setValue("CTLPC",risktype);//风险类别
				retTable.setValue("KLIMZ",creditmon);//信用总额(本币)
				retTable.setValue("OBLIG",usedmon);//SAP已占用金额
				retTable.setValue("NXTRV",arrdate);//SAP总额度到期日
			}
			try {
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			String ERR_MSG = function.getExportParameterList().getValue("ERR_MSG").toString();
			String FLAG = function.getExportParameterList().getValue("FLAG").toString();
			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("SD_CREDIT_CHG");
			JSONArray jsonArray = new JSONArray();
			if (newretTable.getNumRows() > 0) {
				for (int i = 0; i < newretTable.getNumRows(); i++) {
					newretTable.setRow(i);
					JSONObject jsonObject = new JSONObject();
					jsonObject.put("DFLAG", newretTable.getString("DFLAG"));//类型
					jsonObject.put("KUNNR", newretTable.getString("KUNNR"));//客户编码
					jsonObject.put("TFLAG", newretTable.getString("TFLAG"));//是否已写入SAP成功标识
					jsonObject.put("KLIMZ", newretTable.getString("KLIMZ"));//信用总额(本币)
					jsonObject.put("OBLIG", newretTable.getString("OBLIG"));//SAP已占用金额
					jsonObject.put("NXTRV", newretTable.getString("NXTRV"));//SAP总额度到期日
					jsonObject.put("ZNOTES", newretTable.getString("ZNOTES"));//备注

					String DFLAG = newretTable.getString("DFLAG");//类型
					String KUNNR = newretTable.getString("KUNNR");//客户编码
					String TFLAG = newretTable.getString("TFLAG");//是否已写入SAP成功标识
					String KLIMZ = newretTable.getString("KLIMZ");//信用总额(本币)
					String OBLIG = newretTable.getString("OBLIG");//SAP已占用金额
					String NXTRV = newretTable.getString("NXTRV");//SAP总额度到期日
					String ZNOTES = newretTable.getString("ZNOTES");//备注

					jsonArray.add(jsonObject);
					String upsql = "update uf_tr_custinfo set flag ='"+TFLAG+"',creditmon='"+KLIMZ+"',usedmon='"+OBLIG+"',arrdate='"+NXTRV+"',rtf='"+ZNOTES+"' ";
					upsql = upsql+" where custcode = '"+KUNNR+"' and requestid = '"+requestid+"' and no = '"+(i+1)+"'";
					baseJdbc.update(upsql);
				}
			}
			JSONObject jo = new JSONObject();		
			response.setContentType("application/json; charset=utf-8");
			response.getWriter().write(jsonArray.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
	//}
%>
