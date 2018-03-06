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
<%
Calendar today = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat();
String objid=StringHelper.null2String(request.getParameter("objid"));
ScoreService scoreService=(ScoreService)BaseContext.getBean("scoreService");
DocbaseService docbaseService = (DocbaseService) BaseContext.getBean("docbaseService");
CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
Docbase docbase = docbaseService.getPermissionObjectById(objid);
List categoryList = categoryService.getCategoryListByObj(objid);
List loglist=new ArrayList();
String createtypeid="402881e40b6093bf010b60a5847d0004";
String searchtypeid="402881e40b6093bf010b60a5849c0007";
String searchsql="from Log where logtype='"+searchtypeid+"' and objid='"+objid+"' order by submitdate desc,submittime desc";
%>
<html> 
  <body>
 	<form action="" name="EweaverForm" method="post">
 	<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolorlight="#CCCCCC" bordercolordark="#FFFFFF">
     				<colgroup> 
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
					<col width="10%">
				</colgroup>	
 	
 	<tr >
 	    <td ColSpan="8" Align="Center"><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980062")%>:<%=sdf.format(today.getTime())%></td><!-- 最后统计时间 -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e890000")%>:</td><!-- 文档标题 -->
       <td ColSpan="7"><%=StringHelper.null2String(docbase.getSubject())%></td>
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980063")%>:</td><!-- 所述分类 -->
 	   <td ColSpan="7"><%=categoryService.getCategoryPath(categoryList,null,null)%></td>
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("402881eb0bd74dcf010bd753e2b50008")%>:</td><!-- 创建时间 -->
 	   <td><%=StringHelper.null2String(docbase.getCreatedate())%>&nbsp;<%=StringHelper.null2String(docbase.getCreatetime())%></td>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350000")%>:</td><!-- 最后修改时间 -->
 	   <td><%=docbase.getModifydate()%>&nbsp;<%=docbase.getModifytime()%></td>
<%
loglist=(List)scoreService.getLoglist(searchsql);
String submitorname="";
String submitdate="";
String submittime="";
int count=loglist.size();
String submitip="";
if(loglist.size()>0){
    Log log=(Log)loglist.get(0);
    if(!StringHelper.isEmpty(log.getSubmitor()))
    submitorname=StringHelper.null2String(humresService.getHrmresNameById(log.getSubmitor()));
    submitdate=StringHelper.null2String(log.getSubmitdate());
    submittime=StringHelper.null2String(log.getSubmittime());
    submitip=StringHelper.null2String(log.getSubmitip());
}
%>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350001")%>:</td><!--最后阅读时间  -->
 	   <td ColSpan="3"><%=submitdate%>&nbsp;<%=submittime%></td>
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd7215e7b000a")%>:</td><!-- 创建人 -->
 	   <td>
		<a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=docbase.getCreator()%>">
		  <%=humresService.getHrmresNameById(docbase.getCreator())%>
		</a>
       </td>
 	   <td><%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd720023f0009")%>:</td><!-- 最后修改人 -->
 	   <td>					
 	   <a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=docbase.getModifier()%>">
	     <%=humresService.getHrmresNameById(docbase.getModifier())%>
	   </a>
	   </td>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350002")%>:</td><!-- 最后阅读人 -->
 	   <td ColSpan="3"><a href="<%=request.getContextPath()%>/humres/base/humresview.jsp?id=<%=docbase.getModifier()%>"><%=submitorname%></a></td>
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350003")%>:</td><!-- 创建时IP -->
 	   <td><%=submitip%></td>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350004")%>:</td><!-- 最后修改时IP -->
 	   <td><%=submitip%></td>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350005")%>:</td><!-- 最后阅读时IP -->
 	   <td ColSpan="3"><%=submitip%></td>
 	</tr>
 	<tr >
 	    <td ColSpan="8"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350006")%></td><!-- 阅读次数信息 -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350007")%>:</td><!-- 累计阅读次数 -->
 	   <td ColSpan="7"><%=count%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	</tr>
 	<tr>
<%
sdf = new SimpleDateFormat("yyyy-MM-dd");
String todaydate=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,-1) ;
String yesterdaydate=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,1) ;
int todaycount=scoreService.getLogCount(todaydate,searchtypeid,objid);
int yestodaycount=scoreService.getLogCount(yesterdaydate,searchtypeid,objid);

