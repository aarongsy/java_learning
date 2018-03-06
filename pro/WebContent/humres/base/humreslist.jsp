<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>
<%
boolean useRTX=false;
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
Setitem rtxSet=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
if(rtxSet!=null&&"1".equals(rtxSet.getItemvalue())){
	useRTX=true;
}
Humres humres = new Humres();
Page pageObject = (Page) request.getAttribute("pageObject");
String userid = currentuser.getId();
String tablename = "humres";
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
HumreslinkService humreslinkService = (HumreslinkService) BaseContext.getBean("humreslinkService"); 
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService"); 
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
List resultOptions = searchcustomizeService.getSearchResult(userid,tablename);
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");

if (pageObject == null) { 
	response.sendRedirect("/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=search");
}
%>
<%
String clear=StringHelper.null2String(request.getParameter("clear"));
String objname="";
String objno="";
String gender="";
String orgunitid="";//部门
String checkbox="";
if(clear.equals("true")){
     request.getSession().setAttribute("humresFilter",null);
}
Map humresFilter = (Map)request.getSession().getAttribute("humresFilter");
if(humresFilter!=null){
	if (humresFilter.get("objno")!=null) objno = (String)humresFilter.get("objno");
	if (humresFilter.get("objname")!=null) objname = (String)humresFilter.get("objname");
	if (humresFilter.get("gender")!=null) gender = (String)humresFilter.get("gender");
	if (humresFilter.get("orgunitid")!=null) orgunitid = (String)humresFilter.get("orgunitid");
	if (humresFilter.get("checkbox")!=null) checkbox = (String)humresFilter.get("checkbox");
}

 %>


<html>
  <head>
  	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
  </head>
  
  <body>
<%
pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";
 %>  

<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=search&from=list" name="EweaverForm" method="post">
<table>
	<colgroup> 
		     <col width="10%">
		     <col width="10%">
		     <col width="10%">
		     <col width="10%">
	</colgroup>	

		        <tr>
					<td class="Line" colspan=100% nowrap>
					</td>		        	  
		        </tr>		        
				<tr>

					<td class="FieldName" nowrap>
					    <%=labelService.getLabelName("402881e70b7728ca010b7730905d000b")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=100%" name="objname" value="<%=objname%>"/>
					</td>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e70b7728ca010b773ff0b0000c")%>
					</td>
					<td class="FieldValue">
						<SELECT name="gender" size="1">
						   <OPTION VALUE=""></OPTION>
						   <OPTION <% if(gender.equals("402881ea0b198b1f010b1a1bfd9a0004")){%>  selected <%}%> VALUE="402881ea0b198b1f010b1a1bfd9a0004"><%=labelService.getLabelName("402881ea0b198b1f010b1a1bfd9a0004")%></OPTION>

						   <OPTION <% if(gender.equals("402881ea0b198b1f010b1a1c3e760005")){%>  selected <%}%> VALUE="402881ea0b198b1f010b1a1c3e760005"><%=labelService.getLabelName("402881ea0b198b1f010b1a1c3e760005")%></OPTION>
<%		
  String orgName = "";	
  Orgunit orgunit=null;
  if(!StringHelper.isEmpty(orgunitid))		      			     				      
 		 orgunit = orgunitService.getOrgunit(orgunitid);
  if (orgunit!=null) 
  		orgName = StringHelper.null2String(orgunit.getObjname());			      
%>
						</SELECT>
					</td>
					<td class="FieldName" nowrap>
					   <%=labelService.getLabelName("402881e70b7728ca010b7740c7e1000d")%>

					</td>
					<td class="FieldValue">    
					    <button  type="button" class=Browser onclick="javascript:getBrowser('/base/orgunit/orgunitbrowser.jsp','orgunitid','orgunitidspan','0');"></button>
						<input type="hidden"  name="orgunitid" value="<%=orgunitid%>"/>
						<span id="orgunitidspan"/><%=orgName%></span>
						<input  type="checkbox" name='checkbox' value="1" <% if(checkbox.equals("1")){ %> checked <%}%> >
					</td>
				</tr>	
				        	
</table>

	   <table>
			
			<tr class="Header">

				<% 
				Iterator it = resultOptions.iterator();
				String showname = "";
				while(it.hasNext()){
					Searchcustomizeoption searchcustomizeoption = (Searchcustomizeoption) it.next();
					showname = StringHelper.null2String(searchcustomizeoption.getShowname());
					if(searchcustomizeoption.getLabelid() != null)
					   	showname = labelService.getLabelName(searchcustomizeoption.getLabelid());
					   
				%>
					<td nowrap><%=showname%>&nbsp</td>	<!--显示字段名  -->
				<%
				}
				%>
					
			</tr>	

