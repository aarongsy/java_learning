<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.request.service.FormService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.workflow.report.model.Contemplate" %>
<%@ page import="com.eweaver.workflow.report.service.ContemplateService" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<!--页面菜单开始-->
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String reportid = request.getParameter("reportid");
String isformbase = request.getParameter("isformbase");
String toaction = request.getParameter("toaction");
String sqlwhere = request.getParameter("sqlwhere");
String contemplateid = request.getParameter("contemplateid");
String docCategoryid = request.getParameter("docCategoryid");
ContemplateService contemplateService = (ContemplateService)BaseContext.getBean("contemplateService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
FormService formService = (FormService) BaseContext.getBean("formService");
paravaluehm.put("{id}",reportid);

String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search";

String conaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=savecondition";
String tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate"+"&highsearch=1";
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search";
	conaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=savecondition";
	tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=searchtemplate&highsearch=1";
}
if(isformbase!=null && !isformbase.equals("")){
    action +="&isformbase="+isformbase;
    conaction +="&isformbase="+isformbase;
    tmpaction +="&isformbase="+isformbase;
}
if(sqlwhere!=null && !"".equals(sqlwhere)){
    action +="&sqlwhere="+sqlwhere;
}

if(contemplateid==null||"".equals(contemplateid)){
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("提交")+"','S','accept',function(){onSubmit()});";
    //pagemenustr += "{R,"+labelService.getLabelName("40288184119b6f4601119c3cdd77002d")+",javascript:window.history.go(-1)}";
    //pagemenustr += "{D,"+labelService.getLabelName("402881eb0bcbfd19010bcc5cb5a3001c")+",javascript:location.href='/base/searchcustomize/searchcustomize.jsp?reportid="+ reportid +"&sysmodel="+ sysmodel +"'}";

    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f7a113e0046")+"','M','page_copy',function(){showtemplate()});";//模板管理
    //pagemenustr += "{B,"+"保存"+",javascript:savecondition()}";
}else{
    pagemenustr +=  "addBtn(tb,'"+labelService.getLabelName("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){onSubmit2()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_redo',function(){javascript:back('"+ reportid +"')});";
}
String formid=reportdefService.getReportdef(reportid).getFormid();
%>
<html>
  <head>
      <style type="text/css">
     #pagemenubar table {width:0}
</style>
      <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
      <script type="text/javascript">
      
      //多选Checkbox函数
function onClickMutiBox(box, fieldid) {
	var field = document.getElementById('con' + fieldid+'_value');
	if (box.checked) {
		if (field.value) {
			field.value = field.value + ',' + box.value;
		} else {
			field.value = box.value;
		}
	} else {
		var tempValue = field.value + ',';
		tempValue = tempValue.replace(box.value + ',','');
		field.value = tempValue.substring(0,tempValue.length-1);
	}
}
        Ext.onReady(function() {

            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
        });
    </script>
  </head>
  <body>


<div id="pagemenubar"></div>
<!--页面菜单结束-->
<%

		ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");
		FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
		List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid(reportid);
		List formfieldlist = new ArrayList();
        Iterator it = reportSearchfieldList.iterator();
        String checkfieldList="";
       StringBuffer directscript=new StringBuffer();
        while(it.hasNext()){
			Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
			String formfieldid = reportsearchfield.getFormfieldid();
            String isfill=reportsearchfield.getIsfillin();
            Formfield formfield = formfieldService.getFormfieldById(formfieldid);
            if(StringHelper.isEmpty(isfill)||isfill.equals("0"))
            {
               formfield.setFillin("0");
            }
            else
            {
               formfield.setFillin("1");
            }

			formfieldlist.add(formfield);
		}
			
			
		DataService	dataService = new DataService();
String[] checkcons = request.getParameterValues("check_con");

//得到初命使查询条件：
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(contemplateid!=null&&!"".equals(contemplateid)&&fieldsearchMap==null){
    Contemplate contemplate=contemplateService.getContemplate(contemplateid);
    if(contemplate.getTempmap()!=null&&!"".equals(contemplate.getTempmap()))
    fieldsearchMap = StringHelper.string2Map(contemplate.getTempmap().substring(1,contemplate.getTempmap().length()-1),",");
}

String isshow = "";
String fieldopt = "";
String fieldopt1 = "";
String fieldvalue = "";
String fieldvalue1 = "";
String fieldvalueck="";	
%>
<FORM NAME=EweaverForm STYLE="margin-bottom:0" action="<%=action %>" method="post" >
<%
//保存初使带入的参数

String initquerystr = StringHelper.null2String(request.getParameter("initquerystr"));

if(StringHelper.isEmpty(initquerystr)){
	String querystring = StringHelper.null2String(request.getQueryString());
	
	int conindex = querystring.indexOf("&con");
	if(conindex != -1){
		initquerystr = querystring.substring(conindex);
	}
}

//隐藏初使查询条件
  boolean ishiddencon=true;
String[] convalue = initquerystr.split("&");
for(int i=0; i < convalue.length; i++){
	String tempcon = convalue[i];
	if(!StringHelper.isEmpty(tempcon)){
		String[] conv = tempcon.split("=");
		String con = conv[0];
		String vle = "";
		if(conv.length==2){
			vle = conv[1];
		}
        Iterator fielditcon = formfieldlist.iterator();
        while(fielditcon.hasNext()){
           Formfield formfield = (Formfield)fielditcon.next();
           	String id = formfield.getId();
            if(con.equals("con"+id+"_value")){
                ishiddencon=false;
            }
        }
		%>
         <%if(ishiddencon){%>
		<input type='hidden' name="<%=con %>" value="<%=vle %>">

		<%  }
	}
}
%>

<input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">

<input type=hidden name="reportid" value="<%=reportid%>">
<input type=hidden name="contempname" value="">
<input type=hidden name="ispublic" value="">
<input type="hidden" name="docCategoryid" value="<%=docCategoryid%>">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10"> 
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


  <table width=100% class=viewform>
  <b><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003b")%></b> <!-- 报表条件 -->
  <colgroup>
	<col width="25%"> 
	<col width="75%">
  
  <%
  if(false){
  %>
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881ec0cbb8cc8010cbbf030f8002d")%></td>
   		<td class="FieldValue">
   			<select name=isfinished><!-- isfinished-->
   				<option value="-1"></option> 
   				<%
   					if(fieldsearchMap!=null){
   						fieldvalue = (String)fieldsearchMap.get("conisfinished_value");
   					}
   				%>
   				<option value="1" <%if(StringHelper.null2String(fieldvalue).equals("1")){%> selected <%}%>><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option> 
   				<option value="0" <%if(StringHelper.null2String(fieldvalue).equals("0")){%> selected <%}%>><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
   			</select> 
   		</td>
     </tr>
    <%
  }
int linecolor=0;

int tmpcount = 0;
boolean showsep = true;

Iterator fieldit = formfieldlist.iterator();
while(fieldit.hasNext()){
    String msg="";
	Formfield formfield = (Formfield)fieldit.next();

	tmpcount += 1;
	String id = formfield.getId();
	 if(formfield.getFillin().equals("1"))
      {
       msg="<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>";
      }
	

	if(fieldsearchMap != null){
		fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
		fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
		fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
		fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");
		fieldvalueck=(String)fieldsearchMap.get("con"+ id + "_checkbox");
		
    }else{
		isshow = StringHelper.null2String(request.getParameter("con" + id + "_isshow"));
		fieldopt = StringHelper.null2String(request.getParameter("con" + id + "_opt"));
		fieldvalue = StringHelper.null2String(request.getParameter("con" + id + "_value"));
		fieldopt1 = StringHelper.null2String(request.getParameter("con" + id + "_opt1"));
		fieldvalue1 = StringHelper.null2String(request.getParameter("con" + id + "_value1"));
		fieldvalueck = StringHelper.null2String(request.getParameter("con" + id + "_checkbox"));
	}
	
	if(isshow.equals("0")){//定义查询列隐藏

		isshow = "display:'none'";
	}
%>

<tr class=title style="<%=isshow %>">
    <%
String htmltype = String.valueOf(formfield.getHtmltype());
String type = formfield.getFieldtype();

		String _fieldid = StringHelper.null2String(formfield.getId());
		String _formid = StringHelper.null2String(formfield.getFormid());
		String _fieldname = StringHelper.null2String(formfield.getFieldname());
		String _htmltype = StringHelper.null2String(formfield.getHtmltype());
		String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
		String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
		String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
		String _style ="";
		String _value="";
		
		String htmlobjname = _fieldid;
%>
    <td  class="FieldName" nowrap> 
<%
String name = formfield.getFieldname();
name = "d."+name;
Reportfield reportfield = reportfieldService.getReportfieldByFormFieldId(reportid, formfield.getId());
String label;
if(reportfield != null && reportfield.getId() != null){
	label = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
}else{
	label = labelCustomService.getLabelNameByFormFieldForCurrentLanguage(formfield);
}
%>
<%=StringHelper.null2String(label)%> 
    <%
if(htmltype.equals("1")){
	if(type.equals("1")){//文本
	if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value";
       else
       checkfieldList+=",con"+ id + "_value";
      }
%>
    <td  class="FieldValue"> 
      <input type=text class=inputstyle2 size=30 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>/><span id="con<%=id%>_valuespan"><%=msg%></span>
    </td>
   <%
   }else if(type.equals("2")){//整数
       if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
%>
    <td  class="FieldValue"> 

      <input type=text class=inputstyle2 size=12 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> ><span id="con<%=id%>_valuespan"><%=msg%></span>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->

      <input type=text class=inputstyle2 size=12 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%> ><span id="con<%=id%>_valuespan"><%=msg%></span>
    </td>
    <%
   }
   else if(type.equals("3")){//浮点数

   if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
   
   %>
    <td  class="FieldValue"> 
      <input type=text class=inputstyle2 size=12 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> >
      <input type=text class=inputstyle2 size=12 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()' <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value1','con<%=id%>_valuespan')"<%}%>><span id="con<%=id%>_valuespan"><%=msg%></span>
    </td>
    <%
   
   }
   else if(type.equals("4")||type.equals("6")){//日期
	   String fieldcheck = "";
   		fieldcheck = formfield.getFieldcheck();
     if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value"+",con"+ id + "_value1";
       else
       checkfieldList+=",con"+ id + "_value"+",con"+ id + "_value1";
      }
   %>
			<td  class="FieldValue"> 

       			<input type=text class=inputstyle size=10 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker(<%=fieldcheck %>)">
                    -
                <input type=text class=inputstyle size=10 name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker(<%=fieldcheck %>)">        
       		 </td>

    <%
   }
   else if(type.equals("5")){//时间
	 String fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
   	 if(fieldcheck.equals("")){
   		 fieldcheck="{startDate:'%H:00:00',dateFmt:'H:mm:ss'}";
   	 }
     if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }      StringBuffer sb = new StringBuffer("");
		sb.append("<td width=15% class='FieldValue' nowrap>");
         sb.append("<input type=\"text\" class=inputstyle size=10 name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\" onclick=\"WdatePicker("+fieldcheck+")\"  >");
        sb.append("</td>");
   		out.print(sb.toString());
   }
     %>
