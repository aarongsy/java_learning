<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.document.report.ReportService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>

<%
  //  /document/report/docnumdependhumres.jsp
  ReportService reportService = new ReportService();
  OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService"); 
  CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
  
  String orgunitId = (String) request.getParameter("orgunitId");
  String categoryid = (String) request.getParameter("categoryid");
  
  String beginDate = (String) request.getParameter("beginDate");
  String endDate = (String) request.getParameter("endDate");
  String isReply = (String) request.getParameter("isReply");
  String orderFlag = (String) request.getParameter("orderFlag");
  
  String sql = reportService.getDocNumDependHumres(categoryid,orgunitId,beginDate,endDate,isReply,orderFlag);

  List rsList = reportService.getResult2List(sql);
   

  //String pageNo = (String) request.getAttribute("pageNo");
  //int pn = NumberHelper.string2Int(pageNo,1);
  //String pageSize = (String) request.getAttribute("pageSize");
  //int ps =   NumberHelper.string2Int(pageNo,20);
  //Page pageObject = reportService.getResult2Page(sql,pn,ps);
  
  
  
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
	<td><img src="<%=request.getContextPath()%>/images/main/titlebar_bg.jpg" border=0> <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980055")%></td><!-- 著者文档数 -->
	<td align="right" valign="bottom" >
	<a href="<%=request.getContextPath()%>/document/report/docnumdependhumres.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015")%>>></a><!-- 更多 -->
	</td>
    </tr>
  </table>
</td>
</tr>	
<tr>
<td class=LinePortal></td>
</tr>	
</table>
 		

<form action="" name="EweaverForm"  method="post">

<table class=noborder>
	<colgroup> 
	    <col width="25%">
		<col width="55%">
		<col width="20%">
	</colgroup>	
	<tr class="Header">
		<th  nowrap>
		<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980053")%></th>	<!-- 文档所有者 -->
		<th   nowrap>
		<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></th>		<!-- 部门 -->	
		<th nowrap>
		<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980051")%></th>	<!-- 文档总数 -->
	</tr> 
	<%  
	     if (rsList.size()!=0) {
	   		boolean isLight=false;
			String trclassname="";
			for (int i=0;i<rsList.size();i++){
			   Map rcdMap = (Map)rsList.get(i);
			  isLight=!isLight;
			  if(isLight) trclassname="DataLight";
			  else trclassname="DataDark";	
	     
	%>	 
  <tr class="<%=trclassname%>">	 
     <%
       String hname = (String) rcdMap.get("hname");
       hname = StringHelper.null2String(hname);
     %>
     <td nowrap>
        <%=hname%>
     </td>
     <%
       String objname = (String) rcdMap.get("objname");
       objname = StringHelper.null2String(objname);
     %>
     <td nowrap>
       <%=objname%>
     </td>   
    <%
       Integer num = NumberHelper.getIntegerValue(rcdMap.get("c"));
        
     %>
      <td nowrap>
       <%=num.intValue()%>
     </td>   
 

  </tr>
	<%
	  }// end for
	 }// end if 
	%>	
	</table>
</form>
       
 <script language="javascript">
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
    var orgunitId = document.all("orgunitid").value;
    var beginDate = document.all("begindate").value;
    var endDate = document.all("enddate").value;
    var isReply = document.all("isReply").value;
    var orderFlag = document.all("orderFlag").value;
    document.EweaverForm.action = "<%=request.getContextPath()%>/document/report/docnumdependhumres.jsp?orgunitId="+orgunitId+"&beginDate="+"&endDate="+endDate+"&isReply="+isReply+"&orderFlag="+orderFlag;
    document.EweaverForm.submit();
} 
 </script>
  </body>
</html>
