<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
DataService ds = new DataService();
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
String formobjname = StringHelper.null2String(CoworkHelper.getParams("replyform"));
String operatedatefield = StringHelper.null2String(CoworkHelper.getParams("replydate"));
String operatetimefield = StringHelper.null2String(CoworkHelper.getParams("replytime"));
String requestid = StringHelper.null2String(request.getParameter("requestid"));
List<Map<String,Object>> list4 = ds.getValues("select * from coworkaddfun where requestid='"+requestid+"' and ISDELETE=0 order by ordernum asc");
Map<String,Object> m4 = new HashMap<String,Object>();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Reply Page3</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="">
	<meta http-equiv="description" content="">
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<link href="<%= request.getContextPath()%>/app/cooperation/css/coworkstyle.css" rel="stylesheet" type="text/css" />	
<style>
body{margin:0px; padding:0px;}
.content1{  
     width:650px;  
     padding-top:10px; 
     padding-right:20px; 
     padding-bottom:10px; 
     padding-left:10px; 
     z-index:9999;
     }  
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
<script type="text/javascript">
jQuery(function(){
<%if(currentSysModeIsWebsite){%>
setIframeHeight_IsWebsite();
<%}else{%>
setIframeHeight_IsSoftware();
<%}%>
function setIframeHeight_IsSoftware(){
    var frameRight = window.parent.parent.parent.document.getElementById("frameRight");
	var replyframe1 = window.parent.parent.document.getElementById("replyframe1");
	var replyframe = window.parent.document.getElementById("replyframe");
	   if(frameRight && replyframe1 && replyframe){
	            replyframe1.style.height= "auto";
				replyframe.style.height= "auto";
				frameRight.style.height = "auto";
	       try{
				var bHeight_1 = frameRight.contentWindow.document.body.scrollHeight;
				var dHeight_1 = frameRight.contentWindow.document.documentElement.scrollHeight;
				var height1 = Math.min(bHeight_1, dHeight_1);
				//alert(height1+"frameRight的高度");
				var bHeight_2 = replyframe1.contentWindow.document.body.scrollHeight;
				var dHeight_2 = replyframe1.contentWindow.document.documentElement.scrollHeight;
				var height2 = Math.max(bHeight_2, dHeight_2);
				//alert(height2+"replyframe1的高度");
				var bHeight_3 = replyframe.contentWindow.document.body.scrollHeight;
				var dHeight_3 = replyframe.contentWindow.document.documentElement.scrollHeight;
				var height3 = Math.max(bHeight_3, dHeight_3);
			    //alert(height3+"replyframe的高度");
				replyframe1.style.height= height3+800;
				replyframe.style.height= height3+800;
				frameRight.style.height = height1;
		   }catch (ex){
		  
		   }
	   }
}
function setIframeHeight_IsWebsite(){
    var frameRight  = window.parent.parent.parent.document.getElementById("frameRight");
	var replyframe1 = window.parent.parent.document.getElementById("replyframe1");
	var replyframe  = window.parent.document.getElementById("replyframe");
	   if(frameRight && replyframe1 && replyframe){
	            replyframe1.style.height= "auto";
				replyframe.style.height= "auto";
				frameRight.style.height = "auto";
	       try{
				var bHeight_1 = frameRight.contentWindow.document.body.scrollHeight;
				var dHeight_1 = frameRight.contentWindow.document.documentElement.scrollHeight;
				var height1 = Math.max(bHeight_1, dHeight_1);
				//alert(height1+"frameRight的高度");
				var bHeight_2 = replyframe1.contentWindow.document.body.scrollHeight;
				var dHeight_2 = replyframe1.contentWindow.document.documentElement.scrollHeight;
				var height2 = Math.max(bHeight_2, dHeight_2);
				//alert(height2+"replyframe1的高度");
				var bHeight_3 = replyframe.contentWindow.document.body.scrollHeight;
				var dHeight_3 = replyframe.contentWindow.document.documentElement.scrollHeight;
				var height3 = Math.max(bHeight_3, dHeight_3);
			    //alert(height3+"replyframe的高度");
				replyframe1.style.height= height3+800;
				replyframe.style.height= height3+800;
				frameRight.style.height = height3+800;
				window.parent.parent.resizeMainPageBodyHeight();
				// alert(frameRight.style.height+"*******");
		   }catch (ex){
		  
		   }
	   }
}
});
</script>
  </head>
  <body>
