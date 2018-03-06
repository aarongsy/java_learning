<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%
EweaverUser eweaveruser1 = BaseContext.getRemoteUser();
Calendar cal = Calendar.getInstance(); 
int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH)+1;
//month=month-1;
if(month<1)
{
	month=12;
	year=year-1;
}
String pyear = request.getParameter("pyear");
String yf="";
if(month<10)
	yf="0"+month;
if(pyear==null)pyear=String.valueOf(year);
String thismonth=pyear+"-"+yf;
String lastmonth=pyear+"-"+yf;
if(month<2)
{
	lastmonth=(year-1)+"-12";
}
else
{
	lastmonth=year+"-"+((month-1<10)?"0"+(month-1):(month-1));
}


String where="";
where = where +" and ((to_char(to_date(c.implementdate,'yyyy-mm-dd'),'yyyy')='"+pyear+"' and c.state in ('2c91a0302a8cef72012a8eabe0e803f2','2c91a0302a8cef72012a8eabe0e803f3')) or c.state in ('2c91a0302a8cef72012a8eabe0e803f1','2c91a0302ab11213012ab12bf0f00022','2c91a0302a8cef72012a8eabe0e803f0') )";
String action=StringHelper.null2String(request.getParameter("action"));
//String where=" and c.zxr='"+execman+"'";
String tempstr="";
String userid=eweaveruser1.getId();
BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");



if(request.getMethod().equalsIgnoreCase("post") && action.equalsIgnoreCase("search")){
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="data"+DateHelper.getCurrentDate()+".xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<c:if test="${!isExcel}">
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0002") %><!-- 调试机组进度处理 --></title>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
  <script src='/dwr/engine.js'></script>
  <script src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" defer="defer"></script>
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
var win;
Ext.onReady(function(){

var div=document.getElementById("pagemenubar");
	topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %>','S','accept',function(){onSearch()});//确定
	topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'显示全部','A','accept',function(){showAll()});
	//topBar.addSpacer();
	//topBar.addSpacer();
	//topBar.addSeparator();
	//addBtn(topBar,'保存为HTML','H','html_go',Save2Html);
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025") %>','E','page_excel',Save2Excel);//导出为Excel
	/*topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'导出全部','M','page_excel',exportAll);*/
	var idx=location.href.indexOf('?');
	var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'seachdiv',
	split:true,
	region:'north',         
		autoScroll:true,
		height:60,
		collapseMode:'mini'
	},{
		contentEl:'repContainer',
		autoScroll:true,
		region:'center'
	}]
  });




	
  });
function Save2Excel(){
	document.getElementById('exportType').value="excel";
	//document.forms[0].target="_blank";
	document.forms[0].submit();
}
function onSearch(){
	document.getElementById('exportType').value="";
	if(checkIsNull())
		document.forms[0].submit();
}
function checkIsNull()
{
	return true;
}
function printPrv ()
{  
  var location="/app/base/print.jsp?&opType=preview&portrait=false";
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
    alert('<%=labelService.getLabelNameByKeyId("402883d934c1392c0134c1392c930000") %>');//您的浏览器可能禁止弹出窗口，无法正常运行程序!
    return;
  }  
  popWindow.focus();  
  popWindow.moveTo(0,0);
  
}


