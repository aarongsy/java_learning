<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.InputStream" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
DataService ds = new DataService();
String requestid = StringHelper.null2String(request.getParameter("requestid"));
CoWorkService cwService = new CoWorkService();
if(CoworkHelper.IsNullCoworkset()){
	out.print("<h5><img src='/images/base/icon_nopermit.gif' align='absmiddle' />请联系管理员！先设置好协作区关联表单信息后再来操作。</h5>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>Reply Page2</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
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
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
<script type="text/javascript">
jQuery(function(){
<%if(currentSysModeIsWebsite){%>
setIframeHeight_IsWebsite();
<%}else{%>
setIframeHeight_IsSoftware();
<%}%>
});
</script>
  </head>
  <body>
<TABLE class=layouttable border=1 id="table3">
<COLGROUP>
<COL width="10%">
<COL width="75%">
<COL width="15%">
</COLGROUP>
<TBODY>
<TR>
<TD class=FieldValue>参与角色</TD>
<TD class=FieldValue>内容</TD>
<TD class=FieldValue>安全级别</TD>
</TR>
<% 
List<Map<String,Object>> list3 = ds.getValues("select * from COWORKPERMISSION where requestid='"+requestid+"' and ISDELETE=0 order by oprule asc,opunit asc");
Map<String,Object> m3 = new HashMap<String,Object>();
if(list3!=null && list3.size()>0){
for(int i=0;i<list3.size();i++){
	m3=list3.get(i);
   int oprule = Integer.parseInt(m3.get("oprule")+"");
   int opunit=Integer.parseInt(m3.get("opunit")+"");
   String id3=StringHelper.null2String(m3.get("id"));
   String content=StringHelper.null2String(m3.get("content"));
   String contentspan ="";
   String sql3_1="";
   if(opunit==0){
	   sql3_1 = "select objname,id from humres where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==1){
	   sql3_1 = "select objname,id from orgunit where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==2){
	   sql3_1 = "select objname,id from stationinfo  where id in ('"+content.replace(",","','")+"')";
   }else if(opunit==3){
	   sql3_1 = "SELECT rolename AS objname,id as id FROM Sysrole where id in ('"+content.replace(",","','")+"')";
   }
   if(opunit!=4){
	   List<Map<String,Object>> list3_1 = ds.getValues(sql3_1);
	   for(int j=0;j<list3_1.size();j++){
		   Map<String,Object> m3_1 = list3_1.get(j);
		   String id3_1 =StringHelper.null2String(m3_1.get("id"));
		   if(j!=list3_1.size()-1){
			   if(opunit==0){
			      contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>"+",";
			   }else{
				   contentspan+=StringHelper.null2String(m3_1.get("objname"))+",";
			   }
		   }else{
			   if(opunit==0){
				   contentspan+="<a href=javascript:onUrl('/humres/base/humresinfo.jsp?id="+id3_1+"','"+StringHelper.null2String(m3_1.get("objname"))+"','tab"+id3_1+"') >"+StringHelper.null2String(m3_1.get("objname"))+"</a>";
			   }else{
				   contentspan+=StringHelper.null2String(m3_1.get("objname"));
			   }
		   }
	   }
   }else{
	   contentspan ="所有人";	   
   }
   int minseclevel=NumberHelper.string2Int(m3.get("minseclevel"),-1);
   int maxseclevel=NumberHelper.string2Int(m3.get("maxseclevel"),-1);
%>
<TR id="row3<%=i %>" style="display:block">
<TD class=FieldName  id="cell3<%=i %>_1">
  <%if(oprule==0){%>参与者<%}else{%>负责人<%} %>
</TD>
<TD class=FieldName  id="cell3<%=i %>_3">
<%=contentspan %>
</TD>
<TD class=FieldName  id="cell3<%=i %>_4">
<%=minseclevel!=-1?minseclevel+"":"" %>&nbsp;-&nbsp;
<%=maxseclevel!=-1?maxseclevel+"":"" %>
</TD>
</TR>
<%}} %>
</TBODY>
</TABLE>
  </body>
</html>
