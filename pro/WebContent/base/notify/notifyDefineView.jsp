<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>

<% 
   String id = StringHelper.null2String(request.getParameter("id"));
   NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
   ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
   NotifyDefine notifyDefine = notifyDefineService.get(id);
%> 
<html>
  <head>
  </head>
  
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{M,"+labelService.getLabelName("402881e70b774c35010b7750a15b000b")+",javascript:location.href='"+request.getContextPath()+"/base/notify/notifyDefineModify.jsp?id="+id+"'}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

 <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.notify.servlet.NotifyDefineAction?action=modify" name="EweaverForm"  method="post">
 <table class=noborder>
    <input type="hidden" name="id" value="<%=id%>"/>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	
	<tr class=Title>
		<th colspan=2 nowrap>提醒信息</th>
	</tr>
	<tr>
    	<td class="Line" colspan=2 nowrap>
		</td>		        	  
	 </tr>	
	 <tr>
	    <td class="FieldName" nowrap>
			提醒名称
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(notifyDefine.getNotifyName())%>
		</td>
	 </tr>	
 	 <tr>
	    <td class="FieldName" nowrap>
			提醒内容
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(notifyDefine.getContent())%>
		</td>
	 </tr> 	
	 <%
	   String selectitemname = "";
         if(notifyDefine.getRemindType()==1){
            selectitemname = "到期提醒";
         }else if(notifyDefine.getRemindType()==2){
             selectitemname = "周年提醒";
         }else if(notifyDefine.getRemindType()==4){
            selectitemname = "即时提醒";
         }
	 %>
	 <tr>
	   <td class="FieldName" nowrap>
			提醒类型
	   </td>
	   <td class="FieldValue">
			<%=selectitemname%>				
		</td>
	 </tr>
     <tr>
	   <td class="FieldName" nowrap>
			提醒方式
	   </td>
	   <td class="FieldValue">
			<%if(notifyDefine.getIspopup()==1){%>弹出式提醒	&nbsp;<%}%>
            <%if(notifyDefine.getIsemail()==1){%>邮件提醒	&nbsp;<%}%>
            <%if(notifyDefine.getIssms()==1){%>短信提醒	&nbsp;<%}%>
            <%if(notifyDefine.getIsrtx()==1){%>即时通讯	&nbsp;<%}%>
		</td>
	 </tr>
	 <tr <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	    <td class="FieldName" nowrap>
			提前时间
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(notifyDefine.getAhead())%>天<%if(notifyDefine.getAhour()!=null&&!("").equals(notifyDefine.getAhour())){%><%=StringHelper.null2String(notifyDefine.getAhour())%>小时<%}%><%if(notifyDefine.getAminutes()!=null&&!("").equals(notifyDefine.getAminutes())){%><%=StringHelper.null2String(notifyDefine.getAminutes())%>分<%}%>
		</td>
	 </tr>
     <tr <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	    <td class="FieldName" nowrap>
			实际表单
	   </td>
	   <td class="FieldValue">
	      <%=forminfoService.getForminfoById(notifyDefine.getFormId()).getObjname()%>
		</td>
	 </tr>
     <tr <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	    <td class="FieldName" nowrap>
			表单日期字段
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(notifyDefine.getDateField())%>
		</td>
	 </tr>
     <tr <%if(notifyDefine.getRemindType().equals(4)){%>style="display:none" <%}%>>
	    <td class="FieldName" nowrap>
			表单时间字段
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(notifyDefine.getTimeField())%>
		</td>
	 </tr>
 </table>
 </form>
  </body>
</html>