function finish(processid){
		win= new Ext.Window({//创建弹出岗位的window容器
			maskDisabled:false,
			id:'tree-advancedTree01-win',
			modal : true,//是否为模式窗口
			constrain:true,//窗口只能在viewport指定的范围
			closable:true,//窗口是否可以关闭
			closeAction:'hide',
			//autoDestroy:true,
			layout:'fit',
			width:350,
			height:200,
			plain:true,
			items:[
				{
					id:'tree-advancedTree01-win-view',
					border:false
				}
			]
		});
		var viewPanel = Ext.getCmp('tree-advancedTree01-win-view');
		win.setTitle("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0003") %>");//阶段进度处理
		var dataObj = {
			processid: processid
		}
		win.show();
		var tmpTpl = new Ext.Template([
			'<div style="margin:5px"><center><br><table style="width:400px"><td class="fieldName"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005a") %>：</td><td class="value">&nbsp;&nbsp;<input type="text" value="<%=DateHelper.getCurrentDate()%>"  onclick="WdatePicker()" readOnly name="finishdate" size="20"> <input type="hidden" name="processid" value="{processid}"></td></tr>',//完成日期
			'<tr><td colspan=2 align=center><button type="button" onclick="javascript:finishAction();"><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %></button></td></tr></table></center></div>'  
		]);
		tmpTpl.overwrite(viewPanel.body, dataObj);
	}
	
	function finishAction()
	{
		var processid=document.getElementById('processid').value;
		var finishdate=document.getElementById('finishdate').value;
		if(finishdate.length<1){
			alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0004") %>");//完成日期不能为空！
			return;
		}
		Ext.Ajax.request({
				url: '/app/ft/progressAction.jsp?action=finish',
				method:'post',
				params:{processid:processid,finishdate:finishdate},
				success: function(response, option) {
					var result = response.responseText;
					if(result.indexOf("ok")==0)
					{
						var inn=finishdate+"(<a href=\"javascript:finishcancel('"+processid+"')\"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0005") %></a>)";//取消完成
						var spanobj=document.getElementById(processid+'span');
						spanobj.innerHTML=inn;
						win.destroy();
					}
					else
					{
						alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0006") %>");//操作失败，请检查是否登录超时或网络连接是否正常！
						return;
					}
				},
				failure: function(response, option) {
					nodeEdited.setText(oldValue);//如果失败则将改过的节点恢复原状
					alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0007") %>");//数据库操作失败，请检查网络连接是否正常！
				}
			});
	
	}
	function finishcancel(processid)
	{
		Ext.Ajax.request({
				url: '/app/ft/progressAction.jsp?action=finishcancel',
				method:'post',
				params:{processid:processid},
				success: function(response, option) {
					var result = response.responseText;
					if(result.indexOf("ok")==0)
					{
						var inn="<a href=\"javascript:finish('"+processid+"');\"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0008") %></a>";//未完成
						var spanobj=document.getElementById(processid+'span');
						spanobj.innerHTML=inn;
					}
					else
					{
						alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0006") %>");//操作失败，请检查是否登录超时或网络连接是否正常！
						return;
					}
				},
				failure: function(response, option) {
					nodeEdited.setText(oldValue);//如果失败则将改过的节点恢复原状
					alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0007") %>");//数据库操作失败，请检查网络连接是否正常！
				}
			});
	
	}
</script>
</head>

<body>

