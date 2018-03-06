<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.document.remark.service.RemarkService"%>
<%@ page import="com.eweaver.document.remark.model.Remark"%>
<%
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
Humres humres=null;
Remark remark=new Remark();
RemarkService remarkService=(RemarkService)BaseContext.getBean("remarkService");
String id=StringHelper.null2String(request.getParameter("id"));
remark=remarkService.getRemarkById(id);
int score=Integer.parseInt((remark.getScore()).toString());
String humresid=StringHelper.null2String(remark.getHumresid());
String humresname="";
humres=humresService.getHumresById(humresid);
if(humres!=null){
    humresname=StringHelper.null2String(humres.getObjname());
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  </head> 
  <body>
  <!-- 标题 -->
<!--页面菜单开始-->     
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
        
        <!-- form -->
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.document.remark.servlet.RemarkAction?action=create" name="EweaverForm" method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				 <colgroup> 
					<col width="50%">
					<col width="50%">
				</colgroup>
				
				  <tr>
				    <td nowrap><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e98004a")%>：&nbsp;&nbsp;&nbsp;//点评内容
				    <input type="radio" name="score" <%if(score==1){%> checked <%}%> value="1">1<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" <%if(score==2){%> checked <%}%> value="2">2<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" <%if(score==3){%> checked <%}%> value="3">3<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" <%if(score==4){%> checked <%}%> value="4">4<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    <input type="radio" name="score" <%if(score==5){%> checked <%}%> value="5">5<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%><!-- 分 -->

				    </td>
				   <!--  <td nowrap>&nbsp;&nbsp;&nbsp; 推荐该文章:<input type="checkbox" name="score2" value="1"></td>-->
				  </tr>
				  <tr>
				    <td ColSpan="2"><textarea STYLE="width=100%" class=InputStyle rows=10 name="objdesc"><%=StringHelper.null2String(remark.getObjdesc())%></textarea></td>
				  </tr>
				</table>
		</form>
<script language="javascript"> 
function onSubmit(){
   	checkfields="objdesc";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    
</script> 
    </body>
</html>

