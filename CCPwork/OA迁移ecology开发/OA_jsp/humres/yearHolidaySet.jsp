<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ include file="/base/init.jsp"%>
<%
String currdate=StringHelper.null2String(request.getParameter("currdate"));
if(currdate==null||currdate.length()<1)currdate=DateHelper.getCurrentDate();
DataService ds = new DataService();
%>

<html>
  <head>
<style>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #A5ACB2;
	border-right-color: #A5ACB2;
	border-bottom-color: #A5ACB2;
	border-left-color: #A5ACB2;
}
</style>

<link rel="stylesheet" type="text/css" href="/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
  </head>
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
	addBtn(topBar,'<%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")%>','S','accept',function(){onSubmit()});//保存
	topBar.addSpacer();
	topBar.addSpacer();
	topBar.addFill();
});
	</script>
  <body>
<%
	titlename=labelService.getLabelNameByKeyId("402883d934c0917e0134c0917ec30000");//运输车位置登记
%> 
<!--页面菜单结束-->

<%
String yearcnd=request.getParameter("yearcnd");
String orgidcnd=request.getParameter("orgidcnd");
String rootid=request.getParameter("rootid");

String sql1="select a.objno,a.id,a.objname,a.orgid from  humres a where  a.orgids like '%"+orgidcnd+"%' and isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935' ";
List ls1= ds.getValues(sql1+" order by a.objno");
String sql ="select b.requestid,b.objid,b.hlds from  uf_attendance_yuserhlds b where  b.hyear="+yearcnd+" and b.objid in (select a.id from  humres a where  a.orgids like '%"+orgidcnd+"%' and isdelete=0 and hrstatus='4028804c16acfbc00116ccba13802935')";
List ls2= ds.getValues(sql);
%>
	<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.humres.AttendanceAction?action=save" name="EweaverForm" method="post">
		 <input type="hidden" name="searchName" value="">
		 <input type="hidden" name="delids">
		 <input type="hidden" name="ids">
		 <input type="hidden" name="yearcnd" value="<%=yearcnd%>">
		 <input type="hidden" name="orgidcnd" value="<%=orgidcnd%>">
		<table cellspacing=0 cellpadding=0 border=1 style="border-bottom:1px #ACA8A6 solid;border-collapse:collapse;layout:fixed;width:500">
		<COLGROUP>
			<COL width="30">
			<COL width="60">
			<COL width="150">
			<COL width="100">
			<COL width="100">
      </COLGROUP>
			<tbody>
			<tr class=Header>
				<td style="text-align:center"><input type="checkbox" value="" onclick="javascript:checkAll(this,'check_node');"></td>
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c095220134c09523720000")%><!-- 序号 --></td>
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%><!-- 部门 --></td>
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%><!-- 姓名 --></td>
				<td style="text-align:center"><%=labelService.getLabelNameByKeyId("402883d934c098950134c098966d0000")%><!-- 年假天数 --></td>

			</tr>
     <%
       
         for (int i=0;i<ls1.size();i++){
				String bgcolor=(i%2==1)?"style=\"background-color:#EBEBEB\"":"";
				Map m = (Map)ls1.get(i);
				String id=m.get("id").toString();
				String objname=m.get("objname").toString();
				String orgid=m.get("orgid").toString();
				String hlds="0.0";
				String requestid="";
				for(int j=0,size=ls2.size();j<size;j++)
				{
					Map m1 = (Map)ls2.get(j);
					if(m1.get("objid").toString().equals(id))
					{
						hlds=StringHelper.null2String(m1.get("hlds"));
						requestid=StringHelper.null2String(m1.get("requestid"));
						break;
					}
				}
     %>		
	           <tr class=DataLight >
				<td align=center <%=bgcolor%>>					    
				<input  type='checkbox'  name='check_node' value='<%=requestid%>'>	
				<input type="hidden" name="id" value="<%=requestid%>" />
				<input type="hidden" name="objid" value="<%=id%>" />
				</td>
				<td align=center <%=bgcolor%>>
				<%=(i+1)%>
				</td>
				<td align=center <%=bgcolor%>>
				<input style="width:95%" class=inputstyle type="hidden" name="orgid"  value="orgid%>"/>
				<%=getBrowserDicValue("orgunit","id","objname",orgid)%>
				</td>
				<td align=center <%=bgcolor%>>
				<%=objname%>
				</td>
				<td align=center <%=bgcolor%>>
				<input style="width:95%;height:20" class=inputstyle type="text" name="hlds"  value="<%=hlds%>"/
				</td>
		  </tr>  			
		<%}
		%>	
	  </tbody>
      </table>
    </form>  
  </body>
  
</html>


