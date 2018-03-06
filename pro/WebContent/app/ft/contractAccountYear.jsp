<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.DecimalFormat"%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
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
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String contractnostr=StringHelper.null2String(request.getParameter("contractno"));

if(type.equals("submit")){
	String contractid=request.getParameter("contractno");
	String fromyear=request.getParameter("fromyear");
	String toyear=request.getParameter("toyear");
	String presum=request.getParameter("presum");
	String thissum=request.getParameter("thissum");
	String contractsum=request.getParameter("contractsum");
	String nextsum=request.getParameter("nextsum");
	String remark=request.getParameter("remark");
	sql = "select t.requestid from uf_income_accountyear t,uf_contract a where t.contractno=a.requestid and a.requestid='"+contractnostr+"' and t.fromyear='"+fromyear+"'";
	ls=baseJdbc.executeSqlForList(sql);
	String subId="";
	String subsqlinsert="";
	String[] ididArray=request.getParameterValues("idid");
	String[] finishmoneyArray=request.getParameterValues("finishmoney");
	//String[] subcontractno=request.getParameterValues("subcontractno");
	String[] suborgunitid=request.getParameterValues("suborgunitid");
	String[] subdistsum=request.getParameterValues("subdistsum");
	String[] subremark=request.getParameterValues("subremark");
	String[] subrequestid=request.getParameterValues("subrequestid");
	sql = " update uf_contract a set a.carrymoney ='"+nextsum+"' where requestid='"+contractid+"'";
	baseJdbc.update(sql);
	if(ls.size()<1){
		requestid=IDGernerator.getUnquieID();
		sql = "insert into uf_income_accountyear(id,requestid,fromyear,toyear,contractno,contractsum,presum,thissum,nextsum,remark,bookman,bookdate) values " +
				"('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+fromyear+","+toyear+",'"+contractid+"',"+contractsum+","+presum+","+thissum+","+nextsum+"," +
						"'"+StringHelper.filterSqlChar(remark)+"','"+eweaveruser.getId()+"','"+DateHelper.getCurrentDate()+"')";
		baseJdbc.update(sql);
		
		sql = "insert into formbase(ID,CREATOR,CREATEDATE,CREATETIME,MODIFIER,MODIFYDATE,MODIFYTIME,ISDELETE,CATEGORYID) "+
		 "values ('"+requestid+"','"+eweaveruser.getId()+"','"+DateHelper.getCurrentDate()+"','"+DateHelper.getCurrentTime()+"',"+
		 "'"+eweaveruser.getId()+"','"+DateHelper.getCurrentDate()+"','"+DateHelper.getCurrentTime()+"','0','2c91a0302c619c72012c6390eb941c07')"; 
		baseJdbc.update(sql);
		
		if(suborgunitid!=null){
			for(int i=0;i<suborgunitid.length;i++){
				subId=IDGernerator.getUnquieID();
				subsqlinsert="insert into uf_income_acc_sub(id,requestid,orgunit,accountmoney,remark,finishmoney) values('"+
					subId+"','"+requestid+"','"+suborgunitid[i]+
					"','"+subdistsum[i]+"','"+subremark[i]+"',"+finishmoneyArray[i]+") ";
				baseJdbc.update(subsqlinsert);
			}
		}
	}
	else{	
		String incomeaccount ="";
			Map mp= (Map)ls.get(0);
			incomeaccount=(String)mp.get("requestid");
		sql = "update uf_income_accountyear set fromyear="+fromyear+",toyear="+toyear+",contractno='"+contractid+"',contractsum="+contractsum+",presum="+presum+",thissum="+thissum+",nextsum="+nextsum+",remark='"+StringHelper.filterSqlChar(remark)+"' where requestid='"+incomeaccount+"' and fromyear='"+fromyear+"'";
		baseJdbc.update(sql);
		
		if(suborgunitid!=null){
		for(int i=0;i<suborgunitid.length;i++){
		//判断结转子表是否含有该部门记录
			String ishavedepart="select orgunit from uf_income_acc_sub where  orgunit='"+suborgunitid[i]+"' and requestid='"+incomeaccount+"'";
			List ishaveDepart=baseJdbc.executeSqlForList(ishavedepart);
			if(ishaveDepart.size()>0){
				subId=IDGernerator.getUnquieID();
				subsqlinsert="update uf_income_acc_sub set finishmoney="+finishmoneyArray[i]+",accountmoney="+subdistsum[i]+" where orgunit='"+suborgunitid[i]+"' and requestid='"+incomeaccount+"'";
				baseJdbc.update(subsqlinsert);
			}else{
				subId=IDGernerator.getUnquieID();
				subsqlinsert="insert into uf_income_acc_sub(id,requestid,orgunit,accountmoney,remark,finishmoney) values('"+
				subId+"','"+incomeaccount+"','"+suborgunitid[i]+
				"','"+subdistsum[i]+"','"+subremark[i]+"',"+finishmoneyArray[i]+") ";
				baseJdbc.update(subsqlinsert);
			}
		
		}
		}
	}

	FormService formService=(FormService)BaseContext.getBean("formService");	
	formService.getPermissionRuleFromCategory("2c91a0302c619c72012c6390eb941c07",requestid);
}

