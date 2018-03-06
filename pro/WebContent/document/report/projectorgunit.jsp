<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.document.report.ReportService"%>
<%
String begindate = StringHelper.trimToNull(request.getParameter("begindate"));
String enddate = StringHelper.trimToNull(request.getParameter("enddate"));

OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
ReportService reportService = new ReportService();

String sql = reportService.getProjectNumDependOrgunit(begindate,enddate);
List list = reportService.getResult2List(sql);
%>
<html>
	<head>
	</head>
	<body>
		<%titlename="项目部门统计";%>
		<%@ include file="/base/toptitle.jsp"%>
		
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
				创建日期
			</td>
			<td class="FieldValue">
				<button class="Calendar"  onclick="javascript:getdate('begindate','begindatespan','0')"></button>&nbsp; 
       			<span id=begindatespan><%=StringHelper.null2String(begindate)%></span>-&nbsp;&nbsp;
       			<button class="Calendar"  onclick="javascript:getdate('endDate','endDatespan','0')"></button>&nbsp; 
       			<span id=enddatespan><%=StringHelper.null2String(enddate)%></span>
       			<input type=hidden name="begindate" value="<%=StringHelper.null2String(begindate)%>"> 
       			<input type=hidden name="enddate" value="<%=StringHelper.null2String(enddate)%>"> 
			</td>
			<td class="FieldName" nowrap>
			</td>
			<td class="FieldValue">
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
					<col width="">
					<col width="10%">
				</colgroup>
				
				<tr class="Header">
					<td>
						部门
					</td>
					<td>
						总数
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
					<td align="right">
						<%=map.get("c")%>
					</td>
				</tr>
				<%
				sum += (NumberHelper.getIntegerValue(map.get("c"))).intValue();
				}
%>
				<tr class="Header">
					<td>
						合计
					</td>
					<td>
						<div align="right"><%=sum%></div>
					</td>
				</tr>
			</table>
			
		</form>
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
<script language="javascript" type="text/javascript">
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
 <!--
function onSubmit(){
    document.EweaverForm.submit();
} 
function onPopup(url){
   	var id=window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url,window,"dialogWidth=800px;dialogHeight=600px");
}
 -->
 </script>	
	</body>
</html>