<div id='seachdiv'>
<div id="pagemenubar"></div>
<form action="" name="formExport" method="post">
<input type="hidden" name="action" value="search"/>
<input type="hidden" name="exportType" id="exportType" value=""/>
<TABLE id=myTable width="100%" bgcolor="#E7E9EB">
<TBODY>
<TR class=title>
		<TD class=FieldName noWrap width="10%"><%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b6f0001") %><!-- 年度 --> </td>
		<td class="FieldValue" nowrap="true">
		<span><select name="pyear" id="pyear" style="width:80">
		<%
		for(int i=year-2;i<year+1;i++)
		{
			if(i==Integer.parseInt(pyear))
				out.println("<option value='"+i+"' selected>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
			else 
				out.println("<option value='"+i+"'>"+i+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")+"</option>");//年
		}

		%>
		</select>
		</span>
		</td>
</tr>
</table>
</div>
<div id='repContainer'>
</c:if><BR>

<%
String sql="select c.requestid,c.no,c.name,c.money,c.predictdate,c.implementdate,a.finish1,c.finishdate,A.id,A.REQUESTID REQUESTIDa,A.OBJNAME,A.PRODUCEQTY from edo_task a,uf_contract c where a.model='2c91a84e2aa7236b012aa737d8930005' and a.MASTERTYPE='2c91a0302acabc4e012acac827220002' and a.projectid=c.requestid  "+where+" order by c.no,a.outlinelevel,a.outlinenumber";
List jzlist= baseJdbc.executeSqlForList(sql);

sql="select id,objname from selectitem a where  nvl(a.col1,0)=0  and typeid='2c91a0302aa6def0012aad4792cf0838' order by dsporder";
List jzjzlist= baseJdbc.executeSqlForList(sql);
StringBuffer bufhd = new StringBuffer();
StringBuffer bufhd1 = new StringBuffer();
%>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=pyear%>&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d") %><!-- 年 -->&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0002") %><!-- 调试机组进度处理 --></CENTER></div> 
<div align=left width="50%"></div><div align=right width="50%"></div> 
<table cellspacing="0" cellpadding="0" border="1" style="border-collapse:collapse;width:100%" bordercolor="#333333" id="mainTable">
	
   <tr style="background:#E0ECFC;border:1px solid #c3daf9;height:25;">
			<td colspan="1" rowspan="1" align="center" width="8%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005b") %><!-- 合同编号 --></td>
			<td colspan="1" align="center" rowspan="1"  width="15%"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f005c") %><!-- 合同名称 --></td>
			<td colspan="1" align="center" rowspan="1" width="15%"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0009") %><!-- 机组编号 --></td>
			<%
			int sizek=jzjzlist.size();
			for(int k=0;k<sizek;k++)
			{
				Map m = (Map)jzjzlist.get(k);
				String objname=StringHelper.null2String(m.get("objname"));
				bufhd.append("<td align=\"center\"  width=\""+(60/sizek)+"%\">"+objname+"</td>");
			}
			out.println(bufhd.toString());
			%>
  </tr>
