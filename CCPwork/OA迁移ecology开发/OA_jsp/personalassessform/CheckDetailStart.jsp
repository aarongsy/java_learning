<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>

<%
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String Year = StringHelper.null2String(request.getParameter("year"));//年度
String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
String planname=StringHelper.null2String(request.getParameter("checkplan"));//考核计划
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
%>
<style type="text/css"> 


tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 


</style>
<script type='text/javascript' language="javascript" ></script>


<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width=60>
<COL width=120>
<COL width=120>
<COL width=160>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
<COL width=120>
</COLGROUP>

<TR  class="tr1">
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>序号</TD>
<TD  noWrap class="td2"  align=center>考核计划</TD>
<TD  noWrap class="td2"  align=center>主管</TD>
<TD  noWrap class="td2"  align=center>部门</TD>
<TD  noWrap class="td2"  align=center>工号</TD>
<TD  noWrap class="td2"  align=center>被考核人</TD>
<TD  noWrap class="td2"  align=center>评分</TD>
<TD  noWrap class="td2"  align=center>人事主管修改评分</TD>
<TD  noWrap class="td2"  align=center>人事主管修改评语</TD>
</tr>

<%
String del="delete from uf_checkcollectchild where requestid='"+requestid+"'";
baseJdbc.update(del);
//and instr('"+comtype+"',(select extrefobjfield5 from humres where id=f.employname))>0
  //考核计划、主管、部门、工号、被考核人
  /*String sql ="select (select a.planname from uf_hr_checkplan a where a.requestid=f.checkplan) as checkplan,f.firstdirector as director,(select d.objname from orgunit d where d.id=f.employdepart)as employdepart,f.employno as employno,(select c.objname from humres c where c.objno=f.employno) as employname,f.totalfirst as firstscore,f.totalagain as againscore,f.totalreview as reviewscore from uf_hr_checkperformance f left join requestbase re on f.requestid=re.id where f.checkyear='"+Year+"' and 1=re.isfinished and 0=re.isdelete and (not exists(select ch.id from  uf_checkcollectchild ch left join uf_hr_checkperformance chf on chf.requestid=ch.requestid  where ch.employno=f.employno and 0=(select isdelete from requestbase where id=ch.requestid) and ch.requestid<>'"+requestid+"'  and chf.checkyear<>'"+Year+"'))";*/

  //String sql="select (select a.planname from uf_hr_checkplan a where a.requestid=f.checkplan)as checkplan,(select wm_concat(objname) from humres where instr(f.firstdirector,id)>0) as director,f.firstdepart as dept,(select d.objname from orgunit d where d.id=f.firstdepart)as employdepart,(select objno from humres where id=f.employname) as employno,(select c.objname from humres c where c.id=f.employname) as employname,f.totalfirst as firstscore,f.totalagain as againscore,f.totalreview as reviewscore from uf_hr_checkperformance f left join requestbase re on f.requestid=re.id where f.checkyear='"+Year+"' and 1=re.isfinished and 0=re.isdelete and f.employno not in(select ch.employno from  uf_checkcollectchild ch left join uf_hr_checkperformance chf on chf.employno=ch.employno  where  0=(select isdelete from requestbase where id=ch.requestid)  and chf.checkyear='"+Year+"') and instr('"+comtype+"',(select extrefobjfield5 from humres where id=f.employname))>0 ";

  //2015年度查询方式
  //String sql="select (select a.planname from uf_hr_checkplan a where a.requestid=f.checkplan)as checkplan,(select wm_concat(objname) from humres where instr(f.firstdirector,id)>0) as director,f.firstdepart as dept,(select d.objname from orgunit d where d.id=f.firstdepart)as employdepart,f.employname as humreid,(select objno from humres where id=f.employname) as employno,(select c.objname from humres c where c.id=f.employname) as employname,f.totalfirst as firstscore,f.totalagain as againscore,f.totalreview as reviewscore from uf_hr_checkperformance f left join requestbase re on f.requestid=re.id where f.checkyear='"+Year+"' and 1=re.isfinished and 0=re.isdelete and f.employname not in(select ch.humreid from  uf_checkcollectchild ch left join uf_hr_checkperformance chf on chf.employname=ch.humreid  where  0=(select isdelete from requestbase where id=ch.requestid)  and chf.checkyear='"+Year+"') and instr('"+comtype+"',(select extrefobjfield5 from humres where id=f.employname))>0 ";


	//2016年度查询方式
    String sql="select (select a.planname from uf_hr_checkplan a where a.requestid=f.checkplan)as checkplan,(select wm_concat(objname) from humres where instr(f.firstdirector,id)>0) as director,f.firstdepart as dept,(select d.objname from orgunit d where d.id=f.firstdepart)as employdepart,f.employname as humreid,(select objno from humres where id=f.employname) as employno,(select c.objname from humres c where c.id=f.employname) as employname,f.totalfirst as firstscore,f.totalagain as againscore,f.totalreview as reviewscore from uf_hr_checkperformance f left join requestbase re on f.requestid=re.id where f.checkyear='"+Year+"' and 1=re.isfinished and 0=re.isdelete and f.employname not in(select ch.humreid from  uf_checkcollectchild ch left join uf_checkcollectmain chf on chf.requestid=ch.requestid  where  0=(select isdelete from requestbase where id=ch.requestid)  and chf.checkyear=(select id from selectitem where objname='"+Year+"')) and instr('"+comtype+"',(select extrefobjfield5 from humres where id=f.employname))>0 ";

  if(!planname.equals(""))
  {
	  sql=sql+" and instr('"+planname+"',f.checkplan)>0";
  }
  sql=sql+" order by f.employno";
  //System.out.println("哈哈哈哈哈哈哈哈哈哈哈："+sql);


  String insertscore="";//初始化需要插入"绩效考核汇总审批中的分数"
  List sublist = baseJdbc.executeSqlForList(sql);
  if(sublist.size()>0){
	 for(int k=0,sizek=sublist.size();k<sizek;k++){
		 Map mk = (Map)sublist.get(k);
		 String checkplan=StringHelper.null2String(mk.get("checkplan"));
		 String director=StringHelper.null2String(mk.get("director"));
		 String employdepart=StringHelper.null2String(mk.get("employdepart"));
		 String dept=StringHelper.null2String(mk.get("dept"));
		 String employno=StringHelper.null2String(mk.get("employno"));
		 String humreid=StringHelper.null2String(mk.get("humreid"));

		 String newsql="select max(jcdedept) as jcdedept1  from uf_hr_pundept where dept=(select orgid  from humres where objno='"+employno+"')";//该员工对应的一级部门
		 String firstdepart="";//初始化归属部门
		 String deptname="";
		 List newsublist=baseJdbc.executeSqlForList(newsql);
		 if(newsublist.size()>0)
		 {
			 Map newmk=(Map)newsublist.get(0);
			 firstdepart=StringHelper.null2String(newmk.get("jcdedept1"));//归属部门id
			 String ssql="select objname from orgunit where id='"+firstdepart+"'";
			 List list=baseJdbc.executeSqlForList(ssql);
			 if(list.size()>0)
			 {
				 Map map=(Map)list.get(0);
				 deptname=StringHelper.null2String(map.get("objname"));//归属部门名称
			 }
			 
		 }

		 String employname=StringHelper.null2String(mk.get("employname"));
		 String firstscore=StringHelper.null2String(mk.get("firstscore"));//初评分数
		 String againscore=StringHelper.null2String(mk.get("againscore"));//复评分数
		 String reviewscore=StringHelper.null2String(mk.get("reviewscore"));//评审分数
		 //若存在"复评分数"有值就取"复评分数",否则就取"评审分数",若"评审分数"也没值,则最后取"初评分数"
		 if(!againscore.equals(""))
		 {
			 insertscore=againscore;
		 }
		 else if(!reviewscore.equals(""))
		 {
			 insertscore=reviewscore;
		 }
		 else
		 {
			 insertscore=firstscore;
		 }
	     
		 //将考核明细插入绩效考核汇总子表中
         String insql="insert into uf_checkcollectchild(id,requestid,checkprocess,checkplan,director,department,employno,employname,score,leadermodifyscore,leadermodifycomment,dirmodifyscore,dirmodifycomment,manmodifyscore,manmodifycomment,lastscore,ordernum,firstdepart,initscore,humreid)values((select sys_guid() from dual),'"+requestid+"','','"+checkplan+"','"+director+"','"+dept+"','"+employno+"','"+employname+"','"+insertscore+"',"+insertscore+",'','"+insertscore+"','',"+insertscore+",'',"+insertscore+","+(k+1)+",'"+firstdepart+"','"+insertscore+"','"+humreid+"')";
		 baseJdbc.update(insql);
%>

<TR   id="dataDetail" class="tr1">
<TD   class="td2"  align=center><input id=<%="che"+k%> name="che" type="checkbox"></TD>
<TD   class="td2"  align=center><%=checkplan%></TD><!--考核计划 -->
<TD   class="td2"  align=center><%=director%></TD><!--主管 -->
<TD   class="td2"  align=center><%=deptname%></TD><!--部门-->
<TD   class="td2"  align=center><input id=<%="jobno"+k%> type="hidden" value=<%=employno%>><%=employno%></TD><!--工号-->
<TD   class="td2"  align=center><%=employname%></TD><!--被考核人-->
<TD   class="td2"  align=center><%=insertscore%></TD><!--评分-->
<TD   class="td2"  align=center>
<select id="<%="select_"+k%>" style="width:120px" onchange="ChangeScore('<%="id1"+k%>','<%=employno%>','<%=k%>')" >
<option value="<%=insertscore%>"></option>
<option value="0">0</option>
<option value="0.5">0.5</option>
<option value="1">1</option>
<option value="1.5">1.5</option>
<option value="2">2</option>
<option value="2.5">2.5</option>
<option value="3">3</option>
<option value="3.5">3.5</option>
<option value="4">4</option>
<option value="4.5">4.5</option>
<option value="5">5</option>
</select>
</TD><!--人事主管修改评分 -->
<TD   class="td2"  align=center><input id=<%="id2"+k%> type="text" style="width:120px;" onchange="ChangeComment('<%="id2"+k%>','<%=employno%>')"></TD><!--人事主管修改评语 -->
</tr>
<%		
	}
}
%>
</table>
</div>
