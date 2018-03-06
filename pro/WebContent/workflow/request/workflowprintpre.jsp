<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.layout.ShowFlow" %>
<%@ page import="com.eweaver.workflow.stamp.model.Stampinfo" %>
<%@ page import="com.eweaver.workflow.stamp.model.Imginfo" %>
<%@ page import="com.eweaver.workflow.stamp.service.StampinfoService" %>
<%@ page import="com.eweaver.workflow.stamp.service.ImginfoService" %>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/base/init.jsp"%>
<%

	String workflowid = StringHelper.null2String(request.getParameter("workflowid")).trim();
	String requestid = StringHelper.null2String(request.getParameter("requestid")).trim();
	String nodeid = StringHelper.null2String(request.getParameter("nodeid")).trim();
	String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
	String requestids = StringHelper.null2String(request.getParameter("ids")).trim();
	String workflowsql="select * from Nodeinfo where id in (select distinct ws.nodeid from Requestlog wl,Requeststep ws where wl.requestid = ws.requestid and wl.requestid = '"+requestid+"' and wl.operator='"+currentuser.getId()+"') order by nodetype,id";
	DataService dateService=new DataService();
	List workflowlist=new ArrayList();
    workflowlist=dateService.getValues(workflowsql);
    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
    workflowid = nodeinfoService.get(nodeid).getWorkflowid();
    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
    String formid = workflowinfoService.get(workflowid).getFormid();
	String layoutid="";

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>打印</title>
    <script src='/dwr/interface/FormlayoutService.js'></script>
    <script src='/dwr/engine.js'></script>
    <script src='/dwr/util.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';
var topBar=null;
WeaverUtil.load(function(){
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSpacer();
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSeparator();
	topBar.addFill();
});
function printPrv ()
{  
  var url="/workflow/request/workflowprintQ.jsp";
  document.EweaverPrint.action=url;
  document.EweaverPrint.target="printframe";
  document.EweaverPrint.submit();
}
</script>
<body onload="//loadEvent()">
<div id='pagemenubar'></div>
<form action="" name="EweaverPrint" id="EweaverPrint"  method="post" target="">
<input type="hidden" name="opType" value="preview">
<input type="hidden" name="workflowid" value="<%=workflowid%>">
<input type="hidden" name="requestid" value="<%=requestid%>">
<TABLE style="WIDTH: 100%" cellSpacing=0 cellPadding=0 border=1>
<COLGROUP><STRONG>
<COL width="15%">
<COL width="35%">
<COL width="15%">
<COL width="35%"></COLGROUP>
<TBODY>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270019") %><!-- 打印项选择 -->: </TD>
<TD class=FieldValue colspan=3><input  type="checkbox"  name='checkbox2' value="2" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001a") %><!-- 流转记录 --></input>&nbsp;&nbsp;&nbsp; <span style="display:none"><input  type="checkbox"  name='checkbox1'  value="1" >&nbsp;<%=labelService.getLabelNameByKeyId("402881e50c3b7110010c3b9778e10039") %><!-- 流程图 --></input></span>
			</TD>
</TD></tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001b") %><!-- 打印节点选择 -->: </TD>
<TD class=FieldValue colspan=3>
<%
        if(workflowlist!=null){
        for(int i=0;i<workflowlist.size();i++){
        Map map=(Map)workflowlist.get(i);
        String id = StringHelper.null2String(map.get("id"));
        String nodename=StringHelper.null2String(map.get("objname"));
        %>
                        <input  type="radio"  name='nodeid' <%if(id.equals(nodeid)){%> checked <%}%> value="<%=id%>" onclick="showLayout('<%=id%>','<%=formid%>')"><%=nodename%></input>
        <%}}%>
</TD></tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001c") %><!-- 打印布局选择 -->: </TD>
<TD class=FieldValue colspan=3><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001d") %><!-- 可选的布局 -->:&nbsp;

            <select name="printLayout" style="width:180">
                <!-- <option value="">未选择</option> -->
                 <%
			       String strDefHql="from Formlayout where (nodeid='"+nodeid+"' or (nodeid is null and formid='"+formid+"')) and typeid=3 order by nodeid asc";
			       FormlayoutService formlayoutService = (FormlayoutService)BaseContext.getBean("formlayoutService");
			       List listdef = formlayoutService.findFormlayout(strDefHql);
			       if(listdef.size()!=0){
			   	%>
                <%Iterator it=listdef.iterator();
                while(it.hasNext()){
                    Formlayout formlayout= (Formlayout) it.next();
                %>
                <option value="<%=formlayout.getId()%>" <%=(layoutid.equals(formlayout.getId())?" selected ":"")%>><%=formlayout.getLayoutname()%></option>
                <%}}%>
            </select>
 
</TD></TR>

