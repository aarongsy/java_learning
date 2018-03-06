<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.math.*"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="com.eweaver.cpms.project.doc.*" %>
<%@ page import="com.eweaver.base.category.service.*" %>
<%@ page import="com.eweaver.base.category.model.*" %>
<%@ page import="com.eweaver.workflow.workflow.service.*" %>
<%@ page import="com.eweaver.workflow.workflow.model.*" %>
<%@ page import="com.eweaver.cpms.project.resource.*" %>
<%

TaskResourceService taskResourceService = (TaskResourceService) BaseContext.getBean("taskResourceService"); 
HumresService humresService = (HumresService) BaseContext.getBean("humresService"); 
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService"); 

//System.out.println(categoryid);
String projectid = StringHelper.null2String(request.getParameter("projectid"));
String objid = StringHelper.null2String(request.getParameter("objid"));
String taskid = StringHelper.null2String(request.getParameter("taskid"));

TaskResource taskResource = taskResourceService.getTaskResource(objid);

if(null == taskResource)taskResource = new TaskResource();

%>

<html>
<head>

<script  type='text/javascript' src='/js/workflow.js'></script>

<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
Ext.onReady(function(){
	var tb1 = new Ext.Toolbar();
	tb1.render('pagemenubar');
	addBtn(tb1,'保存','S','disk',function(){onSave();});
	addBtn(tb1,'关闭','C','delete',function(){top.frames[1].commonDialog.hide();});
});
</script>
</head>
<body style="margin:0px;padding:0px;overflow: hidden;">
<div id="pagemenubar"></div>
<form id="EweaverForm" name="EweaverForm" action=" /ServiceAction/com.eweaver.cpms.project.resource.TaskResourceAction?action=saveresource"    method="post">
<input type="hidden" name="id" value="<%=objid%>">
<input type="hidden" name="taskid" value="<%=taskid%>">
<input type="hidden" name="projectid" value="<%=projectid%>">
<table width="100%" id="tab1" border=1>
<tr>
<%
String humresname = humresService.getHrmresNameById(taskResource.getHumresid());
%>
<td class="fieldName" width="15%" align="right">人 员</td>
<td class="fieldValue" width="85%"><button type=button class=Browser name="button_humresid" 
	onclick="javascript:getrefobj('humresid','humresidspan','402881e70bc70ed1010bc75e0361000f','','','1');"></button>
	<input type="hidden" name="humresid" value="<%=StringHelper.null2String(taskResource.getHumresid()) %>" style="width: 80%"  >
	<span id="humresidspan" name="humresidspan" ><%=StringHelper.null2String(humresname)%><%if(StringHelper.isEmpty(humresname)){%><img src="/images/base/checkinput.gif"><%}%></span>
</td>
</tr>
<tr>
<td class="fieldName" align="right">角 色</td>
<td class="fieldValue"><input type="text" id="role" name="role" value="<%=StringHelper.null2String(taskResource.getRole()) %>"></td>
</tr>
<tr>
<td class="fieldName" align="right">使用单位百分比</td>
<td class="fieldValue">
<input type="text" name="theunit" id="theunit" onblur="fieldcheck(this,'^-?\\d+$','使用单位')"  
onChange="fieldcheck(this,'^-?\\d+$','使用单位');"  value="<%=StringHelper.null2String(taskResource.getTheunit()) %>"/>%
</td>
</tr>
<tr style="display: none">
<td class="fieldName" align="right">计划工时</td>
<td class="fieldValue">
<input type="text" name="plantime" id="plantime" onblur="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','计划工时')"  
onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','计划工时');" value="<%=StringHelper.null2String(taskResource.getPlantime()) %>"/>
</td>
</tr>
<tr style="display: none">
<td class="fieldName" align="right">实际工时</td>
<td class="fieldValue">
<input type="text" name="realtime" id="realtime" onblur="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','实际工时')"  
onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','实际工时');" value="<%=StringHelper.null2String(taskResource.getRealtime()) %>"/>
</td>
</tr>
<tr>
<td class="fieldName" align="right">备 注</td>
<td class="fieldValue">
<TEXTAREA name="desc" id="desc" style="width: 100%;"><%=StringHelper.null2String(taskResource.getDescription()) %></TEXTAREA></td>
</tr>
</table>
</form>
</body>
<script language="javascript">
function onSave(id){
	if(document.getElementById('humresid').value){
		document.EweaverForm.submit();
	}else{
		alert('未选择人员');
	}
}

function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";


    var fck=param.indexOf("function:");
        if(fck>-1){}else{
            var param = parserRefParam(inputname,param);
        }
	var idsin = document.getElementsByName(inputname)[0].value;
        var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
	var id;
    if(Ext.isIE){
    try{

    id=openDialog(url,idsin);
    }catch(e){return}
    if (id!=null) {

    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
  if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                     if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
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
                }
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
}
</script>
</html>