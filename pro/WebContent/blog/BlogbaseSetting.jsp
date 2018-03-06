<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%--<%@ include file="/systeminfo/init.jsp" %>--%>
<%@ include file="/blog/bloginit.jsp" %>
<%--<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />--%>
<%--<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />--%>
<%--<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />--%>
<%--<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
/*
if (!HrmUserVarify.checkUserRight("blog:baseSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}*/
String imagefilename = "/ecology/images/hdSystem.gif";
String titlename ="微博基本设置"; //微博基本设置
String needfav ="1";
String needhelp ="";

String userid="";
userid=user.getId();

String operation=StringHelper.null2String(request.getParameter("operation"));

String allowRequest="";   //允许关注申请
String enableDate="";     //微博启用时间
String isSingRemind="";   //签到提交提醒
String isManagerScore=""; //启用上级评分
String attachmentDir="";  //微博附件上传目录
String pathcategory = "";
String isAttachment="0";

String sqlstr="select * from blog_sysSetting";
List list1= baseJdbcDao.executeSqlForList(sqlstr);
if(list1.size()>0){
Map map = (Map)list1.get(0);
allowRequest=StringHelper.null2String(map.get("allowRequest"));
enableDate=StringHelper.null2String(map.get("enableDate"));
isSingRemind=StringHelper.null2String(map.get("isSingRemind"));
isManagerScore=StringHelper.null2String(map.get("isManagerScore"));
attachmentDir=StringHelper.null2String(map.get("attachmentDir"));
}
if(attachmentDir!=null&&!attachmentDir.equals("")){
    String attachmentDirs[]=StringHelper.TokenizerString2(attachmentDir,"|");
    /*
    pathcategory = "/"+MainCategoryComInfo.getMainCategoryname(attachmentDirs[0])+
                  "/"+SubCategoryComInfo.getSubCategoryname(attachmentDirs[1])+
                  "/"+SecCategoryComInfo.getSecCategoryname(attachmentDirs[2]);
    */
}
	
List list = baseJdbcDao.executeSqlForList("select isActive from blog_app WHERE appType='attachment'");
if(list.size()>0){
	Map map = (Map)list.get(0);
	isAttachment=StringHelper.null2String(map.get("isActive"));
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<SCRIPT language="javascript" src="/ecology/js/datetime.js"></script>
<SCRIPT language="javascript" src="/datapicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" type="text/css" id="global_css" href="/css/skins/default/global.css"/>
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/xtheme-gray.css"/>
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
<%-- <%@ include file="/systeminfo/TopTitle.jsp" %>--%>
<%-- <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>--%>
 <%-- 
	 RCMenu += "{保存,javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 --%>
<%--<%@ include file="/systeminfo/RightClickMenu.jsp" %>--%>
<%
String pagemenustr =  "addBtn(tb,'保存','S','accept',function(){doSave()});";
%>
<div id="pagemenubar"> </div>
  <form action="BlogSettingOperation.jsp" method="post" id="mainform">
    <input type="hidden" value="editBaseSetting" name="operation"/> 
    <TABLE class=ViewForm style="width: 98%" align="center">
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		<TBODY>
			<TR class=Title>
				<TH colSpan=2>基本设置</TH> <!-- 基本设置 -->
			</TR>
			
			<TR class=Spacing style="height: 1px;">
			<TD class=Line1 colSpan=2></TD>
			</TR>
		
			<tr>
			  <td>允许申请关注</td> <!-- 允许申请关注 -->
			  <td class=Field>
				<input type="checkbox"  <%=allowRequest.equals("1")?"checked=checked":""%>  name="allowRequest" onclick="changeBox(this)"  value="<%=allowRequest.equals("1")?"1":"0"%>" />
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			<tr>
			  <td>微博启用时间</td> <!-- 微博启用时间 -->
			  <td class=Field>
			       <BUTTON type="button" class=calendar  onclick="onShowDate(enableDatespan,enableDate)"></BUTTON> 
			       <input type="hidden"  name="enableDate" id="enableDate" value=<%=enableDate%>>
		           <SPAN id=enableDatespan style="font-weight:normal !important;color:#000000 !important;"><%=enableDate%></SPAN>
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
			<tr>
			  <td>直接上级评分</td> <!-- 启用上级评分 -->
			  <td class=Field>
			      <input type="checkbox"  <%=isManagerScore.equals("1")?"checked=checked":""%> name="isManagerScore" onclick="changeBox(this)"  value="<%=isManagerScore.equals("1")?"1":"0"%>" />
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
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
  function changeBox(obj){
	var bool = obj.checked
	if(bool){
		obj.value="1"
	}else{
		obj.value="0"
	}
	
  }
  function doSave(){
     if(jQuery("#enableDate").val()==""){
       alert("请填写微博启用时间");
       return ;
     }  
     jQuery("#mainform").submit();
  }
  
  function onShowCatalog() {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
           jQuery("#mypathspan").html(wuiUtil.getJsonValueByIndex(result,2));
          //result[2] 路径字符串   result[3] maincategory result[4] subcategory  result[1] seccategory
          jQuery("#attachmentDir").val(wuiUtil.getJsonValueByIndex(result,3)+"|"+wuiUtil.getJsonValueByIndex(result,4)+"|"+wuiUtil.getJsonValueByIndex(result,1));
        }else{
        if("<%=isAttachment%>"=="1")
          jQuery("#mypathspan").html("<IMG src='/ecology/images/BacoError.gif' align=absMiddle>");
        else
          jQuery("#mypathspan").html("");  
          jQuery("#attachmentDir").val("");
        }
    }
   }
  
 </script>
</html>
