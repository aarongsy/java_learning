<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.cpms.comment.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.document.base.model.*"%>

<%
String objid = StringHelper.null2String(request.getParameter("objid"));
String taskid = StringHelper.null2String(request.getParameter("taskid"));
String subject = StringHelper.null2String(request.getParameter("subject"));
DataService dataService =new DataService();
CommentService commentService =(CommentService)BaseContext.getBean("commentService");
HumresService humresService =(HumresService)BaseContext.getBean("humresService");
String sql="from Comment where objid='"+objid+"' ";
if(!StringHelper.isEmpty(taskid)){
	sql+="and taskid='"+taskid+"' ";
}
sql+="order by createdate desc,createtime desc";
List commentList = commentService.find(sql);
AttachService attachService = (AttachService) BaseContext.getBean("attachService");

%>
<html>
<head>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/js/formbase.js"></script>
<script type="text/javascript" language="javascript" src="/cpms/scripts/comment.js"></script>
<link rel="stylesheet" type="text/css" href="/css/global.css">
<link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
<link rel="stylesheet" type="text/css" href="/cpms/styles/jive.css" />
<style type="text/css">
body,form{margin: 0px;padding: 2px;}
a.button{
	font-weight: bold;
	border: solid 1px #bbcee1;
	padding: 2 5 2 5;
	background-color: #e6f0f9;
	color: #587bbd;
}
a.button:visited{
	color: #587bbd;
}
a.button:hover{
	color: #587bbd;
	background-color: #edf4fc;
	text-decoration: none;
}
</style>
<script type="text/javascript">
  var tb = new Ext.Toolbar();
</script>
</head>
<body onload="init();">
<div style="line-height:25px;vertical-align:middle;  padding: 4 0 4 2">
	<a class="button" id="showReplay" href="#" onclick="addComment();"><img src="/images/silk/comment_add.gif" align="absmiddle" > 发表话题</a>
</div>
<div>
<form action="/ServiceAction/com.eweaver.cpms.comment.CommentAction?action=save" name="CommentForm" id="CommentForm" style="display:none" method="post">
	<input type="hidden" name="objid" value="<%=objid%>">
	<input type="hidden" name="taskid" value="<%=taskid%>">
	<input type="hidden" id="attachs" name="attachs">
	<table id="contentDiv" border="0">
		<tr>
			<td align="center">标题:</td>
			<td>
				<input type="text" style="width: 100%" name="subject" id="subject" value="<%=subject%>" />
			</td>
		</tr>
		<tr>
			<td align="center">内容:</td>
			<td>
				<textarea name="content" id="content"></textarea>
			</td>
		</tr>
		<TR>
			<TD align="center">附件:</TD>
			<TD>
				<div id="fileUploadDIV" ></div>
				<iframe width="100%" height="20" name="uploadIframe" id="uploadIframe" frameborder=0 scrolling=auto src="/base/fileupload.jsp"></iframe>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD style="padding: 5px;">
				<a id="saveComment" class="button" href="#" onclick="javascript:onSave();"><img src="/images/silk/comment_edit.gif" align="absmiddle" > 发  表 </a>
				<a style="margin-left: 30px;" href="#" onclick="javascript:hideComment();"> 取 消  </a>
			</TD>
		</TR>
	</table>
</form>
</div>
<div id="comments" style="padding: 2px;">
<%if(commentList!=null&commentList.size()>0){
for(int i=0;i<commentList.size();i++){
	Comment comment = (Comment)commentList.get(i);
	String alt="";
	if(i%2==1){
		alt="jive-thread-reply-alt jive-thread-reply-postauthor";
	}
%>
	<DIV class="jive-thread-reply <%=alt%>">
		<DIV class=jive-thread-reply-body>
			<DIV class=jive-author>
				<SPAN class=jive-author-avatar-container> 
					<A class=jiveTT-hover-user href="#"> 
						<IMG class=jive-avatar	border=0 alt="<%=humresService.getHrmresNameById(comment.getCreator())%>" src="/cpms/images/avatar.png">
					</A> 
				</SPAN>
				<DIV class=jive-username-link-wrapper>
					<A class="jiveTT-hover-user jive-username-link" href="#"><%=humresService.getHrmresNameById(comment.getCreator())%></A>
				</DIV>
				<EM><%=comment.getCreatedate()%> <%=comment.getCreatetime()%></EM>
			</DIV>
			<DIV class=jive-thread-reply-body-container>
				<DIV class=jive-thread-reply-subject>
					<DIV class=jive-thread-reply-date>
						<SPAN><%=humresService.getHrmresNameById(comment.getCreator())%>发表于<%=comment.getCreatedate()%> <%=comment.getCreatetime()%></SPAN>
					</DIV>
					<span style="font-weight: bold;"><%=StringHelper.null2String(comment.getSubject())%></span>
				</DIV>
				<DIV class=jive-thread-reply-message>
					<DIV class=jive-rendered-content><%=StringHelper.null2String(comment.getContent())%></DIV>
				</DIV>
				<%if(comment.getAttachs()!=null){%>
				<div style="margin:5 0 0 0;padding:0; border: none;">
				<%
				String[] attachids = comment.getAttachs().split(",");
				for(int j=0;j<attachids.length;j++){
					String attachid = attachids[j];
					Attach attachTmp = attachService.getAttach(attachid);
					String attachfilesize = "0";
					if (attachTmp.getFilesize() != null) {
						attachfilesize = StringHelper.numberFormat2(attachTmp.getFilesize().longValue() / 1024.0);
					}
				%>
					<div style="margin:2;padding:0; border: none;">
						<img src="/images/silk/accessory.gif" align="absmiddle">
						<a href="#" onClick="javascript:location.href='/ServiceAction/com.eweaver.document.file.FileDownload?isdownload=1&attachid=<%=attachTmp.getId()%>&download=1'"><%=attachTmp.getObjname()%></a> (<%=attachfilesize%>K)
					</div>
				<%}%>
				</div>
				<%}%>
			</DIV>
		</DIV>
	</DIV>
	
<%}}else{%>
没有交流信息。
<%}%>
</div>
</body>
</html>