<tbody>
<%
	String color1="#D5F9F9";
	String color2="#F8D3FC";
	String color3="#FBF5B0";
	StringBuffer buf1 = new StringBuffer();
	String contractno2="";
	int size=jzlist.size();
	for(int i=0;i<size;i++)
	{
		Map m = (Map)jzlist.get(i);
		String id=StringHelper.null2String(m.get("id"));
		String requestid=StringHelper.null2String(m.get("requestid"));
		String contractno=StringHelper.null2String(m.get("no"));		
		String name=StringHelper.null2String(m.get("name"));
		String produceqty =StringHelper.null2String(m.get("produceqty"));
		String finish1=StringHelper.null2String(m.get("finish1"));
		String remark=StringHelper.null2String(m.get("remark"));
		String money=StringHelper.null2String(m.get("money"));
		String implementdate=StringHelper.null2String(m.get("implementdate"));
		String predictdate=StringHelper.null2String(m.get("predictdate"));
		String mtstate=StringHelper.null2String(m.get("status"));
		String requestida=StringHelper.null2String(m.get("REQUESTIDa"));
				//识别任务
		List jdlist= baseJdbc.executeSqlForList("select a.id,a.objname,nvl(b.process,a.objdesc) process,b.taskid,b.requestid,nvl(b.dsporder,a.dsporder) dsporder,b.jztaskid,b.remark,to_char(to_date(b.plandate,'yyyy-mm-dd'),'yyyy-mm') planmonth,to_char(to_date(b.finishdate,'yyyy-mm-dd'),'yyyy-mm') finishmonth,finishdate,nvl(b.STATUS,-1) status,nvl(b.calctype,1) calctype  from selectitem a,(select e.requestid,e.dsporder,e.contractno,e.jztaskid,e.taskid,e.process,e.remark,e.processid,e.plandate,e.finishdate,e.STATUS,e.calctype from uf_income_pcprocess e  where   e.jztaskid='"+id+"' ) b where  nvl(a.col1,0)=0 and a.id=b.processid(+) and typeid='2c91a0302aa6def0012aad4792cf0838' order by dsporder");
		String bgcolor="";
			buf1.append("<tr style=\"height:25;\" "+bgcolor+" >");
		if(!contractno2.equals(requestid))
		{
			contractno2=requestid;
			int rownum = 0;
			int addrownum=1;
			for(int k=i+1;k<size;k++)
			{
				Map m2 = (Map)jzlist.get(k);
				String contractno3=StringHelper.null2String(m2.get("requestid"));
				if(contractno3.equals(contractno2))
				{
					rownum=rownum+1;
				}
				else
					break;
			}
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+contractno+"</td>");
			buf1.append("<td align=\"center\" rowspan="+(rownum+addrownum)+">"+name+"</td>");
		}
		buf1.append("<td align=\"center\" >"+getBrowserDicValue("edo_task","requestid","objname",requestida)+"</td>");
		for(int j=0,sizej=jdlist.size();j<sizej;j++)
		{
			Map prm = (Map)jdlist.get(j);
			String ida=StringHelper.null2String(prm.get("id"));
			String processid=StringHelper.null2String(prm.get("requestid"));
			
			String objnamea=StringHelper.null2String(prm.get("objname"));
			String dspordera=StringHelper.null2String(prm.get("dsporder"));
			String taskida=StringHelper.null2String(prm.get("taskid"));
			String jztaskida=StringHelper.null2String(prm.get("jztaskid"));
			String finisha=StringHelper.null2String(prm.get("FINISH1"));
			String statusa=StringHelper.null2String(prm.get("STATUS"));
			String planmontha=StringHelper.null2String(prm.get("planmonth"));
			String finishmontha=StringHelper.null2String(prm.get("finishmonth"));
			String process=StringHelper.null2String(prm.get("process"));
			String finishdate=StringHelper.null2String(prm.get("finishdate"));
			String calctype=StringHelper.null2String(prm.get("calctype"));
			String bgcolor1="";
			String url="";
			String title="";
			if(statusa.equals("-1"))
			{
			
				title=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000a");//未设置
				bgcolor1="#ffffbb";
			}
			else if(statusa.equals("0"))
			{
				bgcolor1="#e1fac0";
				if(calctype.equals("0"))
					title=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0008");//未完成
				else{
					url="javascript:finish('"+processid+"')";
					title="<span id="+processid+"span><a href=\""+url+"\">"+labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb392f0008")+"</a></span>";//未完成
				}
			}
			else if(statusa.equals("1"))
			{
				if((finishdate.startsWith(thismonth)||finishdate.startsWith(lastmonth))&&calctype.equals("1"))
				{
					url="javascript:finishcancel('"+processid+"')";
					title="<span id="+processid+"span>"+finishdate+"(<a href=\""+url+"\">取消完成</a>)</span>";
					bgcolor1="#b0e1ce";
				}
				else
				{
					title=finishdate+"(<font color=\"red\">已完成</font>)";
					bgcolor1="#b0e1ce";
				}
			}
			buf1.append("<td align=center style=\"background-color:"+bgcolor1+"\">"+title+"</td>");
		}
		buf1.append("</tr>");	
	}
out.println(buf1.toString());

%>
</tbody>
</table>
<ul style="color:red"><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e") %><!-- 说明 -->：
<li style="color:red">&nbsp;&nbsp;&nbsp;&nbsp;</span><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000b") %><!-- 阶段状态未设置，表示该机组进度计算设置有误！ --></li><br>
<li style="color:red">&nbsp;&nbsp;&nbsp;&nbsp;</span><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000c") %></li><br><!-- 在机组阶段设置中，仅手工完成阶段在此处理！ -->			
<li style="color:red">&nbsp;&nbsp;&nbsp;&nbsp;</span><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3930000d") %><!-- 当月可以取消完成本月及上月手工完成的阶段! --> </li>
</ul>
</form>
</div>
<c:if test="${!isExcel}">

</body>
</html>
</c:if>
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
