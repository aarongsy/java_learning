<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>


<html>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aabb6f6010aabe32990000f")+"','B','arrow_redo',function(){onReturn()});";//返回
%>
  <head>

      <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
   </style>

   <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
     <script type="text/javascript">
       Ext.onReady(function() {

           Ext.QuickTips.init();
       <%if(!pagemenustr.equals("")){%>
           var tb = new Ext.Toolbar();
           tb.render('pagemenubar');
           <%=pagemenustr%>
       <%}%>
       });
       
       
       function check(obj){
    	 var reg1=/^1?\d?\d$/;
    	 var reg2=/^2[0-4]\d$/;
    	 var reg3=/^25[0-5]$/;
    	 var t = obj.value;
    	  var ipStartLable = document.getElementById("ipStartLable");
    	  var ipEndLable = document.getElementById("ipEndLable");
    	 if(reg1.test(t)||reg2.test(t)||reg3.test(t)){
    			 ipStartLable.style.display="none";
    			 ipEndLable.style.display="none";
    	 }else{
    		 obj.value="";
    		 if(obj.id.indexOf('ipStart')!=-1){
    			 ipStartLable.style.display="block";
    			 ipEndLable.style.display="none";
    		 }else{
    			 ipStartLable.style.display="none";
    			 ipEndLable.style.display="block";
    		 }
    		 return  false;
    	 }
       }
   </script>

  </head>
  
  <body>


<div id="pagemenubar" style="z-index:100;"></div> 

		<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.ipset.servlet.IpsetAction?action=create" target="_self" name="EweaverForm"  method="post" >
	    	<table border="1" >
				<colgroup> 
					<col width="20%">
					<col width="">
					<col width="">
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007d")%>：<!-- 内网IP名称 -->
					</td>
					<td class="FieldValue">
						
						<input style="width=42%" type="text" name="ipName" id="ipName"  maxlength="128" />
						<span id=itemnamespan><img src="<%= request.getContextPath()%>/images/base/checkinput.gif"></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
              	         <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007e")%><!-- 内网IP开始地址 -->：
                    </td>
					<td bgcolor="#EFEFDE">
					<table border="0">
							<tr>
								<td style="width:70%">&nbsp;
									<input type="text" id="ipStart1" name="ipStart1" style="width=90" onblur="check(this)">.
									<input type="text" id="ipStart2" name="ipStart2" style="width=90" onblur="check(this)" >.
									<input type="text" id="ipStart3" name="ipStart3" style="width=90"  onblur="check(this)">.
									<input type="text" id="ipStart4" name="ipStart4" style="width=90" onblur="check(this)">&nbsp;&nbsp;
									<img src='<%= request.getContextPath()%>/images/base/checkinput.gif'></td>
								<td><label id="ipStartlable" style="color: red" style="display:none">&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790080")%><!-- IP只能输入0~255之间的数字！ --></label></td>
							</tr>
						</table>
					</td>
				</tr>				
					<td class="FieldName" nowrap>
                  	     <%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf7379007f")%>：<!-- 内网IP结束地址 -->
                    </td>
					<td bgcolor="#EFEFDE">
						<table>
							<tr>
								<td style="width:70%">&nbsp;
								<input type="text" id="ipEnd1" name="ipEnd1" style="width=90"  onblur="check(this)">.
								<input type="text" id="ipEnd2" name="ipEnd2" style="width=90"  onblur="check(this)">.
								<input type="text" id="ipEnd3" name="ipEnd3" style="width=90"  onblur="check(this)">.
								<input type="text" id="ipEnd4" name="ipEnd4" style="width=90"  onblur="check(this)">&nbsp;&nbsp;
								<img src="<%= request.getContextPath()%>/images/base/checkinput.gif"></td>
								<td><label id="ipEndLable" style="color: red" style="display:none">&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790080")%><!-- IP只能输入0~255之间的数字！ --></label></td>
							</tr>
						</table>
					</td>
				</tr>				
						    
		    </table>
		</form>
		
<script language="javascript">
   function onSubmit(){
   	checkfields="ipName,ipStart1,ipStart2,ipStart3,ipStart4,ipEnd1,ipEnd2,ipEnd3,ipEnd4";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   
     function onReturn(){
        var url='/base/ipset/ipsetlist.jsp';
        window.location=url;
    }
   
 </script>		
  </body>
</html>
