<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@ page import="com.eweaver.workflow.request.service.RequestlogService"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page import="com.eweaver.workflow.request.model.Requestbase"%>
<%@ page import="com.eweaver.base.category.service.CategoryService"%>
<%@ page import="com.eweaver.base.category.model.Category"%>
<%@ page import="com.eweaver.base.category.model.Categorylink"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowNodeStyleService"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.searchcustomize.service.SearchcustomizeService"%>
<%@ page import="com.eweaver.base.searchcustomize.model.*"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="java.net.URLEncoder"%>



<%
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");

Selectitem selectitem;
CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
RequestbaseService requestbaseService = (RequestbaseService) BaseContext.getBean("requestbaseService");
RequestlogService requestlogService = (RequestlogService) BaseContext.getBean("requestlogService");
NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
WorkflowNodeStyleService workflowNodeStyleService = (WorkflowNodeStyleService) BaseContext.getBean("workflowNodeStyleService");
String action = request.getParameter("action");
String userid = eweaveruser.getId();
HumresService humresService = (HumresService) BaseContext.getBean("humresService");


String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String nodeid = StringHelper.null2String(request.getParameter("nodeid"));
ArrayList arrWorkflowids = new ArrayList();
ArrayList arrWorkflownames = new ArrayList();
ArrayList arrNodeids = new ArrayList();
ArrayList arrNodenames = new ArrayList();
ArrayList arrNodeworkflowids = new ArrayList();


List nodeinfolist = requestbaseService.findDealwithRequeststatus(null,null);
for(int i=0;i<nodeinfolist.size();i++){
	
			Object[] values = (Object[])nodeinfolist.get(i);

			String _workflowid = StringHelper.null2String(values[0]);
			String _workflowname = StringHelper.null2String(values[1]);
			String _nodeid = StringHelper.null2String(values[2]);
			String _nodename = StringHelper.null2String(values[3]);
			
			if(StringHelper.isEmpty(workflowid) && StringHelper.isEmpty(nodeid)){
				workflowid = _workflowid;
				nodeid = _nodeid;
			}else if(!StringHelper.isEmpty(workflowid) && StringHelper.isEmpty(nodeid) && workflowid.equals(_workflowid)){
				nodeid = _nodeid;
			}else if(StringHelper.isEmpty(workflowid) && !StringHelper.isEmpty(nodeid) && nodeid.equals(_nodeid)){
				workflowid = _workflowid;
			}
			
			if(!arrWorkflowids.contains(_workflowid)){
				arrWorkflowids.add(_workflowid);
				arrWorkflownames.add(_workflowname);
			}
			
				arrNodeids.add(_nodeid);
				arrNodenames.add(_nodename);	
				arrNodeworkflowids.add(_workflowid);	
}

List list = (List) request.getAttribute("requestbaselist");
if(list==null){
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=piworkflow&workflowid="+workflowid+"&nodeid="+nodeid);
	return;
}



String tablename = "requestbase2";
SearchcustomizeService searchcustomizeService = (SearchcustomizeService) BaseContext.getBean("searchcustomizeService");
List resultOptions = searchcustomizeService.getSearchResult(userid,tablename);
List _tmpList = workflowNodeStyleService.getActivedNodeStyle(workflowid,nodeid);
ArrayList formvalueSqls = new ArrayList();
DataService ds = new DataService();

//新建文档的ｔａｒｇｅｔｕｒｌ
String targeturlfordoc = request.getContextPath()+"/workflow/request/workflowsimple.jsp?requestid=";
	
%>
<html>
  <head>
  	  <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
      
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/dojo.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.widget.TabContainer");
	dojo.require("dojo.widget.LinkPane");
	dojo.require("dojo.widget.ContentPane");
	dojo.require("dojo.widget.LayoutContainer"); 	
	dojo.require("dojo.widget.Dialog");     
</script><script type="text/javascript">
var dlgworkflow;
var dlg0;
function init(e) {
	dlgworkflow = dojo.widget.byId("dialogrequeststatus");
	dlg0 = dojo.widget.byId("dialog0");
	var btn = document.getElementById("hider0");
	dlg0.setCloseControl(btn);
	var btn1 = document.getElementById("hider1");
	dlg0.setCloseControl(btn1);
//	var btn = document.getElementById("hiderdialog");
//	dlgworkflow.setCloseControl(btn);
//	var btn1 = document.getElementById("hider1");
//	dlg0.setCloseControl(btn1);
}
dojo.addOnLoad(init);

</script>

