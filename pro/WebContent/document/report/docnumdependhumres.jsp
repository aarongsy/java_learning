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
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
<form action="" name="EweaverForm"  method="post">
<table id="searchTable" class=noborder style="display:'';">
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
       			<span id="begindatespan"><%=StringHelper.null2String(beginDate)%></span>-&nbsp;&nbsp;
       			<button type="button" class="Calendar"  onclick="javascript:getdate('endDate','endDatespan','0')"></button>&nbsp; 
       			<span id="enddatespan"><%=StringHelper.null2String(endDate)%></span>
       			<input type=hidden name="begindate" value="<%=StringHelper.null2String(beginDate)%>"> 
       			<input type=hidden name="enddate" value="<%=StringHelper.null2String(endDate)%>"> 
			</td>
			<td class="FieldName" nowrap>
			  <%=labelService.getLabelNameByKeyId("402881e50de7d974010de7f72658013a")%><!-- 所属部门 -->

			</td>
			<%
			  String orgName = orgunitService.getOrgunitPath(orgunitId,null,null);
			%>
			<td class="FieldValue">
			  <button  type="button" class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','0');"></button>
			  <input type="hidden"  name="orgunitid" value="<%=StringHelper.null2String(orgunitId)%>"/>
			  <span id="orgunitidspan"/><%=StringHelper.null2String(orgName)%></span>		
			</td>
		</tr>
		<tr>
			<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bcd354e010bcda6ab3b001b")%></td><!-- 文档分类 -->
          		<td class="FieldValue" ><input type="hidden" name="categoryid" value="<%=StringHelper.null2String(categoryid)%>"/>       			
          			<button type="button" class=Browser onclick="javascript:getBrowser('/base/category/categorybrowser.jsp?model=docbase&categoryid='+document.EweaverForm.categoryid.value,'categoryid','categoryidspan','1');"></button>
             		<span id="categoryidspan"><%=categoryService.getCategoryPath(categoryid,null,null)%></span>	
             	</td>
			<td class="FieldName" nowrap>
			</td>
			<td class="FieldValue">	
			</td>
		</tr>	
		<tr class="FieldValue" nowrap>
			<td class="FieldName" nowrap>
			  <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980050")%><!--是否包含回复  -->
			</td>
			<td class="FieldValue">
			   <select id="isReply" size="1">
			     <option value=""></option>
			     <option value="2"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c")%></option><!-- 是 -->
			     <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d")%></option><!-- 否 -->
			   </select>
			</td>	
			<td class="FieldName" nowrap>
			   <%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980052")%><!-- 排序条件 -->
			</td>
			<td class="FieldValue">
				 <select id="orderFlag" size="1">
			     <option value=""></option>
			     <option value="1"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></option><!-- 部门 -->
			     <option value="2"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980051")%></option><!-- 文档总数 -->
			   </select>		  
			</td>	
		</tr>		
		
</table>

<table class=noborder>
	<colgroup> 
	    <col width="25%">
		<col width="25%">
		<col width="25%">
		<col width="25%">
	</colgroup>	
	<tr class="Header">
		<th  nowrap>
		<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980053")%></th><!-- 文档所有者 -->	
		<th  nowrap>
		<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980054")%></th><!-- 职务 -->
		<th   nowrap>
		<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></th><!-- 部门 -->
		<th nowrap>
		<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980051")%></th>	<!--文档总数  -->
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
       String station = (String) rcdMap.get("station");
       String  sname = StringHelper.null2String(selectitemService.getSelectitemNameById(StringHelper.null2String(station)));
    
     %>   
     <td nowrap>
         <%=sname%>
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
    document.EweaverForm.action = "<%=request.getContextPath()%>/document/report/docnumdependhumres.jsp?orgunitId="+orgunitId+"&beginDate="+beginDate+"&endDate="+endDate+"&isReply="+isReply+"&orderFlag="+orderFlag;
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
