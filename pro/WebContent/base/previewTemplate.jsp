<%@ page contentType="text/html; charset=utf-8" language="java" %>
<jsp:directive.page import="com.eweaver.base.BaseContext"/>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.workflow.form.model.*,java.util.*"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.ForminfoService"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.FormfieldService"/>
<jsp:directive.page import="com.eweaver.base.Page"/>
<%!
private ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>生成默认模板－预览</title>
<script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/js/weaverUtil.js"></script>
<script language="javascript" type="text/javascript" src="<%= request.getContextPath()%>/js/prototype.js"></script>
<style type="text/css">
<!--
table{width:auto;}
-->
</style>
<script language="javascript" type="text/javascript">
WeaverUtil.imports(['<%= request.getContextPath()%>/dwr/util.js','<%= request.getContextPath()%>/dwr/engine.js','<%= request.getContextPath()%>/dwr/interface/FormfieldService.js']);

var Preview={
id:"tablePreview",
chWidth:function(obj){
	var val=obj.value;
	if(!val.isNumeric()){
		if(!val.endsWitdh("%")){
			alert('非数字字符!');
			return;
		}
	}
	$(this.id).width=val;
},
chColumn:function(obj){
	var val=obj.options[obj.selectedIndex].value;
	if(!val.isNumeric()){
		alert('非数字字符!');
		return;
	}
	val=parseInt(val);
	var rows=$(this.id).rows;
	var len=rows(0).cells.length;
	if(val>len){//扩展列
		for(var i=len;i<val;i++)
			rows(0).insertCell().innerHTML="&nbsp;";
	}else if(val<len){//删除列
		for(var i=len;i>val;i--)
			rows(0).deleteCell(i-1);
	}
	var cw=Math.floor(parseInt($(this.id).width)/val);
	for(var i=0;i<val;i++)
		rows(0).cells(i).width=cw+"";
},
toFields:function(){//获取字段名
	var oTable=$(this.id);
	var rows=oTable.rows;
	var len=rows.length;
	for(var i=1;i<len;i++)oTable.deleteRow(1);
	var colums=parseInt($F('tableColumn'));
	var cRow=0;//表示操作的当前行号
	var cCol=0;//操作的当前列
	FormfieldService.getAllFieldByFormIdExist($F('formId'),function(data){
		var f=null;
		var nums=(data.length*2)/colums;
		for(var i=2;i<nums;i++){
			var row=oTable.insertRow();
			for(var n=0;n<colums;n++)row.insertCell(n).innerHTML='&nbsp;';
		}
		var n=0;
		for(var i=0;i<data.length;i++){
			f=data[i];
			rows(cRow).cells(cCol++).innerHTML=f.labelname+":";
			rows(cRow).cells(cCol++).innerHTML=f.fieldname;
			if(cCol>=colums)cCol=0;
			n=(i+1)*2;
			if(n%colums==0)
				cRow=n/colums-1;
			else cRow=Math.floor(n/colums);
			alert('i:'+i+',n:'+n+',row:'+cRow+",cCol:"+cCol);
		}
	});
}

};
</script>
</head>

<body>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction?action=defaultTemplate" method="post" name="form1">
<table width="600" border="1" cellspacing="1" cellpadding="1">
  <tr>
    <td width="80">表单</td>
    <td width="507">
      <select name="formId" id="formId">
<%
Page pageObject = this.forminfoService.getPagedByQuery("from Forminfo order by id desc",1,100);
List list = (List) pageObject.getResult();
Forminfo forminfo=null;
for(int i=0;i<list.size();i++)
{
	forminfo=(Forminfo)list.get(i);
	out.print("<option value=\""+forminfo.getId()+"\">"+forminfo.getObjname());
	out.println("</option>");
}
%></select>
	  <label for="isEdit"><input name="isEdit" type="checkbox" id="isEdit" value="value" />编辑模板</label>
&nbsp;&nbsp;
</td>
  </tr>
  <tr>
  	<td>变量名称</td>
  	<td><input name="oName" id="oName" value="obj"/></td>
  </tr>
  <tr>
  	<td>名称前缀</td>
  	<td><input name="namePrefix" id="namePrefix" value="name"/>
  	(如果是多行数据请改成:[name${velocityCount}]</td>  	
  </tr>  
  <tr>
    <td>宽度</td>
    <td><input name="tableWidth" onBlur="Preview.chWidth(this)" type="text" id="tableWidth" value="600" />
      (默认为px)</td>
  </tr>
  <tr>
    <td>列数</td>
    <td><select name="tableColumn" id="tableColumn" onChange="Preview.chColumn(this)">
      <option value="2" selected="selected">2</option>
      <option value="4">4</option>
      <option value="6">6</option>
      <option value="8">8</option>
    </select></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><!--<a href="javascript:;" onClick="Preview.toFields();">生成字段预览</a>-->
      &nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="btnSave" type="submit" id="btnSave" value="提交" /></td>
  </tr>
</table>
</form>
<hr/>
<div id="a">
<table id="tablePreview" width="600" border="1">
<tr><td width="118">filed:</td>
<td width="466">value1</td>
</tr>
</table>
</div>
</body>
</html>
