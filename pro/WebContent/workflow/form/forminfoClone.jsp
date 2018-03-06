<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ include file="/base/init.jsp"%>
<%
String id = request.getParameter("id");
Forminfo forminfo = ((ForminfoService)BaseContext.getBean("forminfoService")).getForminfoById(id);
int objtype=forminfo.getObjtype();
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List selectitemlist = selectitemService.getSelectitemList("402881ec0c68ca65010c68d4d68b000a",null);
Selectitem selectitem;
String selectItemId = forminfo.getSelectitemid();
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
String isworkflow=StringHelper.null2String(request.getParameter("isworkflow"));
pagemenustr +=  "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";//提交
%>
<html>
<head>
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
<style type="text/css">
     #pagemenubar table {width:0}
</style>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script>
var contentPanel=null;
Ext.onReady(function(){
	<%
	if(!pagemenustr.equals("")){
		out.println("var tb = new Ext.Toolbar();");
	    out.println("tb.render('pagemenubar');");
	    out.println(pagemenustr);
	}
	if("true".equalsIgnoreCase(request.getParameter("toField"))){
		out.println("contentPanel.setActiveTab(fieldPanel);");
	}
	%>
});
</script>
</head>
<body>
<div id="ajaxcontentarea">
    <div id="pagemenubar"></div>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=clone" target="_self" name="EweaverForm"  method="post">
			<input type=hidden name=id value="" />
			<input type=hidden name=cloneId value="<%=forminfo.getId()%>" />
            <input type=hidden name=moduleid value="<%=forminfo.getModuleid()%>" />
		<table>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tr style="display:none;">
					<td class="FieldName" nowrap>
						 <%=labelService.getLabelName("402881e90bcbc9cc010bcbcb1aab0008")%>
					</td>
					<td class="FieldValue">
                    <input id="selectitemid" name="selectitemid" value='<%=selectItemId%>'>

					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="tbname" value="<%=forminfo.getObjname()%>" onchange="checkInput('tbname','labelnamespan')"  /><span id=labelnamespan></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b33919af10003")%>:
					</td>
					<td  class="FieldValue">
						<input style="width=95%" type="text" name="tbdesc" value="<%=StringHelper.null2String(forminfo.getObjdesc())%>" />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402881e90b36c0ac010b36c21eed0001") %>:<!-- 表单类型 -->
					</td>
					<td class="FieldValue">
						<% 
						String[] names=new String[]{labelService.getLabelName("402881e90b36c6a0010b36cdc9fe0004"),
						labelService.getLabelName("402881e90b36c6a0010b36cd0f0c0003"),"","",labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370066")};//虚拟表单
						%>
						<%=names[forminfo.getObjtype()]%>
						<input type="hidden" name="tbType" value="<%=forminfo.getObjtype()%>" />
    				</td>
				</tr>
				<% if(forminfo.getObjtype().intValue()==0){%>
                <tr id="oDiv">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370067") %><!-- 用途 -->:
					</td>
					<td class="FieldValue">
						<select name="purpose" id="purpose">
						  		<option value="0" <%if(forminfo.getCol1().equals("0")){%>selected<%} %>><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370068") %><!-- 普通 --></option>
                                <option value="1" <%if(forminfo.getCol1().equals("1")){%>selected<%} %>><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370069") %><!-- 交流 --></option>
                               <%-- <option value="2" >日程</option>--%>
    					 </select>
					</td>
				</tr>
				<tr id="oDiv">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e90b36c0ac010b36c3f9fc0002")%>:
					</td>
					<td class="FieldValue">
								uf_<input style="width: 150px" MAXLENGTH="26" type="text" name="tablename" id="tablename" onkeyup="value=value.replace(/[^\w]/ig,'')"/>
					</td>
				</tr>
				<%}else if(forminfo.getObjtype()==4){
				%>	
				<tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006a") %><!-- 数据源 -->:</td>
					<td class="FieldValue">
						<%=forminfo.getCol2()%>
						<input type="hidden" name="vdatasource" value="<%=forminfo.getCol2()%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006b") %><!-- 物理表名 -->:</td>
					<td class="FieldValue">
						<%=forminfo.getObjtablename()%>
						<input type="hidden" name="vtableName" value="<%=forminfo.getObjtablename()%>"/>
					</td>
				</tr>
				<%}%>
			</table>
        </form>
		</div>
    </body>
<script language="javascript">
function onSubmit(){
	checkfields="tbname,tablename";
	checkmessage='<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';
	if(!checkForm(EweaverForm,checkfields,checkmessage)){
		return false;
	}
	document.EweaverForm.submit();
}
</script>
</html>