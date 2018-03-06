<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50004")%></title><!-- 考核监控报表 -->
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
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%>','S','accept',function(){onSearch()});//确定
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
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
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000")%>');
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}
</script>
</head>
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
<body>
<form action="/app/humres/exmineMonitor.jsp" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#BDEBF7">
<TBODY>
<TR class=title>
<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001")%></td><!-- 年度 --> 
<TD class=FieldValue width="25%"><BUTTON type="button" class=Browser onclick="javascript:getrefobj('year','yearspan','4028804d21e37e9b0121e715d9dc00e7','','/workflow/request/formbase.jsp?requestid=','0');"></BUTTON> <INPUT type=hidden value="<%=year%>" name=year> <SPAN id="yearspan" name="yearspan"><%=getBrowserDicValue("uf_hrm_examinedate","requestid","EXMYEAR",year)%></SPAN> </TD>
</tr></td></table>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50004")%></CENTER></div><!-- 考核监控报表 -->
<CENTER>
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" width="100%">
	<colgroup>
	<col width="10%" />
  <col width="10%" />
  <col width="10%" />
  <col width="10%" />
	<col width="10%" />
	<col width="50%" />
  </colgroup>
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:30;">
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50005")%></td><!-- 高管 -->
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883d934c111b80134c111b9100000")%></td><!-- 期间 -->
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50006")%></td><!-- 应考核员工数 -->
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50007")%></td><!-- 已考核员工数 -->
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50008")%></td><!-- 未考核员工数 -->
	 <td   align="center"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003b")%></td><!-- 详情 -->
  </tr>
<%

if(year.length()>0)
{
		String sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3='4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066' and a.isdelete=0 order by a.objno";
		List mnglist = ds.getValues(sql);

		sql = "select count(A.ID) num,B.EXMYEARHALF,B.MANAGER from humres a,uf_hrm_examine b  where a.ID=b.EXMMAN and  a.hrstatus='4028804c16acfbc00116ccba13802935' and  a.extselectitemfield3<>'4028804d2176f8ad01217abb92d600ff' and a.id<>'4028803b21381b8d0121385df3070066'  and a.isdelete=0 and exists (select userid from uf_prj_humseq where userid=a.id) "+where+"  group by b.MANAGER,B.EXMYEARHALF";
		//and b.exmtype=1
		List checklist = ds.getValues(sql);
		sql = "select userid from uf_prj_humseq ";
		List usersnum = ds.getValues(sql);
		int usernum = usersnum.size();
		StringBuffer cont = new StringBuffer();
		for(int i=0,size=mnglist.size();i<size;i++)
		{
			Map m = (Map)mnglist.get(i);
			String userid = m.get("ID").toString();
			String name = m.get("OBJNAME").toString();
			int checkednum1 = 0;
			int checkednum2 = 0;
			for(int j=0,size1=checklist.size();j<size1;j++)
			{
				Map m1 = (Map)checklist.get(j);
				String exmyearhalf = m1.get("EXMYEARHALF").toString();
				String userid1 = m1.get("MANAGER").toString();
				
				if(userid.equals(userid1))
				{
					if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004e"))
					{
						checkednum1=Integer.parseInt(m1.get("num").toString());
					}
					else if(exmyearhalf.equals("8a80869c21e25a8f0121e2884724004f"))
					{
						checkednum2=Integer.parseInt(m1.get("num").toString());
					}
				}
				else
					continue;
			}
			
			sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935'  and a.isdelete=0 and exists (select userid from uf_prj_humseq where userid=a.id) and not exists(select b.exmman from uf_hrm_examine b where b.EXMMAN=a.ID and b.MANAGER='"+userid+"' and b.EXMYEARHALF='8a80869c21e25a8f0121e2884724004e' "+where+" ) order by a.objno";
			List unchecklist1 = ds.getValues(sql);

			sql = "select A.ID,A.OBJNAME from humres a  where  a.hrstatus='4028804c16acfbc00116ccba13802935'  and a.isdelete=0 and exists (select userid from uf_prj_humseq where userid=a.id) and not exists(select b.exmman from uf_hrm_examine b where b.EXMMAN=a.ID and b.MANAGER='"+userid+"' and b.EXMYEARHALF='8a80869c21e25a8f0121e2884724004f' "+where+" ) order by a.objno";
			List unchecklist2 = ds.getValues(sql);
			
			String uncheckmen1="";
			String uncheckmen2="";
			for(int j=0,size1=unchecklist1.size();j<size1;j++)
			{
				Map m1 = (Map)unchecklist1.get(j);
				uncheckmen1=uncheckmen1+m1.get("OBJNAME").toString()+",";
			}
			for(int j=0,size1=unchecklist2.size();j<size1;j++)
			{
				Map m1 = (Map)unchecklist2.get(j);
				uncheckmen2=uncheckmen2+m1.get("OBJNAME").toString()+",";
			}
				cont.append("<tr style=\"height:22;background:"+((i%2==0)?"#F7FBC4":"#FFFFFF")+"\">");
			cont.append("<td rowspan=\"2\" align=\"center\" >"+name+"</td>");
			cont.append("<td rowspan=\"1\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd50009")+"</td>");//上半年
			cont.append("<td  align=\"center\" >"+usernum+"</td>");
			cont.append("<td  align=\"center\" >"+checkednum1+"</td>");
			cont.append("<td rowspan=\"1\" align=\"center\"  "+(usernum>checkednum1?"style=\"color:red\"":"")+">"+(usernum-checkednum1)+"</td>");
			cont.append("<td rowspan=\"1\" align=\"center\">"+uncheckmen1+"</td>");
			cont.append("</tr>");
			cont.append("<td rowspan=\"1\" align=\"center\" >"+labelService.getLabelNameByKeyId("402883de352db85b01352db85dd5000a")+"</td>");//下半年
			cont.append("<td  align=\"center\" >"+usernum+"</td>");
			cont.append("<td  align=\"center\" >"+checkednum2+"</td>");
			cont.append("<td rowspan=\"1\" align=\"center\"  "+(usernum>checkednum2?"style=\"color:red\"":"")+" >"+(usernum-checkednum2)+"</td>");
			cont.append("<td rowspan=\"1\" align=\"center\" >"+uncheckmen2+"</td>");
			cont.append("</tr>");

		}
		out.println(cont.toString());
}
%>
</table>
</div>
</body>
</html>