<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>

<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.sap.conn.jco.JCoException"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>

<%
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
String username = currentuser.getObjname();
String userno = currentuser.getObjno();
String sapno = currentuser.getExttextfield15();
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String themonth = StringHelper.null2String(request.getParameter("themonth"));

String h1 = "0";//旷工时数
String h2 = "0";//延时加班时数
String h3 = "0";//双休加班时数
String h4 = "0";//法定加班时数
String h5 = "0";//事假时数
String h6 = "0";//伤病假时数
String h7 = "0";//医疗期时数
String h8 = "0";//产假时数
String h9 = "0";//流产假时数
String h10 = "0";//婚假时数
String h11 = "0";//丧假时数
String h12 = "0";//工伤假时数
String h13 = "0";//护理假时数
String h14 = "0";//年休假时数
String h15 = "0";//换休假时数
String h16 = "0";//请假总时数
String h17 = "0";//加班总时数
String h18 = "0";//可休事假时数
String h19 = "0";//剩余年假时数
String h20 = "0";//剩余双休调休时数
String h21 = "0";//剩余延时调休时数
String h22 = "0";//可休病假时数


if(themonth!=null){	
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZHR_PAYROLL_TIME_DATA_GET";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段
	function.getImportParameterList().setValue("PERNR",sapno);
	function.getImportParameterList().setValue("MONTH",themonth);

	try {
		function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
	} catch (JCoException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	JCoTable retTable = function.getTableParameterList().getTable("PYTDA");
	if (retTable != null) {
		for (int i = 0; i < retTable.getNumRows(); i++) {
			String LGART = retTable.getString("LGART");
			String ANZHL = retTable.getString("ANZHL");
			if(LGART.equals("4015")){
				h1 = ANZHL;
			}
			if(LGART.equals("3015")){
				h2 = ANZHL;
			}
			if(LGART.equals("3020")){
				h3 = ANZHL;
			}
			if(LGART.equals("3030")){
				h4 = ANZHL;
			}
			if(LGART.equals("4005")){
				h5 = ANZHL;
			}
			if(LGART.equals("4010")){
				h6 = ANZHL;
			}
			if(LGART.equals("4020")){
				h7 = ANZHL;
			}
			if(LGART.equals("4025")){
				h8 = ANZHL;
			}
			if(LGART.equals("4030")){
				h9 = ANZHL;
			}
			if(LGART.equals("4035")){
				h10 = ANZHL;
			}
			if(LGART.equals("4040")){
				h11 = ANZHL;
			}
			if(LGART.equals("4040")){
				h11 = ANZHL;
			}
			retTable.nextRow();
		}
	}
	//定额
	SapConnector sapConnector2 = new SapConnector();
	String functionName2 = "ZHR_IT2006_GET";
	JCoFunction function2 = null;
	try {
		function2 = SapConnector.getRfcFunction(functionName2);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	//插入字段
	function2.getImportParameterList().setValue("PERNR",sapno);

	try {
		function2.execute(sapConnector2.getDestination(sapConnector2.fdPoolName));
	} catch (JCoException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	JCoTable retTable2 = function2.getTableParameterList().getTable("IT2006");
	if (retTable != null) {
		for (int i = 0; i < retTable2.getNumRows(); i++) {
			String field1 = retTable2.getString("KTART");
			String field2 = retTable2.getString("ANZHL");
			String ZEINH = retTable2.getString("ZEINH");
			if(ZEINH.equals("010")){
				field2 = NumberHelper.string2Double(field2)*8+"";
			}
			if(field1.equals("30")){
				h18 = field2;
			}
			if(field1.equals("10")){
				h19 = field2;
			}
			if(field1.equals("21")){
				h20 = field2;
			}
			if(field1.equals("20")){
				h21 = field2;
			}
			if(field1.equals("90")){
				h22 = field2;
			}
			retTable2.nextRow();
		}

	}
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>

<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
    .x-panel-body-noheader{
        border-top:#99bbe8 0px solid
    }
	input{ border-left:0px;border-top:0px;border-right:0px;border-bottom:1px solid #0D0000 } span{ vertical-align:top; }
</style>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%= request.getContextPath()%>/app/hrmanage/selfSearch.jsp" name="EweaverForm" id="EweaverForm" method="post">
<input type="hidden" name="submitaction"  id="submitaction" value="search"/>
<center>
        <table style="border:0;width:98%;">
				<colgroup>
					<col width="16.6%">
					<col width="16.6%">
					<col width="16.6%">
					<col width="16.6%">
					<col width="16.6%">
					<col width="16.6%">
				</colgroup>

            <TR height="60">
            	<TD class=Spacing colspan=6 align="center">			
				<span style="color:#8a8a8a;font-size:15pt;padding:10px">
					<b>员工考勤信息查询</b>
				</span>
				<br>
				</TD>
			</TR>
			<TR><TD class=Line colspan=6 style="height: 1px;background-color: #C2D5FC;"></TD><TR>
			<TR>
			<TD class=FieldName noWrap>员工工号</TD>
			<TD class=FieldValue colspan=2><%=userno %></TD>
			<TD class=FieldName noWrap>员工姓名</TD>
			<TD class=FieldValue colspan=2><%=username %></TD>
			</TR>	
			<TR>
			<TD class=FieldName noWrap>所属薪资月</TD>
			<TD class=FieldValue colspan=5><input style="width:20%" type="text" id="themonth" name="themonth" value="<%=themonth %>"   class=inputstyle size=10 onclick="WdatePicker({dateFmt:'yyyyMM'})"  onChange="checkInput('themonth','themonthspan')" ><span id="themonthspan" name="themonthspan" ><img src="/images/base/checkinput.gif" align=absMiddle></span>
			&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:onSubmit()" class="btn" >查询</a></TD></TR>
			<TR><TD  colspan=6 style="height: 10px;"></TD><TR>
			<TR>
			<TD class=FieldName noWrap>旷工时数</TD>
			<TD class=FieldName noWrap>延时加班时数</TD>
			<TD class=FieldName noWrap>双休加班时数</TD>
			<TD class=FieldName noWrap>法定加班时数</TD>
			<TD class=FieldName noWrap>事假时数</TD>
			<TD class=FieldName noWrap>伤病假时数</TD>
			</TR>
			<TR>
			<TD class=FieldValue noWrap><%=h1 %></TD>
			<TD class=FieldValue noWrap><%=h2 %></TD>
			<TD class=FieldValue noWrap><%=h3 %></TD>
			<TD class=FieldValue noWrap><%=h4 %></TD>
			<TD class=FieldValue noWrap><%=h5 %></TD>
			<TD class=FieldValue noWrap><%=h6 %></TD>
			</TR>
			
			<TR>
			<TD class=FieldName noWrap>医疗期时数</TD>
			<TD class=FieldName noWrap>产假时数</TD>
			<TD class=FieldName noWrap>流产假时数</TD>
			<TD class=FieldName noWrap>婚假时数</TD>
			<TD class=FieldName noWrap>丧假时数</TD>
			<TD class=FieldName noWrap>工伤假时数</TD>
			</TR>
			<TR>
			<TD class=FieldValue noWrap><%=h7 %></TD>
			<TD class=FieldValue noWrap><%=h8 %></TD>
			<TD class=FieldValue noWrap><%=h9 %></TD>
			<TD class=FieldValue noWrap><%=h10 %></TD>
			<TD class=FieldValue noWrap><%=h11 %></TD>
			<TD class=FieldValue noWrap><%=h12 %></TD>
			</TR>
			
			<TR>
			<TD class=FieldName noWrap>护理假时数</TD>
			<TD class=FieldName noWrap>年休假时数</TD>
			<TD class=FieldName noWrap>换休假时数</TD>
			<TD class=FieldName noWrap>请假总时数</TD>
			<TD class=FieldName noWrap>加班总时数</TD>
			<TD class=FieldName noWrap></TD>
			</TR>
			<TR>
			<TD class=FieldValue noWrap><%=h13 %></TD>
			<TD class=FieldValue noWrap><%=h14 %></TD>
			<TD class=FieldValue noWrap><%=h15 %></TD>
			<TD class=FieldValue noWrap><%=h16 %></TD>
			<TD class=FieldValue noWrap><%=h17 %></TD>
			<TD class=FieldValue noWrap></TD>
			</TR>
			
			<TR><TD  colspan=6 style="height: 5px;"></TD><TR>
			<TR><TD class=Line colspan=6 style="height: 1px;background-color: #C2D5FC;"></TD><TR>
			<TR><TD class=FieldName colspan=6>到目前为止的定额余数：</TD></TR>
			
			<TR>
			<TD class=FieldName noWrap>可休事假时数</TD>
			<TD class=FieldName noWrap>剩余年假时数</TD>
			<TD class=FieldName noWrap>剩余双休调休时数</TD>
			<TD class=FieldName noWrap>剩余延时调休时数</TD>
			<TD class=FieldName noWrap>可休一般病假时数</TD>
			<TD class=FieldName noWrap></TD>
			</TR>
			<TR>
			<TD class=FieldValue noWrap><%=h18 %></TD>
			<TD class=FieldValue noWrap><%=h19 %></TD>
			<TD class=FieldValue noWrap><%=h20 %></TD>
			<TD class=FieldValue noWrap><%=h21 %></TD>
			<TD class=FieldValue noWrap><%=h22 %></TD>
			
			<TD class=FieldValue noWrap></TD>
			</TR>
			<TR><TD  colspan=6 style="height: 5px;"></TD><TR>
			<TR><TD class=Line colspan=6 style="height: 1px;background-color: #C2D5FC;"></TD><TR>
			<TR>
			<TD class=FieldName colSpan=6>奖惩信息：</TD></TR>
			<TR>
			<TD colSpan=6>
			<DIV id=yearHldDiv></DIV><IFRAME id=splitIframe4 src="<%= request.getContextPath()%>/app/oamanage/report.jsp?action=search&reportid=40285a904a9639b6014a99048ad40d3e&sqlwhere=jobname='<%=userid %>'" frameBorder=0 width="100%" name=splitIframe4 scrolling=no></IFRAME></TD></TR>
			
	    </table>
	</center>
</form>
      </div>
    <div id="messagePage">
        <table style="border:0">
            <TR><TD><span id="message" name="message" style="font-size:12"></span></TD></TR>
            </table>
      </div>
  </body>
<script language="javascript">
function reset(){
   document.all('EweaverForm').reset();
}


function onSubmit(){
	var themonth = document.getElementById('themonth').value;
	if(!themonth){
		alert('所属薪资月不能为空！');
	}else{
		document.EweaverForm.submit();
	}		
}

</script>
</html>
