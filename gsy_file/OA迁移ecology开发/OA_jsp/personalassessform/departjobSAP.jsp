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
<%@ page import="com.sap.conn.jco.JCoStructure" %>

<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	//部门职位晋升调职
	String sql = "select (select exttextfield15 from humres where objno=a.employno) as employno,a.takeeffectdate,(select case objname when '常熟厂' then '01' when '盘锦厂' then '02' when '长沙厂' then '03' else '04' end from orgunittype where objname=a.factorytype) as factorytype,(select case objname when '管理职' then '01' when '技术职' then '02' else '03' end from selectitem where id=a.manageorbusiness)as ranktype,(select sapid from uf_profedes where descri=(select nametext from uf_profe where requestid=a.recommtitle)) as recommtitle,a.recommrank from uf_hr_departpromotapp a left join requestbase res on res.id=a.requestid where 0=res.isdelete and a.requestid='"+requestid+"'";
	System.out.println("sql="+sql);	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		 Map map = (Map)list.get(0);
		 String employno = StringHelper.null2String(map.get("employno"));//人员编号
		 String takeeffectdate = StringHelper.null2String(map.get("takeeffectdate"));//生效日期
		 String factorytype = StringHelper.null2String(map.get("factorytype"));//厂区别
		 String ranktype = StringHelper.null2String(map.get("ranktype"));//职称类型
		 String recommtitle = StringHelper.null2String(map.get("recommtitle"));//建议升调职称
		 String recommrank = StringHelper.null2String(map.get("recommrank"));//建议升调职级

		 SapConnector sapConnector = new SapConnector();
		 String functionName = "ZHR_IT0008_COPY";//职位晋升调职 RFC
		 JCoFunction function = null;
		 try 
		 {
			function = SapConnector.getRfcFunction(functionName);
			//建表
			JCoTable retTable = function.getTableParameterList().getTable("IT0008");

					retTable.appendRow();
					retTable.setValue("PERNR", employno); //员工编号
					retTable.setValue("BEGDA", takeeffectdate);//生效日期
					retTable.setValue("TRFAR", factorytype); //厂区别
					retTable.setValue("TRFGB", ranktype);//职称分类
				    retTable.setValue("TRFGR", recommtitle); //建议升调职称
					retTable.setValue("TRFST", recommrank);//建议升调职级

			try 
			{
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} 
			catch (JCoException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			

			//抓取抛SAP的返回值
			String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
			String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
			//更新数据库中对应的行项信息(即SAP将要返回的信息如消息类型,消息文本)
			String upsql="update uf_hr_departpromotapp set messty='"+MSGTY+"',messtx='"+MESSAGE+"' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);

		} catch ( JCoException e ) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	JSONObject jo = new JSONObject();		
	//jo.put("MSGTY", MSGTY);
	//jo.put("MESSAGE", MESSAGE);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	System.out.println(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
