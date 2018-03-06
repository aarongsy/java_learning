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
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowactingService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowacting" %>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-11-25
  Time: 10:53:45
  To change this template use File | Settings | File Templates.
--%>

<html>
  <head><title>Simple jsp page</title>
    <script src='<%= request.getContextPath()%>/dwr/interface/ModuleService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
  </head>
  <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
  <body>
<!--页面菜单开始-->
<%
WorkflowactingService workflowactingService = (WorkflowactingService) BaseContext.getBean("workflowactingService");
String workflowactingid = StringHelper.null2String(request.getParameter("workflowactingid"));
 SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
ModuleService moduleService = (ModuleService) BaseContext.getBean("moduleService");
  String byagent = StringHelper.null2String(request.getParameter("byagent"));
  String agent = StringHelper.null2String(request.getParameter("agent"));    
 Workflowacting workflowacting = new Workflowacting();
 workflowacting=workflowactingService.getWorkflowacting(workflowactingid);

String byagentName = StringHelper.null2String(humresService.getHumresById(workflowacting.getByagent()).getObjname());
String agentName = StringHelper.null2String(humresService.getHumresById(workflowacting.getAgent()).getObjname());
String creator = StringHelper.null2String(humresService.getHumresById(workflowacting.getCreator()).getObjname());
Workflowinfo workflowinfo = (Workflowinfo)workflowinfoService.get(workflowacting.getWorkflowid());
String workflowinfoName = workflowinfo.getObjname();
//StringHelper.null2String(workflowinfoService.get(workflowacting.getWorkflowid()).getObjname());
String moduleName = StringHelper.null2String(moduleService.getModule(workflowacting.getModuleid()).getObjname());

  List selectitemlist = selectitemService.getSelectitemList("402881ed0bd74ba7010bd74feb330003",null);//资源类型
  Selectitem selectitem = new Selectitem();

pagemenustr += "{C,"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+",javascript:document.EweaverForm.submit();}";//保存
if(workflowacting.getIseffective()==1){
	pagemenustr += "{C,"+labelService.getLabelNameByKeyId("4028831534efec550134efec55fc000f")+",javascript:revoke();}";//回收该代理
}else{
	pagemenustr += "{C,"+labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0010")+",javascript:resume();}";//打开该代理
}
pagemenustr += "{C,"+labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0011")+",javascript:location.href='"+request.getContextPath()+"/workflow/workflow/exportbrowserbyagent.jsp?workflowactingid="+workflowactingid+"&byagent="+byagent+"&agent="+agent+"&formid="+workflowinfo.getFormid()+"';}";//高级代理设置
pagemenustr += "{C,"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+",javascript:location.href='"+request.getContextPath()+"/workflow/workflow/workflowactinglist.jsp?byagent="+byagent+"&agent="+agent+"';}";//返回
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=save" name="EweaverForm" id="EweaverForm" method="post">
	    <input type="hidden" name="workflowactingid" id="workflowactingid" value="<%=workflowactingid%>">
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
                     <%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39320024")%><!-- 所属模块 -->
                  </TD>
                  <td class=FieldValue>
                    <input type="hidden"  name="moduleid" value="<%=workflowacting.getModuleid()%>"/>
                    <span id="moduleidspan"><%=moduleName%></span>
                  </td>
                </TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                    <%=labelService.getLabelNameByKeyId("402881ee0c715de3010c72411ed60060")%>  <!-- 流程名称 -->
                  </TD>
                  <td class=FieldValue>
                      <button type="button" class=Browser name="button_agent" onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/workflow/workflowinfobrowser.jsp?sqlwhere=isPermitActing=1','workflowid','workflowidspan','0');"></button>
                      <input type="hidden" name="workflowid" id="workflowid" value="<%=workflowacting.getWorkflowid()%>">
                      <span id="workflowidspan" name="workflowidspan" ><%=workflowinfoName%></span>
                  </td>
                </TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                      <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0008")%><!--被代理人--><!-- 被代理人不可变更 -->
                  </TD>
                  <td class=FieldValue>
                  <!-- 
                  <button  class=Browser name="button_agent" onclick="javascript:getBrowser('<%= request.getContextPath()%>/humres/base/humresbrowser.jsp','byagent','byagentspan','0');"></button>
                   -->
                  <input type="hidden" name="byagent" id="byagent" value="<%=workflowacting.getByagent()%>">
                  <span id="byagentspan" name="byagentspan" ><%=byagentName%></span>
                  </td>
                </TR>
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                      <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0009")%><!-- 代理人 -->
                  </TD>
                  <td class=FieldValue>
                      <button type="button"  class=Browser name="button_agent" onclick="javascript:getBrowser('<%= request.getContextPath()%>/humres/base/humresbrowser.jsp','agent','agentspan','0');"></button>
                      <input type="hidden" name="agent" id="agent" value="<%=workflowacting.getAgent()%>"><span id="agentspan" name="agentspan" ><%=agentName%></span>
                  </td>
                </TR>

                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                    <%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006")%> <!--  创建者 -->
                  </TD>
                  <td class=FieldValue>
                      <span id="create" name="create" ><%=creator%></span>
                  </td>
                </TR>
                
                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                     	<%=labelService.getLabelNameByKeyId("402883ea3f094d73013f094d73ed0286")%> <!-- 是否代理开始节点 -->
                  </TD>
                  <td class=FieldValue>
                  <%
                 	int isAgentStartNode = NumberHelper.string2Int(workflowacting.getIsAgentStartNode(),0);
                  %>
                      <input type="checkbox" onclick="setBoxVal(this)" <%if(isAgentStartNode==1){%>checked="checked"<%} %>  name="isAgentStartNode" id="isAgentStartNode" value="<%=isAgentStartNode %>">
                  </td>
                </TR>

                <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                    <%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b1f3dc000f")%>  <!-- 开始时间 -->
                  </TD>
                  <td class=FieldValue>
                    <input type=text class=inputstyle size=20 name="begintime"  value="<%=StringHelper.null2String(workflowacting.getBegintime())%>" onclick="WdatePicker()" >
                    <span id="begintimespan"   ></span>
                  </td>
                </TR>
              <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                    <%=labelService.getLabelNameByKeyId("402881820d4598fb010d45b24e600012")%>  <!-- 结束时间 -->
                  </TD>
                  <td class=FieldValue>
                    <input type=text class=inputstyle size=20 name="endtime"  value="<%=StringHelper.null2String(workflowacting.getEndtime())%>" onclick="WdatePicker()" >
                    <span id="endtimespan"  >

                    </span>
                  </td>
                </TR>
              <TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
         
                      <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0012")%>：<!-- 高级代理条件 -->
                  </TD>
                  <td class=FieldValue>
                    <input type=text readOnly="true" class=inputstyle size=200 name="condition"  value="<%=StringHelper.null2String(workflowacting.getCondition())%>"  >
                  </td>
                </TR>
                  <TD nowrap class=FieldName> </TD>
                  <TD nowrap class=FieldName>
                       
                      <%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0013")%>：<!-- 高级代理条件名称 -->
                  </TD>
                  <td class=FieldValue>
                  <!-- 
                    <input type=text readOnly="true" class=inputstyle size=200 name="conditionName"  />
                   -->
                   <%=StringHelper.null2String(workflowacting.getConditionName())%>
                   <!-- 
                    <A href=\"javascript:onUrl('/humres/base/humresview.jsp?id=4028818b2525339b012529ee4181016f','许建华','tab4028818b2525339b012529ee4181016f')\">许建华</A>};{报销日期,大于,2010-06-13};{金额小写,大于,44};"  >
                    -->
                  </td>
                </TR>
	    </table>
        </form>
  </body>
 <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script language="javascript"><!--
