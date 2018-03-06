<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%@ include file="/blog/bloginit.jsp" %>
<%--<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String userid="";
userid=user.getId();

String operation=StringHelper.null2String(request.getParameter("operation"));

String isReceive="1";     //是否接收关注申请
String maxAttention="50"; //最大关注人数
String isThumbnail="1";   //是否显示缩略图

String sqlstr="select * from blog_setting where userid='"+userid+"'";
//RecordSet.execute(sqlstr);
List list = baseJdbcDao.executeSqlForList(sqlstr);
if(list.size()>0){
	Map RecordSet = (Map)list.get(0);
	isReceive=StringHelper.null2String(RecordSet.get("isReceive"));
	isThumbnail=StringHelper.null2String(RecordSet.get("isThumbnail"));
	maxAttention=StringHelper.null2String(RecordSet.get("maxAttention"));
}else{
	sqlstr="insert into blog_setting(userid,isReceive,isThumbnail,maxAttention) values('"+userid+"',1,1,50)";
	baseJdbcDao.update(sqlstr);
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/default/global.css"/>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/xtheme-gray.css"/>
<LINK href="/ecology/css/Weaver.css" type='text/css' rel='STYLESHEET'>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
 </style>
  </head>
  <body>
<%-- <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
 <% 
	 //RCMenu += "{保存,javascript:doSave(),_self} ";
	 //RCMenuHeight += RCMenuHeightStep ;
	 String pagemenustr =  "addBtn(tb,'保存','S','accept',function(){doSave()});";
	      
 %>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<div id="pagemenubar"> </div> 
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" >
    <input type="hidden" value="edit" name="operation"/> 
    <TABLE class=ViewForm style="width: 98%;margin-left: 10px;"> 
		<COLGROUP>
		<COL width="30%">
		<COL width="20%">
		<COL width="50%">
		<TBODY>
			<TR class=Title>
				<TH colSpan=3>基本设置</TH><!-- 基本设置 -->
			</TR>
			
			<TR class=Spacing style="height: 1px;">
			<TD class=Line1 colSpan=3></TD>
			</TR>
		
			<tr>
			  <td>接收关注申请</td><!-- 接收关注申请 -->     
			  <td class=Field>
				<input type="checkbox" name="isReceive" <%=isReceive.equals("1")?"checked=checked":""%> value="1" />
			  </td>
			  <td class="Field">
			    <span style="color: #666666"></span>
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=3></TD></TR>
			
			<tr style="display: none">
				  <td>关注人数上限</td>
				  <td class=Field>
					<input type="text" name="maxAttention" value="<%=maxAttention%>" style="width: 35px" size="4">
				  </td>
				  <td class="Field">
				    <span style="color: #666666">(最多可以关注的人数)</span>
				  </td>
				</tr>
				<TR style="height: 1px;"><TD class=Line colspan=3></TD></TR>
			<tr style="display: none">
			  <td>显示人员缩略图</td>
			  <td class=Field>
				<input type="checkbox" name="isThumbnail" <%=isThumbnail.equals("1")?"checked=checked":""%>  value="1" />
			  </td>
			  <td class="Field">
			    <span style="color: #666666"></span>
			  </td>
			</tr>			
			<TR style="display: none"><TD class=Line colspan=3></TD></TR>
		</TBODY>
	</TABLE>
	</form>  
  </body>
<script type="text/javascript"> 
     Ext.onReady(function() {
         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     });
 </script>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
 </script>
</html>