<%}
else if(htmltype.equals("2")){//多行文本
     if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value";
       else
       checkfieldList+=",con"+ id + "_value";
      }
%>

    <td colspan=3  class="FieldValue"> 
      <TEXTAREA ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"  <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>  ><%=StringHelper.null2String(fieldvalue)%></TEXTAREA><span id="con<%=id%>_valuespan"><%=msg%></span>
    </td>
    <%
}
else if(htmltype.equals("3")){//带格式文本


		//StringBuffer sb = new StringBuffer("");
		//sb.append("<td class='FieldValue'><input type=\"hidden\" name=\"field_"+_fieldid+"\"  value=\""+_value.replaceAll("\"","'")+"\" >");
		//sb.append("<IFRAME ID=\"eWebEditor"+_fieldid+"\" src=\"/plugin/ewe/ewebeditor.htm?id=field_"+_fieldid+"&style=eweaver\" frameborder=\"0\" scrolling=\"no\" "+_style+"></IFRAME></td>");
		//out.print(sb.toString());		
}

else if(htmltype.equals("4")){//check框

  if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ id + "_value";
       else
       checkfieldList+=",con"+ id + "_value";
      }
%>

    <td  class="FieldValue"> 
			<INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldvalue).equals("1")){%> checked <%}%>  <%if(formfield.getFillin().equals("1")){%>onChange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%> onclick="gray(this)" ><span id="con<%=id%>_valuespan"><%=msg%></span>
    </td>

    <%}
    
