<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>

<%
String strForminfoId=request.getParameter("forminfoid");
Forminfo forminfo = ((ForminfoService)BaseContext.getBean("forminfoService")).getForminfoById(strForminfoId);
List list=FormfieldTranslate.getAllUIType();
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title><%=labelService.getLabelName("402881e60b95cc1b010b961f6f910008")%></title>
    <%if(request.getParameter("issuccess")!=null){%>
        <%if(request.getParameter("issuccess").equals("1")){%>
            <SCRIPT>
                window.close();
            </SCRIPT>
        <%}else if(request.getParameter("issuccess").equals("2")){%>
            <SCRIPT>
                alert('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003a") %>');//该字段名称已经存在，请更换为其他名称！
            </SCRIPT>
        <%}else if(request.getParameter("issuccess").equals("3")){%>
            <SCRIPT>
                alert('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003b") %>');//该字段名称为数据库关键字，请更换为其他名称！
            </SCRIPT>
        <%}%>
    <%}%>
  </head>
  
  <body onload="IsShowFieldType();">
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=create" target="_self" name="EweaverForm"  method="post">
		<input type="hidden" name="forminfoid" value='<%=strForminfoId%>' />
		
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

		<table>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>	
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b96212bc80009")%>
					</td>
					<td class="FieldValue">
						<input type="text" MAXLENGTH="26" name="fieldName" id="fieldName"  onChange="checkinput_char_num('fieldName');checkInput('fieldName','fieldNamespan')"/>
						<span id="fieldNamespan"/><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b9621ab87000a")%>
					</td>
					<td class="FieldValue">
						  <select name="uiType" Onchange="IsShowFieldType()">
						  <%
                              if(StringHelper.null2String(forminfo.getCol1()).equals("1")){
                          %>
                              <option value=6 selected><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003c") %><!-- 关联选择 --></option>
                              <option value=7 ><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017") %><!-- 附件 --></option>  
                          <%    }else{
						      for(int i=1;i<=list.size();i++)
						      {
						        if(i==1){
						  %>
						  		<option value='<%=i%>' selected><%=list.get(i-1)%></option>
						  <%
						  }
						  else{
						  %>
						       <option value='<%=i%>'><%=list.get(i-1)%></option>		       
						  <%
						  }
						  }}
						  %>
    					 </select>
    				</td>
				</tr>
				<tr id="oDiv1" style="display:none">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b9621d0e1000b")%>
					</td>
					<td id="oDivfv" class="FieldValue">
						<select name="fieldType" Onchange="IsShowFieldAttr()">
						<%
						       list=FormfieldTranslate.getAllFieldType();
						      for(int i=1;i<=list.size();i++)
						      {
						        if(i==1){
						  %>
						  		<option value='<%=i%>' selected><%=list.get(i-1)%></option>
						  <%
						  }
						  else{
						  %>
						       <option value='<%=i%>'><%=list.get(i-1)%></option>		       
						  <%
						  }
						  }
						  %>
    					 </select>
					</td>
				</tr>
				<tr id="oDiv3" style="display:none">
					<td id="oDivrt1" class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b9661001d0011")%>
					</td>
					<td id="oDivrt2" class="FieldValue">
						<!-- input type="text" name="relatbId" /-->
						<input type="hidden" name="relatbId" />						    			
          				<button type="button"  class=Browser onclick="javascript:getBrowser2('/base/refobj/refobjbrowser.jsp?moduleid=<%=moduleid%>','relatbId','relatbIdspan','0');"></button>
             			<span id="relatbIdspan"></span>						
					</td>
				</tr>
				<tr id="oDiv4" style="display:none">
					<td id="oDivsel1" class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50acff854010ad05534de0005")%>
					</td>
					<td id="oDivsel2" class="FieldValue">
						<input type="hidden" name="selId" />						    			
          				<button  type="button" class=Browser onclick="javascript:getBrowser('/base/selectitem/selectitemtypebrowser.jsp?moduleid=<%=moduleid%>','selId','selspan','0');"></button>
             			<span id="selspan"></span>
					</td>
				</tr>
				<tr id="oDiv2" style="display:none">
					<td id="oDivfa1" class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b96605fe50010")%>
					</td>
					<td id="oDivfa2" class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b966017e0000f")%>
					</td>
					<td id="oDivfa3" class="FieldValue">
						<input type="text" name="fieldattr" />
					</td>
				</tr>
				<tr id="fieldChecktr">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965fccdc000e")%>
					</td>
					<td class="FieldValue">
						<TEXTAREA id="fieldCheck" name="fieldCheck" ROWS="5" COLS="80"></TEXTAREA>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965f6a0c000d")%>
					</td>
					<td class="FieldValue">
						<input type="text" name="labelId" />
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965dc554000c")%>
					</td>
					<td class="FieldValue">
						<input type="text" name="labelname" />
					</td>
				</tr>
				<tr id="oDiv5" style="display:none">
					<td  class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%>
					</td>
					<td class="FieldValue">
						<select id ="isselect" name="isselect" >
							<option value="0" selected><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003d") %><!-- 可选择可新建 --></option>
						  	<option value="1" ><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935003e") %><!-- 只新建 --></option>
						    <option value="2" ><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935003f") %><!-- 只选择 --></option>		       
    					</select>
					</td>
				</tr>
            <tr id="oDiv6" style="display:none">
					<td  class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39350040") %><!-- 是否是金额字段 -->
					</td>
					<td class="FieldValue">
					<input type="checkbox" name="ismoney" id="ismoney" value="0" onclick="CheckMoney()"/>
					</td>
				</tr>
			</table> 

		</form>
  </body>
