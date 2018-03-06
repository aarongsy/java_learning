<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitemtype" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.sql.DataSource"%>
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
  <head><title>模块导出</title>
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
        pagemenustr +="addBtn(tb,'导出','E','save',function(){doExport()});";
        pagemenustr +="addBtn(tb,'更新Tables.xml','U','save',function(){refreshTables()});";
        request.getSession().setAttribute("moduleprogress","");
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      var categoryTree;
      var loadurl = '<%=request.getContextPath()%>/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=moduletree';
      var ds_Name;
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
        var menuTree;
        var ds;
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
         menuTree = new Ext.tree.TreePanel({
                animate:true,
                useArrows :true,
                containerScroll: true,
                autoScroll:true,
                checkModel: 'single',
                //lines:true,
                region:'west',
                width:200,
                split:true,
                collapsible: true,
                collapsed : false,
                rootVisible:true,
                root:new Ext.tree.AsyncTreeNode({
                    text: '<%=roottext%>',
                    id:'<%=rootid%>',
                    expanded:true,
                    allowDrag:false,
                    allowDrop:true
                }),
            loader:new Ext.tree.TreeLoader({
                dataUrl: loadurl,
                baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
                preloadChildren:true
            }
                    )

        });

         menuTree.on('check',function(n,c){
            if(c){
                document.getElementById("workflowids").value=n.id+",";
            }else{
                var ids=document.getElementById("workflowids").value;
                //var index=ids.indexOf(n.id+",");
                //if(index!=-1){
                //    document.getElementById("workflowids").value=ids.substring(0,index)+ids.substring(index+n.id.length+1,ids.length);
                //}
            }

        })
          //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'dsdiv',split:true,collapseMode:'mini'},
            {region:'center',autoScroll:true,contentEl:'mydiv',split:true,collapseMode:'mini'},
            menuTree]
        });

      })
      var Runner = function(){
          var f = function(pbar,count, cb){

              return function(){
                  doRefresh();
                  if(currentCount >= count){
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


      function reloadModule(dsname) {
        ds_Name = dsname;
        menuTree.loader.dataUrl = loadurl +'&ds='+ dsname;
        //alert(menuTree.loader.dataUrl);
      	menuTree.root.reload();

      }
      </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <div id="dsdiv">
  <table width="50%">
  <tr>
					<td class="FieldName" nowrap><b>请选择需要导出模块的数据源:<b/></td>
					<%String[] names=BaseContext.getBeanNames(DataSource.class); %>
					<td class="FieldValue"><select onchange="reloadModule(this.value);" id="vdatasource" name="vdatasource">
					<option value="">&nbsp;</option>
					<%for(String n:names)out.println("<option value=\""+n+"\">"+n+"</option>"); %>
					</select></td>
				</tr>
	</table>			
  </div>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=create" name="EweaverForm" id="EweaverForm" method="post">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center">请在左边页面选择需要导出的模块</TD></TR>
            <tr><TD colspan=3  align="center">是否仅导出流程<input type="checkbox" id="wfcheck" name="wfcheck" value="1"></TD></tr>
            <TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <tr><td colspan=3 align="center">
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                </div>
                </div>
                <br/>
                <div id="showResult"></div>
        </td></tr>
	    </table>
        </form>
      </div>
  </body>
<script language="javascript">

	var s1 ;
    function doExport(){
        var workflowids="";
		var isonlywf = document.getElementById("wfcheck").checked==true?"1":"0";
        workflowids = document.all("workflowids").value;
        if(workflowids == '') {
        	alert('现在无模块或流程被选择,无法导出');
        	return;
        }
        if(isonlywf == '0' && workflowids.indexOf('m_') == -1) {
        	alert('现在无模块被选择,若是只导出流程，请确认仅导出流程选项是否选中');
        	return;
        }
        if(isonlywf == '1' && workflowids.indexOf('wf_') != -1) {
        	if(!confirm('你选择了流程，流程所有内容将会被导出！')) {
        		return;
        	}
        	
        }
        if(workflowids.indexOf('m_') != -1) {
        	if(!confirm('你选择了模块，整个模块的所有内容将会被导出！')) {
        		return;
        	}
        	
        }
         document.getElementById('p1text').innerHTML = '';
         document.getElementById('p1text').style.display = '';
     Ext.Ajax.request({    
                   url : contextPath+'/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=export&ds='+ds_Name,    
                   timeout:240000,
                   params : {    
                          moduleids:workflowids,
                          isonlywf:isonlywf 
                    },    
                   success : function(response) {                       
                        var respText = response.responseText;  
                        document.getElementById("showResult").innerHTML=respText;
                    },    
                    failure : function(response) {    
                                Ext.Msg.alert('错误, 无法访问后台');
                                myMask.hide();
                    }    
		})
		s1= setInterval(returnTotal,100);
		//returnTotal(0);
    }
    
    function returnTotal(o){
         Ext.Ajax.request({    
                   url : contextPath+'/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=progress',    
                   timeout:240000, 
                   success : function(response) {                       
                        var respText = response.responseText;  
                        total=respText;
                        if(total == '0' || total == ''){
                        	total = '正在导出,请稍候...';
                        }else{
                        	clearInterval(s1); 
                        }
                        Ext.fly('p1text').update('<br><br><a href="javascript:void(0)">'+total+'</a><br><br>').show();
                    },    
                    failure : function(response) {    
                                Ext.Msg.alert('错误, 无法访问后台');
                                myMask.hide();
                    }    
		})
    
    }
    
    function refreshTables(){
    	Ext.Ajax.request({    
                   url : contextPath+'/ServiceAction/com.eweaver.moduleio.ModuleIoAction?action=refreshTables',    
                   timeout:240000, 
                   success : function(response) {                       
                        Ext.Msg.alert(response.responseText);
                    },    
                    failure : function(response) {    
                         Ext.Msg.alert(response.responseText);
                    }
		})
    	
    }
 
</script>
</html>