<%
if(list4!=null && list4.size()>0){
	String fieldid = "";
	String orderfield = "0";
	String addtype = StringHelper.null2String(request.getParameter("addtype"));
    for(int i=0;i<list4.size();i++){
		m4=list4.get(i);
		if(addtype.equals(StringHelper.null2String(m4.get("id")))){
			fieldid = StringHelper.null2String(m4.get("fieldid"));
			orderfield = StringHelper.null2String(m4.get("orderfield"));
		}
    }
%>
<div style="overflow-x:scroll">
<TABLE class=layouttable border=1 id="table3" style="width:100%">
<COLGROUP>
<COL width="60%">
<COL width="40%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue width="60%">内容</TD>
<TD class=FieldValue width="40%">创建时间</TD>
</TR>
<%
int curePage = NumberHelper.string2Int(StringHelper.null2String(request.getParameter("curePage")),1);
int showRownum =25;
int start = 0;
int end = showRownum;
if(1<curePage){
	start = curePage*showRownum-showRownum;
	end = start+showRownum;
}
List<Map<String,String>> addlist = cwService.getAddFunList(fieldid,requestid,formobjname,operatedatefield,operatetimefield,orderfield,start,end);
int sum =  addlist.size();
int pageCount = (sum/showRownum);
if((sum%showRownum)>0){
	pageCount +=1;
}

for(Map<String,String> m:addlist){
	String content = m.get("content");
	if(content.indexOf("<img")>=0&&content.indexOf("src=")>0)
	{//如果含有图片的话，让图片安比例放缩
	 int dex = content.indexOf("<img");
	 String a = content.substring(0,dex+4);
	 String b = content.substring(dex+4,content.length());
	 content  = a+" onload=\"javascript:if(this.width>550){this.resized=true;this.style.width=550;}\""+b;
	}
	String date = m.get("date");
%>
<TR style="width:100%">
<TD style=" word-break:break-all;width:70%"> 
<%=content %>
</TD>
<TD class=FieldName  width="30%"><%=date%></TD>
</TR>
<%
}
%>
</TBODY>
</TABLE>
</div>
<%if(sum>0){ %>
<br/>
  <table border="0" width="720" cellspacing="0" cellpadding="0" style="margin-left:20px;">
    <tr>
      <td align="center">
      <div class="fengye"> 
      <%if(curePage!=1){ %>
      <a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=curePage-1 %>&addtype=<%=addtype%>');">上一页</a>
      <%}else{ %>
      <span class="disabled">上一页</span>
      <%}
      if(curePage<4){
       if(pageCount>6){ 
         for(int i=1;i<=6;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=i%>&addtype=<%=addtype%>');"><%=i %></a><%	
       	}
         }
         if(pageCount!=7){%>
         ...
       <%}
         if(curePage!=pageCount){%>
       <a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>&addtype=<%=addtype%>');"><%=pageCount %></a>
       <%}else{%>
         <span class="current"><%=pageCount %></span>
       <%}
       }else{
      	 for(int i=1;i<=pageCount;i++){
       	if(curePage==i){
       	%><span class="current"><%=i %></span><%	
       	}else{
       	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=i%>&addtype=<%=addtype%>');"><%=i %></a><%	
       	}
     }	
       }
       }else{
      	 if(pageCount>7){ %>
	    <a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=1&addtype=<%=addtype%>');">1</a>
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
        	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=i%>&addtype=<%=addtype%>');"><%=i %></a><%	
        	}
	      }
       	  if(curePage+4 < pageCount ){%>
          ...
         <%}if(curePage!=pageCount){%>
          <a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=pageCount%>&addtype=<%=addtype%>');"><%=pageCount %></a>
         <%}else{%>
          <span class="current"><%=pageCount %></span>
         <%}  
     }else{
       	 for(int i=1;i<=pageCount;i++){
        	if(curePage==i){
        	%><span class="current"><%=i %></span><%	
        	}else{
        	%><a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=i%>&addtype=<%=addtype%>');"><%=i %></a><%	
        	}
	     }	
     }
       }
      if(curePage!=pageCount){%>
      <a href="javascript:onCP_openUrl('/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&curePage=<%=curePage+1 %>&addtype=<%=addtype%>');">下一页</a>
      <%}else{ %>
      <span class="disabled">下一页</span>
      <%} %>
      </div>
      </td>
    </tr>
  </table>
  <%}} %>
 </body>
</html>