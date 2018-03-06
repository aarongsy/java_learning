<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
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
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%
String reportid = "4028801111bdd00d0111bdd73e060006";
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");

List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getBrowserReportfieldList(reportid);
}
String userid = currentuser.getId();
int maxselected = 100;

String idslimited = StringHelper.null2String(request.getParameter("idslimited"));	//限定选择范围(?,?,?)　调用browser时传入


String idsin = StringHelper.null2String(request.getParameter("idsin"));	//已选中id(?,?,?)　调用browser时传入


String idsselected = StringHelper.null2String(request.getAttribute("idsselected"));	//已选中id(?,?,?)　搜索后传回


if(!idsin.equals("")){
	idsselected = idsin;
}

if(idsselected.equals("0"))
	idsselected = "";
String namesselected = "";	//已选中名称(?,?,?)
%>
<html>
  <head>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>

  </head> 
  <body>
     
     
<!--页面菜单开始-->     
<%
paravaluehm.put("{reportid}",reportid);
pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";

//PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
//pagemenustr += _pagemenuService2.getPagemenuStr(reportid,paravaluehm);


String	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&pagesize=100000&from=list&browserm=1&reportid=" + reportid;
String	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&pagesize=100000&reportid=" + reportid;


%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

 	<form action="<%=action%>" name="EweaverForm" method="post" target="frame2">
<%
//隐藏初使查询条件
String initsqlwhere = StringHelper.null2String(request.getAttribute("initsqlwhere"));
String initquerystr = StringHelper.null2String(request.getAttribute("initquerystr"));
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
		%>
		<input type='hidden' name="<%=con %>" value="<%=vle %>">
		<%
	}
}
%>
<input type='hidden' name="sqlwhere" id="sqlwhere" value="<%=initsqlwhere %>">
<input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">
<!--  ***************************************************************************************************************************-->
   <input type="hidden" name="idslimited" value="<%=StringHelper.null2String(request.getAttribute("idslimited"))%>"/>
   <input class=inputstyle2 type="hidden" name="idsselected" value="<%=idsselected%>">
   <input class=inputstyle2 type="hidden" name="namesselected" value="<%=namesselected%>">
   <input class=inputstyle2 type="hidden" name="userid" value="<%=userid%>">
   <input class=inputstyle2 type="hidden" name="customizegroupname" >
   <input class=inputstyle2 type="hidden" name="resourcegroup" >

<%

ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");

List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
List formfieldlist = new ArrayList();
Iterator it = reportSearchfieldList.iterator();
while(it.hasNext()){

	Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
	String formfieldid = reportsearchfield.getFormfieldid();
	Formfield formfield = formfieldService.getFormfieldById(formfieldid);
	formfieldlist.add(formfield);
}


DataService	dataService = new DataService();
String[] checkcons = request.getParameterValues("check_con");

//得到初使查询条件：

Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
if(descorasc.equals("desc")){
	descorasc = "asc";
}else{
	descorasc = "desc";
}
String fieldopt = "";
String fieldopt1 = "";
String fieldvalue = "";
String fieldvalue1 = "";
 %>

  <table width=100% class=viewform>
    <%
int linecolor=0;

int tmpcount = 0;
boolean showsep = true;

Iterator fieldit = formfieldlist.iterator();

