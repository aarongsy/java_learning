<%@include file="/base/init.jsp" %>
<%@page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%

			HumresService humresService = (HumresService)BaseContext.getBean("humresService");
			OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
			SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
			DataService dataService = new DataService();			
			String weekdate = StringHelper.null2String(request.getParameter("weekdate"),DateHelper.getCurrentDate());
			String richengren = StringHelper.null2String(request.getParameter("richengren"),eweaveruser.getId());			
			String requestid = StringHelper.null2String(request.getParameter("requestid"));//日程主表requestid
			//System.out.println("requestid======"+requestid);
			String richengleixing = StringHelper.null2String(request.getParameter("richengleixing"));//默认我的日程 ,"40288182306cae59013072625b240704"
		    String roomid = StringHelper.null2String(request.getParameter("roomid"));//会议id
			String txid=StringHelper.null2String(request.getParameter("txid"));
			String iscreate = StringHelper.null2String(request.getParameter("iscreate"));//是否创建			
            String weekfirst = "";           
            String weeklast = "";          	        					
            String selectmainsql = "";
            Map getmaindatamap = new HashMap();
            String selectdetailsql ="";
            List getdetaildatalist = new ArrayList();
            boolean notcp=false;
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
					notcp=true;
				}
			}
			if (!StringHelper.isEmpty(requestid)){
				iscreate="0";
				selectmainsql = "select requestid,richengren,tijiaoren,tijiaobumen,tijiaoriqi,richengleixing,richenshijian,jieshuriqi,kaishiriqi,gongzuoneirong,biaoti,weekdate,gsdidian from uf_schedule where requestid='"+requestid+"'";
				getmaindatamap = dataService.getValuesForMap(selectmainsql);	
				System.out.println("fsdf"+getmaindatamap);
				richengleixing = (String)getmaindatamap.get("richengleixing");
				if (StringHelper.isEmpty(richengleixing)){
					richengleixing = "40288182306cae59013072625b240704";
				}
				richengren = (String)getmaindatamap.get("richengren");
				weekdate = (String)getmaindatamap.get("weekdate");
				selectdetailsql = "select requestid,shijian,didian,neirong,xingqi from uf_scheduledetail where requestid='"+requestid+"' order by shijian asc";
				getdetaildatalist = dataService.getValues(selectdetailsql);
			}
			String selectname = selectitemService.getSelectitemNameById(richengleixing);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>日程管理</title>
<!--    <link rel="stylesheet" href="/culture/css/culture_association.css" type="text/css"></link>-->
      <script type="text/javascript" src="/app/js/jquery.js"></script>
      <script type="text/javascript" src="/js/orgsubjectbudget.js"></script>
      <link rel="stylesheet" href="/app/schedule/css/schedule.css" type="text/css"></link>
      <script type="text/javascript" src="/app/schedule/js/schedule.js"></script>
      <script type="text/javascript" src="/datapicker/WdatePicker.js"></script>
      <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	  <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
	  <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
  </head>
  
  <body>
  <div id="pagemenubar"></div>
     <div align="center">
      <form action="/app/schedule/handschedulemodify.jsp" method="post" name="EweaverForm">
