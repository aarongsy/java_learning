<%@include file="/base/init.jsp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
				String path = request.getContextPath();
				String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
				String gettodaydate = DateHelper.getCurrentDate();
				BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
				EweaverUser newUser = BaseContext.getRemoteUser();
				String newuserid = newUser.getId();//当前登录用户
				
				String selectitem = StringHelper.null2String(request.getParameter("selectitem"),"");
				
				
				String selectloginuser = "select objname,orgid from humres where id='"+eweaveruser.getId()+"'";
				List loginuser = baseJdbcDao.executeSqlForList(selectloginuser);
				Map loginmaMap = new HashMap();
				if(loginuser.size()>0){
					loginmaMap = (Map)loginuser.get(0);
				}		 
				String seleitem = "select id,objname from selectitem where typeid='40288182306cae5901307261edf30702' and pid is null order by id asc";
				List getselectitem = baseJdbcDao.executeSqlForList(seleitem);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>日程管理</title>
    <link rel="stylesheet" href="/culture/css/culture_association.css" type="text/css"></link>
      <script type="text/javascript" src="/htfapp/js/jquery-1.3.2.min.js"></script>
      <script type="text/javascript" src="../js/orgsubjectbudget.js"></script>
      <link rel="stylesheet" href="/schedule/css/schedule.css" type="text/css"></link>
      <script type="text/javascript" src="/schedule/js/schedule.js"></script>
      <script type="text/javascript" src="../datapicker/WdatePicker.js"></script></head>
     <script type="text/javascript">
     function savagetdata(tempval){
    	 $("#tempvalue").val(tempval);
    	 EweaverForm.submit();
     }
     $(function(){
    	$('#leixing').change(function(){
    		var gettypeid = this.options[this.selectedIndex].value;
    		if(gettypeid=='4028813130b0a8340130b1252b5f0011'||gettypeid=='40288182306cae59013072625b240704'||gettypeid=='40288182306cae59013072625b240705'){
    			$("#4028813130b0a8340130b1252b5f0011").show();
    			$("#40288182306cae59013072625b240703").hide();
    		}else{
    			$("#4028813130b0a8340130b1252b5f0011").hide();
    			$("#40288182306cae59013072625b240703").show();
    		}
    	}); 
     });