while(fieldit.hasNext()){
	Formfield formfield = (Formfield)fieldit.next();
	String id = formfield.getId();
	if(fieldsearchMap != null){
		fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
		fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
		fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
		fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");
	}

	if(tmpcount%3==0){
%>
<tr class=title >
    <%
	}
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
String label = formfield.getLabelname();
%>
      <%=StringHelper.null2String(label)%>
    <%
if(htmltype.equals("1")){
	if(type.equals("1")){//文本
%>
    <td  class="FieldValue" nowrap>
      <input type=text class=inputstyle2 size=12 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
    </td>
   <%
   }else if(type.equals("2")){//整数
%>
    <td  class="FieldValue" nowrap>
      <input type=text class=inputstyle2 size=5 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--到--
      <input type=text class=inputstyle2 size=5 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
    </td>
    <%
   }
   else if(type.equals("3")){//浮点数



   %>
    <td  class="FieldValue" nowrap>
      <input type=text class=inputstyle2 size=5 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>--到--
      <input type=text class=inputstyle2 size=5 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
    </td>
    <%

   }
   else if(type.equals("4")){//日期

   %>
			<td  class="FieldValue" nowrap>
       			<button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('con<%=id%>_value','con<%=id%>_valuespan','0')"></button>&nbsp;
       			<span id="con<%=id%>_valuespan" ><%=StringHelper.null2String(fieldvalue)%></span>-&nbsp;&nbsp;
       			<input type=hidden name="con<%=id%>_value" value="" value="<%=StringHelper.null2String(fieldvalue)%>">
       			<button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('con<%=id%>_value1','con<%=id%>_value1span','0')"></button>&nbsp;
       			<span id="con<%=id%>_value1span" ><%=StringHelper.null2String(fieldvalue1)%></span>
       			<input type=hidden name="con<%=id%>_value1" value="" value="<%=StringHelper.null2String(fieldvalue1)%>">
       		 </td>

    <%
   }
   else if(type.equals("5")){//时间
   		StringBuffer sb = new StringBuffer("");
		sb.append("<td class='FieldValue' nowrap>\n\r <button  type=button class=Calendar onclick=\"javascript:gettime('con"+_fieldid+"_value','con"+_fieldid+"_valuespan','0');\"></button>");
		sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
		sb.append("\n\r<span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\" >");
		sb.append(StringHelper.null2String(fieldvalue));
		sb.append("</span>\n\r</td>");
   		out.print(sb.toString());
   }
     %>
<%}
else if(htmltype.equals("2")){//多行文本
%>
    <td  class="FieldValue" nowrap>
      <select class=inputstyle2 name="con<%=id%>_opt" style="width:100%" >
        <option value="3"  <%if(StringHelper.null2String(fieldopt).equals("3")){%> selected <%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002c")%></option><!-- 包含 -->
        <option value="1"  <%if(StringHelper.null2String(fieldopt).equals("1")){%> selected <%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002d")%></option><!--  等于-->
        <option value="2"  <%if(StringHelper.null2String(fieldopt).equals("2")){%> selected <%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002e")%></option><!-- 不等于 -->
        <option value="4"  <%if(StringHelper.null2String(fieldopt).equals("4")){%> selected <%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a002f")%></option><!-- 不包含 -->
      </select>
    </td>
    <td colspan=3  class="FieldValue" nowrap>
      <TEXTAREA NAME="" ROWS="" COLS="50" name="con<%=id%>_value" value=<%=StringHelper.null2String(fieldvalue)%>></TEXTAREA>
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


%>

    <td  class="FieldValue" nowrap>
			<INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldopt).equals("1")){%> checked <%}%> onclick="gray(this)">
    </td>

    <%}

else if(htmltype.equals("5")){//选择项


			List list = selectitemService.getSelectitemList(type,null);
			StringBuffer sb = new StringBuffer("");
			sb.append("<input type=\"hidden\" name=\"field_"
							+ _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
			sb.append("<td class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+">");
			String _isempty = "";
			if(StringHelper.isEmpty(fieldvalue))
				_isempty = " selected ";
			sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
			for(int i=0;i<list.size();i++){
				Selectitem _selectitem = (Selectitem)list.get(i);
				String _selectvalue = StringHelper.null2String(_selectitem.getId());
				String _selectname = StringHelper.null2String(_selectitem.getObjname());
				String selected = "";
				if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
					selected = " selected ";
				sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
			}
			sb.append("</select>\n\r</td> ");
			out.print(sb.toString());

}
else if(htmltype.equals("6")){ // 关联选择

			Refobj refobj = refobjService.getRefobj(type);
			if(refobj != null){
				String _refid = StringHelper.null2String(refobj.getId());
				String _refurl = StringHelper.null2String(refobj.getRefurl());
				String _viewurl = StringHelper.null2String(refobj.getViewurl());
				String _reftable = StringHelper.null2String(refobj.getReftable());
				String _keyfield = StringHelper.null2String(refobj.getKeyfield());
				String _viewfield = StringHelper.null2String(refobj.getViewfield());

				String showname = "";
				if(!StringHelper.isEmpty(fieldvalue)){
					String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
					List valuelist = dataService.getValues(sql);

					Map tmprefmap = null;
					String tmpobjname = "";
					String tmpobjid = "";

					for(int i=0;i<valuelist.size();i++){
						tmprefmap = (Map)valuelist.get(i);
						tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
						try{
							tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
						}catch(Exception e){
							tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
						}

						if(!StringHelper.isEmpty(_viewurl)){//以里面定义为主

							showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
							showname += tmpobjname;
							showname += "</a>";

						}else{
							if(i==valuelist.size()-1){
								showname += tmpobjname;
							}else{
								showname += tmpobjname + ", ";
							}
						}
					}
				}


				String checkboxstr = "";
				if("orgunit".equals(_reftable)){
					String checked = "";
					if(fieldsearchMap!=null && StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
						checked = "checked";
					}
					checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
				}
				StringBuffer sb = new StringBuffer("");
				sb.append("<td class='FieldValue'> \n\r<button  type=button class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
				sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
				sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
				sb.append(showname);

				sb.append("</span>\n\r").append(checkboxstr).append("</td> ");
				out.print(sb.toString());

			}
}
else if(htmltype.equals("7")){ //附件
			StringBuffer sb = new StringBuffer("");
			sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
			if(!StringHelper.isEmpty(_value)){
				Attach attach = attachService.getAttach(_value);
				String attachname = StringHelper.null2String(attach.getObjname());
				sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
			}
			sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" >\n\r</td> ");
			out.print(sb.toString());

}

 if(linecolor==0) linecolor=1;
          else linecolor=0;
    tmpcount += 1;
}
%>
  </table>


    </form>
<script language="javascript" type="text/javascript">
   function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
   } 
function createexcel(){
   	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
	document.EweaverForm.submit();
}

function onSearch2(){
   	document.EweaverForm.action="<%=action2%>";
	document.EweaverForm.submit();
}

function onSearch3(){
   	document.EweaverForm.action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
	document.EweaverForm.submit();
}

//点击按列排序
function listorder(input){
   	document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
	document.EweaverForm.submit();
}
    function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态
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
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    param = parserRefParam(inputname,param);
	idsin = document.all(inputname).value;
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id="+refid+"&"+param+"&idsin="+idsin);
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
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>

