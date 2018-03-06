<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
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
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%
String year = StringHelper.null2String(request.getParameter("year"));
if(year==null) year="";
String action=StringHelper.null2String(request.getParameter("action"));
DataService ds = new DataService();
String where=" and B.EXMYEAR='"+year+"'";
String sql = "select EXMYEAR  from uf_hrm_examinedate   where requestid='"+year+"'";
List yearlist = ds.getValues(sql);
String exmyear = "";
if(yearlist.size()>0)
{
	Map m = (Map)yearlist.get(0);
	exmyear = m.get("EXMYEAR").toString();
}
%>
<%!


		/**
	 * 取select字段字典值。
	 * @param dicID。
	 * @return dicValue。
	 */
	private String progress(String fieldvalue)
	{
			fieldvalue = "<div id=\"p2\" >\n" +
                                                " <div style=\"width: auto; height: 15px;\" id=\"pbar2\" class=\"x-progress-wrap left-align\">\n" +
                                                "          <div class=\"x-progress-inner\">\n" +
                                                "              <div style=\"width: " +fieldvalue+ "%; height: 15px;\" id=\"ext-gen9\" class=\"x-progress-bar\">\n" +
                                                "              <div style=\"z-index: 99; width: 100px;\" id=\"ext-gen10\" class=\"x-progress-text x-progress-text-back\">" +
                                                "           <div style=\"width: 100px; height: 15px;\" id=\"ext-gen12\">" + fieldvalue + "%" + "</div>" +
                                                "             </div>\n" +
                                                "           </div>\n" +
                                                "          </div>\n" +
                                                "      </div>\n" +
                                                "  </div>";
		return fieldvalue;
	}
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
<%@ include file="/base/init.jsp"%>
<%