<style type="text/css">
	.dojoDialog {
		width:90%;
		background : #CCCCCC;
		border : 1px solid #999999;
		-moz-border-radius : 5px;
		padding : 4px;
	}

</style>
  </head> 
  <body>
<!--页面菜单开始-->     
<%	

	Nodeinfo nodeinfo  = nodeinfoService.get(nodeid);
	String savebuttonname = StringHelper.null2String(nodeinfo.getSavebuttonname());
	String submitbuttonname = StringHelper.null2String(nodeinfo.getSubmitbuttonname());
	Integer ynawoke = nodeinfo.getYnawoke();
	String awokeinfo = StringHelper.null2String(nodeinfo.getAwokeinfo());
	int bAwoke = 0;
	
	if(StringHelper.isEmpty(submitbuttonname))
		submitbuttonname = labelService.getLabelName("402881e60aabb6f6010aabbda07e0009");
	if(StringHelper.isEmpty(savebuttonname))
		savebuttonname = labelService.getLabelName("402881ea0bfa7679010bfa963f300023");
		
	if(StringHelper.isEmpty(awokeinfo))
		awokeinfo = labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0048");//您确定要提交吗？
	
	if(	ynawoke !=null && ynawoke.intValue()==1)
		bAwoke = 1;
	
	
	boolean canreject = false;
	String rejectid = "";
	
	if(StringHelper.null2String(nodeinfo.getIsreject()).equals("1")){
		canreject = true;
		rejectid = StringHelper.null2String(nodeinfo.getRejectnode());
	}

