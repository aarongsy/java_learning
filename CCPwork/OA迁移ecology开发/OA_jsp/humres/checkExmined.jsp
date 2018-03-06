<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.humres.base.model.Humres" %><%
	String exmman= request.getParameter("exmman");
	String exmyear= request.getParameter("exmyear");
	String exmyearhalf= request.getParameter("exmyearhalf");
	EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
	String userid=eweaveruser1.getId();
	String requestid= request.getParameter("requestid");
	String returnstr="0";
	DataService ds = new DataService();
	String status="";
	status = ds.getValue("SELECT STATUS FROM uf_hrm_examinedate WHERE requestid='"+exmyear+"'");
	if(!(status!=null&&status.equals("4028803b21381b8d0121387683c90074")))
	{
		returnstr="1";//年度考核已停止
	}
	else
	{
		List examine = ds.getValues("SELECT REQUESTID FROM uf_hrm_examine WHERE exmman='"+exmman+"' and exmyear='"+exmyear+"'  and exmyearhalf='"+exmyearhalf+"'  and manager='"+userid+"'");
		if(requestid!=null&&requestid.length()>0)
		{
			returnstr="0";
		}
		else
		{
			if(examine.size()>0)
			{
				returnstr="2";//考核已存在
			}
		}
	}
	out.println(returnstr);
%>