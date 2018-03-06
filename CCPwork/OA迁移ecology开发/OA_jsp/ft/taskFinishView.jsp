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
<%
String type = request.getParameter("action");
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql = "";
List ls=null;
String delids = StringHelper.null2String(request.getParameter("delids"));
String[] delidsArr=delids.split(",");
String ids = "'0'";
for(int i=0,len=delidsArr.length;i<len;i++)
{
	ids=ids+",'"+delidsArr[i]+"'";
}

//String url="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=search&workflowid=";
%>
<%@ include file="/base/init.jsp"%>
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
<body>
<form id="EweaverForm" name="EweaverForm" action="/app/ft/taskFinishView.jsp" target="" method="post">
 <input type="hidden" name="action" id="action" value="submit"/>
 <input type="hidden" name="ids" id="ids" value="<%=ids%>"/>
<div id="searchDiv"  >
<div id="pagemenubar"></div> <br>
<div style="width:95%">
<%
List contractlist= baseJdbc.executeSqlForList("select requestid,no,name,dodept,orgunit,a.customercoding,a.pjprincipal,a.state,FLOWNO from uf_contract a where a.requestid in ("+ids+") order by FLOWNO");
List mainlist= baseJdbc.executeSqlForList("select id,requestid,projectid,taskno,objname,status from edo_task where model='2c91a84e2aa7236b012aa737d8930006'  and  projectid in ("+ids+") order by projectid,outlinelevel,outlinenumber");
List sublist= baseJdbc.executeSqlForList("select requestid,parenttaskuid,projectid,taskno,objname,nvl(status,'2c91a0302aa21947012aa232f186000f') status from edo_task where model='2c91a84e2aa7236b012aa737d8930007'  and  projectid in ("+ids+") order by projectid,parenttaskuid,outlinelevel,outlinenumber");
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
	if(contractlist.size()>0)
	{
	
		Map mm = (Map)contractlist.get(0);
		String no = StringHelper.null2String(mm.get("no"));
		String name = StringHelper.null2String(mm.get("name"));
		String dodept = StringHelper.null2String(mm.get("dodept"));
		String orgunit = StringHelper.null2String(mm.get("orgunit"));
		String customercoding = StringHelper.null2String(mm.get("customercoding"));
		String pjprincipal = StringHelper.null2String(mm.get("pjprincipal"));
		String state = StringHelper.null2String(mm.get("state"));
		String requestidm = StringHelper.null2String(mm.get("requestid"));


		buf.append("<tr>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0043")+":</td>");//合同号
		buf.append("<td class=\"FieldValue\">"+no+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c")+":</td>");//合同名称
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+name+"</td>");
		buf.append("</tr>");
	
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")+":</td>");//部门
		buf.append("<td class=\"FieldValue\">"+getBrowserDicValues("orgunit","id","objname",dodept)+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7160056")+":</td>");//项目负责人
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+getBrowserDicValue("humres","id","objname",pjprincipal)+"</td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c800063")+":</td>");//事业部
		buf.append("<td class=\"FieldValue\">"+getBrowserDicValues("orgunit","id","objname",orgunit)+"</td>");
		buf.append("<td class=\"FieldName\" nowrap=\"true\">"+labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")+":</td>");//状态
		buf.append("<td class=\"FieldValue\" style=\"color:red\">"+getSelectDicValue(state)+"</td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td class=\"FieldName\">"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0051")+":</td>");//甲方名称
		buf.append("<td class=\"FieldValue\" colspan=3>"+getBrowserDicValue("uf_customer","requestid","unitname",customercoding)+"</td>");
		buf.append("</tr>");
		buf.append("<tr>");
		buf.append("<td colspan=4>");
		buf.append("<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\" style=\"border-collapse:collapse;width:100%\" bordercolor=\"#333333\">");
		buf.append("<colgroup>");
		buf.append("<col width=\"5%\" />");
		buf.append("<col width=\"40%\" />");
		buf.append("<col width=\"45%\" />");
		buf.append("<col width=\"10%\" />");
		buf.append("</colgroup>");																													
		buf.append("<tr style=\"background:#FAF9FB;border:1px solid #EEF4FD;height:20;\">");
		buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402883d934c095220134c09523720000")+"</td>");//序号
		buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"center\">"+labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fce4cc10006")+"</td>");//任务名称
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402883de35273f910135273f955b0044")+"</td>");//节点状态
		buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+labelService.getLabelNameByKeyId("402881ea0cc094ad010cc09ec149000b")+"</td>");//任务状态	
		buf.append("</tr>");
		buf.append("<tbody>");
		for(int i=0,size=mainlist.size();i<size;i++)
		{
			Map m = (Map)mainlist.get(i);
			String taskno = StringHelper.null2String(m.get("taskno"));
			String objname = StringHelper.null2String(m.get("objname"));
			String endreason = StringHelper.null2String(m.get("endreason"));
			String status = StringHelper.null2String(m.get("status"));
			String requestid = StringHelper.null2String(m.get("requestid"));
			String id = StringHelper.null2String(m.get("id"));
				String zjstr="";
			for(int j=0,size1=sublist.size();j<size1;j++)
			{
				Map m1 = (Map)sublist.get(j);
				String parenttaskuid = StringHelper.null2String(m1.get("parenttaskuid"));
				if(id.equals(parenttaskuid))
				{
					String taskno1 = StringHelper.null2String(m1.get("taskno"));
					String objname1 = StringHelper.null2String(m1.get("objname"));
					String status1 = StringHelper.null2String(m1.get("status"));
					String requestid1 = StringHelper.null2String(m1.get("requestid1"));
					if(status1.equals("2c91a0302aa21947012aa232f186000f")||status1.equals("2c91a0302aa21947012aa232f1860010"))
					{
						zjstr+="<span style=\"width:100\"><img src=\"/images/base/bacocross.gif\"  border=0> "+objname1+"</span>";
					}
					else
					{
						zjstr+="<span style=\"width:100\"><img src=\"/images/base/bacocheck.gif\" border=0> "+objname1+"</span>";
					}
				}

			}
			buf.append("<tr style=\"background:#E0ECFC;border:1px solid #c3daf9;height:20;\">");
			buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+(i+1)+"</td>	");
			buf.append("<td colspan=\"1\" rowspan=\"1\" align=\"left\" >"+objname+"</td>");
			buf.append("<td colspan=\"1\" align=\"left\" rowspan=\"1\" nowrap>"+zjstr+"</td>");
			buf.append("<td colspan=\"1\" align=\"center\" rowspan=\"1\" >"+getSelectDicValue(status)+"</td>	");
			buf.append("</tr>");
		}
		buf.append("</table>");
		buf.append("</td>");
		buf.append("</tr>");
	}
	out.println(buf);
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

	/**
	 * 取批量brower框字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String getBrowserDicValues(String tab,String idCol,String valueCol,String dicID)
	{
		String dicValue="";
		if(dicID==null||dicID.length()<1)return "";
		String[] dicIDs = dicID.split(",");
		DataService ds = new DataService();
		for(int i=0,size=dicIDs.length;i<size;i++)
		{
			dicValue=dicValue+","+ds.getValue("select "+valueCol+" from "+tab+" where "+idCol+"='"+dicIDs[i]+"'");
		}
		if(dicValue.length()<1)dicValue="";
		else dicValue=dicValue.substring(1,dicValue.length());
		return dicValue;
	}
%>
