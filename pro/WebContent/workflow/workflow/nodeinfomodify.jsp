<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@ include file="/base/init.jsp"%>
<jsp:directive.page import="javax.sql.DataSource"/>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.word.service.WordModuleService" %>
<%@ page import="com.eweaver.workflow.form.dao.FormlayoutDaoHB" %>
<%@ page import="com.eweaver.sysinterface.base.service.InterfaceConfigDetailService" %>
<%@ page import="com.eweaver.sysinterface.base.service.InterfaceObjLinkService" %>
<%@ page import="com.eweaver.sysinterface.base.model.InterfaceObjLink" %>
<%@ page import="com.eweaver.sysinterface.base.model.InterfaceConfigDetail" %>
<%
  String id  = StringHelper.null2String(request.getParameter("id"));
  NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
  Nodeinfo nodeinfo = nodeinfoService.get(id);
  String workflowid = StringHelper.null2String(nodeinfo.getWorkflowid());
  WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
  FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
  Workflowinfo workflowinfo = workflowinfoService.get(StringHelper.null2String(nodeinfo.getWorkflowid()));
  HumresService humresService = (HumresService) BaseContext.getBean("humresService");
  SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
  WordModuleService wordModuleService = (WordModuleService) BaseContext.getBean("wordModuleService");
  CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
  ExportService exportService = (ExportService)BaseContext.getBean("exportService");
  ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
  
  //Start_获取相关接口
  InterfaceConfigDetailService interfaceConfigDetailService = (InterfaceConfigDetailService)BaseContext.getBean("interfaceConfigDetailService");
  InterfaceObjLinkService interfaceObjLinkService = (InterfaceObjLinkService)BaseContext.getBean("interfaceObjLinkService");
  List<InterfaceObjLink> interfaceList = interfaceObjLinkService.findByObjid(id);
  StringBuffer interfaceNames = new StringBuffer();
  if(interfaceList != null && !interfaceList.isEmpty()) {
  	for( InterfaceObjLink interfaceObjLink : interfaceList) {
  		InterfaceConfigDetail interfaceobj = interfaceConfigDetailService.getConfigDetailById(interfaceObjLink.getInterfaceId());
  		if(interfaceobj != null) {
  			interfaceNames.append(StringHelper.null2String(interfaceobj.getName()) + ",");
  		}
  	}
  }
  //End
  
  Setitem gmode=setitemService.getSetitem("402880311e723ad0011e72782a0d0005");
    String graphmode ="0";
    if(gmode!=null&&!StringHelper.isEmpty(gmode.getItemvalue())){
       graphmode=gmode.getItemvalue(); 
    }
  Nodeinfo tempNode = new Nodeinfo();  
  FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
  Formfield formfield = new Formfield();   
  List filedList = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
  
  Forminfo forminfo=forminfoService.getForminfoById(workflowinfo.getFormid());
  Forminfo forminfoMain=forminfoService.getForminfoMain(forminfo);
  List fieldListMain=filedList;
  if(!forminfoMain.getId().equals(forminfo.getId())){
	  fieldListMain =formfieldService.getAllFieldByFormId(forminfoMain.getId());
  }
  
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  Selectitem selectitem = null;
  List selectitemlist = selectitemService.getSelectitemList("4028819d0e521bf9010e5237454d000a",null);
%>


<html>
  <head>
<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-ui-1.9m7/ui/minified/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
<script type="text/javascript" src="/js/main.js"></script>
<script type="text/javascript" language="javascript" src="<%=request.getContextPath()%>/datapicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery/jquery-ui-1.9m7/themes/base/minified/jquery-ui.min.css"/>
<link rel="stylesheet" type="text/css" href="/js/jquery/plugins/multiselect/jquery.multiselect.css"/>
<link href="/js/jquery/plugins/qtip/jquery.qtip.min.css" rel="stylesheet" type="text/css">
  <script type="text/javascript">
