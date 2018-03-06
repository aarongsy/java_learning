<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitemtype" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemtypeService" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ include file="/base/init.jsp"%>


<html>
  <head><title>Simple jsp page</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
    <script src='<%= request.getContextPath()%>/dwr/interface/HumresExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/UsersWorkflowExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>

      <%//导入
        pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190071")+"','I','accept',function(){importRecords()});";
        pagemenustr +="addBtn(tb,'导出Excel模板','E','accept',function(){downloadExcel()});";


        String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
        String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
				String throwstr = StringHelper.null2String(request.getParameter("throwstr"));
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.override(Ext.tree.TreeLoader, {
        createNode : function(attr){
            // apply baseAttrs, nice idea Corey!
            if(this.baseAttrs){
                Ext.applyIf(attr, this.baseAttrs);
            }
            if(this.applyLoader !== false){
                attr.loader = this;
            }
            if(typeof attr.uiProvider == 'string'){
               attr.uiProvider = this.uiProviders[attr.uiProvider] || eval(attr.uiProvider);
            }

            var n = (attr.leaf ?
                            new Ext.tree.TreeNode(attr) :
                            new Ext.tree.AsyncTreeNode(attr));

        if (attr.expanded) {
                n.expanded = true;
            }

            return n;
        }
    });
        var outBtn;
        var total=0;
        var currentCount=0;
        var lostnum=0;
        var refresstimer;
        var pbar1;
        var isfinish = "0";
      Ext.onReady(function(){
            pbar1 = new Ext.ProgressBar({
               text:'0%'
            });

           <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>
      })
      var Runner = function(){
          var f = function(pbar,count, cb){

              return function(){
                  doRefresh();
                  if(isfinish=="1"){
                      clearInterval(refresstimer);
                      cb();
                  }else{
                          var i = currentCount/count;
                          pbar.updateProgress(i, Math.round(100*i)+'%');
                  }
             };
          };
          return {
              run : function(pbar, count, cb){
                  var ms = 5000/count;
                    try{
                    refresstimer=setInterval(f(pbar, count, cb),2);
                    }catch(e){}
              }
          }
      }();

      </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.customaction.zgdz55.ImportHumresDataAction?action=xmlupload" name="EweaverForm" id="EweaverForm" method="post" enctype="multipart/form-data">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190070")%></TD><TR><!-- 请在下面选择需要导入的excel文档 -->
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center"><input type="file" name="path" /></TD><TR>
            <tr><td colspan=3 align="center">
                <br/>
								 <div id="finishmessage" <%if(throwstr.length()<1)out.println("style=\"display:none;\"");%>>
                    <span href="javascript:void(0)"><%=throwstr%></span>
<%
if(request.getAttribute("errorMsg")!=null){
	out.println("<span style='color:red;font-weight:bold;'>ERROR:</span><br/>");
	out.println(request.getAttribute("errorMsg"));
}
%>
						</div>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
 
                </div>
                </div>
              
                <br/>
        </td></tr>
	    </table>
        </form>
      <iframe id="upload_faceico" name="upload_faceico" src="<%=request.getContextPath()%>/base/module/upload_faceico.jsp" width="0" height="0" style="top:-100px;">
      </iframe>
      </div>
    <div id="messagePage">
        <table style="border:0">
            <TR><TD><span id="message" name="message" style="font-size:12"></span></TD></TR>
            </table>
      </div>
  </body>
<script language="javascript">
      var path="";

      function downloadExcel(){
    	  document.forms[0].action="/ServiceAction/com.eweaver.excel.servlet.ExpHumresAction";
          document.forms[0].submit();
      }
    function importRecords(){
		isfinish="0";
		document.getElementById("finishmessage").style.display="none";
		if(document.forms[0].path.value==""||document.forms[0].path.value==null){
			alert("<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190072")%>");//你还没有选择需要导入的excel文档
			return;
		}
      	document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ImportHumresDataAction?action=xmlupload";
	 	document.forms[0].submit();
    }
</script>
</html>
