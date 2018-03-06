<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.DataService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%
String nf = request.getParameter("nf");
String yf = request.getParameter("yf");
String bm = request.getParameter("bm");
String yg = request.getParameter("yg");
String kmmc = request.getParameter("kmmc");
String isbx = request.getParameter("isbx");
String action=StringHelper.null2String(request.getParameter("action"));
%>
<%
if(request.getMethod().equalsIgnoreCase("post")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	System.out.println(excel);
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="费用报销统计表.xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<c:if test="${!isExcel}">
<%@ include file="/base/init.jsp"%>
<html>
  <head>
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
 <title><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001c") %><!-- 费用报销统计表 --></title>
 </head>
 <body>
 <form action="/app/project/projectReport.jsp" name="formExport" method="post">
 <input type="hidden" name="action" value="search"/>
 <input type="hidden" name="exportType" id="exportType" value=""/>
  <%
  //费用报销
  StringBuffer  startDate=new StringBuffer("");
  StringBuffer  sqlbf=new StringBuffer("");

   String sdstr="";
   String edstr="";
   if(yf!=null&&!"".equals(yf)){
     startDate.append(nf);
     startDate.append("-");
     startDate.append(yf);
    }else{
   	 startDate.append(nf);
   	}
	String where = " ";
   	sdstr=startDate.toString();
   	sqlbf.append("select sum(url.actualfee) fyze,url.budget from uf_reimburse_list url ,uf_reimburse ur where url.requestid=ur.requestid and ur.reqDate like '"+sdstr+"%' and exists(select id from requestbase where id=ur.requestid and isdelete=0 and isfinished=1) GROUP BY budget");
    if(bm!=null&&!"".equals(bm)){
       sqlbf.append(" and ur.reqDept='"+bm+"'");
    }
     if(yg!=null&&!"".equals(yg)){
       sqlbf.append("  and ur.reqMan='"+yg+"'");
    }
     if(kmmc!=null&&!"".equals(kmmc)){
		 where+=" and ua.objname like '%"+StringHelper.filterSqlChar(kmmc)+"%'";
    }
	if(isbx!=null&&!"".equals(isbx)){
		 where+=" and ua.isRusment ='"+isbx+"'";
    }
 
    String sqlstr=sqlbf.toString();
    DataService ds = new DataService();
	//科目相关信息
	 String sql="select ua.requestid,objlevel,objname,objnumber,(select objname from selectitem where id=ua.isRusment) sfbx from uf_amountstyle ua  where 1=1 "+where+" order by ua.objnumber";
     List  kmList = ds.getValues(sql);
     List  bxList = ds.getValues(sqlstr.toString());
   %>
 <center>
<div id='repContainer' style="width:95%">
 <center>
</c:if>  

<br>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001c") %><!-- 费用报销统计表 --></CENTER></div>
<div align=left width="50%"><%=nf%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 --> &nbsp;<%=yf%><%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028") %><!-- 月 --></div>
<div align=right width="50%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001e") %><!-- 单位(元) --></div>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;" bordercolor="#333333" id="mainTable">
	<colgroup>
	<col width="20%" />
	<col width="20%" />
	<col width="15%" />
	<col width="15%" />
	<col width="30%" />
  </colgroup>
  <tbody>
  <tr style="background:#DADDFE;font-size:12;font-weight:bold;border:1px solid #c3daf9;height:25;">
    <td  align="center" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001f") %><!-- 科目号 --></td>
    <td  align="center" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0020") %><!-- 科目名称 --></td>
    <td align="center" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0021") %><!-- 科目级次 --></td>
    <td align="center" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0022") %><!-- 是否报销科目 --></td>
    <td align="center" ><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0023") %><!-- 报销总额 --></td>
  </tr>
  
  <%
	double sum=0.0;
	StringBuffer buf = new StringBuffer();
	
	for(int i=0,size=kmList.size();i<size;i++){
		 buf.append("<tr style=\"height:22;\" "+(i%2==0?"bgcolor=\"#E0E2E7\"":"")+" >");
		 String jc ="";
		 String mc ="";
		 String bh = "";
		 String sfbx="";
		 String id="";
		 double fyze=0.0;
		 Map kmm = (Map)kmList.get(i);
		 jc = StringHelper.null2String(kmm.get("objlevel")) ;
		 mc = StringHelper.null2String(kmm.get("objname")) ;
		 bh = StringHelper.null2String(kmm.get("objnumber")) ;
		 sfbx = StringHelper.null2String(kmm.get("sfbx")) ;
		 id = StringHelper.null2String(kmm.get("requestid")) ;
		 //报销总额
		 for(int j=0,size1=bxList.size();j<size1;j++)
		 {
			Map bxm = (Map)bxList.get(j);
			String budget = StringHelper.null2String(bxm.get("budget")) ;
			if(budget.equals(id))
			{
				fyze = Double.valueOf(StringHelper.null2String(bxm.get("fyze"))) ;
				break;
			}
		 }
		 sum=sum+fyze;
		 buf.append("<td align=\"center\">"+bh+"</td>");
		 buf.append("<td align=\"center\">"+mc+"</td>");
		 buf.append("<td align=\"center\">"+jc+"</td>");
		 buf.append("<td align=\"center\">"+sfbx+"</td>");
		 buf.append("<td align=\"right\">"+NumberHelper.moneyAddComma(fyze)+"</td>");
		 buf.append("</tr>");
	} 
	buf.append("<tr height=\"25\" bgcolor=\"#BEC1C5\">");
	buf.append("<td height=\"25\" colspan=\"4\"   align=\"center\"><b>"+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0036")+"</b></td>");//总计
	buf.append("<td colspan=\"1\" align=\"right\"><b>"+NumberHelper.moneyAddComma(sum)+"</b></td>");
	buf.append("</tr>");
	out.println(buf.toString());
 
 %>
</table>
<br>
<div style="display:none">
Save2Excel
</form>   
<c:if test="${!isExcel}">
</body>
</html>
</c:if>

