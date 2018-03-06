<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*, weaver.systeminfo.SystemEnv" %> 
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%

String flag = "0";
String UserUid = "";
String Userid1 = "";
String f_weaver_belongto_userid = "";

User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

if(user == null){
}else{
	UserUid = user.getUID() +"";
}
int userid = Util.getIntValue(request.getParameter("userid"), -1);
Userid1 = userid+"";
f_weaver_belongto_userid = request.getParameter("f_weaver_belongto_userid");


	int requestid = Util.getIntValue(request.getParameter("requestid"));//请求id
	int workflowid = Util.getIntValue(request.getParameter("workflowid"));//流程id
	int formid = Util.getIntValue(request.getParameter("formid"));//表单id
	int isbill = Util.getIntValue(request.getParameter("isbill"));//表单类型，1单据，0表单
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));//流程的节点id
	
	
	
	//String name = SystemEnv.getHtmlLabelName(197,user.getLanguage());//获取语言文字
	rs.execute("select nownodeid from workflow_nownode where requestid="+requestid); 
	rs.next();
	int nownodeid = Util.getIntValue(rs.getString("nownodeid"),nodeid);
	rs.execute("select nodeid from workflow_flownode where nodetype=0 and workflowid="+workflowid);
	rs.next();
	int onodeid = Util.getIntValue(rs.getString("nodeid"),0);
	
	rs.execute("select * from uf_dmhr_otapp where requestid="+requestid);
	rs.next();
	int jobname = Util.getIntValue(rs.getString("jobname"));
	

	
%>
<!-- OverTime Application流程 -->
<!-- nownodeid： 383 开始Apply   387 加班确认ActualOT-->
<script type="text/javascript"> 

var width = document.body.clientWidth*0.9;
jQuery(document).ready(function() {

alert("Userid1="+"<%=Userid1 %>");
alert("UserUid="+"<%=UserUid %>");
alert("f_weaver_belongto_userid="+"<%=test %>");      
});
</script>