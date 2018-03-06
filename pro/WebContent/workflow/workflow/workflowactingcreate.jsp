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
<%@ page import="com.eweaver.base.security.service.logic.SysuserService" %>
<%@ include file="/base/init.jsp"%>


<html>
  <head><title>Simple jsp page</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
 
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>

    
      <%
        String rootid="r00t";
        String roottext=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0007");//流程选择
        pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','C','save',function(){onSubmit()});";//保存
      %>
      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      var categoryTree;
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
      Ext.onReady(function(){
           <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>

      menuTree = new Ext.tree.TreePanel({
            animate:true,
            //title: '&nbsp;',
            useArrows :true,
            containerScroll: true,
            autoScroll:true,
            enableDD:true,
            ddAppendOnly:true,
            ddGroup:'dnd',
                checkModel: 'cascade',
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
                allowDrop:false
            }),
            loader:new Ext.tree.TreeLoader({
                dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=getworkflowtree",
                baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
                preloadChildren:false
            }
                    )

        });

         menuTree.on('check',function(n,c){
            if(c){
                document.getElementById("workflowids").value+=n.id+",";
            }else{
                var ids=document.getElementById("workflowids").value;
                var index=ids.indexOf(n.id+",");
                if(index!=-1){
                    document.getElementById("workflowids").value=ids.substring(0,index)+ids.substring(index+n.id.length+1,ids.length);
                }
            }

        })
          //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'center',autoScroll:true,contentEl:'mydiv',split:true,collapseMode:'mini'},menuTree]
        });

      })

      </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
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
                <TR><TD class=Line colspan=3></TD><TR>
                <TR><TD class=Spacing colspan=3></TD><TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                     <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0008")%><!--  被代理人-->
                  </TD>
                  <td class=FieldValue>
                      <%
                          SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
                          if(sysuserService.checkUserPerm(sysuserService.get(eweaveruser.getSysuserid()),"com.eweaver.workflow.workflow.service.WorkflowactingService.save")){
                      %>
                  <button type="button"  class=Browser name="button_agent" onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp','byagent','byagentspan','0');"></button>
                      <%
                          }
                      %>
                  <input type="hidden" name="byagent" id="byagent" value="<%=currentuser.getId()%>"><span id="byagentspan" name="byagentspan" ><%=currentuser.getObjname()%></span>
                  </td>
                </TR>
                
                
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                     <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0009")%> <!-- 代理人 -->
                  </TD>
                  <td class=FieldValue>
                      <button type="button"  class=Browser name="button_agent" onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/humresbrowser.jsp','agent','agentspan','0');"></button>
                      <input type="hidden" name="agent" id="agent" value="">
                      <span id="agentspan" name="agentspan" ><img src="/images/base/checkinput.gif" align=absMiddle></span>
                  </td>
                </TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                     	<%=labelService.getLabelNameByKeyId("402883ea3f094d73013f094d73ed0286")%> <!-- 是否代理开始节点 -->
                  </TD>
                  <td class=FieldValue>
                      <input type="checkbox" onclick="setBoxVal(this)"  name="isAgentStartNode" id="isAgentStartNode" value="0">
                  </td>
                </TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                     <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000a")%> <!-- 限制时间 -->
                  </TD>
                  <td class=FieldValue>
                    <input type=text class=inputstyle size=10 id="begintime" name="begintime"  value="" onclick="WdatePicker()" >
                    <span id="begintimespan"   ><img src="/images/base/checkinput.gif" align=absMiddle></span>-
                    <input type=text class=inputstyle size=10 id="endtime" name="endtime"  value="" onclick="WdatePicker()" >
                    <span id="endtimespan"  ><img src="/images/base/checkinput.gif" align=absMiddle>

                    </span>
                  </td>
                </TR>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000b")%><!-- 请在左边页面选择需要代理的流程 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>

	    </table>
        </form>
      </div>
  </body>
  <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script language="javascript">
   function onSubmit(){
   		//流程不能为空
        if(document.getElementById("workflowids").value==null||document.getElementById("workflowids").value==""){
            alert("<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000c")%>");//流程不能为空
            return;
        }
        if(document.getElementById("agent").value==null||document.getElementById("agent").value==""){
            alert("<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000d")%>");//代理人不能为空
            return;
        }
        if(document.getElementById("agent").value==document.getElementById("byagent").value){
            alert("<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000e")%>");//代理人和被代理人不能相同
            return;
        }
        if(document.getElementById("begintime").value=="" || document.getElementById("endtime").value==""){
            alert("<%=labelService.getLabelNameByKeyId("408960b43af83631013af836322c0000")%>");//开始时间和结束时间不能为空！
            return;
        }
        if(document.getElementById("begintime").value>document.getElementById("endtime").value){
            alert("<%=labelService.getLabelNameByKeyId("408960b43af83631013af836322c0001")%>");//开始时间不能大于结束时间！
            return;
        }
        
   		document.EweaverForm.submit();
   }
   function onPopup(url){
   	var id=openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
   	document.EweaverForm.submit();
   }



var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
	    }catch(e){}
	
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';                                                                       
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
		if (id!=null) {
			if (id[0] != '0') {
				document.all(inputname).value = id[0];
				document.all(inputspan).innerHTML = id[1];
		    }else{
				document.all(inputname).value = '';
				if (isneed=='0')
				document.all(inputspan).innerHTML = '';                                                                       
				else
				document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
		
	            }
	         }
     }
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
             plain: true,
             modal:true,
             items: {
                 id:'dialog',
                 region:'center',
                 iconCls:'portalIcon',
                 xtype     :'iframepanel',
                 frameConfig: {
                     autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                     eventsFollowFrameLinks : false
                 },
                 closable:false,
                 autoScroll:true
             }
         });
     }
     win.close=function(){
                 this.hide();
                 win.getComponent('dialog').setSrc('about:blank');
                 callback();
             } ;
     win.render(Ext.getBody());
     var dialog = win.getComponent('dialog');
     dialog.setSrc(viewurl);
     win.show();
	}
 }

function setBoxVal(obj){
	if(obj.checked){
		obj.value = 1;
	}else{
		obj.value = 0
	}
}
 </script>
 <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
</html>
