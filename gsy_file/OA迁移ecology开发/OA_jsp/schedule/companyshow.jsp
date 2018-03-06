<%@include file="/base/init.jsp" %>
<%@page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%

			HumresService humresService = (HumresService)BaseContext.getBean("humresService");
			OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
			SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
			boolean isworkflow = false;
			DataService dataService = new DataService();			
			String weekdate = StringHelper.null2String(request.getParameter("weekdate"),DateHelper.getCurrentDate());
			String richengren = StringHelper.null2String(request.getParameter("richengren"),eweaveruser.getId());			
			String requestid = StringHelper.null2String(request.getParameter("requestid"));//日程主表requestid
			//System.out.println("requestid======"+requestid);
			String richengleixing = StringHelper.null2String(request.getParameter("richengleixing"));//默认我的日程 ,"40288182306cae59013072625b240704"
		    String roomid = StringHelper.null2String(request.getParameter("roomid"));//会议id
			String didian="";	//地点
			
			String iscreate = StringHelper.null2String(request.getParameter("iscreate"));//是否创建			
            String weekfirst = "";           
            String weeklast = "";          	        					
            String selectmainsql = "";
            Map getmaindatamap = new HashMap();
            String selectdetailsql ="";
            List getdetaildatalist = new ArrayList();
            
			if (StringHelper.isEmpty(requestid)){
				iscreate = "1";
				
				Date currentDate = DateHelper.parseDate(weekdate);
            	int dayOfWeek = DateHelper.getDayOfWeek(currentDate);  
            	weekfirst = DateHelper.getShortDate(DateHelper.getCurrentWeekFirstDay(currentDate));
            	weeklast = DateHelper.getShortDate(DateHelper.getDay(DateHelper.parseDate(weekfirst),6));
            	if (!"40288182306cae59013072625b240703".equals(richengleixing)){//非公司日程            	
            		selectmainsql = "select uf.* from uf_schedule uf,uf_scheduledetail d where d.shijian='"+weekdate+"' and "+
            		"uf.richengleixing='"+richengleixing+"' and uf.richengren='"+richengren+"' and uf.requestid=d.requestid and uf.laiyuan is null";
            		//System.out.println("selectmainsql====="+selectmainsql);		
            		List schlist = dataService.getValues(selectmainsql);
            		if (schlist!=null && schlist.size()>0){
						getmaindatamap = (Map)schlist.get(0);
					}	
					if (getmaindatamap.get("requestid")!=null && !StringHelper.isEmpty((String)getmaindatamap.get("requestid"))){
						requestid=(String)getmaindatamap.get("requestid");
						
						
					}
				}
			}
			if (!StringHelper.isEmpty(requestid)){
				iscreate="0";
				selectmainsql = "select meetingid,requestid,richengren,tijiaoren,tijiaobumen,tijiaoriqi,richengleixing,richenshijian,jieshuriqi,kaishiriqi,gongzuoneirong,biaoti,weekdate,gsdidian,meetingid from uf_schedule where requestid='"+requestid+"'";
				getmaindatamap = dataService.getValuesForMap(selectmainsql);	
				richengleixing = (String)getmaindatamap.get("richengleixing");
				roomid = StringHelper.null2String(getmaindatamap.get("meetingid"));
				String meetrequestid = dataService.getValue("select requestid from uf_admin_meeting where requestid='"+StringHelper.null2String(getmaindatamap.get("meetingid"))+"'");
				if(meetrequestid.length()!=0){
					isworkflow = true;
				}
				
				if (StringHelper.isEmpty(richengleixing)){
					richengleixing = "40288182306cae59013072625b240704";
				}
				richengren = (String)getmaindatamap.get("richengren");
				weekdate = (String)getmaindatamap.get("weekdate");
				selectdetailsql = "select requestid,shijian,didian,neirong,xingqi from uf_scheduledetail where requestid='"+requestid+"' order by shijian asc";
				getdetaildatalist = dataService.getValues(selectdetailsql);
				if(getdetaildatalist!=null && getdetaildatalist.size()>0){
					didian=StringHelper.null2String(((Map)getdetaildatalist.get(0)).get("didian"));
				}
			}
			String selectname = selectitemService.getSelectitemNameById(richengleixing);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>日程管理</title>
