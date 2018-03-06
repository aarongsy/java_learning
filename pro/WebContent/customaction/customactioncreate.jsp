
<%@ page import="com.eweaver.customaction.service.CustomactionService" %>
<%@ page import="com.eweaver.customaction.model.Customaction" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<%
String objname=StringHelper.null2String(request.getParameter("objname"));
String formid=StringHelper.null2String(request.getParameter("formid"));
ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
%>
<%

    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onConfirm()});";
     pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";

%>
  <head>
      <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
   </style>

      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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

  </head>
  <body>
  <div id="divSearch">
      <div id="pagemenubar" style="z-index:100;"></div>
  <form name="EweaverForm" method="post" action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.servlet.CustomactionAction?action=create">
  <table>
	<colgroup>
		<col width="50%">
		<col width="50%">
	</colgroup>

  <tr>
	<td valign=top>
		       <table class=noborder>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>

                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790048")%><!-- 操作名称 -->
					</td>
					<td class="FieldValue">
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=objname%>">
					</td>
				</tr>
                     <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a004a")%><!-- 表单 -->
					</td>
					<td class="FieldValue">
                         <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp','formid','formidspan','0');"></button>
                        <input type="hidden"  name="formid" id="formid" value="<%=formid%>"/>
                                 <%
                                 Forminfo forminfo=forminfoService.getForminfoById(formid);
                                 %>
                        <span id="formidspan"><%=StringHelper.null2String(forminfo.getObjname())%></span>
					</td>
				</tr>
                   <tr>
                       <td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                       </td>
                       <td class="FieldValue">
                         <textarea rows="5" cols="50" id="description" name="description" ></textarea>
                       </td>
                   </tr>
			 </table>
	  </td>

</table>

</form>
      </div>
   <script type="text/javascript">
       function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        var objname=document.getElementById("objname").value;
        try {
            id = openDialog(contextPath + '/base/popupmain.jsp?url=' + viewurl);
        } catch(e) {
        }
        if (id != null) {
            if (id[0] != '0') {
                document.all(inputname).value = id[0];
                document.all(inputspan).innerHTML = id[1];
                window.location="customactioncreate.jsp?objname="+objname+"&formid="+id[0];

            } else {
                document.all(inputname).value = '';
                if (isneed == '0')
                    document.all(inputspan).innerHTML = '';
                else
                    document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
        }
    }
       function onConfirm(){
          document.EweaverForm.submit();
       }
       function onReturn(){
            window.location="customactionlist.jsp";
       }
   </script>
  </body>
</html>