String delids = StringHelper.null2String(request.getParameter("delids"));

String[] delidsArr=delids.split(",");
String ids = "0";
if(delidsArr.length>0){
	ids=delidsArr[0];
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/engine.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
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
	if(document.getElementById('contractno').value==null&&document.getElementById('contractno').value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0040") %>");//请选择要结转的合同！
		return;
	}
	if(document.getElementById('thissum').value==null&&document.getElementById('thissum').value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0041") %>");//请填写本年完成金额！
		return;
	}
	document.all('EweaverForm').submit();
}
》</script>
<body>
<form id="EweaverForm" name="EweaverForm" action="" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
 <input type="hidden" name="trids" id="trids" value="<%=ids%>"/>
 <input type="hidden" name="requestid" id="requestid" value="<%=requestid%>"/>
 
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:80%">
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
<colgroup>
<col width="20%"/>
<col width="80%"/>
</colgroup>
<%
	//查询子表的相关字段信息
	String subSql="";
	if(!"".equals(ids)){
		//查询历史记录
		
		subSql = "select a.contractno as subcontractno,0 as finishmoney,a.remark as subremark,a.requestid as subrequestid,a.orgid as suborgid,b.objname as subobjname,nvl(a.distsum,0.0) as subdistsum from uf_contract_dist a ,orgunit b where a.orgid=b.id and a.requestid='"+ids+"'";
	}else{
		subSql = "select nvl(b.finishmoney,0.0) as finishmoney,b.accountmoney as subdistsum,b.remark as subremark,o.objname as subobjname,o.id as suborgid,b.requestid as subrequestid,a.contractno as subcontractno  from uf_income_accountyear a ,uf_income_acc_sub b,orgunit o  where a.requestid=b.requestid and b.orgunit=o.id and a.requestid='"+requestid+"'";
	}
	List listSub=baseJdbc.executeSqlForList(subSql);
	//查询主表字段
	sql = "select requestid,fromyear,contractno,(select no from uf_contract where requestid=t.contractno) no,nvl(contractsum,0.0) contractsum,nvl(projectsum,0.0) projectsum,nvl(thissum,0.0) thissum,nvl(nextsum,0.0) nextsum,nvl(presum,0.0) presum,toyear,remark from uf_income_accountyear t where requestid='"+requestid+"'";
	List ls1 = baseJdbc.executeSqlForList(sql);
	sql = "select requestid,no,name,nvl((select sum(thissum) from uf_income_accountyear where contractno=t.requestid),0.0) presum,money from uf_contract t where requestid='"+ids+"'";
	ls = baseJdbc.executeSqlForList(sql);

	String contractid="";
	String contractno="";
	String contractname="";
	String fromyear="";
	String toyear="";
	double presum=0.0;
	double thissum=0.0;
	double contractsum=0.0;
	double nextsum=0.0;
	String remark="";
	if(ls1.size()>0){
		Map m= (Map)ls1.get(0);
		contractid=StringHelper.null2String(m.get("contractno"));
		contractno=StringHelper.null2String(m.get("no"));
		contractsum=Double.valueOf(StringHelper.null2String(m.get("contractsum")));
		thissum=Double.valueOf(StringHelper.null2String(m.get("thissum")));
		nextsum=Double.valueOf(StringHelper.null2String(m.get("nextsum")));
		presum=Double.valueOf(StringHelper.null2String(m.get("presum")));
		toyear=StringHelper.null2String(m.get("toyear"));
		remark=StringHelper.null2String(m.get("remark"));
		fromyear=StringHelper.null2String(m.get("fromyear"));
	
	}else if(ls.size()>0){
		Map m= (Map)ls.get(0);
		contractid=StringHelper.null2String(m.get("requestid"));
		contractno=StringHelper.null2String(m.get("no"));
		contractsum=Double.valueOf(StringHelper.null2String(m.get("money")));
		presum=Double.valueOf(StringHelper.null2String(m.get("presum")));
	}
	
