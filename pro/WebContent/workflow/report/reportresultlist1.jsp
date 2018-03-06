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
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String reportid = request.getParameter("reportid");
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
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
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

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
   	UL LI {list-style-image: url('/images/book.gif'); margin-bottom: 4}
</Style>
  <script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
  </head> 
  <body>
     
<!--页面菜单开始-->     
<%
String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=" + reportid;
paravaluehm.put("{reportid}",reportid);
pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2(),id='aaaaa'}";

PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
pagemenustr += _pagemenuService2.getPagemenuStr(reportid,paravaluehm);


if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=" + reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}

%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
 	<form action="<%=action%>" name="EweaverForm" method="post">
 	
 	
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
<%
//得到初使查询条件：

Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
Map hiddenMap = (Map)request.getAttribute("hiddenMap");
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


 %>
<%if(hiddenMap != null){
  for(Object o:hiddenMap.keySet()){
      String value=(String)hiddenMap.get(o);
%>
      <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
<%
  }
}%>
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
      <input type=text class=inputstyle2 style="width:90%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
    </td>
   <%
   }else if(type.equals("2")){//整数   
%>
    <td  class="FieldValue" nowrap> 
      <input type=text class=inputstyle2 style="width:40%" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--到--
      <input type=text class=inputstyle2 style="width:40%" name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
    </td>
    <%
   }
   else if(type.equals("3")){//浮点数


   
   %>
    <td  class="FieldValue" nowrap> 
      <input type=text class=inputstyle2 style="width:40%" name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>--到--
      <input type=text class=inputstyle2 style="width:40%" name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
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
		sb.append("<td class='FieldValue' nowrap>\n\r <button  class=Calendar onclick=\"javascript:gettime('con"+_fieldid+"_value','con"+_fieldid+"_valuespan','0');\"></button>");
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
    <td colspan=3  class="FieldValue" nowrap> 
      <TEXTAREA ROWS="" style="width:90%" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
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
			sb.append("<td class='FieldValue'>\n\r <select class=\"inputstyle2\" style=\"width:90%\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" >");
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
					if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
						checked = "checked";
					}
					if(StringHelper.null2String(fieldvalue1).equals("1")){
						checked = "checked";
					}
					checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
				}
				StringBuffer sb = new StringBuffer("");
				sb.append("<td class='FieldValue'> \n\r<button  class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
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
}%>
  </table>

<!--  ***************************************************************************************************************************-->  
  
        <table class=liststyle cellspacing=1   id="vTable">
<!--表头开始-->		  
          <tr class=Header> 
          <%
		
        it = reportfieldList.iterator();
        cols = reportfieldList.size();
        
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();  
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}
			
			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}
%>
         	<td nowrap  <%=widths%> <%=styler %>><a href="javascript:listorder('<%=formfields.getFieldname() %>');"><B><%=reportfield.getShowname()%></B></a></td>
<%
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %> 
          </tr>