<!--    <link href="/htfapp/portal/manual/style/css.css" rel="stylesheet" type="text/css" />-->
<!--	<link href="/culture/css/common.css" rel="stylesheet" type="text/css" />-->
<!--	<link href="/culture/css/culture_privateSchool.css" rel="stylesheet" type="text/css" />-->
	<link rel="stylesheet" href="/app/htfmeeting/culture_association.css" type="text/css"></link>
      <script type="text/javascript" src="/app/js/jquery.js"></script>
      <script type="text/javascript" src="/js/orgsubjectbudget.js"></script>
      <link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>
      <script type="text/javascript" src="/app/schedule/js/schedule.js"></script>
      <script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
      <style type="text/css">
      	td{font-size: 14px;text-align: left;}
	    textarea{
	     color: #4e4e4e; background:#fff; overflow-y: auto; 
	     margin-top:10px;margin-bottom:10px; border:1px solid #dbd5b2;font-size:14px;
        }
      </style>
  </head>
  
  <body>
  <div id="pagemenubar"></div> 
     <div align="center">
      <form action="/app/schedule/handschedulemodify.jsp" method="post" name="EweaverForm">
      	  <div id="layoutFrame">
      	  	 <input type="hidden" value="<%=requestid%>" name="requestid"/>   	  	 
      	  	 <div class="form" style="width: 800px;">
      	  	      <center>
      	  	      	 <div id="layoutDiv">
      	  	      	   
      	  	      	   <%
      	  	      	   		if("高管日程".equals(StringHelper.null2String(selectname))){
      	  	      	   	%>
      	  	      	   		<h1>领导<%=StringHelper.null2String(humresService.getHrmresNameById(richengren)) %>日程</h1>
      	  	      	   	<%	
      	  	      	   		}else{
      	  	      	   	%>
      	  	      	   		<h1><%=StringHelper.null2String(selectname) %></h1>
      	  	      	   	<%	     	  	      	   		
      	  	      	   		
      	  	      	   		}
      	  	      	    %>
      	  	      	   
      	  	      	   
      	  	      	   <table border="0px;" cellpadding="0" cellspacing="0" class="layouttable" >
      	  	      	      <colgroup>
      	  	      	      	<col width="15%">
      	  	      	      	<col width="20%">
      	  	      	      	<col width="50%">
      	  	      	      </colgroup>
      	  	      	      <tbody>
      	  	      	       <tr>
      	  	      	   	    	<th class="FieldName" style="display: none;">日程类型：</th>
      	  	      	   	    	<td class="FieldValue" colspan="2" style="display: none;">
      	  	      	   	    		<select style="width: 555px;" name="richengleixing" id="richengleixing" onchange="javascript:onchange1()">
      	  	      	   	    		    <%
      	  	      	   	    		    	//String selectname = selectitemService.getSelectitemNameById(richengleixing);
      	  	      	   	   					//String typeid = StringHelper.null2String(getmaindatamap.get("richengleixing"));
      	  	      	   	    		    %>
      	  	      	   	    		    <option value="<%=richengleixing %>" selected="selected"><%=selectname%></option>
      	  	      	   	    		    <%
      	  	      	   	    		        String selectallemp = "select id,objname from selectitem where typeid='40288182306cae5901307261edf30702' and pid is null";
			      	  	      	        	List getselectdata = dataService.getValues(selectallemp);
			      	  	      	        
      	  	      	   	    		        Map selectmap = new HashMap();
			      	  	      	        	if(getselectdata.size()>0){
			      	  	      	        	for(int i=0;i<getselectdata.size();i++){
			      	  	      	        	 selectmap = (Map)getselectdata.get(i);
			      	  	      	        	 String selectitemid = StringHelper.null2String(selectmap.get("id"));
			      	  	      	        	 if(richengleixing.equals(selectitemid)){
			      	  	      	        		 continue;
			      	  	      	        	 }
			      	  	      	        	 
      	  	      	       				 %>
      	  	      	   	    			   <option value="<%=StringHelper.null2String(selectmap.get("id"))%>"><%=StringHelper.null2String(selectmap.get("objname")) %></option>
      	  	      	   	    			 <%} %>
      	  	      	   	    			 <%} %>
      	  	      	   	    		 </select>
      	  	      	   	    	</td>
      	  	      	   	    </tr>
      	  	      	   	    
      	  	      	   	    <%
      	  	      	           if("4028813130b0a8340130b1252b5f0011".equals(richengleixing)||"40288182306cae59013072625b240705".equals(richengleixing)){//部门，高管
      	  	      	            String richengrenname = humresService.getHumresHtml(richengren);
      	  	      	          %>
      	  	      	       <tr>
      	  	      	         
      	  	      	       	  <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">日程人：</th>
      	  	      	       	  <td class="FieldValue" colspan="2"><%=StringHelper.null2String(humresService.getHrmresNameById(richengren)) %></td>
      	  	      	       	  
      	  	      	       </tr>
      	  	      	        <tr>
      	  	      	       	  <th class="FieldName" style="font-size: 14px;font-weight: normal;text-align: center; width: 15%;">时间</th>
      	  	      	       	  <th class="FieldName" style="font-size: 14px;font-weight: normal;text-align: center;">地点</th>
      	  	      	       	  <th class="FieldName" style="font-size: 14px;font-weight: normal;text-align: center;">工作内容</th>
      	  	      	       </tr>
      	  	      	       <%for(int i=0; i<7;i++){ 
	      	  	      	    	String[] big = {"一","二","三","四","五","六","日"};
		      	  	            String n = Double.toString(i);
		      	  	            String last = n.substring(n.lastIndexOf(".")+1);
		      	  	            String first = n.substring(0,n.lastIndexOf("."));
		      	  	            String print = "";
			      	  	       	for(int j=0;j<first.length();j++){
				      	              print = print + big[Integer.parseInt(first.substring(j,j+1))];
				      	          }
			      	  	       Map detaildatamMap = new HashMap();
			      	  	      if(getdetaildatalist.size()>0){
			      	  	   			detaildatamMap = (Map)getdetaildatalist.get(i);
			      	  	       }
			      	  	       String shijian = StringHelper.null2String(detaildatamMap.get("shijian"));
			      	  	       if (StringHelper.isEmpty(requestid)){
			      	  	       	shijian = DateHelper.dayMove(weekfirst,i);
			      	  	       }
      	  	      	       %>
      	  	      	       <tr>
      	  	      	       	  <th class="FieldName" align="center" style="font-size: 14px;font-weight: normal;text-align: center;"><%=shijian%> 星期<%=print %></th>
      	  	      	       	  <td class="FieldValue" align="center" style="font-size: 14px;"><%=StringHelper.null2String(detaildatamMap.get("didian")) %></td>
      	  	      	       	  <td class="FieldValue"><textarea rows="1" id="teax" onpropertychange="this.style.height=this.scrollHeight+'px';"  oninput="this.style.height=this.scrollHeight+'px';" style="overflow:hidden;border:0px;height:16px;width:480px"><%=StringHelper.null2String(detaildatamMap.get("neirong")) %></textarea></td>
      	  	      	       </tr>
      	  	      	       <%} %>
      	  	      	       <%} %>
      	  	      	       </tbody>
      	  	      	   </table>
      	  	      	   <%if(("40288182306cae59013072625b240703").equals(richengleixing)||"40288182306cae59013072625b240704".equals(richengleixing)){ %>
      	  	      	   <table border="1px;" cellpadding="0" cellspacing="0" class="layouttable" style="font-size: 14px;">
	      	  	      	      <colgroup>
	      	  	      	      	 <col width="15%">
	      	  	      	   	   	 <col width="19%">
	      	  	      	   	   	 <col width="15%">
	      	  	      	   	   	 <col width="19%">
	      	  	      	   	   	 <col width="15%">
	      	  	      	   	   	 <col width="19%">
	      	  	      	      </colgroup>
	      	  	      	      <tbody>
	      	  	      	     
	      	  	      	      	  <tr>
		      	  	      	         <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">标题：</th>
		      	  	      	         <td class="FieldValue" colspan="5">
			      	  	      	         <%if(isworkflow){%>
			      	  	      	          <a style="font-size: 14px;" href="javascript:onUrl('/workflow/request/workflow.jsp?requestid=<%=StringHelper.null2String(getmaindatamap.get("meetingid")) %>','<%=StringHelper.null2String(getmaindatamap.get("biaoti"))%>','tabff808081327644bb0132771b13010779')">
			      	  	      	          <%=StringHelper.null2String(getmaindatamap.get("biaoti"))%>
			      	  	      	          </a>
			      	  	      	         <%}else{%>
			      	  	      	         <%=StringHelper.null2String(getmaindatamap.get("biaoti"))%>
			      	  	      	         <%} %>
		      	  	      	         </td>
		      	  	      	       </tr>
		      	  	      	       <tr>
		      	  	      	         <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">开始时间：</th>
		      	  	      	         <td class="FieldValue"><%=StringHelper.null2String(getmaindatamap.get("kaishiriqi")) %></td>
		      	  	      	         
		      	  	      	  <%
		      	  	      	  		if("40288182306cae59013072625b240703".equals(StringHelper.null2String(selectname))){
		      	  	      	  %>
		      	  	      	  		<th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">结束时间：</th>
		      	  	      	        <td class="FieldValue" colspan="3"><%=StringHelper.null2String(getmaindatamap.get("jieshuriqi")) %></td>
		      	  	      	        <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">地点：</th>
		      	  	      	        <td class="FieldValue"><%=didian %></td>
		      	  	      	  <%
		      	  	      	  		}else{
		      	  	      	  %>
		      	  	      	  		 <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">结束时间：</th>
		      	  	      	         <td class="FieldValue"><%=StringHelper.null2String(getmaindatamap.get("jieshuriqi")) %></td>
		      	  	      	  		 <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">地点：</th>
		      	  	      	         <td class="FieldValue"><%=StringHelper.null2String(getmaindatamap.get("gsdidian")) %></td>
		      	  	      	  <%
		      	  	      	  		
		      	  	      	  		}
		      	  	      	   %>
		      	  	      	        
								   </tr>
								   <tr>
		      	  	      	         <th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">工作内容：</th>
		      	  	      	         <td class="FieldValue" colspan="5">
		      	  	      	            <textarea rows="1" id="teax" onpropertychange="this.style.height=this.scrollHeight+'px';"  oninput="this.style.height=this.scrollHeight+'px';" style="overflow:hidden;border:0px;height:16px;width:660px"><%=StringHelper.null2String(getmaindatamap.get("gongzuoneirong")) %></textarea>
		      	  	      	         </td>
		      	  	      	       </tr>
	      	  	      	      </tbody>
      	  	      	   </table>
      	  	      	   <%} %>
      	  	      	   <table class="layouttable" cellpadding="0" cellspacing="0" style="font-size: 14px;">
      	  	      	   	   <colgroup>
      	  	      	   	   	 <col width="14%">
      	  	      	   	   	 <col width="18%">
      	  	      	   	   	 <col width="14%">
      	  	      	   	   	 <col width="17%">
      	  	      	   	   	 <col width="14%">
      	  	      	   	   	 <col width="17%">
      	  	      	   	   </colgroup>
      	  	      	   	   <tbody>
      	  	      	   	    <%
      	  	      	   	       String tijiaoren = StringHelper.null2String(getmaindatamap.get("tijiaoren"));
      	  	      	   	       String tijiaobumen = StringHelper.null2String(getmaindatamap.get("tijiaobumen"));
      	  	      	   	       String tijiaoriqi = StringHelper.null2String(getmaindatamap.get("tijiaoriqi"));
      	  	      	   	       if (StringHelper.isEmpty(tijiaoren)){
      	  	      	   	       		tijiaoren = eweaveruser.getId();
      	  	      	   	       }
      	  	      	   	       if (StringHelper.isEmpty(tijiaobumen)){
      	  	      	   	       		tijiaobumen = eweaveruser.getOrgid();
      	  	      	   	       }
      	  	      	   	       if (StringHelper.isEmpty(tijiaoriqi)){
      	  	      	   	       		tijiaoriqi = DateHelper.getCurrentDate();
      	  	      	   	       }
      	  	      	   	       Humres humres = humresService.getHumresById(tijiaoren);
      	  	      	   	       
      	  	      	           String deptname = orgunitService.getOrgunitName(tijiaobumen);
      	  	      	          %>
      	  	      	   	   	<tr>
      	  	      	       	<th class="FieldName" align="right" style="font-size: 14px;font-weight: normal;">提交人：</th>
      	  	      	       	<td class="FieldValue"><%=StringHelper.null2String(humres.getObjname()) %>
      	  	      	       	</td>
      	  	      	       	<th class="FieldName"  align="right" style="font-size: 14px;font-weight: normal;">提交部门：</th>
      	  	      	       	<td class="FieldValue"><%=deptname %></td>
      	  	      	       	<th class="FieldName"  align="right" style="font-size: 14px;font-weight: normal;">提交日期：</th>
      	  	      	       	<td class="FieldValue"><%=StringHelper.null2String(tijiaoriqi) %></td>
      	  	      	       </tr>
      	  	      	   	   </tbody>
      	  	      	   </table>
      	  	      	 </div>
      	  	      </center>
      	  	 </div>
      	  	 <div class="operationbtn">
      	  	   <%if(StringHelper.isEmpty(roomid)){%>    <%--为空代表能够编辑 --%>
	      	  	 	<%
	      	  	 	String tijiaorenid = StringHelper.null2String(getmaindatamap.get("tijiaoren"));
	      	  	 	String richengrenid = StringHelper.null2String(getmaindatamap.get("richengren"));
	      	  	 	if (currentuser.getId().equals(richengrenid) || currentuser.getId().equals(tijiaorenid)){
	      	  	 	
	      	  	 		if(!"个人日程".equals(StringHelper.null2String(selectname))){
	      	  	 		pagemenustr +="addBtn(tb,'编辑','E','erase',function(){updateagenda();editfun();});";
	      	  	 	%>
<!--	      	  	 	  <input name="" type="button" value="编 辑" class="btnred02" onclick="updateagenda()" id="editfun"/>-->
	      	  	 	<%}}
	      	  	 	pagemenustr +="addBtn(tb,'保存','S','erase',function(){savefun()});";
	      	  	 	%>
<!--	      	  	 	 <input name="" type="button" value="保 存" class="btnred02" id="savefun">-->
      	  	   <%}%>