else if(htmltype.equals("5")){//选择项

        if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
			SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
			List list = selectitemService.getSelectitemList(type,null);
			StringBuffer sb = new StringBuffer("");
			
			//系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
            if("402881e80c33c761010c33c8594e0005".equals(formid) || "402881e50bff706e010bff7fd5640006".equals(formid)){
           	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
           	 if(_field!=null){
           	 	_fieldcheck = _field.getId();
           	 }
            }
			
			sb.append("<input type=\"hidden\" name=\"field_"
							+ _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
              if(formfield.getFillin().equals("1"))
              {
            sb.append("<td class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+"  onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +"),checkInput('con"+_fieldid+"_value','con"+_fieldid+"_valuespan')\"  >");

              }
              else{
                sb.append("<td class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+"  onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\"  >");
              }
          String _isempty = "";
			if(StringHelper.isEmpty(fieldvalue))
				_isempty = " selected ";
			sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
			for(int i=0;i<list.size();i++){
				Selectitem _selectitem = (Selectitem)list.get(i);  
				String _selectvalue = StringHelper.null2String(_selectitem.getId());
				String _selectname = labelCustomService.getLabelNameBySelectitemForCurrentLanguage(_selectitem);
				String selected = "";
				if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
					selected = " selected ";
				sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
			}	
			sb.append("</select> ");
        sb.append("<span id='con"+_fieldid+"_valuespan'>");
					if (formfield.getFillin().equals("1"))
                      {
                          sb.append("<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>");
                      }
                    sb.append("</span>");
             sb.append("</td>");
            out.print(sb.toString());

}
else if(htmltype.equals("6")){ // 关联选择

       if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
        RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
			Refobj refobj = refobjService.getRefobj(type);
			if(refobj != null){
				String _refid = StringHelper.null2String(refobj.getId());
				String _refurl = StringHelper.null2String(refobj.getRefurl());
				String _viewurl = StringHelper.null2String(refobj.getViewurl());
				String _reftable = StringHelper.null2String(refobj.getReftable());
				String _keyfield = StringHelper.null2String(refobj.getKeyfield());
				String _viewfield = StringHelper.null2String(refobj.getViewfield());
				String showname = "";   
                 int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
                 String _selfield=StringHelper.null2String(refobj.getSelfield());
                 _selfield=StringHelper.getEncodeStr(_selfield);
                if(!StringHelper.isEmpty(fieldvalue)){
					String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
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
				
				
				String checkboxstr = "";
				if(StringHelper.null2String(fieldvalueck).equals("1"))
					checkboxstr = "checked";
				if("orgunit".equals(_reftable)){
					checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+checkboxstr+">";
				}
				StringBuffer sb = new StringBuffer("");

                sb.append("<td class='FieldValue'> ");
                if(isdirect==1)
                {
                  //加一个用于提示的文本框
                    if (!StringHelper.isEmpty(_selfield)) {
                	    _selfield = _selfield.replaceAll("\r\n"," ");
					}
                    sb.append("<input type=text class=\"InputStyle2\" name="+_fieldid+" id="+_fieldid+" onfocus=\"checkdirect(this)\">");
                    directscript.append(" $(\"#"+_fieldid+"\").autocomplete(\""+request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable="+_reftable+"&viewfield="+_viewfield+"&selfield="+_selfield+"&keyfield="+_keyfield+"\", {\n" +
                                         "\t\twidth: 260,\n" +
                                                    "        max:15,\n" +
                                                    "        matchCase:true,\n" +
                                                    "        scroll: true,\n" +
                                                    "        scrollHeight: 300,          \n" +
                                                    "        selectFirst: false});");


                                 directscript.append("\n" +
                                     "                             $(\"#"+_fieldid+"\").result(function(event, data, formatted) {\n" +
                                     "                                     if (data)\n" +
                                     "                                         document.getElementById('con"+_fieldid+"_value').value=data[1];\n" +
                                     "                                 });");

                }
                String fieldCheck = formService.parserRefParam(new HashMap(), formfield.getFieldcheck());
                fieldCheck = StringHelper.replaceString(fieldCheck, "'", "%27");
                sb.append("\n\r<button  class=Browser type=button onclick=\"getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+fieldCheck+"','"+_viewurl+"','0');\"></button>");
				 if(isdirect==1)
                 {  //用于存放所输入文本对应的id
                  sb.append("\n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 }
                else{
                sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");

                 }
                sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
				sb.append(showname);
                sb.append(msg);
                sb.append("</span>\n\r").append(checkboxstr).append("</td> ");

                out.print(sb.toString());
				
			}
} 
else if(htmltype.equals("7")){ //附件
            if(formfield.getFillin().equals("1"))
      {
       if(checkfieldList.equals(""))
       checkfieldList+="con"+ _fieldid + "_value";
       else
       checkfieldList+=",con"+ _fieldid + "_value";
      }
            AttachService attachService = (AttachService) BaseContext.getBean("attachService");
			StringBuffer sb = new StringBuffer("");
			sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
			if(!StringHelper.isEmpty(_value)){
				Attach attach = attachService.getAttach(_value);
				String attachname = StringHelper.null2String(attach.getObjname());
				sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
			}
			sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" onchange=checkInput('con"+_fieldid+"file','con"+_fieldid+"span')>");
           sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
            if(formfield.getFillin().equals("1"))
             sb.append(msg);
                  sb.append("</span>\n\r");
                    sb.append("\n\r</td> ");
			out.print(sb.toString());

}
else if(htmltype.equals("8")){//checkbox（多选）
	 if(formfield.getFillin().equals("1"))
    {
     if(checkfieldList.equals(""))
     checkfieldList+="con"+ _fieldid + "_value";
     else
     checkfieldList+=",con"+ _fieldid + "_value";
    }
	 StringBuffer sb = new StringBuffer("");
	 sb.append("<td class=\"FieldValue\" width=15% nowrap> \n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\"");
	 if(fieldvalue!=null){
		 sb.append(fieldvalue);
	 }
	 sb.append("\" >");
	 String sql = "select id,objname from selectitem where isdelete=0 and typeid=(select fieldtype from formfield where id='"+_fieldid+"')";
	 List list = dataService.getValues(sql);
	 Iterator boxit= list.iterator();
	 while(boxit.hasNext()){
		 Map map = (Map)boxit.next();
		 String boxid = (String)map.get("id");
		 String boxname = (String)map.get("objname");
		 sb.append("<input type='checkbox' ");
		 if(fieldvalue!=null&&fieldvalue.indexOf(boxid)!=-1){
	 		sb.append(" checked=\"checked\" ");
	 	}
		 sb.append(" name='"+boxid+"' id='"+boxid+"' value='"+boxid+"' onclick=javascript:onClickMutiBox(this,'"+_fieldid+"') ><label style='padding:0 10 0 2;'>"+boxname+"</label>");
	 }
	 sb.append("</td>");
	 out.print(sb.toString()); 
} 
%>
    </tr>
    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>
  </table>
  	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</FORM>
  <script type="text/javascript">
      var inputid;
      var spanid;
      var temp;
     function checkdirect(obj)
  {
      inputid=obj.id;
      spanid=obj.name;
      temp=0;
  }
      var $j = jQuery.noConflict();
      $j(document).ready(function($){
              <%=directscript%>
         $.Autocompleter.Selection = function(field, start, end) {
             if( field.createTextRange ){
              var selRange = field.createTextRange();
              selRange.collapse(true);
              selRange.moveStart("character", start);
              selRange.moveEnd("character", end);
              selRange.select();
              if(inputid==undefined||spanid==undefined)
                 return;
               var len=field.value.indexOf("  ");
                 var lenspance=field.value.indexOf(" ");
                   if(temp==0&&len>0){
                   temp=1;
               var  length=field.value.length;

               var data=field.value;

              document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
             document.getElementById('con'+spanid+'span').innerHTML= data.substring(len,length);
                   }else if(temp==0&&lenspance>0){

                 var data=field.value;

              document.getElementById(inputid).value=data;
             document.getElementById('con'+spanid+'span').innerHTML= data;

                   }else{
                       document.getElementById(inputid).value="";
                   }
       } else if( field.setSelectionRange ){
              field.setSelectionRange(start, end);
          } else {
                 if( field.selectionStart ){
                  field.selectionStart = start;
                  field.selectionEnd = end;
              }
          }
          field.focus();
      };

       });
   var win;
  
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

      function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
  </script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
</BODY></HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function onSubmit(){
	if("docbaseAction"=="<%=toaction%>"){
		document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search";
	}
    checkfields='<%=checkfieldList%>';//填写必须输入的input name，逗号分隔
    checkmessage="<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220039")%>";//必输项不能为空
    if(checkForm(EweaverForm,checkfields,checkmessage)){
	  		/*if(issave == 1)
  				document.all("issave").value = "1";
	  		if(issave == 3)
  				document.all("isundo").value = "1";
	  		*/

	   		document.EweaverForm.submit();
	  }
}

function onSubmit2(){
	if("docbaseAction"!="<%=toaction%>"){
		document.EweaverForm.action+="&contemplateid=<%=contemplateid%>&iscontemplate=1";
	}
   	document.EweaverForm.submit();
}

function onSysSubmit(){
	document.EweaverForm.action = "<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search";
	document.EweaverForm.submit();
}

function savecondition(){
	SaveTemplate_onclick();
}
function showtemplate(){
	document.EweaverForm.action="<%=tmpaction %>";
	document.EweaverForm.target="";   
    document.EweaverForm.submit();
}
function fillotherselect(elementobj,fieldid,rowindex){
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值
	var objname = "field_"+fieldid+"_fieldcheck";
	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)
	if(fieldcheck=="")
		return;
		
//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql ="<%=SQLMap.getSQLString("workflow/report/reportsearch.jsp")%>";
	DataService.getValues(sql,{          
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);
   	
}
   function back(reportid){
  		location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>&reportid="+reportid;
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
                 /*var duty=document.getElementById("con"+select_array[loop]+"_value");

                var oOption = document.createElement("OPTION");
                duty.options.add(oOption);
                oOption.innerText ="";
		      oOption.value = "0";*/
            DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
            fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
//-->
</SCRIPT>
