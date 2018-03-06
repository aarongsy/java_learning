<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.menu.service.MenuorgService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.util.NumberHelper" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.document.base.service.DocbaseService" %>
<%@ page import="com.eweaver.humres.base.service.StationinfoService" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService" %>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink" %>
<%@ page import="com.eweaver.base.security.util.PermissionUtil2" %>
<%@ page import="com.eweaver.external.IRtxSyncData" %>
<%@ page import="com.eweaver.attendance.service.AttendanceService" %>
<%@ page import="com.eweaver.attendance.model.Attendance" %>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService"%>
<%@ page import="com.eweaver.base.module.model.Module"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.base.Page"%>

<head>
<script src="/searchengine/main.js" type="text/javascript" charset="utf-8"></script>
<!--<link href="/htfapp/web/css/common.css" rel="stylesheet" type="text/css" />-->
<!--<link href="/htfapp/web/css/oa.css" rel="stylesheet" type="text/css" />-->
<script src="/app/js/jquery.js" type="text/javascript" charset="utf-8"></script>
<!--<script src="/htfapp/web/js/jquery.easing.1.3.js" type="text/javascript" charset="utf-8"></script>-->
<!--<script src="/htfapp/web/js/common.js" type="text/javascript" charset="utf-8"></script>-->
<!--<script src="/htfapp/web/js/sideBar.js" type="text/javascript" charset="utf-8"></script>-->
<!--<script src="/htfapp/web/js/Validform.js" type="text/javascript" charset="utf-8"></script>-->
<link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>
<!--<link rel="stylesheet" href="../culture/css/culture_association.css" type="text/css"></link>-->
<script type="text/javascript" src="/datapicker/WdatePicker.js"></script></head>

<body>
            
           
<%
			String date = StringHelper.null2String(request.getParameter("date"));
			
            HumresService humresService =(HumresService)BaseContext.getBean("humresService");
			DataService dataService = new DataService();
                 
			Date currentDate = new Date();
			if (StringHelper.isEmpty(date)){
            	currentDate = new Date();
            }else{
            	currentDate = DateHelper.stringtoDate(date);
            }

			String weekfirst = "";           
			String weeklast = "";
			weekfirst = DateHelper.getShortDate(DateHelper.getCurrentWeekFirstDay(currentDate));
			weeklast = DateHelper.dayMove(weekfirst,6);

            List humreslist = new ArrayList();
             
           String startdate = weekfirst.replace("-",".");
           String enddate = weeklast.replace("-",".");
            
            
%>
 <div class="maindiv" style="text-align: center;">
 	 <div class="detaildiv">
 	    <div>
 	    	<p style="text-align: left;">
 	    		日期：<input type="text" id="date" name="date" value="<%=date %>" onclick="WdatePicker()"/>
 	    		<a href="javascript:onsearch()" id="newasso"><span>搜 索</span></a>
 	    		<a href="javascript:void(0)" id="newasso" onclick="ontime()">
 	    		<span>按人员列表</span>
 	    		</a>
 	    	</p>
 	    </div>
 	    <table class="maintable" border="0px;" cellpadding="0" cellspacing="0">
 	       <colgroup>
 	       <col width="15%"/>
 	       <col width="80%"/>
 	       </colgroup>
 	    	<tbody>
 	    		<tr><td colspan="2" class="manger">公司高管层行程安排表(<%=startdate %>-<%=enddate %>)</td></tr>
					<%
	     	  	      	    
	  	  	      	       for(int i=0; i<7;i++){ 
	   	  	      	    	String[] big = {"一","二","三","四","五","六","日"};
	    	  	            String n = Double.toString(i);
	    	  	            String last = n.substring(n.lastIndexOf(".")+1);
	    	  	            String first = n.substring(0,n.lastIndexOf("."));
	    	  	            String print = "";
	     	  	       		for(int j=0;j<first.length();j++){
	      	             		 print = print + big[Integer.parseInt(first.substring(j,j+1))];
	      	          		}
	      	          		humreslist = dataService.getValues("select h.objname, ufd.neirong,ufd.didian from uf_schedule  uf, uf_scheduledetail ufd,"+
                          	"humres h where uf.richengren=h.id and ufd.requestid=uf.requestid and shijian ='"+DateHelper.dayMove(weekfirst,i)+"' order by h.seclevel desc");
                          	
	      	  	    %>
     	  	      	       <tr>
     	  	      	       	  <td><%=DateHelper.dayMove(weekfirst,i) %>  星期<%=print %></td>
     	  	      	       	  <td>  
	     	  	      	       	  <table cellpadding="0" cellspacing="0" border="0">	  	      	      
				 	    		  <%
				                          List tempList = new ArrayList();
				                         String humresql = "select uf.richengren,ufd.neirong,ufd.didian from uf_schedule uf inner join "+
				                         "uf_scheduledetail ufd on uf.requestid=ufd.requestid inner join humres h on uf.richengren=h.id "+
				                         "where uf.richengleixing='4028813130b0a8340130b1252b5f0011' "+
				                         "and ufd.shijian='"+DateHelper.dayMove(weekfirst,i)+"' order by h.objno,h.dsporder asc,ufd.shijian desc";
				                         humreslist = dataService.getValues(humresql);
				                          
				                          Map map1 = new HashMap();
				                          for (int j = 0; j < humreslist.size(); j++) {
				                        	  Map map = (Map)humreslist.get(j);
				                        	  String objname = StringHelper.null2String(map.get("richengren"));
				                        	  objname = humresService.getHrmresNameById(objname);
				                        	  String neirong = (String)map.get("neirong");//
				                        	  String didian=(String)map.get("didian");//
				                        	  if (StringHelper.isEmpty(neirong)&&StringHelper.isEmpty(didian)){
				                        	  	    continue;
				                        	  }
				                        	 %>
				                        	 <tr style="border: 0px none white;">
				                        	 	<%
				                        	 		if(j==0){
				                        	 	%>
				                        	 		<td style="text-align: left;padding-top: 0px solid #C83E31;">
				                        	 	<%
				                        	 		}else{
				                        	 	%>
				                        	 		<td style="text-align: left;border-top: 1px solid #C83E31; ">
					                        	 <%
				                        	 		}
					                        	 %>
					                        	     <%=StringHelper.null2String(objname) %>  
						                        	 <%=StringHelper.null2String(didian) %>  
						                        	 <%=StringHelper.null2String(neirong) %>
					                        	 </td>
				                        	 </tr>
				                        	 <%                        	  
				                        	  
				                        %>
				                <%} %>
	               			 	</table>
               		 	   </td>
               		  </tr>
                 <%} %>
 	    	</tbody>
 	    </table>
 	 </div>
 </div>
</body>

<script>
function onsearch(){
	document.location.href="schedulemanalisttwo.jsp?date="+document.getElementById("date").value;
}
function ontime(){
	  var gettime = $('#date').val();
	  location.href='schedulemanalist.jsp?date='+gettime+'';
}
</script>

</html>