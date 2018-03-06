<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowacting"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowactingService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlink"%>
<%@ page import="com.eweaver.workflow.form.service.FormlinkService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.DataService"%>
<html>
  <head>
    	  <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
  </head>
  <body> 
  <!-- 标题 -->
  <%titlename=labelService.getLabelName("402881540c9f83d6010c9f9e49aa0009");%>
  
<!--页面菜单开始-->     
<%
	String workflowactingid = request.getParameter("workflowactingid");
	String byagent = request.getParameter("byagent");
	String agent = request.getParameter("agent");
	
	pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:browser_onclick()}";
	//pagemenustr += "{C,"+"生成条件"+",javascript:setCondition2()}";
	pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.history.back()}";
	
	pagemenustr += "{C,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:browser_clear()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
<font color="red">(<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290040") %><!-- 使用步骤： 1.在表单名称下面填写相应的字段值  2.勾选字段前面的复选框 ,可以多选 3.提交退出设置页面 -->)</font>
<%
		WorkflowactingService workflowactingService = (WorkflowactingService) BaseContext.getBean("workflowactingService");
		String formid = request.getParameter("formid");
		Workflowacting workflowacting = workflowactingService.getWorkflowacting(workflowactingid);
		
		String condition = workflowacting.getCondition();//request.getParameter("condition");//查询条件
		Map conmap1 = new HashMap();	
		Map conmap2 = new HashMap();
		
		ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
		FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");

		Forminfo forminfo1 = forminfoService.getForminfoById(formid);
		List forminfolists = new ArrayList();

		if(forminfo1.getObjtype().toString().equals("0")){//实际表单
			//formfieldlist = formfieldService.getAllFieldByFormId(formid);
			//String objtablename = forminfo.getObjtablename();
			forminfolists.add(forminfo1);
		}else if(forminfo1.getObjtype().toString().equals("1")){//抽象表单
			//FormlinkService formlinkService = (FormlinkService) BaseContext.getBean("formlinkService");
			StringBuffer hql = new StringBuffer("from Forminfo a  where a.id in (");
			hql.append("select b.pid from Formlink b where  b.typeid=1 and b.oid='").append(formid).append("')");
			forminfolists = forminfoService.getForminfoListByHql(hql.toString());
		}

String[] checkcons = request.getParameterValues("check_con");
ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
		
%>
<FORM NAME=EweaverForm STYLE="margin-bottom:0" action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search" method="post">

<input type=hidden name=reportid value="<%=formid%>">

  <b><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf290039") %><!-- 原报表条件 -->：
  	      <input type=text id="oldconditions" class=inputstyle value="<%=StringHelper.null2String(condition)%>" size=125 readonly>
  </b>
  <br/>
  <span id="newcondition" style="DISPLAY: none">
    <b>
	<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003a") %><!-- 新报表条件 -->：
  </b>
  <br/>
	  <TEXTAREA NAME="conditions" id="conditions" ROWS="5" COLS="60" style="width:100%"></TEXTAREA>
	  <input type="hidden" NAME="conditionsName" id="conditionsName" />
  </span>

<select class=inputstyle name="formname" onchange="onChangeShareType()" value="">
				<option value="0"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003b") %><!-- 请选择表单名称 -->：</option>
    <%
    for(int k=0; k<forminfolists.size(); k++){
    	Forminfo forminfo= (Forminfo)forminfolists.get(k);
    	String formname1 = forminfo.getObjname();
		String objtablename1 = forminfo.getObjtablename();
		%>
		        <option value="<%=objtablename1%>"><%=formname1%></option>
		<%}%>
 </select>
    <%
    for(int k=0; k<forminfolists.size(); k++){
    	Forminfo forminfo= (Forminfo)forminfolists.get(k);
    	//System.out.println("------formid:" +k+"  " + forminfo.getId());
    	List formfieldlist = formfieldService.getAllFieldByFormIdExist(forminfo.getId());
    	String formname = forminfo.getObjname();
		String objtablename = forminfo.getObjtablename();
		
		String mstyle = "";
		if(k!=0){
			mstyle = "none";
		}
		%>
	
	<table width=100% class=viewform  id="<%=objtablename%>" style="display:'<%=mstyle%>'">
	
		<B> <tr> <%=labelService.getLabelNameByKeyId("297ee7020b338edd010b3390af720002") %><!-- 表单名称 -->：<%=formname%> </tr> </B>
		
		<%
		
		int linecolor=0;
		int tmpcount = 0;
		boolean showsep = true;
		String fieldname="";
		//System.out.println("------formfieldlist.size():" + formfieldlist.size());
		Iterator fieldit = formfieldlist.iterator();
		while(fieldit.hasNext()){
			Formfield formfield = (Formfield)fieldit.next();
		
			tmpcount += 1;
			String id = formfield.getId();
			
			String htmltype = String.valueOf(formfield.getHtmltype());
			String type = StringHelper.null2String(formfield.getFieldtype());
	
			String _fieldid = StringHelper.null2String(formfield.getId());
			String _formid = StringHelper.null2String(formfield.getFormid());
			String _fieldname = StringHelper.null2String(formfield.getFieldname());
			String _htmltype = StringHelper.null2String(formfield.getHtmltype());
			String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
			String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
			String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
			String _style ="";
			String _value="";
	
			fieldname = formfield.getFieldname();
			String label = formfield.getLabelname();
			
			
%>
		<INPUT TYPE="hidden" name="con<%=id%>_value_fieldname" value="<%=fieldname%>">
		<INPUT TYPE="hidden" name="con<%=id%>_value_objtablename" value="<%=objtablename%>">
		<INPUT TYPE="hidden" name="con<%=id%>_value1_fieldname" value="<%=fieldname%>">
		<INPUT TYPE="hidden" name="con<%=id%>_value1_objtablename" value="<%=objtablename%>">
		
	<tr class=title>
<%	
if(!htmltype.equals("3")&& !htmltype.equals("7")){
%>
	  <td class="FieldName"><INPUT TYPE="checkbox" NAME="check_con<%=id%>" id="check_con<%=id%>" onclick="addfield2('con<%=id%>_value')"></td>	
      <td class="FieldName" ><span name="con<%=id%>_valuename" id="con<%=id%>_valuename"><%=StringHelper.null2String(label)%></span></td> 

    <%
}

if(htmltype.equals("1")){
	if(type.equals("1")){//文本
%>

    <td  class="FieldValue"> 
      <select class=inputstyle name="con<%=id%>_value_opt" >
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
        <option value="7"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %><!-- 包含 --></option>
        <option value="8"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %><!-- 不包含 --></option>
      </select>
    </td>
    <td colspan=3  class="FieldValue"> 
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onchange="addfield('con<%=id%>_value')" >
    </td>
   <%
   }else if(type.equals("2")){//整数
   
%>

    <td  class="FieldValue"> 
      <select class=inputstyle name="con<%=id%>_value_opt"  >
        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
      </select>
    </td>
    <td  class="FieldValue">
      <input type=text class=inputstyle size=12 name="con<%=id%>_value" onchange="addfield('con<%=id%>_value');"  >
    </td>
    <td  class="FieldValue">     
      <select class=inputstyle name="con<%=id%>_value1_opt" style="width:100%">
        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
      </select>
    </td>
    <td  class="FieldValue"> 
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1"  onchange="addfield('con<%=id%>_value1')" >
    </td>
    <%
   }
   else if(type.equals("3")){//浮点数


   
   %>
    <td  class="FieldValue"> 
      <select class=inputstyle name="con<%=id%>_value_opt" >
        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
      </select>
    </td>
    <td  class="FieldValue">
      <input type=text class=inputstyle size=12 name="con<%=id%>_value" onchange="addfield('con<%=id%>_value')"  >
    </td>
    <td  class="FieldValue">     
      <select class=inputstyle name="con<%=id%>_value1_opt">
        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
      </select>
    </td>
    <td  class="FieldValue"> 
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1" onchange="addfield('con<%=id%>_value1')"  >
    </td>
    <%
   
   }
   else if(type.equals("4")){//日期
   
   %>

			<td  class="FieldValue"> 
			  <select class=inputstyle name="con<%=id%>_value_opt" >
		        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
		        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
		        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
		        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
		        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
		        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
			  </select>
			</td>
			<td  class="FieldValue">  
       			<button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('con<%=id%>_value','con<%=id%>_span1','0')"></button>&nbsp; 
       			<span id="con<%=id%>_span1"></span>
       			<input type=hidden name="con<%=id%>_value" value=""> 			  
			</td>
       		<td  class="FieldValue" align=left>
			  <select class=inputstyle name="con<%=id%>_value1_opt" >
		        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
		        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
		        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
		        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
		        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
		        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
			  </select> 
			 </td>
			 <td  class="FieldValue">      		
       			<button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('con<%=id%>_value1','con<%=id%>_span2','0')"></button>&nbsp; 
       			<span id="con<%=id%>_span2" ></span>-&nbsp;&nbsp;
       			<input type=hidden name="con<%=id%>_value1" value="">
       		 </td>

    <%
   }
   else if(type.equals("5")){//时间
	%>
			<td  class="FieldValue"> 
			  <select class=inputstyle name="con<%=id%>_value_opt" >
		        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
		        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
		        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
		        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
		        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
		        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
			  </select>
			</td>	
	<%
	   		StringBuffer sb = new StringBuffer("");
		sb.append("<td class='FieldValue'>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"+_fieldid+"_value','con"+_fieldid+"span1','0');\"></button>");
		sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+_value+"\"  "+_style+"  >");
		sb.append("\n\r<span id=\"con"+_fieldid+"span1\" name=\"field_"+_fieldid+"span\" >");
		sb.append(_value);
		sb.append("</span>\n\r</td>");
   		out.print(sb.toString());
   		
   	%>
 			<td  class="FieldValue"> 
			  <select class=inputstyle name="con<%=id%>_value1_opt" >
		        <option value="1"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002f") %><!-- 大于 --></option>
		        <option value="2"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003c") %><!-- 大于或等于 --></option>
		        <option value="3"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf28002c") %><!-- 小于 --></option>
		        <option value="4"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003d") %><!-- 小于或等于 --></option>
		        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
		        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
			  </select>
			</td>	  	
   	
   	<%	
   		StringBuffer sb1 = new StringBuffer("");
		sb1.append("<td class='FieldValue'>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"+_fieldid+"_value1','con"+_fieldid+"span2','0');\"></button>");
		sb1.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value1\" value=\""+_value+"\"  "+_style+"  >");
		sb1.append("\n\r<span id=\"con"+_fieldid+"span2\" name=\"field_"+_fieldid+"span\" >");
		sb1.append(_value);
		sb1.append("</span>\n\r</td>");
   		out.print(sb1.toString());
   }
     %>
<%}
else if(htmltype.equals("2")){//多行文本
%>
    <td  class="FieldValue"> 
      <select class=inputstyle name="con<%=id%>_value_opt" style="width:100%">
        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
        <option value="6"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e") %><!-- 不等于 --></option>
        <option value="7"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c") %><!-- 包含 --></option>
        <option value="8"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f") %><!-- 不包含 --></option>
      </select>
    </td>
    <td colspan=3  class="FieldValue"> 
      <TEXTAREA ROWS="" COLS="50" name="con<%=id%>_value" onchange="addfield('con<%=id%>_value')" style="width:100%"></TEXTAREA>
    </td>
    <%
}

else if(htmltype.equals("4")){//check框


%>

    <td  class="FieldValue"> 
			<INPUT TYPE="checkbox" NAME="con<%=id%>_value" onchange="addfield('con<%=id%>_value')" value="1" onclick="gray(this)">
    </td>
    <%}
    

else if(htmltype.equals("5")){//选择项


			SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
			List list = selectitemService.getSelectitemList(type,null);
			StringBuffer sb = new StringBuffer("");
			sb.append("<input type=\"hidden\" name=\"field_"
							+ _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
			sb.append("<td class='FieldValue'>\n\r <select class=\"InputStyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+"  onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\"  >");
			String _isempty = "";
			if(StringHelper.isEmpty(_value))
				_isempty = " selected ";
			sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
			for(int i=0;i<list.size();i++){
				Selectitem _selectitem = (Selectitem)list.get(i);  
				String _selectvalue = StringHelper.null2String(_selectitem.getId());
				String _selectname = StringHelper.null2String(_selectitem.getObjname());
				String selected = "";
				if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(_value)))
					selected = " selected ";
				sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
			}	
			sb.append("</select>\n\r</td> ");
			out.print(sb.toString());

}