if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname=year+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150042");//年度-绩效考核总表.xls
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<c:if test="${!isExcel}">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150043")%><!-- 绩效考核总表 --></title>
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
<style>
ul li ol{margin-left:10px;}
table{width:auto;}
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
</head>
<script type="text/javascript">
function parserRefParam(inputname,_fieldcheck){
		if(getValidStr(_fieldcheck)=="")
			return;
		strend = inputname.substring(38);
		
		spos = _fieldcheck.indexOf("$");
		while(spos != -1){
			epos = _fieldcheck.indexOf("$",spos+1);
			if (spos != -1 && epos != -1) {
				pname = _fieldcheck.substring(spos + 1, epos);
				pname = "field_"+pname+strend;
				pvalue = getValidStr(document.all(pname).value);
				
				_fieldcheck = _fieldcheck.substring(0,spos)+pvalue+_fieldcheck.substring(epos+1);
				
			}
			spos = _fieldcheck.indexOf("$",epos+1);
		}
		_fieldcheck = _fieldcheck.ReplaceAll("%27","'");
		spos = _fieldcheck.indexOf("sqlwhere=");
		var sqlwhere = "";
		if(spos !=-1){
			epos = _fieldcheck.indexOf("&",spos+1);
			if(epos ==-1){
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9);
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere;
				
			}else{
			
				var stag = _fieldcheck.substring(0,spos+9);
				sqlwhere = _fieldcheck.substring(spos+9,epos);
				
				var etag = _fieldcheck.substring(epos);
				
				sqlwhere = encode(sqlwhere);
				_fieldcheck = stag + sqlwhere+etag;
			}
		}
		return _fieldcheck;
	}
    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
					 if(document.getElementById('input_'+inputname)!=null)
					 document.getElementById('input_'+inputname).value="";
					var param = parserRefParam(inputname,param);
				var idsin = document.all(inputname).value;
				var id;
					try{
					id=window.showModalDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin);
					}catch(e){}
				if (id!=null) {
				if (id[0] != '0') {
					document.all(inputname).value = id[0];
					document.all(inputspan).innerHTML = id[1];
					}else{
					document.all(inputname).value = '';
					if (isneed=='0')
					document.all(inputspan).innerHTML = '';
					else
					document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
</script>
<script type="text/javascript">
WeaverUtil.imports(['/dwr/engine.js','/dwr/util.js','/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '/js/ext/resources/images/default/s.gif';

var topBar=null;
WeaverUtil.load(function(){
	var div=document.createElement("div");
	div.id="pagemenubar";
	Ext.getBody().insertFirst(div);
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onSearch()});//确定
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028")%>','P','print',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	topBar.addSpacer();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025")%>','E','page_excel',Save2Excel);//导出为Excel
	var idx=location.href.indexOf('?');
    if(idx>0)
    document.formExport.action= document.formExport.action+location.href.substring(idx);
});
function Save2Html(){
	document.getElementById('exportType').value="html";
	document.formExport.target="_blank";
	document.formExport.submit();
}
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.formExport.target="_blank";
	document.formExport.submit();
}
function onSearch(){
	if(checkIsNull())
		document.formExport.submit();
}
function checkIsNull()
{
	var year=document.getElementsByName('year');
	if(year[0].value==null||year[0].value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b005e")%>");//年度必须选择!
		return false;
	}
	return true;
}
function printPrv ()
{  
  var location="/app/base/print.jsp?&opType=preview";
	var width=630;
	var height=540;
	var winName='previewRep';
	var winOpt='scrollbars=1';
	 if(width==null || width=='')
    width=400;
  if(height==null || height=='')
    height=200;
  if(winOpt==null)
    winOpt="";
  winOpt="width="+width+",height="+height+(winOpt==""?"":",")+winOpt+", status=1";
  var popWindow=window.open(location,winName,winOpt);
  if(popWindow==null)
  {
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000")%>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
</script>
</head>

<body>
<form action="/app/humres/yearExamineRoport.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#BDEBF7">
<TBODY>
<TR class=title>
<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%><!-- 年度 --></td> 
<TD class=FieldValue width="25%"><BUTTON type="button" class=Browser onclick="javascript:getrefobj('year','yearspan','4028804d21e37e9b0121e715d9dc00e7','','/workflow/request/formbase.jsp?requestid=','0');"></BUTTON> <INPUT type=hidden value="<%=year%>" name=year> <SPAN id="yearspan" name="yearspan"><%=getBrowserDicValue("uf_hrm_examinedate","requestid","EXMYEAR",year)%></SPAN> </TD>
</tr></td></table>
<br>
<div id='repContainer'>
</c:if>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150043")%><!-- 绩效考核总表 --></CENTER></div>
<CENTER>
<table border="1" style="border-collapse:collapse; width:100%" bordercolor="#202020">
	<COLGROUP>
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="10%" />
	<col width="100%" />
	<tr height="40">
	</COLGROUP>	
    <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:20;">
	  <td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150044")%><!-- 被考核人 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150045")%><!-- 考核人 --></b></div></td>	
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150046")%><!-- 考核时间 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150047")%><!-- 考核内容 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150048")%><!-- 所得分数 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150049")%><!-- 得分 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004a")%><!-- 所占权重 --></b></div></td>
		<td colspan=2><div align="center"><b><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004b")%><!-- 考核得分 --></b></div></td>
		<td ><div align="center"><b><%=labelService.getLabelNameByKeyId("402881e70b774c35010b774dffcf000a")%><!-- 备注 --></b></div></td>
   </tr>	
