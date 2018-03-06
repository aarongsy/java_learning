<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.document.report.ReportService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>

<%
String begindate = StringHelper.trimToNull(request.getParameter("begindate"));
String enddate = StringHelper.trimToNull(request.getParameter("enddate"));
String isreply = StringHelper.trimToNull(request.getParameter("isreply"));
String orgunitid = StringHelper.trimToNull(request.getParameter("orgunitid"));
String categoryid = (String) request.getParameter("categoryid");

OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
DocbaseService docbaseService = (DocbaseService)BaseContext.getBean("docbaseService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");

ReportService reportService = new ReportService();

String sql = reportService.getDocNumDependViewlog(categoryid,orgunitid,begindate,enddate,isreply);
List list = reportService.getResult2List(sql);
%>
<html>
	<head>
	</head>
	<body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

		<form action="" name="EweaverForm" method="post">
		<table id=searchTable class=noborder style="display:'';">
		<colgroup> 
			<col width="10%">
			<col width="40%">
			<col width="10%">
			<col width="40%">
		</colgroup>
		 <tr>
			<td class="Line" colspan=4 nowrap>
			</td>		        	  
		</tr>		        
		<tr>
			<td class="FieldName" nowrap>
				<%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd72253df000c")%><!-- 创建日期 -->
			</td>
			<td class="FieldValue">
				<button type="button" class="Calendar"  onclick="javascript:getdate('begindate','begindatespan','0')"></button>&nbsp; 
       			<span id=begindatespan><%=StringHelper.null2String(begindate)%></span>-&nbsp;&nbsp;
       			<button type="button" class="Calendar"  onclick="javascript:getdate('endDate','endDatespan','0')"></button>&nbsp; 
       			<span id=enddatespan><%=StringHelper.null2String(enddate)%></span>
       			<input type=hidden name="begindate" value="<%=StringHelper.null2String(begindate)%>"> 
       			<input type=hidden name="enddate" value="<%=StringHelper.null2String(enddate)%>"> 
			</td>
			<td class="FieldName" nowrap>
				<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980056")%><!--包含:回复  -->
			</td>
			<td class="FieldValue">
				<input type="checkbox" name="isreply" value="1"<%=isreply!=null?" checked":""%>/>
			</td>
		</tr>
				<tr>
			<td class="FieldName" nowrap>
				<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%><!-- 部门 -->
			</td>
			<td class="FieldValue">
				<button  type="button" class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','0');"></button>
					<input type="hidden"  name="orgunitid" value="<%=StringHelper.null2String(orgunitid)%>">
					<span id="orgunitidspan"/><%=orgunitService.getOrgunitName(orgunitid)%></span>
			</td>
			<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda6ab3b001b")%></td><!-- 文档分类 -->
          		<td class="FieldValue" ><input type="hidden" name="categoryid" value="<%=StringHelper.null2String(categoryid)%>"/>       			
          			<button type="button" class=Browser onclick="javascript:getBrowser('/base/category/categorybrowser.jsp?model=docbase&categoryid='+document.EweaverForm.categoryid.value,'categoryid','categoryidspan','1');"></button>
             		<span id="categoryidspan"><%=categoryService.getCategoryPath(categoryid,null,null)%></span>	
             	</td>
		</tr>	        
		
		<tr>
			<td class="Line" colspan=4 nowrap>
			</td>		        	  
		</tr>       
		</table>
		<!-- div id="searchctrl" align="right"><a href="javascript:onHiddenShow('searchTable')"><img src="/images/task_up.gif" border="0">&nbsp;<img src="/images/task_down.gif" border="0"></a></div-->
			<table>
				<colgroup>
					<col width="30%">
					<col width="">
					<col width="">
					<col width="">
					<col width="10%">
				</colgroup>		
				<tr class="Header">
					<td>
						<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890000")%><!-- 文档标题 -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("402881e70b227478010b22783d2f0004")%><!-- 分类体系 -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%><!-- 部门 -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd752d0860006")%><!-- 创建者 -->

					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980057")%><!-- 总数 -->
					</td>
				</tr>
				<%				
			boolean isLight=false;
			String trclassname="";
			int sum = 0;
			Iterator it = list.iterator();
				while(it.hasNext()) {
					Map map = (Map) it.next();
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
				String docid = (String)map.get("id"); 
				Docbase docbase = docbaseService.getDocbase(docid);
				
				orgunitid = humresService.getHumresById(docbase.getCreator()).getOrgid();
				String orgunitname = orgunitService.getOrgunitPath(orgunitid,null,null);
				
%>
				<tr class="<%=trclassname%>">
					<td>
						<a href="<%=request.getContextPath()%>/document/base/docbaseview.jsp?id=<%=docid%>" target="_blank"><%=docbaseService.getSubjectByDoc(docid) %></a>
					</td>
					<td>
						<%=categoryService.getDocCategoryPath(categoryService.getCategoryidStrByObj(docid),null,null) %>
					</td>
					<td>
						<%= orgunitname %>
					</td>
					<td>
						<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=docbase.getCreator()%>" target="_blank"><%=humresService.getHrmresNameById(docbase.getCreator()) %></a>
					</td>
					<td align="right">
						<%=map.get("c")%>
					</td>
				</tr>
				<%
				sum += (NumberHelper.getIntegerValue(map.get("c"))).intValue();
				}
%>
				<tr class="Header">
					<td colspan="4">
						<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")%><!-- 合计 -->
					</td>
					<td>
						<div align="right"><%=sum%></div>
					</td>
				</tr>
			</table>
			
		</form>
<script language="javascript" type="text/javascript">
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
    document.EweaverForm.submit();
} 

function getdate(inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/plugin/calendar.jsp",null,"dialogHeight:320px;dialogwidth:275px");
    }catch(e){}

	if (id!=null) {
		document.all(inputname).value = id;
		document.all(inputspan).innerHTML = id;
        if (id==""&&isneed=="1")
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    }
 }
 </script>	
	</body>
</html>
