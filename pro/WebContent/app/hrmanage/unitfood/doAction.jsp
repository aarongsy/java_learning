<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="org.json.simple.JSONValue" %>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.ParseException"%>
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action = StringHelper.null2String(request.getParameter("action"));
	if(action.equals("newdata")){//分类新建时
		String flowno=StringHelper.null2String(request.getParameter("flowno"));
		String objdept=StringHelper.null2String(request.getParameter("objdept"));
		String objno=StringHelper.null2String(request.getParameter("objno"));
		String objname=StringHelper.null2String(request.getParameter("objname"));
		String thedate=StringHelper.null2String(request.getParameter("thedate"));
		String breakfast=StringHelper.null2String(request.getParameter("breakfast"));
		String lunch=StringHelper.null2String(request.getParameter("lunch"));
		String dinner=StringHelper.null2String(request.getParameter("dinner"));
		//清空历史数据
		String sql = "delete from uf_hr_forunitfoodsub where flowno='"+flowno+"'";
		baseJdbc.update(sql);
		//获取数组
		String[] str1 = objdept.split(",");
		String[] str2 = objno.split(",");
		String[] str3 = objname.split(",");
		String[] str4 = thedate.split(",");
		String[] str5 = breakfast.split(",");
		String[] str6 = lunch.split(",");
		String[] str7 = dinner.split(",");
		for(int i=0;i<str1.length;i++){			
			String isql = "insert into uf_hr_forunitfoodsub (flowno,reqdept,jobno,objname,thedate,breakfast,lunch,dinner) values ('"+flowno+"',replace('"+str1[i]+"','null',''),replace('"+str2[i]+"','null',''),replace('"+str3[i]+"','null',''),replace('"+str4[i]+"','null',''),replace('"+str5[i]+"','null',''),replace('"+str6[i]+"','null',''),replace('"+str7[i]+"','null',''))";
			baseJdbc.update(isql);
		}
		return;
	}
	if(action.equals("tosub")){//把转存表的数据插入到子表中
		String flowno=StringHelper.null2String(request.getParameter("flowno"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String sql = "select * from uf_hr_forunitfoodsub where flowno='"+flowno+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String reqdept = StringHelper.null2String(map.get("reqdept"));
				String jobno = StringHelper.null2String(map.get("jobno"));
				String objname = StringHelper.null2String(map.get("objname"));
				String thedate = StringHelper.null2String(map.get("thedate"));
				String breakfast = StringHelper.null2String(map.get("breakfast"));
				String lunch = StringHelper.null2String(map.get("lunch"));
				String dinner = StringHelper.null2String(map.get("dinner"));
				String isql = "insert into uf_hr_unitfootsub (id,requestid,reqdept,jobno,objname,thedate,breakfast,lunch,dinner) values (sys_guid(),'"+requestid+"','"+reqdept+"','"+jobno+"','"+objname+"','"+thedate+"','"+breakfast+"','"+lunch+"','"+dinner+"')";
				baseJdbc.update(isql);
			}
			String isql2 = "update uf_hr_unitfoot set imtype='2',breakbook=(select count(NVL(breakfast,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and breakfast='40285a90495b4eb001496408814f5995'),breaksend=(select count(NVL(breakfast,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and breakfast='40285a90495b4eb001496408814f5996'),lunchbook=(select count(NVL(lunch,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and lunch='40285a90495b4eb001496408814f5995'),lunchsend=(select count(NVL(lunch,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and lunch='40285a90495b4eb001496408814f5996'),dinnerbook=(select count(NVL(dinner,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and dinner='40285a90495b4eb001496408814f5995'),dinnersend=(select count(NVL(dinner,0)) from uf_hr_unitfootsub where requestid='"+requestid+
					"' and dinner='40285a90495b4eb001496408814f5996') where requestid='"+requestid+"'";
			baseJdbc.update(isql2);//把主表的导入标识修改为2和合计
			String isql3 = "delete from uf_hr_forunitfoodsub where flowno='"+flowno+"'";
			baseJdbc.update(isql3);//删除转存表的数据
		}
		return;
	}
	if(action.equals("editdata")){
		String theid=StringHelper.null2String(request.getParameter("theid"));
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		String breakfast=StringHelper.null2String(request.getParameter("breakfast"));
		String lunch=StringHelper.null2String(request.getParameter("lunch"));
		String dinner=StringHelper.null2String(request.getParameter("dinner"));
		//获取数组
		String[] str1 = theid.split(",");
		String[] str5 = breakfast.split(",");
		String[] str6 = lunch.split(",");
		String[] str7 = dinner.split(",");
		for(int i=0;i<str1.length;i++){		 	
			String isql = "update uf_hr_unitfootsub set breakfast=replace('"+str5[i]+"','null',''),lunch=replace('"+str6[i]+"','null',''),dinner=replace('"+str7[i]+"','null','') where id='"+str1[i]+"'";
			baseJdbc.update(isql);
		}
		String isql2 = "update uf_hr_unitfoot set breakbook=(select count(NVL(breakfast,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and breakfast='40285a90495b4eb001496408814f5995'),breaksend=(select count(NVL(breakfast,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and breakfast='40285a90495b4eb001496408814f5996'),lunchbook=(select count(NVL(lunch,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and lunch='40285a90495b4eb001496408814f5995'),lunchsend=(select count(NVL(lunch,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and lunch='40285a90495b4eb001496408814f5996'),dinnerbook=(select count(NVL(dinner,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and dinner='40285a90495b4eb001496408814f5995'),dinnersend=(select count(NVL(dinner,0)) from uf_hr_unitfootsub where requestid='"+requestid+
				"' and dinner='40285a90495b4eb001496408814f5996') where requestid='"+requestid+"'";
		baseJdbc.update(isql2);//更新主表
		return;
	}
%>