<!--      	  <div id="layoutFrame">-->
<!--      	  	 <img alt="" src="/htfapp/images/logo_signRequest.gif">-->
      	  	 <%if(richengleixing.equals("40288182306cae59013072625b240703")){%>
<!--      	  	 <div align="right" style="width: 800px;">-->
<!--      	  	      <a href="#" title="公司日程主要包括的内容如下：-->
<!--1、重要来访。主要内容为：上级监管部门、股东单位、政府来访等活动（一句话新    闻预告）；大型公司路演（一句话新闻预告）；其他重要来访。-->
<!--2、公司客户活动。主要内容为：基金经理面对面（一句话新闻预告）；添富之约、      走进汇添富（一句话新闻预告）；投资策略会、添富论坛（一句话新闻预告）；    其他重要客户活动。-->
<!--3、产品发行信息。主要内容为：公募基金发行及成立信息（一句话新闻预告）;专户    产品发行及成立信息（一句话新闻预告）。-->
<!--4、其他业务动态。主要内容为：其他重要公司业务信息。">帮助</a>-->
<!--      	  	 </div>-->
      	  	 <%}%>
      	  	 <input type="hidden" value="<%=requestid%>" name="requestid"/>   	  	 
      	  	 <div class="form" style="width: 800px;">
      	  	      <center>
      	  	      	 <div id="layoutDiv">
      	  	      	   <h1><%=StringHelper.null2String(selectname) %></h1>
      	  	      	   <table border="0px;" cellpadding="0" style="display: <%=notcp?"":"none" %>" cellspacing="0" class="layouttable">
      	  	      	      <colgroup>
      	  	      	      	<col width="15%">
      	  	      	      	<col width="20%">
      	  	      	      	<col width="50%">
      	  	      	      </colgroup>
      	  	      	      <tbody>
      	  	      	       <tr>
      	  	      	   	    	<th class="FieldName" style="display: none;">日程类型</th>
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
      	  	      	         
      	  	      	       	  <th class="FieldName">日程人</th>
      	  	      	       	  <td class="FieldValue">
      	  	      	       	  	<button class="Browser" onclick="javascript:getrefobj('richengren','richengrenspan','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresview.jsp?id=','0');" name="button_richengren" type="button"></button>
		      					<input type="hidden" value="<%=richengren%>" name="richengren" id="richengren"  >
								<span id="richengrenspan" name="richengrenspan" onpropertychange="javascript:onchange1()"><%=richengrenname%></span>
      	  	      	       	    
      	  	      	       	  </td>
      	  	      	       	   	<th class="FieldName" style="text-align: left;">&nbsp;时间
      	  	      	       	   		<input type="text" onclick="WdatePicker()" name="weekdate" id="date" value="<%=weekdate %>" onchange="javascript:onchange1()">
      	  	      	       	   	</th>
      	  	      	       </tr>
      	  	      	        <tr>
      	  	      	       	  <th class="FieldName"><center>时间</center></th>
      	  	      	       	  <th class="FieldName"><center>地点</center></th>
      	  	      	       	  <th class="FieldName"><center>工作内容</center></th>
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
      	  	      	       	  <th class="FieldName"><input type="text" value="<%=shijian%>" size="10" style="border: 0px;" name="FieldTime" readonly="readonly"/> 星期<%=print %></th>
      	  	      	       	  <td class="FieldValue"><input type="text" class="InputStyle2" name="idennumber" value="<%=StringHelper.null2String(detaildatamMap.get("didian")) %>"></td>
      	  	      	       	  <td class="FieldValue"><textarea cols="25" rows="2"  class="InputStyle2" name="InputStyle2"><%=StringHelper.null2String(detaildatamMap.get("neirong")) %></textarea></td>
      	  	      	       </tr>
      	  	      	       <%} %>
      	  	      	       <%}else if("40288182306cae59013072625b240704".equals(richengleixing)){
      	  	      	    	   %>
      	  	      	    	   <input type="hidden" value="<%=richengren%>" name="richengren" id="richengren"  >
      	  	      	    	   
      	  	      	    	   <%
      	  	      	    	   
      	  	      	       } %>
      	  	      	       </tbody>
      	  	      	   </table>
      	  	      	   <%if(("40288182306cae59013072625b240703").equals(richengleixing)||"40288182306cae59013072625b240704".equals(richengleixing)){ %>
      	  	      	   <table border="1px;" cellpadding="0" cellspacing="0" class="layouttable">
	      	  	      	      <colgroup>
	      	  	      	      	<col width="15%">
	      	  	      	      	<col width="15%">
	      	  	      	      	<col width="15%">
	      	  	      	      	<col width="15%">
	      	  	      	      	<col width="15%">
	      	  	      	      	<col width="15%">
	      	  	      	      </colgroup>
	      	  	      	      <tbody>
	      	  	      	     
	      	  	      	      	  <tr>
		      	  	      	         <th class="FieldName">标题</th>
		      	  	      	         <td class="FieldValue" colspan="5">		      	  	      	           
		      	  	      	           <input type="text" class="InputStyle2" name="biaoti" value="<%=StringHelper.null2String(getmaindatamap.get("biaoti"))%>">
		      	  	      	         </td>
		      	  	      	       </tr>
		      	  	      	       <tr>
		      	  	      	         <th class="FieldName">开始时间</th>
		      	  	      	         <td class="FieldValue"><input type="text" class="InputStyle2" onclick="WdatePicker()" name="startdate" id="startdate" value="<%=StringHelper.null2String(getmaindatamap.get("kaishiriqi")) %>"></td>
		      	  	      	         <th class="FieldName">结束时间</th>
		      	  	      	         <td class="FieldValue"><input type="text" class="InputStyle2" onclick="WdatePicker()" name="enddate" id="enddate" value="<%=StringHelper.null2String(getmaindatamap.get("jieshuriqi")) %>"></td>
		      	  	      	         <th class="FieldName">地点</th>
		      	  	      	         <td class="FieldValue"><input type="text" class="InputStyle2" name="gsadress" id="gsadress" value="<%=StringHelper.null2String(getmaindatamap.get("gsdidian"))%>"></td>
								   </tr>
								   <tr>
		      	  	      	         <th class="FieldName">工作内容</th>
		      	  	      	         <td class="FieldValue" colspan="5">
		      	  	      	           <textarea rows="10" cols="105" name="neirong"><%=StringHelper.null2String(getmaindatamap.get("gongzuoneirong")) %></textarea>
		      	  	      	         </td>
		      	  	      	       </tr>
	      	  	      	      </tbody>
      	  	      	   </table>
      	  	      	   <%} %>
      	  	      	   <table class="layouttable" cellpadding="0" cellspacing="0">
      	  	      	   	   <colgroup>
      	  	      	   	   	 <col width="15%">
      	  	      	   	   	 <col width="15%">
      	  	      	   	   	 <col width="15%">
      	  	      	   	   	 <col width="15%">
      	  	      	   	   	 <col width="15%">
      	  	      	   	   	 <col width="15%">
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
      	  	      	       	<th class="FieldName">提交人&nbsp;&nbsp;</th>
      	  	      	       	<td class="FieldValue">
      	  	      	       	   <%=StringHelper.null2String(humres.getObjname()) %>
      	  	      	       	</td>
      	  	      	       	<th class="FieldName">提交部门&nbsp;&nbsp;</th>
      	  	      	       	<td class="FieldValue">
		      					<%=deptname %>
		      				  </span></span></span>
      	  	      	       	</td>
      	  	      	       	<th class="FieldName">提交日期&nbsp;&nbsp;</th>
      	  	      	       	<td class="FieldValue"><input type="text" value="<%=StringHelper.null2String(tijiaoriqi) %>" style="border: 0px" size="10" name="Fileddate" onclick="WdatePicker()"/></td>
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
	      	  	 	if (!"0".equals(iscreate) && (currentuser.getId().equals(richengrenid) || currentuser.getId().equals(tijiaorenid))){
	      	  	 	pagemenustr +="addBtn(tb,'编辑','E','erase',function(){editfun()});";
	      	  	 	%>
	      	  	 		
<!--	      	  	 	  <input name="" type="button" value="编 辑"  id="editfun"/>-->
	      	  	 	<%};
	      	  	 	pagemenustr +="addBtn(tb,'保存','S','erase',function(){savefun()});";
	      	  	 	%>
