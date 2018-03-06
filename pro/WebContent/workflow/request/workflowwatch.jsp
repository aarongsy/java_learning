<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.net.URLEncoder"%>
<%
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
Selectitem selectitem;
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
RequestlogService requestlogService = (RequestlogService) BaseContext.getBean("requestlogService");
NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
String action = StringHelper.null2String(request.getParameter("action"));
String userid = eweaveruser.getId();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");
String tablename = "requestbase";
SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
List resultOptions = searchcustomizeService.getSearchResult(userid,tablename);
Page pageObject = (Page) request.getAttribute("pageObject");
StringBuffer hql = new StringBuffer(
		"from Requestbase rb where rb.id in ");
hql
		.append(
				"(select wo.requestid from Requeststatus wi , Requestoperators wo where wi.curstepid=wo.stepid ")
		.append("and  (wi.isreceived=0 or wi.issubmited=0) ").append(
				"and wi.ispaused=0 and  wo.userid='").append(
				userid).append("')");
if (pageObject == null) {
	pageObject = requestbaseService.getPagedByQuery(hql.toString(),1,20);
}

String targeturl = URLEncoder.encode(request.getContextPath()+"/base/blank.jsp?isclose=1","UTF-8");
%>
<%

String clear="";
clear=StringHelper.null2String(request.getParameter("clear"));
String requestname="";
String workflowid="";
String isfinished="";
String isdelete="";
String creator="";
String createdatefrom="";
String createdateto="";
String requestlevel="";
if(clear.equals("true")){
     request.getSession().setAttribute("requestbaseFilter",null);
}
Map requestbaseFilter = (Map)request.getSession().getAttribute("requestbaseFilter");
if(requestbaseFilter!=null){
	if (requestbaseFilter.get("requestname")!=null) requestname = (String)requestbaseFilter.get("requestname");
	if (requestbaseFilter.get("workflowid")!=null) workflowid = (String)requestbaseFilter.get("workflowid");
	if (requestbaseFilter.get("isfinished")!=null) isfinished = ""+requestbaseFilter.get("isfinished");
	if (requestbaseFilter.get("isdelete")!=null) isdelete = ""+requestbaseFilter.get("isdelete");
	if (requestbaseFilter.get("creater")!=null) creator = (String)requestbaseFilter.get("creater");
	if (requestbaseFilter.get("createdatefrom")!=null) createdatefrom = (String)requestbaseFilter.get("createdatefrom");
	if (requestbaseFilter.get("createdateto")!=null) createdateto = (String)requestbaseFilter.get("createdateto");
	if (requestbaseFilter.get("requestlevel")!=null) requestlevel = (String)requestbaseFilter.get("requestlevel");
}
%>
<html>
  <head>
    <script language="JScript.Encode" src="/js/rtxint.js"></script>
	<script language="JScript.Encode" src="/js/browinfo.js"></script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('/images/book.gif'); margin-bottom: 4}
</Style>
  </head> 
  <body>
<%

pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";
//pagemenustr += "{S,"+labelService.getLabelName("40288184119b6f4601119c3cdd77002d")+",javascript:onSearch3()}";//高级搜索
pagemenustr += "{D,删除,javascript:onDelete()}";//删除
pagemenustr += "{R,永久删除,javascript:onRemove()}";//永久删除

 %>

<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
 	<form action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=watch&from=list" name="EweaverForm" method="post">
 	<input type="hidden" name="operation" />