%>
	<tr>
	<td class="FieldValue" nowrap="true" colspan=2><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0042") %><!-- 合同信息 -->：</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0043") %><!-- 合同号 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<!-- 	<button  class=Browser type=button onclick="getrefobj('contractno','contractnospan','2c91a0302a9c6fa0012a9dbf6df30107','/workflow/request/formbase.jsp?requestid=','0');"></button> -->
		<input type="hidden" name="contractno" value="<%=contractid%>"    >
		<span id="contractnospan" name="contractnospan" ><%=contractno%></span>
	</span>
	</td>
	</tr>
	<tr>
	<%DecimalFormat df =new DecimalFormat("#.##"); %>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0044") %><!-- 合同总金额 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span><input type="text" class="InputStyle2" name="contractsum"  style="background:#D5EEE1" id="contractsum" value="<%=df.format(contractsum)%>"  style='width: 80%' readonly>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0045") %><!-- 元 --></span>
	</td>
	</tr>
	<tr>
	<td class="FieldValue" nowrap="true" colspan=2><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0046") %><!-- 请填写结转信息 -->：</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003e") %><!-- 结算年度 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span><select name="fromyear" id="fromyear" style="background:#FDD5C4" style="width:80%" onchange="javascript:fromyearChange(this);"> <%--<%if(!StringHelper.isEmpty(fromyear)){%>disabled<%} %>
	--%><%
	int currentyear1=currentyear;
	if(fromyear.length()>0)currentyear=Integer.parseInt(fromyear);
		for(int i=currentyear1-1;i<currentyear1+1;i++)
		{
			if(i==currentyear)
				out.println("<option value='"+i+"' selected>"+i+"</option>");
			else 
				out.println("<option value='"+i+"'>"+i+"</option>");
		}
		toyear=String.valueOf(currentyear+1);
	%>
	</select>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --></span>
	</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0046") %><!-- 请填写结转信息 -->：</td>
	</tr>

	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0047") %><!-- 合同去年完成 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<input type="text" class="InputStyle2" name="presum"  id="presum" value="0"  style='width: 80%'    readonly style="background:#D5EEE1">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0045") %><!-- 元 -->
	</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0048") %><!-- 合同已完成 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<input readOnly="true"  style="background:#D5EEE1" type="text" class="InputStyle2" name="thissum"  id="thissum" value="<%=df.format(thissum)%>"  style='width: 80%'  onblur="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0049") %>')"  onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0049") %>');checkInput('thissum','thissumspan');" >&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0045") %><!-- 元 -->
	</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004a") %><!-- 结算至年度 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span><input type="text" class="InputStyle2" name="toyear" style="background:#D5EEE1" id="toyear" value="<%=toyear%>"  style='width: 80%' readonly>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --></span>
	</td>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004b") %><!-- 结转总金额 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<input type="text" class="InputStyle2" name="nextsum" style="background:#D5EEE1" id="nextsum" value="<%=df.format(nextsum)%>"  style='width: 80%'   readonly>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0045") %><!-- 元 -->
	</td>
	</tr>
	<tr>
	<table>
