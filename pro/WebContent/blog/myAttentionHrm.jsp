<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogManager"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.SQLMap"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%--<%@ include file="/page/maint/common/initNoCache.jsp" %>--%>
<script>
   function addAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=addAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).show();
      jQuery("#addAttention_"+attentionid).hide();
   }
   function cancelAttention(attentionid,islower){
      jQuery.post("blogOperation.jsp?operation=cancelAttention&islower="+islower+"&attentionid="+attentionid);
      jQuery("#cancelAttention_"+attentionid).hide();
      jQuery("#addAttention_"+attentionid).show();
   }
</script>
<script type="text/javascript" language="javascript" src="/js/main.js"></script>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
 String from=StringHelper.null2String(request.getParameter("from"));
 String userid=StringHelper.null2String(request.getParameter("userid"));
 String currentUserid=user.getId();
 BlogDao blogDao=new BlogDao(); 
 SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
 SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");
 SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");

 String departmentid=user.getId();   //用户所属部门
 //String subCompanyid=ResourceComInfo.getSubCompanyID(userid);   //用户所属分部
 String seclevel=StringHelper.null2String(user.getSeclevel());           //用于安全等级
 
 String allowRequest=blogDao.getSysSetting("allowRequest");    //系统申请设置情况
 
 BlogShareManager shareManager=new BlogShareManager();
 String managerstr=" t.managers ";
 //if(SQLMap.getDbtype().equals(SQLMap.DBTYPE_ORACLE))
	//managerstr="','||t.managers||','"; 
 //
 /*
 String sqlStr="select * from (select id,status,managerid,case when t.managerid='"+userid+"' then 1 else 0 end as islower,case when t1.blogid is not null or "+managerstr+" like '%,"+userid+",%' then 1 else 0 end as isshare,case when t2.attentionid is not null or t.managerid='"+userid+"' then 1 else 0 end as isattention,case when t4.attentionid is not null then 1 else 0 end as iscancel from HrmResource t "+
 " left join (select distinct blogid from blog_share where (type=1 and  content like '%,"+userid+",%' )   or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel) or (type=4 and exists (select roleid from hrmrolemembers  where resourceid='"+userid+"'  and roleid in(content)) and "+seclevel+">=seclevel) or (type=5 and "+seclevel+">=seclevel) or (type=7 and  content like '%,"+userid+",%' ) ) t1"+
 " on t.id=t1.blogid"+
 " left join (select distinct attentionid from blog_attention where userid='"+userid+"') t2"+
 " on t.id=t2.attentionid"+
 " left join (select distinct attentionid from blog_cancelAttention where userid='"+userid+"')  t4"+
 " on t.id=t4.attentionid"+
 " ) t0 where (isshare=1 and isattention=1) and iscancel=0 and (status=0 or status=1 or status=2 or status=3) ";
 */
 String sqlStr = "";
 sqlStr+="select *  from (select id,t.hrstatus,manager,t.isdelete,case when t.manager like '%"+userid+"%' then 1 else 0 end as islower, ";
 sqlStr+=" case when t1.blogid is not null or "+managerstr+" like '%"+userid+"%' then 1 else 0 end as isshare, ";
 sqlStr+=" case when t2.attentionid is not null or t.manager like '%"+userid+"%' then 1 else 0 end as isattention, ";
 sqlStr+=" case when t4.attentionid is not null then 1 else 0 end as iscancel "; 
 sqlStr+=" from humres t left join ( ";
 sqlStr+=" select distinct blogid from blog_share where (type = 1 and content like '%"+userid+"%') "; 
 sqlStr+=" or (type = 3 and content like '%,"+departmentid+",%' and "+seclevel+" >= seclevel) "; 
 sqlStr+=" or (type = 4 and exists (select roleid from humresroleview ";
 sqlStr+=" where resourceid = '"+userid+"' and roleid in (content)) and "+seclevel+" >= seclevel) "; 
 sqlStr+=" or (type = 5 and "+seclevel+" >= seclevel) or (type = 7 and content like '%"+userid+"%')) t1 on t.id = t1.blogid ";
 sqlStr+=" left join (select distinct attentionid from blog_attention where userid = '"+userid+"') t2 on t.id = t2.attentionid ";
 sqlStr+=" left join (select distinct attentionid from blog_cancelAttention where userid = '"+userid+"') t4 on t.id = t4.attentionid) t0 ";
 sqlStr+=" where (isshare = 1 and isattention = 1) and iscancel = 0 and (hrstatus='4028804c16acfbc00116ccba13802935' and isdelete=0) ";
 //recordSet.execute(sqlStr);
 System.out.println(sqlStr);
 List list = baseJdbcDao.executeSqlForList(sqlStr);
 if(list.size()>0){
%>
<DIV id=footwall_visitme class="footwall" style="width: 100%;float: left;">
<UL>
<%	 
       for(int i=0;i<list.size();i++){ 
    	   Map map = (Map)list.get(i);
    	   String attentionid=StringHelper.null2String(map.get("id"));
           int islower=NumberHelper.getIntegerValue(map.get("islower")).intValue();
           int isshare=NumberHelper.getIntegerValue(map.get("isshare")).intValue();
           int isattention=NumberHelper.getIntegerValue(map.get("isattention")).intValue();
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
       		 Map map2 = (Map)list2.get(0);
       		 isReceive=NumberHelper.getIntegerValue("isReceive").intValue();
       	  }
       	  if(isReceive==0)
       		 status=-1;             //不允许申请
       	  if(allowRequest.equals("0"))
       		  status=-1;             //系统设置为不允许申请
         }	  
         String username=humresService.getHumresById(attentionid).getObjname();
         String deptName=orgunitService.getOrgunitName(humresService.getHumresById(attentionid).getOrgid());
 %>
  <LI class="LInormal" style="height: 75px">
	<DIV class="LIdiv">
	   <A class=figure href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')" ><IMG src="<%=BlogDao.getBlogIcon(attentionid)%>" width=55  height=55></A>
	   <div class=info>
	    <SPAN class=line><A class=name href="javascript:onUrl('/blog/viewBlog.jsp?blogid=<%=attentionid%>','<%=username %>的微博','blog_<%=attentionid%>')"><%=username%></A></SPAN> 
	    <SPAN class="line gray-time" title="<%=deptName%>"><%=deptName%></SPAN>
	   
	    <div> 
			<%if(!"view".equals(from)) {%>
               <a class="btnEcology" id="cancelAttention_<%=attentionid%>" href="javascript:void(0)" onclick="cancelAttention('<%=attentionid%>',<%=islower%>)" style="margin-right: 8px;display:<%=attentionid.equals(""+user.getId())?"none":"" %>">
					<div class="left" style="width:70px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">-</span>取消关注</span></div><!-- 取消关注 -->
					<div class="right"> &nbsp;</div>
	           </a>
	           <a class="btnEcology" id="addAttention_<%=attentionid%>" href="javascript:void(0)" onclick="addAttention('<%=attentionid%>',<%=islower%>)" style="margin-right: 8px;display: none">
					<div class="left" style="width:70px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span>添加关注</span></div><!-- 添加关注 -->
					<div class="right"> &nbsp;</div>
	           </a> 
			  <%} %>
		 </div>
	   </div>	   
	</DIV>
  </LI>
   <%}%> 
</UL>
</DIV>   
<%}else{ 
	out.println("<div class='norecord'>没有可以显示的数据</div>");
}%>
<script>
  jQuery("#footwall_visitme li").hover(
    function(){
       jQuery(this).addClass("LIhover");
    },function(){
       jQuery(this).removeClass("LIhover");
    }
  );
</script>
<br>
<br>	    
