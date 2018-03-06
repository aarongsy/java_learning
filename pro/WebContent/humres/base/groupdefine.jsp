<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%
String sysrole=StringHelper.null2String(request.getParameter("sysrole"));
String orgunitid=StringHelper.null2String(request.getParameter("orgunitid"));
String checkbox=StringHelper.null2String(request.getParameter("checkbox"));  
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
HumrescustomizeService humrescustomizeService = (HumrescustomizeService) BaseContext.getBean("humrescustomizeService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem = null; 
   
String userid = currentuser.getId();
int maxselected = 100;

String humresidslimited = StringHelper.null2String(request.getParameter("humresidslimited"));	//限定选择范围(?,?,?)　调用browser时传入


String humresidsin = StringHelper.null2String(request.getParameter("humresidsin"));	//已选中id(?,?,?)　调用browser时传入


String humresidsselected = StringHelper.null2String(request.getAttribute("humresidsselected"));	//已选中id(?,?,?)　搜索后传回


if(!humresidsin.equals("")){
	humresidsselected = humresidsin;
}

if(humresidsselected.equals("0"))
	humresidsselected = "";

String humresnamesselected = "";	//已选中名称(?,?,?)
if(!humresidsselected.equals("")){
	List humresidsArrayList=StringHelper.string2ArrayList(humresidsselected,",");
	for(int i=0;i<humresidsArrayList.size();i++){
		humresnamesselected += "," + ((Humres)humresService.getHumresById(""+humresidsArrayList.get(i))).getObjname();
	}
}

 orgunitid = "";				      		      
List humresList = (List)request.getAttribute("humresList") ;

if(humresList==null){
	if(!humresidslimited.equals("")){	
			      		      
		response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=groupdefine&sysrole="+sysrole+"&orgunitid="+orgunitid+"&humresidslimited="+humresidslimited);
		return;
	}
		
	orgunitid =humresService.getHumresById(userid).getOrgid();				      		      
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=groupdefine&sysrole="+sysrole+"&humresidsselected="+humresidsselected+"&orgunitid="+orgunitid);
	return;
}

//搜索条件
String objname = "";
String gender = "";
String hrstatus = "";
orgunitid ="";
String workstatus = "";
 sysrole="";
Map humresFilter = (Map)request.getAttribute("humresFilter");
if (humresFilter.get("orgid")!=null) orgunitid = (String)humresFilter.get("orgid");
if (humresFilter.get("objname")!=null) objname = (String)humresFilter.get("objname");
if (humresFilter.get("gender")!=null) gender = (String)humresFilter.get("gender");
if (humresFilter.get("hrstatus")!=null) hrstatus = (String)humresFilter.get("hrstatus");
if (humresFilter.get("workstatus")!=null) workstatus = (String)humresFilter.get("workstatus");
if (humresFilter.get("sysrole")!=null) sysrole = (String)humresFilter.get("sysrole");
%>



<html>
  <head>
    <script src='<%=request.getContextPath()%>/dwr/interface/HumrescustomizeService.js'></script>
  	<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
  </head>
  
  <body>    
          
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSubmit()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
     
   <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=groupdefine" name="EweaverForm"  method="post">
   
   <input type="hidden" name="humresidslimited" value="<%=StringHelper.null2String(request.getAttribute("humresidslimited"))%>"/>
   <input class=inputstyle type="hidden" name="humresidsselected" value="<%=humresidsselected%>">
   <input class=inputstyle type="hidden" name="humresnamesselected" value="<%=humresnamesselected%>">
   <input class=inputstyle type="hidden" name="userid" value="<%=userid%>">
   <input class=inputstyle type="hidden" name="customizegroupname" >
   <input class=inputstyle type="hidden" name="resourcegroup" >
   
     <TABLE ID=searchTable> 
         <tr>
		 <td class="FieldName" width=10% nowrap>
			   <%=labelService.getLabelName("402881e70b7728ca010b7730905d000b")%> 
		 </td>
		 <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="objname" value="<%=objname%>"/>
		 </td>
		 <td class="FieldName" nowrap>
			   <%=labelService.getLabelName("402881e70b7728ca010b773ff0b0000c")%>
		 </td>
		 <td class="FieldValue">
			  <SELECT name="gender" size="1">
			    <OPTION VALUE="">
				<OPTION VALUE="402881ea0b198b1f010b1a1bfd9a0004" <%if (gender.equals("402881ea0b198b1f010b1a1bfd9a0004")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ea0b198b1f010b1a1bfd9a0004")%>

				<OPTION VALUE="402881ea0b198b1f010b1a1c3e760005" <%if (gender.equals("402881ea0b198b1f010b1a1c3e760005")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ea0b198b1f010b1a1c3e760005")%>

			  </SELECT>
		 </td>	
		 <td class="FieldName" width=10% nowrap>
			<%=labelService.getLabelName("402881e70b7728ca010b774446360011")%> 
		 </td>
		   <%
		    String hrName = selectitemService.getSelectitemNameById(hrstatus);
		   %>
		 <td class="FieldValue">
			  <button type="button"  class=Browser onclick="javascript:getBrowser('/base/selectitem/selectitembrowser.jsp?typeid=402881ea0b1c751a010b1ccf7dbe0002','hrstatus','hrstatusspan','0');"></button>
		      <input type="hidden"  name="hrstatus" value="<%=hrstatus%>"/>
			  <span id = "hrstatusspan"><%=hrName%></span>
		 </td>									
       </tr> 
       <tr>
		 <td class="FieldName" width=10% nowrap>
			  <%=labelService.getLabelName("402881e70b7728ca010b7740c7e1000d")%>
		 </td>
		<%
		   String oName = orgunitService.getOrgunitName(orgunitid);
		 %>
		 <td class="FieldValue">    
			  <button type="button"  class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','0');"></button>
			  <input type="hidden"  name="orgunitid" value="<%=orgunitid%>"/>
			  <span id="orgunitidspan"/><%=oName%></span>
			  <input  type="checkbox" <% if(checkbox.equals("1")){%> checked <%}%>  name='checkbox' value="1" >
		 </td>                  
 		 <td class="FieldName" width="10%" nowrap>
			 <%=labelService.getLabelName("402881eb0bcd354e010bcd53bab5000c")%>
		 </td>                  
         <td class="FieldValue">
		      <select class="inputstyle" id="groupid" name="groupid" width="90%" onChange="doSearch()">
				         <option value=""></option>
				         <% 
				           
				           List list = humrescustomizeService.getAllHumrescustomize(userid);  
				           Iterator it = list.iterator();
				           while (it.hasNext()) {
				             Humrescustomize humrescustomize = null;
				             humrescustomize =  (Humrescustomize)it.next();
				             String  humrescustomizeid = humrescustomize.getId();
				         %>
			            <option value=<%=humrescustomizeid%>>
			           <%=humrescustomize.getGroupname()%></option>
			           <% } %>
		       </select>
         </td>
		 <td class="FieldName" width=10% nowrap>
			   <%=labelService.getLabelNameByKeyId("402881e70b7728ca010b7744e68f0012")%><!-- 角色 --> 
		 </td>
		 <%
		   String workName = selectitemService.getSelectitemNameById(workstatus);
		 %>
		 <td class="FieldValue">
			  <button  type="button" class=Browser onclick="javascript:getBrowser('/base/selectitem/selectitembrowser.jsp?typeid=402881ea0b198b1f010b19ff244c0002','workstatus','workstatusspan','0');"></button>
			  <input type="hidden"  name="workstatus" value="<%=workstatus%>"/>
			  <span id = "workstatusspan"><%=workName%></span>
		 </td>    
                </tr>
	    <tr>
	    	 <td class="FieldName" width=10% nowrap>
	    	 <%=labelService.getLabelNameByKeyId("402881ea0bfa67d7010bfa68fe0b0005") %>
	    	 </td>
<%
Sysrole sysroleobj=new Sysrole();
if(!StringHelper.isEmpty(sysrole))
sysroleobj=sysroleService.get(sysrole);
String sysrolename=StringHelper.null2String(sysroleobj.getRolename());
%>
	    	 <td class="FieldValue">
	    	 	<button  type="button" class=Browser onclick="javascript:getBrowser('/base/security/sysrole/sysrolebrowser.jsp?typeid=402881ea0b198b1f010b19ff244c0002','sysrole','sysrolespan','0');"></button>
			  	<input type="hidden"  name="sysrole" value="<%=sysrole%>"/>
			  	<span id = "sysrolespan"><%=sysrolename%></span>
	    	 </td>
	    	 <td class="FieldName" width=10% nowrap>
	    	 </td>
	    	 <td class="FieldValue">
	    	 </td>
	    	 <td class="FieldName" width=10% nowrap>
	    	 </td>
	    	 <td class="FieldValue">
	    	 </td>
	    </tr>  
	</TABLE>
<TABLE>
<tr width="100%">
<td width="60%" valign=top>
	<div style="overflow-y:scroll;width:100%;height:380px">
	<TABLE  ID=BrowserTable class=BrowserStyle>
			<TR  class=Header>
				  <TH width="0%" style="display:none">id</TH>
				  <TH><%=labelService.getLabelName("402881e70b7728ca010b7730905d000b")%></TH>
				  <TH><%=labelService.getLabelName("402881e70b7728ca010b773ff0b0000c")%></TH>
				  <TH><%=labelService.getLabelName("402881eb0bcd354e010bcd5a897c000d")%></TH>
				  <TH><%=labelService.getLabelNameByKeyId("402881e510e569090110e56e72330003")%></TH><!-- 岗位 -->
			</TR>
				  <%
				    if (humresList!=null && humresList.size()>0) {
				       boolean isLight=false;
			           String trclassname="";
				       for (int i=0;i<humresList.size();i++){
				         Humres humres = (Humres)humresList.get(i);
				         isLight=!isLight;
					     if(isLight) trclassname="DataLight";
					     else trclassname="DataDark";
				  %>


				 <tr class="<%=trclassname%>">
	                <td width="0%" style="display:none">					    
					    <%=humres.getId()%>
					</td>
					<td nowrap>
					 	<%=humres.getObjname()%>
					</td>	
					<td nowrap>
					 	<%=labelService.getLabelName(humres.getGender())%>
					</td>				
					<td nowrap>
					 <%
					   String orgunitName ="";
 					   // Orgunit orgunit = orgunitService.getOrgunit(humresorg.getOrgunitid()) ;
 					  //  if (orgunit!=null)
 					      orgunitName = StringHelper.null2String(orgunitService.getOrgunitName(humres.getOrgid()));
 					 %>  
					 <%=orgunitName%>
					</td>	
					<td nowrap>
					<%
				 String station = "";
				 if(!StringHelper.isEmpty(humres.getStation())){
				   selectitem = selectitemService.getSelectitemById(humres.getStation());
				   station = StringHelper.null2String(selectitem.getObjname());
				 }
				 %>	
				 <%=station%>
					</td>
				</tr> 
           		<%}
	         	}
		       %>	
	</TABLE>
	</div>
</td>
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%" class=noborder>
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="<%=request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd696920f0004")%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="<%=request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>"onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="<%=request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
				<br>
				<br>
				<button type="button" onclick="javascript:addGroup();">
                  <%=labelService.getLabelName("402881eb0bcd354e010bcd5f4472000e")%>

               </button>
               <br>
               <button type="button" onclick="javascript:deleteGroup();">
                  <%=labelService.getLabelName("402881eb0bcd354e010bcd5fc06a000f")%>

               </button>
			</td>
			<td align="center" valign="top" width="70%">
				<select size="20" name="srcList" multiple="true" style="width:100%" class="InputStyle">

					  <!-- option value="1"></option-->
					
				</select>
			</td>
		</tr>

      </table>

</td>
</tr>
</table> 
    </form>
<script>
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
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
<script language="javascript"> 
  var resourceArray = new Array();
  
  function onSubmit(){
  	setResourceStr();
  	document.all("humresidsselected").value=humresidsselected;
  	document.all("humresnamesselected").value=humresnamesselected;
    document.EweaverForm.submit();
  }   
  
  function addAllToList(){
	var table =document.all("BrowserTable");
	//alert(table.rows.length);
	for(var i=1;i<table.rows.length;i++){
		var str = table.rows(i).cells(0).innerText+"~"+table.rows(i).cells(1).innerText ;
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect(document.all("srcList"),str);
	}
	reloadResourceArray();
}
function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
} 

function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	oOption.innerText = str.split("~")[1];
	
	
}


function deleteAllFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}

//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllist(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}


function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}

function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}

function setResourceStr(){
	humresidsselected ="";
	humresnamesselected = "";
	for(var i=0;i<resourceArray.length;i++){
		humresidsselected += ","+resourceArray[i].split("~")[0] ;
		humresnamesselected += ","+resourceArray[i].split("~")[1] ;
	}
	humresidsselected = humresidsselected.substring(1,humresidsselected.length);
	humresnamesselected = humresnamesselected.substring(1,humresnamesselected.length);
}


function addGroup(){
	var resourcegroup = "";
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourcegroup += "," + destList.options[i].value+"~"+destList.options[i].text ;
	}
	if(resourcegroup == "") return;
	resourcegroup = resourcegroup.substring(1);
	var vDetail = prompt("<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050000")%>","");// 请输入自定义组名称 ！
	if(vDetail!=null){
		document.EweaverForm.customizegroupname.value = vDetail;
		document.EweaverForm.resourcegroup.value = resourcegroup;
		document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=savegroup1"
		document.EweaverForm.submit();
	}
}
function deleteGroup(){
 if (document.all("groupid").value != "" && document.all("groupid").value != null){
 document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=deletegroup1"
 document.EweaverForm.submit(); 
 }
}

function doSearch()
{ 
         
  HumrescustomizeService.getHumrescustomizeById(getHumrescustomize,document.all("groupid").value);
}

function getHumrescustomize(Humrescustomize){
  if (Humrescustomize==null) return;
  var humresList = Humrescustomize.includevalues;
  var humresArray = new Array();
  humresArray = humresList.split(",");
  deleteAllist(); 
  for (i=0;i<humresArray.length;i++){
  addObjectToSelect(document.all("srcList"),humresArray[i]);  
  }
  
}

</script> 
<script language="javascript" for="BrowserTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.all("srcList"),newEntry);
			reloadResourceArray();
		}
	}
</script>

<!--载入已选中值 -->
<script language="javascript"> 
<%
if(!humresidsselected.equals("")){

	List _idsList=StringHelper.string2ArrayList(humresidsselected,",");
	List _namesList=StringHelper.string2ArrayList(humresnamesselected,",");

	for(int i=0;i<_idsList.size();i++){
		String _idsnames = _idsList.get(i)+"~"+_namesList.get(i);
%>
		var newEntry = "<%=_idsnames%>" ;
		addObjectToSelect(document.all("srcList"),newEntry);
		reloadResourceArray();	
<%		
	}	
}
%>
</script>
  </body>
</html>