$(function(){
	$('#imgHasten').qtip({
		content: '流程位于此节点时，流程创建者可以进行催办。'
	});
	$('#imgRejectnode').qtip({
		content: '勾选节点时，请不要勾选当前节点之后的节点。'
	});
});
</script>
<style type="text/css">
.ui-multiselect-header{
	display: none;
}
</style>
  </head>
  
  <body onload="javascript:init();"> 
		<!--页面菜单开始-->
		<%pagemenustr += "{S," + labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+ ",javascript:onSubmit()}";%>
		<div id="pagemenubar" style="z-index:100;"></div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.NodeinfoAction?action=modify" name="EweaverForm" id="EweaverForm" method="post">
			<input type="hidden" id="id" name ="id" value="<%=id%>">
			<table class=noborder>
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>		
				<tr class=Title>
					<th colspan=2 nowrap>
						<%=labelService.getLabelName("402881ee0c715de3010c725ffd4b00ae")%><!-- 节点信息-->
					</th>
				<!-- 流程信息 -->
				</tr>
				<tr>
					<td class="Line" colspan=2 nowrap></td>
				</tr>		
				<tr><!--  节点名称 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7248aaad0072")%>
					</td>
					<td class="FieldValue">
                       <%if(graphmode.equals("0")){%>
                       <input type="text" class="InputStyle2" style="width=50%"  id="objname" name="objname" value="<%=StringHelper.null2String(nodeinfo.getObjname())%>" onChange="checkInput('objname','objnamespan')"/>
					   <span id="objnamespan"/></span>
                       <%}else{%>
					   <input type="hidden" class="InputStyle2" style="width=50%" id="objname" name="objname" value="<%=StringHelper.null2String(nodeinfo.getObjname())%>" onChange="checkInput('objname','objnamespan')"/>
					   <span id="objnamespan"/><%=StringHelper.null2String(nodeinfo.getObjname())%></span>
					   <%}%>
                    </td>
				</tr>	
				<tr><!--  所属流程 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7249ba5b0078")%>

					</td>
					<td class="FieldValue">

					   <input type="hidden" id="workflowid" name="workflowid" value="<%=StringHelper.null2String(nodeinfo.getWorkflowid())%>"/>
					   <span id="workflowidspan"><%=StringHelper.null2String(workflowinfo.getObjname())%></span>
					</td>
				</tr>		
				<tr><!--  节点类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c724923d40075")%>
					</td>
					<td class="FieldValue">
					   <select class="inputstyle2"  name="nodetype" id="nodetype" onChange="javascript:nodeTypechange()">
					      <option value="1" <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("1")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c76779a340007")%></option> <!--  开始节点 -->
					      <option value="2" <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("2")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c7679ec06000a")%></option> <!--  活动节点 --> 
					      <option value="3" <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("3")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c767a6e22000d")%></option> <!--  子过程活动节点 --> 
					      <option value="4" <%if (StringHelper.null2String(nodeinfo.getNodetype()).equals("4")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c767adf440010")%></option> <!--  结束节点 -->
					   </select>
					</td>
				</tr>	
				<%if (!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")) { %>
				<tr><!--  自由流转 -->
					<td class="FieldName" nowrap><%=labelService.getLabelName("944a6559e87b4d85b9db1c8bfebf4cb0")%></td>
					<td class="FieldValue">
					   <input type='checkbox' id="isfree" name='isfree' value="1" <%if(StringHelper.null2String(nodeinfo.getIsfree()).equals("1")){%><%="checked"%><%}%> />
					</td>
				</tr>
				<%} %>
				
				<%if (!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")) { %>
				<tr><!--  是否显示提交并反馈 -->
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028836835cd84e70135cd84e7fd0000")%></td>
					<td class="FieldValue">
					   <input type='checkbox' id="isShowFeedback" name='isShowFeedback' value="1" <%if(StringHelper.null2String(nodeinfo.getIsShowFeedback()).equals("1")){%><%="checked"%><%}%> />
					</td>
				</tr>
				<%} %>
				<tr id = "isrejecttr"><!--  是否允许退回 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72661f7b00b1")%>

					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isreject" name='isreject' value=""<%=StringHelper.null2String(nodeinfo.getIsreject())%>"" <% if (StringHelper.null2String(nodeinfo.getIsreject()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isreject')" />
					</td>
				</tr>	
				<tr id="rejectnodetr"><!--  退回节点 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c726689d800b4")%>

					</td>
					<td class="FieldValue">
						<% 
						  String rejectnode= StringHelper.null2String(nodeinfo.getRejectnode()); 
					      List nodelist = nodeinfoService.getNodelistByworkflowid(workflowid);
					      Iterator it = nodelist.iterator();
					    %>
						 <select class="inputstyle2"  name="rejectnode" id="rejectnode" onChange="" multiple="multiple">
					        <% 
					          while(it.hasNext()){
					             tempNode = (Nodeinfo) it.next();
					          %>
					        <option value="<%=StringHelper.null2String(tempNode.getId())%>" <%if (rejectnode.indexOf(tempNode.getId())!=-1){%> <%="selected"%> <%}%>><%=StringHelper.null2String(tempNode.getObjname())%></option> 
			                <%
			                  }
			                %>
					      </select>	
					      <img id="imgRejectnode" src="/images/lightbulb.png" style="" />					   
					</td>
				</tr>
				<%if (!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")) { %>
				<tr id = "isundo"><!--  是否允许退回 -->
					<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450005") %><!-- 是否撤回 --></td>
					<td class="FieldValue">
					   <select class="inputstyle2"   name="col3" id="col3" onChange="">
					     <option value="0" <% if (StringHelper.null2String(nodeinfo.getCol3()).equals("0")){%><%="selected"%><%}%>>  </option>
					     <option value="1" <% if (StringHelper.null2String(nodeinfo.getCol3()).equals("1")){%><%="selected"%><%}%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450006") %><!-- 查看前撤回 --></option>
					     <option value="2" <% if (StringHelper.null2String(nodeinfo.getCol3()).equals("2")){%><%="selected"%><%}%>><%=labelService.getLabelNameByKeyId("4028690a0f60fbe6010f6124fcb40041") %><!-- 撤回 --></option>
					     <%--option value="3" <% if (StringHelper.null2String(nodeinfo.getCol3()).equals("3")){%><%="selected"%><%}%>>强制收回</option> --%>
					   </select>
					   <%--input type='checkbox' name='col3' value="0" <% if (StringHelper.null2String(nodeinfo.getCol3()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('col3')" /> --%>
					</td>
				</tr>
				<%} %>
                <tr id = "trtemporary">
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450007") %><!-- 是否显示添加会签人 -->

					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="istemporary" name='istemporary' onclick="temporarycheck(this)" <%if("1".equals(nodeinfo.getIstemporary())){%> checked="true" value="1" <%}%>/>
                     &nbsp;&nbsp;&nbsp; <span id="istemporarytextspan"<%if(!"1".equals(nodeinfo.getIstemporary())){%> style="display:none"<%}%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450009") %><!-- 自定义按钮名称 -->： <input type='text' id="istemporarytext" name='istemporarytext' class="InputStyle2" value="<%=StringHelper.null2String(nodeinfo.getIstemporarytext())%>"/> </span>

					</td>
				</tr>
                  <tr id = "trtemporary2">
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450008") %><!-- 是否显示非会签人 -->

					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="istemporary2" name='istemporary2' onclick="temporarycheck2(this)" <%if("1".equals(nodeinfo.getIstemporary2())){%> checked="true" value="1" <%}%>/>
                         &nbsp;&nbsp;&nbsp;<span id="istemporarytext2span" <%if(!"1".equals(nodeinfo.getIstemporary2())){%> style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450009") %><!-- 自定义按钮名称 -->： <input type='text' id="istemporarytext2" name='istemporarytext2' class="InputStyle2" value="<%=StringHelper.null2String(nodeinfo.getIstemporarytext2())%>"  /></span>
					</td>
				</tr>
                  <tr id = "trtemporary3">
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b45000a") %><!-- 是否显示移交 -->

					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="istemporary3" name='istemporary3' onclick="temporarycheck3(this)" <%if("1".equals(nodeinfo.getIstemporary3())){%> checked="true" value="1" <%}%>/>
                         &nbsp;&nbsp;&nbsp; <span id="istemporarytext3span" <%if(!"1".equals(nodeinfo.getIstemporary3())){%> style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450009") %><!-- 自定义按钮名称 -->： <input type='text' id="istemporarytext3" name='istemporarytext3' class="InputStyle2" value="<%=StringHelper.null2String(nodeinfo.getIstemporarytext3())%>" /> </span>
					</td>
				</tr>
				
                  <tr id = "trisForceFinish">
					<td class="FieldName" nowrap>
                    <%=labelService.getLabelNameByKeyId("4028832e3eef03ae013eef03afdd028f") %><!-- 是否显示强制归档 -->

					</td>
					<td class="FieldValue">
					<%
						String isForceFinish = StringHelper.null2String(nodeinfo.getIsForceFinish());
					%>
					   <input type='checkbox' id="isForceFinish" name='isForceFinish' onclick="isForceFinishCheck(this)" <%if("1".equals(isForceFinish)){%> checked="true" value="1" <%}%>/>
                         &nbsp;&nbsp;&nbsp; <span id="isForceFinishspan" <%if(!"1".equals(isForceFinish)){%> style="display:none"<%}%>> <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450009") %><!-- 自定义按钮名称 -->： <input type='text' id="isForceFinishText" name='isForceFinishText' class="InputStyle2" value="<%=StringHelper.null2String(nodeinfo.getIsForceFinishText())%>" /> </span>
					</td>
				</tr>
				<tr id ="refworkflowidytr" style="display:none"><!--  相关流程 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c726721e600b7")%>
					</td>
					<td class="FieldValue">
					   <%
					     String refworkflowName = "";
					     Workflowinfo refworkflow = workflowinfoService.get(StringHelper.null2String(nodeinfo.getRefworkflowid()));
					     if (refworkflow!=null) 
					       refworkflowName = StringHelper.null2String(refworkflow.getObjname());		   
					   %>
					   <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/workflowinfobrowser.jsp','refworkflowid','refworkflowidspan','0');"></button>
					   <input type="hidden" id="refworkflowid"  name="refworkflowid"  value="<%=StringHelper.null2String(nodeinfo.getRefworkflowid()) %>"/>
					   <span id="refworkflowidspan"/><%=refworkflowName%></span>					
					</td>
				</tr>								
				<tr id="refnodeidtr"  style="display:none"><!--  相关节点 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c726d004b00ba")%>
					</td>
					<td class="FieldValue">
					   <%
					     String refnodename = "";
					     Nodeinfo refnode = nodeinfoService.get(StringHelper.null2String(nodeinfo.getRefnodeid()));
					     if (refnode!= null)
					       refnodename = StringHelper.null2String(refnode.getObjname());
					   %>
					   <button  type="button" class=Browser onclick="javascript:getBrowser('/workflow/workflow/nodeinfobrowser.jsp','refnodeid','refnodeidspan','0');"></button>
					   <input type="hidden" id="refnodeid" name="refnodeid" value="<%=StringHelper.null2String(nodeinfo.getRefnodeid())%>"/>
					   <span id="refnodeidspan"/><%=refnodename%></span>					
					</td>
				</tr>				
				<tr id = "outmappingtr"  style="display:none"><!--输出参数列表关系   -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c726e131a00bd")%>
					</td>
					<td class="FieldValue">
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=5 id="outmapping" name="outmapping"><%=StringHelper.null2String(nodeinfo.getOutmapping())%></TEXTAREA>					
					</td>
				</tr>							
				<tr  id="inmappingtr" style="display:none"><!--输入参数列表关系   -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c726e7f7600c0")%>
					</td>
					<td class="FieldValue">
					<TEXTAREA STYLE="width=100%" class=InputStyle rows=5 id="inmapping" name="inmapping"><%=StringHelper.null2String(nodeinfo.getInmapping())%></TEXTAREA>					
					</td>
				</tr>	
				<tr><!--  是否邮件提醒 -->
					<td class="FieldName" nowrap>
                         	<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b45000b") %><!-- 是否跨数据源流转 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="iscrossds" name='iscrossds' value="<%=StringHelper.null2String(nodeinfo.getIsCrossDs())%>" <% if (StringHelper.null2String(nodeinfo.getIsCrossDs()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('iscrossds')" /><!-- onClick="javascript:onCheck('isemail')" -->
					</td>
				</tr>	
								<tr><!--  是否邮件提醒 -->
					<td class="FieldName" nowrap>
                         	<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b45000c") %><!-- 正文内容同步到主机 -->
					</td>
					<td class="FieldValue">
						<input type="text" id="doctourl" name="doctourl" value="<%=StringHelper.null2String(nodeinfo.getDocToUrl())%>"/>
					</td>
				</tr>
				<%
				 String datasource = nodeinfo.getDataSource();
				 %>
				<tr id="crossds" <%if(StringHelper.isEmpty(datasource)){ %>style="display:none"<%} %>>
					<td class="FieldName" nowrap>
                          	 <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b46000d") %><!-- 流转数据源 -->
					</td>
					<%String[] names=BaseContext.getBeanNames(DataSource.class); 
					 
					%>
					<td class="FieldValue"><select id="datasource" name="datasource">
					<option value="">&nbsp;</option>
					<%for(String n:names)out.println("<option value=\""+n+"\" "+(n.equalsIgnoreCase(datasource)?"selected":"")+">"+n+"</option>"); %>
					</select></td>
				</tr>
				<tr><!--前驱转移关系   -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("402881ee0c715de3010c726f352b00c3")%>
					</td>
					<td class="FieldValue">
						  <select class="inputstyle2"  name="jointype" id="jointype" onChange="">
					        <option value="" <%if (StringHelper.null2String(nodeinfo.getJointype()).equals("")){%><%="selected"%><%}%>></option> 
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getJointype()).equals("1")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881ee0c765f9b010c7680a68a0013")%></option> <!--同步聚合（AND）   -->
					        <option value="2" <%if (StringHelper.null2String(nodeinfo.getJointype()).equals("2")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c768131e20016")%></option> <!--异或聚合（XOR）   -->
					      </select>
					</td>
				</tr>	
				<tr><!--后驱转移关系   -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("402881ee0c715de3010c726ff28100c6")%>
					</td>
					<td class="FieldValue">
						  <select class="inputstyle2"  name="splittype" id="splittype" onChange="javascript:showOrHideEPTR();">
					        <option value="" <%if (StringHelper.null2String(nodeinfo.getSplittype()).equals("")){%><%="selected"%><%}%>></option> 
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getSplittype()).equals("1")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881ee0c765f9b010c76839db80019")%></option> <!--并行（AND）   -->
					        <option value="2" <%if (StringHelper.null2String(nodeinfo.getSplittype()).equals("2")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881ee0c765f9b010c7684248f001c")%></option> <!--异或（XOR） -->
					      </select>
					</td>
				</tr>
				<tr id="exclusivePriorityTR"><!--排他性优先级   -->
					<td class="FieldName" nowrap>
                    	<%=labelService.getLabelName("402881e43c8593e0013c8593e10c0001")%>
					</td>
					<td class="FieldValue">
						<%
							boolean epFlag = exportService.isDefinedExclusivePriority(nodeinfo.getId());
						%>
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/workflow/workflow/exclusivePrioritySetting.jsp?nodeid=<%=nodeinfo.getId()%>','exclusivePrioritySpan','exclusivePrioritySpan','0')"></button>
						<span id="exclusivePrioritySpan">
							<!-- 已定义优先级      未定义优先级 -->
							<%=epFlag ? labelService.getLabelName("402881e43c8593e0013c8593e10c0003") : labelService.getLabelName("402881e43c8593e0013c8593e10c0005") %>   
						</span>
					</td>
				</tr>		
				<tr><!--  接口配置-->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b46000e") %><!-- 请选择接口 -->
					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/sysinterface/interfacemanager.jsp?objtype=node&objid=<%=nodeinfo.getId()%>','interfacepage','interfacepagespan','0')"></button>
						<span id="interfacepagespan"><%=interfaceNames %></span>
					</td>
				</tr>	
				<tr><!--  节点预处理页面 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72730a8a00c9")%>

					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/workflow/workflow/extendjsp.jsp?type=pre&workflowid=<%=workflowid%>&filename='+document.getElementById('perpage').value,'perpage','perpagespan','0')"></button>
						<input type="hidden" id="perpage" name="perpage" value="<%=StringHelper.null2String(nodeinfo.getPerpage())%>"/>
						<span id="perpagespan"><%=StringHelper.null2String(nodeinfo.getPerpage())%></span>
					</td>
				</tr>				
				<tr><!--  节点后处理页面 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72746e5300cc")%>

					</td>
					<td class="FieldValue">
						<button  type="button" class=Browser onclick="javascript:getJspBrowser('/workflow/workflow/extendjsp.jsp?type=aft&workflowid=<%=workflowid%>&filename='+document.getElementById('afterpage').value,'afterpage','afterpagespan','0')"></button>
						<input type="hidden" id="afterpage" name="afterpage" value="<%=StringHelper.null2String(nodeinfo.getAfterpage())%>"/>
						<span id="afterpagespan"><%=StringHelper.null2String(nodeinfo.getAfterpage())%></span>
					</td>
				</tr>	
				<tr><!-- 提醒类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028819d0e521bf9010e525d08b70010")%><!-- 提醒类型-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="remindtype" id="remindtype" onChange="javascript:changeType()"> 
                       <option value=""><%=labelService.getLabelNameByKeyId("402883d93ebfd597013ebfd59a580291") %><!-- 流程提醒 --></option>
                       <%for(int i=0;i<selectitemlist.size();i++){
                       selectitem=(Selectitem)selectitemlist.get(i);
                       %>
					   <option value="<%=selectitem.getId()%>" <%if(selectitem.getId().equals(nodeinfo.getRemindtype())){%> selected<%}%>>
						<%=selectitem.getObjname()%>
					   </option>
					   <%}%>
                       </select>
                       &nbsp;&nbsp;
                       <!-- 选择提醒方式 -->
                       <div id="divSelectNotify" style="display:<%="4028819d0e521bf9010e5238bec2000d".equals(nodeinfo.getRemindtype())?"inline":"none"%>;">
				                       邮件<input type='checkbox' name='selemail' value="<%=StringHelper.null2String(nodeinfo.getSelemail())%>" <% if (StringHelper.null2String(nodeinfo.getSelemail()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selemail')" />
				                       短信<input type='checkbox' name='selsms' value="<%=StringHelper.null2String(nodeinfo.getSelsms())%>" <% if (StringHelper.null2String(nodeinfo.getSelsms()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selsms')" />
				                       弹出窗口<input type='checkbox' name='selpopup' value="<%=StringHelper.null2String(nodeinfo.getSelpopup())%>" <% if (StringHelper.null2String(nodeinfo.getSelpopup()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selpopup')" />
				                       即时通讯<input type='checkbox' name='selrtx' value="<%=StringHelper.null2String(nodeinfo.getSelrtx())%>" <% if (StringHelper.null2String(nodeinfo.getSelrtx()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('selrtx')"/>
                       </div>
                       
                       <!-- 强制提醒方式 -->
                       <div id="divForceNotify" style="display:<%="4028819d0e521bf9010e5238bec2000e".equals(nodeinfo.getRemindtype())?"inline":"none"%>;">
				                       邮件<input type='checkbox' name='isemail' value="<%=StringHelper.null2String(nodeinfo.getIsemail())%>" <% if (StringHelper.null2String(nodeinfo.getIsemail()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isemail')" />
				                       短信<input type='checkbox' name='issms' value="<%=StringHelper.null2String(nodeinfo.getIssms())%>" <% if (StringHelper.null2String(nodeinfo.getIssms()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('issms')" />
				                       弹出窗口<input type='checkbox' name='ispopup' value="1" <% if (StringHelper.null2String(nodeinfo.getIspopup()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('ispopup')"/>
				                       即时通讯<input type='checkbox' name='isrtx' value="1" <% if (nodeinfo.getIsrtx()!=null&&nodeinfo.getIsrtx().intValue()==1){%><%="checked"%><%}%> onClick="javascript:onCheck('isrtx')" />
                       </div>
                       
					</td>
					</tr>					
				<tr id="emailmodeltr"  style="display:none"><!--  邮件模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c727606f600d2")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=50%" id="emailmodel" name="emailmodel" value="<%=StringHelper.null2String(nodeinfo.getEmailmodel())%>"/>
					</td>
				</tr>											
				<tr id="msgmodeltr"  style="display:none"><!--  消息模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7276cf0e00d8")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width=50%" id="msgmodel" name="msgmodel" value="<%=StringHelper.null2String(nodeinfo.getMsgmodel())%>"/>
					</td>
				</tr>
				<%
					int nodetype =NumberHelper.getIntegerValue(nodeinfo.getNodetype()).intValue();
					String hastendisplay = "";
					if(nodetype==0||nodetype==1||nodetype==4){
						hastendisplay = "none";
					}else{
						hastendisplay="";
					}
				%>
				<tr style="display: <%=hastendisplay %>"><!--  是否可催办 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("EDC319F865A041DE9B7633CC1EFBBBD9") %><!-- 是否可催办 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="hasten" name='hasten' value="<%=StringHelper.null2String(nodeinfo.getHasten())%>" <% if (StringHelper.null2String(nodeinfo.getHasten()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('hasten')"/>
					   <img id="imgHasten" src="/images/lightbulb.png" style="" />
					</td>
				</tr>
				<tr style="display: <%=hastendisplay %>"><!--  是否会签 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006b") %><!-- 是否会签 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="huiqian" name='huiqian' value="<%=StringHelper.null2String(nodeinfo.getHuiqian())%>" <% if (StringHelper.null2String(nodeinfo.getHuiqian()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('huiqian')"/>
					</td>
				</tr>
				<tr><!--  是否在手机中显示 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("4028836e37775d9a0137775da5bb0000") %><!-- 是否在手机中显示  -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="showinphone" name='showinphone' value="<%=StringHelper.null2String(nodeinfo.getIsShowInphone())%>" <% if (StringHelper.null2String(nodeinfo.getIsShowInphone()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('showinphone')"/>
					</td>
				</tr>
				<%
				String checkNodetype = StringHelper.null2String(nodeinfo.getNodetype());
				boolean isshowSetAutoflow=false;
				if(checkNodetype.equals("1") || checkNodetype.equals("4")){
					isshowSetAutoflow=true;
				}
				%>
				<tr id="isdiscautoflowtr" style="display:<%=isshowSetAutoflow?"none":""%>"><!--  是否自动流转（非相邻节点） -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006c") %><!-- 是否自动流转 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isdiscautoflow" name='isdiscautoflow' value="<%=StringHelper.null2String(nodeinfo.getIsdiscautoflow())%>" <% if (StringHelper.null2String(nodeinfo.getIsdiscautoflow()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isdiscautoflow')"/>
					</td>
				</tr>
				<tr id="isautoflowtr" style="display:<%=isshowSetAutoflow?"none":""%>"><!--  是否自动流转 （相邻节点）-->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b46000f") %><!-- 是否自动流转（相邻节点） -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isautoflow" name='isautoflow' value="<%=StringHelper.null2String(nodeinfo.getIsautoflow())%>" <% if (StringHelper.null2String(nodeinfo.getIsautoflow()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isautoflow')"/>
					</td>
				</tr>	
				<%if (!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")) { %>
				<tr><!--  允许批量审批 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883dd3c8a0462013c8a0466cf0280") %><!-- 是否允许批量审批 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isbatchapproval" name='isbatchapproval' value="<%=StringHelper.null2String(nodeinfo.getIsBatchApproval())%>" <% if (StringHelper.null2String(nodeinfo.getIsBatchApproval()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('isbatchapproval')"/>
					</td>
				</tr>
				<%}%>
				<tr><!--  表单扩展页面 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b006d") %><!-- 扩展页面 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" id="nodeextpage" name='nodeextpage' value="<%=StringHelper.null2String(nodeinfo.getNodeextpage())%>"/>
					</td>
				</tr>	
				<tr><!--  是否提交前确认 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460010") %><!-- 是否提交前确认 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="ynawoke" name='ynawoke' <% if (StringHelper.null2String(nodeinfo.getYnawoke()).equals("1")){%><%="checked"%><%}%> value='1' />
					</td>
				</tr>	
				<tr><!--  提交确认信息 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460011") %><!-- 提交确认信息 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" id="awokeinfo" name="awokeinfo" value="<%=StringHelper.null2String(nodeinfo.getAwokeinfo())%>"/>
					</td>
				</tr>	
				<tr><!--  保存按钮名称 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0070") %><!-- 保存按钮名称 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" id="savebuttonname" name="savebuttonname" value="<%=StringHelper.null2String(nodeinfo.getSavebuttonname())%>"/>
					</td>
				</tr>	
				<tr><!--  提交按钮名称 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0071") %><!-- 提交按钮名称 -->
					</td>
					<td class="FieldValue">
					   <input type="text" class="InputStyle2" style="width=50%" id="submitbuttonname" name="submitbuttonname" value="<%=StringHelper.null2String(nodeinfo.getSubmitbuttonname())%>"/>
					</td>
				</tr>		
				<tr><!--  数据接口 -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("402881e50cc049d2010cc04b80090006")%>
					</td>
					<td class="FieldValue">
					  <TEXTAREA STYLE="width=100%" class=InputStyle rows=5 id="datainterface" name="datainterface"><%=StringHelper.null2String(nodeinfo.getDatainterface())%></TEXTAREA>
					</td>
				</tr>
				<tr><!--  数据接口(退回调用) -->
					<td class="FieldName" nowrap>
                           <%=labelService.getLabelName("40288035251035db01251063ca760005")%>
					</td>
					<td class="FieldValue">
					  <TEXTAREA STYLE="width=100%" class=InputStyle rows=5 id="datainterface2" name="datainterface2"><%=StringHelper.null2String(nodeinfo.getDatainterface2())%></TEXTAREA>
					</td>
				</tr>
				<tr><!--  是否允许打印 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0072") %><!-- 是否允许打印 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isprint" name='isprint' value='<%=StringHelper.null2String(nodeinfo.getIsprint())%>' <%if(StringHelper.null2String(nodeinfo.getIsprint()).equals("1")){%> <%="checked"%> <%}%> onclick="onPrintCheck()"/>
					</td>
				</tr>
				<tr><!--  是否Excel导出 -->
					<td class="FieldName" nowrap>
                         	<%=labelService.getLabelNameByKeyId("4028834e34e5c3500134e5c3533a0292")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isexcelexp" name='isexcelexp' value='<%=StringHelper.null2String(nodeinfo.getIsexcelexp())%>' <%if(StringHelper.null2String(nodeinfo.getIsexcelexp()).equals("1")){%> <%="checked"%> <%}%> onclick="javascript:onCheck('isexcelexp')"/>
					</td>
				</tr>
				<tr><!--  是否超时 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7277d47200de")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="istimeout" name='istimeout' value="<%=StringHelper.null2String(nodeinfo.getIstimeout())%>" <% if (StringHelper.null2String(nodeinfo.getIstimeout()).equals("1")){%><%="checked"%><%}%> onClick="javascript:onCheck('istimeout')" />
					</td>
				</tr>
		  </table>	
	
                  <table id="timeouttable" style="display:none" class="noborder">
                  	<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>	
				      <tr><!--超时起始时间  -->
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelName("402881ee0c715de3010c727914b600e4")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2" name="timeoutstart" id="timeoutstart" onChange="checkTime()">
					        <option value="0" <%if (StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("0")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881e70b65e2b3010b65e5e5fc0006")%></option><!--提交时间  -->
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("1")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881f00c7690cf010c7693133e0007")%></option> <!--接收时间  -->
					        <option value="2" <%if (StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("2")){%><%="selected"%><%}%>> <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0074") %></option> <!--指定时间  -->
					      </select>
					      <span id="timeoutstart_span1"><%=labelService.getLabelName("402883243dcf39ad013dcf39afdb0000")%></span>
					      <span id="timeoutstart_span2"><%=labelService.getLabelName("402883243dcf39ad013dcf39afdc0001")%></span>
					    </td>
				     </tr>	
  			    	<tr id ="timeoutunittr"><!--时间单位  -->
				    	<td class="FieldName" nowrap>
                              <%=labelService.getLabelName("402881ee0c715de3010c727854e900e1")%>
				    	</td>
					    <td   class="FieldValue" >
						  <select class="inputstyle2"  name="timeoutunit" id="timeoutunit" onChange="">
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getTimeoutunit()).equals("1")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c76894378001f")%></option><!--小时  --> 
					        <option value="2" <%if (StringHelper.null2String(nodeinfo.getTimeoutunit()).equals("2")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c7689dac80022")%></option> <!--天  -->
					        <option value="3" <%if (StringHelper.null2String(nodeinfo.getTimeoutunit()).equals("3")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c768a4f830025")%></option> <!--周  -->
					        <option value="4" <%if (StringHelper.null2String(nodeinfo.getTimeoutunit()).equals("4")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c768ac6960028")%></option> <!--月  -->
					        <option value="5" <%if (StringHelper.null2String(nodeinfo.getTimeoutunit()).equals("5")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881ee0c765f9b010c768b3338002b")%></option> <!--季度  -->
					      </select>
					   </td>
				     </tr>	  

  			    	 <tr><!--超时时间类型  -->
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelName("402881ee0c715de3010c727976fa00e7")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2"  name="timeouttype" id="timeouttype" onChange="javascript:timeouttypeChange()">
					        <option value="0" <%if (StringHelper.null2String(nodeinfo.getTimeouttype()).equals("0")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881f00c7690cf010c76948617000a")%></option>  <!--常量  -->
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getTimeouttype()).equals("1")){%><%="selected"%><%}%>><%=labelService.getLabelName("402881f00c7690cf010c7694fadc000d")%></option>  <!--变量  -->
					      </select>
					       	<input type="text" style="display:none" class="InputStyle2"  id="timeoutvalue" name="timeoutvalue" value="<%=StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("2")?"":StringHelper.null2String(nodeinfo.getTimeoutvalue())%>" onblur="fieldcheck(this,'^-?\\d+$','整数')"/>
					    	<input type="text" style="display:none" class="InputStyle2"  id="timeoutvaluedate" name="timeoutvalue" value="<%=StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("2")?StringHelper.null2String(nodeinfo.getTimeoutvalue()):""%>" onclick="WdatePicker({minDate:'%y-%M-#{%d}'})" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;"/>
					    	<span id="timeoutvaluedate_span"><%=labelService.getLabelName("402883243dcf39ad013dcf39afdc0002")%></span>
					    </td>
				     </tr>	
				     
				     <!--  字段 -->	
				     <tr id="timeoutfieldidtr" style="display:none"><!--超时变量 字段id  -->
				        <td class="FieldName" nowrap>
				            <%=labelService.getLabelName("402881ee0c715de3010c727bd46b00ea")%>
				        </td>
				        <td class="FieldValue">
				           <select class="inputstyle2"  name="timeoutfieldid"  id="timeoutfieldid" > 
				             <option value="" <%if (StringHelper.null2String(nodeinfo.getTimeoutfieldid()).equals("")){%><%="selected"%><%}%>> </option> 
				             <%
				               Iterator fieldIt = fieldListMain.iterator();
				               while(fieldIt.hasNext()){
				                 formfield = (Formfield)fieldIt.next();
				                 if (formfield!=null&&"2".equals(StringHelper.null2String(formfield.getFieldtype()))){
				             %>
				               <option value="<%=formfield.getId()%>"  <%if (StringHelper.null2String(nodeinfo.getTimeoutfieldid()).equals(formfield.getId())){%><%="selected"%><%}%>><%=StringHelper.null2String(formfield.getLabelname())%></option> 
				             <%
				               }
				              }
				             %>
				           </select>
				           <select class="inputstyle2"  name="timeoutfieldid"  id="timeoutfieldiddate" > 
				             <option value="" <%if (StringHelper.null2String(nodeinfo.getTimeoutfieldid()).equals("")){%><%="selected"%><%}%>> </option> 
				             <%
				             Iterator fieldIt2 = fieldListMain.iterator();
				               while(fieldIt2.hasNext()){
				                 formfield = (Formfield)fieldIt2.next();
				                 if (formfield!=null&&"4".equals(StringHelper.null2String(formfield.getFieldtype()))){
				             %>
				               <option value="<%=formfield.getId()%>"  <%if (StringHelper.null2String(nodeinfo.getTimeoutfieldid()).equals(formfield.getId())){%><%="selected"%><%}%>><%=StringHelper.null2String(formfield.getLabelname())%></option> 
				             <%
				               }
				              }
				             %>
				           </select>
				        </td>
				     </tr>				     
  			    	 <tr><!--超时操作-->
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelName("402881ee0c715de3010c727c31fd00ed")%>
				    	</td>
					    <td class="FieldValue">
						  <select class="inputstyle2" id="timeoutopt"  name="timeoutopt"  id="timeoutopt" onChange="javascript:timeoutoptChange();">
					        <option value="0" <%if (StringHelper.null2String(nodeinfo.getTimeoutopt()).equals("0")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881f00c7690cf010c7699453c0010")%></option> <!--发送邮件-->
					        <option value="1" <%if (StringHelper.null2String(nodeinfo.getTimeoutopt()).equals("1")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881f00c7690cf010c7699c7e40013")%></option> <!--自动执行-->
					        <option value="2" <%if (StringHelper.null2String(nodeinfo.getTimeoutopt()).equals("2")){%><%="selected"%><%}%>> <%=labelService.getLabelName("402881f00c7690cf010c769a2ba50016")%></option> <!--重定向-->
					        <option value="3" <%if (StringHelper.null2String(nodeinfo.getTimeoutopt()).equals("3")){%><%="selected"%><%}%>> <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0075") %><!-- 发送邮件一次之后自动执行 --></option> <!--仅忽略一次-->
					         <option value="4" <%if (StringHelper.null2String(nodeinfo.getTimeoutopt()).equals("4")){%><%="selected"%><%}%>> <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460013") %><!-- 自定义执行动作 --></option> <!--仅忽略一次-->
					       
					      </select>
					      <span id="col2span" style="display:none" ><%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0076") %><!-- 发送邮件和自动执行时间间隔(单位同上面的时间单位) -->	
					      	<input type="text" class="InputStyle2" name="col2" id="col2" value="<%=StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("2")?"":StringHelper.null2String(nodeinfo.getCol2())%>" onblur="fieldcheck(this,'^-?\\d+$','整数')"/>
					      	<input type="text" class="InputStyle2" name="col2" id="col2date" value="<%=StringHelper.null2String(nodeinfo.getTimeoutstart()).equals("2")?StringHelper.null2String(nodeinfo.getCol2()):""%>" onclick="WdatePicker({minDate:'%y-%M-#{%d}'})" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','日期');return false;"/>					  
					    </span>
					     <span id="customactionspan" style="display:none" ><br/><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460014") %><!-- 执行动作路径(例如：com.eweaver.job.custom.noderemind) -->:			      
					      	<input type="text" size="70" class="InputStyle2" name="customaction" id="customaction" value="<%=StringHelper.null2String(nodeinfo.getCustomaction())%>"/>					  
					    </span>
					    </td>
					 </tr>
				     <tr id="timeoutloadidtr" style="dispaly:none"><!--  重定向节点 -->
					  <td  class="FieldName" nowrap>
                            <%=labelService.getLabelName("402881ee0c715de3010c727cb58c00f0")%>

				      </td>
					  <td class="FieldValue">
						<% 
						  String loadnodeid= StringHelper.null2String(nodeinfo.getTimeoutloadid()); 
					      List nodelist1 = nodeinfoService.getNodelistByworkflowid(workflowid);
					      Iterator it1 = nodelist.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="timeoutloadid" id="timeoutloadid" onChange="">
					        <option value=""></option> 
					        <% 
					          while(it1.hasNext()){
					             tempNode = (Nodeinfo) it1.next();
					          %>
					        <option value="<%=StringHelper.null2String(tempNode.getId())%>" <%if (loadnodeid.equals(StringHelper.null2String(tempNode.getId()))){%> <%="selected"%> <%}%>><%=StringHelper.null2String(tempNode.getObjname())%></option> 
			                <%
			                  }
			                %>
					      </select>					     
					  </td>
				     </tr>					    		     		     			                   
                  </table>
	
	
			<table class="noborder">
			<colgroup>
				<col width="30%">
				<col width="70%">
			</colgroup>
			<%if (!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")) { %>
			<tr style="">
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf2b0073") %><!-- 是否要盖章 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="isstamp" name='isstamp' value='<%=StringHelper.null2String(nodeinfo.getIsstamp())%>'<%if(StringHelper.null2String(nodeinfo.getIsstamp()).equals("1")){%> <%="checked"%> <%}%>onclick="onStampCheck()" />
					</td>
				</tr>
			<%}%>
                <%if(!StringHelper.null2String(nodeinfo.getIsstamp()).equals("1")){%>
            <tr id="stampfieldtr" style="display:none">
                <%}else{%>
                <tr id="stampfieldtr" style="">

                <%}%>
            <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460012") %><!-- 选择要盖章的位置 -->
			</td>
			<td class="FieldValue">
		     	 <select id="stampfield" name="stampfield">
                 <option value="" <%if (StringHelper.null2String(nodeinfo.getStampfield()).equals("")){%><%="selected"%><%}%>> </option>
                 <%
                   Iterator stampfieldlist = fieldListMain.iterator();
                   while(stampfieldlist.hasNext()){
                  	formfield = (Formfield)stampfieldlist.next();
                    if (formfield!=null){
                   	%>
                     <option value="<%=formfield.getId()%>"  <%if (StringHelper.null2String(nodeinfo.getStampfield()).equals(formfield.getId())){%><%="selected"%><%}%>><%=StringHelper.null2String(formfield.getLabelname())%> <%=formfield.getFieldname()%></option>
                   	<%
                   	}
                  	}
                 %>
		     	 </select>
			</td>
            </tr>
            <tr>
				<td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883e23c086242013c086248d90000") %><!-- 是否电子签章 -->
				</td>
				<td class="FieldValue">
				   <input type='checkbox' id="isISignatureHTML" name='isISignatureHTML' value='1' <%if(StringHelper.null2String(nodeinfo.getIsISignatureHTML()).equals("1")){%> <%="checked"%> <%}%> />
				</td>
			</tr>
			<tr>
				<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460015") %><!-- 是否需要生成HTML文档 --></td>
				<td class="FieldValue">
				<%if(!"4".equals(StringHelper.null2String(nodeinfo.getNodetype()))){ %>
					<input type='checkbox' id="ishtmldoc" name='ishtmldoc' value="1" <% if (StringHelper.null2String(nodeinfo.getIshtmldoc()).equalsIgnoreCase("1")) out.print("checked");%> onClick="javascript:onCheck('hashtmldoc')" />
				<%}else{
					String ishtmldoc=StringHelper.null2String(nodeinfo.getIshtmldoc());
				%>
					<select id="ishtmldoc" name="ishtmldoc" onchange="javascript:onCheck('hashtmldoc');">
						<option value="0" <%if("".equals(ishtmldoc)||"0".equals(ishtmldoc)) out.print("selected"); %>></option>
						<option value="1" <%if("1".equals(ishtmldoc)) out.print("selected"); %>><%=labelService.getLabelNameByKeyId("4028832c3ea6d01f013ea6d01fb60001") %><!-- 归档后编辑 --></option>
						<option value="2" <%if("2".equals(ishtmldoc)) out.print("selected"); %>><%=labelService.getLabelNameByKeyId("4028832c3ea6d01f013ea6d01fb60002") %><!-- 归档前 --></option>
						<option value="3" <%if("3".equals(ishtmldoc)) out.print("selected"); %>><%=labelService.getLabelNameByKeyId("4028832c3ea6d01f013ea6d01fb60003") %><!-- 归档前和归档后编辑 --></option>
					</select>
				<%} %>
				</td>
			</tr>
			</table>
			
			<table id="htmldoctable" <% if (!(StringHelper.null2String(nodeinfo.getIshtmldoc()).equalsIgnoreCase("0") || StringHelper.null2String(nodeinfo.getIshtmldoc()).equalsIgnoreCase(""))){%>style="display:block;"<%}else{%>style="display:none;"<%}%> class="noborder">
			<colgroup>
				<col width="30%">
				<col width="70%">
			</colgroup>
			<tr>
			 	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b460016") %><!-- HTML文档布局 --></td>
				<td class="FieldValue">
					<select id="htmldoclayout" name="htmldoclayout">
					<option value=""></option>
					<%
					List<Formlayout> layoutlist = ((FormlayoutDaoHB)formlayoutService.getFormlayoutDao()).getHibernateTemplate().find("select a from Formlayout a,Workflowinfo b where (a.typeid=1 or a.typeid=3) and a.formid=b.formid and b.id='" + workflowid + "' and a.isdelete=0");
					for (Formlayout formlayout:layoutlist) {
					%>
					<option value="<%=formlayout.getId()%>"
					<%if(formlayout.getId().equals(StringHelper.null2String(nodeinfo.getHtmldoclayout()))){%>selected="selected"<%}%>><%=formlayout.getLayoutname()%>
					</option>
					<%}%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028832c3ea6d01f013ea6d01fb60000") %><!-- 生成html文档是否包括审批意见 --></td>
				<td class="FieldValue">
					<input type='checkbox' id="isshowmsg" name='isshowmsg' value="1" <% if (StringHelper.null2String(nodeinfo.getIsshowmsg()).equalsIgnoreCase("1")) out.print("checked");%> />
				</td>
			</tr>
			<tr>
			 	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470017") %><!-- HTML文档名称 --></td>
				<td class="FieldValue">
				<%
				List list = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
				Iterator iteratorObj = list.iterator();
				%>
				<select class="inputstyle2"  name="htmldoctitle" id="htmldoctitle" >
				<option value=""></option>
				<%
				while(iteratorObj.hasNext()){
					Formfield formfieldObj = (Formfield) iteratorObj.next();
				%>
				<option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getHtmldoctitle())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getLabelname())%></option>
				<%}%>
			    </select>
				</td>
			</tr>
			<tr>
			 	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470018") %><!-- HTML文档分类 --></td>
				<td class="FieldValue">
					<button  type="button" class=Browser id="button_htmldoccat" name="button_htmldoccat" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','htmldoccat','htmldoccatspan','1')"></button>
					<input type="hidden" id="htmldoccat" name="htmldoccat" value="<%=nodeinfo.getHtmldoccat()%>"  style='width: 288px; height: 17px'  >
					<span id="htmldoccatspan" name="htmldoccatspan" ><%=StringHelper.null2String(categoryService.getCategoryById(StringHelper.null2String(nodeinfo.getHtmldoccat())).getObjname())%></span>
				</td>
			</tr>
			</table>
	
	
	
	
          <table class="noborder">
            <colgroup>
               <col width="30%">
               <col width="70%">
            </colgroup>
				<tr><!--  是否超时 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470019") %><!-- 是否需要生成word文档/公文 -->
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="hasworddoc" name='hasworddoc' value="1" <% if (StringHelper.null2String(nodeinfo.getWorddochead()).equalsIgnoreCase("1")) out.print("checked");%> onClick="javascript:onCheck('hasworddoc')" />
					</td>
				</tr>
		  </table>

                  <table id="worddoctable" <% if (!StringHelper.null2String(nodeinfo.getWorddochead()).equalsIgnoreCase("1")){%>style="display:none"<%}%> class="noborder">
                  	<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450000") %><!-- 流转公文word模板 -->
				    	</td>
					    <td class="FieldValue">
                            <button  type="button" class=Browser id="button_4028d80f19b18c860119b263878c0072" name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/document/base/wordmodulebrowser.jsp?docTemplateType=4','wordmoduleid','wordmoduleidspan','1')"></button><input type="hidden" id="wordmoduleid" name="wordmoduleid" value="<%=StringHelper.null2String(nodeinfo.getWordmoduleid())%>"  style='width: 288px; height: 17px'  ><span id="wordmoduleidspan" name="wordmoduleidspan" ><%=StringHelper.null2String(wordModuleService.getWordModule(StringHelper.null2String(nodeinfo.getWordmoduleid())).getObjname())%></span>
                        </td>
                      </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001a") %><!-- Word模板存储字段 -->
				    	</td>
					    <td class="FieldValue">
						<%
						list = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
					      Iterator itObj = list.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="wordmodulefield" id="wordmodulefield" onChange="">
					        <option value=""></option>
					        <%
					          while(itObj.hasNext()){
					             Formfield formfieldObj = (Formfield) itObj.next();
					          %>
					        <option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getWordmodulefield())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getLabelname())%></option>
			                <%
			                  }
			                %>
					      </select>
                        </td>
				     </tr>
				     <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001b") %><!-- Word套红模板字段 -->
				    	</td>
					    <td class="FieldValue">
						<%
                          //List list = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
					      itObj = list.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="wordRedTemplate" id="wordRedTemplate" onChange="">
					        <option value=""></option>
					        <%
					          while(itObj.hasNext()){
					             Formfield formfieldObj = (Formfield) itObj.next();
					             if (formfieldObj.getHtmltype().equals(6)) {
					            	 if (formfieldObj.getFieldtype()!=null && "4028803221e277070121e2997e470003,40282d8629d9bbbf0129d9eabff00087".indexOf(formfieldObj.getFieldtype())>-1) {
					          %>
					        <option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getWordRedTemplate())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getLabelname())%></option>
			                <%
			                  }}}
			                %>
					      </select><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001c") %><!-- （用于公文套红时用的可选模板） -->
                        </td>
				     </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450002") %><!-- 流转文档名称 -->
				    	</td>
					    <td class="FieldValue">
						<%
					      iteratorObj = list.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="worddocname" id="worddocname" onChange="">
					        <option value=""></option>
					        <%
					          while(iteratorObj.hasNext()){
					             Formfield formfieldObj = (Formfield) iteratorObj.next();
					          %>
					        <option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getWorddocname())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getLabelname())%></option>
			                <%
			                  }
			                %>
					      </select>
                        </td>
				     </tr>
				      <tr>
				    	<td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b450003") %><!-- 流转文档分类 -->
				    	</td>
					    <td class="FieldValue">
                        <button  type="button" class=Browser id="button_4028d80f19b18c860119b263878c0072" name="button_4028d80f19b18c860119b263878c0072" onclick="javascript:getBrowser('/base/category/categorybrowser.jsp','worddocurl','worddocurlspan','1')"></button><input type="hidden" id="worddocurl" name="worddocurl" value="<%=nodeinfo.getWorddocurl()%>"  style='width: 288px; height: 17px'  ><span id="worddocurlspan" name="worddocurlspan" ><%=StringHelper.null2String(categoryService.getCategoryById(StringHelper.null2String(nodeinfo.getWorddocurl())).getObjname())%></span>
				     </tr>
				   </table>
				    <table class="noborder">
                  	<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>
				     <tr><!-- 公文是否可编辑 -->
				    	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001d") %><!-- 公文可编辑 --></td>
					    <td class="FieldValue">
                        <input type="checkbox" value="1" id="doccanedit" name="doccanedit" <%if(StringHelper.null2String(nodeinfo.getDocCanEdit()).equalsIgnoreCase("1"))out.print("checked"); %>/>
				     </tr>
				     <tr><!-- 是否保留痕迹 -->
				    	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001e") %><!-- 是否保留痕迹 --></td>
					    <td class="FieldValue">
                        <input type="checkbox" value="1" id="isDocVestige" name="isDocVestige" <%if(StringHelper.null2String(nodeinfo.getIsDocVestige()).equalsIgnoreCase("1"))out.print("checked"); %>/>
				     </tr>
				     <tr>
				     <td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b47001f") %><!-- 公文套红模板字段 -->
				    	</td>
					    <td class="FieldValue">
						<%
                          //List list = formfieldService.getAllFieldByFormId(workflowinfo.getFormid());
					      itObj = list.iterator();
					    %>
						 <select class="inputstyle2" style="dispaly:none" name="wfRedTemplate" id="wfRedTemplate" onChange="">
					        <option value=""></option>
					        <%
					          while(itObj.hasNext()){
					             Formfield formfieldObj = (Formfield) itObj.next();
					             if (formfieldObj.getHtmltype().equals(6)) {
					            	 if (formfieldObj.getFieldtype()!=null && "4028803221e277070121e2997e470003,40282d8629d9bbbf0129d9eabff00087".indexOf(formfieldObj.getFieldtype())>-1) {
					          %>
					        <option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getWfRedTemplate())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getLabelname())%></option>
			                <%
			                  }}}
			                %>
					      </select>
                        </td>
				     </tr>
                         <tr>
				     <td class="FieldName" nowrap>
                             <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470020") %><!-- 流程图显示方式 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="flowchartmethod" id="flowchartmethod" onChange="">
                             <%
                              String sel0="";
                              String sel1="";
                              String sel2="";
                                 if(nodeinfo.getFlowchartmethod()==1){
                                     sel1="selected";
                                 }else if(nodeinfo.getFlowchartmethod()==2){
                                     sel2="selected";
                                 }else {
                                     sel0="selected";
                                 }
                             %>
					        <option value="0" <%=sel0%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470021") %><!-- Tab页 --></option>
                             <option value="1" <%=sel1%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470022") %><!-- 按钮 --></option>
                             <option value="2" <%=sel2%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470023") %><!-- 不显示 --></option>
					      </select>
                        </td>
				     </tr>
                         <tr>
				     <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470024") %><!-- 流程流转显示方式 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="pflowmethod" id="pflowmethod" onChange="">
                             <%
                                String selp0="";
                              String selp1="";
                              String selp2="";
                                 if(nodeinfo.getPflowmethod()==1){
                                     selp1="selected";
                                 }else if(nodeinfo.getPflowmethod()==2){
                                     selp2="selected";
                                 }else {
                                     selp0="selected";
                                 }
                             %>
					        <option value="0" <%=sel0%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470021") %><!-- Tab页 --></option>
                             <option value="1" <%=sel1%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470022") %><!-- 按钮 --></option>
                             <option value="2" <%=sel2%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470023") %><!-- 不显示 --></option>
					      </select>
                        </td>
				     </tr>
                        <tr>
				     <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470025") %><!-- 导入明细记录显示方式 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="importDetail" id="importDetail" onChange="">
                             <%
                                String importDetail0="";
                              String importDetail1="";
                              String importDetail2="";
                                 if(nodeinfo.getImportDetail()==1){
                                     importDetail1="selected";
                                 }else if(nodeinfo.getImportDetail()==2){
                                     importDetail2="selected";
                                 }else {
                                     importDetail0="selected";
                                 }
                             %>
					        <option value="0" <%=importDetail0%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470021") %><!-- Tab页 --></option>
                             <option value="1" <%=importDetail1%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470022") %><!-- 按钮 --></option>
                             <option value="2" <%=importDetail2%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470023") %><!-- 不显示 --></option>
					      </select>
                        </td>
				     </tr>
                        <tr>
				     <td class="FieldName" nowrap>
                          <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470026") %><!-- 是否允许转发 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="isforward" id="isforward" onChange="">
                             <%
                              String isForward0="";
                              String isForward1="";
                                 if(nodeinfo.getIsforward()==0){
                                   isForward0="selected";
                                 }else{
                                    isForward1="selected";
                                 }
                             %>
					        <option value="1" <%=isForward1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %><!-- 是 --></option>
                             <option value="0" <%=isForward0%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %><!-- 否 --></option>
					      </select>
                        </td>
				     </tr>
                        <tr <%if(!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")){%> style="display:none" <%}%>>
				     <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470027") %><!-- 权限列表显示方式 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="plistmethod" id="plistmethod" onChange="">
                             <%
                                  String plistsel0="";
                                 String plistsel1="";
                                 if(nodeinfo.getPlistmethod()==1){
                                     plistsel1="selected";
                                 }else {
                                     plistsel0="selected";
                                 }
                             %>
					        <option value="0" <%=plistsel0%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470021") %><!-- Tab页 --></option>
                             <option value="1" <%=plistsel1%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470022") %><!-- 按钮 --></option>
					      </select>
                        </td>
				     </tr>
                        <tr <%if(!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")){%> style="display:none" <%}%>>
				     <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470028") %><!-- 权限共享显示方式 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="sharepmethod" id="sharepmethod" onChange="">
                             <%
                                String sharepsel0="";
                                 String sharepsel1="";
                                 if(nodeinfo.getSharepmethod()==1){
                                     sharepsel1="selected";
                                 }else {
                                     sharepsel0="selected";
                                 }
                             %>
					        <option value="0" <%=sharepsel0%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470021") %><!-- Tab页 --></option>
                             <option value="1" <%=sharepsel1%>><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470022") %><!-- 按钮 --></option>
					      </select>
                        </td>
				     </tr>
           			<tr>
				     <td class="FieldName" nowrap>
                         <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b470029") %><!-- 签字意见栏是否默认展开 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2" style="dispaly:none" name="isrexpand" id="isrexpand" onChange="">
                             <%
                              String isrexpand0="";
                              String isrexpand1="";
                                 if(nodeinfo.getIsrexpand()==0){
                                   isrexpand0="selected";
                                 }else{
                                    isrexpand1="selected";
                                 }
                             %>
					        <option value="1" <%=isrexpand1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %><!-- 是 --></option>
                             <option value="0" <%=isrexpand0%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %><!-- 否 --></option>
					      </select>
                        </td>
				     </tr>                
                           <tr>
				     <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b48002b") %><!-- 签字意见是否必填 -->
				    	</td>
					    <td class="FieldValue">
						 <select class="inputstyle2"  name="remarkRequired" id="remarkRequired" onChange="">
                             <%
                              String remarkRequired0="";
                              String remarkRequired1="";
                                 if(nodeinfo.getRemarkRequired()==0){
                                   remarkRequired0="selected";
                                 }else{
                                    remarkRequired1="selected";
                                 }
                             %>
					        <option value="1" <%=remarkRequired1%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d13003000c") %><!-- 是 --></option>
                             <option value="0" <%=remarkRequired0%>><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6d19cf5000d") %><!-- 否 --></option>
					      </select>
                        </td>
				     </tr>
				     <tr><!-- 附件是否可编辑 -->
				    	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883a039aedb120139aedb14850000") %><!--  附件是否可编辑 --></td>
					    <td class="FieldValue">
                        <input type="checkbox" value="1" name="attachcanedit" <%if(StringHelper.null2String(nodeinfo.getAttachCanEdit()).equalsIgnoreCase("1"))out.print("checked"); %>/>
				     </tr>
                  </table>
				<table class="noborder">
					<colgroup>
					   <col width="30%">
					   <col width="70%">
				    </colgroup>
					<tr>
				    	<td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b48002c") %><!-- 布局中签字意见显示样式 -->：</td>
					    <td class="FieldValue">
					    <textarea name="col1" id="col1" rows="3" class="InputStyle" style="width:100%;"><%=StringHelper.null2String(nodeinfo.getCol1())%></textarea>
					    <%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b48002d") %><!-- 布局中加 -->{requestlog}<%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b48002e") %><!-- 显示签字意见到布局 --><br/><%=labelService.getLabelNameByKeyId("402883d934d5d70a0134d5d70b48002f") %><!-- 默认样式为 -->：&lt;td width=&quot;30%&quot;&gt;{message}&lt;/td&gt;&lt;td&gt;{operator}&lt;/td&gt;&lt;td&gt;{qianzhang}&lt;/td&gt;&lt;td&gt;{Datetime}&lt;/td&gt;&lt;td&gt;{date}&lt;/td&gt;&lt;td&gt;{time}&lt;/td&gt;&lt;td&gt;{opertype}&lt;/td&gt;&lt;td&gt;{point}&lt;/td&gt;
					</td>
				</tr>
				</table>
          <%--<table class="noborder">--%>
            <%--<colgroup>--%>
               <%--<col width="30%">--%>
               <%--<col width="70%">--%>
            <%--</colgroup>--%>
				<%--<tr><!--  是否添加公文红头 -->--%>
					<%--<td class="FieldName" nowrap>--%>
                         <%--是否添加公文红头--%>
					<%--</td>--%>
					<%--<td class="FieldValue">--%>
					   <%--<input type='checkbox' name='hasworddochead' value="<%=StringHelper.null2String(nodeinfo.getWorddochead()).equals("")?0:1%>" <% if (!StringHelper.null2String(nodeinfo.getWorddochead()).equals("")){%><%="checked"%><%}%> onClick="javascript:onCheck('hasworddochead')" />--%>
					<%--</td>--%>
				<%--</tr>--%>
		  <%--</table>--%>

                  <%--<table id="worddocheadtable" <% if (StringHelper.null2String(nodeinfo.getWorddochead()).equals("")){%>style="display:none"<%}%> class="noborder">--%>
                  	<%--<colgroup>--%>
					   <%--<col width="30%">--%>
					   <%--<col width="70%">--%>
				    <%--</colgroup>--%>
				      <%--<tr>--%>
				    	<%--<td class="FieldName" nowrap>--%>
                             <%--红头文字生成字段--%>
				    	<%--</td>--%>
					    <%--<td class="FieldValue">--%>
						<%--<%--%>
					      <%--Iterator iterator = list.iterator();--%>
					    <%--%>--%>
						 <%--<select class="inputstyle2" style="dispaly:none" name="worddochead" id="worddochead" onChange="">--%>
					        <%--<option value=""></option>--%>
					        <%--<%--%>
					          <%--while(iterator.hasNext()){--%>
					             <%--Formfield formfieldObj = (Formfield) iterator.next();--%>
					          <%--%>--%>
					        <%--<option value="<%=StringHelper.null2String(formfieldObj.getId())%>" <%if (StringHelper.null2String(formfieldObj.getId()).equals(nodeinfo.getWorddochead())){%> <%="selected"%> <%}%>><%=StringHelper.null2String(formfieldObj.getFieldname())%></option>--%>
			                <%--<%--%>
			                  <%--}--%>
			                <%--%>--%>
					      <%--</select>--%>
                        <%--</td>--%>
				     <%--</tr>--%>
                  <%--</table>--%>

		</form>

<script language="javascript">
jQuery(function(){
	jQuery("#rejectnode").multiselect({
		minWidth: 400,
		selectedList: 100,
		noneSelectedText: '',
		checkAllText: '全选',
		uncheckAllText: '全不选'
	});
});

function getJspBrowser(url,inputname,inputspan,isneed){
	id = window.showModalDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url,window,"dialogHeight:600px;dialogwidth:800px");
	if (id!=null) {
		if (id != '0') {
			document.getElementById(inputname).value = id;
			document.getElementById(inputspan).innerHTML = id;
		}else {
			document.getElementById(inputname).value = "";
			if (isneed="0"){
				document.getElementById(inputspan).innerHTML = ""
			}else{
				document.getElementById(inputspan).innerHTML = "<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>"
			}
		}
	}
}

function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.getElementById(inputname).value = id[0];
		document.getElementById(inputspan).innerHTML = id[1];
    }else{
		document.getElementById(inputname).value = '';
		if (isneed=='0')
		document.getElementById(inputspan).innerHTML = '';
		else
		document.getElementById(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
function temporarycheck(obj){
    if(obj.checked){
        document.getElementById("istemporary").value=1;
        document.getElementById("istemporarytextspan").style.display='';
    } else{
        document.getElementById("istemporary").value=0;
        document.getElementById("istemporarytextspan").style.display='none';
    }

}
function temporarycheck2(obj){
    if(obj.checked){
        document.getElementById("istemporary2").value=1;
       document.getElementById("istemporarytext2span").style.display='';
    } else{
        document.getElementById("istemporary2").value=0;
        document.getElementById("istemporarytext2span").style.display='none';

    }

}
function temporarycheck3(obj){
    if(obj.checked){
        document.getElementById("istemporary3").value=1;
        document.getElementById("istemporarytext3span").style.display='';
    } else{
        document.getElementById("istemporary3").value=0;
        document.getElementById("istemporarytext3span").style.display='none';

    }

}
function isForceFinishCheck(obj){
    if(obj.checked){
        document.getElementById("isForceFinish").value=1;
        document.getElementById("isForceFinishspan").style.display='';
    } else{
        document.getElementById("isForceFinish").value=0;
        document.getElementById("isForceFinishspan").style.display='none';
    }
}

function onStampCheck(){
   if(document.getElementById("isstamp").checked){
       document.getElementById("stampfieldtr").style.display=''
      document.getElementById("isstamp").value=1;
   }else{
       document.getElementById("stampfieldtr").style.display='none'
      document.getElementById("isstamp").value=0;
   }
}
function onPrintCheck(){
   if(document.getElementById("isprint").checked){
      document.getElementById("isprint").value=1;
   }else{
      document.getElementById("isprint").value=0;
   }
}
function timeouttypeChange(){
  var timeouttype = document.getElementById("timeouttype").value;
  var timeoutfieldidtr = document.getElementById("timeoutfieldidtr");//超时节点
  var timeoutstart=$("#timeoutstart").val();//超时起始时间
  
  var timeoutfieldid=$("#timeoutfieldid");//整型字段
  var timeoutfieldiddate=$("#timeoutfieldiddate");//日期字段
  
  var timeoutvalue=$("#timeoutvalue");//整型值
  var timeoutvaluedate=$("#timeoutvaluedate");//日期值
  var timeoutvaluedate_span=$("#timeoutvaluedate_span");
  
  if (timeouttype=="0") {
    timeoutfieldidtr.style.display='none';
    if(timeoutstart=="2"){
    	timeoutvalue.attr("disabled","disabled");
    	timeoutvalue.attr("style","display:none");
    	
    	timeoutvaluedate.removeAttr("disabled");
    	timeoutvaluedate.removeAttr("style");
    	timeoutvaluedate_span.removeAttr("style");
    }else{
    	timeoutvalue.removeAttr("disabled");
    	timeoutvalue.removeAttr("style");
    	
    	timeoutvaluedate.attr("disabled","disabled");
    	timeoutvaluedate.attr("style","display:none");
    	timeoutvaluedate_span.attr("style","display:none");
    }
  }else if (timeouttype=="1") {
    timeoutfieldidtr.style.display='';
    timeoutvalue.attr("style","display:none");
    timeoutvaluedate.attr("style","display:none");
    timeoutvaluedate_span.attr("style","display:none");
    if(timeoutstart=="2"){
    	timeoutfieldid.attr("disabled","disabled");
    	timeoutfieldid.attr("style","display:none");
    	
    	timeoutfieldiddate.removeAttr("disabled");
    	timeoutfieldiddate.removeAttr("style");
    }else{
    	timeoutfieldid.removeAttr("disabled");
    	timeoutfieldid.removeAttr("style");
    	
    	timeoutfieldiddate.attr("disabled","disabled");
    	timeoutfieldiddate.attr("style","display:none");
    }
  }
}
function nodeTypechange(){
  var nodeType = document.getElementById("nodetype").value;
  var isrejecttr = document.getElementById("isrejecttr");//是否允许回退
  var rejectnodetr = document.getElementById("rejectnodetr");//退回节点 
  var rejectnode = document.getElementById("rejectnode");//退回节点 select
  var trtemporarynode = document.getElementById("trtemporary"); //是否显示会签人
  var trtemporarynode2 = document.getElementById("trtemporary2"); //是否显示非会签人
  var trtemporarynode3 = document.getElementById("trtemporary3"); //是否显示移交
  var trisForceFinish = document.getElementById("trisForceFinish"); //是否显示强制归档

  var refworkflowidytr = document.getElementById("refworkflowidytr");//相关流程
  var refnodeidtr = document.getElementById("refnodeidtr");  //相关节点
  var outmappingtr = document.getElementById("outmappingtr"); //输出参数列表
  var inmappingtr = document.getElementById("inmappingtr"); //输入参数列表
  
  var isdiscautoflowtr = document.getElementById("isdiscautoflowtr"); //非相邻节点自动流转
  var isautoflowtr = document.getElementById("isautoflowtr"); //邻节点自动流转
  if (nodeType=="1") {
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     rejectnode.style.display='none';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';
     trtemporarynode.style.display='none';
     trtemporarynode2.style.display='none';
     trtemporarynode3.style.display='none';
     //trisForceFinish.style.display='none';
     isdiscautoflowtr.style.display='none';
     isautoflowtr.style.display='none';
  }
  if (nodeType=="2") {
     isrejecttr.style.display='';
     rejectnodetr.style.display='';
     //rejectnode.style.display='';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';
     trtemporarynode.style.display='';
     trtemporarynode2.style.display='';
     trtemporarynode3.style.display='';
     trisForceFinish.style.display='';
     isdiscautoflowtr.style.display='block';
     isautoflowtr.style.display='block';
  }
  if (nodeType=="3") {
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     rejectnode.style.display='none';
     refworkflowidytr.style.display='';
     refnodeidtr.style.display='';
     outmappingtr.style.display='';
     inmappingtr.style.display='';
     trtemporarynode.style.display='none';
     trtemporarynode2.style.display='none';
     trtemporarynode3.style.display='none';
     trisForceFinish.style.display='none';
     isdiscautoflowtr.style.display='block';
     isautoflowtr.style.display='block';

  }
  if (nodeType=="4") {
     isrejecttr.style.display='none';
     rejectnodetr.style.display='none';
     rejectnode.style.display='none';
     refworkflowidytr.style.display='none';
     refnodeidtr.style.display='none';
     outmappingtr.style.display='none';
     inmappingtr.style.display='none';
     trtemporarynode.style.display='none';
     trtemporarynode2.style.display='none';
     trtemporarynode3.style.display='none';
     trisForceFinish.style.display='none';
     isdiscautoflowtr.style.display='none';
     isautoflowtr.style.display='none';

  }  
 }
 
//提醒类型
function changeType(){
	var $ = jQuery;
	var remindObj=document.getElementById("remindtype");
	var divSelectNotify = document.getElementById("divSelectNotify");
	var divForceNotify = document.getElementById("divForceNotify");
	divSelectNotify.style.display = 'none';
	divForceNotify.style.display = 'none';
	
	var isemail=$("[name=isemail]");
	var issms=$("[name=issms]");
	var isrtx=$("[name=isrtx]");
    var ispopup=$("[name=ispopup]");
    
    var selemail=$("[name=selemail]");
    var selsms=$("[name=selsms]");
    var selrtx=$("[name=selrtx]");
    var selpopup=$("[name=selpopup]");
    if (remindObj.value=='4028819d0e521bf9010e5238bec2000c'){ //4028819d0e521bf9010e5238bec2000c为不提醒
    	
    	isemail.removeAttr("checked");
    	issms.removeAttr("checked");
    	isrtx.removeAttr("checked");
        ispopup.removeAttr("checked");
        selemail.removeAttr("checked");
    	selsms.removeAttr("checked");
    	selrtx.removeAttr("checked");
        selpopup.removeAttr("checked");
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000e'){//强制提醒
  	    divForceNotify.style.display = 'inline';   	
        selemail.removeAttr("checked");
    	selsms.removeAttr("checked");
    	selrtx.removeAttr("checked");
        selpopup.removeAttr("checked");
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000d'){//选择提醒
 		divSelectNotify.style.display = 'inline';
        isemail.removeAttr("checked");
    	issms.removeAttr("checked");
    	isrtx.removeAttr("checked");
        ispopup.removeAttr("checked");
  	}
     setCheck('isemail');
	 setCheck('issms');
	 setCheck('ispopup');
	 setCheck('isrtx');
	 setCheck('selemail');
	 setCheck('selsms');
	 setCheck('selpopup');
	 setCheck('selrtx');
}

function setCheck(checkname){
	var $ = jQuery;
	var obj = $("[name="+checkname+"]");
	if(obj.attr("checked")=="checked"||obj.attr("checked")==true){
		obj.val("1");
	}else{
		obj.val("0");
	}
}

function onCheck(checkName){ 
	//是撤回
  <%--if (checkName=="col3") {
     if (document.getElementById("col3").checked){
       document.getElementById("col3").value='1';
     }else{
       document.getElementById("col3").value='0';    
     } 
  }
  if (checkName=="col4") {
     if (document.getElementById("col3").checked){
       document.getElementById("col4").value='1';
     }else{
       document.getElementById("col4").value='0';    
     } 
  }
  if (checkName=="col5") {
     if (document.getElementById("col5").checked){
       document.getElementById("col5").value='1';
     }else{
       document.getElementById("col5").value='0';    
     } 
  }--%>
  //是否ExcelExp
  if (checkName =="isexcelexp") {
	  setCheck(checkName);
  }
  //是否回退
  if (checkName =="isreject"){
  //  test("oncheck");
     var rejectnodetr = document.getElementById("rejectnodetr"); 
     var rejectnode = document.getElementById("rejectnode"); 
     if (document.getElementById("isreject").checked){
       rejectnodetr.style.display='';
       //rejectnode.style.display='';
       document.getElementById("isreject").value='1';
     }else{
       rejectnodetr.style.display='none';
       rejectnode.style.display='none';
       document.getElementById("isreject").value='0';    
     }
     checkTime(); 
  }

 //强制提醒
  if (checkName=="isemail"||checkName=="issms"||checkName=="ispopup"||checkName=="isrtx") {
    setCheck(checkName);
  }

  //选择提醒
  if (checkName=="selemail"||checkName=="selsms"||checkName=="selpopup"||checkName=="selrtx") {
     setCheck(checkName);
  }

 //是否超时
  if (checkName=="istimeout"){
    var timeouttable = document.getElementById("timeouttable");
    if (document.getElementById("istimeout").checked) {
       timeouttable.style.display = '';
       document.getElementById("istimeout").value='1'; 
    }else{
       timeouttable.style.display = 'none';
       document.getElementById("istimeout").value='0';       
    }  
  }   
	//是否需要生成html文档
	if (checkName=="hashtmldoc"){
  		var htmldoctable = document.getElementById("htmldoctable");
  		<%if(!StringHelper.null2String(nodeinfo.getNodetype()).equals("4")){%>
	  		if (document.getElementById("ishtmldoc").checked) {
	     		htmldoctable.style.display = 'block';
	     		document.getElementById("ishtmldoc").value='1';
	  		}else{
	     		htmldoctable.style.display = 'none';
	     		document.getElementById("ishtmldoc").value='0';
  			}
  		<%}else{%>
  			if(document.getElementById("ishtmldoc").value!=0){
	  			htmldoctable.style.display = 'block';
	  		}
	  		else{
	  			htmldoctable.style.display = 'none';
	  		}
  		<%}%>
	}
  //是否需要生成流转文档
  if (checkName=="hasworddoc"){
    var worddoctable = document.getElementById("worddoctable");
    if (document.getElementById("hasworddoc").checked) {
       worddoctable.style.display = '';
       document.getElementById("hasworddoc").value='1';
       checkInput("wordmoduleid","wordmoduleidspan");
    }else{
       worddoctable.style.display = 'none';
       document.getElementById("hasworddoc").value='0';
    }
  }
  //是否添加公文红头
  if (checkName=="hasworddochead"){
    var worddocheadtable = document.getElementById("worddocheadtable");
    if (document.getElementById("hasworddochead").checked) {
       worddocheadtable.style.display = '';
       document.getElementById("hasworddochead").value='1';
    }else{
       worddocheadtable.style.display = 'none';
       document.getElementById("hasworddochead").value='0';
    }
  }
  if (checkName=="huiqian"||checkName=="showinphone"||checkName=="hasten"||checkName=='isbatchapproval'){
   	setCheck(checkName);
  }

  //是否自动流转（非相邻节点）
  if (checkName=="isdiscautoflow"){
   if (document.getElementById("isdiscautoflow").checked) {
	    document.getElementById("isdiscautoflow").value='1';
	   //相邻节点自动流转不可选中
	   document.getElementById("isautoflow").checked =false;
	   document.getElementById("isautoflow").value='0';
    }else{
     document.getElementById("isdiscautoflow").value='0';
    }
  }
  //是否自动流转（相邻节点）
  if (checkName=="isautoflow"){
   if (document.getElementById("isautoflow").checked) {
     document.getElementById("isautoflow").value='1';
     //非相邻节点自动流转不可选中 
     document.getElementById("isdiscautoflow").checked = false;
     document.getElementById("isdiscautoflow").value='0';
    }else{
     document.getElementById("isautoflow").value='0';
    }
  }

  if (checkName=="iscrossds"){
   if (document.getElementById("iscrossds").checked) {
     document.getElementById("iscrossds").value='1';
     document.getElementById("crossds").style.display='';
    }else{
     document.getElementById("iscrossds").value='0';
     document.getElementById("crossds").style.display='none';
    }
  }
} 
function timeoutoptChange(){

  var timeoutopt = document.getElementById("timeoutopt").value;
  var timeoutloadidtr = document.getElementById("timeoutloadidtr");
  var timeoutloadid = document.getElementById("timeoutloadid");
   var col2span = document.getElementById("col2span");
   var customactionspan = document.getElementById("customactionspan");
  if (timeoutopt=="2"){
   // var timeoutloadidtr = document.getElementById("timeoutloadidtr");//重定向节点  
   timeoutloadidtr.style.display ="";
   timeoutloadid.style.display ="";
   col2span.style.display ="none";
  } else if(timeoutopt=="3"){
   timeoutloadidtr.style.display ="none";
   timeoutloadid.style.display ="none";
   col2span.style.display ="";
   customactionspan.style.display ="none";
   
   var timeoutstart=$("#timeoutstart").val();//超时起始时间
   var col2=$("#col2");
   var col2date=$("#col2date");
   if(timeoutstart=="2"){
	   col2.attr("disabled","disabled");
	   col2.attr("style","display:none");
	   col2date.removeAttr("disabled");
	   col2date.removeAttr("style");
   }else{
	   col2.removeAttr("disabled");
	   col2.removeAttr("style");
	   col2date.attr("disabled","disabled");
	   col2date.attr("style","display:none");
   }
  } else if (timeoutopt=="4") {
  	
	timeoutloadidtr.style.display ="none";
	timeoutloadid.style.display ="none";
	customactionspan.style.display ="";
	col2span.style.display ="none";
  }	else {
  	 timeoutloadidtr.style.display ="none";
   	 timeoutloadid.style.display ="none";
   	 col2span.style.display ="none";
   	 customactionspan.style.display ="none";
  }
  }
  function checkTime(){
	var timeoutstart =document.getElementById("timeoutstart");
	var timeoutunit  =  document.getElementById("timeoutunit");
	var timeoutunittr  =  document.getElementById("timeoutunittr");
    if (timeoutstart.value=="2"){
      timeoutunit.style.display ="none";
      timeoutunittr.style.display ="none";
    }else {
      timeoutunit.style.display ="";
      timeoutunittr.style.display ="";   
    }
    timeouttypeChange();
    timeoutoptChange();
    
	var timeoutstart_span1=$("#timeoutstart_span1");
	var timeoutstart_span2=$("#timeoutstart_span2");
	if(timeoutstart.value=="0"){
		timeoutstart_span1.removeAttr("style");
		timeoutstart_span2.attr("style","display:none");
	}else if(timeoutstart.value=="1"){
		timeoutstart_span1.attr("style","display:none");
		timeoutstart_span2.removeAttr("style");
	}else{
		timeoutstart_span2.attr("style","display:none");
		timeoutstart_span1.attr("style","display:none");
	}
}

function test(msg){
alert(msg);
}
function init(){   
  //alert(init);
  changeType();
  nodeTypechange();
  onCheck("isreject");
  onCheck("isemail");
  onCheck("issms");
  onCheck("isrtx");
  onCheck("istimeout");
  timeouttypeChange();
  
  timeoutoptChange();
  
  showOrHideEPTR();
}
 function onSubmit(){
	var ishtmldoc = document.getElementById("hasworddoc");
	checkfields = "";
	if (ishtmldoc && ishtmldoc.checked) {
		checkfields = "wordmoduleid,";
	}
   	checkfields+="objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   		if(!Ext.isSafari&&!Ext.isIE){
   	        window.parent.close();
   		} 
   		if(Ext.isSafari){
   				parent.win.close();
   	     }
 	}
}
function showOrHideEPTR(){
	var splittype = document.getElementById("splittype");
	var exclusivePriorityTR = document.getElementById("exclusivePriorityTR");
	if(splittype && exclusivePriorityTR){
		if(splittype.value == "2"){
			exclusivePriorityTR.style.display = "";
		}else{
			exclusivePriorityTR.style.display = "none";
		}
	}
}
</script>
  </body>
</html>