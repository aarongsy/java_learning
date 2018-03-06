<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
IDGernerator idGernerator = new IDGernerator();
EweaverUser newUser = BaseContext.getRemoteUser();
String newuserid = newUser.getId();//当前登录用户
String createdate = new Date().toLocaleString();
String [] getarry = createdate.split(" ");
String getdate = getarry[0].toString();
String gettiem = getarry[1].toString();
DataService dataService = new DataService();
String quesname = StringHelper.null2String(request.getParameter("quesname"));//问卷名称
String quesperson = StringHelper.null2String(request.getParameter("quesperson"));//问卷设计人
String quesdept = StringHelper.null2String(request.getParameter("quesdept"));//问卷设计人部门
String quesdate = StringHelper.null2String(request.getParameter("quesdate"));//问卷设计日期
String requid = idGernerator.getUnquieID();
String desisql = "insert into uf_qst_designermain(id,requestid,nodeid,rowindex,qstname,bookman,bookdept,orgid,qsttype,bookdate) "+
	"values('"+idGernerator.getUnquieID()+"','"+requid+"','','','"+quesname+"','"+quesperson+"','"+quesdept+"','"+quesdept+"','','"+quesdate+"')";
dataService.executeSql(desisql);
String formbasesql = "insert into formbase(id,creator,createdate,createtime,modifier,modifytime,isdelete,categoryid,col1,col2,col3) "+
	"values('"+requid+"','"+newuserid+"','"+getdate+"','"+gettiem+"','','',0,'','','','')";
dataService.executeSql(formbasesql);
%>
