<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.humres.base.service.*"%>

<%
String sqlwhere = StringHelper.null2String((String)request.getParameter("sqlwhere"));
String categoryid=StringHelper.trimToNull(request.getParameter("categoryid"));
String doctypeid=StringHelper.trimToNull(request.getParameter("doctypeid"));
String author=StringHelper.trimToNull(request.getParameter("author"));
String createdatefrom=StringHelper.trimToNull(request.getParameter("createdatefrom"));
String createdateto=StringHelper.trimToNull(request.getParameter("createdateto"));
String doctype = StringHelper.trimToNull(request.getParameter("doctype"));
String typeid = StringHelper.trimToNull(request.getParameter("typeid"));
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
Page pageObject = (Page) request.getAttribute("pageObject");
if (pageObject == null) {
	request.getRequestDispatcher("/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=browser&categoryid="+categoryid+"&doctypeid="+doctypeid+"&author="+author+"&createdatefrom="+createdatefrom+"&createdateto="+createdateto+"&pagesize=10&isreply=0" + "&sqlwhere=" + sqlwhere).forward(request, response);
	return;
}
Map map = (Map)request.getAttribute("docQueryFilter");
if(map == null) map = new HashMap();
%>
<html>
  <head>
  </head> 
  <body>
	<%
	pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
	pagemenustr += "{Q,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
	%>
	<div id="pagemenubar" style="z-index:100;"></div> 
	<%@ include file="/base/pagemenu.jsp"%>
	<!--页面菜单结束-->
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.base.servlet.DocbaseAction?action=browser&sqlwhere=<%=sqlwhere%>" name="EweaverForm" method="post">
	<input type="hidden" name="isreply" value="0">
	 <table width="100%">
     <colgroup>
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">
     <tbody>
     <tr>
		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71c27e80004")%></td><!-- 主题-->
		<td class="FieldValue"><input name="subject" value="<%=StringHelper.null2String(map.get("subject"))%>"></td>
		<td class="FieldName" nowrap><%=labelService.getLabelName("402881ee0c715de3010c71ad6d46000a")%></td><!-- 作者-->
		<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp','author','authorspan','0');"></button>
            <span id="authorspan"><%=((HumresService) BaseContext.getBean("humresService")).getHrmresNameById(StringHelper.null2String(map.get("author")))%></span>
          	<input type="hidden" name="author" value="<%=StringHelper.null2String(map.get("author"))%>"/>
       </td>     
     </tr>
     <tr>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881e70b227478010b22783d2f0004")%></td><!-- 分类体系-->
       <td class="FieldValue">      			
          	<button type="button" class=Browser onclick="javascript:getBrowser('/base/category/categorybrowser.jsp?model=docbase','categoryid','categoryidspan','0');"></button>
            <span id="categoryidspan"><%=((CategoryService) BaseContext.getBean("categoryService")).getCategoryNameStrByCategory(StringHelper.null2String(map.get("categoryid")))%></span>
            <input type="hidden" name="categoryid" value="<%=StringHelper.null2String(map.get("categoryid"))%>"/> 	
       </td>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%></td><!-- 文档类型-->
       <td class="FieldValue">
       		<input type="hidden" name="doctypeid" value="<%=StringHelper.null2String(map.get("typeid"))%>"/>       			
          	<button  type="button" class=Browser onclick=""></button>
            <span id="doctypeidspan"></span>
       </td>
     </tr>
       <tr>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('createdatefrom','createdatefromspan','0')"></button>&nbsp; 
       			<span id=createdatefromspan></span>-&nbsp;&nbsp;
       			<button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('createdateto','createdatetospan','0')"></button>&nbsp; 
       			<span id=createdatetospan></span>
       			<input type=hidden name="createdatefrom" value="<%=StringHelper.null2String(map.get("createdatefrom"))%>"> 
       			<input type=hidden name="createdateto" value="<%=StringHelper.null2String(map.get("createdateto"))%>"> 
       		</td>
       		<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71b621f0003")%></td>
	       	<td class="FieldValue"><input name="objno" value="<%=StringHelper.null2String(map.get("objno"))%>"></td>
	   </tr>
	</tbody>
    </table>
	<table ID=BrowserTable class=BroswerStyle cellspacing=1>
<%				
	Docbase docbase =null;
	if(pageObject.getTotalSize()!=0){
		boolean isLight=false;
		String trclassname="";
		List list = (List) pageObject.getResult();		
		for (int i = 0; i < list.size(); i++) {
			isLight=!isLight;
			if(isLight) trclassname="DataLight";
			else trclassname="DataDark";	
			docbase = (Docbase) list.get(i);
			 categoryid = null;
			if(categoryService.getCategoryByObj(docbase.getId())!=null)
				categoryid = (categoryService.getCategoryByObj(docbase.getId())).getId();

			String objno = docbase.getObjno()==null?"":" ,"+docbase.getObjno();

%>
	<tr class="<%=trclassname%>">
		<td style="display:none">
			<%=docbase.getId()%>
		</td>
		<td>
			<%=docbase.getSubject()%><%=objno%></td>
	   	</tr>
<%		}
	}
%>	
	</table>
	<br>
	<table border="0">
	<tr>
		<td nowrap align=center colspan="2">
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
	</tr>
	<tr>
		<td nowrap align=center>						
		<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
		&nbsp;
		<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
		&nbsp;
		</td>
		<td nowrap align=center>
		<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
			<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:document.EweaverForm.submit();">
			&nbsp;
			<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
			<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.EweaverForm.submit();">
		</td>
	</tr>
	</table>       
    </form>
<script language="javascript" type="text/javascript">
function onSubmit(){
  		event.srcElement.disabled = true;
  		document.EweaverForm.pageno.value = 1;
   		document.EweaverForm.submit();
}
function onSearch(pageno){
    	event.srcElement.disabled = true;
   		document.EweaverForm.pageno.value=pageno;
		document.EweaverForm.submit();
}
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+viewurl);
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
<script language=VBS>
Sub btnclear_onclick()
     getArray "0",""
End Sub
sub getdate(inputname,spanname,isneed)
	returnvalue = window.showModalDialog("/plugin/calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if (Not IsEmpty(returnvalue)) then
		document.all(inputname).value = returnvalue
		document.all(spanname).innerHtml = returnvalue
		if (returnvalue="" and isneed="1") then
			document.all(spanname).innerHtml = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
		end if
	end if
end sub

Sub Btnclear_onclick()
     getArray "0",""
End Sub

Sub BrowserTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     getArray e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   ElseIf e.TagName = "A" Then
      getArray e.parentelement.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText
   End If
End Sub
Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub
</script>
  <script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>

