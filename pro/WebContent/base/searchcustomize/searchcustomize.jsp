<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeoptionService"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>

<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<HTML>
	<HEAD>
	</HEAD>
	<BODY>
		<%
        response.setHeader("cache-control", "no-cache");
        response.setHeader("pragma", "no-cache");
        response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
      String tablename = request.getParameter("tablename");  

      String contemplateid = request.getParameter("contemplateid");
      String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
      SearchcustomizeoptionService searchcustomizeoptionService = (SearchcustomizeoptionService) BaseContext.getBean("searchcustomizeoptionService");
      SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
       
     // List fieldList = searchcustomizeoptionService.getSearchcustomizeoptionByTablename(tablename);
     // Iterator it = fieldList.iterator();
      
      String reportid = request.getParameter("reportid"); 
      ReportfieldService reportfieldService = (ReportfieldService) BaseContext.getBean("reportfieldService");
      List fieldList = reportfieldService.getReportfieldListByReportID(reportid);
      Iterator it = fieldList.iterator();
    %>

<!--页面菜单开始-->     
<%
String sysmodel = request.getParameter("sysmodel");

pagemenustr += "{S,"+labelService.getLabelName("402881ea0bfa7679010bfa963f300023")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:back('"+ reportid +"')}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

		<FORM action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.searchcustomize.servlet.SearchcustomizeAction?action=create&sysmodel=<%=sysmodel%>" name="EweaverForm" method="post">
			<INPUT type="hidden" name="reportid" value="<%=reportid%>">
			<INPUT type="hidden" name="contemplateid" value="<%=contemplateid%>">
			<input class=inputstyle type="hidden" name="resourceids" id="resourceids" value="">

			<TABLE>
				<TR width="100%">
					<!--########Browser Table Start########-->
					<TD width="60%">

						<TABLE ID="BrowserTable" cellpadding="1" class="BroswerStyle" cellspacing="0" STYLE="margin-top:0" align="left">
							<TR class="Header">
								<TH width="0%" style="display:none">
									id
								</TH>
								<TH width="50%">
									<%=labelService.getLabelName("402881e70b7728ca010b7730905d000b  ")%>		
								</TH>
							</TR>

							<TR>
								<TD colspan="5" width="100%">
									<DIV style="overflow-y:scroll;width:100%;height:350px">
										<TABLE width="100%" id="BrowseTable">
											<%
				    if (fieldList!=null && fieldList.size()!=0) {
				       boolean isLight=false;
			           String trclassname="";
				       for (int i=0;i<fieldList.size();i++){
				         Reportfield reportfield = (Reportfield)fieldList.get(i);
				         isLight=!isLight;
					     if(isLight) trclassname="DataLight";
					     else trclassname="DataDark";
				  %>
											<TR class="<%=trclassname%>">
												<TD width="0%" style="display:none">
													<%=reportfield.getId()%>
												</TD>
												<TD width="50%" nowrap onclick="clickAddfield(this)" onmouseover="mouseover(this)" onmouseout="mouseout(this)">
													<%=reportfield.getShowname()%>
												</TD>

											</TR>
											<%}
	         	}
		       %>
										</TABLE>
									</DIV>
								</TD>
							</TR>
						</TABLE>
					</TD>
					<!--########Browser Table end########-->
					<!--########Select Table Start########-->
					<TD width="40%" valign="top">
						<TABLE cellspacing="1" align="left" width="100%">
							<TR>
								<TD align="center" valign="top" width="30%">
									<IMG src="<%=request.getContextPath()%>/images/base/arrow_u.gif" style="cursor:hand" title="上移" onclick="javascript:upFromList();" alt="">
									<BR>
									<BR>
									<IMG src="<%=request.getContextPath()%>/images/base/arrow_all.gif" style="cursor:hand" title="全部增加" onClick="javascript:addAllToList()" alt="">
									<BR>
									<BR>
									<IMG src="<%=request.getContextPath()%>/images/base/arrow_out.gif" style="cursor:hand" title="删除" onclick="javascript:deleteFromList();" alt="">
									<BR>
									<BR>
									<IMG src="<%=request.getContextPath()%>/images/base/arrow_all_out.gif" style="cursor:hand" title="全部删除" onclick="javascript:deleteAllFromList();" alt="">
									<BR>
									<BR>
									<IMG src="<%=request.getContextPath()%>/images/base/arrow_d.gif" style="cursor:hand" title="下移" onclick="javascript:downFromList();" alt="">
								</TD>
								<TD align="center" valign="top" width="70%">
									<SELECT size="15" name="srcList" id="srcList" multiple="true" style="width:100%" class="InputStyle">
                                        <%
                                        //  List customizeList = searchcustomizeService.getAllSearchcustomizeByHql(userid,tablename);
                                        List customizeList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
                                          if (customizeList!=null && customizeList.size()>0){ 
                                            Reportfield reportfield = null;
                                            Iterator cit = customizeList.iterator();
                                            while (cit.hasNext()){
                                            	reportfield = (Reportfield) cit.next();
                                              
                                          
                                        %> 
										  <option value=<%=reportfield.getId() %>> 
									    	  <%=reportfield.getShowname() %>
										  </option>
                                        <%
                                           } //end while
                                         }//end if
                                        %>
									</SELECT>
								</TD>
							</TR>
						</TABLE>


					</TD>
					<!--########Select Table end########-->
				</TR>
			</TABLE>
		</FORM>