function revoke(){
	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=revoke&workflowactingid=<%=workflowactingid%>";
	document.EweaverForm.submit();
}
function resume(){
	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=resume&workflowactingid=<%=workflowactingid%>";
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
			if(inputname=="workflowid"){
		        var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=getmodulename&pipeid="+id[0];
		        var xmlhttp = new AjaxWf();
		        xmlhttp.open("GET", url, true);
		        xmlhttp.onreadystatechange = function() {
		            if (xmlhttp.readyState == 4) {
		                if (xmlhttp.status == 200) {
		                    var allstr = xmlhttp.responseText;
		                    var modulestr = allstr.split(",");
			                document.all("moduleid").value = modulestr[0];
							document.all("moduleidspan").innerHTML = modulestr[1];
		                } else {
		                    alert("<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0014")%>");//数据读取发生异常，请稍后在试
		                    return false;
		                }
		            }
		        }
		        xmlhttp.send(null);
			}
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
			}
	
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
			if(inputname=="workflowid"){
		        var url = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=getmodulename&pipeid="+id[0];
		        var xmlhttp = new AjaxWf();
		        xmlhttp.open("GET", url, true);
		        xmlhttp.onreadystatechange = function() {
		            if (xmlhttp.readyState == 4) {
		                if (xmlhttp.status == 200) {
		                    var allstr = xmlhttp.responseText;
		                    var modulestr = allstr.split(",");
			                document.all("moduleid").value = modulestr[0];
							document.all("moduleidspan").innerHTML = modulestr[1];
		                } else {
		                    alert("<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0014")%>");//数据读取发生异常，请稍后在试
		                    return false;
		                }
		            }
		        }
		        xmlhttp.send(null);
			}
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0'){
				document.all(inputspan).innerHTML = '';
			}else{
				document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
			}
	
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

 function rollback(data){//经测试返回的data是null
    var id = data.id;
    var name = data.objname;
    alert(name);
    if(id!=null){
        document.forms[0].moduleid.value = id;
    }else{
        document.forms[0].moduleid.value = "";
    }
    if(name!=null){
        document.getElementById("moduleidspan").innerText = name;
    }else{
        document.getElementById("moduleidspan").innerText = "";
    }
 }
 
 function AjaxWf() {
    var XMLHttpReq = false;
    if (window.XMLHttpRequest) { // Mozilla 浏览器
        XMLHttpReq = new XMLHttpRequest();
    } else if (window.ActiveXObject) { // IE浏览器
        try {
            XMLHttpReq = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                XMLHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) {
            }
        }
    }
    return XMLHttpReq;
}
 
  function setBoxVal(obj){
	if(obj.checked){
		obj.value = 1;
	}else{
		obj.value = 0
	}
}
 --></script>
 <script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
</html>