else if(htmltype.equals("6")){ // 关联选择

			RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
			Refobj refobj = refobjService.getRefobj(type);
			if(type!=null && refobj != null){

                if(type.equals("402881e60bfee880010bff17101a000c")){%>
                    <td  class="FieldValue"> 
                      <select class=inputstyle name="con<%=id%>_value_opt" >
                        <option value="5"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d") %><!-- 等于 --></option>
                        <option value="9"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003e") %><!-- 从属于 --></option>
                        <option value="10"><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf29003f") %><!-- 不从属于 --></option>
                      </select>
                    </td>	
                <%}
				String _refid = StringHelper.null2String(refobj.getId());
				String _refurl = StringHelper.null2String(refobj.getRefurl());
				String _viewurl = StringHelper.null2String(refobj.getViewurl());
				String _reftable = StringHelper.null2String(refobj.getReftable());
				String _keyfield = StringHelper.null2String(refobj.getKeyfield());
				String _viewfield = StringHelper.null2String(refobj.getViewfield());
				String showname = "";
				if(!StringHelper.isEmpty(_value)){
					String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(_value) + ")";
					DataService dataService = new DataService();
					List valuelist = dataService.getValues(sql);
					for(int i=0;i<valuelist.size();i++){
						Map refmap = (Map) valuelist.get(i);  	
						String _objid = StringHelper.null2String((String) refmap.get("objid"));
						String _objname = StringHelper.null2String((String) refmap.get("objname"));
						if(!StringHelper.isEmpty(_viewurl))
							showname += "&nbsp;&nbsp;<a href=\""+_viewurl+_objid+"\" target=\"_blank\" >";
						showname += _objname;
						if(!StringHelper.isEmpty(_viewurl))
							showname += "</a>";
					}
				}
				
				StringBuffer sb = new StringBuffer("");
				sb.append("<td class='FieldValue'> \n\r<button  type=button class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','field_"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
				sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+_value.trim()+"\"  "+_style+"  >");
				sb.append("\n\r<span id=\"field_"+_fieldid+"span\" name=\"field_"+_fieldid+"span\" >");
				sb.append(showname);
				sb.append("</span>\n\r</td> ");
				out.print(sb.toString());	
				
			}
} 

}
}
%>
    </tr>

  </table>



