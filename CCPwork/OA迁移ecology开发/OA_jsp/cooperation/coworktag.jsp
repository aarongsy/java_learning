<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
DataService ds = new DataService();
pagemenustr ="addBtn(tb,'"+labelService.getLabelName("保存")+"','S','accept',function(){onSave()});";//提交按钮
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>标签管理</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
	<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/interface/SelectitemService.js'></script>
	<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/engine.js'></script>
	<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/dwr/util.js'></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/ajax.js"></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
	<script type='text/javascript' language="javascript" src='<%= request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
	<LINK media=screen href="<%= request.getContextPath()%>/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/tx/jquery.autocomplete.css" />
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
var tb =null;
Ext.onReady(function() {
   Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
   <%}%>
});
function addRow(){
	var table = document.getElementById("table");
	var rowscount = table.rows.length-1;
	var row = table.insertRow();
	row.setAttribute("id","row"+rowscount);
	row.style.display="";
	var cell1 = row.insertCell();
	cell1.className ="FieldName";
	cell1.innerHTML ="<input type=\"text\" value=\"\" id=\"objname"+rowscount+"\" name=\"objname"+rowscount+"\" value=\"\"/>";
	var cell2 = row.insertCell();
	cell2.className ="FieldName";
	cell2.innerHTML ="<input type=\"text\" id=\"ordernum"+rowscount+"\" name=\"ordernum"+rowscount+"\" value=\"\" onkeyup=\"value=value.replace(/[^\\d]/g,'')\" onbeforepaste=\"clipboardData.setData('text',clipboardData.getData('text').replace(/[^\\d]/g,''))\"/>";
	var cell3 = row.insertCell();
	cell3.className ="FieldName";
	cell3.innerHTML ="<select id=\"disabled"+rowscount+"\" name=\"disabled"+rowscount+"\"><option value=\"0\" >是</option><option value=\"1\">否</option></select>";
	var cell4 = row.insertCell();
	cell4.className ="FieldName";
	cell4.innerHTML ="<input type=\"button\" value=\"删除\" onclick=\"delTableRow('"+rowscount+"')\"/><input type=\"hidden\"  name=\"id"+rowscount+"\" id=\"id"+rowscount+"\" value=\"\"><input type=\"hidden\"  name=\"del"+rowscount+"\" id=\"del"+rowscount+"\" value=\"0\">";
}

function delTableRow(i){
	var table = document.getElementById("table");
    table.rows("row"+i).style.display="none";
    document.getElementById("del"+i).value="1";
	//table.deleteRow(rowid);
}

function onSave(){
	var table = document.getElementById("table");
	var rowscount = table.rows.length-1;
	if(rowscount==0){
		  return;
	}
	for(var i=0;i<rowscount;i++){
	   var objname=document.getElementById('objname'+i).value;
	   if(objname==""){
	     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
	       return;
	   }
	}
	var temp=false;
	var num=0;
	for(var i=0;i<rowscount;i++){
	   var objname=document.getElementById('objname'+i).value;
	   var ordernum=document.getElementById('ordernum'+i).value;
	   var disabled=document.getElementById('disabled'+i).value;
	   var id="";
	   if(document.getElementById('id'+i)&&document.getElementById('id'+i).value){
		   id=document.getElementById('id'+i).value;
	   }
	   var del=document.getElementById('del'+i).value;
		   Ext.Ajax.timeout = 900000;
		   Ext.Ajax.request({
		       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=savetag',
		       params:{id:id,del:del,objname:objname,ordernum:ordernum,disabled:disabled},
		       sync:true,
		       success: function(res) {
		    	    var xml=res.responseXML;
                    var status = xml.getElementsByTagName("msg")[0].childNodes[0].nodeValue+"";
		    	   document.getElementById("id"+i).value=status;
		           num+=1;
		           if(num==rowscount){
					   temp=true;
				   }
		           if(temp){
						pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
					}else if (i==rowscount-1 && !temp){
						pop( '设置失败');//！
					}
		       }
		   });
    }
}
</script>
  </head>
<body>
<div class="x-tab" title="标签管理">
<div id="pagemenubar"></div>
<TABLE class=layouttable border=1 id="table">
<COLGROUP>
<COL width="25%">
<COL width="40%">
<COL width="20%">
<COL width="15%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>显示名称</TD>
<TD class=FieldValue>菜单顺序</TD>
<TD class=FieldValue>是否启用</TD>
<TD class=FieldValue><input type="button" value="添加标签" onclick="addRow()"/></TD>
</TR>
<%
List<Map<String,Object>> list = ds.getValues("select * from coworktag where ISDELETE=0 order by ordernum asc");
Map<String,Object> m = new HashMap<String,Object>();
if(list!=null && list.size()>0){
for(int i=0;i<list.size();i++){
	m=list.get(i);
	String id= StringHelper.null2String(m.get("id"));
	String objname = StringHelper.null2String(m.get("objname"));
	int ordernum = NumberHelper.string2Int(m.get("ordernum"),-1);
	int disabled = NumberHelper.string2Int(m.get("disabled"),0);
	if("402881e83abf0214013abf0220810290".equals(id) ||"402881e83abf0214013abf0220810291".equals(id)|| "402881e83abf0214013abf0220810292".equals(id)|| "402881e83abf0214013abf0220810293".equals(id)  ){
		%>
<TR id="row<%=i %>" style="display:block">
<TD class=FieldName noWrap>
<%=objname %>
<input type="hidden" id="objname<%=i %>" name="objname<%=i %>" value="<%=objname %>"/>
</TD>
<TD class=FieldName noWrap>
<input type="hidden" id="ordernum<%=i %>" name="ordernum<%=i %>" value="<%=ordernum%>" />
</TD>
<TD class=FieldName noWrap>
<%=disabled==0?"是":"否" %>
<input type="hidden" id="disabled<%=i %>" name="disabled<%=i %>" value="<%=disabled %>" />
</TD>
<TD class=FieldName noWrap>
<input type="hidden"  name="id<%=i %>" id="id<%=i %>" value="<%=id %>">
<input type="hidden"  name="del<%=i %>" id="del<%=i %>" value="0">
</TD>
</TR>		
		<%
	}else{
%>
<TR id="row<%=i %>" style="display:block">
<TD class=FieldName noWrap>
<input type="text" id="objname<%=i %>" name="objname<%=i %>" value="<%=objname %>"/>
</TD>
<TD class=FieldName noWrap>
<input type="text" id="ordernum<%=i %>" name="ordernum<%=i %>" value="<%=ordernum!=-1?ordernum+"":"" %>" onkeyup="value=value.replace(/[^\d]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))"/>
</TD>
<TD class=FieldName noWrap>
<select id="disabled<%=i %>" name="disabled<%=i %>">
   <option value="0" <%=disabled==0?"selected='selected'":"" %>>是</option>
   <option value="1" <%=disabled==1?"selected='selected'":"" %>>否</option>
</select>
</TD>
<TD class=FieldName noWrap>
<input type="button" value="删除" onclick="delTableRow('<%=i %>')"/>
<input type="hidden"  name="id<%=i %>" id="id<%=i %>" value="<%=id %>">
<input type="hidden"  name="del<%=i %>" id="del<%=i %>" value="0">
</TD>
</TR>
<%}}} %>
</TBODY>
</TABLE>
</div>
  </body>
</html>
