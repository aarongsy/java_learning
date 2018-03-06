<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="/base/init.jsp"%>
<html>
  <head>
<style>
.list1 img{cursor:hand;padding:2px;border:1px solid #CCCCCC;
event:expression(
    onmouseover = function(){
		this.style.borderColor='#333333';
    },
    onmouseout = function(){
       this.style.borderColor='#CCCCCC';
    }
 );
}
.list1 td{text-align:center;}
</style>
<base target="_self"/>
<title>浏览图片资源</title>
  </head> 
  <body >
<!--页面菜单开始-->     
<%
//pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";
%>

<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->
<table class="list1" width="80%" align="center" border="0">
<tr>
<%
String p=StringHelper.null2String(request.getParameter("p"));
if(!p.endsWith(""+File.separatorChar))p+=""+File.separatorChar;
p=p.replaceAll("\\.","");
int pos=p.lastIndexOf(File.separatorChar);
String pp="";
if(pos>0)pp=p.substring(0,p.length()-pos);

		String fpath=BaseContext.getRootPath()+"images"+p;
		File f=new File(fpath);
		File[] files=f.listFiles();
		List<String> dirs=new ArrayList<String>();
		int i=1;String name=null;
		String pUrl=p.replaceAll("\\\\","/");
		for(File f1:files){
			name=f1.getName();
			if(name.startsWith("."))continue;
			if(f1.isDirectory())dirs.add(name);			
			if(name.endsWith(".jpg") || name.endsWith(".gif")){
				out.println("<td><img src='"+request.getContextPath()+"/images"+pUrl+name+"' onclick='getImg(this)' title='/images"+pUrl+name+"' width='32' height='32'/></td>");
				if(i%13==0)out.println("</tr><tr>");
				i+=1;
			}
		}

 %>
</tr></table>
<br/>
<table class="list1" border="0">
<tr><%
for(String dir:dirs){
	out.println("<td><a href='imagesBrowser.jsp?p="+p+dir+"'>"+dir+"</a></td>");
}
 %></tr>
</table>
<script>
function getImg(o){
	//alert("src:"+o.title);
	window.returnValue=o.title;
	window.close();
}
</script>
</body>
</html>
