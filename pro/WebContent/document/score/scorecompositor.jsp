<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.Page"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="com.eweaver.document.base.model.*"%>
<%@ page import="com.eweaver.document.base.service.*"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.document.score.service.ScoreService"%>
<%@ page import="com.eweaver.document.score.model.Score"%>
<%@ page import="com.eweaver.base.log.model.Log"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%> 
<%@ page import="java.lang.Comparable"%>
<%
String sum=StringHelper.null2String(request.getParameter("count"));
int n=10;
if(!StringHelper.isEmpty(sum))
       n=Integer.parseInt(sum);
       
Calendar today = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat();
sdf = new SimpleDateFormat("yyyy-MM-dd");
ScoreService scoreService=(ScoreService)BaseContext.getBean("scoreService");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService"); 
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");

List humresscorelist=new ArrayList();
List humresscorelist2=new ArrayList();
List humresscorelist3=new ArrayList();
List humreslist=new ArrayList();
humreslist=humresService.getAllHumres();

//---------------------------获取本周第一天和最后一天


today.add(Calendar.DATE,1-today.get(Calendar.DAY_OF_WEEK));
String datebegin=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,6);
String dateend=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,-6);//重新定位到第一天


//---------------------------获取本月第一天和最后一天


today.add(Calendar.DATE,1-today.get(Calendar.DAY_OF_MONTH));
String datebeginMonth=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,today.getActualMaximum(today.DATE)-1);
String dateendMonth = StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,1-today.getActualMaximum(today.DATE));//重新定位到第一天




if(humreslist.size()>0){
    for(int i=0;i<humreslist.size();i++){
   		Humres humres=(Humres)humreslist.get(i);
    	int count=  scoreService.getHumresScore(humres.getId());
         Score score=new Score();
         score.setCountscore(count);
         score.setHumresid(humres.getId());
         humresscorelist.add(score);
   }
   for(int i=0;i<humreslist.size();i++){
   		Humres humres=(Humres)humreslist.get(i);
    	int count2=  scoreService.getHumresScore(humres.getId(),datebegin,dateend);
         Score score=new Score();
         score.setCountscore(count2);
         score.setHumresid(humres.getId());
         humresscorelist2.add(score);
   }
   
   for(int i=0;i<humreslist.size();i++){
   		Humres humres=(Humres)humreslist.get(i);
    	int count3=  scoreService.getHumresScore(humres.getId(),datebeginMonth,dateendMonth);
         Score score=new Score();
         score.setCountscore(count3);
         score.setHumresid(humres.getId());
         humresscorelist3.add(score);
   }
   

}
Collections.sort(humresscorelist);
Collections.sort(humresscorelist2);
Collections.sort(humresscorelist3);
Collections.reverse(humresscorelist);
Collections.reverse(humresscorelist2);
Collections.reverse(humresscorelist3);
%>
<html> 
  <body>
 	<form action="<%=request.getContextPath()%>/document/score/scorecompositor.jsp" name="EweaverForm" method="post">
 	   <TABLE width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolorlight="#CCCCCC" bordercolordark="#FFFFFF">
 	   			<col width="10%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
				</col>
 	       <TR>
 	          <TD Align="Center"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002c")%></TD><!-- 本周积分排行 -->
 	          <TD Align="Center"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002d")%></TD><!-- 本月积分排行 -->
 	          <TD Align="Center"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002e")%></TD><!-- 累计积分排行 -->
 	       </TR>
<%
Score score1=new Score();
Humres humres=new Humres();
for(int i=0;i<n;i++){
%>
           <TR>
           
<%
if(humresscorelist2.size()>i){
score1=(Score)humresscorelist2.get(i);
humres=humresService.getHumresById(score1.getHumresid());
%>
           <TD><a href="javascript:openDialog('/humres/base/humresview.jsp?id=<%=score1.getHumresid()%>')"><%=StringHelper.null2String(humres.getObjname())%></a>：&nbsp;&nbsp;&nbsp;&nbsp;<%=score1.getCountscore()%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></TD><!-- 分 -->
<%
}
if(humresscorelist3.size()>i){
score1=(Score)humresscorelist3.get(i);
humres=humresService.getHumresById(score1.getHumresid());
%>
           <TD><a href="javascript:openDialog('/humres/base/humresview.jsp?id=<%=score1.getHumresid()%>')"><%=StringHelper.null2String(humres.getObjname())%></a>：&nbsp;&nbsp;&nbsp;&nbsp;<%=score1.getCountscore()%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></TD><!-- 分 -->
<%
}
if(humresscorelist.size()>i){
score1=(Score)humresscorelist.get(i);
humres=humresService.getHumresById(score1.getHumresid());
%>
           <TD><a href="javascript:openDialog('/humres/base/humresview.jsp?id=<%=score1.getHumresid()%>')"><%=StringHelper.null2String(humres.getObjname())%></a>：&nbsp;&nbsp;&nbsp;&nbsp;<%=score1.getCountscore()%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></TD><!-- 分 -->
<%}%>
           </TR>
<%}%>
          <TR><!-- 查看前 -->   <!-- 名积分信息 -->
          <TD ColSpan="3"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002f")%><input type="text" onkeypress="return event.keyCode>=48&&event.keyCode<=57||(this.value.indexOf('.')<0?event.keyCode==46:false)" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false"   name="count" value="10"/><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450030")%> <input type=button value=统计 onClick='javascript:EweaverForm.submit();'></TD>
          </TR>
 	   </TABLE>
    </form>
  </body>
</html>
