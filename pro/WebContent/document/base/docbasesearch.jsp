<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.orgunit.service.*"%>
<%@ page import="com.eweaver.document.doctype.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
Selectitem selectitem = null;
String clear=StringHelper.null2String(request.getParameter("clear"));
String subject="";
String objno="";
String categoryid="";
String andor="";
String doctypeid="";
String author="";
String docstatus="";
String modifier="";
String creator="";
String modifydatefrom="";
String modifydateto="";
String createdatefrom="";
String createdateto="";
String orgunitid="";
if(clear.equals("true")){
     request.getSession().setAttribute("docQueryFilter",null);
}
Map docQueryFilter = (Map)request.getSession().getAttribute("docQueryFilter");
if(docQueryFilter!=null){
	if (docQueryFilter.get("objno")!=null) objno = (String)docQueryFilter.get("objno");
	if (docQueryFilter.get("subject")!=null) subject = (String)docQueryFilter.get("subject");
	if (docQueryFilter.get("typeid")!=null) doctypeid = (String)docQueryFilter.get("typeid");
	if (docQueryFilter.get("categoryid")!=null) categoryid = (String)docQueryFilter.get("categoryid");
	if (docQueryFilter.get("modifydatefrom")!=null) modifydatefrom = (String)docQueryFilter.get("modifydatefrom");
	if (docQueryFilter.get("andor")!=null) andor = ""+docQueryFilter.get("andor");
	if (docQueryFilter.get("author")!=null) author = (String)docQueryFilter.get("author");
	if (docQueryFilter.get("docstatus")!=null) docstatus = ""+docQueryFilter.get("docstatus");
	if (docQueryFilter.get("modifier")!=null) modifier = (String)docQueryFilter.get("modifier");
	if (docQueryFilter.get("creator")!=null) creator = (String)docQueryFilter.get("creator");
	if (docQueryFilter.get("modifydateto")!=null) modifydateto = (String)docQueryFilter.get("modifydateto");
	if (docQueryFilter.get("createdatefrom")!=null) createdatefrom = (String)docQueryFilter.get("createdatefrom");
	if (docQueryFilter.get("createdateto")!=null) createdateto = (String)docQueryFilter.get("createdateto");
	if (docQueryFilter.get("orgunitid")!=null) orgunitid = (String)docQueryFilter.get("orgunitid");
}
%>
<html>
  <head>
  </head>
  <body>
  <!-- 标题 -->
  <%titlename=labelService.getLabelName("402881eb0bd712c6010bd7306968000f");%>
  <%@ include file="/base/toptitle.jsp"%>
  
<!--页面菜单开始-->   
<%
pagemenustr += "{D,清空条件,javascript:location.href='"+request.getContextPath()+"/document/base/docbasesearch.jsp?clear=true'}";
%>   
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=search&from=search" name="EweaverForm" method="post">
    <table width="100%">
     <colgroup>
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">
     <tbody>
     <tr class=Title>
        <th colspan=4><%=labelService.getLabelName("402881e70b7728ca010b772e24f50009")%></th>
     </tr>
     <tr>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71b621f0003")%></td>
       <td class="FieldValue"><input name="objno" value="<%=objno%>"></td>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71c27e80004")%></td>
       <td class="FieldValue"><input name="subject" value="<%=subject%>">
       		<select name="andor">
       			<option value = 'and' <%if(andor.equals("and")){%> selected <%}%> >AND</option>
       			<option value = 'or' <%if(andor.equals("or")){%> selected <%}%> >OR</option>
       		</select>
       </td>
     </tr>
     <tr>
<%
	String categoryname="";
	if(!StringHelper.isEmpty(categoryid)){
	   if(categoryService.getCategoryNameStrByCategory(categoryid)!=null){
	   		 categoryname=StringHelper.null2String(categoryService.getCategoryPath(categoryid,null,null));
		}
	}
%>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda6ab3b001b")%></td>
       <td class="FieldValue">      			
          	<button class=Browser onclick="getBrowser('/ServiceAction/com.eweaver.base.category.servlet.CategoryAction?action=searchm&model=docbase','categoryid','categoryidspan','0');"></button>
            <span id="categoryidspan"><%=categoryname%></span>
            <input type="hidden" name="categoryid" value="<%=categoryid%>"/>	
       </td>
<%
String doctypename="";

%>
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%></td><!--文档类型 -->
       <td class="FieldValue">
       		<input type="hidden" name="doctypeid" value="<%=doctypeid%>"/>       			
          	<button  class=Browser onclick=""></button>
            <span id="doctypeidspan"><%=doctypename%></span>
       </td>
     </tr>
     <tr>