//---------------------------获取本周第一天和最后一天

today.add(Calendar.DATE,1-today.get(Calendar.DAY_OF_WEEK));
String datebegin=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,6);
String dateend=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,-6);//重新定位到第一天

int weekcount=scoreService.getLogCount(datebegin,dateend,searchtypeid,objid);
//---------------------------获取本月第一天和最后一天

today.add(Calendar.DATE,1-today.get(Calendar.DAY_OF_MONTH));
String datebeginMonth=StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,today.getActualMaximum(today.DATE)-1);
String dateendMonth = StringHelper.null2String(sdf.format(today.getTime()));
today.add(Calendar.DATE,1-today.getActualMaximum(today.DATE));//重新定位到第一天

int monthcount=scoreService.getLogCount(datebeginMonth,dateendMonth,searchtypeid,objid);
%>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350009")%>:</td><!-- 今日阅读次数 -->
 	   <td><%=todaycount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000a")%>:</td><!-- 昨日阅读次数 -->
 	   <td><%=yestodaycount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000b")%>:</td><!-- 本周阅读次数 -->
 	   <td><%=weekcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000b")%>:</td><!-- 本月阅读次数 -->
 	   <td><%=monthcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	</tr>
 	<tr >
 	    <td ColSpan="8"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000c")%></td><!-- 阅读人次信息 -->
 	</tr>
<%
String sql="select distinct submitor from Log where objid='"+objid+"' and logtype='"+searchtypeid+"'";
loglist=(List)scoreService.getLoglist(sql);
int ydcount=0;
if (loglist.size()>0)
    ydcount=loglist.size();
sql="select distinct submitor from Log where submitdate='"+todaydate+"' and objid='"+objid+"' and logtype='"+searchtypeid+"'";
loglist=(List)scoreService.getLoglist(sql);
int tydcount=0;
if (loglist.size()>0)
    tydcount=loglist.size();
sql="select distinct submitor from Log where submitdate='"+yesterdaydate+"' and objid='"+objid+"' and logtype='"+searchtypeid+"'";
loglist=(List)scoreService.getLoglist(sql);
int yydcount=0;
if (loglist.size()>0)
    yydcount=loglist.size();
sql="select distinct submitor from Log where submitdate between '"+datebegin+"' and  '"+dateend+"' and objid='"+objid+"' and logtype='"+searchtypeid+"'";
loglist=(List)scoreService.getLoglist(sql);
int wydcount=0;
if (loglist.size()>0)
    wydcount=loglist.size();
sql="select distinct submitor from Log where submitdate between '"+datebeginMonth+"' and  '"+dateendMonth+"' and objid='"+objid+"' and logtype='"+searchtypeid+"'";
loglist=(List)scoreService.getLoglist(sql);
int mydcount=0;
if (loglist.size()>0)
    mydcount=loglist.size();
    
%>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000d")%>:</td><!--累计阅读人数  -->
 	   <td ColSpan="7"><%=ydcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000e")%>:</td><!-- 今日阅读人数 -->
 	   <td><%=tydcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350010")%>:</td><!-- 昨日阅读人数 -->
 	   <td><%=yydcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350011")%>:</td><!-- 本周阅读人数 -->
 	   <td><%=wydcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350012")%>:</td><!-- 本月阅读人数 -->
 	   <td><%=mydcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	</tr>
 	<tr >
 	    <td ColSpan="8"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350013")%></td><!-- 回复次数信息 -->
 	</tr>
<%
sql="from Docbase where pid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int rdcount=0;
if (loglist.size()>0)
    rdcount=loglist.size();
sql="from Docbase where pid='"+objid+"' and createdate='"+todaydate+"'";
loglist=(List)scoreService.getLoglist(sql);
int trdcount=0;
if (loglist.size()>0)
    trdcount=loglist.size();
sql="from Docbase where pid='"+objid+"' and createdate='"+yesterdaydate+"'";
loglist=(List)scoreService.getLoglist(sql);
int yrdcount=0;
if (loglist.size()>0)
    yrdcount=loglist.size();
