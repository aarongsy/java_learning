<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/base/init.jsp"%>
<%
String type = request.getParameter("action");
if(type==null)type="";
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);
int month=today.get(Calendar.MONTH);
if(month<1)
{
	month=12;
	currentyear=currentyear-1;
}
String nf = request.getParameter("nf");
String yf = request.getParameter("yf");
if(yf==null)yf=String.valueOf(month);
if(yf.length()<2)yf="0"+yf;
if(nf==null)nf=String.valueOf(currentyear);
String sql = "";
List ls=null;
String delids = StringHelper.null2String(request.getParameter("delids"));
String[] delidsArr=delids.split(",");
String ids = "'0'";
for(int i=0,len=delidsArr.length;i<len;i++)
{
	ids=ids+",'"+delidsArr[i]+"'";
}
	

if(type.equals("submit"))
{
	String requestid=request.getParameter("requestid");
	String endreason=request.getParameter("endreason");
	
	String ny=nf+"-"+yf;
	baseJdbc.update("update edo_task  set STATUS='2c91a0302aa21947012aa232f1860012',INDENTFINISHDATE='"+DateHelper.getCurrentDate()+"',endreason='"+StringHelper.filterSqlChar(endreason)+"' where  requestid in ("+ids+") and (STATUS='2c91a0302aa21947012aa232f1860010' or status='2c91a0302b278cea012b27d28c3a0014')");

	baseJdbc.update("update uf_contract_dist t set implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in (select a.projectid from edo_task a,uf_contract b  where b.requestid=a.projectid and b.state='2c91a0302ab11213012ab12bf0f00022' and  a.requestid in ("+ids+") and a.department=t.orgid) and not exists(select id from edo_task where STATUS not in ('2c91a0302aa21947012aa232f1860012','2c91a0302aa21947012aa232f1860011','2c91a0302aa21947012aa232f1860013') and model='2c91a84e2aa7236b012aa737d8930006' and projectid=t.requestid and department=t.orgid)");

	baseJdbc.update("update uf_contract t set state='2c91a0302a8cef72012a8eabe0e803f2',implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in (select projectid from edo_task where requestid in ("+ids+")) and not exists(select id from uf_contract_dist where implementdate is null and requestid=t.requestid) and state='2c91a0302ab11213012ab12bf0f00022'");

	


	uf_contract a,uf_contract_dist b where 

	

	select department from edo_task where requestid in ("+ids+")


	out.println("<script>");
	out.println("alert('"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0041")+"');");//强制结项成功！
	out.println("self.parent.dlg0.hide();self.parent.document.getElementById('refresh').click();");
	out.println("</script>");
	return;
}
//String url="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=search&workflowid=";
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<link rel="stylesheet" type="text/css" href="/css/eweaver.css" />
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript"  src="/js/weaverUtil.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
<body>
<center>
</tr>
</table>

<body>
<form id="EweaverForm" name="EweaverForm" action="/app/ft/taskAccount.jsp" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
 <input type="hidden" name="delids" id="delids" value="<%=delids%>"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:90%">
<%
List mainlist= baseJdbc.executeSqlForList("select requestid,objname,status,taskno,endreason from edo_task where requestid in ("+ids+")");

List sublist= baseJdbc.executeSqlForList("select requestid,status,objname,taskno from edo_task where parenttaskuid in (select id from edo_task where requestid in ("+ids+")) and model='2c91a84e2aa7236b012aa737d8930007'  order by outlinelevel,outlinenumber");

StringBuffer buf = new StringBuffer();
%>
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
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
		String taskno = StringHelper.null2String(m.get("taskno"));
		String objname = StringHelper.null2String(m.get("objname"));
		String endreason = StringHelper.null2String(m.get("endreason"));
		String status = StringHelper.null2String(m.get("status"));
		String requestid = StringHelper.null2String(m.get("requestid"));
		if(status.equals("2c91a0302aa21947012aa232f1860010")||status.equals("2c91a0302b278cea012b27d28c3a0014"))
		{
		%>
		<script type="text/javascript">
		Ext.onReady(function(){
			Ext.QuickTips.init();
			var topBar = new Ext.Toolbar();
			topBar.render('pagemenubar');
			topBar.addSeparator();
			addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800076")%>','S','accept',function(){onsubmit()});//强制结项
			topBar.render('pagemenubar');
			topBar.addSeparator();
			topBar.addFill();
		  });
		function onsubmit(){
			if(document.getElementsByName('endreason')[0].value!=null&&document.getElementsByName('endreason')[0].value.length>0)
			{
				document.all('EweaverForm').submit();
			}
			else
			{
				alert("<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0042")%>");//请填写强制结项原因！
			}
		}
		</script>
		<%
		}
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70f001e")+":</td>");//任务编号
		buf.append("<td class=\"FieldValue\"><input type=hidden name=requestid value='"+requestid+"'>"+taskno+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")+":</td>");//状态
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+getSelectDicValue(status)+"</td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\">"+labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006")+":</td>");//任务名称
		buf.append("<td class=\"FieldValue\" colspan=3>"+objname+"</td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0043")+":</td>");//结项原因
		buf.append("<td class=\"FieldValue\" colspan=3><TEXTAREA class=\"InputStyle2\" name=\"endreason\" style='width: 92%; height: 30px' >"+endreason+"</TEXTAREA></td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td colspan=4>");
		buf.append("<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\" style=\"border-collapse:collapse;width:100%\" bordercolor=\"#333333\">");
			buf.append("<colgroup>");
			buf.append("<col width=\"40%\" />");
			buf.append("<col width=\"30%\" />");
			buf.append("<col width=\"30%\" />");
			buf.append("</colgroup>");																														
			buf.append("<tr style=\"background:#E0ECFC;border:1px solid #c3daf9;height:25;\">");
				buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402881ee0c715de3010c7248aaad0072")+"</td>");//节点名称
				buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0044")+"</td>");//节点状态
				buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e89000e")+"</td>");//文档编号	
			buf.append("</tr>");
			buf.append("<tbody>");
			for(int i=0,size=sublist.size();i<size;i++)
			{
				Map m1 = (Map)sublist.get(i);
				String taskno1 = StringHelper.null2String(m1.get("taskno"));
				String objname1 = StringHelper.null2String(m1.get("objname"));
				String status1 = StringHelper.null2String(m1.get("status"));
				String requestid1 = StringHelper.null2String(m1.get("requestid1"));

				buf.append("<tr style=\"background:#E0ECFC;border:1px solid #c3daf9;height:25;\">");
					buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+objname1+"</td>");
					buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+getSelectDicValue(status1)+"</td>");
					buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+taskno1+"</td>	");
				buf.append("</tr>");

			}
		buf.append("</td>");
		buf.append("</tr>");
	}
	out.println(buf.toString());
	%>
	</table>
	</div>
</div>
</body>
</html>
<%!
	/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getSelectDicValue(String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select OBJNAME from selectitem where id='"+dicID+"'");
	}
	/**
	 * 取brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValue(String tab,String idCol,String valueCol,String dicID)
	{
		if(dicID==null||dicID.length()<1)return "";
		String dicValue="";
		DataService ds = new DataService();
		return ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicID+"'");
	}


%>
