<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/cooperation/init.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String requestid=StringHelper.null2String(request.getParameter("requestid"));
%>
<html>
  <head>
    <title></title>
<link  type="text/css" rel="stylesheet" href="/app/cooperation/css/default.css" />   
<%if(userMainPage.getIsUseSkin()){%>
<link rel="stylesheet" type="text/css" id="main_css" href="<%=currentSkin.getBasePath() %>/cooperation.css"/>
<%}%>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" language="javascript" src="/app/cooperation/js/openUrl.js"></script>
	<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/app/cooperation/js/scripts/boot.js"></script>
	<script>
	function onItemClick(e) {        
	    var item = e.item;
	    var isLeaf = e.isLeaf;
	    if (isLeaf) {
	       var text = item.text;
	       var id = item.id;
	       if(id=="replypage1"){//相关交流
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>");
	       }
	       if(id=="readlog"){
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/coworklogpage.jsp?requestid=<%=requestid %>");
	       }
	       
	       if(id=="replypage2_1"){
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/participantlist.jsp?requestid=<%=requestid %>");
	       }
	       
	       if(id=="replypage2_2"){
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/participantlist2.jsp?requestid=<%=requestid %>");
	       }
	       
	       if(id=="replypage2_3"){
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/participantlist3.jsp?requestid=<%=requestid %>");
	       }
	       id = id+"";
	       if(id.substring(0,11)=="replypage3_"){
	    	   var addtype=id.substring(11);
	    	   onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/addfunctionlist.jsp?requestid=<%=requestid %>&addtype="+addtype);
	       }
	       if(id=="searchreply"){
	       var replfyframe = document.getElementById("replyframe");
	         try{  
		          if(typeof(eval(replfyframe.contentWindow.changeTable))=="function"){
		              replfyframe.contentWindow.changeTable();
		          }else{
		              onP_openURL("replyframe","<%= request.getContextPath()%>/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>&search=1");
		          }
	         }catch(e){
	        
	         }  
	       }
	    }            
	}
	</script>
  </head>
  <body>
    <table width="100%" cellpadding="0" cellspacing="0">
    <tr style="height: auto;" valign="top">
		<td colspan="2">
			<!--  begin 协作区列表显示 -->
			<ul id="menu1" class="mini-menubar" style="width:100%;border:0px;margin-top:5px;" url="/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=replymenu&requestid=<%=requestid %>" onitemclick="onItemClick" textField="text" idField="id" parentField="pid" >
			</ul>    
			<iframe width="100%" height="auto" BORDER="0" FRAMEBORDER="0" noresize="noresize" src="<%= request.getContextPath()%>/app/cooperation/reply/replycoworklist.jsp?requestid=<%=requestid %>" name="replyframe" id="replyframe" scrolling="no">
            </iframe>
			<!--  end  协作区列表显示 -->
		</td>
	</tr>
    </table>
  </body>
</html>