//	pagemenustr += "{S,"+submitbuttonname+",javascript:onSubmit()}";
//	if(canreject) {
//		pagemenustr += "{B,"+labelService.getLabelName("402881e50c7bd518010c7be0ab0e0007")+",javascript:onReject()}";
//	}
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->  
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=piworkflow" name="EweaverForm" method="post">
     
	<table id=searchTable>
       <tr>
		 <td class="FieldName" width=10% nowrap>
			  <%=labelService.getLabelName("402881ef0c820942010c821bf6be000b")%><!-- 工作流名称-->
		 </td>                 
         <td class="FieldValue" width=15%>
		     <select class="inputstyle" id="workflowidselect" name="workflowidselect" onChange="javascript:onSearchByWorkflowid(this.value);">
		     	<%	for(int i=0;i<arrWorkflowids.size();i++){
		     			String _workflowid = StringHelper.null2String(arrWorkflowids.get(i));
		     			String _workflowname = StringHelper.null2String(arrWorkflownames.get(i));
		     			String checked = "";
		     			if(_workflowid.equals(workflowid))
		     				checked = " selected ";
		     		%>
				<option value="<%=_workflowid%>" <%=checked%>><%=_workflowname%></option>
				<%}%>
		     </select>
		     <input type="hidden" name="workflowid" id="workflowid" value="<%=workflowid%>">
          </td>
          
          		 <td class="FieldName" width=10% nowrap>
			  <%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%><!-- 节点名称-->
		 </td>                 
         <td class="FieldValue" width=15%>
		     <select class="inputstyle" id="nodeidselect" name="nodeidselect"  onChange="javascript:onSearchByNodeid(this.value);">
		     <%	for(int i=0;i<arrNodeids.size();i++){
		     			String _nodeid = StringHelper.null2String(arrNodeids.get(i));
		     			String _nodename = StringHelper.null2String(arrNodenames.get(i));
		     			String _nodeworkflowid = StringHelper.null2String(arrNodeworkflowids.get(i));
		     			if(!_nodeworkflowid.equals(workflowid))
		     				continue;
		     			String checked = "";
		     			if(_nodeid.equals(nodeid))
		     				checked = " selected ";
		     		%>
				<option value="<%=_nodeid%>"  <%=checked%>><%=_nodename%></option>
				<%}%>
		       </select>
		     <input type="hidden" name="nodeid" id="nodeid" value="<%=nodeid%>">
          </td>
	    </tr>        
       </table>
 	
 	<table border="0" name="workflowtable" id="workflowtable">
 	<tr class="Header">
		<td><input type=hidden name="selectall" value=1 onclick="selectallworkflow(this);"></td>
				<% 
				Iterator it = resultOptions.iterator();
				String showname = "";
				while(it.hasNext()){
					Searchcustomizeoption searchcustomizeoption = (Searchcustomizeoption) it.next();
					int _fieldid = searchcustomizeoption.getFieldid().intValue();
					if(_fieldid!=4009){
						showname = StringHelper.null2String(searchcustomizeoption.getShowname());
						if(searchcustomizeoption.getLabelid() != null)
						   	showname = labelService.getLabelName(searchcustomizeoption.getLabelid());					 
				%>
					<td nowrap><%=showname%>&nbsp</td>	<!--显示字段名  -->
				<%
					}else{

						String _tmpSql = "select ";
						String _tmpFormid = "";
						for (int _tmpIndex = 0; _tmpIndex < _tmpList.size(); _tmpIndex++) {
						
				 			showname = "";
							Object[] values = (Object[])_tmpList.get(_tmpIndex);
							String _Tfieldid = StringHelper.null2String( values[0]);
							String _Tlabelname = StringHelper.null2String( values[1]);
							String _Tdefaultvalue = StringHelper.null2String( values[2]);
							String _Tformid = StringHelper.null2String( values[3]);
							String _Tfieldname = StringHelper.null2String( values[4]);
							
							if(_tmpFormid.equals("")){
								_tmpSql += _Tfieldname+" as field"+_Tfieldid.substring(10);	
								_tmpFormid = _Tformid;					
							}else if(_tmpFormid.equals(_Tformid)){
								_tmpSql += ","+_Tfieldname+" as field"+_Tfieldid.substring(10);
							}else{
								Forminfo _forminfo = forminfoService.getForminfoById(_tmpFormid);
								String _tablename = StringHelper.null2String(_forminfo.getObjtablename());
								if(!_tablename.equals("")){
									_tmpSql += " from "+_tablename +" where requestid = ";
									 formvalueSqls.add(_tmpSql);
								}
								_tmpSql = "select ";
								_tmpFormid = _Tformid;
							}
							
							if(_tmpIndex == _tmpList.size()-1){
								Forminfo _forminfo = forminfoService.getForminfoById(_Tformid);
								String _tablename = StringHelper.null2String(_forminfo.getObjtablename());
								if(!_tablename.equals("")){
									_tmpSql += " from "+_tablename +" where requestid = ";
									 formvalueSqls.add(_tmpSql);
								}
							}
							
							if(StringHelper.isEmpty(_Tdefaultvalue))
								_Tdefaultvalue = _Tlabelname;
								
							showname = _Tdefaultvalue;
			
			%>	 		
				<td nowrap><%=showname%>&nbsp</td>	<!--显示字段名  -->
			<%	 		}
				 	}  
				}
				%>
 	</tr>
 	<%			

		boolean isLight=false;
		String trclassname="";
		int fieldid;
		String typename="";
		String objtypeid="";
		String humresname="";

		Requestbase requestbase = null;
		for (int i = 0; i < list.size(); i++) {

			requestbase = (Requestbase) list.get(i);

			
			isLight=!isLight;					
			if(isLight) trclassname="DataLight";
				else trclassname="DataDark";
				
%>
<tr class="<%=trclassname%>" id="tr_<%=requestbase.getId()%>" name="tr_<%=requestbase.getId()%>">

		<td><input type=hidden name="requestid_select" value="<%=requestbase.getId()%>"></td>
				    <%
				      Iterator Options = resultOptions.iterator();
				      String fieldvalue="";
				      while (Options.hasNext()) {
					        Searchcustomizeoption searchoption = (Searchcustomizeoption) Options.next();
					        fieldvalue="";
					        fieldid = searchoption.getFieldid().intValue();
					        
					        if(fieldid != 4009){
						       switch(fieldid){
	                            case 4001:
						       			//fieldvalue="<a href='/workflow/request/workflow.jsp?requestid=" + requestbase.getId() + "' target='_blank'>"+StringHelper.null2String(requestbase.getRequestname())+"</a>";
						       			fieldvalue="<a href='#' onclick=\"showrequeststatus('"+requestbase.getId()+"');\" >"+StringHelper.null2String(requestbase.getRequestname())+"</a>";
						       			//fieldvalue=StringHelper.null2String(requestbase.getRequestname());
						       		break;
						       	case 4002:
						       	            Workflowinfo workflowinfo = workflowinfoService.get(requestbase.getWorkflowid());
								            String workflowinfoname = "";
								            if(workflowinfo != null){
								            	workflowinfoname = workflowinfo.getObjname();
								            }
						       				fieldvalue=StringHelper.null2String(workflowinfoname);
						       			break;
						       	case 4003:
						       				selectitem = selectitemService.getSelectitemById(requestbase.getRequestlevel());
						       				fieldvalue=StringHelper.null2String(selectitem.getObjname());
						       			break;
						       	case 4004:
						       				String creater = humresService.getHumresById(requestbase.getCreater()).getObjname();
						       				fieldvalue="<a href='"+request.getContextPath()+"/humres/base/humresview.jsp?id=" + requestbase.getCreater() + "'>" + StringHelper.null2String(creater) + "</a>";
						       			break;
	
						       	case 4005:
						       				String createdatatime = requestbase.getCreatedate() + requestbase.getCreatetime();
						       	            fieldvalue=StringHelper.null2String(createdatatime);
	                                   break;
	                            case 4006:
	                            			String isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c");//是
							            	if(requestbase.getIsfinished().toString().equals("0")){
							            		isfinish = labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d");//否
							            	}
	                                         fieldvalue=StringHelper.null2String(isfinish);
	                                   break;
	                            case 4007:                            			
	                                        fieldvalue="<textarea type=text name='"+requestbase.getId()+"_remark' class='InputStyle2' style='width:100% height:100%'></textarea>";
	                                   break;     
	                            case 4008:
	                            			
	                            			
	                                        fieldvalue=StringHelper.null2String(nodeinfo.getObjname());
	                                   break;      
	                            case 4009:
	                            			
	                                        fieldvalue="";
	                                   break;  
	                                                
	                            default:
	                                   break;
	
	
								}	//end switch			        			        
							    %>   
							     <td nowrap><%=fieldvalue%></td>	<!--显示字段值 --> 
							    <%
							}else{
								Map valuemap = new HashMap();
								for(int _index=0;_index<formvalueSqls.size();_index++){
									String _sql = StringHelper.null2String(formvalueSqls.get(_index));
									_sql += "'"+requestbase.getId()+"'";
									Map values = ds.getValuesForMap(_sql);
									valuemap.putAll(values);
								}
								for (int _tmpIndex = 0; _tmpIndex < _tmpList.size(); _tmpIndex++) {
						
						 			fieldvalue = "";
									Object[] values = (Object[])_tmpList.get(_tmpIndex);
									String _Tfieldid = StringHelper.null2String( values[0]);
									String _Tlabelname = StringHelper.null2String( values[1]);
									String _Tdefaultvalue = StringHelper.null2String( values[2]);
									String _Tformid = StringHelper.null2String( values[3]);
									String _Tfieldname = StringHelper.null2String( values[4]);
									String htmltype = StringHelper.null2String( values[6]);
									String fieldtype = StringHelper.null2String( values[7]);
									String _Tvalue = StringHelper.null2String(valuemap.get("FIELD"+_Tfieldid.substring(10)));
									
									fieldvalue = _Tvalue;
									if(htmltype.equals("5")&&!StringHelper.isEmpty(fieldvalue)){						
										selectitem = selectitemService.getSelectitemById(fieldvalue);
										if(selectitem!=null){
											fieldvalue = selectitem.getObjname();
										}
									}
									if(htmltype.equals("6")&&!StringHelper.isEmpty(fieldvalue)){						
										Refobj refobj = refobjService.getRefobj(fieldtype);
										if(refobj != null){
											String _reftable = refobj.getReftable();
											String _keyfield = refobj.getKeyfield();
											String _viewfield = refobj.getViewfield();
											showname = "";
												String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
												try{
													Map refmap = ds.getValuesForMap(sql);		 	
													String _objname = (String) refmap.get("objname");								
													showname += _objname;									
												}catch(Exception e){
													System.out.println("--------sql:" + sql);
												}
											fieldvalue = showname;
										}			
									}		
							%>   
							     <td><%=fieldvalue%></td>	<!--显示字段值 --> 
							    <%
							    }
							}
                      }  //end while 		    
				    %>
</tr>
<%
}
%>
</table>
       <br>
      
	<div dojoType="dialog" id="dialog0" bgColor="white" bgOpacity="0.5" toggle="fade" toggleDuration="10" style="width:50%;display: 'none'">
		<table align="center">
		<tr align="center">
				<td align="center">
				<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0049") %><!-- 您确定要退回该流程吗? --><BR><%=labelService.getLabelNameByKeyId("40288035248eb3e801248f4ee7030031") %><!-- 请选择退回的节点 -->:
				</td>
		</tr>
		<%
		String rejectnodeid = "";
		if(canreject){
					String hql = "from Nodeinfo where workflowid='"+workflowid+"'";
					List nodelist = nodeinfoService.findAll(hql);
					for (int i = 0; i < nodelist.size(); i++) {
						Nodeinfo _nodeinfo = (Nodeinfo) nodelist.get(i);
						if (_nodeinfo.getNodetype().intValue() == 1) {
							String _thisnodeid = StringHelper.null2String(_nodeinfo.getId());
							boolean ischecked = false;
							if(rejectid.equals(_thisnodeid))
								ischecked = true;
							else if(rejectid.equals("") && _nodeinfo.getNodetype().intValue() == 1)
								ischecked = true;
								
							if(ischecked)
								rejectnodeid = _thisnodeid;
		%>
			<tr align="center">
				<td>
					<input type="radio" value="<%=_thisnodeid%>" id="rejectednode1" name="rejectednode1" <%if(ischecked){%> checked <%}%> onclick="javascript:document.all('rejectednode').value='<%=_thisnodeid%>';"><%=StringHelper.null2String(_nodeinfo.getObjname())%>			
				</td>
			</tr>
					<%			}
							}
					}%>
			<tr>
				<td align="center">
					<button type="button" class='btn' accessKey='O' id="hider0" onclick="javascript:changeIsreject(1);"><U>O</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6e71870022") %><!-- 确定 --></button>
					<button type="button" class='btn' accessKey='C' id="hider1" onclick="javascript:changeIsreject(0);"><U>C</U>--<%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023") %><!-- 取消 --></button>
				</td>
			</tr>
		</table>
	</div>
	
	
