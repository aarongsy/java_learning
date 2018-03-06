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
if(type.equals("submit"))
{
	String trids=request.getParameter("trids");
	String ny=nf+"-"+yf;
	baseJdbc.update("update uf_contract set state='2c91a0302a8cef72012a8eabe0e803f3',finishdate=to_char(last_day(to_date('"+ny+"','yyyy-mm')),'yyyy-mm-dd') where  requestid in ("+trids+") and state='2c91a0302a8cef72012a8eabe0e803f2'");
	out.println("<script>");
	out.println("alert('"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003c")+"');");
	out.println("self.parent.dlg0.hide();self.parent.store.reload();");
	out.println("</script>");
	return;
}
//String url="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=search&workflowid=";
String sql = "";
List ls=null;
String delids = StringHelper.null2String(request.getParameter("delids"));
String[] delidsArr=delids.split(",");
String ids = "'0'";
for(int i=0,len=delidsArr.length;i<len;i++)
{
	ids=ids+",'"+delidsArr[i]+"'";
}
%>
<%@ include file="/base/init.jsp"%>
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
<script type="text/javascript">
Ext.onReady(function(){
	Ext.QuickTips.init();
	var topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onsubmit()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	topBar.addFill();
  });
function onsubmit(){
	document.all('EweaverForm').submit();
}
</script>
<body>
<form id="EweaverForm" name="EweaverForm" action="/app/ft/contractAccount.jsp" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
 <input type="hidden" name="trids" id="trids" value="<%=ids%>"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:60%">
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
<colgroup>
<col width="20%"/>
<col width="80%"/>
</colgroup>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003d") %><!-- 请选择结算年度和月份 -->：</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003e") %><!-- 结算年度 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span><select name="nf" id="nf" style="width:150">
	<%
		for(int i=currentyear-2;i<currentyear+1;i++)
		{
			if(i==currentyear)
				out.println("<option value='"+i+"' selected>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
			else 
				out.println("<option value='"+i+"'>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
		}

	%>
	</select></span>
	</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003f") %><!-- 结算月份 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<select name="yf" id="yf" style="width:150">
		<option value="01" <%=yf.equals("01")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0028") %><!-- 一月 --></option>
				<option value="02" <%=yf.equals("02")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0029") %><!-- 二月 --></option>
				<option value="03" <%=yf.equals("03")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002a") %><!-- 三月 --></option>
				<option value="04" <%=yf.equals("04")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002b") %><!-- 四月 --></option>
				<option value="05" <%=yf.equals("05")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002c") %><!-- 五月 --></option>
				<option value="06" <%=yf.equals("06")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c002d") %><!-- 六月 --></option>
				<option value="07" <%=yf.equals("07")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002e") %><!-- 七月 --></option>
				<option value="08" <%=yf.equals("08")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e002f") %><!-- 八月 --></option>
				<option value="09" <%=yf.equals("09")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0030") %><!-- 九月 --></option>
				<option value="10" <%=yf.equals("10")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0031") %><!-- 十月 --></option>
				<option value="11" <%=yf.equals("11")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0032") %><!-- 十一月 --></option>
				<option value="12" <%=yf.equals("12")?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0033") %><!-- 十二月 --></option>
	</select>
	</span>
	</td>
	</tr>
	</table>
	</div>
</div>
</body>
</html>
<%!

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
