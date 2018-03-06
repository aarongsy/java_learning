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
String action = request.getParameter("action");
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

String tb = StringHelper.null2String(request.getParameter("tb"));

String targeturl = URLEncoder.encode(request.getContextPath()+"/base/blank.jsp?isclose=1","UTF-8");
%>

<html>
  <head>
    <script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>
  </head> 
  <body>
<!--页面菜单开始-->     
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=<%=action%>&from=list" name="EweaverForm" method="post">
 	<input type="hidden" name="tb" id= "tb" value=<%=tb%>>
 	<table border="0">
 	<tr class="Header">
 
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
		String humresname="";
		List list = (List) pageObject.getResult();
		Requestbase requestbase = null;
		for (int i = 0; i < list.size(); i++) {

			requestbase = (Requestbase) list.get(i);

			
			isLight=!isLight;					
			if(isLight) trclassname="DataLight";
				else trclassname="DataDark";
				
%>
<tr class="<%=trclassname%>">

				    <%
				      Iterator Options = resultOptions.iterator();
				      String fieldvalue="";
				      
				      while (Options.hasNext()) {
					        Searchcustomizeoption searchoption = (Searchcustomizeoption) Options.next();
					        String curusertel="";
					        fieldid = searchoption.getFieldid().intValue();
					        
					       switch(fieldid){
                            case 2001:
                            			curusertel = StringHelper.null2String(requestbase.getRequestname());
                            			String workbasename = curusertel;
                            			if(curusertel.length()>80){
                            				workbasename = curusertel.substring(0,80)+"...";
                            			}
					       				fieldvalue="<a href='"+request.getContextPath()+"/workflow/request/workflow.jsp?targeturl="+targeturl+"&requestid=" + requestbase.getId() + "' target='_blank'>"+ workbasename +"</a>";
					       				
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
					       				String creater = humresService.getHumresById(requestbase.getCreater()).getObjname();
					       				fieldvalue="<a href='"+request.getContextPath()+"/humres/base/humresview.jsp?id=" + requestbase.getCreater() + "'>" + StringHelper.null2String(creater) + "</a>";
					       			break;

					       	case 2005:
					       				String createdatatime = requestbase.getCreatedate() + requestbase.getCreatetime();
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
	                    			String lastsubmitdatesql = "select * from (select  operatedate,operatortime from requestlog where requestid='" +requestbase.getId()+ "' order by operatedate desc,operatortime desc) where rownum<=1 order by rownum asc";
	                    			DataService dbservice = new DataService();
	                    			Map m = (Map)dbservice.getValuesForMap(lastsubmitdatesql);
	                    			String lastsubmitdate = (String)m.get("operatedate");
	                    			String lastsubmittime = (String)m.get("operatortime");
	                               // fieldvalue=StringHelper.null2String(lastsubmitdate);
	                                fieldvalue=StringHelper.null2String(lastsubmitdate) + "  " + lastsubmittime;
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
										Humres humres = new Humres();
										if (userlist.size() > 0){
											humres = humresService.getHumresById((String) userlist.get(0));	
	                                        fieldvalue= "<FONT COLOR='#CC0000'>"+StringHelper.null2String(humres.getObjname())+ "</FONT>";
	                                        
	                                        curusertel = labelService.getLabelNameByKeyId("402881e70b7728ca010b7746fc6a0015")+"："+ StringHelper.null2String(humres.getTel1()) + "\n"+labelService.getLabelNameByKeyId("402881e70b7728ca010b7747b30f0016")+"：" + StringHelper.null2String(humres.getTel2());//办公室电话  移动电话
										}
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
						<button  type="button" accessKey="F" onclick="onSearch(1,'<%=tb%>')">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>,'<%=tb%>')">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>,'<%=tb%>')">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>,'<%=tb%>')">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="onSearch2('1',this.value,'<%=tb%>')">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="onSearch2('2',this.value,'<%=tb%>')">
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>       
  
 	
 	
    </form>
<script language="javascript" type="text/javascript">
    function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
   	
   	document.EweaverForm.action = "<%=request.getContextPath()%>/workflow/request/workflowtables.jsp?tb=<%=tb%>&pageno="+pageno;
	document.EweaverForm.submit();
   }    
   
  function onSearch2(input1,input2){
  	
  		if(input1=="1"){
  			document.EweaverForm.action = "<%=request.getContextPath()%>/workflow/request/workflowtables.jsp?tb=<%=tb%>&pageno="+input2;
  		}
  		if(input1=="2"){
  			document.EweaverForm.action = "<%=request.getContextPath()%>/workflow/request/workflowtables.jsp?tb=<%=tb%>&pagesize="+input2;
  		}
  	 	
		document.EweaverForm.submit();
  }
    
</script>
    
  </body>
</html>