<TR class=Header>
<TD noWrap width="20%">
<P align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004c") %><!-- 业务部门 --></P></TD>
<TD noWrap width="20%">
<P align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004d") %><!-- 部门结转金额 --></P></TD>
<TD noWrap width="20%">
<P align=center><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004e") %><!-- 部门已完成金额 --></P></TD>
<TD noWrap width="40%">
<P align=center><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 --></P></TD>
</TR>
<%
	if(listSub.size()>0){
	for(int i=0;i<listSub.size();i++){
		Map subMap = (Map)listSub.get(i);	
 %>
<TR class=DataLight>
<TD noWrap>
	<INPUT readOnly="true"  style="WIDTH: 90%" name=suborgunit class=InputStyle2  value=<%=subMap.get("subobjname") %>>
	<INPUT style="display:none" name=suborgunitid class=InputStyle2   value=<%=subMap.get("suborgid") %>>
	<INPUT style="display:none" name=subrequestid class=InputStyle2   value=<%=subMap.get("subrequestid") %>>
	<INPUT style="display:none" name=subcontractno class=InputStyle2   value=<%=subMap.get("subrequestid") %>>
</TD>
<TD noWrap>
	<INPUT type="hidden" id="ORGsubdistsum<%=i+1 %>" value=<%=Integer.parseInt(subMap.get("subdistsum").toString())+Integer.parseInt(subMap.get("finishmoney").toString()) %>>
	<INPUT readOnly="true" style="WIDTH: 90%" name=subdistsum id="subdistsum<%=i+1 %>" class=InputStyle2    value=<%=subMap.get("subdistsum") %>>
</TD>
<TD noWrap>
	<INPUT style="background:#FDD5C4"  style="WIDTH: 90%" name=finishmoney id="finishmoney<%=i+1 %>" class=InputStyle2 value=<%=subMap.get("finishmoney") %> onpropertychange="valueChange(this)" onchange="totalChange(this)">
</TD>
<TD noWrap>
	<INPUT style="WIDTH: 90%" name=subremark class=InputStyle2    value=<%=StringHelper.null2String(subMap.get("subremark")) %>>
</TD>
	</tr>
	<%} }%>
	</table>
	</tr>
	<tr>
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %><!-- 备注 -->：</td>
	<td class="FieldValue" nowrap="true">
	<span>
	<TEXTAREA class="InputStyle2" name="remark" style="background:#FDD5C4" style='width: 92%; height: 60px'  onblur="fieldcheck2(this,'','<%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a") %>')"  ><!-- 备注 --><%=remark%></TEXTAREA>
	</span>
	</td>
	</tr>
	
	</table>
	</div>
</div>
</body>
</html>
<script>
function fromyearChange(obj){
	document.getElementById('toyear').value=parseInt(obj.value)+1;
	DataService.getValue("select sum(thissum) from uf_income_accountyear where contractno='"+
			document.getElementById("contractno").value+"' and toyear='"+
			document.getElementById("fromyear").value+"'",
			function(value){if(!value)value=0;document.getElementById("presum").value = value;});
}
window.onload=function(){
	document.getElementById("fromyear").fireEvent("onchange");
	document.getElementById("finishmoney1").fireEvent("onchange");
}
function valueChange(obj){
	obj.id.match(/\D*(\d+)/gi); 
	if((document.getElementById('ORGsubdistsum'+RegExp.$1).value-obj.value)<0){
		alert("<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f004f") %>");//部门已完成金额超出范围！
		obj.value=document.getElementById('ORGsubdistsum'+RegExp.$1).value;
		totalChange(obj);
		return;
	}
	document.getElementById('subdistsum'+RegExp.$1).value = document.getElementById('ORGsubdistsum'+RegExp.$1).value-obj.value;
}
function totalChange(obj){
	var tempObjs = Ext.query("input[@id^='finishmoney']");
	var thisYearTotal=0;
	for(var i=0;i<tempObjs.length;i++){
		thisYearTotal+=parseInt(tempObjs[i].value);
	}
	document.getElementById("thissum").value=thisYearTotal;
	tempObjs = Ext.query("input[@id^='subdistsum']");
	thisYearTotal=0;
	for(var i=0;i<tempObjs.length;i++){
		thisYearTotal+=parseInt(tempObjs[i].value);
	}
	document.getElementById("nextsum").value=thisYearTotal;
}
</script>