<!--	      	  	 	 <input name="" type="button" value="保 存"  id="savefun">-->
      	  	   <%}%>
<!--      	  	 	 <input name="" type="button" value="关 闭"  onclick="closewindow()" id="closewin">-->
      	  	 </div>
<!--      	  </div>-->
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
		      $("tbody input,textarea,select,button").attr("disabled","");
		    	  $("#S").css("display","");
	      }
      });
      
      function editfun(){
      	  	$("tbody input,textarea,select,button").attr("disabled","");
      	  	$(this).css("display","none");
      	    $('#closewin').css("display","none");
      	  	$("#S").css("display","block");
      	  }
      	  function savefun(){
      		  var startdate = $('#startdate').val();
      		  var enddate = $('#enddate').val();
      		  if(typeof(startdate)!="undefined"&&typeof(enddate)!="undefined"){
      			  startdate = startdate.replace("-","").replace("-","");
      			  enddate = enddate.replace("-","").replace("-","");
      			  if(startdate>enddate){
      				  alert("开始日期不能够大于结束日期！");
      				  $('#enddate').val("").focus();
      				  return;
      			  }
      		  }
      	  	  document.EweaverForm.action="/app/schedule/handschedulemodify.jsp?txid=<%=txid %>";
      		  EweaverForm.submit();
      		  alert("提交成功！");
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
</script>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  