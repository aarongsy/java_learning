<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.IDGernerator" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String tabid = request.getParameter("tabid");
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402881e50b8e316a010b8e6a55fb0008") %></title>

<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
</head>
<body>
<form action="/app/base/tabinfo.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="submit"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
<colgroup>
<col width="15%"/>
<col width="35%"/>
<col width="15%"/>
<col width="35%"/>
</colgroup>
<%
StringBuffer buf = new StringBuffer();
	String sql = "select id,objname,objtablename from forminfo where objtype=0 and  isdelete=0   order by objtablename";
	List tablist= baseJdbc.executeSqlForList(sql);
	buf.append("<tr>");
	buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c1c82a0134c1c82b4f0000")+":</td>");//数据表
	buf.append("<td class=\"FieldValue\">");
	buf.append("<select style=\"width:95%\" class=\"inputstyle2\" id=\"tabid\"  name=\"tabid\" onchange=\"javascript:onSearch();\">");
	buf.append("<option value=\"\"   ></option>");
	
	for(int k=0,sizek=tablist.size();k<sizek;k++)
	{
		Map tabm = (Map)tablist.get(k);
		String id=StringHelper.null2String(tabm.get("id"));
		String objname=StringHelper.null2String(tabm.get("objname"));
		String objtablename=StringHelper.null2String(tabm.get("objtablename"));	

		String tempstr=StringHelper.null2String(tabid);
		if(id.equals(tempstr))
		{
			buf.append("<option value=\""+id+"\"  selected>"+objname+":"+objtablename+"</option>");
		}
		else
		{
			buf.append("<option value=\""+id+"\">"+objname+":"+objtablename+"</option>");
		}
			
	}
	buf.append("</select>");
	buf.append("</td>");
	buf.append("</tr>");
	sql="select A.id,A.fieldname,A.htmltype,A.fieldtype,a.labelname from formfield a where a.isdelete='0' and formid='"+tabid+"'";
	List fieldlist= baseJdbc.executeSqlForList(sql);
	buf.append("<tr>");
	buf.append("<td colspan=4>");
	buf.append("<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\" style=\"border-collapse:collapse;width:100%\" bordercolor=\"#333333\">");
	buf.append("<colgroup>");
	buf.append("<col width=\"150\" />");
	buf.append("<col width=\"200\" />");
	buf.append("<col width=\"100\" />");
	buf.append("<col width=\"100\" />");
	buf.append("</colgroup>");																													
	buf.append("<tr style=\"background:#FAF9FB;border:1px solid #EEF4FD;height:20;\">");
	buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402881e60b95cc1b010b96212bc80009")+"</td>");//字段名称
	buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402883d934c1ca1c0134c1ca1c860000")+"</td>");//字段标识
	buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883d934c1cb510134c1cb52780000")+"</td>");//表现类型
	buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("4028834634e95e120134e95e14550021")+"</td>");//表现内容
	buf.append("</tr>");
	buf.append("<tbody>");
	for(int i=0,sizei=fieldlist.size();i<sizei;i++)
	{
		Map m = (Map)fieldlist.get(i);
		String ida=StringHelper.null2String(m.get("id"));
		String fieldnamea=StringHelper.null2String(m.get("fieldname"));
		String htmltypea=StringHelper.null2String(m.get("htmltype"));
		String fieldtypea=StringHelper.null2String(m.get("fieldtype"));
		String labelnamea=StringHelper.null2String(m.get("labelname"));
		buf.append("<tr style=\"height:20;\">");
		buf.append("<td align=\"left\">"+fieldnamea+"</td>");
		buf.append("<td align=\"left\">"+labelnamea+"</td>");
		buf.append("<td align=\"left\">"+htmltypea+"</td>");
		buf.append("<td align=\"left\">"+fieldtypea+"</td>");
		
		buf.append("</tr>");			
	}
	buf.append("</tbody></table>");
	buf.append("</td>");
	buf.append("</tr>");
out.println(buf.toString());
%>
</tbody>
</table>
</form>
</body>
</html>
<script>
function onSearch(){
	document.getElementById('exportType').value="";
	if(checkIsNull())
		document.forms[0].submit();
}
function checkIsNull()
{
	return true;
}
</script>