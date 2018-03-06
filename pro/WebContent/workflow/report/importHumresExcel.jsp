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

      <%
        pagemenustr +="addBtn(tb,'导入','I','accept',function(){importRecords()});";


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
            //==== Progress bar1  ====
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
            <TR><TD class=Spacing colspan=3 align="center">请在下面选择需要导入的excel文档</TD><TR>
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

      function downloadLostRecord(){
          document.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download&path="+path;
      }
    function importRecords(){
				isfinish="0";
				document.getElementById("finishmessage").style.display="none";
				if(document.forms[0].path.value==""||document.forms[0].path.value==null){
					alert("你还没有选择需要导入的excel文档");
					return;
				}
      //frames["upload_faceico"].document.getElementById("pathtext").value="";
      document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.util.ImportHumresDataAction?action=xmlupload";
			document.forms[0].submit();
			//getPath();
    }
    function getPath(){
      /* path = frames["upload_faceico"].document.getElementById("pathtext").value;

       if(path==""||path==null){
           setTimeout("getPath()",1000);
    }else{
    total=0;
    currentCount=0;
       Ext.fly('p1').setDisplayed(true);
       Ext.fly('p1text').update('');
    if (!pbar1.rendered){
           pbar1.render('p1');
    }else{
           pbar1.text = '0%';
    pbar1.show();
    }
    sAlert();
    if(total==-1){
    pbar1.reset(true);

       Ext.fly('p1text').update('请等待先前的任务完成').show();
    return;
    }
    if(total==0){
    pbar1.reset(true);

       var progressBarhome=document.getElementById("progressBarhome");
       var progressBar=document.getElementById("progressBar");
    progressBarhome.appendChild(progressBar);
       var bgObj=document.getElementById("bgDiv");
    document.body.removeChild(bgObj);
       var title=document.getElementById("msgTitle");
       document.getElementById("msgDiv").removeChild(title);
       var msgObj=document.getElementById("msgDiv");
    document.body.removeChild(msgObj);
       document.getElementById("importMessage").style.display="none";
       Ext.fly('p1text').update('没有记录导入').show();
    return;
    }
    Runner.run(pbar1, total, function(){
    pbar1.reset(true);
//           Ext.fly('p1text').update('操作完成!\n导入的记录总数: '+total+',失败数: '+lostnum+'.').show();
//           var progressBarhome=document.getElementById("progressBarhome");
//           var progressBar=document.getElementById("progressBar");
//    progressBarhome.appendChild(progressBar);
//           var bgObj=document.getElementById("bgDiv");
//    document.body.removeChild(bgObj);
//           var title=document.getElementById("msgTitle");
//           document.getElementById("msgDiv").removeChild(title);
//           var msgObj=document.getElementById("msgDiv");
//    document.body.removeChild(msgObj);
            document.getElementById("lostRecord").innerText = "点击查看";
            document.getElementById("succesRecord").innerText = "点击查看";
            document.getElementById("finishmessage").innerText ="操作完成!";
    });
    }*/
    }
    function doImportOpt(){
    DWREngine.setAsync(false);
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.inputExcel(path,'<%=workflowid%>',returnTotal);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.inputExcel(path,'<%=categoryid%>',returnTotal);
        <%
            }else{
        %>
        HumresExcelService.inputExcel(path,returnTotal);
        <%
            }
        %>
    DWREngine.setAsync(true);
    }

    function returnTotal(o){
        total=o;
        document.getElementById("totalNum").innerText=total;
    }
    function returnCurrentCount(o){
        var obj=eval('(' + o + ')'); ;

        var succesNum=obj.succesNum;
        lostnum=parseInt(obj.lostNum);
        
        var curNum = parseInt(succesNum)+lostnum
        document.getElementById("curnum").innerText=curNum;
        
        document.getElementById("succesNum").innerText=parseInt(succesNum);
        document.getElementById("lostNum").innerText=lostnum;

        currentCount=curNum;
        isfinish = obj.isfinish;
        if(curNum==total){
           document.getElementById("curra").style.display="none";
           document.getElementById("finishmessage").style.display="block";
           if(isfinish!="1"){
               document.getElementById("finishmessage").innerText ="数据导入操作已完成,正在生成错误信息文件,请稍候...";
           }
        }
    }
    function doRefresh(){
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }else{
        %>
        HumresExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }
        %>
    }
</script>
</html>
