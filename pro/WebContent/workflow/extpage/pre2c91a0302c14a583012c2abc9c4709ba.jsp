<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//当前工作流包含表单是抽象表单
//收入合同评审－主表	ID:2c91a0302bbcd476012c063ea1422a51
//	编号:	flowNO
//	清单:	attach2
//	评审内容5:	review5
//	意见1:	advise1
//	项目负责部门:	prjdept
//	顾客名称:	customer
//	合同计划结束时间:	planendtime
//	评审内容7:	review7
//	评审内容10:	review10
//	意见3:	advise3
//	评审表附件（A）和参考文件（R）清单:	attach3
//	流程状态:	flowstate
//	支出预算总金额:	money3
//	合同计划开始时间:	planstarttime
//	合同类型:	ctrtype
//	预算中间产品(或大宗材料):	content3
//	申请部门负责人:	reqdeptprincipal
//	合同主要内容:	content
//	预算采购服务主要内容:	content2
//	总金额2:	money2
//	评审内容2:	review2
//	评审内容4:	review4
//	合同名称:	contract
//	附件:	attach
//	评审内容6:	review6
//	评审内容9:	review9
//	评审内容12:	review12
//	评审内容14:	review14
//	评审内容15:	review15
//	评审次数:	reviewtimes
//	合同金额:	ctrmoney
//	总金额:	money1
//	申请人:	reqman
//	评审内容1:	review1
//	评审内容8:	review8
//	评审内容11:	review11
//	评审内容16:	review16
//	实施部门:	impldept
//	数量:	amount
//	评审内容3:	review3
//	评审内容13:	review13
//	签名1:	sign1
//	签名2:	sign2
//	签名3:	sign3
//	意见2:	advise2
//	意见4:	advise4
//	意见5:	advise5
//	业务部门:	orgid
//	当前节点:	currentnode
//	申请人事业部:	orgunit
//	申请部门:	reqdept
//	合同洽谈组成员:	groupmember
//	洽谈情况:	talkcase
//	意见6:	advise6
//	供方名称:	supplier
//	关联采购批准:	relbug
//	采购对象:	buyobject
//	来源类型:	sourcetype
//	洽谈结果:	talkresult
//	签字4:	sign4
//合同-跨事业部拆分表	ID:2c91a0302b98c1b4012b99022b270015
//	备注:	remark
//	合同号:	contractno
//	分配金额:	distsum
//	业务部门:	orgid
//	pid:	pid
//---------------------------------------
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.msg.*"%>
<%
//---------------------------------------
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
String operatemode = request.getParameter("operatemode");
//提交的
if(operatemode.equals("reject")){
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	baseJdbc.update("update uf_ctr_income set reviewtimes=nvl(reviewtimes,1)+1 where requestid='"+requestid+"'");
}
targeturl="/workflow/request/close.jsp?mode=submit";
%>
<script>
var commonDialog=top.leftFrame.commonDialog;
if(commonDialog){
	var frameid=parent.contentPanel.getActiveTab().id+'frame';
	var tabWin=parent.Ext.getDom(frameid).contentWindow;
	if(!commonDialog.hidden)
	{
		commonDialog.hide();
		tabWin.location.reload();
	}
	else
	{
		tabWin.location.href="<%=targeturl%>";
	}
}
</script>

