<%@page import="java.sql.SQLException"%>
<%@page import="org.hibernate.HibernateException"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.springframework.orm.hibernate3.HibernateCallback"%>
<%@page import="org.springframework.orm.hibernate3.HibernateTemplate"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>

<% 
   String id = StringHelper.null2String(request.getParameter("id"));
   SysGroupService sysGroupService = (SysGroupService) BaseContext.getBean("sysGroupService");
   FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
   SysGroup sysGroup = sysGroupService.get(id);
   
   HibernateTemplate hibernateTemplate = (HibernateTemplate) BaseContext.getBean("hibernateTemplate");
   List<?> userList = hibernateTemplate.find("select objid from Sysuser where id in (select userid from Sysuserrolelink where roleid = ?)", new Object[]{"402881e50bf0a737010bf0a96ba70004"});
   boolean isAdmin = userList.contains(eweaveruser.getId());
%> 
<html>
  <head>
  </head>
  
  <body>
<!--页面菜单开始-->     
<%
if ((isAdmin && "1".equals(sysGroup.getGrouptype())) || (eweaveruser.getId().equals(sysGroup.getCreator()) && "2".equals(sysGroup.getGrouptype()))) {
	pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e70b774c35010b7750a15b000b") + "','M','add',function(){location.href='"+request.getContextPath()+"/base/security/sysgroup/sysGroupModify.jsp?id="+id+"';});";
	pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aa85b6e010aa8624c070003") + "','D','delete',function(){onDelete()});";
}
//pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aabb6f6010aabe32990000f") + "','B','arrow_redo',function(){window.close()});";
%>
      <style type="text/css">
          .x-toolbar table {
              width: 0
          }

          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
      </style>
      <script src='<%= request.getContextPath()%>/dwr/interface/SysresourceService.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

      <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
      <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
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
<div id="pagemenubar" style="z-index:100;"></div> 
<!--页面菜单结束-->

 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysroleAction?action=modify" name="EweaverForm"  method="post">
 <table class=noborder>
    <input type="hidden" name="id" value="<%=id%>"/>
    <input type="hidden" name="ids" value="<%=id%>"/>
    
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	
	<tr class=Title>
		<th colspan=2 nowrap></th>
	</tr>
	<tr>
    	<td class="Line" colspan=2 nowrap>
		</td>		        	  
	 </tr>	
	 	  <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001")%><!-- 顺序 -->
	   </td>
	   <td class="FieldValue">
			<%=StringHelper.null2String(sysGroup.getDsporder())%>
		</td>
	 </tr> 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003")%><!-- 名称 -->
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(sysGroup.getGroupname())%>
		</td>
	 </tr>	
 	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000")%>
	   </td>
	   <td class="FieldValue">
	      <%=StringHelper.null2String(sysGroup.getGroupdesc())%>
		</td>
	 </tr> 	
	 <%
	   String selectitemname =sysGroup.getGrouptype().equals("1")?labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050002"): labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050003");
	 %>
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c002e")%><!-- 类型 -->
	   </td>
	   <td class="FieldValue">
			<%=selectitemname%>				
		</td>
	 </tr>	
	  <tr>
	   <td class="FieldName" nowrap>
         <%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c0031")%><!-- 排序 -->
	   </td>
	   <td class="FieldValue">

           <%
                String str="";
            if(!StringHelper.isEmpty(sysGroup.getOrderfield())){
                if("asc".equals(sysGroup.getOrdercontent())){
                    str=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000");
                }else{
                    str=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000");
                }
           %>
           	<%=formfieldService.getFormfieldById(sysGroup.getOrderfield()).getLabelname()%>
              <%=str%>
           <%}%>

		</td>
	 </tr>
 </table>
 </form>
  </body>
</html>
<script>
 function onDelete(){
 	EweaverForm.action = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=delete";
 	document.EweaverForm.submit();
 }
 </script>
      
