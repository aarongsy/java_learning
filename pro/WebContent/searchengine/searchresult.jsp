<%@ page language="java" import="java.util.*"  errorPage="/error.jsp" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@page import="com.eweaver.base.category.service.CategoryService"%>
<%@page import="com.eweaver.base.log.service.LogService"%>
<%@page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@page import="com.eweaver.searchengine.model.SearchPOJO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.apache.log4j.spi.LoggerFactory"%>
<%@page import="org.apache.commons.logging.Log"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.eweaver.base.util.*"%>
<%@page import="com.eweaver.base.*"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<html>
<head>    
<title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005a") %><!-- 文档搜索 --></title>
<script type="text/javascript"  src="/searchengine/suggest.js"></script>
<script type="text/javascript"  src="/searchengine/search.js"></script>
<script  type="text/javascript" src="/searchengine/main.js"></script> 
<script  type="text/javascript" src="/searchengine/browser.js"></script> 
<script  type="text/javascript" src="/searchengine/dateutil.js"></script> 
<script  type="text/javascript" src="/searchengine/calendar.js"></script> 
<link href="/searchengine/search.css" type="text/css" rel="stylesheet">
<%String showType = (String)request.getParameter("showType"); %>

</head>  
  <body onload="spentTime()"  onkeydown="checkkeydown()">
  <%    
      String begintime=(String)request.getAttribute("begintime"); 
      String spent=(String)request.getAttribute("spent");
      if(spent == null) {
      	spent = "0";
      }
     SearchPOJO[] arr=(SearchPOJO[])request.getAttribute("pageShow");
     String searchKeys=StringHelper.null2String(request.getParameter("searchKeys"));
     if(StringHelper.isEmpty(searchKeys)) {
     	  Object keysObj = request.getSession().getAttribute("searchKeys");
     	  if(keysObj != null) {
     	  	searchKeys = keysObj.toString();    	
     	  } else {
     	  	searchKeys = " ";
     	  }
     }      
      //得到分页对象
     Page pageObject=(Page)request.getAttribute("pageObject");
     if(pageObject == null) {
     	pageObject = new Page();
     }
	 int pageSize = pageObject.getPageSize();
	String sort=StringHelper.null2String(request.getSession().getAttribute("sort"));				

     String action="/ServiceAction/com.eweaver.searchengine.servlet.LuceneAction?action=search";
   %>

	<form action="<%=action %>"  method="post" name="VelcroForm">
		<div style="margin-top:10px" align="center">
			<span id="logo"><img src="/searchengine/images/searchlogo.gif"><%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f2fd40a0036") %><!-- 全文检索 --></span>
			<INPUT autocomplete="off" 
			maxLength=2048 size=41 
			style="vertical-align:middle;" 
			name="q" 
			id="searchKeys" 
			title="<%=labelService.getLabelNameByKeyId("40288035249ec8aa01249f2fd40a0036") %>" 
			value="<%=searchKeys %>" 			
			 />
			 <!-- onkeyup="keyupdeal(event);" -->
			 <!-- 全文检索 -->

			<button type="button" style="vertical-align:middle;" accessKey='S' onclick="Search();" id='<%=labelService.getLabelNameByKeyId("40288035249ddfdb01249e0985720006") %>'><!-- 搜索 --> <%=labelService.getLabelNameByKeyId("40288035249ddfdb01249e0985720006") %> </button>     
			                                     
	        <div id="suggest" style="display: none" class="suggest"></div>
	        <div style="padding-right:10%;margin-top:5px;margin-bottom:3px">
	        	<input  type="radio" name="sortmode" value="1" onclick="csort()" <%=sort.equals("1")?"checked":"" %>/><%=labelService.getLabelNameByKeyId("402881820d467b14010d4687e3be0008") %><!-- 时间 -->
				<input  type="radio" name="sortmode" value="0" onclick="csort()"  <%=sort.equals("0")?"checked":"" %>/><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005b") %><!-- 匹配度 -->
				<input  type="radio" name="sortmode" value="2" onclick="csort()" <%=sort.equals("2")?"checked":"" %>/><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005c") %><!-- 综合 -->
				<input  id="showType" type="hidden" name="showType" value="<%=showType %>"/>
	        </div>
	     </div>       		      
 
	   <div class="info" align="left"> 
		   <div class="panel"><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005d") %><!-- 每页显示数量 -->
			<img id="20" src="/searchengine/images/number20.gif" width="18" height="15" onclick="SearchPageNo(20);">
			<img id="40" src="/searchengine/images/number40.gif" width="18" height="15" onclick="SearchPageNo(40);">
			<img id="80" src="/searchengine/images/number80.gif" width="18" height="15" onclick="SearchPageNo(80);">
			&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522000b") %><!-- 显示方式 -->
			<img id="simple" src="/searchengine/images/jian2.gif" width="19" height="15" onclick="showSimple('simple');">
			<img id="detail" src="/searchengine/images/xiang2.gif" width="19" height="15" onclick="showSimple('detail');">
			<!-- button id = "flag" class='btn' onclick="return  showSimple();" id='简要'>简要</button--></div>
			<div class="panelInfo">
				<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005e") %><!-- 约有 --><B><%=pageObject.getTotalSize()%></B><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be6005f") %><!-- 项符合 -->
			    <B><%=searchKeys%></B><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60060") %><!-- 的查询结果，以下是第 -->
	    		<B><%=pageObject.getStart()%></B>
	    		-<B><%=pageObject.getEnd()%></B><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60061") %><!-- 项(搜索用时 --> 
	    		<B><span id="spent"><%=spent%><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be60062") %><!-- 秒 --></span></B>)
	    	</div>
    	</div>		
    	<div >&nbsp;</div>	
    	<div id="resultview">
    	<%	
             boolean showflag=true;			
             if(pageObject.getTotalSize()!=0){
             Object[] list1 = (Object[]) pageObject.getResult();	
	         for (int k = 0; k < list1.length; k++) {	
		         SearchPOJO sp=(SearchPOJO)list1[k];		
		         String createTime=String.valueOf(sp.getCreateDate());
		        // int last = createTime.lastIndexOf(":");
		        // if(last == -1)
		        // 	continue;
		      //createTime = createTime.substring(0,last);
	          String summary = sp.getDescribe();
	          String title = sp.getSubject();          	
         %>
	<ul >
	<li>
		<%=createTime %>
	<label>
		<a href="/document/base/docbaseview.jsp?id=<%=sp.getId()%>" 
		   target="_blank">
		   <%=title%>
		</a>
	</label>
	
		<a name="hide" id='<%=sp.getId()%>' 
		href="javascript:openchild('<%=sp.getId()%>')" 
		class="tip" 
		onmouseover=showSummaryDiv('tip_<%=sp.getId()%>',this)
		onMouseOut=hiddenSummaryDiv('tip_<%=sp.getId()%>')
		>
			<font color="#0">[<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e") %><!-- 摘要 -->]</font>	
		</a><!-- 摘要 -->	
		
	<%if(summary !=null && summary.length() > 1) {%>
		<div style="display:none" 
		onMouseOut=hiddenSummaryDiv('tip_<%=sp.getId()%>') 
		id="tip_<%=sp.getId()%>">
			<p><%=summary%></p>
		</div>
	<%}%>
	
	<a 
	name="hide" 
	target="_blank"  
	href="/humres/base/humresview.jsp?id=<%=sp.getCreatorid()%>">
		<font color="#666666"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71ad6d46000a") %><!-- 作者 -->:<%=StringHelper.null2String(sp.getCreator())%></font>	
		<!-- font color="#666666">Score:<%=StringHelper.null2String(sp.getScore())%></font-->	
	</a>	
	<div name="hide" id="hide">
		<%String describe = sp.getContents();
		%>
		<%if((describe != null)&&describe.length()>1) {%>
			<%=describe%>
		<% }%>
	</div>
	<%
	//获取所有附件的id
			String attachids = sp.getAttid();
			String attachnames = sp.getObjname();
			attachnames = attachnames==null?"":attachnames;
			attachids = attachids==null?"":attachids;
			String[] temp = attachids.split(String.valueOf((char)0x0f));
			String[] objname = attachnames.split(String.valueOf((char)0x0f));		
			Map attmap=new HashMap(); 
			if(!attachnames.equals("") ){	
				int minLength = temp.length;	
				String tagNum = "";
				if(minLength >=2) {
	%>				
	<%
				String href = " <a href=/document/base/docbaseview.jsp?id="+sp.getId()+" target=_blank>";
				tagNum = href+"["+(minLength)+"]</a>";			
				}					
				if(minLength >= 1){			
	 %>
	<div 
		name="hide" 
		id="hide">
		<%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017") %><!-- 附件 -->:
		<!--<a 
			target="_blank" 
			href="/ServiceAction/com.eweaver.document.file.FileDownload?docid=<%=sp.getId()%>&attachid=<%=temp[0]%>"><%=objname[0]%>
		</a>  -->
		<a 
			target="_blank" 
			href="/searchengine/docattachview.jsp?docid=<%=sp.getId()%>&attachid=<%=temp[0]%>"><%=objname[0]%>
		</a>
		<%=tagNum %>
	</div>				
	<%
			 }
		}
	%>	
	</li>
	</ul>
	<%}} %>
	</div>	  
	<%@ include file="pagenavigator.jsp"%> 
	</form>
</body>
<script type="text/javascript">
 /**
    获得从提交搜索到页面加裁完成的时间
  */
  	function spentTime(){  		
  	    $("suggest").style.left=$("searchKeys").offsetLeft;
  		var begin=<%=begintime%>;
		var d=new Date();
		var end=d.getTime();
		var spent=end-begin;
		document.all("spent").innerHtml = "<B>"+spent+"</B>";		
		var flag = <%=showType%>
		var obj = document.getElementsByName("hide")
//		var info = flag==1?"简要":"详细";
//		document.getElementById("flag").value = info;
		var info = flag==1?"detail":"simple";
		showSimple(info);
		/*
		for (i=0;i< obj.length;i++) { 
			if(flag == 1)
				obj[i].style.display = "";
			else {
				obj[i].style.display = "none";
			}	
		}
		*/
		var pagesize = <%=pageSize%>;
		if(pagesize == "20") {
			
			document.getElementById("20").src=imgSrc[3];
			
		}
		if(pagesize == "40") {
			document.getElementById("40").src=imgSrc[4];
			
		}
		if(pagesize == "80") {
			
			document.getElementById("80").src=imgSrc[5];
			
		}
	}
	</script>
</html>
