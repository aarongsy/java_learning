<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-5
  Time: 14:06:07
  To change this template use File | Settings | File Templates.
--%>
<html>
  <head><title>人员权限检索</title>

<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/HumresExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersWorkflowExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
<%

    pagemenustr +="addBtn(tb,'提交','E','accept',function(){sAlert()});";
%>

    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });

            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>

      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
	});
});
    function sAlert(){
        if(document.getElementById("requestid").value==''){
            alert("请选择需要处理的人员！");
        }else{
//            document.EweaverForm.action="getPerm.jsp?userid="+document.getElementById("requestid").value;
            document.EweaverForm.submit();
        }
    }
</script>

  <style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript">


  </script>
  </head>
  <body>
<div id="divSum">
 <div id="pagemenubar"></div>
  <%--<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download" enctype="multipart/form-data" method="post">--%>
  <%--</form>--%>
<form action="getPerm.jsp" name="EweaverForm" id="EweaverForm" method="post">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center">请在下面选择需要处理的人员</TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
        <tr>
            <td align="center" colspan="3">
            <button type="button" class="Browser" onclick="onShowMutiResource('requestidSpan','requestid')"></button>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="3">
            <input type="hidden" name="requestid" value="<%=currentuser.getId()%>"/>
			<span id = "requestidSpan"><%=currentuser.getObjname()%></span>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="3">
            &nbsp;
            </td>
        </tr>
	    </table>
        </form>
 </div>
</body>

<script type="text/javascript">
    function onShowMutiResource(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/humres/base/humresbrowser.jsp?sqlwhere=hrstatus%3D'4028804c16acfbc00116ccba13802935'&humresidsin="+document.all(inputname).value);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    
</script>
</html>