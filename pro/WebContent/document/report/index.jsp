<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%
String[] model = {"docbase","customer","project"};
if(!StringHelper.isEmpty(request.getParameter("model")))
	model = StringHelper.null2String(request.getParameter("model")).split(",");
%>
<html>
  <head>
  </head> 
  <body>
<table height=100%>
<tr>
<td valign=top>
   <table class=ListShort cellspacing=1 style="border:0">
		<colgroup> 
			<col width="1">
			<col width="">		
		</colgroup>
<%
for(int i=0;i<model.length;i++){
	if("docbase".equalsIgnoreCase(model[i])){
%>
		<tr><td class=Spacing colspan=3></td><tr>
	    <tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/doc/listtitle.gif border=0>
	        	<%=labelService.getLabelName("402881eb0bcd354e010bcdbc15eb0022")%>
	    </th>
      	</tr>
	    <tr><td class=Line colspan=3></td><tr>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="docnumdependhumres.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980059")%></a><!--著者文档数量  -->
	         </TD>	                    
	    </TR>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="docorgunit.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005a")%></a><!-- 部门文档数量 -->
	         </TD>	                    
	    </TR>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="docviewlog.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005b")%></a><!-- 最多被阅文档 -->
	         </TD>	                    
	    </TR>
<%
	}else if("customer".equalsIgnoreCase(model[i])){
%>
	    <tr><td class=Spacing colspan=3></td><tr>
	    <tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/doc/listtitle.gif border=0>
	        	<%=labelService.getLabelName("402881ed0c1e8532010c1e8ae0c70005")%>
	    </th>
      	</tr>
	    <tr><td class=Line colspan=3></td><tr>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="customerorgunit.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005c")%></a><!-- 客户部门统计 -->
	         </TD>	                    
	    </TR>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="customerhumres.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005d")%></a><!-- 客户经理统计 -->
	         </TD>	                    
	    </TR>
<%
	}else if("project".equalsIgnoreCase(model[i])){
%>
	    <tr><td class=Spacing colspan=3></td><tr>
	    <tr class=Title>
	    <th colspan=3>
	    	<img src=<%=request.getContextPath()%>/images/doc/listtitle.gif border=0>
	        	<%=labelService.getLabelName("402881e80c770b5e010c7728ee2c0011")%>
	    </th>
      	</tr>
	    <tr><td class=Line colspan=3></td><tr>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="projectorgunit.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005e")%></a><!-- 项目部门统计 -->
	         </TD>	                    
	    </TR>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="projectmanager.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98005f")%></a><!-- 项目经理统计 -->
	         </TD>	                    
	    </TR>  
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="projecthumres.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980060")%></a><!-- 项目成员统计 -->
	         </TD>	                    
	    </TR>
	    <TR>
     		 <TD nowrap class=FieldName> </TD>
	         <TD nowrap class=FieldName >  
	    		<a href="projectstate.jsp" target="_blank"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980061")%></a><!-- 项目状态统计 -->
	         </TD>	                    
	    </TR> 
<%}
}%> 
   </table> 

		</td>
	</tr>
</table> 

  </body>
</html>
