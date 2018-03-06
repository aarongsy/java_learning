<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.servlet.RequestlogAction"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>

<%
	RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");
	RequestbaseService requestbaseService = (RequestbaseService)BaseContext.getBean("requestbaseService");
	String requestid = request.getParameter("requestid");
	Requestbase requestbase = requestbaseService.getRequestbaseById(requestid);
	
	StringBuffer hql = new StringBuffer("select wl.operatedate,wl.operatortime, wl.remark, ni.objname ,h.objname,s.objname, rb.requestname,wl.operator");
	hql.append(" from Requestlog wl, Requeststep ws ,Nodeinfo ni,Humres h ,Selectitem s ,Requestbase rb ")
		.append(" where wl.stepid=ws.id and ws.nodeid = ni.id and h.id=wl.operator and s.id = wl.logtype and rb.id=wl.requestid")
		.append(" and wl.requestid='").append(requestid).append("' order by wl.operatedate desc,wl.operatortime desc");
	List requestlogList = (List) request.getAttribute("requestlogList");
	
	////    显示样式参数,可选"1","2","3","4";    ////////////////
	String mstyle = StringHelper.null2String(request.getParameter("style"));
	
	if (requestlogList == null) {
		requestlogList = requestlogService.getAllRequestlog(hql.toString());
	}
%>

<!----------显示模式1：时间 操作者 操作类型 流转意见--------->
<%
if (mstyle.equals("1"))
{
%>
        <table class=liststyle cellspacing=1>
          <colgroup>
           <col width="30%">
            <col width="20%"> 
            <col width="20%"> 
            <col width="30%"> 
          </colgroup>
          <tbody> 
          <tr class=Header> 
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b074410031")%></th><!--日期时间 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
            <th><%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%></th><!--操作类型 -->
			<th><%=labelService.getLabelName("402881f00c7690cf010c76b3481b003a")%></th><!--流转意见 -->
          </tr>
		  <tr class="line2"><th colspan="4"></th></tr>
 				<%				
					Iterator it = requestlogList.iterator();		
					while(it.hasNext()) {
						Object[] results = (Object[])it.next();
				%>
          <tr  class=DataLight  > 
          <!-- 日期-->
            <td><%=results[0]%>
            <!-- 时间-->
              &nbsp<%=results[1]%></td> 
            <td>
            <!-----操作者------>
			<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=results[7]%>"> <%=results[4]%> </a>
            </td>
            <!-----操作类型------->
            <td><%=results[5]%>
            </td>
            <td> 
              <!----流转意见------>
              <%=StringHelper.null2String(results[2])%>
              
            </td>
          </tr>
      		<%	
				}
			%>	
	</table>
       <br>
</body>
</html>

<!------显示模式2：时间 操作者 操作--------->
<%
}
else if (mstyle.equals("2"))
{
%>
        <table class=liststyle cellspacing=1>
          <colgroup> <col width="30%"> <col width="30%"> <col width="40%">
          <tbody> 
          <tr class=Header> 
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b074410031")%></th><!--日期时间 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
            <th><%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%></th><!--操作类型 -->
          </tr>
		  <tr class="line2"><th colspan="4"></th></tr>
 				<%				
					Iterator it = requestlogList.iterator();		
					while(it.hasNext()) {
						Object[] results = (Object[])it.next();
				%>
          <tr  class=DataLight  > 
          <!-- 日期-->
            <td><%=results[0]%>
            <!-- 时间-->
              &nbsp<%=results[1]%></td> 
            <td>
            <!-----操作者------>
			<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=results[7]%>"> <%=results[4]%> </a>
            </td>
            <!-----操作类型------->
            <td><%=results[5]%>
            </td>
          </tr>
      		<%	
				}
			%>	
	</table>
       <br>
</body>
</html>

<!------显示模式3：时间 操作者 流转意见--------->
<%
}
else if (mstyle.equals("3"))
{
%>
        <table class=liststyle cellspacing=1>
          <colgroup>
            <col width="20%"> 
            <col width="20%"> 

          </colgroup>
          <tbody> 
          <tr class=Header> 
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b074410031")%></th><!--日期时间 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b3481b003a")%></th><!--流转意见 -->
          </tr>
		  <tr class="line2"><th colspan="3"></th></tr>
				<%
					Iterator it = requestlogList.iterator();		
					while(it.hasNext()) {
						Object[] results = (Object[])it.next();
				%>
          <tr  class=DataLight  > 
          <!-- 日期-->
            <td><%=results[0]%>
            <!-- 时间-->
              &nbsp<%=results[1]%>
            </td> 
            
            <td>
            <!-----操作者------>
			<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=results[7]%>"> <%=results[4]%> </a>
            </td>
            
            <!-----流转意见------->
            <td><%=StringHelper.null2String(results[2])%>
            </td>
          </tr>
			<%	
			   }
			%>	
	</table>
       <br>
</body>
</html>
<!------显示模式4: 操作者 流转意见--------->

<%
}
else if (mstyle.equals("4"))
{
%>
        <table class=liststyle cellspacing=1>
          <colgroup>
           <col width="30%">
            <col width="70%"> 

          </colgroup>
          <tbody> 
          <tr class=Header> 
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b3481b003a")%></th><!--流转意见 -->
          </tr>
		  <tr class="line2"><th colspan="2"></th></tr>
 				<%
					Iterator it = requestlogList.iterator();		
					while(it.hasNext()) {
						Object[] results = (Object[])it.next();	
				%>
          <tr  class=DataLight  > 
            <td>
            <!-----操作者------>
				<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=results[7]%>"> <%=results[4]%></a>
            </td>
            
            <!-----流转意见------->
            <td><%=StringHelper.null2String(results[2])%>
            </td>
          </tr>
      	<%	
			 }
		%>	
	</table>
       <br>
</body>
</html>

<!-----默认显示模式-------------------------->
<%
}
else
{
%>
        <table class=liststyle cellspacing=1>
          <colgroup>
           <col width="30%">
            <col width="20%"> 
            <col width="20%"> 
            <col width="30%"> 
          </colgroup>
          <tbody> 
          <tr class=Header> 
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b074410031")%></th><!--日期时间 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1476b0034")%></th><!--操作者 -->
            <th><%=labelService.getLabelName("402881f00c7690cf010c76b1f3260037")%></th><!--节点 -->
            <th><%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%></th><!--操作类型 -->
          </tr>
		  <tr class="line2"><th colspan="4"></th></tr>
 				<%				
					Iterator it = requestlogList.iterator();		
					while(it.hasNext()) {
						Object[] results = (Object[])it.next();
				%>
          <tr  class=DataLight  > 
          <!-- 日期-->
            <td><%=results[0]%>
            <!-- 时间-->
              &nbsp<%=results[1]%></td> 
            <td>
            <!-----操作者------>
			<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=results[7]%>"> <%=results[4]%> </a>
            </td>
            <!-----节点------->
            <td><%=results[3]%>
            </td>
            <td> 
              <!---- 操作类型 ------>
              <%=results[5]%>
              
            </td>
          </tr>
          <tr  class=DataDark  > 
            <td colspan="4"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="15%"><font color="#FF0000"><%=labelService.getLabelName("402881f00c7690cf010c76b3481b003a")%></font></td><!--签字 -->
                  <td width="85%"> 
                    <%=StringHelper.null2String(results[2])%>
                  </td>
                </tr>
              </table>
	         </td>
	       </tr>
  		<%	
 			 }
		%>	
	</table>
       <br>
</body>
</html>
<%}%>