</html>

<script language="javascript">
   
    function onSubmit(){
        checkfields="fieldName";
        checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
        if(checkForm(EweaverForm,checkfields,checkmessage)){
            document.EweaverForm.submit();
        }
    }
   function CheckMoney(){
     if(document.getElementById("ismoney").checked){
         document.getElementById("ismoney").value="1";
     }else{
         document.getElementById("ismoney").value="0";
     }
   }
   function IsShowContent()
   {
      IsShowFieldType();
      IsShowFieldAttr();      
   }

   function IsShowFieldType()
   {
      var uiType=document.EweaverForm.uiType.value;
      var o = document.getElementById("oDiv1");
      var o2 = document.getElementById("oDiv2");
      var o1 = document.getElementById("oDivfv");
      var o3 = document.getElementById("oDiv3");
      var o4 = document.getElementById("oDiv4");
      var o5 = document.getElementById("oDiv5");
      var oSelect = document.getElementById("isselect");
      
      document.EweaverForm.fieldType.selectedIndex=0;
      IsShowFieldAttr();
      if(Number(uiType)==1)
      {
          o.style.display='';
          o1.style.display='';
          o2.style.display=''; 
          o3.style.display='none';  
          o4.style.display='none';  
          o5.style.display='none';  
          oSelect.style.display='none';  
      }
      else if(Number(uiType)==6)
      {
          o.style.display='none';
          o1.style.display='none';
          o2.style.display='none'; 
          o3.style.display='';  
          o4.style.display='none'; 
      }
      else if(Number(uiType)==5)
      {
          o.style.display='none';
          o1.style.display='none';
          o2.style.display='none'; 
          o3.style.display='none';  
          o4.style.display='';  
          o5.style.display='none';  
          oSelect.style.display='none';
      }
	  else
	  {
		  o.style.display='none'; 
		  o1.style.display='none';  
		  o2.style.display='none';  
		  o3.style.display='none';
		  o4.style.display='none'; 
		  o5.style.display='none';  
          oSelect.style.display='none';                            
      }
      
   }	
   
   function IsShowFieldAttr()
   {
   
   		
      var fieldType=document.EweaverForm.fieldType.value;
      var o = document.getElementById("oDiv2");
      var o1 = document.getElementById("oDivfa1");
      var o2 = document.getElementById("oDivfa2");
       var imdiv=document.getElementById("oDiv6");
      var fieldChecktr = document.getElementById("fieldChecktr");
      
      if(Number(fieldType)==1)
      {
          o.style.display='';
          o1.style.display='';
          o2.style.display='none';
          imdiv.style.display='none';
          fieldChecktr.style.display='';
          document.all("fieldattr").value="256";
          document.all("fieldCheck").value ="";
      }
	  else if(Number(fieldType)==3)
	  {
		  o.style.display='';
          o1.style.display='none';
          o2.style.display='';  
          fieldChecktr.style.display='';
          imdiv.style.display='block';
          document.all("fieldattr").value="";
          document.all("fieldCheck").value ="^(-?\\d+)(\\.\\d+)?$";                                
      }
      else if(Number(fieldType)==2)
      {
         o.style.display='none';
         fieldChecktr.style.display='';
            imdiv.style.display='none';
         document.all("fieldattr").value="";
         document.all("fieldCheck").value ="^-?\\d+$";
      }
      else if (Number(fieldType)==4)
      {
         fieldChecktr.style.display='none';
         o.style.display='none';
            imdiv.style.display='none';
         document.all("fieldattr").value="10";
         document.all("fieldCheck").value ="";//yyyy-mm-dd
      }
      else if (Number(fieldType)==5)
      {
         fieldChecktr.style.display='none';
            imdiv.style.display='none';
         o.style.display='none';     
         document.all("fieldattr").value="8";
         document.all("fieldCheck").value ="";  //hh-mm-ss
      }
      
   }
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
    function getBrowser2(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
        if( id[1]=="文档") {
			document.all("oDiv5").style.display="";
			document.all("isselect").style.display="";
    }else {
			document.all("oDiv5").style.display="none";
			document.all("isselect").style.display="none";
        }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>


