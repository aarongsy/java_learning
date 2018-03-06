<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
DataService ds = new DataService();
String requestid = StringHelper.null2String(request.getParameter("requestid"));
String sql3_2 = "select count(*) from coworklog where coworkid='"+requestid+"' ";
int sum =  NumberHelper.string2Int(ds.getValue(sql3_2),0);
int curePage = NumberHelper.string2Int(StringHelper.null2String(request.getParameter("curePage")),1);
int showRownum =15;
int pageCount = (sum/showRownum);
if((sum%showRownum)>0){
	pageCount +=1;
}
int start = 0;
int end = showRownum;
if(1<curePage){
	start = curePage*showRownum-showRownum;
	end = start+showRownum;
}
String sql = "select * from coworklog  WHERE coworkid='"+requestid+"' order by operatedate desc,operatetime desc";
/* begin 分页处理*/
int pageSize = showRownum;
int pageNo = curePage;
Page reportpage = ds.pagedQuery(sql.toLowerCase(),pageNo, pageSize);
List<Map<String, Object>> list =new ArrayList<Map<String, Object>>();
int total = reportpage.getTotalSize();
if(total>0)
	list = (List) reportpage.getResult();
/* end 分页处理*/
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Reply Page1</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link href="<%= request.getContextPath()%>/app/cooperation/css/default.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/app/cooperation/js/openUrl.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript">
	jQuery(function(){
	<%if(currentSysModeIsWebsite){%>
	setIframeHeight_IsWebsite();
	<%}else{%>
	setIframeHeight_IsSoftware();
	<%}%>
	});
	</script>
	<style>
	body{margin:0px; padding:0px;}
	a{  
	    cursor:pointer;  
	    text-decoration:none;  
	    hide-focus: expression(this.hideFocus=true);  
	    outline:none;  
	}  
	a:link,a:visited,a:active{  
	    text-decoration:none;  
	    color: #000000;
	}  
	  
	a:focus{  
	    outline:0;   
	}
	</style>
</head>
<body style="padding: 0px;margin: 0px;">
<TABLE class=layouttable border=1 id="table3">
<COLGROUP>
<COL width="34%">
<COL width="33%">
<COL width="33%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>操作类型</TD>
<TD class=FieldValue>操作者</TD>
<TD class=FieldValue >操作时间</TD>
</TR>
<%if(list!=null && list.size()>0){
	String[] optype={"新建","修改","查看","发表","回复","删除"};
for(Map<String,Object> m:list){
	String otype = optype[NumberHelper.string2Int(m.get("operatetype"),3)-1];
	String userid = ds.getValue("select objname from humres where id='"+StringHelper.null2String(m.get("operator"))+"'");
	String datetime = StringHelper.null2String(m.get("operatedate"))+" "+StringHelper.null2String(m.get("operatetime"));
%>
<TR>
<TD class=FieldName noWrap><%=otype %></TD>
<TD class=FieldName noWrap ><%=userid %></TD>
<TD class=FieldName noWrap ><%=datetime %></TD>
</TR>
<%}} %>
</TBODY>
</TABLE>
<%if(sum>0){ %>
<br/>
  <table border="0" width="720" cellspacing="0" cellpadding="0" style="margin-left:20px;">
    <tr>
      <td align="center">
      <div class="fengye"> 
      <%if(curePage!=1){ %>
      <a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=curePage-1 %>');">上一页</a>
      <%}else{ %>
      <span class="disabled">上一页</span>
      <%}
      if(curePage<4){
       if(pageCount>6){ 
         for(int i=1;i<=6;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
       	}
         }
         if(pageCount!=7){%>
         ...
       <%}
         if(curePage!=pageCount){%>
       <a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>');"><%=pageCount %></a>
       <%}else{%>
         <span class="current"><%=pageCount %></span>
       <%}
       }else{
      	 for(int i=1;i<=pageCount;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
       	}
     }	
       }
       }else{
      	 if(pageCount>7){ %>
	    <a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=1');">1</a>
        <%
          if(pageCount!=7 && curePage!=4){%>
          ...
        <%}
          // 计算下
          int start1=0;
          if(curePage+3>pageCount){
        	  start1 = pageCount-4;
          }else if(curePage+2==pageCount){
        	  start1 = curePage-3;
          }else{
        	  start1 = curePage-2;
          }
        
          for(int i=start1;i<pageCount && i<=(start1+4) ;i++){
        	if(curePage==i){
        	%><span class="current"><%=i %></span><%	
        	}else{
        	%><a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
        	}
	      }
       	  if(curePage+4 < pageCount ){%>
          ...
         <%}if(curePage!=pageCount){%>
          <a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>');"><%=pageCount %></a>
         <%}else{%>
          <span class="current"><%=pageCount %></span>
         <%}  
     }else{
       	 for(int i=1;i<=pageCount;i++){
        	if(curePage==i){
        	%><span class="current"><%=i %></span><%	
        	}else{
        	%><a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=i%>');"><%=i %></a><%	
        	}
	     }	
     }
       }
      if(curePage!=pageCount){%>
      <a href="javascript:onCP_openUrl('/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>&curePage=<%=curePage+1 %>');">下一页</a>
      <%}else{ %>
      <span class="disabled">下一页</span>
      <%} %>
      </div>
      </td>
    </tr>
  </table>
  <%} %>
  </body>
</html>