<TR height=25 <% if(!LabelCustomService.isEnabledMultiLanguage()){ //未启用多语言%> style="display: none;" <% } %>>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883dd3680eb50013680eb5178028e") %><!-- 字段名称显示方式 -->: </TD>
<TD class=FieldValue colspan=3><%=labelService.getLabelNameByKeyId("402883dd3680eb50013680eb51780290")%><!-- 可选的方式 -->:&nbsp;

            <select name="printType" id="printType" style="width:180">
            	<%
            		DataService ds = new DataService();
            		String sql = "select id,objname from SELECTITEM where TYPEID='402883d1366808440136685bda100047' and ISDELETE=0 order by DSPORDER";
            		List list = ds.getValues(sql);
            		for(int i=0;i<list.size();i++){
            			Map map = (Map)list.get(i);
            			String opinionid = StringHelper.null2String(map.get("id"));
            			String opinionObjname = StringHelper.null2String(map.get("objname"));
            			sql = "select labelname from LabelCustom where keyword='"+opinionid+"' and language='"+language+"'";
            			String labelCustomName = ds.getValue(sql);
            			if(!StringHelper.isEmpty(labelCustomName)){
            				opinionObjname = labelCustomName;
            			}
            	%>
            			 <option value="<%=opinionid %>" <%if(opinionid.equals("402883d1366808440136685cf8cb0048")&&language.equals("zh_CN")){%>selected="selected" <% }else if(opinionid.equals("402883d1366808440136685cf8cc0049")&&language.equals("en_US")){%>selected="selected"<%} %>><%=opinionObjname %></option>
            	 <%}%>
            </select>
 
</TD></TR>

<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001e") %><!-- 打印方向 -->: </TD>
<TD class=FieldValue><INPUT type="radio" class=InputStyle2 value="0"  name="printdirection">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf27001f") %><!-- 横向 -->&nbsp;&nbsp;&nbsp;<INPUT type="radio" class=InputStyle2 checked value="1" name="printdirection">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270020") %><!-- 纵向 --></TD>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270021") %><!-- 缩放比率 -->: </TD>
<TD class=FieldValue><select width="80%" class=InputStyle2 name="zoom">
<option value="2.0" >2.0</option>
<option value="1.5" >1.5</option>
<option value="1.4" >1.4</option>
<option value="1.3" >1.3</option>
<option value="1.2" >1.2</option>
<option value="1.1" >1.1</option>
<option value="1.0" selected>1.0</option>
<option value="0.9" >0.9</option>
<option value="0.8" >0.8</option>
<option value="0.7" >0.7</option>
<option value="0.6" >0.6</option>
<option value="0.5" >0.5</option>
</select>
</TD></tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf270022") %><!-- 左边距(毫米) -->: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 style="WIDTH: 80%" value="" name="leftsize">&nbsp;</TD>
<TD class=FieldName noWrap align=right><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280023") %><!-- 右边距(毫米) -->: </TD>
<TD class=FieldValue><INPUT type="text" class=InputStyle2 style="WIDTH: 80%" value="" name="rightsize">&nbsp;</TD></TR>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9d231f0016") %><!-- 页眉 -->: </TD>
<TD class=FieldValue colspan=3><INPUT class=InputStyle2 style="WIDTH: 80%" value="" name="header">&nbsp;</TD>
</tr>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71c673ca002a") %><!-- 页脚 -->: </TD>
<TD class=FieldValue colspan=3><INPUT class=InputStyle2 style="WIDTH: 80%" value="&b&p/&P" name="footer">&nbsp;</TD>
</TR>
<TR height=25>
<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280024") %><!-- 显示纸张对话框 -->: </TD>
<TD class=FieldValue><INPUT class=InputStyle2  type="checkbox" value="" name="pagedialog">&nbsp;</TD></TD>
<TD vAlign=bottom><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280025") %><!-- 显示打印对话框 -->: </TD>
<TD class=FieldValue >
<P><INPUT type="checkbox" class=InputStyle2 value="" name="printdialog" checked></P></TD></TR></TBODY></TABLE>
<div style="display:none" id="repContainer">
</div>
</form>
<iframe name="printframe" id="printframe"  src="" style="display:none"></iframe>
</body>
 <script>
 function loadEvent()
 {
	document.EweaverForm.submit();
 }

     function showLayout(id,formid){
        if(document.forms[0].printLayout==null){
            return;    
        }
        FormlayoutService.findFormlayout("from Formlayout where (nodeid='"+id+"' or (nodeid is null and formid='"+formid+"')) and typeid=3 order by nodeid asc",showLayoutcallback);
    }

    function showLayoutcallback(data){
        DWRUtil.removeAllOptions("printLayout");
		var printLayout=document.forms[0].printLayout;
		var oOption = document.createElement("OPTION");
		printLayout.options.add(oOption);
		oOption.innerText ="未选择";
		oOption.value = "";
		DWRUtil.addOptions("printLayout",data,"id","layoutname");
    }
 </script>

</html> 


			