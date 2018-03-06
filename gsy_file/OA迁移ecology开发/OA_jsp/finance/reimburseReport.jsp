<%@ page contentType="text/html; charset=UTF-8"%>
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
DataService ds = new DataService();
Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);
String nf = request.getParameter("nf");
String yf = request.getParameter("yf");
if(yf==null)yf="";
String bm = request.getParameter("bm");
String yg = request.getParameter("yg");
String kmmc = request.getParameter("kmmc");
String isbx = request.getParameter("isbx");
if(nf==null)nf="";
if(yg==null)yg="";
if(bm==null)bm="";
if(kmmc==null)kmmc="";
if(isbx==null)
	isbx="40288098276fc2120127704884290210";
if(nf==null)nf=String.valueOf(currentyear);
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
   	sqlbf.append("select sum(url.actualfee) fyze,url.budget from uf_reimburse_list url ,uf_reimburse ur where url.requestid=ur.requestid and ur.reqDate like '"+sdstr+"%' and exists(select id from requestbase where id=ur.requestid and isdelete=0 and isfinished=1)");
    if(bm!=null&&bm.length()>0){
       sqlbf.append(" and ur.reqDept='"+bm+"'");
    }
     if(yg!=null&&yg.length()>0){
       sqlbf.append("  and ur.reqMan='"+yg+"'");
    }
     if(kmmc!=null&&kmmc.length()>0){
		 where+=" and ua.requestid = '"+StringHelper.filterSqlChar(kmmc)+"'";
    }
	if(isbx!=null&&isbx.length()>0){
		 where+=" and ua.isRusment ='"+isbx+"'";
    }
	sqlbf.append(" GROUP BY budget");
    String sqlstr=sqlbf.toString();
	//科目相关信息
	 String sql="select ua.requestid,objlevel,objname,objnumber,(select objname from selectitem where id=ua.isRusment) sfbx from uf_amountstyle ua  where 1=1 "+where+" order by ua.objnumber";
     List  kmList = ds.getValues(sql);
     List  bxList = ds.getValues(sqlstr.toString());
	String excel=StringHelper.null2String(request.getParameter("exportType"));
	boolean isExcel=excel.equalsIgnoreCase("excel");
	if(request.getMethod().equalsIgnoreCase("post")){
	pageContext.setAttribute("isExcel",isExcel);
	if(isExcel){//导出Ｅｘｃｅｌ
		String fname="费用报销统计表.xls";
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("content-type","application/vnd.ms-excel");
		response.addHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fname,"utf-8"));
	}
}
%>
<%if(!isExcel){%>
<c:if test="${!isExcel}">
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
</style>
<script type="text/javascript">
Ext.onReady(function(){
	Ext.QuickTips.init();
	var topBar = new Ext.Toolbar();
	topBar.render('pagemenubar');
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0024") %>','S','accept',function(){onSearch()});//快速搜索
	topBar.render('pagemenubar');
	topBar.addSeparator();
	//addBtn(topBar,'清空条件','C','erase',function(){reset()});
	//topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdc91c700028") %>','P','printer',function(){printPrv()});//打印
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addSeparator();
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0025") %>','E','page_excel',Save2Excel);//导出为Excel
	/*var viewport = new Ext.Viewport({
	layout: 'border',
	items: [{
	contentEl:'searchDiv',
	split:true,
	region:'north'
	, autoScroll:true,
		collapseMode:'mini'
	},{
		contentEl:'contentDiv',
		autoScroll:true,
		region:'center'
	}]
  });*/
  });
function onSearch(){
	document.getElementById('exportType').value="";
	document.all('EweaverForm').target='';
	document.all('EweaverForm').submit();
}
function reset(){
   document.all('EweaverForm').reset();
}
function checkIsNull()
{
	var startdate=document.getElementsByName('startdate');
	if(startdate[0].value==null||startdate[0].value=='')
	{
		alert("<%=labelService.getLabelNameByKeyId("402883d934c0338a0134c0338ad60000") %>");//必须填入考勤时间段!
		return false;
	}
	return true;
}

function Save2Excel(){
	document.all('EweaverForm').target='_blank';
	document.getElementById('exportType').value="excel";
	document.all('EweaverForm').submit();
}
function printPrv ()
{  
  var location="/app/base/print.jsp?opType=preview&portrait=true";
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
</script>
<body>
<form id="EweaverForm" name="EweaverForm" action="reimburseReport.jsp" target="" method="post">
 <input type="hidden" name="exportType" id="exportType" value=""/>
<div id="searchDiv" >
<div id="pagemenubar"></div> 
<table cellspacing="1" border="0" align="center" style="width: 99%;" class="Econtent">
<colgroup>
<col width="13%"/>
<col width="20%"/>
<col width="13%"/>
<col width="20%"/>
<col width="13%"/>
<col width="20%"/>
</colgroup>
<tr class="repCnd">
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0026") %><!-- 报销年度 -->：</td>
	<td class="FieldValue" nowrap="true">
		<span><select name="nf" id="nf">
			<%

				for(int i=currentyear-2;i<currentyear+5;i++)
				{
					if(i==currentyear)
						out.println("<option value='"+i+"' selected>"+i+"年</option>");
					else 
						out.println("<option value='"+i+"'>"+i+"年</option>");
				}
	
	    %>
	 </select></span>
		</td>
		<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0027") %><!-- 报销月份 -->：</td>
		<td class="FieldValue" nowrap="true">
		<span>
		  <select name="yf" id="yf">
				<option value="" ></option>
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
	<td class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0022") %><!-- 是否报销科目 -->：</td>
	<td class="FieldValue" nowrap="true">

	<select style="width:120" class="inputstyle2" id="isbx"  name="isbx">
	<option value=""></option>
	<%
	List selectData=ds.getValues("select id,objname from selectitem where typeid='40288098276fc21201277048481a020f'");
	String tempstr=isbx;
	for(int i=0,size=selectData.size();i<size;i++)
	{
		Map m = (Map)selectData.get(i);
		String id=m.get("id").toString();
		if(id.equals(tempstr))
		{
			out.println("<option value=\""+id+"\"  selected>"+m.get("objname").toString()+"</option>");
		}
		else
		{
			out.println("<option value=\""+id+"\">"+m.get("objname").toString()+"</option>");
		}
		
	}
	%>
	</td>
	 </tr>
	 <tr class="repCnd">
	<td  class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0034") %><!-- 报销人 -->: </td>
    <td class="FieldValue" nowrap="true">
     <button  class=Browser type=button onclick="getrefobj('yg','ygspan','402881e70bc70ed1010bc75e0361000f','/humres/base/humresview.jsp?id=','1');"></button>
     <input type="hidden" name="yg" value="<%=yg%>" >
     <span id="ygspan" name="ygspan" ><%=getBrowserDicValue("humres","id","objname",yg)%></span>
     </td> 
    <td  class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0035") %><!-- 报销部门 -->: </td>
    <td class="FieldValue" nowrap="true">
     <button  class=Browser type=button onclick="getrefobj('bm','bmspan','402881e60bfee880010bff17101a000c','/base/orgunit/orgunitview.jsp?id=','0');"></button>
     <input type="hidden" name="bm" value="<%=bm%>" />
     <span id="bmspan" name="bmspan" ><%=getBrowserDicValue("orgunit","id","objname",bm)%></span>
     </td> 
     <td  class="FieldName" nowrap="true"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c0020") %><!-- 科目名称 -->: </td>
    <td class="FieldValue" nowrap="true">
	     <button  class=Browser type=button onclick="getrefobj('kmmc','kmmcspan','4028807327f52fe50127f6418c3e05de','/workflow/request/formbase.jsp?id=','0');"></button>
     <input type="hidden" name="kmmc" value="<%=kmmc%>" />
     <span id="kmmcspan" name="kmmcspan" ><%=getBrowserDicValue("uf_amountstyle","requestid","objname",kmmc)%></span>
    </td>	
</tr>
</table>
</div>
<div id="contentDiv">
 <center>
<div id='repContainer' style="width:95%">
</c:if>  
<%}%>
<div style="font-size:15;font-weight:bold;height:20;" valign='middle'><CENTER><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001c") %>费用报销统计表</CENTER></div>
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
</div>
<%if(!isExcel){%>
<c:if test="${!isExcel}">
 </center>
</form> 


</body>
</html>
 <script type="text/javascript">
  var win;
  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid;
            }
    id=window.showModalDialog(url);
    }catch(e){return}
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
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&idsin='+idsin;
    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
                plain: true,
                modal:true,
                items: {
                    id:'dialog',
                    region:'center',
                    iconCls:'portalIcon',
                    xtype     :'iframepanel',
                    frameConfig: {
                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                        eventsFollowFrameLinks : false
                    },
                    defaultSrc:url,
                    closable:false,
                    autoScroll:true
                }
            });
        }
        win.close=function(){
                    this.hide();
                    win.getComponent('dialog').setSrc('about:blank');
                    callback();
                } ;
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
    }
</script>
</c:if>
<%}%>
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

%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      