<%			
	Humres humres=null;
	String humresname="";			     
     if(!StringHelper.isEmpty(author)){
		humres=humresService.getHumresById(author);
		if(humres!=null){
			humresname=humres.getObjname();
		}
	}							
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881ee0c715de3010c71ad6d46000a")%></td>
       	<td class="FieldValue">
       		<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','author','authorspan','0');"></button>
       		<span id="authorspan"><%=humresname%></span>
       		<input type=hidden name="author" value="<%=author%>"> </td>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881e70b774c35010b774cceb80008")%></td>
   		<td class="FieldValue">
			<input type=text name="docseclevel" value="" class="InputStyle2" onKeyPress='checkInt_KeyPress()' size=2>
			---<input type=text name="docseclevel2" value="" class="InputStyle2" onKeyPress='checkInt_KeyPress()'  size=2>
   		</td>
     </tr>
     <tr>
<%			
	 humres=null;
	 humresname="";			     
     if(!StringHelper.isEmpty(modifier)){
		humres=humresService.getHumresById(modifier);
		if(humres!=null){
			humresname=humres.getObjname();
		}
	}							
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd720023f0009")%></td>
       	<td class="FieldValue">
       		<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','modifier','modifierspan','0');"></button>
       		<span id=modifierspan><%=humresname%></span>
       		<input type=hidden name=modifier value="<%=modifier%>"> 
       	</td>
<%			
	 humres=null;
	 humresname="";			     
     if(!StringHelper.isEmpty(creator)){
		humres=humresService.getHumresById(creator);
		if(humres!=null){
			humresname=humres.getObjname();
		}
	}							
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
      	<td class="FieldValue">
       		<button class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
	       	<span id=creatorspan><%=humresname%></span>
	       	<input type=hidden name=creator value="<%=creator%>"> 
	    </td>
     	</tr>
       <tr>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd721dd76000b")%></td>
	       	<td class="FieldValue" align=left>
	       		<button class="Calendar" id=SelectDate  onclick="javascript:getdate('modifydatefrom','doclastmoddatefromspan','0')"></button>&nbsp; 
	       		<span id=doclastmoddatefromspan><%=modifydatefrom%></span>-&nbsp;&nbsp;
	       		<button class="Calendar" id=SelectDate2 onclick="javascript:getdate('modifydateto','doclastmoddatetospan','0')"></button>&nbsp;
	       		<span id=doclastmoddatetospan><%=modifydateto%></span>
	       		<input type=hidden name="modifydatefrom" value="<%=modifydatefrom%>">
	       		<input type=hidden name="modifydateto" value="<%=modifydateto%>"> 
	       	</td>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<button class="Calendar" id=SelectDate  onclick="javascript:getdate('createdatefrom','createdatefromspan','0')"></button>&nbsp; 
       			<span id=createdatefromspan><%=createdatefrom%></span>-&nbsp;&nbsp;
       			<button class="Calendar" id=SelectDate2 onclick="javascript:getdate('createdateto','createdatetospan','0')"></button>&nbsp; 
       			<span id=createdatetospan><%=createdateto%></span>
       			<input type=hidden name="createdatefrom" value="<%=createdatefrom%>"> 
       			<input type=hidden name="createdateto" value="<%=createdateto%>"> </td>
	   </tr>
	   <tr>
<%
	 Orgunit orgunit=null;
		String orgname="";
		if(!StringHelper.isEmpty(orgunitid)){
			orgunit=orgunitService.getOrgunit(orgunitid);
			if(orgunit!=null){
			orgname=StringHelper.null2String(orgunit.getObjname());
			
			}
		}
%>
					<td class="FieldName" nowrap>
					  <%=labelService.getLabelName("402881e30fa73306010fa79e77890883")%><!-- 组织单元-->
					</td>
					<td class="FieldValue">    
					    <button  class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','1');"></button>
						<input type="hidden"  name="orgunitid" value="<%=orgunitid%>"/>
						<span id="orgunitidspan"/><%=orgname%></span>
					</td>
					<td class="FieldName" nowrap>
						权限控制
					</td>
					<td class="FieldValue">
			       		<select name="titleper">
			       			<option value = ''></option>
			       			<option value = '1'>受控制</option>
			       			<option value = '0'>不受控制</option>
			       		</select>
					</td>	
		</tr>
       </tbody>
 </table>
   </form>
<script language="javascript">
 <!--
function onSubmit(){
  checkfields="";//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空


  if(checkForm(EweaverForm,checkfields,checkmessage)){
   	document.EweaverForm.submit();
  }
}
 -->
</script>
<script language=vbs>
sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	end if
end sub

</script>
<script type="text/javascript">
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=window.showModalDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
    </body>
</html>
