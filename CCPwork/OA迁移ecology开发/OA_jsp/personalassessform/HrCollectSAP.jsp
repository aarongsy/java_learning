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
	String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
	String year=StringHelper.null2String(request.getParameter("year"));//上抛年度
	String factype=StringHelper.null2String(request.getParameter("factype"));//厂区别
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String delsql = "delete uf_hr_promoSAP where requestid='"+requestid+"' ";
	baseJdbc.update(delsql);
	
	//String sql = "select (select exttextfield15 from humres where objno=a.employno) as employno,b.takeeffectdate,(select case objname when '常熟厂' then '01' when '盘锦厂' then '02' when '长沙厂' then '03' else '04' end from orgunittype where objname=a.factype) as factorytype,(select case objname when '管理职' then '01' when '技术职' then '02' else '03' end from selectitem where id=a.ranktype)as ranktype,(select sapid from uf_profedes where descri=(select nametext from uf_profe where requestid=a.hrmodifytitle)) as hrmodifytitle,a.hrmodifyrank from uf_hr_promochild a left join uf_hr_promosummary b on a.requestid=b.requestid left join requestbase res on res.id=b.requestid where 0=res.isdelete and b.requestid='"+requestid+"'";//绩效考核汇总
	String sql = "select (select exttextfield15 from humres where objno=a.employno) as employno,b.takeeffectdate,(select case objname when '常熟厂' then '01' when '盘锦厂' then '02' when '长沙厂' then '01' else '04' end from orgunittype where objname=a.factype) as factorytype,(select case objname when '管理职' then '01' when '技术职' then '02' else '03' end from selectitem where id=(select classify from uf_profe where requestid=a.hrmodifytitle))as ranktype,(select nameid from uf_profe where requestid=a.hrmodifytitle) as hrmodifytitle,a.hrmodifyrank from uf_hr_promochild a left join uf_hr_promosummary b on a.requestid=b.requestid left join requestbase res on res.id=b.requestid where 0=res.isdelete  and b.requestid='"+requestid+"' and a.checkyear='"+year+"'";
	//System.out.println("sql="+sql);	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			 Map map = (Map)list.get(i);
			 String employno = StringHelper.null2String(map.get("employno"));//人员编号
			 String takeeffectdate = StringHelper.null2String(map.get("takeeffectdate"));//生效日期
			 String factorytype = StringHelper.null2String(map.get("factorytype"));//厂区别
			 String ranktype = StringHelper.null2String(map.get("ranktype"));//职称类型
			 String hrmodifytitle = StringHelper.null2String(map.get("hrmodifytitle"));//人事修改升调职称
			 String hrmodifyrank = StringHelper.null2String(map.get("hrmodifyrank"));//人事修改升调职级

			 SapConnector sapConnector = new SapConnector();
			 String functionName = "ZHR_IT0008_COPY";//员工职称晋升 RFC
			 JCoFunction function = null;
			 try 
			 {
				function = SapConnector.getRfcFunction(functionName);
				//建表
				JCoTable retTable = function.getTableParameterList().getTable("IT0008");//职称晋升汇总子表

						retTable.appendRow();
						retTable.setValue("PERNR", employno); //员工编号
						retTable.setValue("BEGDA", takeeffectdate);//生效日期
						retTable.setValue("TRFAR", factorytype); //厂区别
						retTable.setValue("TRFGB", ranktype);//职称分类
						retTable.setValue("TRFGR", hrmodifytitle); //人事修改调职
						retTable.setValue("TRFST", hrmodifyrank);//人事修改职级

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
				System.out.print("MESSAGEL:"+MESSAGE);
				System.out.print("MESSAGE::"+MSGTY);
				//更新数据库中对应的行项信息
				String upsql = "insert into uf_hr_promoSAP (id,requestid,messty,messtx,year,factype)values((select sys_guid() from dual),'"+requestid+"','"+MSGTY+"','"+MESSAGE+"','"+year+"','"+factype+"') ";   //SAP将要返回的信息
				System.out.println(upsql);
				baseJdbc.update(upsql);

		} catch ( JCoException e ) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		} catch ( Exception e ) {
			e.printStackTrace();
		}
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
