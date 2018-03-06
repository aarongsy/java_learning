<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.document.report.ReportService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%
String categoryid = (String) request.getParameter("categoryid");
String begindate = StringHelper.trimToNull(request.getParameter("begindate"));
String enddate = StringHelper.trimToNull(request.getParameter("enddate"));
String isreply = StringHelper.trimToNull(request.getParameter("isreply"));

OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
ReportService reportService = new ReportService();
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  
String sql = reportService.getDocNumDependOrgunit(categoryid,begindate,enddate,isreply);
List list = reportService.getResult2List(sql);
%>
<html>
	<head>
	</head>
	<body>
<table class=noborder>
<tr>
<td bgcolor="#daeaea">
  <table class=noborder>
 	<tr>
	<td><img src="<%=request.getContextPath()%>/images/main/titlebar_bg.jpg" border=0> <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980058")%></td><!-- 部门文档数 -->
	<td align="right" valign="bottom" >
	<a href="<%=request.getContextPath()%>/document/report/docorgunit.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015")%>>></a><!-- 更多 -->
	</td>
    </tr>
  </table>
</td>
</tr>	
<tr>
<td class=LinePortal></td>
</tr>	
</table>

		<form action="" name="EweaverForm" method="post">

		<!-- div id="searchctrl" align="right"><a href="javascript:onHiddenShow('searchTable')"><img src="/images/task_up.gif" border="0">&nbsp;<img src="/images/task_down.gif" border="0"></a></div-->
			<table>
				<colgroup>
					<col width="">
					<col width="18%">
				</colgroup>
				
				<tr class="Header">
					<td>
						<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%><!-- 部门 -->
					</td>
					<td>
						<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980051")%><!-- 文档总数 -->
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
%>
				<tr class="<%=trclassname%>">
					<td>
						<%=orgunitService.getOrgunitName((String)map.get("orgunitid"))%>
					</td>
					<td align="left">
						<%=map.get("c")%>
					</td>
				</tr>
				<%
				sum += (NumberHelper.getIntegerValue(map.get("c"))).intValue();
				}
%>
				<tr class="Header">
					<td>
						<%=labelService.getLabelNameByKeyId("402883d934c2013a0134c2013b71000e")%><!--合计  -->
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
 </script>	
	</body>
</html>