<%			
if(pageObject.getTotalSize()!=0){
		boolean isLight=false;
		String trclassname="";
		int fieldid;
		String fieldvalue="";
			
		List list = (List) pageObject.getResult();
		for (int i = 0; i < list.size(); i++) {
			humres = (Humres) list.get(i);
			isLight=!isLight;					
			if(isLight) trclassname="DataLight";
				else trclassname="DataDark";
%>
				 
			<tr class="<%=trclassname%>">  
				    <%
				      Iterator Options = resultOptions.iterator();
				      while (Options.hasNext()) {
					        Searchcustomizeoption searchoption = (Searchcustomizeoption) Options.next();
					        fieldid = searchoption.getFieldid().intValue();
					       switch(fieldid){
					       	case 1001:
					       				fieldvalue=StringHelper.null2String(humres.getObjno());
					       			break;
					       	case 1002:
					       		if(useRTX){
					       				fieldvalue="<a href='"+request.getContextPath()+"/humres/base/humresview.jsp?id="+humres.getId()+"'>"+StringHelper.null2String(humres.getObjname())+"</a>"
					       				+"&nbsp;<img align=\"absbottom\" width=16 height=16 src=\"/rtx/images/blank.gif\" onload=\"RAP('"+humres.getRtxNo()+"');\">";
					       		}else{
					       			fieldvalue="<a href='"+request.getContextPath()+"/humres/base/humresview.jsp?id="+humres.getId()+"'>"+StringHelper.null2String(humres.getObjname())+"</a>";
					       			
					       		}
					       		if(BaseContext.getOnlineuserids().indexOf(humres.getId())!=-1){
					       				fieldvalue += "";
					       			}
					       			break;
					       	case 1003:
					       				fieldvalue=labelService.getLabelName(humres.getGender());
					       			break;
					       	case 1004:
					       				fieldvalue=StringHelper.null2String(humres.getStation());
					       			if(!fieldvalue.equals("")) {
					       					
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(fieldvalue);
				   fieldvalue = StringHelper.null2String(stationinfo.getObjname());
					       			}
					       			break;
					       	case 1005:
					       				fieldvalue=StringHelper.null2String(humres.getDuty());
					       			break;
					       	case 1006:
					       				fieldvalue=StringHelper.null2String(humres.getWorkaddr());
					       			break;
					       	case 1007:
					       				fieldvalue=StringHelper.null2String(humres.getOfficeaddr());
					       			break;
					       	case 1008:
					       				fieldvalue=StringHelper.null2String(humres.getHrstatus());
					       			if(!fieldvalue.equals("")) 
					       					fieldvalue=selectitemService.getSelectitemById(fieldvalue).getObjname();
					       			break;
					       	case 1009:
					       				fieldvalue=StringHelper.null2String(humres.getWorkstatus());
					       			if(!fieldvalue.equals("")) 
					       					fieldvalue=selectitemService.getSelectitemById(fieldvalue).getObjname();
					       			break;
					       	case 1010:
					       				fieldvalue=StringHelper.null2String(humres.getTel1());
					       			break;
					       	case 1011:
					       				fieldvalue=StringHelper.null2String(humres.getTel2());
					       			break;
					       	case 1012:
					       				fieldvalue=StringHelper.null2String(humres.getTel3());
					       			break;
					       	case 1013:
					       				fieldvalue=StringHelper.null2String(humres.getFax());
					       			break;
					       	case 1014:
					       				fieldvalue=StringHelper.null2String(humres.getEmail());
					       			break;
					       	case 1015:
					       				fieldvalue=StringHelper.null2String(humres.getSeclevel());
					       			break;
					       	case 1016:
					       				fieldvalue=StringHelper.null2String(humres.getSeclevel());
									    orgunitid =  StringHelper.null2String(humres.getOrgid());					      
									    orgunit =  orgunitService.getOrgunit(orgunitid);
									    fieldvalue = "";
									    if (orgunit!= null)		      
									      fieldvalue=orgunit.getObjname();					       				
					       			break;
					       	case 1017:
									    String pid = "";
									    String pidname = "";
									    List humreslinkList =  humreslinkService.getAllHumreslinkByHumresid(humres.getId());
									    if(humreslinkList != null && humreslinkList.size()>0 ){
										      Humreslink humreslink = (Humreslink)humreslinkList.get(0);
										      pid = humreslink.getPid();
										      pidname = humresService.getHumresById(pid).getObjname();
									    }
									    fieldvalue="<a href='"+request.getContextPath()+"/humres/base/humresview.jsp?id="+pid+"'>"+pidname+"</a>";
					       			break;
								default:break;
							}	//end switch			        			        
				    %>
				     <td nowrap><%=StringHelper.null2String(fieldvalue)%></td>	<!--显示字段值 --> 
				    <%
                      }  //end while 		    
				    %>

			</tr>
<%
		}  //end for
}  //end if
%>				
       </table>
       <br>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td nowrap align=center>						
						<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
						&nbsp;
					</td>

					<td nowrap align=center>
						<button  type="button" accessKey="F" onclick="onSearch(1)">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>)">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>)">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>)">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:document.EweaverForm.submit();">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.EweaverForm.submit();">
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>       
    </form>
<script language="javascript" type="text/javascript">
    function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
   	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=search&from=list";
	document.EweaverForm.submit();
   }    
function onSearch2(){
	document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=search";
	document.EweaverForm.submit();
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
</script>

  </body>
</html>