<script language="javascript"> 

  var resourceArray = new Array();    

<%
	List customizeList1 = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
   if (customizeList1!=null && customizeList1.size()>0){ 
	  
	   Reportfield reportfield = null;
       Iterator cit = customizeList1.iterator();
       while (cit.hasNext()){
       	reportfield = (Reportfield) cit.next();
	   %>
	   
	   var resource = document.getElementById("resourceids").value;
	   if(resource != ""){
	   		resource = resource+ "~" + "<%=reportfield.getId()%>";
	   }else{
	   		resource = "<%=reportfield.getId()%>";
	   }
	   
	   document.getElementById("resourceids").value = resource;
						  
   <%
     } //end while
      
   }//end if
  %> 
  
  function back(reportid){
  		location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&sysmodel=<%=sysmodel%>&isformbase=<%=isformbase%>&reportid="+reportid;
  }
  
  function addAllToList(){
	var table =document.getElementById("BrowseTable");
	
	for(var i=0;i<table.rows.length;i++){
		var str = table.rows[i].cells[0].innerHTML.trim()+"~"+table.rows[i].cells[1].innerHTML.trim() ;
		if(!isExistEntry(str,document.getElementById("srcList")))
			addObjectToSelect(document.getElementById("srcList"),str);
	}
	reloadResourceArray();
}

function isExistEntry(entry,destList){
	if (destList == null || destList.options == null) return false; 
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if (entry.indexOf(destList.options[i].value) > -1)
			return true;
	}
	return false;
}
function isExistEntry1(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
} 
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.getElementById("srcList");
	document.getElementById("resourceids").value =""; 
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
		if (document.getElementById("resourceids").value != ""){
			document.getElementById("resourceids").value = document.getElementById("resourceids").value +"~" +destList.options[i].value;
		}else{
			document.getElementById("resourceids").value = destList.options[i].value;
		}
	}
	//alert(resourceArray.length);
}

function upFromList(){
	var destList  = document.getElementById("srcList");
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

function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	oOption.innerHTML = str.split("~")[1];
	
	
}
function deleteFromList(){
	var destList  = document.getElementById("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}

function deleteAllFromList(){
	var destList  = document.getElementById("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}


function upFromList(){
	var destList  = document.getElementById("srcList");
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
	var destList  = document.getElementById("srcList");
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

  function onSubmit(){
	alert('<%=labelService.getLabelName("402881aa0eea0265010eea674c7a011d")%>');
    document.EweaverForm.submit();
  } 

  function clickAddfield(e) {
	  var e =  navigator.appName == "Netscape" ? e : window.event.srcElement;
		if(e.tagName == "TD"){
			var newEntry = e.parentElement.cells[0].innerHTML.trim()+"~"+e.parentElement.cells[1].innerHTML.trim();
			if(!isExistEntry(newEntry,document.getElementById("srcList"))){
				addObjectToSelect(document.getElementById("srcList"),newEntry);
				reloadResourceArray();
			}
		}
  }

  function mouseover(e) {
	  var e =  navigator.appName == "Netscape" ? e : window.event.srcElement;
	  if(e.tagName == "TD") {
		  e.parentElement.className = "Selected";
	  }
  }

  function mouseout(e) {
	  var e =  navigator.appName == "Netscape" ? e : window.event.srcElement;
	  if(e.tagName == "TD"){
		  e.parentElement.className = "DataLight";
	  }
  }

</script>
<!-- script language="javascript" for="BrowseTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,document.all("srcList"))){
			addObjectToSelect(document.all("srcList"),newEntry);
			reloadResourceArray();
		}
	}
</script -->
<!-- script language=vbs>

Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub

Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub


</script -->
	</BODY>
</HTML>
