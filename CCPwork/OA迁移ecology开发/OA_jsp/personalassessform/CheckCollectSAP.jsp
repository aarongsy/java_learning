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
System.out.println("start: ------------------------------------------------------- ");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));//申请单的requestid
	String newyear=StringHelper.null2String(request.getParameter("newyear"));//当前年份
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//每次重抛前先删除上次抛的记录
	String delaql="delete uf_checkreturnsap where requestid='"+requestid+"'";
	baseJdbc.update(delaql);

	JSONObject jo = new JSONObject();
	String sql = "select * from uf_checkcollectmain  where requestid='"+requestid+"'";//绩效考核汇总主表
	System.out.println("sql="+sql);	
	List list = baseJdbc.executeSqlForList(sql);
	System.out.println("sql="+sql);	

	if (list.size()>0) 
	{
		 //Map map = (Map)list.get(0);
		 //String checkyear=StringHelper.null2String(map.get("checkyear"));//考核年度
		 //创建SAP对象		
		 SapConnector sapConnector = new SapConnector();
		 String functionName = "ZHR_IT9002_CREATE";//员工绩效考核汇总RFC	ZHR_IT9002_CREATE
		 JCoFunction function = null;
		 try 
		 {
			function = SapConnector.getRfcFunction(functionName);
			//插入字段
			function.getImportParameterList().setValue("YEAR",newyear);//考核年度
			System.out.println("newyear:  "+newyear);
			//建表
			JCoTable retTable = function.getTableParameterList().getTable("IT9002");//绩效考核汇总子表
			//String getsql =  "select (select exttextfield15 from humres where id= humreid ) employno,lastscore from uf_checkcollectchild  where requestid = '"+requestid+"' ";
			//String getsql =  "select (select exttextfield15 from humres where id= humreid ) employno,lastscore from uf_checkcollectchild  where requestid = '"+requestid+"' ";
			//String getsql="select a.exttextfield15 as employno,b.lastscore from humres a left join uf_checkcollectchild b on a.objno=b.employno  where (a.id='40285a904a1d4bfd014a2e7a78067f0f' or a.id='40285a904a1d4bfd014a2e7a07ea7dc3' or a.id='40285a904a1d4bfd014a2e7a620e7ecf' or a.id='40285a904a1d4bfd014a2e7a94467f61' or a.id='40285a904a1d4bfd014a2e7a91867f59' or a.id='40285a904a1d4bfd014a2e7a44477e77' or a.id='40285a904a1d4bfd014a2e79cff57d1f' or a.id='40285a904a1d4bfd014a2e7a24507e17' or a.id='40285a904a1d4bfd014a2e7a79667f13' or a.id='40285a904a1d4bfd014a2e79f2657d83' or a.id='40285a904a1d4bfd014a2e79e5b17d5d' or a.id='40285a904a1d4bfd014a2e7a68dc7ee3' or a.id='40285a904a1d4bfd014a2e79d2bc7d27' or a.id='40285a904a1d4bfd014a2e7a6b937eeb' or a.id='40285a904a1d4bfd014a2e7ac58f7ff3' or a.id='40285a904a1d4bfd014a2e7a195d7df7' or a.id='40285a904a1d4bfd014a2e79f71b7d91' or a.id='40285a904a1d4bfd014a2e7a2c4c7e2f' or a.id='40285a904a1d4bfd014a2e79f7c57d93' or a.id='40285a904a1d4bfd014a2e7a2d9f7e33' or a.id='40285a904a1d4bfd014a2e7a1ab87dfb' or a.id='40285a904a1d4bfd014a2e79eb147d6d' or a.id='40285a904a1d4bfd014a2e79da8d7d3d' or a.id='40285a904a1d4bfd014a2e7ae1cd0045' or a.id='40285a904a1d4bfd014a2e7ab88a7fcd' or a.id='40285a904a1d4bfd014a2e7a96407f67' or a.id='40285a904a1d4bfd014a2e79dbdf7d41' or a.id='40285a904a1d4bfd014a2e7ab29c7fbb' or a.id='40285a904a1d4bfd014a2e7ab3467fbd' or a.id='40285a904a1d4bfd014a2e7a0eb47dd7' or a.id='40285a904a1d4bfd014a2e7a7f8a7f23' or a.id='40285a904a1d4bfd014a2e7a80377f25' or a.id='40285a904a1d4bfd014a2e7aaa917fa3' or a.id='40285a904a1d4bfd014a2e7aa8887f9d' or a.id='40285a904a1d4bfd014a2e7a9fa77f83' or a.id='40285a904ae3405d014af1ff55777f44' or a.id='297e55a64a33c893014a33c9e3bc0034' or a.id='40285a904a1d4bfd014a2e7aa48c7f91' or a.id='40285a904c3230d7014c4e971e05577b' or a.id='40285a904c3230d7014c4e971c9f5777') and requestid = '"+requestid+"'";
			String getsql="select a.exttextfield15 as employno,b.lastscore from humres a left join uf_checkcollectchild b on a.objno=b.employno  where requestid = '"+requestid+"'";
			//员工编号、最终考分
			List getlist = baseJdbc.executeSqlForList(getsql);
			if ( getlist.size()>0 ) 
			{
				for (int i=0;i<getlist.size();i++)
				{
					Map getmap = (Map)getlist.get(i);
					String employno = StringHelper.null2String(getmap.get("employno"));//员工编号
					String lastscore = StringHelper.null2String(getmap.get("lastscore"));//最终考分
					retTable.appendRow();
					retTable.setValue("PERNR", employno); //员工编号
					retTable.setValue("ZSCRE", lastscore);//最终考分
				 }
			 }
			try 
			{
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			} 
			catch (JCoException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
				jo.put("msg","false");
				jo.put("failinfo","执行 ZHR_IT9002_CREATE 出错！");
			 } catch (Exception e) {
				// TODO Auto-generated catch block
				jo.put("msg","false");
				jo.put("failinfo","执行 ZHR_IT9002_CREATE 出错Exception！");
				e.printStackTrace();
			}
			

			//抓取抛SAP的返回值
			JCoTable newretTable = function.getTableParameterList().getTable("MESSAGE");
			
			newretTable.firstRow();//获取返回表格数据中的第一行
			String PERNR = newretTable.getString("PERNR");//人员号
			String MSGTX = newretTable.getString("MSGTX");//消息文本
			String MSGTY = newretTable.getString("MSGTY");//消息类型
			//更新数据库中对应的行项信息
			String upsql = "insert into uf_checkreturnsap(ID, REQUESTID,  sapid, errorcode, successmark)  values ((select sys_guid() from dual), '"+requestid+"','"+PERNR+"','"+MSGTX+"','"+MSGTY+"')";   //SAP将要返回的信息
			baseJdbc.update(upsql);
			//System.out.println(upsql);
			do{
				newretTable.nextRow();//获取下一行数据
				PERNR = newretTable.getString("PERNR");//人员号
				MSGTX = newretTable.getString("MSGTX");//消息文本
				MSGTY = newretTable.getString("MSGTY");//消息类型
				upsql= "insert into uf_checkreturnsap(ID, REQUESTID,  sapid, errorcode, successmark)  values ((select sys_guid() from dual), '"+requestid+"','"+PERNR+"','"+MSGTX+"','"+MSGTY+"')";  
				baseJdbc.update(upsql);
				//System.out.println(upsql);
			}while(!newretTable.isLastRow());//如果不是最后一行
			jo.put("msg","true");
		} catch ( JCoException e ) {
			// TODO Auto-generated catch block
			jo.put("msg","false");
			jo.put("failinfo","连接 ZHR_IT9002_CREATE 出错！");
			e.printStackTrace();
			
		} catch ( Exception e ) {
			// TODO Auto-generated catch block
			jo.put("msg","false");
			jo.put("failinfo","连接SAP出错！");
			e.printStackTrace();
			
		}
	} 
	else
	{
		jo.put("msg","false");
		jo.put("failinfo","没有需要抛SAP的明细！");
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	System.out.println(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