sql="from Docbase where pid='"+objid+"' and  createdate between '"+datebegin+"' and  '"+dateend+"'";
loglist=(List)scoreService.getLoglist(sql);
int wrdcount=0;
if (loglist.size()>0)
    wrdcount=loglist.size();
sql="from Docbase where pid='"+objid+"' and  createdate between '"+datebeginMonth+"' and  '"+dateendMonth+"'";
loglist=(List)scoreService.getLoglist(sql);
int mrdcount=0;
if (loglist.size()>0)
    mrdcount=loglist.size();
%>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350014")%>:</td><!-- 回复次数 -->
 	   <td ColSpan="7"><%=rdcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350015")%>:</td><!-- 今日回复次数 -->
 	   <td><%=trdcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350016")%>:</td><!-- 昨日回复次数 -->
 	   <td><%=yrdcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450017")%>:</td><!-- 本周回复次数 -->
 	   <td><%=wrdcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450018")%>:</td><!-- 本月回复次数 -->
 	   <td><%=mrdcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c350008")%></td><!-- 次 -->
 	</tr>
 	<tr >
 	    <td ColSpan="8"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450019")%></td><!-- 回复人次信息 -->
 	</tr>
<%
sql="select distinct creator  from Docbase where pid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int hfcount=0;
if (loglist.size()>0)
    hfcount=loglist.size();
sql="select distinct creator from  Docbase where pid='"+objid+"' and createdate='"+todaydate+"'";
loglist=(List)scoreService.getLoglist(sql);
int thfcount=0;
if (loglist.size()>0)
    thfcount=loglist.size();
sql="select distinct creator from Docbase where pid='"+objid+"' and createdate='"+yesterdaydate+"'";
loglist=(List)scoreService.getLoglist(sql);
int yhfcount=0;
if (loglist.size()>0)
    yhfcount=loglist.size();
sql="select distinct creator from Docbase where pid='"+objid+"' and  createdate between '"+datebegin+"' and  '"+dateend+"'";
loglist=(List)scoreService.getLoglist(sql);
int whfcount=0;
if (loglist.size()>0)
    whfcount=loglist.size();
sql="select distinct creator from Docbase where pid='"+objid+"' and  createdate between '"+datebeginMonth+"' and  '"+dateendMonth+"'";
loglist=(List)scoreService.getLoglist(sql);
int mhfcount=0;
if (loglist.size()>0)
    mhfcount=loglist.size();
%>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001a")%>:</td><!--  累计回复人数-->
 	   <td ColSpan="7"><%=hfcount%>人</td><!-- 人 -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001b")%>:</td><!-- 今日回复人数 -->
 	   <td><%=thfcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001c")%>:</td><!-- 昨日回复人数 -->
 	   <td><%=yhfcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001d")%>:</td><!-- 本周回复人数 -->
 	   <td><%=whfcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001e")%>:</td><!--本月回复人数  -->
 	   <td><%=mhfcount%><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c35000f")%></td><!-- 人 -->
 	</tr>
 	<tr >
 	    <td ColSpan="8"><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c45001f")%></td><!-- 本文积分信息 -->
 	</tr>
<%
SelectitemService selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
Selectitem selectitem;
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaea3c760018");//获取创建积分系数
int createjfxs=Integer.parseInt(selectitem.getObjdesc());
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaea3c760019");//获取阅读积分系数
int docreadjfxs=Integer.parseInt(selectitem.getObjdesc());
int sumdocreadscore=docreadjfxs*count;
sql="from Remark where type=1 and objid='"+objid+"'";//获取总点评次数

loglist=(List)scoreService.getLoglist(sql);
int remarkcount=0;
if (loglist.size()>0)
     remarkcount=loglist.size();
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaea3c80001a");//获取点评系数
int dpjfxs=Integer.parseInt(selectitem.getObjdesc());
int sumremarkcount=remarkcount*dpjfxs;

sql="from Remark where type=2 and objid='"+objid+"'";//获取总推荐次数

loglist=(List)scoreService.getLoglist(sql);
int tjcount=0;
if (loglist.size()>0)
     tjcount=loglist.size();
