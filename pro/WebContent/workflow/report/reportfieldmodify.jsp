<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>

<%@ include file="/base/init.jsp"%>
<html>
  <head>
  </head>
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{B,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.history.go(-1)}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
<%
String reportid = request.getParameter("reportid");
String id = request.getParameter("id");
String formid = request.getParameter("formid");
//System.out.println("--------" + reportid +"----" +id);
ReportfieldService reportfieldService = (ReportfieldService) BaseContext.getBean("reportfieldService");

Reportfield reportfield = reportfieldService.getReportfieldById(id);
//Formfield formfield = ((FormfieldService)BaseContext.getBean("formfieldService")).getFormfieldById(reportfield.getFormfieldid());
//String formlabelname = formfield.getLabelname();
%>
 <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportfieldAction?action=modify&reportid=<%=reportid%>" name="EweaverForm"  method="post">
<input type="hidden" name="id" value="<%=StringHelper.null2String(id)%>">
  <table class=noborder>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	
	  <tr>
    	<td class="Line" colspan=100% nowrap></td>		        	  
	  </tr>	
	  
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70c919ba6010c923424cc000a")%><!-- 表单字段-->
	   </td>
	   <td class="FieldValue">
	         <button  type="button" class=Browser onclick="javascript:getBrowser2('/workflow/form/formfieldbrowser.jsp?formid=<%=formid%>','formfieldid','showname','fieldtype','formfieldidspan','1');"></button>
			 <input type="hidden"   name="formfieldid" value="<%=reportfield.getFormfieldid()%>"/>
			 <input type="hidden"   name="fieldtype"/>
			 <span id = "formfieldidspan"><%=(reportfield.getFormfieldid().equals(""))? "" : reportfield.getShowname()%></span>
		</td>
	 </tr>	
	 <%
	 	String formfieldid2 = StringHelper.null2String(reportfield.getCol1());
	 	String display = "display:'none'";
	 	if(!StringHelper.isEmpty(formfieldid2)){
	 		//display = "";
	 	}
	 %>
<!--  -->
	 <tr style="<%=display %>" id="refobject">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220007")%><!--关联表单字段 -->
	   </td>
	   <td class="FieldValue"  >
	         <button  type="button" class=Browser id="refobjectid" onclick="javascript:getBrowser3('/workflow/form/formfieldbrowser.jsp?formfieldid='+this.value,'formfieldid2','showname','fieldtype','formfieldid2span','1');"></button>
			 <input type="hidden"   name="formfieldid2"  value="<%=formfieldid2%>"/>
			 <span id = "formfieldid2span" ></span>
		</td>
	 </tr>	
<!--  -->
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc55f035001a")%><!-- 显示名称-->
			
	   </td>
	   <td class="FieldValue">
			<input name="showname" value="<%=reportfield.getShowname()%>" class="InputStyle2" style="width=95%" >
		</td>
	 </tr>	
	 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b774c35010b774d4c410009 ")%><!-- 显示顺序-->
	   </td>
	   <td class="FieldValue">
	        <input name="dsporder" value="<%=reportfield.getDsporder()%>" class="InputStyle2" style="width=95%" >
		</td>
	 </tr>	
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e30f50a062010f50b92a0d00b2")%><!-- 显示列宽-->
	   </td>
					<%
						String showwidth = "";
						if(reportfield.getShowwidth()!=null && reportfield.getShowwidth().intValue()!=-1){
							showwidth = reportfield.getShowwidth().toString();
						}
					%>
	   <td class="FieldValue">
	        <input name="showwidth" value="<%=showwidth%>" class="InputStyle2" style="width=5%" onKeyPress='checkInt_KeyPress()'>%
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70c90eb3b010c910fc4a70007 ")%><!-- 是否排序-->
	   </td>
	   <td class="FieldName" nowrap>
        <select class="inputstyle" id="isorderfield" name="isorderfield">
           <option value=0 <%=(StringHelper.null2String(reportfield.getIsorderfield()).equals("0"))?"selected":""%>></option>
           <option value=1 <%=(StringHelper.null2String(reportfield.getIsorderfield()).equals("1"))?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%></option><!-- 升序 -->
           <option value=2 <%=(StringHelper.null2String(reportfield.getIsorderfield()).equals("2"))?"selected":""%>><%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%></option><!-- 降序 -->
        </select>
		</td>
	 </tr>	 
