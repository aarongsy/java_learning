
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%
	String condition=StringHelper.null2String(request.getParameter("condition"));
	while(condition.indexOf("@")!=-1){
		condition=condition.replace("@","%");
	}
	while(condition.indexOf("syh")!=-1){
		condition=condition.replace("syh","\"");
	}
%>
<HTML>

	
	<BODY>
		<DIV id="TopTitle" class=TopTitle Style="display:''">
			<IMG src="<%=request.getContextPath()%>/images/main/titlebar_bg.jpg">
			<%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71f4d7580053")%>：<!-- 查询条件 -->
				<button type="button" class='btn' accesskey="S" onclick="javascript:btnok_onclick();">
		  	<u>S</u>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022")%><!-- 确定 -->
		  </button>
		</DIV>
	 	<form action="" name="EweaverForm" method="post">
			<TEXTAREA NAME="condition" id="condition"  ROWS="1" COLS="1" style="width: 100%;height: 340px"><%=condition%></TEXTAREA>
	    </form>
	    <DIV>
		<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220044")%><font color="red">$currentdate$,$currenttime$,$currentuser$,$currentorgunit$,<!-- 说明：过滤条件为SQL语句，可使用的参数为 -->
		PARM()</font>.<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220045")%>'$currentorgunit$' =<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220046")%>,
		A.f4 like '%$currentorgunit$%'
		<br><br><!-- 子表的字段为A.*** 例如： --><!-- A.f4既是当前登录人的部门=子表的f4字段 -->
		<font color="red"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220047")%></font><!-- 注意：红色字体的参数是大小写相关的，如果字段是字符字段，别忘记打在两端打单引号 -->
	    </DIV>
		<script language="javascript" type="text/javascript">
			function onSubmit(){
		  		alert("condision");
			
		   		//document.EweaverForm.submit();
				window.close();
		    }
		  	window.onunload=function(){
				btnok_onclick();
			};
		</script>
    </body>
</html>
<SCRIPT LANGUAGE=VBS>


Sub btnok_onclick()
	destList = document.all("condition").value
	window.parent.returnvalue = destList
	window.parent.close
End Sub

</SCRIPT>