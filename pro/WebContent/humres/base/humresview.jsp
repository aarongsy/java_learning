<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.DataService" %>
<%
	String id = StringHelper.null2String(request.getParameter("id"));
	HumresService humresService = (HumresService) BaseContext.getBean("humresService");
	OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
	SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
	SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");
	SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService)BaseContext.getBean("sysuserrolelinkService");
	SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
	Sysuser sysuser = new Sysuser();
	Sysuserrolelink sysuserrolelink = new Sysuserrolelink();
    OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
	Selectitem selectitem = null;
	Orgunit orgunit = new Orgunit();
	Orgunittype orgunittype = new Orgunittype();
	Humres humres = humresService.getHumresById(id); 

String reftype = StringHelper.trimToNull(request.getParameter("reftype"));

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
String isrefresh = StringHelper.null2String(request.getParameter("isrefresh"));
String messageid = StringHelper.null2String(request.getParameter("messageid"));
String action = StringHelper.null2String(request.getParameter("action"));

// 是否人力资源管理员 
boolean isHumresAdmin = false;
String humresroleid = "402881e50bf0a737010bf0b021bb0006";//人力资源管理员角色id
Humres humres1 = humresService.getHumresById(currentuser.getId()); 
PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
isHumresAdmin = permissionruleService.checkUserRole(currentuser.getId(),humresroleid,humres1.getOrgid());
if(!isHumresAdmin){	//如果不是人力资源管理员,那么检查该用户是否拥有人事卡片管理的权限
	isHumresAdmin = permissionruleService.checkUserPerms(currentuser.getId(), "402880ca15a8a7cd0115b5d541120063");
}
boolean isManager = humresService.isManager(currentuser.getId(),humres.getId(),null);
boolean isSelf = currentuser.getId().equals(id);
Setitem refmodelitem = setitemService.getSetitem("402880e71284a7ed011284fcf3de0011");
String refmodelid = StringHelper.null2String(refmodelitem.getItemvalue()).trim();
	
Setitem layoutsetitem = new Setitem();
if(isHumresAdmin)
	layoutsetitem = setitemService.getSetitem("402880e71284a7ed011284fb84a6000b");
else if(isManager&&!isSelf)
	layoutsetitem = setitemService.getSetitem("402880e71284a7ed011284fae5ad0011");
else if(isSelf)
	layoutsetitem = setitemService.getSetitem("402880e71284a7ed011284fae5ad0010");
else
	layoutsetitem = setitemService.getSetitem("402880e71284a7ed011284fae5ad0009");
	
String layoutid = StringHelper.null2String(layoutsetitem.getItemvalue()).trim();	
if(layoutid.endsWith(".jsp")){
	String allparmsurlstr = "";
	for( Enumeration e = request.getParameterNames(); e.hasMoreElements(); ) {
		String paraname = e.nextElement().toString().trim();
		String paravalue = StringHelper.trimToNull(request.getParameter(paraname));
		if(!StringHelper.isEmpty(paraname) && !StringHelper.isEmpty(paravalue) &&!"lastdocid".equals(paraname)){
			allparmsurlstr += "&"+paraname+"="+URLEncoder.encode(paravalue,"UTF-8");
		}
	}
	response.sendRedirect(layoutid+"?go=1"+allparmsurlstr);;
	return;	
}
%>
<!--页面菜单开始-->
<%
String tabStr="";
boolean hasTab=false;
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
if((isHumresAdmin||isManager)&&!"402881e70be6d209010be75668750014".equalsIgnoreCase(id)){
	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','page',function(){javascript:onDelete('"+id+"')});";//删除
	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0017")+"','R','page',function(){javascript:onRestore('"+id+"')});";//恢复
	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0018")+"','D','delete',function(){javascript:onDeleteReal('"+id+"');});";//彻底删除
}
if(isHumresAdmin||isManager){
    tabStr+="addTab(contentPanel,'"+request.getContextPath()+"/base/security/sysusermodify.jsp?mtype=1&objid="+StringHelper.null2String(id)+"','"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0019")+"','lock');";//登录帐号
}
if(isManager||isSelf||isHumresAdmin)
{
		pagemenustr += "addBtn(tb,'"+labelService.getLabelName("编辑")+"','E','application_form_edit',function(){javascript:location.href='"+request.getContextPath()+"/humres/base/humresmodify.jsp?reftype="+reftype+"&id="+StringHelper.null2String(id)+"'});";
	tabStr+="addTab(contentPanel,'"+request.getContextPath()+"/workflow/workflow/imgdataview.jsp?userid="+id+"','"+labelService.getLabelNameByKeyId("40288035251035db0125106d98880005")+"','application_view_icons');";//盖章列表
}
paravaluehm.put("{id}",id);
paravaluehm.put("{reftype}",reftype);
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
        ArrayList<String> menuList=_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm);
		pagemenustr += menuList.get(0);
        tabStr += menuList.get(1);
