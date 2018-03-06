<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.SQLMap"%>  
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%--<%@page import="weaver.hrm.resource.ResourceComInfo"%>--%>
<%--<%@page import="weaver.hrm.company.DepartmentComInfo"%>--%>
<%--<%@ page import="weaver.general.*" %>--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
 String listType=request.getParameter("listType");
 String keyworkd=StringHelper.null2String(request.getParameter("keyworkd"));
 String userid=""+user.getId();
 String departmentid=user.getOrgid();   //用户所属部门
 //int subCompanyid=user.getUserSubCompany1();  //用户所属分部
 String seclevel=user.getSeclevel()+"";          //用于安全等级
 String sqlStr="";
%>

 <%if(listType.equals("attention")){
	BlogDao blogDao=new BlogDao();
	int pagesize=NumberHelper.getIntegerValue(request.getParameter("pagesize"),30).intValue();
	int total=NumberHelper.getIntegerValue(request.getParameter("total"),30).intValue();
	int currentpage=NumberHelper.getIntegerValue(request.getParameter("currentpage"),1).intValue();
	List attentionList=blogDao.getAttentionMapList(userid,currentpage,pagesize,total);
    if(attentionList.size()>0){
 %> 
  <table id='blogList' class="ListStyle" cellspacing="1" style="margin:0px;width:100%">
		<tbody id="list_body">
		  <%
		    String trClass="";
		    for(int i=0;i<attentionList.size();i++){
		      Map map=(Map)attentionList.get(i);	
		      String attentionid=(String)map.get("attentionid");
		      String isnew=(String)map.get("isnew");
		      String username=(String)map.get("username");
		      String deptName=(String)map.get("deptName");
		  %>
			<TR class="<%=(trClass=trClass.equals("dataLight")?"dataDark":"dataLight")%>">
				<TD class="item" style="<%=isnew.equals("1")?"FONT-WEIGHT: bold":""%>" onclick="colorchange(this);openBlog('<%=attentionid%>',1,this)" vAlign="center">
					<DIV class=title style="width: 80"  title="<%=username%>"><%=username%></DIV>
					<div class="attdept" title="<%=deptName%>"><%=deptName%></div>
			    </TD>
			</TR>
		  <%} %>	
		</tbody>
  </table>
  <%}else
	  out.println("<div class='norecord'>当前没有关注的人</div>");  //当前没有关注的人
  %> 
<%}else if(listType.equals("searchList")||listType.equals("canview")){ 
	BlogDao blogDao=new BlogDao();
    String allowRequest=blogDao.getSysSetting("allowRequest");   //系统申请设置情况
    
    String managerstr=" t.managers ";
	//if(SQLMap.getDbtype().equals(SQLMap.DBTYPE_ORACLE))
		//   managerstr="''||t.managers||''"; 
	/*
    sqlStr="select * from ( select id,objname,case when t.managerid='"+userid+"' then 1 else 0 end as islower,case when t1.blogid is not null or "+managerstr+" like '%,"+userid+",%' then 1 else 0 end as isshare,case when t2.attentionid is not null or t.managerid='"+userid+"' then 1 else 0 end as isattention,case when t4.attentionid is not null then 1 else 0 end as iscancel,case when t3.blogid is not null then 0 else 1 end as isnew from humres t "+
	   " left join (select distinct blogid from blog_share where (type=1 and  content like '%,"+userid+",%' ) or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel) or (type=4 and exists (select roleid from humresroleview  where resourceid="+userid+"  and roleid in(content)) and "+seclevel+">=seclevel) or (type=5 and "+seclevel+">=seclevel) or (type=7 and  content like '%,"+userid+",%' ) ) t1"+
	   " on t.id=t1.blogid"+
	   " left join (select distinct attentionid from blog_attention where userid='"+userid+"') t2"+
	   " on t.id=t2.attentionid"+
	   " left join (select distinct blogid from blog_read where userid='"+userid+"')  t3"+
	   " on t.id=t3.blogid"+
	   " left join (select distinct attentionid from blog_cancelAttention where userid='"+userid+"')  t4"+
	   " on t.id=t4.attentionid"+
	   " where (status=0 or status=1 or status=2 or status=3)) t0 where ";
	if(listType.equals("searchList"))
		sqlStr=sqlStr+" lastname like '%"+keyworkd+"%'";
	else 
		sqlStr=sqlStr+" isshare=1";
	sqlStr=sqlStr+" order by isnew desc ,isshare desc,lastname asc";
	*/
	sqlStr="select * from ( select id,objname,case when t.manager like '%"+userid+"%' then 1 else 0 end as islower,case when t1.blogid is not null or "+managerstr+" like '%"+userid+"%' then 1 else 0 end as isshare,case when t2.attentionid is not null or t.manager like '%"+userid+"%' then 1 else 0 end as isattention,case when t4.attentionid is not null then 1 else 0 end as iscancel,case when t3.blogid is not null then 0 else 1 end as isnew from humres t "+
	   " left join (select distinct blogid from blog_share where (type=1 and  content like '%"+userid+"%' ) or (type=3 and content like '%"+departmentid+"%' and "+seclevel+">=seclevel) or (type=4 and exists (select roleid from humresroleview  where resourceid='"+userid+"'  and roleid in(content)) and "+seclevel+">=seclevel) or (type=5 and "+seclevel+">=seclevel) or (type=7 and  content like '%"+userid+"%' ) ) t1"+
	   " on t.id=t1.blogid"+
	   " left join (select distinct attentionid from blog_attention where userid='"+userid+"') t2"+
	   " on t.id=t2.attentionid"+
	   " left join (select distinct blogid from blog_read where userid='"+userid+"')  t3"+
	   " on t.id=t3.blogid"+
	   " left join (select distinct attentionid from blog_cancelAttention where userid='"+userid+"')  t4"+
	   " on t.id=t4.attentionid"+
	   " where (hrstatus='4028804c16acfbc00116ccba13802935' and isdelete=0)) t0 where ";
	if(listType.equals("searchList"))
		sqlStr=sqlStr+" objname like '%"+keyworkd+"%'";
	else 
		sqlStr=sqlStr+" isshare=1";
	sqlStr=sqlStr+" order by isnew desc ,isshare desc,objname asc";
	//recordSet.execute(sqlStr);
	List list = baseJdbcDao.executeSqlForList(sqlStr);
   if(list.size()>0){
%> 
      <table id='blogList' class="ListStyle" cellspacing="1" style="margin:0px;width:100%">
		<tbody id="list_body">
		  <%
		    //ResourceComInfo resourceComInfo=new ResourceComInfo();
		    //DepartmentComInfo departmentComInfo=new DepartmentComInfo();
		    String trClass="";
		    for(int i=0;i<list.size();i++){
		      Map recordSet = (Map)list.get(i);
		      String attentionid=StringHelper.null2String(recordSet.get("id"));
		      if(attentionid.equals(userid))
		    	  continue;
		      int isnew=NumberHelper.getIntegerValue(recordSet.get("isnew")).intValue();
		      int isshare=NumberHelper.getIntegerValue(recordSet.get("isshare")).intValue();
		      int isattention=NumberHelper.getIntegerValue(recordSet.get("isattention")).intValue();
		      int islower=NumberHelper.getIntegerValue(recordSet.get("islower")).intValue();
		      int iscancel=NumberHelper.getIntegerValue(recordSet.get("iscancel")).intValue();
		      int status=0;                  //不在共享和关注范围内
		      
		      if(isshare==1)                 //在共享范围内
		    	  status=1;
		      if(isshare==1&&isattention==1) //在关注范围内
		    	  status=2;
		      if(isshare==1&&isattention==1&&islower==1&&iscancel==1)
		    	  status=1;
		      if(status==0){
		    	  int isReceive=1;
		    	  //RecordSet recordSet2=new RecordSet();
		    	  sqlStr="select isReceive from blog_setting where userid='"+attentionid+"'";
		    	  List list2 = baseJdbcDao.executeSqlForList(sqlStr);
		    	  if(list2.size()>0){
		    		 Map recordSet2 = (Map)list2.get(0);
		    		 isReceive=NumberHelper.getIntegerValue(recordSet2.get("isReceive")).intValue();
		    	  }
		    	  if(isReceive==0)
		    		 status=-1;             //不允许申请
		    	  if(allowRequest.equals("0"))
		    		  status=-1;             //系统设置为不允许申请
		      }	  
		      String username=humresService.getHrmresNameById(attentionid);
		      String deptName=orgunitService.getOrgunitName(humresService.getHumresById(attentionid).getOrgid());
		  %>
			<TR class=<%=(trClass=trClass.equals("dataLight")?"dataDark":"dataLight")%>>
			<TD class="item" onclick="colorchange(this);openBlog('<%=attentionid%>',1,this)" style="<%=isnew==1?"FONT-WEIGHT: bold":""%>" vAlign=center>
				<DIV class=title style="width: 80"><%=username%></DIV>
				<div class="dept"><%=deptName%></div>
				<%if(status==0&&!attentionid.equals(userid)){%>
			       <div class="disOperation">
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="apply" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span>申请关注</span></div><!-- 申请关注 -->
							<div class="right"> &nbsp;</div>
					   </a>
				  </div>
			    <%}else if(status==1&&!attentionid.equals(userid)){%>
			      <div class="disOperation"> 
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="add" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666;font-weight: normal !important"><span id="btnLabel"><span class="add">+</span>添加关注</span></div><!-- 添加关注 -->
							<div class="right"> &nbsp;</div>
					   </a>
				  </div>  
			    <%}else if(status==2&&!attentionid.equals(userid)){%>
			      <div class="disOperation"> 
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="cancel" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666;font-weight: normal !important"><span id="btnLabel"><span class="cancel">-</span>取消关注</span></div><!-- 取消关注 -->
							<div class="right"> &nbsp;</div>
					   </a>
				  </div>   
			    <%} %>
			</TR>
		 <%} %>	
		</tbody>
  </table>
  <%}else
	  out.println("<div class='norecord'>没有可以显示的数据</div>");  
  %> 
   <%}else if(listType.equals("hrmOrg")){ %>
    <script>
	 jQuery(document).ready(function(){
	       $("#hrmOrgTree").addClass("hrmOrg"); 
	       $("#hrmOrgTree").treeview({
	          url:"hrmOrgTree.jsp?datetime="+(new Date()).getTime()
	       });
	 });
	 
    </script> 
    <div style="width:100%;;border-top:1px solid  #c8ebfd;line-height:1px"></div>
    <ul id="hrmOrgTree" style="width: 100%"></ul>
   <%}%>
<script>
function colorchange(obj){
		 var tds = document.getElementById("list_body").getElementsByTagName("TD");
		 for(var i=0;i<tds.length;i++){
			 if(i%2==0){
				tds[i].style.backgroundColor ="#ffffff";	 
			 }else{
				 tds[i].style.backgroundColor ="#f5fafa";
			 }
			 
		 }
		  obj.style.backgroundColor="#8cc97d";
	 }

</script>
