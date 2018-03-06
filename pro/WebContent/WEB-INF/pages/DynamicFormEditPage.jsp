<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*,com.eweaver.base.util.VtlEngineHelper,java.io.*" %>
<jsp:directive.page import="com.eweaver.base.BaseContext"/>
<jsp:directive.page import="com.eweaver.base.util.StringHelper"/>
<jsp:directive.page import="com.eweaver.workflow.form.model.*"/>
<jsp:directive.page import="com.eweaver.base.Page"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.service.TemplateEngine"/>
<jsp:directive.page import="com.eweaver.base.treeviewer.model.DynamicFormAction"/>
<jsp:directive.page import="com.eweaver.workflow.form.service.ForminfoService"/>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%!

private ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script language="javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/js/weaverUtil.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/js/main.js"></script>
<title>测试模板解析</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/resources/css/tree.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<style>
.x-window-footer table,.x-toolbar table{width:auto;}
</style>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/eweaver.css" />
<script type="text/javascript">
WeaverUtil.imports(['<%=request.getContextPath()%>/dwr/engine.js','<%=request.getContextPath()%>/dwr/util.js','<%=request.getContextPath()%>/dwr/interface/TreeViewer.js']);
Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';
WeaverUtil.load(function(){
	var tb = new Ext.Toolbar();
	tb.render('pagemenubar');
	addBtn(tb,'保存','S','accept',function(){document.editForm.submit();});
	addBtn(tb,'返回','B','arrow_redo',function(){location.href='<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction';});
});
var rows=1;
<%
Object obj=request.getAttribute("fieldList");
List fieldList=null;
if(obj!=null){
 fieldList=(List)obj;
 out.println("rows="+fieldList.size()+";");
}
%>
function addRow(){
	var obj=document.createElement("li");
	obj.id="rows"+rows;
	var s='前缀:<input name="fieldPrefix'+rows+'" value=""/>';
	s+='行号前缀:<input name="rowPrefix'+rows+'" value="rowNum"/>';
	s+='<select name="formId'+rows+'">';
	s+=$('formIdSelect').innerHTML;
	s+='</select>';
	s+='<input type="button" value="－" onclick="Element.remove(\''+obj.id+'\')"/>';
	obj.innerHTML=s;
	$('spanContainer').appendChild(obj);
	rows+=1;
}
</script>
</head>
<body>
<span id="pagemenubar"></span><br/>
<div style="display:;"><hr/>
<form method="post" name="editForm" action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.treeviewer.servlet.TemplateViewerListAction">
<c:if test="${not empty tempId}"><input type="hidden" name="tempId" id="tempId" value='<c:out value="${tempId}"/>'/></c:if>
<input type="hidden" name="action" id="editAction" value="editActionSave"/>
<input type="hidden" name="id" id="editId" value='<c:out value="${form.id}"/>'/>
<%
Page pageObject = this.forminfoService.getPagedByQuery("from Forminfo order by id desc",1,100);
List list = (List) pageObject.getResult();

/*
String editFormId="";
Object objTmp=request.getAttribute("form");
if(objTmp!=null){
	DynamicFormAction form1=(DynamicFormAction)objTmp;
	editFormId=form1.getFormId();
	//System.out.println("editId:"+form1.getId());
	//System.out.println("interfaceText:"+form1.getInterfaceText());
	if(editFormId==null) editFormId="";
}
*/

Forminfo forminfo=null;
//System.out.println("editId:"+request.getParameter("editId"));
%>
<ol  style="list-style-type:decimal" id="spanContainer">
<%

if(fieldList==null || fieldList.size()==0){
	Map m=new HashMap();
	m.put("fieldPrefix","");
	m.put("formId","");
	m.put("rowPrefix","rowNum");
	if(fieldList==null) fieldList=new ArrayList();
	fieldList.add(m);
}
String editFormId="";
for(int n=0;n<fieldList.size();n++){
Map m=(Map)fieldList.get(n);
editFormId=m.get("formId").toString();
%>
<li id="span<%=n%>">
前缀:<input name="fieldPrefix<%=n%>"  value='<%=m.get("fieldPrefix")%>' />
行号前缀:<input name="rowPrefix<%=n%>"  value='<%=m.get("rowPrefix")%>' />
<select id="formIdSelect" name="formId<%=n%>">
<option value="0">  </option>
<%
for(int i=0;i<list.size();i++)
{
	forminfo=(Forminfo)list.get(i);
	out.print("<option value=\""+forminfo.getId()+"\" ");
	if(editFormId.equalsIgnoreCase(forminfo.getId()))
		out.print(" selected=\"selected\"");
	out.print(">"+forminfo.getObjname());
	out.println("</option>");
}
%>
</select>
<%if(n==0){ %>
	<input type="button" value="＋"" onclick="addRow()"/>
<%}else{%>
	<input type="button" value="－" onclick="Element.remove('span<%=n%>')"/>
<%} %>
</li>
<%}
%>
</ol>
自定义接口:(结尾需要return data;data as Map为传入参数。而out,request为内置变量，属性和方法同java语法)<br/><textarea name="interfaceText" style="width:600px;height:300px;" type="_moz">
<c:out value="${form.interfaceText}"/>
</textarea>
</div>
</form>
</div>

<!-- 
<c:if test="${not empty formList}">
<table width="80%" align="center">
<tr><td>ID</td><td>FormId</td><td>fieldPrefix</td><td>inerfaceText</td></tr>
<c:forEach var="f" items="${formList}">
<tr><td><c:out value="${f.id}"/></td><td><c:out value="${f.formId}"/></td><td><c:out value="${f.fieldPrefix}"/></td><td><a href="javascript:onUpdate('<c:out value="${f.id}"/>','editAction')">编辑</a></td></tr>

</c:forEach>
</table>
</c:if>
 -->
</body>
</html>