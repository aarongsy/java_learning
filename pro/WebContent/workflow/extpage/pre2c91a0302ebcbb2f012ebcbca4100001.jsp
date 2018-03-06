<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
//----------------------若变更类型为变更，更新合同表的金额，附件字段；若变更类型为废止，更新合同表的状态为已废止-----------------
String requestid= request.getParameter("requestid");
String targeturl = request.getParameter("targeturl");
//String operatemode = request.getParameter("operatemode");a
//提交的
//if(operatemode.equals("submit")||operatemode.equals("save")){
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List checklist= baseJdbc.executeSqlForList("select altertype,ctrattach,ctrmoney,bg1,bg2,ctrno from uf_srctr_alter where requestid='"+requestid+"'");
	if(checklist.size()>0){
		Map m1 = (Map)checklist.get(0);
		//变更类型  altertype
		String altertype = StringHelper.null2String(m1.get("altertype"));
		//附件  ctrattach
		String ctrattach = StringHelper.null2String(m1.get("ctrattach"));
		//合同金额  ctrmoney
		String ctrmoney = StringHelper.null2String(m1.get("ctrmoney"));
		//预算采购服务  bg1
		String bg1= StringHelper.null2String(m1.get("bg1"));
		//预算中间产品（或大宗材料）  bg2
		String bg2= StringHelper.null2String(m1.get("bg2"));
        //合同编号  ctrno
		String ctrno = StringHelper.null2String(m1.get("ctrno"));
        
        //如果是合同变更类型
        if("2c91a0302bbcd476012c108b52643d8a".equals(altertype.trim())){
        	baseJdbc.update("update uf_contract set money='"+ctrmoney+"',electrontext='"+ctrattach+"',bg1='"+bg1+"',bg2='"+bg2+"' where requestid='"+ctrno+"'");
        }else if("2c91a0302bbcd476012c108b52643d8b".equals(altertype.trim())){
        	baseJdbc.update("update uf_contract set state='2c91a0302ab11213012ab12bf0f00021' where requestid='"+ctrno+"'");
        }
    }
//}

%>
<%
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

