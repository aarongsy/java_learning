<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="javax.swing.text.html.HTMLEditorKit.ParserCallback"%>
<%@ page import="javax.swing.text.html.parser.ParserDelegator"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ include file="/base/init.jsp"%>
<%
String nCount=request.getParameter("nCount");
String isCreateDate=StringHelper.null2String(request.getParameter("isCreateDate"));
String isModifyDate=StringHelper.null2String(request.getParameter("isModifyDate"));
String showReply=StringHelper.null2String(request.getParameter("showReply"));
if(showReply.equals("0"))showReply="2";
String url=request.getParameter("url");
String titleLength=request.getParameter("titleLength");
String content=Scan("http://news.baidu.com/ns?rn="+nCount+"&tn=newstitle&ie=gb2312&ct="+showReply+"&word="+url+"&sr=0&cl=2&prevct=1&tn=newstitle&from=news&bs="+url+"");
//String 
//content=Scan("http://news.baidu.com/ns?bt=0&et=0&sr=0&rn="+nCount+"&tn=newstitle&ie=gb2312&ct="+showReply+"&word="+url+"&pn=20&cl=0&prevct=1");
if(content.indexOf("<p class=\"res\">") != -1)
	content=content.substring(content.indexOf("<p class=\"res\">"),content.length());
if(content.lastIndexOf("</p>") != -1)
	content=content.substring(0,content.lastIndexOf("</p>"));
%>
<html>
<head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<style>
TD.Line {
	BACKGROUND-COLOR: #B0BDD4; BACKGROUND-REPEAT: repeat-x; HEIGHT: 1px
}
</style>
<script type="text/javascript">
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
    Ext.onReady(function() {

		fltContent();
	});
	var isCreateDate=<%=isCreateDate%>;
	var isModifyDate=<%=isModifyDate%>;
	var showNum=<%=nCount%>;
	var titleLength=parseInt('<%=titleLength%>');
	function fltContent()
	{
	
		var html="<table cellspacing=\"0\" border=\"0\" align=\"center\" style=\"width: 100%;font-size:12\" >";
		html+="<colgroup><col width=\"20\"/>";
		if(isCreateDate==0&&isCreateDate==0)
		{
			html+="<col width=\"100%\"/>";
		}
		else if(isCreateDate==1&&isCreateDate==1)
		{
			html+="<col width=\"65%\"/>";
			html+="<col width=\"20%\"/>";
			html+="<col width=\"15%\"/>";
		}
		else 
		{
			html+="<col width=\"80%\"/>";
			html+="<col width=\"20%\"/>";
		}
		html+="</colgroup>";
		var spans=document.getElementsByTagName("span");
		if(spans==null)return;
		var idx=1;
		
		for(var i=0,len=spans.length;i<len;i++)
		{
			var url="";
			var title="";
			var date="";
			var span=spans[i];
			var as = span.getElementsByTagName("a");
			var fts = span.getElementsByTagName("font");
			if(as!=null&&as.length>0)
			{
				url=as[0].href;
				title=as[0].innerText;
			}
			if(fts!=null&&fts.length>0)
			{
				var x=0;
				for(var j=0,len1=fts.length;j<len1;j++)
				{
					if(fts[j].className=='g')
					{
						x=j;
						date=fts[x].innerHTML;
						date=date.substring(date.indexOf(" ")+1,date.length);
						break;
					}
				}
				
			}
			if(url.length<1)continue;
			if(idx>showNum)break;
			idx=idx+1;
			var titleall=title;
			if(title.length>titleLength)
			{
				title=title.substring(0,titleLength);
				title=title+'...';

			}
			if(isCreateDate==0&&isCreateDate==0)
			{
				html+="<tr height=\"20\"><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><tr height=\"1\"><td colspan=\"2\" class=\"line\"/></tr>";
			}
			else if(isCreateDate==1&&isCreateDate==1)
			{
				html+="<tr height=\"20\"><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><td align=\"left\">&nbsp;<span ><a href=\""+url+"\"  title='"+titleall+"' target=\"_blank\">"+title+"</a></td><td align=left>"+date.substring(0,date.indexOf(" "))+"</td><td align=left>"+date.substring(date.indexOf(" ")+1,date.length)+"</td></tr><tr height=\"1\"><td colspan=\"4\" class=\"line\"/></tr>";
			}
			else if(isCreateDate==1&&isCreateDate==0)
			{
				html+="<tr height=\"20\"><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><td align=\"left\">&nbsp;<span ><a href=\""+url+"\"  title='"+titleall+"' target=\"_blank\">"+title+"</a></td><td align=left>"+date.substring(0,date.indexOf(" "))+"</td></tr><tr height=\"1\"><td colspan=\"3\" class=\"line\"/></tr>";
			}
			else 
			{
				html+="<tr><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><td align=\"left\">&nbsp;<span ><a href=\""+url+"\"  title='"+titleall+"' target=\"_blank\">"+title+"</a></td><td align=left>"+date.substring(date.indexOf(" ")+1,date.length)+"</td></tr><tr height=\"1\"><td colspan=\"3\" class=\"line\"/></tr>";
			}
			//html+="<tr><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><td align=\"left\">&nbsp;<span ><a href=\"+url+"\" title='"+titleall+"'>"+title+"</a></td><td align=left>"+date+"</td></tr><tr height=\"1\"><td colspan=\"3\" class=\"line\"/></tr>";
		}
		html+="</table>";
		document.getElementById("news").innerHTML=html;
	}
	function iFrameHeight() {   
		var ifm= document.getElementById("cwin");   
		var subWeb = document.frames ? document.frames["iframepage"].document : ifm.contentDocument;   
		if(ifm != null && subWeb != null) {
		   ifm.height = subWeb.body.scrollHeight;
		}   
	} 
</script>
  </head>
  <body>
 <div id="news" width="100%" valign="top" height="100%">
 </div>
<div id="content" style="display:none;" >
<%out.println(content);%>
</div>
<%!
private   URL   currentUrl;   
private   ParserCallback   parse=new   ParserCallback();   
private   String Scan(String url){   
	   ParserDelegator   pd=new   ParserDelegator();  
	   StringBuffer bufstr = new StringBuffer();
	   try   {   
			   currentUrl=new URL(url);   
			   URLConnection   con=currentUrl.openConnection();   
			   HttpURLConnection   httpcon=(HttpURLConnection)   con;   
			   if(httpcon.getResponseCode()==HttpURLConnection.HTTP_OK){   
					   if(httpcon.getContentType().startsWith("text/html")){   
							   InputStreamReader   in=new   InputStreamReader(con.getInputStream());   
							   BufferedReader   buf=new   BufferedReader(in);   
							   //这个循环可以用while(true)   
								for(int   i=0;i<3000;i++){   
									String   s=buf.readLine();  
									if(s==null)
										break;
									bufstr.append(s);  
							   }   
							   //pd.parse(buf,parse=new   ParserCallback(),false);   
							   buf.close();   
							   in.close();   
					   }   
			   }   
			
	   }   
	   catch   (MalformedURLException   e)   {   
			   e.printStackTrace();   
	   }   catch   (IOException   e)   {   
			   e.printStackTrace();   
	   }   
	      return bufstr.toString();
}   
%>