<!--表头结束-->
				<%		
				
				
				if(pageObject.getTotalSize()!=0){
					List list = (List) pageObject.getResult();	
					
					Map reportdataMap = null;
					Map reportMap = null;
					rows = list.size();	
					
					
					for (int i = 0; i < list.size(); i++) {
						
						reportdataMap = new HashMap();
						reportMap = (Map)list.get(i);
				%>		

          <tr  class=datadark  > 
       <%   
       int j=0;
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			String rtxstr = "";
			Reportfield reportfield = (Reportfield) it2.next();
			String alertcon = StringHelper.null2String(reportfield.getAlertcond());

			if(!StringHelper.isEmpty(alertcon)){
				Iterator pagemenuparakeyit3 = reportMap.keySet().iterator();
				while (pagemenuparakeyit3.hasNext()) {
					String pagemenuparakey = (String)pagemenuparakeyit3.next();
					String pagemenuparakey2 = "{" + pagemenuparakey + "}";
					alertcon = StringHelper.replaceString(alertcon,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
				}
			}
			
			String formfieldid = reportfield.getFormfieldid();
			String href = reportfield.getHreflink();//报表中配置的链接，如果报表关联字段browser中已配置了链接，刚此处的链接不起作用
			Formfield formfield = formfieldService.getFormfieldById(formfieldid);

			boolean isalign = false;//数字是否右对齐

			if(formfield != null&&!StringHelper.isEmpty(formfield.getId())){
				String formfieldname = formfield.getFieldname();
				fieldvalue = StringHelper.null2String(reportMap.get(formfieldname));//对象对应的ID
				String fieldtype = formfield.getFieldtype();//字段对应类型（通过此类型得到相应对象是selectitem还是browser，从而得到对应ID的显示名）

				
				String formfieldvalue = "";//生成excel报表时用到

				
				String htmltype = "";
				if(formfield.getHtmltype()!=null){
					htmltype = formfield.getHtmltype().toString();
				}
				
				if(htmltype.equals("1")&&(fieldtype.equals("2")||fieldtype.equals("3"))){
					if(StringHelper.isEmpty(fieldvalue)){
						fieldvalue = "0";
					}
					fieldvalue = new java.text.DecimalFormat("#,##0.00").format(Double.valueOf(fieldvalue));
					isalign = true;
				}
				
				if(htmltype.equals("4")){
					if("1".equals(fieldvalue)){
						fieldvalue = "<IMG SRC='/images/bacocheck.gif' >";
					}else{
						fieldvalue = "<IMG SRC='/images/bacocross.gif' >";
					}
				}
//				System.out.println("--------isalign:" + isalign);
//				System.out.println("--------fieldvalue:" + fieldvalue + "-------htmltype:" + htmltype);
				if(htmltype.equals("5")&&!StringHelper.isEmpty(fieldvalue)){
					
					Selectitem selectitem = selectitemService.getSelectitemById(fieldvalue);
					if(selectitem!=null){
						fieldvalue = selectitem.getObjname();
						formfieldvalue = fieldvalue;
					}
				}
				
				if(htmltype.equals("6")&&!StringHelper.isEmpty(fieldvalue)){
					Refobj refobj = refobjService.getRefobj(fieldtype);
					if(refobj != null){
						String _refid = StringHelper.null2String(refobj.getId());
						String _refurl = StringHelper.null2String(refobj.getRefurl());
						String _viewurl = StringHelper.null2String(refobj.getViewurl());
						String _reftable = StringHelper.null2String(refobj.getReftable());
						String _keyfield = StringHelper.null2String(refobj.getKeyfield());
						String _viewfield = StringHelper.null2String(refobj.getViewfield());

						String showname = "";
						if(!StringHelper.isEmpty(formfieldname)){
							String reffieldid = StringHelper.null2String(reportfield.getCol1());
							String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
							//得到对象ID对应的objname
							
							if(fieldvalue.contains(",")){//如果关联字段是多值的(比如多选browser)
								sql = "select distinct " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(fieldvalue)+ ")";
							}
							

//							*******************************************************************************************************
//							如果存在关联字段
							if(!reffieldid.equals("")){
								Formfield refformfield = formfieldService.getFormfieldById(reffieldid);
								String refhtmltype = "";
								if(refformfield.getHtmltype()!=null){
									refhtmltype = refformfield.getHtmltype().toString();
								}

								String reffieldname = StringHelper.null2String(refformfield.getFieldname());
								String reffieldtype = StringHelper.null2String(refformfield.getFieldtype());
								if(refhtmltype.equals("5")){
									sql = "select a." + _keyfield + " as objid,b.objname as objname " 
									 	+ "from " + _reftable + " a,Selectitem b where a." + _keyfield + " ='" + fieldvalue + "'"
										 + " and a." + reffieldname + "=b.id";
									
									_viewurl = "";
								}else if(refhtmltype.equals("6")){
									Refobj refrefobj = refobjService.getRefobj(reffieldtype);

									String _refviewurl = StringHelper.null2String(refrefobj.getViewurl());
									String _refreftable = StringHelper.null2String(refrefobj.getReftable());
									String _refkeyfield = StringHelper.null2String(refrefobj.getKeyfield());
									String _refviewfield = StringHelper.null2String(refrefobj.getViewfield());
									
									_viewurl = _refviewurl;
								
									//存在一个字段对应多个值的情况，所以用 like 
										sql = "select distinct a." + _keyfield + " as objid,b."+ _refviewfield +" as objname " 
											 + "from " + _reftable + " a,"+ _refreftable +" b where a." + _keyfield + " ='" + fieldvalue + "'"
											 + " and a." + reffieldname + " like '%' + b.id + '%'";
											
								}else{
									sql = "select " + _keyfield + " as objid," + reffieldname + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
									_viewurl = "";
								}
							}
//							*******************************************************************************************************	

//							System.out.println("--------sql:" + sql);

							List reflist = dataService.getValues(sql);
							Map tmprefmap = null;
							String tmpobjname = "";
							String tmpobjid = "";
							for(int n=0; n< reflist.size(); n++){
								tmprefmap = (Map)reflist.get(n);
								tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
								try{
									tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
								}catch(Exception e){
									tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
								}
								
								if(StringHelper.isEmpty(href)&&!StringHelper.isEmpty(_viewurl)){//以里面定义为主

									showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
									showname += tmpobjname;
									showname += "</a>";

								}else{
									if(n==reflist.size()-1){
										showname += tmpobjname;
									}else{
										showname += tmpobjname + ", ";
									}
								}

							}
							
							if("humres".equals(_reftable)){//添加RTX在线感知
								rtxstr = humresService.getRTXHtml(tmpobjid);
							}
						}

						fieldvalue = showname;
					}			
				}
				StringBuffer fieldvalue7 = new StringBuffer("");
				if(htmltype.equals("7")&&!StringHelper.isEmpty(fieldvalue)){
					Forminfo forminfo = forminfoService.getForminfoById(formfield.getFormid());
					Attach attach = attachService.getAttach(fieldvalue);
					if(attach!=null){
						//int righttype = permissiondetailService.getAttachOpttype((String)reportMap.get("id"),forminfo.getObjtablename());
						fieldvalue = attach.getObjname();
						formfieldvalue = fieldvalue;
		
						fieldvalue7.append("<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid=")
							.append(attach.getId()).append("&download=1").append("\">").append(fieldvalue).append("</a>");
	
					}
				}
				
				reportdataMap.put(formfieldname,formfieldvalue);
				
				if(StringHelper.isEmpty(href)){
		%>	
            <td id="<%=i%>_<%=j%>" <%if(isalign){%>  align="right" <%} %>>
            	<%
            		if(htmltype.equals("7")){
            	%>
            	<%=StringHelper.null2String(fieldvalue7.toString())%>
            	<%
            		}else{
            	%>
            	<%=StringHelper.null2String(fieldvalue)%><%=rtxstr%>
            	<%}%>
            </td>
            
            
<script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>
         <%				
				
				}else{
					Iterator pagemenuparakeyit = reportMap.keySet().iterator();
					while (pagemenuparakeyit.hasNext()) {
						String pagemenuparakey = (String)pagemenuparakeyit.next();
						String pagemenuparakey2 = "{" + pagemenuparakey + "}";
						href = StringHelper.replaceString(href,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
					}

		%>	
            <td id="<%=i%>_<%=j%>" >
            
            	<%
            		if(htmltype.equals("7")){
            	%>
            	<%=StringHelper.null2String(fieldvalue7.toString())%>
            	<%
            		}else{
            	%>
            	<a href="<%=href%>" target="_bank"><%=StringHelper.null2String(fieldvalue)%></a><%=rtxstr%>
            	<%}%>
            </td>
          <script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>
         <%
         }
         }else{
         if(StringHelper.isEmpty(href)){
			%>	
	            <td></td>
	            
	         <%         
         }else{
					Iterator pagemenuparakeyit = reportMap.keySet().iterator();
					while (pagemenuparakeyit.hasNext()) {
						String pagemenuparakey = (String)pagemenuparakeyit.next();
						String pagemenuparakey2 = "{" + pagemenuparakey + "}";
						href = StringHelper.replaceString(href,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
					}
      
		%>	
            <td id="<%=i%>_<%=j%>"><a href="<%=href%>" target="_bank"><%=reportfield.getShowname() %></a></td>
<script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>           
         <%         
         }
         }
         j++;
         
         }
         reportdatalist.add(reportdataMap);
         %>   
          </tr>			

		<%
		  }
		  %>
		  <tr>
		  <% 
		 request.getSession().setAttribute("reportdatalist",reportdatalist);
		 
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			Reportfield reportfield = (Reportfield) it2.next(); 
			String formfieldid = "";
			Formfield formfield = null;
			
			if(reportfield.getIssum().toString().equals("1") && summap != null){
				formfieldid = reportfield.getFormfieldid();
				formfield = formfieldService.getFormfieldById(formfieldid);
				String allmoney = "0";
				if(summap.get("sum_"+formfield.getFieldname())!=null){
					allmoney = StringHelper.null2String(summap.get("sum_"+formfield.getFieldname()));
				}
				
		%>	
            <td  align="right"><%=new java.text.DecimalFormat("#,##0.00").format(Double.valueOf(allmoney))%></td>
            
         <%			
			
			}else{
		%>	
            <td></td>
            
         <%			
			}
		}
	}
	
	
		%>	

	   		</tr>
	   </table>
       <br>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td nowrap align=center>						
						<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
						&nbsp;
					</td>

					<td nowrap align=center>
						<button  type="button" accessKey="F" onclick="onSearch(1)">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>)">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>)">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>)">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:document.EweaverForm.submit();">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.EweaverForm.submit();">
					</td>
					<td>&nbsp;</td>
				</tr>
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
</script>

  </body>
</html>