<input type="hidden" name="isreject" id="isreject" value="0">
<input type="hidden" name="rejectednode" id="rejectednode" value="<%=rejectnodeid%>">
    </form>
    
    <div dojoType="dialog" id="dialogrequeststatus" bgColor="white" bgOpacity="0.5" toggle="fade" toggleDuration="5" style="display: 'none'">
    	<table class=noborder width=100% height=12px>
			<tr>
				<td align="right" width=100% height=12px><a href="#"   id="hiderdialog"  name="hiderdialog" onclick="hiderequeststatus();" >关闭</a></td>
			</tr>
		</table>
	   <iframe align='middle' id="iframerequeststatus" name="iframerequeststatus" src='#' align='top' width='100%' height='580px' frameborder='0' scrolling='auto'>
		</iframe>
	</div>
	
<script language="javascript" type="text/javascript">

	function hiderequeststatus(){
		var docPane = document.all("iframerequeststatus");
		docPane.src="#";
		dlgworkflow.hide();	
	}
	function showrequeststatus(requestid){
		var docPane = document.all("iframerequeststatus");
		targeturl = "<%=URLEncoder.encode(targeturlfordoc, "UTF-8")%>"
		docPane.src="<%=request.getContextPath()%>/workflow/request/workflow.jsp?workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&requestid="+requestid+"&targeturl="+targeturl;
		dlgworkflow.show();	
	}
    function onSearch(pageno){
   	document.EweaverForm.pageno.value=pageno;
	document.EweaverForm.submit();
   }    
    function onSearch(){
	document.EweaverForm.submit();
   }  
   function onSearchByNodeid(value){
   document.all("workflowid").value="";
   document.all("nodeid").value=value;
   document.EweaverForm.action="<%=request.getContextPath()%>/workflow/request/doworkflowm.jsp";
	document.EweaverForm.submit();
   }
   function onSearchByWorkflowid(value){
   
   document.all("workflowid").value=value;
   document.all("nodeid").value="";
   document.EweaverForm.action="<%=request.getContextPath()%>/workflow/request/doworkflowm.jsp";
	document.EweaverForm.submit();
   }
    function onSearch(){
	document.EweaverForm.submit();
   }  
	function selectallworkflow(obj){
		checkobjs = document.all.tags("INPUT");
		for(i=0;i<checkobjs.length;i++){
			tmpobj = checkobjs[i];
			if(tmpobj.name=="requestid_select"){
				if(obj.checked)
					tmpobj.checked = true;
				else
					tmpobj.checked = false;
			}
		}
	}
	function changeIsreject(isreject){
	document.all("isreject").value=isreject;
	
	if(isreject == 1){		
		  		
   document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=batchoperate";
	
   		document.EweaverForm.submit();
	}
}
function onSubmit(){
  	
  var needcheck = 0;
  if(<%=bAwoke%> == 1){
  		 if( confirm('<%=awokeinfo%>')){  		 
   			needcheck = 1;
  		 }
  	}

  if(needcheck == 1){
	  		
   document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.request.servlet.WorkflowAction?action=batchoperate";
	document.EweaverForm.submit();
  }
  document.all("isreject").value = "0";
}


function onReject(){
	dlg0.show();
}

	
</script>
  </body>
</html>