<table>
	<colgroup> 
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">
	</colgroup>	

        <tr>
			<td class="Line" colspan=4 nowrap>
			</td>		        	  
        </tr>
     <tr>
       <td class="FieldName" nowrap><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></td>
       <td class="FieldValue"><input name="requestname" value="<%=requestname%>" class="InputStyle2" style="width=95%" ></td>
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%></td><!--流程类型 -->
<%
String workflowname="";
if(!StringHelper.isEmpty("workflowid")){
	workflowname=StringHelper.null2String(workflowinfoService.get(workflowid).getObjname());
}
%>
       <td class="FieldValue">
       		<input type="hidden" name="workflowid" value="<%=workflowid%>"/>			
          	<button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','workflowid','workflowidspan','0');"></button>
            <span id="workflowidspan"><%=workflowname%></span>
       </td>
     </tr>
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
       		<td class="FieldValue">
       			<select name=isfinished><!-- isfinished-->
       				<option value="-1" <%if(isfinished.equals("-1")){%> selected <%}%> ></option> 
       				<option value="1" <%if(isfinished.equals("1")||StringHelper.isEmpty(isfinished)){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option> 
       				<option value="0" <%if(isfinished.equals("0")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
       			</select> 
       		</td>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c7692e5360009")%></td>
       		<td class="FieldValue">
       			<select name=isdelete>
       				<option value="-1" <%if(isdelete.equals("-1")){%> selected <%}%> ></option> 
       				<option value=0 <%if(isdelete.equals("0")||StringHelper.isEmpty(isdelete)){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option> 
       				<option value=1 <%if(isdelete.equals("1")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
       			</select> 
       		</td>	
     </tr>
     <tr>
<% 
			Humres humres=null;
			String humresname="";
			if(!StringHelper.isEmpty(creator)){
				humres=humresService.getHumresById(creator);
			}
			if(humres!=null){
				humresname=StringHelper.null2String(humres.getObjname());
			}
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
	       	<span id=creatorspan><%=humresname%></span>
	       	<input type=hidden name=creator value="<%=creator%>"> 
	    </td>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<button type="button" class="Calendar" id=SelectDate  onclick="javascript:getdate('createdatefrom','createdatefromspan','0')"></button>&nbsp; 
       			<span id=createdatefromspan><%=createdatefrom%></span>-&nbsp;&nbsp;
       			<button type="button" class="Calendar" id=SelectDate2 onclick="javascript:getdate('createdateto','createdatetospan','0')"></button>&nbsp; 
       			<span id=createdatetospan><%=createdateto%></span>
       			<input type=hidden name="createdatefrom" value="<%=createdatefrom%>"> 
       			<input type=hidden name="createdateto" value="<%=createdateto%>">
       		</td>
	   </tr>
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("40288194108f9f7701108faa84db0004")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','curoperator','curoperatorspan','0');"></button>
	       	<span id=curoperatorspan></span>
	       	<input type=hidden name="curoperator" value=""> 
	    </td>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c76926bcf0007")%></td>
       		<td class="FieldValue">
       		
       			<select name=requestlevel>
       				<option value="" <%if(StringHelper.isEmpty(isdelete)){%> selected <%}%> ></option>
       				<option value="402881eb0c42cba0010c42ff38860008" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860008")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd74dcf010bd751b7610004")%></option> 
       				<option value="402881eb0c42cba0010c42ff38860009" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860009")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76ac26f80014")%></option>
       				<option value="402881eb0c42cba0010c42ff3886000a" <%if(requestlevel.equals("402881eb0c42cba0010c42ff3886000a")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76abd9740011")%></option> 
       			</select> 
       		</td>	
	   </tr>

    </table>
 	
 	<table border="0">
 	<tr class="Header">
 <td>
 	<input type="checkbox" onclick="checkAll()"/>
 </td>
				<% 
				if(resultOptions==null){
					resultOptions = new ArrayList();
				}
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
		String typename="";
		String objtypeid="";
		 humresname="";
		List list = (List) pageObject.getResult();
		Requestbase requestbase = null;
		for (int i = 0; i < list.size(); i++) {

			requestbase = (Requestbase) list.get(i);

			
			isLight=!isLight;					
			if(isLight) trclassname="DataLight";
				else trclassname="DataDark";
				
%>
<tr class="<%=trclassname%>">
<td>
	<input type="checkbox" name="wfid" value="<%=requestbase.getId() %>"/>
</td>
				    <%
				      Iterator Options = resultOptions.iterator();
				      String fieldvalue="";

				      while (Options.hasNext()) {
					        Searchcustomizeoption searchoption = (Searchcustomizeoption) Options.next();
				      		String curusertel="";
					        fieldid = searchoption.getFieldid().intValue();
					        
					       switch(fieldid){
                            case 2001:
					       				fieldvalue="<a href='"+request.getContextPath()+"/workflow/request/workflow.jsp?targeturl="+targeturl+"&requestid=" + requestbase.getId() + "' target='_blank'>"+StringHelper.null2String(requestbase.getRequestname())+"</a>";
					       			
					       		break;
					       	case 2002:
					       	            Workflowinfo workflowinfo = workflowinfoService.get(requestbase.getWorkflowid());
							            String workflowinfoname = "";
							            if(workflowinfo != null){
							            	workflowinfoname = workflowinfo.getObjname();
							            }
					       				fieldvalue=StringHelper.null2String(workflowinfoname);
					       			break;
					       	case 2003:
					       				selectitem = selectitemService.getSelectitemById(requestbase.getRequestlevel());
					       				fieldvalue=StringHelper.null2String(selectitem.getObjname());
					       			break;
					       	case 2004:
					       				//String creater = humresService.getHumresById(requestbase.getCreater()).getObjname();
					       				fieldvalue=humresService.getHumresHtml(requestbase.getCreater());
					       			break;

					       	case 2005:
					       				String createdatatime = requestbase.getCreatedate() + "&nbsp;" + requestbase.getCreatetime();
					       	            fieldvalue=StringHelper.null2String(createdatatime);
                                   break;
                            case 2006:
                            			String isfinish =labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c");//是
						            	if(requestbase.getIsfinished().toString().equals("0")){
						            		isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d");//否
						            	}
                                         fieldvalue=StringHelper.null2String(isfinish);
                                   break;
                            case 2007:
                            			String lastsubmitdatesql = "select * from (select operatedate,operatortime from requestlog where requestid='" +requestbase.getId()+ "' order by operatedate desc,operatortime desc) where rownum<=1 order by rownum asc";
                            			DataService dbservice = new DataService();
                            			Map m = (Map)dbservice.getValuesForMap(lastsubmitdatesql);
                            			String lastsubmitdate = (String)m.get("operatedate");
                            			String lastsubmittime = (String)m.get("operatortime");
                                       // fieldvalue=StringHelper.null2String(lastsubmitdate);
                                        fieldvalue=StringHelper.null2String(lastsubmitdate) + "&nbsp;" + lastsubmittime;
                                   break;     
                            case 2008:
                            			
                            			List nodelist = requestlogService.getCurrentNodeIds(requestbase.getId());
										Nodeinfo nodeinfo = new Nodeinfo();
										if (nodelist.size() > 0)
											nodeinfo = nodeinfoService.get((String) nodelist.get(0));
                            			
                                        fieldvalue=StringHelper.null2String(nodeinfo.getObjname());
                                   break;  
                            case 2009:
                            			
                            			List userlist = requestlogService.getCurrentNodeUsers(requestbase.getId());
										 humres = new Humres();
										if (userlist.size() > 0)
											humres = humresService.getHumresById((String) userlist.get(0));
                            			
                                        fieldvalue=StringHelper.null2String(humres.getObjname());
                                        curusertel = labelService.getLabelNameByKeyId("402881e70b7728ca010b7746fc6a0015")+"："+ StringHelper.null2String(humres.getTel1()) + "\n"+labelService.getLabelNameByKeyId("402881e70b7728ca010b7747b30f0016")+"：" + StringHelper.null2String(humres.getTel2());//办公室电话    移动电话
                                   break;              
                            default:
                                   break;


							}	//end switch			        			        
				    %>   
				     <td nowrap title="<%=curusertel %>"><%=fieldvalue%></td>	<!--显示字段值 --> 
				    <%
                      }  //end while 		    
				    %>
</tr>
<%
}}
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
	document.EweaverForm.submit();
}
function onSearch2(){
	document.EweaverForm.action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=watch";
	document.EweaverForm.submit();
}
function onSearch3(){
	document.EweaverForm.action="/workflow/request/requestbasesearch.jsp";
	document.EweaverForm.submit();
}
function onDelete(){
	document.EweaverForm.operation.value = "deleteWorkflow";
	document.EweaverForm.submit();
}
function onRemove(){
	document.EweaverForm.operation.value = "removeWorkflow";
	document.EweaverForm.submit();
}
function checkAll(){
	var o = event.srcElement;
	var checkboxes = document.getElementsByName("wfid");
	for(var i=0;i<checkboxes.length;i++){
		checkboxes[i].checked = o.checked ? true : false;
	}
}
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
</script>
</body>
</html>
