<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%

BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql = "";
List ls=null;
String action = StringHelper.null2String(request.getParameter("action"));
String categroyid = StringHelper.null2String(request.getParameter("categoryid"));
String clientType = StringHelper.null2String(request.getParameter("clientType"));
if(action.equals("submit"))
{
	String clientName = StringHelper.null2String(request.getParameter("clientName")).trim();
	String url="";
	ls = baseJdbc.executeSqlForList("select requestid from uf_customer a where  unitname='"+StringHelper.filterSqlChar(clientName)+"' and exists(select id from formbase where isdelete=0 and id=a.requestid and categoryid='"+categroyid+"')");
	if(ls.size()>0)
	{
		Map m = (Map)ls.get(0);
		String requestid = StringHelper.null2String(m.get("requestid"));
		url="/workflow/request/formbase.jsp?requestid="+requestid;
	}
	else
	{
		url="/workflow/request/formbase.jsp?categroyid="+categroyid+"&prm="+clientName;
	}
	request.getRequestDispatcher(url).forward(request,response);
	return;
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
</style>
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
	if(document.getElementsByName('clientName')[0].value!=null&&document.getElementsByName('clientName')[0].value.length>0)
	{
		document.all('EweaverForm').submit();
	}
	else
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0016") %>");//请填写单位全称
	}
}
</script>
<body>
<form id="EweaverForm" name="EweaverForm"  target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div>
<table cellspacing="0" border="0"  style="width: 80%;border: 1px #ADADAD solid">
<colgroup>
<col width="20%"/>
<col width="80%"/>
</colgroup>
<tr>
<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0017") %><!-- 单位名称 -->:</td>
<td class="FieldValue" colspan=1><input type="text" class="InputStyle2"  MAXLENGTH=256 name="clientName"  id="clientName" style='width: 80%' value=""  onblur="if(document.getElementById('ac_results')&&document.getElementById('ac_results').style.display=='block') return;while(value.replace(/[^\x00-\xff]/g,'ac_results**').length>maxLength)value=value.slice(0,-1);" onChange="checkInput('clientName','clientNamespan')" ><span id="clientNamespan" name="clientNamespan" ><img src="/images/base/checkinput.gif" align=absMiddle></span><br>
<span style="color:red;"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0018") %><!-- 请填写单位全称，系统将自动检查单位是否存在！ --></span>
</TD>
</tr>
</table>
</div>
</div>
</body>
</html>
