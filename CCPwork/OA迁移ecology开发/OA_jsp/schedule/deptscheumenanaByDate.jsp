
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="java.util.Date"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page contentType="text/html; charset=UTF-8"%>


<head>
<!--<link href="/htfapp/web/css/common.css" rel="stylesheet" type="text/css" />-->
<!--<link href="/htfapp/web/css/oa.css" rel="stylesheet" type="text/css" />-->
<script src="/app/js/jquery.js" type="text/javascript" charset="utf-8"></script>
<!--<script src="/htfapp/web/js/jquery.easing.1.3.js" type="text/javascript" charset="utf-8"></script>-->
<link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>

<style type="text/css">
	table td {
	font-size: 12px;
	font: 12px/1.2 '宋体', Verdana, Tahoma, Arial;
	font-family: simsun,Microsoft YaHei,Verdana,Tahoma,sans-serif;
}
	
</style>
</head>

<body>
            
           
<%
			String date = StringHelper.trimToNull(request.getParameter("date"));
			
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
 	 <div align="center" style="padding-top: 20px;">
 	    <table  border="1px" style="border: thin;width: 97%;border-collapse: collapse;border-color: #b7b7b7;" bordercolor="#b7b7b7" cellpadding="0" cellspacing="0">
 	       <colgroup>
 	       <col width="15%"/>
 	       <col width="80%"/>
 	       </colgroup>
 	       		<tr style="height: 30px;">
 	    		<td colspan="2" class="manger" align="center"  style="font-weight: bold;font-size: 13px;">公司部门负责人行程安排表(<%=startdate %>-<%=enddate %>)</td>
 	    		</tr>
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
     	  	      	       <tr style="height: 30px;">
     	  	      	       	  <td align="center"><%=DateHelper.dayMove(weekfirst,i) %>  星期<%=print %></td>
     	  	      	       	  <td>
     	  	      	       	  <table cellpadding="0" cellspacing="0"  border="0" width="100%">	  	      	      
      	  	     
 	    		 <%
                           List tempList = new ArrayList();
                           String humresql = "select uf.richengren,ufd.neirong,ufd.didian from uf_schedule uf inner join "+
				           "uf_scheduledetail ufd on uf.requestid=ufd.requestid where richengleixing='40288182306cae59013072625b240705' "+
				           "and ufd.shijian='"+DateHelper.dayMove(weekfirst,i)+"' order by ufd.shijian desc";
                           humreslist = dataService.getValues(humresql);
                           
                          Map map1 = new HashMap();
                          int isfirst=0;
                          for (int j = 0; j < humreslist.size(); j++) {
	                        	  Map map = (Map)humreslist.get(j);
	                        	  String objname = (String)map.get("richengren");//
	                        	  String neirong = (String)map.get("neirong");//
	                        	  String didian=(String)map.get("didian");//
	                        	  if (StringHelper.isEmpty(neirong)&&StringHelper.isEmpty(didian)){	                        	  	
	                        	  	continue;
	                        	  }
	                        	  isfirst++;
                        	 %>
                        	 <tr style="height: 30px;border: 0px none white;">
                        	 <%
                        	 	 if(isfirst==1){
                        	 %>
                        	 	 <td style="text-align: left;padding-top: 0px solid #C83E31;padding-left: 4px;">
                        	 <%
                        	 	 }else{
                        	 %>
                        	     <td style="text-align: left;border-top: 1px solid #C83E31;padding-left: 4px; ">
                        	 <%
                        	     } 
                        	 %>
                        	     <%=humresService.getHrmresNameById(objname) %>  
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
 	    </table>
 	    </div>
</body>

</html>