if(!tabStr.equals(""))
hasTab=true;
%>
<html>
  <head>
    <style type="text/css">
   #pagemenubar table {width:0}
</style>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
      <script type="text/javascript">
          var humresid='<%=id%>' ;
          var contentPanel;
        Ext.onReady(function() {
            <% if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("create")){ %>
        if(parent&&parent.orgTree){
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode.parentNode;
        pnode.reload() ;
        pnode.select();
        location=pnode.attributes.href;
        return;
        }
	<%} if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("modify")){ %>
        if(parent&&parent.orgTree){
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode.parentNode;
        pnode.reload() ;
        pnode.select();
        location=pnode.attributes.href;
        return;
        }
	<%} if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("delete")){ %>
        if(parent&&parent.orgTree){
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode.parentNode;
        pnode.reload() ;
        pnode.select();
        location=pnode.attributes.href;
        return;
        }
	<%}%>
            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>

        var c = new Ext.Container({
               autoEl: {},
               <%if(hasTab){%>title:'<%=labelService.getLabelName("表单信息")%>',iconCls:Ext.ux.iconMgr.getIcon('application_form'),<%}else{%>region:'center',<%}%>
               width:Ext.lib.Dom.getViewportWidth(),
               height: Ext.lib.Dom.getViewportHeight(),
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
           });
     <%if(hasTab){%>
     contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:0,
            items:[c]
        });
       <%=tabStr%>
       <%}%>
      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [<%if(hasTab){%>contentPanel<%}else{%>c<%}%>]
	});
      
     	<% if(currentSysModeIsWebsite){ //系统模式为网站模式%>
			resetHeight();
		<% } %>
    });
    
    function resetHeight(){
    	try{
    		var height = Ext.get('divSum').getHeight()+50;
			contentPanel.setHeight(height);	
    	}catch (e) {}
    }
    </script>
  </head>
  
  <body>
  <script type="text/javascript">
      	var strSQLs = new Array();
	var strValues = new Array();
     function SQL(param){
				param = encode(param);
				if(strSQLs.indexOf(param)!=-1){
					var retval = getValidStr(strValues[strSQLs.indexOf(param)]);
					return retval;
				}else{
                    var _url= "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.DataAction?sql="+param;
                    var retval;

                    Ext.Ajax.request({
                        url:_url,
                        sync:true,
                        success: function(res) {
                            var doc=res.responseXML;
                             var root = doc.documentElement;
                            retval = getValidStr(root.text);
                            strSQLs.push(param);
                            strValues.push(retval);
                        }
                    });
					return retval;
				}
			}
  </script>
     
<div id="divSum">
<div id="pagemenubar"></div>
<!--页面菜单结束--> 
	<% if(!StringHelper.isEmpty(messageid)){ %>
	
<DIV><font color=red><%=StringHelper.getDecodeStr(messageid)%></font></div>
	<%} %>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=modify" name="EweaverForm"  method="post">

<%
	
	FormService fs = (FormService)BaseContext.getBean("formService");
	String formcontent ="";
	Map initparameters = new HashMap();
	Map parameters = new HashMap();
	
	parameters.put("bWorkflowform","0");
	parameters.put("isview","1");
	parameters.put("formid","402881e80c33c761010c33c8594e0005");
	parameters.put("objid",id);
	parameters.put("object",humres);
	parameters.put("layoutid",layoutid);
	parameters.put("initparameters",initparameters);
	
	parameters = fs.WorkflowView(parameters);		

	formcontent = StringHelper.null2String(parameters.get("formcontent"));
	
	if(formcontent.equals(""))//没有定义对应的布局，请和系统管理员联系！
		formcontent = "<b><font color=red>"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da05000a")+"</font></a>";
	
 %>

<table>
	<colgroup> 
		<col width="100%">
	</colgroup>	
<tr>
<td valign=top>
<%=formcontent %>
</td>
</tr>
</table>

     </form>
</div>
<script language=javascript>
function onOpenWindow(url){
window.open("<%=request.getContextPath()%>"+url,"newdocwindow","height=600, width=900, top=0, left=0,toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
}
function onDelete(id){
 if(<%=humres.getIsdelete()%>==1)
 {
    alert("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001a")%>");//该员工已被删除！
	return;
 }
 if( confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
 document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=delete&id="+id;//输入你的Action
 document.EweaverForm.submit();
}
}
function onDeleteReal(id){

 if(confirm('<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001b")%>')){//是否确定要彻底删除该账号？
 document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=deleteReal&id="+id;//输入你的Action
 document.EweaverForm.submit();
}
}
function onRestore(id){
  if(<%=humres.getIsdelete()%>==0)
 {
    alert("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001c")%>");//该员工未被删除！
	return;
 }
 if( confirm('<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a001d")%>')){//是否确定要恢复该用户？
 document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=restore&id="+id;//输入你的Action
 document.EweaverForm.submit();
}
}
</script>
  </body>
</html>