<%
	if(year.length()>0)
	{
		sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3='4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and a.isdelete=0 order by a.objno";
		List mnglist = ds.getValues(sql);
		sql = "select A.ID,A.OBJNAME,B.EXMYEAR,B.EXMYEARHALF,B.SCORE1,B.SCORE2,B.SCORE3,B.SUMSCORE from humres a,uf_hrm_examine b  where a.ID=b.EXMMAN and  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3='4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and b.exmtype=2 and a.isdelete=0 "+where+"  order by a.objno";
		List mngScorelist = ds.getValues(sql);
		StringBuffer cont = new StringBuffer();
		for(int i=0,size=mnglist.size();i<size;i++)
		{
			Map m = (Map)mnglist.get(i);
			String userid = m.get("ID").toString();
			String name = m.get("OBJNAME").toString();
			double score1a = 0;
			double score2a = 0;
			double score3a =0;
			double score1b =0;
			double score2b = 0;
			double score3b = 0;
			double sumscorea = 0;
			double sumscoreb = 0;
			for(int j=0,size1=mngScorelist.size();j<size1;j++)
			{
				Map m1 = (Map)mngScorelist.get(j);
				String exmyearhalf = m1.get("EXMYEARHALF").toString();
				String userid1 = m1.get("ID").toString();
				if(userid.equals(userid1))
				{
					if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004e"))
					{
						score1a=Double.valueOf(m1.get("SCORE1").toString());
						score2a=Double.valueOf(m1.get("SCORE2").toString());
						score3a=Double.valueOf(m1.get("SCORE3").toString());
						sumscorea=Double.valueOf(m1.get("SUMSCORE").toString());
					}
					else if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004f"))
					{
						score1b=Double.valueOf(m1.get("SCORE1").toString());
						score2b=Double.valueOf(m1.get("SCORE2").toString());
						score3b=Double.valueOf(m1.get("SCORE3").toString());
						sumscoreb=Double.valueOf(m1.get("SUMSCORE").toString());
					}
				}
				else
					continue;
			}
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"6\" align=\"center\" >"+name+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004c")+"</td>");//董事长
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50009")+"</td>");//上半年
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td  align=\"center\" >"+score1a+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscorea+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >——</td>");
			cont.append("<td colspan=\"2\" rowspan=\"6\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)/2.0)+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >&nbsp;</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000a")+"</td>");//下半年
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td align=\"center\" >"+score1b+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscoreb+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >——</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3b+"</td>");
			cont.append("</tr>");
		}
		out.println(cont.toString());
	//员工考核
		sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3<>'4028804d2176f8ad01217abb92d600ff' and a.extselectitemfield7 is not null and a.id<>'4028803b21381b8d0121385df3070066' and a.isdelete=0  and (exists (select userid from uf_prj_humseq where userid=a.id) or exists (select distinct creator from uf_prj_taskbrief  where finistate='1' and to_char(to_date(createdate,'yyyy-mm-dd'),'yyyy')='"+exmyear+"' and creator=a.id)) order by a.objno";
		mnglist = ds.getValues(sql);
		sql = "select A.ID,A.OBJNAME,a.objno,B.EXMYEAR,B.EXMYEARHALF,round(sum(B.SCORE1)/count(a.id)) SCORE1,round(sum(B.SCORE2)/count(a.id)) SCORE2,round(sum(B.SCORE3)/count(a.id)) SCORE3,round(sum(B.SUMSCORE)/count(a.id)) SUMSCORE from humres a,uf_hrm_examine b  where a.ID=b.EXMMAN and  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3<>'4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and nvl(b.exmtype,1)=1 and a.isdelete=0 and (exists (select userid from uf_prj_humseq where userid=a.id) or exists (select distinct creator from uf_prj_taskbrief  where finistate='1' and to_char(to_date(createdate,'yyyy-mm-dd'),'yyyy')='"+exmyear+"' and creator=a.id))  "+where+"  group by A.ID,A.OBJNAME,B.EXMYEAR,B.EXMYEARHALF,a.objno order by a.objno";
		mngScorelist = ds.getValues(sql);
		//exists (select userid from uf_prj_humseq where userid=a.id)
		//and not exists (select distinct creator from uf_prj_taskbrief  where finistate='1' and to_char(to_date(createdate,'yyyy-mm-dd'),'yyyy')='"+exmyear+"' and creator=a.id)
		sql = "select nvl(round(sum(a.score)*10/count(a.id)),0) score,a.creator from uf_prj_taskbrief a where a.finistate='1' and to_char(to_date(a.createdate,'yyyy-mm-dd'),'yyyy')='"+exmyear+"' group by a.creator";
		List mngPrjlist = ds.getValues(sql);
		cont = new StringBuffer();
		double sumscoreall=0.0;
		int sumsize=mngPrjlist.size();
		String userids="";
		for(int i=0,size=mnglist.size();i<size;i++)
		{
			Map m = (Map)mnglist.get(i);
			String userid = m.get("ID").toString();
			userids=userids+"'"+userid+"',";
			String name = m.get("OBJNAME").toString();
			double score1a = 0;
			double score2a = 0;
			double score3a =0;
			double score1b =0;
			double score2b = 0;
			double score3b = 0;
			double sumscorea = 0;
			double sumscoreb = 0;
			double sumscorec = 0;
			for(int j=0,size1=mngScorelist.size();j<size1;j++)
			{

				Map m1 = (Map)mngScorelist.get(j);
				String exmyearhalf = m1.get("EXMYEARHALF").toString();
				String userid1 = m1.get("ID").toString();
				if(userid.equals(userid1))
				{
					if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004e"))
					{
						score1a=Double.valueOf(m1.get("SCORE1").toString());
						score2a=Double.valueOf(m1.get("SCORE2").toString());
						score3a=Double.valueOf(m1.get("SCORE3").toString());
						sumscorea=Double.valueOf(m1.get("SUMSCORE").toString());
					}
					else if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004f"))
					{
						score1b=Double.valueOf(m1.get("SCORE1").toString());
						score2b=Double.valueOf(m1.get("SCORE2").toString());
						score3b=Double.valueOf(m1.get("SCORE3").toString());
						sumscoreb=Double.valueOf(m1.get("SUMSCORE").toString());
					}
				}
				else
					continue;
			}
			for(int k=0,size2=mngPrjlist.size();k<size2;k++)
			{
				Map m1 = (Map)mngPrjlist.get(k);
				String userid1 = m1.get("creator").toString();
				if(userid.equals(userid1))
				{
						sumscorec=Double.valueOf(m1.get("score").toString());
				}
				else
					continue;
			}
			sumscoreall+=sumscorec;
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"7\" align=\"center\" >"+name+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50005")+"</td>");//高管
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50009")+"</td>");//上半年
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td  align=\"center\" >"+score1a+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscorea+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >20%</td>");
			cont.append("<td colspan=\"1\" rowspan=\"6\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)/2.0)+"</td>");
			cont.append("<td colspan=\"1\" rowspan=\"7\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)*0.2/2.0+sumscorec*0.8)+"</td>");
			cont.append("<td rowspan=\"7\" align=\"center\" >&nbsp;</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000a")+"</td>");//下半年
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td align=\"center\" >"+score1b+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscoreb+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150050")+"</td>");//分管高管
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150051")+"</td>");//项目完成后
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150052")+"</td>");//项目考核
			cont.append("<td align=\"center\" >"+sumscorec+"</td>");
			cont.append("<td  align=\"center\" >"+sumscorec+"</td>");
			cont.append("<td align=\"center\" >80%</td>");
			cont.append("<td  align=\"center\" >"+sumscorec+"</td>");
			cont.append("</tr>");
			
		}
		userids="("+userids+"'1')";
		out.println(cont.toString());
		double avgsumcore = Math.round(sumscoreall/(sumsize*1.0));
		//非项目员工考核
		sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3<>'4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and a.extselectitemfield7  is not null and a.isdelete=0  and a.id not in "+userids+" order by a.objno";
		mnglist = ds.getValues(sql);
		sql = "select A.ID,A.OBJNAME,a.objno,B.EXMYEAR,B.EXMYEARHALF,round(sum(B.SCORE1)/count(a.id)) SCORE1,round(sum(B.SCORE2)/count(a.id)) SCORE2,round(sum(B.SCORE3)/count(a.id)) SCORE3,round(sum(B.SUMSCORE)/count(a.id)) SUMSCORE from humres a,uf_hrm_examine b  where a.ID=b.EXMMAN and  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3<>'4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and nvl(b.exmtype,1)=1 and a.isdelete=0 and a.extselectitemfield7 is not null and not exists (select distinct creator from uf_prj_taskbrief  where finistate='1' and to_char(to_date(createdate,'yyyy-mm-dd'),'yyyy')='"+exmyear+"' and creator=a.id) "+where+"  group by A.ID,A.OBJNAME,B.EXMYEAR,B.EXMYEARHALF,a.objno order by a.objno";
		mngScorelist = ds.getValues(sql);
		cont = new StringBuffer();
		for(int i=0,size=mnglist.size();i<size;i++)
		{
			Map m = (Map)mnglist.get(i);
			String userid = m.get("ID").toString();
			String name = m.get("OBJNAME").toString();
			double score1a = 0;
			double score2a = 0;
			double score3a =0;
			double score1b =0;
			double score2b = 0;
			double score3b = 0;
			double sumscorea = 0;
			double sumscoreb = 0;
			double sumscorec=avgsumcore;
			for(int j=0,size1=mngScorelist.size();j<size1;j++)
			{
				Map m1 = (Map)mngScorelist.get(j);
				String exmyearhalf = m1.get("EXMYEARHALF").toString();
				String userid1 = m1.get("ID").toString();
				if(userid.equals(userid1))
				{
					if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004e"))
					{
						score1a=Double.valueOf(m1.get("SCORE1").toString());
						score2a=Double.valueOf(m1.get("SCORE2").toString());
						score3a=Double.valueOf(m1.get("SCORE3").toString());
						sumscorea=Double.valueOf(m1.get("SUMSCORE").toString());
					}
					else if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004f"))
					{
						score1b=Double.valueOf(m1.get("SCORE1").toString());
						score2b=Double.valueOf(m1.get("SCORE2").toString());
						score3b=Double.valueOf(m1.get("SCORE3").toString());
						sumscoreb=Double.valueOf(m1.get("SUMSCORE").toString());
					}
				}
				else
					continue;
			}
					cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"7\" align=\"center\" >"+name+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50005")+"</td>");//高管
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50009")+"</td>");//上半年
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td  align=\"center\" >"+score1a+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscorea+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >20%</td>");
			cont.append("<td colspan=\"1\" rowspan=\"6\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)/2.0)+"</td>");
			cont.append("<td colspan=\"1\" rowspan=\"7\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)*0.2/2.0+sumscorec*0.8)+"</td>");
			cont.append("<td rowspan=\"7\" align=\"center\" >&nbsp;</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000a")+"</td>");//下半年
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004d")+"</td>");//工作态度
			cont.append("<td align=\"center\" >"+score1b+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscoreb+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004e")+"</td>");//工作能力
			cont.append("<td align=\"center\" >"+score2b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e15004f")+"</td>");//工作成绩
			cont.append("<td align=\"center\" >"+score3b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150050")+"</td>");//分管高管
			cont.append("<td  align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150051")+"</td>");//项目完成后
			cont.append("<td align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85e150052")+"</td>");//项目考核
			cont.append("<td align=\"center\" >"+sumscorec+"</td>");
			cont.append("<td  align=\"center\" >"+sumscorec+"</td>");
			cont.append("<td align=\"center\" >80%</td>");
			cont.append("<td  align=\"center\" >"+sumscorec+"</td>");
			cont.append("</tr>");
			
			/*cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"6\" align=\"center\" >"+name+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >高管</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >上半年</td>");
			cont.append("<td  align=\"center\" >工作态度</td>");
			cont.append("<td  align=\"center\" >"+score1a+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscorea+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >-</td>");
			cont.append("<td colspan=\"1\" rowspan=\"6\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)/2.0)+"</td>");
			cont.append("<td colspan=\"1\" rowspan=\"6\" align=\"center\" >"+Math.round((sumscorea+sumscoreb)/2.0)+"</td>");
			cont.append("<td rowspan=\"6\" align=\"center\" >&nbsp;</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >工作能力</td>");
			cont.append("<td align=\"center\" >"+score2a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >工作成绩</td>");
			cont.append("<td align=\"center\" >"+score3a+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td rowspan=\"3\" align=\"center\" >下半年</td>");
			cont.append("<td align=\"center\" >工作态度</td>");
			cont.append("<td align=\"center\" >"+score1b+"</td>");
			cont.append("<td rowspan=\"3\" align=\"center\" >"+sumscoreb+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >工作能力</td>");
			cont.append("<td align=\"center\" >"+score2b+"</td>");
			cont.append("</tr>");
			cont.append("<tr height=\"22\">");
			cont.append("<td align=\"center\" >工作成绩</td>");
			cont.append("<td align=\"center\" >"+score3b+"</td>");
			cont.append("</tr>");*/

		}
		out.println(cont.toString());

	}

%>

</table>
<c:if test="${!isExcel}">
</div>
</form>

</body>
</html>
</c:if>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                