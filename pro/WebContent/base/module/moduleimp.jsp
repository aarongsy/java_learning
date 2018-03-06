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
<%@ page import="javax.sql.DataSource"%>
<%@ include file="/base/init.jsp"%>


<html>
  <head><title>模块导入</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
    <script src='<%= request.getContextPath()%>/dwr/interface/JaxbOptService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>


      <%
        String rootid="r00t";
        String roottext="模块选择";
        pagemenustr +="addBtn(tb,'导入','I','save',function(){toImport()});";
        pagemenustr +="addBtn(tb,'删除','D','delete',function(){toDelete()});";
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      var categoryTree;
      var ds_name;
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
        var refresstimer;
        var pbar1;
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

          //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'mydiv',split:true,collapseMode:'mini'},{region:'center',autoScroll:true,contentEl:'messagePage',split:true,collapseMode:'mini'}]
        });

      })

	function setDs(dsname) {
		ds_name=dsname;
	}
      </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=create" name="EweaverForm" id="EweaverForm" method="post" target="upload_faceico" enctype="multipart/form-data">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center">&nbsp;
	            <b>请选择需要导入模块的数据源:<b/>
				<%String[] names=BaseContext.getBeanNames(DataSource.class); %>
				<select onchange="setDs(this.value);" id="vdatasource" name="vdatasource">
				<option value="">&nbsp;</option>
				<%for(String n:names)out.println("<option value=\""+n+"\">"+n+"</option>"); %>
				</select>请在下面选择需要导入的模块文件(<a href="/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=loadtables">下载Tables.xml</a>)
			</TD><TR>
			<TR><TD colspan=3>&nbsp;</TD><TR>
			<TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center"><input type="file" name="path" /></TD><TR>
            <tr><td colspan=3 align="center">
                <br/>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                <div id="importMessage" style="display:none;">
                    <a href="javascript:void(0)">导入的模块总数：</a>&nbsp;&nbsp;<a href="javascript:void(0)" id="totalnum">0</a><br/>
                    <a href="javascript:void(0)">当前正导入第 <span id="curnum">0
                    </span> 个模块</a>
                </div>
                </div>
                </div>
                <br/>
        </td></tr>
	    </table>
        </form>
      <iframe id="upload_faceico" name="upload_faceico" src="upload_faceico.jsp" width="0" height="0" style="top:-100px;">
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
      var lostnum=0;

    function toDelete() {
	    if(document.forms[0].path.value==""||document.forms[0].path.value==null){
	        alert("你还没有选择需要导入模块");
	    	return;
	    }
	    frames["upload_faceico"].document.getElementById("pathtext").value="";
	    document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=upload";
	    document.forms[0].submit();
	    getDelPath();
    }

    function getDelPath() {
       path = frames["upload_faceico"].document.getElementById("pathtext").value;
       if(path==""||path==null){
           setTimeout("getDelPath()",1000);
       }else{
           doDeleteOpt();
       }
    }

    function toImport(){
        if(document.forms[0].path.value==""||document.forms[0].path.value==null){
            alert("你还没有选择需要导入模块");
    return;
    }
        frames["upload_faceico"].document.getElementById("pathtext").value="";
        document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=upload";
    document.forms[0].submit();

    getPath();
    }
    function getPath(){
       path = frames["upload_faceico"].document.getElementById("pathtext").value;
       if(path==""||path==null){
           setTimeout("getPath()",1000);
    }else{
    doImportOpt();
    }
    }
    function doImportOpt(){
    var myMask = new Ext.LoadMask(Ext.getBody(), {
                        msg: '正在导入,请稍后...',
                        removeMask: true //完成后移除
                    });
                myMask.show();
    Ext.Ajax.request({    
                   url : contextPath+'/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=import',    
                   timeout:240000,
                   params : {    
                          path:path,
                          ds:ds_name 
                    },    
                   success : function(response) {                       
                        var respText = response.responseText;  
                        document.getElementById("message").innerHTML='';
                        document.getElementById("message").innerHTML=respText;
                         myMask.hide();
                    },    
                    failure : function(response) {    
                                Ext.Msg.alert('错误, 无法访问后台');
                                myMask.hide();
                    }    
		})
    }
       function doDeleteOpt(){
          
       var myMask = new Ext.LoadMask(Ext.getBody(), {
                        msg: '正在清除,请稍后...',
                        removeMask: true //完成后移除
                    });
                myMask.show();
    Ext.Ajax.request({    
                   url : contextPath+'/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=del',    
                   timeout:240000,
                   params : {    
                          path:path,
                          ds:ds_name 
                    },    
                   success : function(response) {                       
                        var respText = response.responseText;  
                        document.getElementById("message").innerHTML='';
                        document.getElementById("message").innerHTML=respText;
                         myMask.hide();
                    },    
                    failure : function(response) {    
                                Ext.Msg.alert('错误, 无法访问后台');
                                myMask.hide();
                    }    
		})
    }
</script>
</html>