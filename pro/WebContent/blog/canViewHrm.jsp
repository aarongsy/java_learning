<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%--<%@page import="weaver.conn.RecordSet"%>--%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.SQLMap"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<%--<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>--%>
<%--<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>--%>
<%
	Humres user=BaseContext.getRemoteUser().getHumres();
	HumresService humresService = (HumresService)BaseContext.getBean("humresService");
	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String from=StringHelper.null2String(request.getParameter("from"));
	String userid=StringHelper.null2String(request.getParameter("userid"));
	BlogDao blogDao=new BlogDao();
	String allowRequest=blogDao.getSysSetting("allowRequest");   //系统申请设置情况
	
	String departmentid=user.getOrgid();   //用户所属部门
	String subCompanyid="";  //用户所属分部
	String seclevel=user.getSeclevel()+"";          //用于安全等级
	
    //RecordSet recordSet=new RecordSet();
	String managerstr=" t.managers ";
	if(SQLMap.getDbtype().equals(SQLMap.DBTYPE_ORACLE))
		   managerstr="''||t.managers||''"; 
	
	String sqlStr="select * from ( select id,objname,case when t.manager like '%"+userid+"%' then 1 else 0 end as islower,case when t1.blogid is not null or "+managerstr+" like '%"+userid+"%' then 1 else 0 end as isshare,case when t2.attentionid is not null or t.manager like '%"+userid+"%' then 1 else 0 end as isattention,case when t4.attentionid is not null then 1 else 0 end as iscancel from humres t "+
	   " left join (select distinct blogid from blog_share where (type=1 and  content like '%"+userid+"%' )  or (type=3 and content like '%"+departmentid+"%' and "+seclevel+">=seclevel) or (type=4 and exists (select roleid from humresroleview  where resourceid='"+userid+"'  and roleid in(content)) and "+seclevel+">=seclevel) or (type=5 and "+seclevel+">=seclevel) or (type=7 and  content like '%"+userid+"%' ) ) t1"+
	   " on t.id=t1.blogid"+
	   " left join (select distinct attentionid from blog_attention where userid='"+userid+"') t2"+
	   " on t.id=t2.attentionid"+
	   " left join (select distinct attentionid from blog_cancelAttention where userid='"+userid+"')  t4"+
	   " on t.id=t4.attentionid"+
	   " where (hrstatus='4028804c16acfbc00116ccba13802935' and isdelete=0)) t0 where isshare=1 order by id";
	List list = baseJdbcDao.executeSqlForList(sqlStr);

if(list.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%;float: left;">
<UL>
<%
  for(int i=0;i<list.size();i++){
	  Map map = (Map)list.get(i);
	  String attentionid= StringHelper.null2String(map.get("id"));
      int isshare=NumberHelper.getIntegerValue(map.get("isshare")).intValue();
      int isattention=NumberHelper.getIntegerValue(map.get("isattention")).intValue();
      int islower=NumberHelper.getIntegerValue(map.get("islower")).intValue();
      int iscancel=NumberHelper.getIntegerValue(map.get("iscancel")).intValue();
      int status=0;                  //不在共享和关注范围内
      
      if(isshare==1)                 //在共享范围内
    	  status=1;
      if(isshare==1&&isattention==1) //在关注范围内
    	  status=2;
      if(isshare==1&&isattention==1&&islower==1&&iscancel==1)
    	  status=1;
      if(status==0){
    	  int isReceive=1;
    	  sqlStr="select isReceive from blog_setting where userid='"+attentionid+"'";
    	  List list2 = baseJdbcDao.executeSqlForList(sqlStr);
    	  if(list2.size()>0){
    		 Map map2=(Map)list2.get(0);
    		 isReceive=NumberHelper.getIntegerValue(map2.get("isReceive")).intValue();
    	  }
    	  if(isReceive==0)
    		 status=-1;             //不允许申请
    	  if(allowRequest.equals("0"))
    		  status=-1;             //系统设置为不允许申请
      }	  
      String username=humresService.getHrmresNameById(attentionid);
      String deptName=orgunitService.getOrgunitName(humresService.getHumresById(attentionid).getOrgid());
%>
  <LI class="LInormal" style="height: 75px">
	<DIV class="LIdiv">
	   <A class=figure href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')" ><IMG src="<%=BlogDao.getBlogIcon(attentionid) %>" width=55  height=55></A>
	   <div class=info>
	    <SPAN class=line><A class=name href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')"><%=username%></A></SPAN> 
	    <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	   
	    <div> 
			   <%if(status==0&&!attentionid.equals(userid)){%>
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="apply" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666;font-weight: normal !important;padding-left: 0px"><span id="btnLabel"><span class="apply">√</span>申请关注</span></div><!-- 申请关注 -->
							<div class="right"> &nbsp;</div>
					   </a>
			    <%}else if(status==1&&!attentionid.equals(userid)){%>
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="add" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666"><span id="btnLabel"><span class="add">+</span>添加关注</span></div>
							<div class="right"> &nbsp;</div>
					   </a>
			    <%}else if(status==2&&!attentionid.equals(userid)){%>
				       <a class="btnEcology" id="cancelAttention" href="javascript:void(0)" onclick="disAttention(this,'<%=attentionid%>',<%=islower%>,event);" status="cancel" style="margin-right: 8px;">
							<div class="left" style="width:68px;color: #666"><span id="btnLabel"><span class="cancel">-</span>取消关注</span></div><!-- 取消关注 -->
							<div class="right"> &nbsp;</div> 
					   </a>
			    <%} %>
		 </div>
	   
	   </div>	   
	    
	</DIV>
  </LI>
<%} %>
</UL>
</DIV>
<%
}else
    out.println("<div class='norecord'>没有可以显示的数据</div>");
%>
<script>
  jQuery("#footwall_visitme li").hover(
    function(){
       jQuery(this).addClass("LIhover");
    },function(){
       jQuery(this).removeClass("LIhover");
    }
  );
  function disAttention(obj,attentionid,islower,eve){
        var itemName=jQuery(obj).parent().parent().find(".title").text();
        var status=jQuery(obj).attr("status");
        if(status=="cancel"){
           jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","add");
           jQuery(obj).find("#btnLabel").html("<span class='add'>+</span>添加关注</span>");  
        }
        if(status=="add"){
           jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
           jQuery(obj).attr("status","cancel");
           jQuery(obj).find("#btnLabel").html("<span class='add'>-</span>取消关注</span>");  
        }
        if(status=="apply"){
          if(jQuery(obj).attr("isApply")!=="true"){
            jQuery.post("blogOperation.jsp?operation=requestAttention&islower="+islower+"&attentionid="+attentionid,function(){
               alert("申请已经发送"); //申请已经发送
               jQuery(obj).find("#btnLabel").html("<span class='apply'>√</span>已申请</span>");
               jQuery(obj).attr("isApply","true");
            });
          }else {
              alert("申请已经发送"); //申请已经发送
          }  
        }
        eve.cancelBubble=true;
      }
</script>
<br/>
<br/>      
