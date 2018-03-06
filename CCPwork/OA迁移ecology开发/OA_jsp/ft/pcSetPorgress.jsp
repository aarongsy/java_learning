<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.IDGernerator" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String projectid = request.getParameter("projectid");
String action=StringHelper.null2String(request.getParameter("action"));
if(action!=null&&action.equals("submit"))
{
	
		String[] jzrequestids=request.getParameterValues("jzrequestid");//机组号
		String[] produceqtys=request.getParameterValues("produceqty");//机组产值
		//从表
		String[] contractnos=request.getParameterValues("contractno");//项目号
		String[] jztaskids=request.getParameterValues("jztaskid");//机组号
		String[] taskids=request.getParameterValues("taskid");//任务号
		String[] processids=request.getParameterValues("processid");//进度标识
		String[] processs=request.getParameterValues("process");//进度
		String[] calctypes=request.getParameterValues("calctype");//计算方式
		String[] remarks=request.getParameterValues("remark");//备注
		String[] dsporders=request.getParameterValues("dsporder");//序号
		List<String> sqlList =new ArrayList<String>();
		for(int i=0;i<jzrequestids.length;i++)
        {
			if(produceqtys[i].length()<1)produceqtys[i]="null";
			sqlList.add("update edo_task set produceqty="+produceqtys[i]+" where requestid='"+jzrequestids[i]+"'");
		}
		for(int i=0;i<processids.length;i++)
        {
			if(processs[i].length()<1)processs[i]="null";
			List templist=baseJdbc.executeSqlForList("select requestid from uf_income_pcprocess  where jztaskid='"+jztaskids[i]+"' and processid='"+processids[i]+"'");
			if(templist.size()>0)
			{
				sqlList.add("update uf_income_pcprocess set taskid='"+taskids[i]+"',process="+processs[i]+",remark='"+StringHelper.filterSqlChar(remarks[i])+"',calctype='"+calctypes[i]+"' where jztaskid='"+jztaskids[i]+"' and processid='"+processids[i]+"'");
			}
			else
			{	
				sqlList.add("insert into uf_income_pcprocess(id,requestid,nodeid,rowindex,contractno,jztaskid,taskid,processid,process,dsporder,remark,calctype,status) values " +
				"('"+IDGernerator.getUnquieID()+"','"+IDGernerator.getUnquieID()+"','','','"+contractnos[i]+"','"+jztaskids[i]+"','"+taskids[i]+"','"+processids[i]+"',"+processs[i]+","+dsporders[i]+",'"+StringHelper.filterSqlChar(remarks[i])+"','"+calctypes[i]+"',0)");
			}	
        }
		if(sqlList.size()>0)
		{
			JdbcTemplate jdbcTemp=baseJdbc.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
			}catch(DataAccessException ex){
				tm.rollback(status);
				throw ex;
			}
		}
		String url=request.getContextPath()+"/app/ft/pcSetPorgress.jsp?projectid="+projectid;
    	response.sendRedirect(url);
		return;
}
//String where=" and c.zxr='"+execman+"'";

%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000e") %><!-- 调试关键进度节点 --></title>
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
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
</head>

<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023") %>','S','accept',function(){onSearch()});//保存
	topBar.render('pagemenubar');
	topBar.addSeparator();
  });
