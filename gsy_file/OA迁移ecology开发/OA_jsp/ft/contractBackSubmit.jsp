<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="java.text.SimpleDateFormat" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.workflow.request.service.FormService" %><%@ page import="com.eweaver.workflow.form.model.*" %><%@ page import="com.eweaver.workflow.form.service.*" %><%@ page import="com.eweaver.base.security.util.*" %><%
	
	String type = request.getParameter("action");
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	if(type.equals("contractBackSubmit"))//合同返回确认
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));
		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		doSubmit(ids,baseJdbc);
		out.println("yes");
	}
%>
<%!

public void doSubmit(String ids,BaseJdbcDao baseJdbc)
{
	PermissionTool permissionTool = new PermissionTool();
	FormBaseService formbaseService=(FormBaseService)BaseContext.getBean("formbaseService");
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	
	List ls=baseJdbc.executeSqlForList("select a.requestid from uf_contract a where a.requestid in ("+ids+")");
	List requestlist=new ArrayList();
	if(ls.size()>0)
	{
		for(int i=0,size=ls.size();i<size;i++)
		{
			Map m = (Map)ls.get(0);
			String requestida=m.get("requestid").toString();
			requestlist.add(requestida);
			//修改为失效状态
			baseJdbc.update("update uf_contract set  isback='2c91a0302b278cea012b28d82e7f001d' where requestid='"+requestida+"'");
		}
		for(int i=0,size=requestlist.size();i<size;i++)
		{
			//删除原有权限
			String delSQL1 = "delete from permissionrule where objid='"+requestlist.get(i).toString()+"'";
			String delSQL2 = "delete from permissiondetail where objid='"+requestlist.get(i).toString()+"'";
			baseJdbc.update(delSQL1);
			baseJdbc.update(delSQL2);
			//重构权限信息
			permissionTool.addPermission("402881162c3940f0012c39fc02b301a4",requestlist.get(i).toString(),"uf_device_result");
		}
	}
}

%>