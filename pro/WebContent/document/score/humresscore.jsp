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
<%
Calendar today = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat();
String objid=StringHelper.null2String(request.getParameter("objid"));
ScoreService scoreService=(ScoreService)BaseContext.getBean("scoreService");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService"); 
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem = null;
Humres humres = humresService.getHumresById(objid);
Sysuser sysuser = sysuserService.getSysuserByObjid(objid);
String logonname = StringHelper.null2String(sysuser.getLongonname());
List doclist=new ArrayList();
List loglist=new ArrayList();
List remarklist=new ArrayList();
String sql="";
String createtypeid="402881e40b6093bf010b60a5847d0004";
String searchtypeid="402881980cfacc4d010cfaecb00b0020";

%>
<html> 
  <body>
 	<form action="" name="EweaverForm" method="post">
 	<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolorlight="#CCCCCC" bordercolordark="#FFFFFF">
     			<colgroup> 
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				</colgroup>	
			<tr>
			<td><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7730905d000b")%></td><!-- 姓名 -->
			<td><%=humres.getObjname()%>&nbsp;</td>
			<td><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd5a897c000d")%></td><!-- 部门 -->
<%					      			     
String orgunitid = humres.getOrgid();					      
Orgunit orgunit =  orgunitService.getOrgunit(orgunitid);
String orgName = "";
if (orgunit!=null) orgName = StringHelper.null2String(orgunit.getObjname());			      
%>
						
			<td><%=orgName%>&nbsp;</td>
			</tr>
			<tr>
			<td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450025")%></td><!-- 个人账号 -->
			<td><%=logonname%>&nbsp;</td>
			<td><%=labelService.getLabelNameByKeyId("402881e510e569090110e56e72330003")%></td><!-- 岗位 -->
<%
String station = " ";
if(!StringHelper.isEmpty(humres.getStation())){
selectitem = selectitemService.getSelectitemById(humres.getStation());
station =StringHelper.null2String(selectitem.getObjname());
}
%>
			<td><%=station%>&nbsp;</td>
			</tr>
			<tr>
			<td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450026")%></td><!-- 论坛昵称 -->
			<td ColSpan="3">&nbsp;</td>
			</tr>
			<tr>
			<td RowSpan="4"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450027")%></td><!-- 积分信息 -->
<%
//-----------------------------------------知识贡献积分
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaea3c760018");//获取创建积分系数
int createjfxs=Integer.parseInt(selectitem.getObjdesc());
sql="from Docbase where creator='"+objid+"'";
doclist=(List)scoreService.getLoglist(sql);
int gxcount=0;
if (doclist.size()>0)
    gxcount=doclist.size();
int gxjfcount=gxcount*createjfxs;
//-----------------------------------------知识索取积分
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaecb00b0020");//获取阅读积分系数
int docreadjfxs=Integer.parseInt(selectitem.getObjdesc());
sql="from Log where logtype='"+searchtypeid+"' and submitor='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int sqcount=0;
if (loglist.size()>0)
    sqcount=loglist.size();
int sqjfcount=sqcount*docreadjfxs;
//-----------------------------------------知识推进积分
sql="from Remark where type=1 and humresid='"+objid+"'";
remarklist=(List)scoreService.getLoglist(sql);
int dpcount=0;
if (remarklist.size()>0)
    dpcount=remarklist.size();
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaecb00b0021");//获取点评系数
int dpjfxs=Integer.parseInt(selectitem.getObjdesc());
int dpjfcount=dpcount*dpjfxs;
sql="from Remark where type=2 and humresid='"+objid+"'";
remarklist=(List)scoreService.getLoglist(sql);
int tjcount=0;
if (remarklist.size()>0)
    tjcount=remarklist.size();
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaecb00b0022");//获取推荐系数
int tjjfxs=Integer.parseInt(selectitem.getObjdesc());
int tjjfcount=tjcount*tjjfxs;
int tjsum=dpjfcount+tjjfcount;
//--------------------------------------------------------综合积分
int sum=gxjfcount+sqjfcount+tjsum;
%>           <!--综合积分   分 -->
			<td ColSpan="3"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450028")%>：<%=sum%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td>
			</tr>
			<tr><!-- 知识贡献积分 分 -->
			<td ColSpan="3"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450029")%>：<%=gxjfcount%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td>
			</tr>
			<tr><!-- 知识索取积分 分 -->
			<td ColSpan="3"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002a")%>：<%=sqjfcount%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td>
			</tr>
			<tr><!--知识推进积分 分   -->
			<td ColSpan="3"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45002b")%>：<%=tjsum%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td>
			</tr>
 	</table>
 	</form>
  </body>
</html>