selectitem=selectitemService.getSelectitemById("402881980cfacc4d010cfaea3c80001b");//获取推荐系数
int tjjfxs=Integer.parseInt(selectitem.getObjdesc());
int sumtjcount=tjcount*tjjfxs;
int sum=createjfxs+sumdocreadscore+sumremarkcount+sumtjcount;//总积分

//-------------------------------------------------------------------------------------
int sumtdocreadscore=tydcount*docreadjfxs;//今天阅读积分
sql="from Remark where createdate='"+todaydate+"' and type=1 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int tdocdpscore=0;
if (loglist.size()>0)
     tdocdpscore=loglist.size();
int sumtdocdpscore=tdocdpscore*dpjfxs;//今天点评积分

sql="from Remark where createdate='"+todaydate+"' and type=2 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int tdoctjscore=0;
if (loglist.size()>0)
     tdoctjscore=loglist.size();
int sumtdoctjscore=tdoctjscore*tjjfxs;//今天推荐积分

int tsumscore=sumtdocreadscore+sumtdocdpscore+sumtdoctjscore;
//---------------------------------------------------------------------------------------
int sumydocreadscore=tydcount*docreadjfxs;//昨天阅读积分
sql="from Remark where createdate='"+yesterdaydate+"' and type=1 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int ydocdpscore=0;
if (loglist.size()>0)
     tdocdpscore=loglist.size();
int sumydocdpscore=tdocdpscore*dpjfxs;//昨天点评积分

sql="from Remark where createdate='"+yesterdaydate+"' and type=2 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int ydoctjscore=0;
if (loglist.size()>0)
     tdoctjscore=loglist.size();
int sumydoctjscore=tdoctjscore*tjjfxs;//昨天推荐积分

int ysumscore=sumydocreadscore+sumydocdpscore+sumydoctjscore;
//---------------------------------------------------------------------------------------
int sumwdocreadscore=tydcount*docreadjfxs;//本周阅读积分
sql="from Remark where createdate between '"+datebegin+"' and  '"+dateend+"' and type=1 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int wdocdpscore=0;
if (loglist.size()>0)
     tdocdpscore=loglist.size();
int sumwdocdpscore=tdocdpscore*dpjfxs;//本周点评积分

sql="from Remark where createdate between '"+datebegin+"' and  '"+dateend+"'and  type=2 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int wdoctjscore=0;
if (loglist.size()>0)
     tdoctjscore=loglist.size();
int sumwdoctjscore=tdoctjscore*tjjfxs;//本周推荐积分

int wsumscore=sumwdocreadscore+sumwdocdpscore+sumwdoctjscore;
//---------------------------------------------------------------------------------------
int summdocreadscore=tydcount*docreadjfxs;//本月阅读积分
sql="from Remark where createdate between '"+datebegin+"' and  '"+dateend+"'and  type=1 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int mdocdpscore=0;
if (loglist.size()>0)
     tdocdpscore=loglist.size();
int summdocdpscore=tdocdpscore*dpjfxs;//本月点评积分

sql="from Remark where createdate between '"+datebegin+"' and  '"+dateend+"'and  type=2 and objid='"+objid+"'";
loglist=(List)scoreService.getLoglist(sql);
int mdoctjscore=0;
if (loglist.size()>0)
     tdoctjscore=loglist.size();
int summdoctjscore=tdoctjscore*tjjfxs;//本月推荐积分

int msumscore=summdocreadscore+summdocdpscore+summdoctjscore;
//---------------------------------------------------------------------------------------

%>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450020")%>:</td><!-- 本文积分 -->
 	   <td ColSpan="7"><%=sum%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td><!--分  -->
 	</tr>
 	<tr>
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450021")%>:</td><!-- 今日本文积分 -->
 	   <td><%=tsumscore%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td><!--分  -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450022")%>:</td><!--昨日本文积分-->
 	   <td><%=ysumscore%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td><!--分  -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450023")%>:</td><!-- 本周本文积分 -->
 	   <td><%=wsumscore%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td><!--分  -->
 	   <td><%=labelService.getLabelNameByKeyId("4028834634e56e090134e56e0c450024")%>:</td><!--本月本文积分  -->
 	   <td><%=msumscore%><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980014")%></td><!--分  -->
 	</tr>
 	</table>
 	</form>
  </body>
</html>