</FORM>
<SCRIPT LANGUAGE=VBS>
sub onShowMultiPropValue(objval,inputname)
	tmp = document.all(inputname&"_value").value
	fieldname = document.all(inputname+"_fieldname").value
	objtablename = document.all(inputname+"_objtablename").value
	id1 = window.showModalDialog("<%=request.getContextPath()%>/systeminfo/BrowserMain.jsp?url=<%=request.getContextPath()%>/props/data/PropValueBrowser.jsp?sqlwhere= where propid="&objval&"&resourceids="&tmp)
	if (Not IsEmpty(id1)) then
	if id1(0)<> "" then
		alert(inputname)
		propvalueids = id1(0)
		propvaluenames = id1(1)
		sHtml = propvaluenames
		document.all(inputname&"_value").value= propvalueids

		document.all(inputname&"_valuespan").innerHtml = sHtml
		document.all(inputname&"_name").value= sHtml
		addfield(inputname)	
	else 
		document.all(inputname&"_value").value= ""
		document.all(inputname&"_name").value= ""
		document.all(inputname&"_valuespan").innerHtml = ""
	end if
	end if
end sub

</script>

</BODY></HTML>
<script language=vbs>


sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
		addfield(inputname)	
	end if
end sub
sub gettime(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/clock.jsp",,"dialogHeight:320px;dialogwidth:275px")

	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	addfield(inputname)	
	end if
end sub
</script>


<SCRIPT language=VBS>

Sub oc_CurrentMenuOnMouseOut(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = "hidden"
End Sub

Sub oc_CurrentMenuOnClick(icount)
    document.all("oc_divMenuDivision"&icount).style.visibility = ""
End Sub
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
    function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var id;
    try{
    id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
<!--
var allfield = new Array();
var allfieldStr="";

function addfield(input){
	//document.all("check_" + input.substr(0,input.indexOf("_value"))).checked=true;
	var len = allfield.length;
	if(allfieldStr.indexOf(input)==-1){
		allfield[len]=input;
		allfieldStr+=input;
	}
}

var checkboxcount = 0;

function addfield2(input){
	var inputtemp = 'check_con'+input.replace('_value','').replace('con','');
	if(document.getElementById(inputtemp).checked){
		checkboxcount++;
	}else{
		checkboxcount--;
	}
	if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
		var len = allfield.length;
		if(allfieldStr.indexOf(input)==-1){
			allfield[len]=input;
			allfieldStr+=input;
		}
	}
}
var tempname;
function setCondition2(){
	document.all("conditionsName").value="";
	document.all("conditions").value="";
	var condition="";
	for(var i=0; i<allfield.length; i++){
		var input = allfield[i];
		var fieldname = document.all(input + "_fieldname").value;
		var objtablename = document.all(input + "_objtablename").value;		
		if(document.all("check_" + input.substr(0,input.indexOf("_value"))).checked){
			var opt="=";
			var value=document.all(input).value;
			if(document.all(input+ "_opt")){
				if(document.all(input+ "_opt").value=="1"){
					opt=">";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "大于";
				}else if(document.all(input+ "_opt").value=="2"){
					opt=">=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "大于或等于";
				}else if(document.all(input+ "_opt").value=="3"){
					opt="<";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "小于";
				}else if(document.all(input+ "_opt").value=="4"){
					opt="<=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "小于或等于";
				}else if(document.all(input+ "_opt").value=="5"){
					opt="=";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "等于";
				}else if(document.all(input+ "_opt").value=="6"){
					opt="<>";
                    condition =  fieldname + opt + " '" + Trim(value) + "' and ";
                    tempname = "不等于";
				}else if(document.all(input+ "_opt").value=="7"){
					opt=" like ";
                    condition =  fieldname + opt + " '%" + Trim(value) + "%' and ";
                    tempname = "包含";
				}else if(document.all(input+ "_opt").value=="8"){
					opt=" not like ";
                    condition =  fieldname + opt + " '%" + Trim(value) + "%' and ";
                    tempname = "不包含";
				}else if(document.all(input+ "_opt").value=="9"){
					opt=" $$$";//由于&&传参被截断，用这个替代
                    condition =  "["+fieldname + opt + " '" + Trim(value) + "'] and ";
                    tempname = "从属于";
				}else if(document.all(input+ "_opt").value=="10"){
					opt=" @@@";//由于##传参被截断，用这个替代
                    condition =  "["+fieldname + opt + " '" + Trim(value) + "'] and ";
                    tempname = "不从属于";
				}
			}else{
				condition =  fieldname + " like '" + Trim(value) + "' and ";
			}
			if(document.all("conditions").value.indexOf(objtablename)== -1){
				if(document.all("conditions").value.indexOf("and")!=-1){
					document.all("conditions").value = document.all("conditions").value.substr(0,document.all("conditions").value.lastIndexOf("and"));
				}
				document.all("conditions").value += "}{" + objtablename + ":";
			}
			document.all("conditions").value += condition;						
		}
		var labelname = input+"name";
		var fieldspan = "field_"+input.replace('con','').replace('_value','')+"span";
		try{
			if(document.getElementById(input+ "_opt")[0].value>0){
				var labelname;
				if(document.getElementById(labelname)==undefined){
					labelname = labelname.replace('value1','value');
				}
					labelname = document.getElementById(labelname).innerHTML;
				var optionvalue = document.all(input+ "_opt").value;
				var inputvalue;
				if(document.getElementById(fieldspan)!=undefined){
					inputvalue = document.getElementById(fieldspan).innerHTML;
				}else{
					inputvalue = document.getElementById(input).value
				}
				document.getElementById("conditionsName").value += "{"+labelname+":"+tempname+" "+inputvalue+"};";
			}
		}catch(e){
			if(document.getElementById(input)[0]!=undefined){//类型
				var typename;
				for(var j=0;j<document.getElementById(input).length;j++){
					if(document.getElementById(input)[j].value==document.getElementById(input).value){
						typename = document.getElementById(input)[j].innerHTML;
					}
				}
				labelname = document.getElementById(labelname).innerHTML;
				document.getElementById("conditionsName").value += "{"+labelname+":"+typename+"};";
			}else{
				document.getElementById("conditionsName").value += "{"+document.getElementById(labelname).innerHTML+":"+document.getElementById(fieldspan).innerHTML+"};";
			}
		}
	}
	//alert(document.getElementById("conditions").value);
	//alert(document.getElementById("conditionsName").value);
	var conditions2 = document.all("conditions").value;
	if(conditions2.indexOf("and")== -1){
		document.all("conditions").value = conditions2;
	}else{
		document.all("conditions").value = conditions2.substr(1,conditions2.lastIndexOf("and")-1) + "}";
	}
}

function browser_onclick(){
	var oldcon = document.all("oldconditions").value;		
	if(oldcon!=null&&oldcon!=''){
		if(checkboxcount<=0){
			alert("请选中条件复选框");return;
		}
	}	
	setCondition2();
	var conditions = document.all("conditions").value;
	//alert(conditions);
	//return;
	document.EweaverForm.action='<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=addcondition&workflowactingid=<%=workflowactingid%>&byagent=<%=byagent%>&agent=<%=agent%>&condition='+conditions;
    document.EweaverForm.submit();
}

function browser_clear(){
	document.all("oldconditions").value='';	
}

function onChangeShareType(){
	var id = document.all("formname").value;
	var len=document.all("formname").length;
	for(var i=1; i<len; i++){
		var tempid = document.all("formname")[i].value;
		if(tempid==id){
			document.all(tempid).style.display = '';
		}else{
			document.all(tempid).style.display = 'none';
		}
	}	
}
function isDigit(s)
{
var patrn=/^[0-9]{1,20}$/;
if (!patrn.exec(s)) return false
return true
} 

function fillotherselect(elementobj,fieldid,rowindex){
	addfield("con" +fieldid + "_value");
	
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";
	
	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)
		
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql ="<%=SQLMap.getSQLString("workflow/workflow/exportbrowserbyagent.jsp")%>";
	DataService.getValues(sql,{          
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);
   	
}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;
			
			if(document.getElementById(objname) == null){
				return;
			}

			DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
//-->
</SCRIPT>
<script type="text/javascript">
             function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态(找出为空的数据)
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
</script>