<%
String isshow = "none";

if(reportfield.getIssum().equals("1")){
	isshow="";
}
%>
	 <tr id="sumfield" style="display:'<%=isshow%>'">
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70c90eb3b010c91106f7d000a")%><!-- 是否统计-->
	   </td>
	   <td class="FieldValue">
		<input  type='checkbox' name='issum' value="1"
		 <%if(StringHelper.null2String(reportfield.getIssum()).equals("1")){%> 
		checked 
		<%}%>
		/>
		</td>
	 </tr>	 
	    
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70c90eb3b010c91129376000d")%><!-- 链接路径-->
	   </td>
		<td class="FieldValue"><input name="hreflink" value="<%=StringHelper.null2String(reportfield.getHreflink())%>" class="InputStyle2" style="width=95%" ></td>
	 </tr>	
	 <tr>
	   <td class="FieldName" nowrap>SQL</td>
		<td class="FieldValue"><input name="sql" value="<%=StringHelper.null2String(reportfield.getCol2())%>" class="InputStyle2" style="width=95%" ></td>
	 </tr>	
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70c90eb3b010c911423ea0010")%><!-- 报警条件-->
	   </td>
		<td class="FieldValue"><input name="alertcond" value="<%=StringHelper.null2String(reportfield.getAlertcond())%>" class="InputStyle2" style="width=95%" ></td>
	 </tr>	
	 <tr>
	    <td class="FieldName" nowrap>
			Browser<!-- -->
	   </td>
	   <td class="FieldValue">
			<input  type='checkbox' name='isbrowser' value="1"
		 <%if(StringHelper.null2String(reportfield.getIsbrowser()).equals("1")){%> 
		checked 
		<%}%>
			>
		</td>
	 </tr>	
	 	 
	  <tr>
    	<td class="Line" colspan=100% nowrap></td>		        	  
	  </tr>	
	</table>     
 </form> 



<script language="javascript">
function getBrowser2(viewurl,inputname,showname,fieldtype,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        document.all(showname).value=id[1];
		document.all(fieldtype).value=id[2];
        if (id[2]=="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350048")%>" || id[2]=="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350049")%>")//整数    浮点数
			document.all("sumfield").style.display="";
		else
			document.all("sumfield").style.display="none";
        isshow = Trim(id[3])=="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003c")%>"?0:1;//关联选择

		if (isshow=="0") {
			document.all("refobject").style.display="";
			document.all("refobjectid").value=id[0];
        }else
			document.all("refobject").style.display="none";
    }else{
		document.all(inputname).value = '';
        document.all(showname).value="" ;
		document.all(fieldtype).value="" ;
        document.all("sumfield").style.display="none";
		document.all("refobject").style.display="none";
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function getBrowser3(viewurl,inputname,showname,fieldtype,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        document.all(showname).value=Trim(document.all("formfieldidspan").innerHtml) + "-->" +id[1];
		document.all(fieldtype).value=id[2];
    }else{
		document.all(inputname).value = '';
        document.all(showname).value="" ;
		document.all(fieldtype).value="" ;
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

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
function onSubmit(){
   	checkfields="";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

function check(){
	checkmessage="<%=labelService.getLabelName("402881e70caedf88010caf372e450010")%>";
   	alert(document.all("fieldtype").value);
   	if(document.all("fieldtype").value == "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350048")%>" || document.all("fieldtype").value == "<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350049")%>"){//整数   浮点数
   	alert("aa");
   		return true;
   	}else{
   	 	alert(checkmessage);
   	 	document.all("issum").value == 0;
   	 	return false;
   	}
}
 
</script> 
  </body>
</html>
