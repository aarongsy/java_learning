<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="javax.swing.text.html.HTMLEditorKit.ParserCallback"%>
<%@ page import="javax.swing.text.html.parser.ParserDelegator"%>

<%@ include file="/base/init.jsp"%>
<%
String content=Scan("http://localhost:8084/app/base/aaa.html");
//String content=Scan("http://news.baidu.com/ns?bt=0&et=0&si=&rn=40&tn=newstitle&ie=gb2312&ct=0&word=%D4%B4%CC%EC&pn=20&cl=2&prevct=1");
content=content.substring(content.indexOf("<p class=\"res\">"),content.length());
System.out.println(content);
content=content.substring(0,content.lastIndexOf("</p>"));
	
%>
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
								for(int   i=0;i<5000;i++){   
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

<html>
  <head>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript">
    Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
    Ext.onReady(function() {

		fltContent();
	});
	var showNum=5;
	function fltContent()
	{
		var html="<table cellspacing=\"1\" border=\"0\" align=\"center\" style=\"width: 98%;font-size:13\" class=\"Econtent\">";
		html+="<colgroup><col width=\"20\"/>";
		html+="<col width=\"70%\"/>";
		html+="<col width=\"30%\"/></colgroup>";
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
				title=as[0].innerHTML;
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
			html+="<tr><td width=\"20\" align=\"left\" class=\"itemIcon\"> <img src=\"<%=request.getContextPath()%>/light/images/esymbol.gif\"/></td><td align=\"left\">&nbsp;<span ><a href=\"javascript:onUrl('"+url+"', '"+title+"', 'tab402880351e44500a011e4465e0cf0023', false, '');\" >"+title+"</a></td><td align=left>"+date+"</td></tr><tr height=\"1\"><td colspan=\"3\" class=\"line\"/></tr>";
		}
		html+="</table>";
		document.getElementById("news").innerHTML=html;
	}
</script>
  </head>
  <body>
 <div id="news" width="100%">

 </div>

<div id="content" style="display:none;" >
<%out.println(content);%>

 </script>