<!--      	  	 	 <input name="" type="button" value="关 闭" class="btnred02" onclick="closewindow()" id="closewin">-->
      	  	 </div>
      	  </div>
      </form>
     </div>
  </body>
</html>
<script type="text/javascript">
Ext.onReady(function(){
              Ext.QuickTips.init();
          <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>
          });
      $(function(){
      if ('1'=='<%=iscreate%>'){
      	  $("tbody input,textarea,select").attr("disabled","");
    	  $("#S").css("display","");
      }else{
	      $("tbody input,select,button").attr("disabled","disabled");
	      $("tbody textarea").attr("readonly","readonly");
	    	  $("#S").css("display","none");
      }
    	  
      	  
      });
      
      function editfun(){
      	  	$("tbody input,textarea,select,button").attr("disabled","");
      	  	$(this).css("display","none");
      	    $('#closewin').css("display","none");
      	  	$("#S").css("display","block");
      	  }
      	  function savefun(){
      	  	  document.EweaverForm.action="/app/schedule/handschedulemodify.jsp";
      		  EweaverForm.submit();
      		  closewindow();
      	  }
      function closewindow(){
    	   publish('refreshtab','tab4028d80f1999187d01199d6464df0d0f')
			var tabpanel=top.frames[1].contentPanel;
			tabpanel.remove(tabpanel.getActiveTab());
      }
      function onchange1(){
      	document.getElementById("requestid").value="";
      	document.EweaverForm.action="editschedule.jsp";
		document.EweaverForm.submit();
      }
      
      function updateagenda(){
      		onUrl('/app/schedule/editschedule.jsp?identifying=1&requestid=<%=requestid %>','公司日程');
      		closewindow();
      }
	var height = document.getElementById("teax").scrollHeight;
	document.getElementById("teax").style.height = height;
</script>
</script>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              