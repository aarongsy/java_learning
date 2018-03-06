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
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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
       // pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190071")+"','I','accept',function(){importRecords()});";
        //pagemenustr +="addBtn(tb,'导出Excel模板','E','accept',function(){downloadExcel()});";


        String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
        String requestid = StringHelper.null2String(request.getParameter("requestid"));
		String throwstr = StringHelper.null2String(request.getParameter("throwstr"));
		System.out.println("throwstr"+throwstr);

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
<form action="/ServiceAction/com.eweaver.app.exceltest.ReadNMXJExcel?requestid=<%=requestid%>" name="form1" id="form1" method="post" enctype="multipart/form-data">
        <table style="border:0">
				<colgroup>
					<col width="100%">
				</colgroup>
            <TR><TD colspan=3 align="center"><input type="file" name="path" /><A href="javascript:importRecords()"><FONT color=#ff0000>Excel导入报价明细</FONT></A><input type="hidden" id="throwstr" value="<%=throwstr%>"></TD><TR>
	    </table>
        </form>

      </div>
  </body>
<script language="javascript">
      var path="";
	  if(document.getElementById('throwstr').value=='success')
	  {
		  //window.parent.location.reload();
		  window.parent.showRecords();
	  }
    function importRecords(){
	 	document.getElementById('form1').submit();
    }
</script>
</html>
