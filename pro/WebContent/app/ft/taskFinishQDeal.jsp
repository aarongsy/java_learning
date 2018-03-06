<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%
String type = request.getParameter("action");
if(type==null)type="";
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql = "";
List ls=null;
String requestid = StringHelper.null2String(request.getParameter("requestid"));
if(type.equals("submit"))
{
	String notes=request.getParameter("notes");
	String indentstartdate=request.getParameter("indentstartdate");
	String indentfinishdate=request.getParameter("indentfinishdate");
	String indentstartdatecheck=request.getParameter("indentstartdatecheck");
	String indentfinishdatecheck=request.getParameter("indentfinishdatecheck");
	StringBuffer sqlbuf= new StringBuffer();
	String status="";
	sqlbuf.append("update edo_task  set notes='"+StringHelper.filterSqlChar(notes)+"'");
	if(indentstartdate!=null)
		sqlbuf.append(",indentstartdate='"+indentstartdate+"'");
	if(indentfinishdate!=null)
		sqlbuf.append(",indentfinishdate='"+indentfinishdate+"'");
	if(indentstartdatecheck!=null)
		status="2c91a0302b278cea012b27d28c3a0014";
	if(indentfinishdatecheck!=null)
		status="2c91a0302aa21947012aa232f1860011";
	if(indentstartdatecheck!=null||indentfinishdatecheck!=null)
	{
		sqlbuf.append(",status='"+status+"'");
	}
	sqlbuf.append(" where  requestid='"+requestid+"'");
	baseJdbc.update(sqlbuf.toString());
	out.println("<script>");
	out.println("alert('"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b004c")+"');");
	out.println("self.parent.dlg0.hide();self.parent.document.getElementById('refresh').click();");
	out.println("</script>");
	return;
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
<body>
<center>
<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
 <input type="hidden" name="requestid" id="requestid" value="<%=requestid%>"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:95%">
<%
sql ="select a.id,a.requestid,a.taskno tasknob,b.objname,b.taskno,b.office,b.principal,b.start1,a.status,b.finish1,a.indentstartdate,a.indentfinishdate,a.notes from  edo_task a,edo_task b where a.parenttaskuid=b.id  and a.requestid='"+requestid+"' order by b.taskno";
List mainlist= baseJdbc.executeSqlForList(sql);
StringBuffer buf = new StringBuffer();
%>
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #DFDFDF solid">
<colgroup>
<col width="15%"/>
<col width="35%"/>
<col width="15%"/>
<col width="35%"/>
</colgroup>
	<%
	if(mainlist.size()>0)
	{
		Map m = (Map)mainlist.get(0);
		String taskno=StringHelper.null2String(m.get("taskno"));
		String objname=StringHelper.null2String(m.get("objname"));
		String office=StringHelper.null2String(m.get("office"));
		String principal=StringHelper.null2String(m.get("principal"));
		String start1=StringHelper.null2String(m.get("start1"));
		String finish1=StringHelper.null2String(m.get("finish1"));
		String status=StringHelper.null2String(m.get("status"));
		String tasknob=StringHelper.null2String(m.get("tasknob"));
		String id=StringHelper.null2String(m.get("id"));
		String indentfinishdate=StringHelper.null2String(m.get("indentfinishdate"));
		String indentstartdate=StringHelper.null2String(m.get("indentstartdate"));
		String notes=StringHelper.null2String(m.get("notes"));
		%>
		<script type="text/javascript">
		Ext.onReady(function(){
			Ext.QuickTips.init();
			var topBar = new Ext.Toolbar();
			topBar.render('pagemenubar');
			topBar.addSeparator();
			addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onsubmit()});//确定
			topBar.render('pagemenubar');
			topBar.addSeparator();
			topBar.addFill();
		  });
		function onsubmit(){
			if(document.getElementsByName('indentstartdatecheck')[0].checked)
			{
				if(document.getElementsByName('indentstartdate')[0].value!=null&&document.getElementsByName('indentstartdate')[0].value.length<1)
				{
					alert("<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004d")%>");return;//请填写实际开始日期！
				}
			
			}
			if(document.getElementsByName('indentfinishdatecheck')[0].checked)
			{
				if(document.getElementsByName('indentfinishdate')[0].value!=null&&document.getElementsByName('indentfinishdate')[0].value.length<1)
				{
					alert("<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b004e")%>");return;//请填写实际完成日期！
				}
			
			}
			document.all('EweaverForm').submit();
	
		}
		</script>
		<%
		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b004b")+":</td>");//服务部门
		buf.append("<td class=\"FieldValue\">"+getBrowserDicValue("orgunit","id","objname",office)+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0049")+":</td>");//工作人员
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+getBrowserDicValue("humres","id","objname",principal)+"</td>");
		buf.append("</tr>");
		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\">"+labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006")+":</td>");//任务名称
		buf.append("<td class=\"FieldValue\" colspan=3>"+objname+"</td>");
		buf.append("</tr>");
		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e")+":</td>");//任务编号
		buf.append("<td class=\"FieldValue\">"+taskno+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000e")+":</td>");//文档编号
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+tasknob+"</td>");
		buf.append("</tr>");


		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b004f")+":</td>");//预计开始
		buf.append("<td class=\"FieldValue\">"+start1+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0050")+":</td>");//实际开始
		buf.append("<td class=\"FieldValue\"><input type=checkbox name=\"indentstartdatecheck\"  value=\"0\" onclick=\"javascript:setDisabled(this,'indentstartdate');\" "+((status.equals("2c91a0302b278cea012b27d28c3a0014")||status.equals("2c91a0302aa21947012aa232f1860010"))?"checked=true":"")+"><input type=text class=inputstyle readonly size=20 name=\"indentstartdate\"  value=\""+indentstartdate+"\" onclick=\"WdatePicker()\" "+((status.equals("2c91a0302b278cea012b27d28c3a0014")||status.equals("2c91a0302aa21947012aa232f1860010"))?"":"disabled=true")+"></td>");
		buf.append("</tr>");
		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0046")+":</td>");//预计完成
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+finish1+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70c0009")+":</td>");//实际完成
		buf.append("<td class=\"FieldValue\" style=\"color:red\"><input type=checkbox name=\"indentfinishdatecheck\"  value=\"0\" onclick=\"javascript:setDisabled(this,'indentfinishdate');\" "+((status.equals("2c91a0302aa21947012aa232f1860011")||status.equals("2c91a0302aa21947012aa232f1860012"))?"checked=true":"")+"><input type=text class=inputstyle readonly size=20 name=\"indentfinishdate\"  value=\""+indentfinishdate+"\" "+((status.equals("2c91a0302aa21947012aa232f1860011")||status.equals("2c91a0302aa21947012aa232f1860012"))?"":"disabled=true")+"  onclick=\"WdatePicker()\" ></td>");
		buf.append("</tr>");
		buf.append("<tr height=\"25\">");
		buf.append("<td class=\"FieldName\">"+labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a")+":</td>");//备注
		buf.append("<td class=\"FieldValue\" colspan=3><TEXTAREA class=\"InputStyle2\" name=\"notes\" style='width: 92%; height: 50px' >"+notes+"</TEXTAREA></td>");
		buf.append("</tr>");
	}
	out.println(buf.toString());
	%>
	</table>
	</div>
</div>
</body>
</html>
<script>
function setDisabled(obj,objname)
{
	if(obj.checked)
		document.getElementsByName(objname)[0].disabled=false;
	else
		document.getElementsByName(objname)[0].disabled=true;

}
</script>