</script>

  </head>
  
  <body>
     <div align="center">
      <form action="/schedule/handschedulemodify.jsp" method="post" name="EweaverForm">
      	  <div id="layoutFrame">
      	    <input type="hidden" name="tempvalue" id="tempvalue"/>
      	    <input type="hidden" name="iseditorsave" id="iseditorsave" value="1"/>
      	  	 <div style="text-align: left;"><img alt="" src="/htfapp/images/logo_signRequest.gif"></div>
      	  	 <div class="form">
      	  	      <center>
      	  	      	 <div id="layoutDiv">
      	  	      	   <h1>日程管理</h1>
      	  	      	   <table border="1px;" cellpadding="0" cellspacing="0" class="layouttable">
      	  	      	      <colgroup>
      	  	      	      	<col width="20%">
      	  	      	      	<col width="30%">
      	  	      	      	<col width="50%">
      	  	      	      </colgroup>
      	  	      	      <tbody>
      	  	      	        <tr>
      	  	      	   	    	<th class="FieldName">日程类型：</th>
      	  	      	   	    	<td class="FieldValue" colspan="2" style="border-right: 0px;">
      	  	      	   	    		<select style="width: 330px;" name="leixing" id="leixing">
      	  	      	   	    		     <%
			      	  	      	        	Map selectmap = new HashMap();
			      	  	      	        	if(getselectitem.size()>0){
			      	  	      	        	for(int i=0;i<getselectitem.size();i++){
			      	  	      	        	selectmap = (Map)getselectitem.get(i);
			      	  	      	        	
      	  	      	       				 %>
      	  	      	   	    			   <option <% if (selectitem.equals((String)(selectmap.get("id")))){ %> selected="selected" <%} %> value="<%=StringHelper.null2String(selectmap.get("id"))%>" name="options">
      	  	      	   	    			   <%=StringHelper.null2String(selectmap.get("objname")) %></option>
      	  	      	   	    			 <%} %>
      	  	      	   	    			 <%} %>
      	  	      	   	    		 </select>
      	  	      	   	    	</td>
      	  	      	   	    	<td width="35%" class="FieldValue" style="border-left: 0px;"></td>
      	  	      	   	    </tr>
      	  	      	    </tbody>
      	  	      	   </table><br/><br/>
      	  	      	   <div id="4028813130b0a8340130b1252b5f0011">
      	  	      	     <table border="1px;" cellpadding="0" cellspacing="0" class="layouttable">
      	  	      	      <colgroup>
      	  	      	      	<col width="20%">
      	  	      	      	<col width="30%">
      	  	      	      	<col width="50%">
      	  	      	      </colgroup>
      	  	      	      <tbody>
      	  	      	       <tr>
      	  	      	       	  <th class="FieldName">日程人：</th>
      	  	      	       	  <td class="FieldValue" colspan="2">
      	  	      	       	  	<button type="button" id="ext-gen33" class="Browser" onclick="javascript:getrefobj('field_40288182308c2a4c0130926087971411','field_40288182308c2a4c0130926087971411span','402881e70bc70ed1010bc75e0361000f','','/humres/base/humresview.jsp?id=','0');" name="button_40288182308c2a4c0130926087971411" type="button"></button>
		      					<input type="hidden" value="<%=eweaveruser.getId() %>" name="field_40288182308c2a4c0130926087971411" id="field_40288182308c2a4c0130926087971411">
								<span id="field_40288182308c2a4c0130926087971411span" name="field_40288182308c2a4c0130926087971411span">
								  <%=StringHelper.null2String(loginmaMap.get("objname")) %>
								</span>
      	  	      	       	  </td>      	  	      	       	  
      	  	      	       </tr>
      	  	      	       <tr>
      	  	      	       	  <th class="FieldName"><center>时间</center></th>
      	  	      	       	  <th class="FieldName"><center>地点</center></th>
      	  	      	       	  <th class="FieldName"><center>工作内容</center></th>
      	  	      	       </tr>
      	  	      	       <%
      	  	      	        Date currentDate = new Date();;
            				int dayOfWeek = DateHelper.getDayOfWeek(currentDate);  
            				String weekfirst = "";           
            				String weeklast = "";
            				if (dayOfWeek==1){
            					
            					weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,(dayOfWeek+1)));
            					weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,0));
            					
            				}else{
            					weekfirst = DateHelper.getShortDate(DateHelper.getDay(currentDate,9-dayOfWeek));
            					weeklast = DateHelper.getShortDate(DateHelper.getDay(currentDate,1-dayOfWeek));
            				}
      	  	      	       for(int i=0; i<7;i++){ 
	      	  	      	    	String[] big = {"一","二","三","四","五","六","日"};
		      	  	            String n = Double.toString(i);
		      	  	            String last = n.substring(n.lastIndexOf(".")+1);
		      	  	            String first = n.substring(0,n.lastIndexOf("."));
		      	  	            String print = "";
			      	  	       	for(int j=0;j<first.length();j++)
				      	          {
				      	              print = print + big[Integer.parseInt(first.substring(j,j+1))];
				      	          }
      	  	      	       %>
      	  	      	       <tr>
      	  	      	       	  <th class="FieldName"><input type="text" value="<%=DateHelper.dayMove(weekfirst,i) %>" size="10" style="border: 0px;" name="FieldTime" readonly="readonly"/> 星期<%=print %></th>
      	  	      	       	  <td class="FieldValue"><input type="text" class="InputStyle2" name="idennumber"></td>
      	  	      	       	  <td class="FieldValue"><textarea cols="25" rows="2"  class="InputStyle2" name="InputStyle2"></textarea></td>
      	  	      	       </tr>
      	  	      	      <%} %>
      	  	      	       </tbody>
      	  	      	      </table>
      	  	      	    </div>
      	  	      	    <div id="40288182306cae59013072625b240703" style="display: none;">
      	  	      	     <table border="1px;" cellpadding="0" cellspacing="0" class="layouttable">
	      	  	      	      <colgroup>
	      	  	      	      	<col width="20%">
	      	  	      	      	<col width="30%">
	      	  	      	      	<col width="20%">
	      	  	      	      	<col width="30%">
	      	  	      	      </colgroup>
	      	  	      	      <tbody>
	      	  	      	      	<tr>
		      	  	      	         <th class="FieldName">标题：</th>
		      	  	      	         <td class="FieldValue" colspan="3">		      	  	      	           
		      	  	      	           <input type="text" class="InputStyle2" name="biaoti">
		      	  	      	         </td>
		      	  	      	         </tr>
		      	  	      	       <tr>
		      	  	      	         <th class="FieldName">开始时间：</th>
		      	  	      	         <td class="FieldValue"><input type="text" class="InputStyle2" onclick="WdatePicker()" name="startdate"></td>
		      	  	      	         <th class="FieldName">结束时间：</th>
		      	  	      	         <td class="FieldValue"><input type="text" class="InputStyle2" onclick="WdatePicker()" name="enddate"></td>
								   </tr>
								   <tr>
		      	  	      	         <th class="FieldName">工作内容：</th>
		      	  	      	         <td class="FieldValue" colspan="3">
		      	  	      	           <textarea rows="10" cols="108" name="neirong"></textarea>
		      	  	      	         </td>
		      	  	      	         </tr>
	      	  	      	      </tbody>
      	  	      	     </table>
      	  	      	    </div>
      	  	      	   <br/>
      	  	      	   <br/>
      	  	      	   <table class="layouttable" border="1px;">
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
      	  	      	       	<th class="FieldName">提交人:&nbsp;&nbsp;</th>
      	  	      	       	<td class="FieldValue">
      	  	      	       	  <input type="button" name="button_4028818230686b49013069c812b800e0" class="Browser"
      	  	      	       	  	onclick="javascript:getrefobj('field_4028818230686b49013069c812b800e0','field_4028818230686b49013069c812b800e0span','402881eb0bd30911010bd321d8600015','','/humres/base/humresview.jsp?id=','1');">
      	  	      	       	  	<input name="field_4028818230686b49013069c812b800e0" type="hidden" value="<%=eweaveruser.getId() %>">
      	  	      	       	  	<span id="field_4028818230686b49013069c812b800e0span" name="field_4028818230686b49013069c812b800e0span">
      	  	      	       	  	  <%=StringHelper.null2String(loginmaMap.get("objname")) %>
      	  	      	       	  </span>
      	  	      	       	</td>
      	  	      	       	<th class="FieldName">提交部门:&nbsp;&nbsp;</th>
      	  	      	       	<%
      	  	      	       	  List orgList	= baseJdbcDao.executeSqlForList("select objname from orgunit where id='"+StringHelper.null2String(loginmaMap.get("orgid"))+"'");
      	  	      	       	  Map orgMap = new HashMap();
      	  	      	       	  if(orgList.size()>0){
      	  	      	       		  orgMap = (Map)orgList.get(0);
      	  	      	       	  }
      	  	      	       	%>
      	  	      	       	<td class="FieldValue">
      	  	      	       		<button type=button  class=Browser name="button_4028818230686b49013068db5724001a" onclick="javascript:getrefobj('field_4028818230686b49013068db5724001a','field_4028818230686b49013068db5724001aspan','40287e8e12066bba0112068b730f0e9c','','/base/orgunit/orgunitview.jsp?id=','0');"></button>
		      				  <input type="hidden" name="field_4028818230686b49013068db5724001a" value="<%=StringHelper.null2String(loginmaMap.get("orgid")) %>"  style='width: 80%'>
		      				  <span id="field_4028818230686b49013068db5724001aspan" name="field_4028818230686b49013068db5724001aspan" >
		      				  	<%=StringHelper.null2String(orgMap.get("objname")) %>
		      				  </span></span></span>
      	  	      	       	</td>
      	  	      	       	<th class="FieldName">提交日期:&nbsp;&nbsp;</th>
      	  	      	       	<td class="FieldValue"><input type="text" value="<%=gettodaydate %>" style="border: 0px" size="10" name="Fileddate" onclick="WdatePicker()"/></td>
      	  	      	       </tr>
      	  	      	   	   </tbody>
      	  	      	   </table>
      	  	      	 </div>
      	  	      </center>
      	  	 </div>
      	  	 <div class="align_c btns">
      	  	 	<a href="javascript:void(0)" onclick="savagetdata(1)">
      	  	 		<span>
      	  	 			<div><font color="white">提交<font/></div>
      	  	 		</span>
      	  	 	</a>
      	  	 	<a href="javascript:void(0)" onclick="savagetdata(2)">
      	  	 		<span>
      	  	 			<div><font color="white">提交并新建<font/></div>
      	  	 		</span>
      	  	 	</a>
      	  	 	<a href="javascript:history.back(1)">
      	  	 		<span>
      	  	 			<div><font color="white">返回<font/></div>
      	  	 		</span>
      	  	 	</a>
			</div>
      	  </div>
      </form>
     </div>
  </body>
</html>
