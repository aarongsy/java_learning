<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.util.FormfieldTranslate"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.document.base.service.DocbaseService"%>
<%@ page import="com.eweaver.document.base.model.Docbase"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%
String strForminfoId=request.getParameter("formid");
List list=FormfieldTranslate.getAllUIType();

Formfield formfield = (Formfield)request.getAttribute("formfield");

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath()%>/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath()%>/dwr/util.js'></script>
    <title><%=labelService.getLabelName("402881e60b95cc1b010b961f6f910008")%></title>   
  </head>
  
  <body onload="IsShowFieldType();">
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=modify" target="_self" name="EweaverForm"  method="post">
		<input type="hidden" name="forminfoid" value='<%=strForminfoId%>' />
		
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
<input type="hidden" name="id" value="<%=StringHelper.null2String(formfield.getId()) %>">
<input type="hidden" name="fieldNameOld" value="<%=StringHelper.null2String(formfield.getFieldname()) %>">
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
						<input type="text" 
							MAXLENGTH="26" 
							name="fieldName" 
							id="fieldName" 
							value="<%=StringHelper.null2String(formfield.getFieldname()) %>"
							onChange="checkinput_char_num('fieldName');checkInput('fieldName','fieldNamespan')" <%if(formfield.getIsdefault()==1){%>readonly<%}%>/>
						<span id="fieldNamespan"/></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b9621ab87000a")%>
					</td>
					<td class="FieldValue">
						  <select name="uiType" onload="IsShowFieldType()" >
						  <%
						      for(int i=1;i<=list.size();i++)
						      {
						        if(formfield.getHtmltype().toString().equals(""+ i)){
						  %>
						  		<option value='<%=i%>' selected><%=list.get(i-1)%></option>
						  <%
						  }
						  else{
						  %>
						            
						  <%
						  }
						  }
						  %>
    					 </select>
    				</td>
				</tr>
				<tr id="oDiv1" style="display:none">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b9621d0e1000b")%>
					</td>
					<td id="oDivfv" class="FieldValue">
						<select name="fieldType" onload="IsShowFieldAttr()" readonly>
						<%
						       list=FormfieldTranslate.getAllFieldType();
						      for(int i=1;i<=list.size();i++)
						      {
						        if(String.valueOf(i).equals(formfield.getFieldtype())){
						  %>
						  		<option value='<%=i%>' selected><%=list.get(i-1)%></option>
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
						<input type="hidden" name="relatbId" value="<%=StringHelper.null2String(formfield.getFieldtype()) %>"/>						    			
          				<button  type="button" class=Browser onclick="javascript:getBrowser2('/base/refobj/refobjbrowser.jsp','relatbId','relatbIdspan','0');"></button>
             			<span id="relatbIdspan">
						<%  int _htmltype = formfield.getHtmltype().intValue();
							String _fieldtype = FormfieldTranslate.getFieldTypeById(formfield.getFieldtype());
							if(_fieldtype.equals("")&&_htmltype==5){
								_fieldtype = StringHelper.null2String(((SelectitemtypeService)BaseContext.getBean("selectitemtypeService"))
												.getSelectitemtypeById(formfield.getFieldtype()).getObjname());
							}
							//todo 关联选择...
							if(_fieldtype.equals("")&&_htmltype==6){
								_fieldtype = ((RefobjService)BaseContext.getBean("refobjService"))
												.getRefobj(formfield.getFieldtype()).getObjname();
							}							
						%>
						<%=StringHelper.null2String(_fieldtype)%>
             			</span>						
					</td>
				</tr>
				<tr id="oDiv4" style="display:none">
					<td id="oDivsel1" class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50acff854010ad05534de0005")%>
					</td>
					<td id="oDivsel2" class="FieldValue">
						<input type="hidden" name="selId" value="<%=StringHelper.null2String(formfield.getFieldtype()) %>"/>						    			
          				<button  type="button" class=Browser onclick="javascript:getBrowser('/base/selectitem/selectitemtypebrowser.jsp','selId','selspan','0');"></button>
             			<span id="selspan">
             			
						<%  
						
							int _htmltype2 = formfield.getHtmltype().intValue();
							String _fieldtype2 = FormfieldTranslate.getFieldTypeById(formfield.getFieldtype());
							if(_fieldtype2.equals("")&&_htmltype2==5){
								_fieldtype2 = StringHelper.null2String(((SelectitemtypeService)BaseContext.getBean("selectitemtypeService"))
												.getSelectitemtypeById(formfield.getFieldtype()).getObjname());
							}
							//todo 关联选择...
							if(_fieldtype2.equals("")&&_htmltype2==6){
								_fieldtype2 = ((RefobjService)BaseContext.getBean("refobjService"))
												.getRefobj(formfield.getFieldtype()).getObjname();
							}							
						%>
						<%=StringHelper.null2String(_fieldtype2)%>         			
             			
             			</span>
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
						<input type="text" name="fieldattr" value="<%=StringHelper.null2String(formfield.getFieldattr()) %>" readonly/>
					</td>
				</tr>
				<tr id="fieldChecktr">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965fccdc000e")%>
					</td>
					<td class="FieldValue">
						<TEXTAREA id="fieldCheck" name="fieldCheck" ROWS="5" COLS="80"><%=StringHelper.null2String(formfield.getFieldcheck())%></TEXTAREA>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965f6a0c000d")%>
					</td>
					<td class="FieldValue">
						<input type="text" name="labelId" value="<%=StringHelper.null2String(formfield.getLabelid())%>"/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e60b95cc1b010b965dc554000c")%>
					</td>
					<td class="FieldValue">
						<input type="text" name="labelname" value="<%=StringHelper.null2String(formfield.getLabelname())%>"/>
					</td>
				</tr>
				<tr id="oDiv5" style="display:none">
					<td  class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e70bc6e72f010bc70c4b660008")%>
					</td>
					<td class="FieldValue">

						<select id ="isselect" name="isselect" >
					<%
						

						String isseltemp = "";
						for(int i=0; i< 3; i++){
							String isselect="";
							if(i == 0){
								isseltemp = labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3934003d");//可选择可新建
							}else if(i == 1){
								isseltemp = labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3937005f");//只创建
							}else if(i == 2){
								isseltemp = labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3935003f");//只选择
							}
							if(String.valueOf(i).equals(formfield.getFieldattr())){
								isselect ="selected";
								
							}
										%>
						  	<option value="<%=i%>" <%=isselect%>><%=isseltemp%></option>
					<%
					}%>	  	
						  	       
    					</select>
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3937005e")%><!-- 唯一性约束 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isOnly" value="1" <%if(formfield.getIsOnly()!=null&&formfield.getIsOnly()==1){%>checked<%}%>/>
					</td>
				</tr>
                 <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370060")%><!-- 重复数据提醒 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="isprompt" value="1" <%if(formfield.getIsprompt()!=null&&formfield.getIsprompt()==1){%>checked<%}%>/>
					</td>
				</tr>
                <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370061")%><!-- 是否纪录日志 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="needLog" value="1" <%if(formfield.getNeedLog()!=null&&formfield.getNeedLog()==1){%>checked<%}%>/>
					</td>
				</tr>
          <%if(formfield.getHtmltype()==1&&formfield.getFieldtype().equals("3")){%>
             <tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370062")%><!-- 是否金额字段 -->
					</td>
					<td class="FieldValue">
						<input type="checkbox" name="ismoney" value="1" <%if(formfield.getIsmoney()!=null&&formfield.getIsmoney()==1){%>checked<%}%> onclick="CheckMoney()"/>
					</td>
				</tr>
                <%}%>
            </table>

		</form>
  </body>
</html>

<script language="javascript">
   
   function onSubmit()
   {
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
      }
      else if(Number(uiType)==6)
      {
          o.style.display='none';
          o1.style.display='none';
          o2.style.display='none'; 
          o3.style.display='';  
          o4.style.display='none'; 
          if(document.all("relatbId").value=="402881e70bc70ed1010bc710b74b000d")
          		o5.style.display=''; 
      }
      else if(Number(uiType)==5)
      {
          o.style.display='none';
          o1.style.display='none';
          o2.style.display='none'; 
          o3.style.display='none';  
          o4.style.display='';  
          o5.style.display='none';  
      }
	  else
	  {
		  o.style.display='none'; 
		  o1.style.display='none';  
		  o2.style.display='none';  
		  o3.style.display='none';
		  o4.style.display='none';   
          o5.style.display='none';                            
      }
      
   }	
   
   function IsShowFieldAttr()
   {
   
   		
      var fieldType=document.EweaverForm.fieldType.value;
      var o = document.getElementById("oDiv2");
      var o1 = document.getElementById("oDivfa1");
      var o2 = document.getElementById("oDivfa2");
      var o3 = document.getElementById("oDivfa3");
      var fieldChecktr = document.getElementById("fieldChecktr");
      if(Number(fieldType)==1)
      {
          o.style.display='';
          o1.style.display='';
          o2.style.display='none';
          fieldChecktr.style.display='';
        //  document.all("fieldattr").value="";
        //  document.all("fieldCheck").value ="";
      }
	  else if(Number(fieldType)==3)
	  {
		  o.style.display='';
          o1.style.display='none';
          o2.style.display='';  
          fieldChecktr.style.display='';   
         // document.all("fieldattr").value="";
        //  document.all("fieldCheck").value ="";                                
      }
      else if(Number(fieldType)==2)
      {
         o.style.display='none';
         o1.style.display='none';
         o2.style.display='none';
         o3.style.display='none';
         fieldChecktr.style.display='';
       //  document.all("fieldattr").value="";
        // document.all("fieldCheck").value ="";
      }
      else if (Number(fieldType)==4)
      {
         fieldChecktr.style.display='';
         o.style.display='none';
         o1.style.display='none';
         o2.style.display='none';
         o3.style.display='none';
         document.all("fieldattr").value="10";
         //document.all("fieldCheck").value ="";//yyyy-mm-dd
      }
      else if (Number(fieldType)==5)
      {
         fieldChecktr.style.display='none';
         o.style.display='none';
         o1.style.display='none';
         o2.style.display='none';
         o3.style.display='none';   
         document.all("fieldattr").value="8";
         document.all("fieldCheck").value ="";  //hh-mm-ss
      }
      
   }	

<%
int ismulti = 0;
if(StringHelper.null2String(formfield.getFieldtype()).length()==32){
	RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
	if(refobjService.getRefobj(formfield.getFieldtype())!=null && refobjService.getRefobj(formfield.getFieldtype()).getIsmulti()!=null)
		ismulti = refobjService.getRefobj(formfield.getFieldtype()).getIsmulti();
}
%>
function getIsMulti(id,inputname,inputspan){
	var sql = "select ismulti from refobj where id='"+id+"'";
	DataService.getValue(sql,{
      callback:function(data) {
		if(data!=<%=ismulti%>){
			if(<%=ismulti%>==0){
				alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370063") %>");//请选择单选Browser字段。
			}else{
				alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39370064") %>");//请选择多选Browser字段。
			}
			document.all("relatbId").value = "";
			document.all("relatbIdspan").innerHTML = "";
		}
      }
   });
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
        if( id[1]=="<%=labelService.getLabelNameByKeyId("402881e90c63546b010c638e0ea0002f") %>") {//文档
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