<script language="JavaScript" src="<%= request.getContextPath()%>/js/addRowBg.js" >
</script>  
<script language="javascript">  
var rowColor="" ;
function copy()
{
	var  check_node= document.getElementsByName("check_node");
	var i=0;
	var toplace1 = document.getElementsByName("toplace1");
	var num1 = document.getElementsByName("nums1");
	var types1 = document.getElementsByName("types1");
	var toplace2 = document.getElementsByName("toplace");
	var num2 = document.getElementsByName("nums");
	var types2 = document.getElementsByName("types");
	for(i=0,len=check_node.length; i <len;i++) {
			if(check_node[i].checked==true) {
				toplace2[i].value=toplace1[i].value;	
				num2[i].value=num1[i].value;
				if(types1[i].value==null||types1[i].value=='')types2[i].options[0].selected=true;
					else
						types2[i].value=types1[i].value;	
			}
	}	
}

function getData()
{
	var  check_node= document.getElementsByName("check_node");
	var i=0;
	var toplace2 = document.getElementsByName("toplace");
	var num2 = document.getElementsByName("nums");
	var types2 = document.getElementsByName("types");
	for(i=0,len=check_node.length; i <len;i++) {
			if(check_node[i].checked==true) {
				getDataDo(check_node[i].value,i,toplace2,num2,types2);
			}
	}
}
function getDataDo(id,idx,toplace2,num2,types2){         
var sql='select T.SUMS,T.STARTTIME,T.ARRIVALTIME,T.TYPES,(SELECT ROTUE FROM UF_MILEAGE_ROUTE WHERE REQUESTID=T.CARLINE) CARLINE,T.CONVERYANCE,T.DISPATCHSTATUS from uf_dispatch_main t where t.Starttime>=\'<%=currdate%>\' and \'<%=currdate%>\'<=t.arrivaltime and converyance=\''+id+'\' order by Starttime desc';   //alert('sql:'+sql); 
      DataService.getValues(sql,{                                             
          callback: function(data){                     
              if(data && data.length>0){
				  var sums=data[0].SUMS;
				  var types=data[0].TYPES;              
				  var dispatchstatus=data[0].DISPATCHSTATUS; 
				  
				  if(dispatchstatus!=null||dispatchstatus=='ff80808127959e8f012795d317740007')
				  {
					  toplace="<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150054")%>";//在途
				  }
				  else
				  {
					  toplace=data[0].CARLINE;
				  }
				if(sums!=null)
					num2[idx].value=sums;
				if(types==null||types=='')types2[idx].options[0].selected=true;
				else
				types2[idx].value=types;	
				toplace2[i].value=toplace;            
                                    
              } 
			  else
			  {
				  toplace2[idx].value="<%=labelService.getLabelNameByKeyId("402883de352db85b01352db85e150055")%>";//未知 
			  }
          }               
      });             
 }  
function delRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {

		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				var did = document.forms[0].elements[i].value;
				document.all("delids").value =document.all("delids").value +",'"+did+"'";
			    vTable.deleteRow(rowsum1-1);					
			}
			rowsum1 -=1;
		}
	}	
	onSubmit();
}
function isTrue()
{
	len = document.forms[0].elements.length;
    var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node2')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {

		if (document.forms[0].elements[i].name=='check_node2'){
			if(document.forms[0].elements[i].checked==true) {
				var did = document.forms[0].elements[i].value;
				document.all("ids").value =document.all("ids").value +",'"+did+"'";					
			}
			rowsum1 -=1;
		}
	}	
}

function onSubmit(){
 //isTrue();
 EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.customaction.humres.AttendanceAction?action=save";
 document.EweaverForm.submit();
}
function onSearch(){
	EweaverForm.action="<%= request.getContextPath()%>/app/humres/yearHolidaySet.jsp";
	EweaverForm.submit();
}

function openimage(){
 var returnvalue = new String(window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp?","Width=110,Height=100"));
}
function BrowserImages(obj){
	var ret=window.showModalDialog("<%= request.getContextPath()%>/base/menu/imagesBrowser.jsp");
   obj.parentNode.firstChild.value=ret;
    if(obj.parentNode.childNodes[1].tagName=='IMG')
    obj.parentNode.childNodes[1].src=ret
    if(obj.parentNode.childNodes[2].tagName=='IMG')
    obj.parentNode.childNodes[2].src=ret
}
function checkAll(obj,checkboxname)
{
	var checkboxs = document.getElementsByName(checkboxname);
	if(checkboxs!=null&&checkboxs.length>0)
	{
		var checkflag=obj.checked;
		for(var i=0,len=checkboxs.length;i<len;i++)
		{
			checkboxs[i].checked=checkflag;
		}
	}
}
</script>
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
	
%>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>