function onSearch(){
	document.getElementById('exportType').value="";
	if(checkIsNull())
		document.forms[0].submit();
}
function checkIsNull()
{
	return true;
}
</script>
</head>
<body>
<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="/app/ft/pcSetPorgress.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="submit"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<input type="hidden" name="projectid" id="exportType" value="<%=projectid%>"/>
<table cellspacing="0" border="0" align="center" style="width: 100%;border: 1px #ADADAD solid">
<colgroup>
<col width="15%"/>
<col width="35%"/>
<col width="15%"/>
<col width="35%"/>
</colgroup>
<%
String sql = "SELECT no,name,money,nvl((select sum(PRODUCEQTY) from edo_task  where model='2c91a84e2aa7236b012aa737d8930005' and MASTERTYPE='2c91a0302acabc4e012acac827220002'  and projectid=uf_contract.requestid),0.0) allproduceqty FROM uf_contract WHERE REQUESTID='"+projectid+"' order by no";
List htlist= baseJdbc.executeSqlForList(sql);
sql="select A.id,A.REQUESTID,A.OBJNAME,A.PRODUCEQTY from edo_task a where a.model='2c91a84e2aa7236b012aa737d8930005' and MASTERTYPE='2c91a0302acabc4e012acac827220002'  and projectid='"+projectid+"' order by outlinelevel,outlinenumber";
List jzlist= baseJdbc.executeSqlForList(sql);
StringBuffer buf = new StringBuffer();
if(htlist.size()>0)
{
	Map mht = (Map)htlist.get(0);
	String no=StringHelper.null2String(mht.get("no"));
	String requestid=StringHelper.null2String(mht.get("requestid"));
	String name=StringHelper.null2String(mht.get("name"));
	String money=StringHelper.null2String(mht.get("money"),"0.0");
	String allproduceqty=StringHelper.null2String(mht.get("allproduceqty"),"0.0");
	double unproduceqty=Double.valueOf(money)-Double.valueOf(allproduceqty);
	buf.append("<tr>");
	buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0043")+":</td>");//合同号
	buf.append("<td class=\"FieldValue\">"+no+"</td>");
	buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800064")+"/"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300016")+":</td>");//总金额  未下达金额
	buf.append("<td class=\"FieldValue\">"+NumberHelper.moneyAddComma(money)+" / "+NumberHelper.moneyAddComma(String.valueOf(unproduceqty)) +"</td>");
	buf.append("</tr>");	
	buf.append("<tr>");
	buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c")+":</td>");//合同名称
	buf.append("<td class=\"FieldValue\" style=\"color:red\" colspan=3>"+name+"</td>");
	buf.append("</tr>");

	for(int k=0,sizek=jzlist.size();k<sizek;k++)
	{
		Map mjz = (Map)jzlist.get(k);
		String jzrequestid=StringHelper.null2String(mjz.get("requestid"));
		String id=StringHelper.null2String(mjz.get("id"));
		String objname=StringHelper.null2String(mjz.get("objname"));
		String produceqty=StringHelper.null2String(mjz.get("produceqty"));

		buf.append("<tr>");
		buf.append("<td class=\"FieldValue\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000f")+":</td>");//机组名称
		buf.append("<td class=\"FieldValue\"><input type='hidden' name='jzrequestid' value='"+jzrequestid+"'>"+objname+"</td>");
		buf.append("<td class=\"FieldValue\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300010")+":</td>");//下达金额
		buf.append("<td class=\"FieldValue\"><input type='text' name='produceqty' value='"+produceqty+"'></td>");
		buf.append("</tr>");	
		buf.append("<tr>");
		buf.append("<td colspan=4>");
		buf.append("<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\" style=\"border-collapse:collapse;width:100%\" bordercolor=\"#333333\">");
		buf.append("<colgroup>");
		buf.append("<col width=\"30\" />");
		buf.append("<col width=\"100\" />");
		buf.append("<col width=\"300\" />");
		buf.append("<col width=\"60\" />");
		buf.append("<col width=\"100\" />");
		buf.append("</colgroup>");																													
		buf.append("<tr style=\"background:#FAF9FB;border:1px solid #EEF4FD;height:20;\">");
		buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402883d934c095220134c09523720000")+"</td>");//序号
		buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300011")+"</td>");//进度
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300012")+"</td>");//关键任务
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300013")+"</td>");//占比
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39300014")+"</td>");//计算方式
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a")+"</td>");//备注
		buf.append("</tr>");
		buf.append("<tbody>");
		String contractno2="";
		List jdlist= baseJdbc.executeSqlForList("select a.id,a.objname,nvl(b.process,a.objdesc) process,b.taskid,b.requestid,nvl(b.dsporder,a.dsporder) dsporder,b.jztaskid,b.remark,b.calctype from selectitem a,(select requestid,dsporder,contractno,jztaskid,taskid,process,remark,processid,nvl(calctype,0) calctype from uf_income_pcprocess where contractno='"+projectid+"' and jztaskid='"+id+"') b where  nvl(a.col1,0)=0 and a.id=b.processid(+) and typeid='2c91a0302aa6def0012aad4792cf0838' order by dsporder");
		List tasklist= baseJdbc.executeSqlForList("select A.id,A.REQUESTID,A.OBJNAME from edo_task a where a.model='2c91a84e2aa7236b012aa737d8930006' and parenttaskuid='"+id+"' order by to_number(outlinenumber)");
		for(int i=0,sizei=jdlist.size();i<sizei;i++)
		{
			Map m = (Map)jdlist.get(i);
			String ida=StringHelper.null2String(m.get("id"));
			String objnamea=StringHelper.null2String(m.get("objname"));
			String objdesca=StringHelper.null2String(m.get("objdesc"));
			String dspordera=StringHelper.null2String(m.get("dsporder"));
			String taskida=StringHelper.null2String(m.get("taskid"));
			String jztaskida=StringHelper.null2String(m.get("jztaskid"));
			String requestida=StringHelper.null2String(m.get("requestid"));
			String remark=StringHelper.null2String(m.get("remark"));
			String calctype=StringHelper.null2String(m.get("calctype"));
			String process=StringHelper.null2String(m.get("process"));
	
			buf.append("<tr style=\"height:20;\">");
			buf.append("<td align=\"center\" ><input type='hidden' name='contractno' value='"+projectid+"'><input type='hidden' name='dsporder' value='"+dspordera+"'><input type='hidden' name='jztaskid' value='"+id+"'><input type='hidden' name='processid' value='"+ida+"'>"+dspordera+"</td>");
			buf.append("<td align=\"left\">"+objnamea+"</td>");
			buf.append("<td align=\"left\">");
			buf.append("<select  class=\"inputstyle2\" id=\"taskid\"  name=\"taskid\">");
			buf.append("<option value=\"\"   ></option>");
			for(int x=0,sizex=tasklist.size();x<sizex;x++)
			{
				Map mx = (Map)tasklist.get(x);
				String tempstr=StringHelper.null2String(mx.get("requestid"));
				if(taskida.equals(tempstr))
				{
					buf.append("<option value=\""+mx.get("requestid").toString()+"\"  selected>"+mx.get("objname").toString()+"</option>");
				}
				else
				{
					buf.append("<option value=\""+mx.get("requestid").toString()+"\">"+mx.get("objname").toString()+"</option>");
				}
				
			}
			buf.append("</select>");
			buf.append("</td>");

			buf.append("<td align=\"center\"><input type='text' style='width:80%' name='process' value='"+process+"'></td>");
			buf.append("<td align=\"left\">");
			buf.append("<select style=\"width:95%\" class=\"inputstyle2\" id=\"calctype\"  name=\"calctype\">");

				
					buf.append("<option value=\"0\" "+(calctype.equals("0")?"selected":"")+">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39310017")+"</option>");//自动
			
					buf.append("<option value=\"1\" "+(calctype.equals("1")?"selected":"")+">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39310018")+"</option>");//手工
				
				
			buf.append("</select>");
			buf.append("</td>");
			buf.append("<td align=\"center\"><input type='text' style='width:80%' name='remark' value='"+remark+"'></td>");
			buf.append("</tr>");			
		}
		buf.append("</tbody></table>");
		buf.append("</td>");
		buf.append("</tr>");
	}
}
out.println(buf.toString());
%>
</tbody>
</table>
</form>
</div>
</body>
</html>
