<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.base.security.model.Permissionrule"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysroleService"%>
<%@ page import="com.eweaver.base.security.model.Sysrole"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.DataService"%>

<%
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");

    PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
 
 	PermissiondetailService permissiondetailService = (PermissiondetailService)BaseContext.getBean("permissiondetailService");  
 	
 	HumresService humresService = (HumresService) BaseContext.getBean("humresService");

    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");

    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");

	OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");

	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");

	SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");
	
	String objid = StringHelper.null2String(request.getParameter("objid"));
	String objtable = StringHelper.null2String(request.getParameter("objtable")).trim();
	int istype = NumberHelper.string2Int(request.getParameter("istype"),0);
	
	if(!"402881e70be6d209010be75668750014".equals(eweaveruser.getId())){
		response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
		return;
	}

	
	int nodetype = 0;
	int refobjtype = 0;
	int isworkflowid = 0;
	if(objtable.equalsIgnoreCase("workflowinfo")){
		refobjtype = 1 ; //工作流相关；		
		isworkflowid = 1;
	}else if(objtable.equalsIgnoreCase("requestbase")){
		refobjtype = 1 ; //工作流相关；
		if(istype==1){
	 		Nodeinfo nodeinfo = nodeinfoService.get(objid);
	 		nodetype = nodeinfo.getNodetype().intValue();
	 	}else
	 		nodetype = 4;
		
	}else if(objtable.equalsIgnoreCase("docbase")||objtable.equalsIgnoreCase("doctype")){
		refobjtype = 2 ; //文档相关；


	}
		       

%>
<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%;display='none' ">
<TABLE width="100%" height="100%">
	<TR><TD align=center style="font-size: 36pt;">批量授权处理中......</TD></TR>
</TABLE>
</DIV>
<html>
  <head>
  	<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>
  	<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script Language="JavaScript">

	function getformfield(permtypeid){
		
       	DataService.getFormfieldForPermission(createList,permtypeid,'<%=objtable%>','<%=objid%>');
       	return true;
    }
    function createList(data)
	{
	    DWRUtil.removeAllOptions("FormfieldID");
	    DWRUtil.addOptions("FormfieldID", data,"id","labelname");
	}
	function getformfield2(permtypeid){
		
       	DataService.getFormfieldForPermission(createList2,permtypeid,'<%=objtable%>','<%=objid%>');
       	return true;
    }
    function createList2(data)
	{
	    DWRUtil.removeAllOptions("role_ziduid");
	    DWRUtil.addOptions("role_ziduid", data,"id","labelname");
	}
</script>
  </head>
     
  <body>
<!--页面菜单开始-->     
<%
pagemenustr += "{S,批量授权,javascript:doSave()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=mainform name=mainform action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=batchcreate" method=post onsubmit='return check_by_ShareType()'>
  <input type="hidden" name="istype" value="<%=istype %>">

		   <table class=noborder>
				<colgroup> 
					<col width="20%">
					<col width="80%">
				</colgroup>	
		        <tr class=Title>
					<th colspan=2 nowrap>选择对象</th>		        	  
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>	
		        
				<tr>
					<td class="FieldName" nowrap>
					   ObjTable
					 </td>
					<td class="FieldValue">    
						<input type="text" class="InputStyle2" style="width=20%" name="objtable" id="objtable" value="<%=objtable%>" /> 
						<span id=""/><%if(objtable.equals("")){ %><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle><%} %></span>
						<br/>流程: requestbase，文档: docbase，分类: uf_xxx
					</td>
				</tr>
				<!-- 
				<tr>
					<td class="FieldName" nowrap>
					   相关类型
					 </td>
					<td class="FieldValue"><input type="hidden" name="objtypeid" value=""/>
					<%
						String browserurl = "";
						if("docbase".equals(objtable)){
							browserurl = "/document/doctype/doctypebrowser.jsp";
						}else if("customer".equals(objtable)){
							browserurl = "/customer/customertype/customertypebrowser.jsp";
						}else if("product".equals(objtable)){
							browserurl = "/product/producttype/producttypebrowser.jsp";
						}else if("project".equals(objtable)){
							browserurl = "/customer/projecttype/projecttypebrowser.jsp";
						}else if("contract".equals(objtable)){
							browserurl = "/contract/contracttype/contracttypebrowser.jsp";
						}else if("assets".equals(objtable)){
							browserurl = "/assets/assetstype/assetstypebrowser.jsp";
						}else if("provider".equals(objtable)){
							browserurl = "/provider/providerype/providerypebrowser.jsp";
						}
						
					%>
						<button  class=Browser onclick="javascript:getBrowser('<%=browserurl %>','objtypeid','objtypeidspan','0');"></button>
						<span id="objtypeidspan"></span>
				   	</td>
				</tr>
				 -->
				<tr>
					<td class="FieldName" nowrap>
					   SQL
					</td>
					<td class="FieldValue">
						<TEXTAREA id="objsql" name="objsql" ROWS="3" COLS="100"></TEXTAREA>
						<span id=""/><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
						<br/>流程: select requestid as id from uf_work_innermessage where ...
						<br/>文档: select id from docbase where ...
						<br/>分类: select requestid as id from uf_xxx where ...
					</td>
				</tr>	
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>	
			</table>
  <TABLE class=ViewForm>

    <COLGROUP>
		<COL width="50%">
  		<COL width="50%">
    </COLGROUP>
    <TBODY>
      <TR class=Title><TH colSpan=2>
      选择权限:
      </TH></TR>
      <TR class=Spacing><TD class=Line1 colSpan=2>
      </TD></TR>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>		        	  
		        </tr>	
      <TR><TD class=FieldValue colSpan=2>
        <SELECT class=InputStyle name=ShareType onchange="onChangeShareType()">
        <%
        	List list = selectitemService.getSelectitemList("402881e60bf4f747010bf4fcad5b0005",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);        		
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>          
        </SELECT>
      </TD></TR>
      <TR><TD class=FieldValue colspan=2>  
       <span id=showRoleType name=showRoleType style="display:''">
          <%=labelService.getLabelName("402881ea0bf63f28010bf6428add0005")%>:
          <SELECT  class=InputStyle name=RoleType onchange="onChangeShareType()">
          <option value="0"><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option>
          <option value="1" selected ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
          </SELECT>
        </span>
        <span id=showOrgObjType name=showOrgObjType style="display:''">
          <%=labelService.getLabelName("402881ea0bf63f28010bf64328a40007")%>:
          <SELECT  class=InputStyle name=OrgObjType onchange="onChangeShareType()">
           <%
        	list = selectitemService.getSelectitemList("402881ea0bf559c7010bf55e479f0013",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);     
        		String optionvalue = StringHelper.null2String(_selectitem.getId());
        		//非工作流相关不显示工作流节点
        		if(refobjtype !=1 && optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf5608b560015"))
        			continue;
        			
        		//文档相关的只显示文档字段
        		String optdesc = StringHelper.null2String(_selectitem.getObjdesc());
        		if(refobjtype==2 && !optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf5608b560014") && optdesc.indexOf("{402881e70bc70ed1010bc710b74b000d}")==-1)
        			continue;
        		//todo...项目相关的只显示项目，客户，产品。。。。


        %>	
        
          <option value="<%=optionvalue%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>   
          </SELECT>
        </span>
        
         <span id=showUserObjType name=showUserObjType style="display:''">
          <%=labelService.getLabelName("402881ea0bf9ae97010bf9b148fd0005")%>:
          <SELECT class=InputStyle name=UserObjType onchange="onChangeShareType()">
            <%
        	list = selectitemService.getSelectitemList("402881ea0bf559c7010bf55b290a0005",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);       
        		String optionvalue = StringHelper.null2String(_selectitem.getId());
        		//非工作流相关不显示工作流节点
        		if(refobjtype !=1 && optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf55ddf210007"))
        			continue;  
        			
        		//文档相关的只显示文档字段
        		String optdesc = StringHelper.null2String(_selectitem.getObjdesc());
        		if(refobjtype==2 && !optionvalue.equalsIgnoreCase("402881ea0bf559c7010bf55ddf210006") && optdesc.indexOf("{402881e70bc70ed1010bc710b74b000d}")==-1)
        			continue;
        		//todo...项目相关的只显示项目，客户，产品。。。。


        			  		
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>   
          </SELECT>
        </span>
        
         <span id=showStationObjType name=showStationObjType style="display:''">
          <%=labelService.getLabelName("402881e510e569090110e56e72330003")%>:
          <SELECT class=InputStyle name=StationObjType onchange="onChangeShareType()">
            <%
        	list = selectitemService.getSelectitemList("297e828210f211130110f21a5ae00006",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);       
        		String optionvalue = StringHelper.null2String(_selectitem.getId());       			
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>   
          </SELECT>
        </span>
        
        <span  name="showStationIDs" id="showStationIDs"> 
	        <BUTTON type="button" class=Browser style="display:''" onclick="javascript:getBrowser('/humres/base/stationlist.jsp?type=browser','StationIDs','StationIDsSpan','1');"></BUTTON>
	        <INPUT type=hidden name="StationIDs" id ="StationIDs"  value="">   
	        <SPAN id=StationIDsSpan name=StationIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
        </span>
        <span  name="showUserIDs" id="showUserIDs"> 
	        <BUTTON type="button" class=Browser style="display:''" onclick="onShowMutiResource('UserIDsSpan','UserIDs')" ></BUTTON>
	        <INPUT type=hidden name="UserIDs" id ="UserIDs"  value="">   
	        <SPAN id=UserIDsSpan name=UserIDsSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>
            
        <span  name="showOrgObjID" id="showOrgObjID"> 
	        <BUTTON type="button" class=Browser style="display:''" onClick="onshowOrgObjID('OrgObjIDSpan','OrgObjID')"  ></BUTTON>
	        <INPUT type=hidden name="OrgObjID" id ="OrgObjID" value="">       
	         <SPAN id=OrgObjIDSpan name=OrgObjIDSpan><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN>
         </span>
        <span id=showrelatedsharename name=showrelatedsharename></span>
        
     
        <!--  
        //以下为工作流表单字段
        //文档字段
        -->
        <span id=showWFOperators name=showWFOperators style="display:''">
          <%=labelService.getLabelName("402881ea0bf9ae97010bf9b5aeb90007")%>:
          <SELECT class=InputStyle name=WFOperatorNodeID onchange="onChangeShareType()">
         <%
         	if(refobjtype==1 && isworkflowid ==0 ){
         		Nodeinfo nodeinfo = nodeinfoService.get(objid);
         		if(nodeinfo != null){
         			list = nodeinfoService.getNodelistByworkflowid(nodeinfo.getWorkflowid());
         			for(int i=0;i < list.size();i++){
         				Nodeinfo _nodeinfo =(Nodeinfo)list.get(i);
         %>
         				<option value="<%=_nodeinfo.getId()%>"><%=StringHelper.null2String(_nodeinfo.getObjname())%></option>
         <%
         			}
         		}
         	}else if(refobjtype==1 && isworkflowid ==1 ){
         			list = nodeinfoService.getNodelistByworkflowid(objid);
         			for(int i=0;i < list.size();i++){
         				Nodeinfo _nodeinfo =(Nodeinfo)list.get(i);
         %>
         				<option value="<%=_nodeinfo.getId()%>"><%=StringHelper.null2String(_nodeinfo.getObjname())%></option>
         <%
         			}
         	}
         	%>
          </SELECT>
        </span>
         <span id=showFormfileds name=showFormfileds style="display:''">
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa12dfb80005")%>:
          <SELECT class=InputStyle name=FormfieldID>
           
          </SELECT>
        </span>        
      </TD>
      </tr>
      <tr>      
      <TD class=FieldValue colspan=2>
      <span id=showOrgShareType name=showOrgShareType style="display:''">       
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")%>:
          <SELECT class=InputStyle name=OrgShareType onchange="onChangeShareType('OrgShareType')">     
             
            <%
        	list = selectitemService.getSelectitemList("402881ea0bfa0b45010bfa18ccee0009",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);        		
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>   
		</SELECT>
        </span>
        
        <span id=showOrgReftype name=showOrgReftype style="display:''"> 
          <%=labelService.getLabelName("297e828210f211130110f23717df000a")%>:
          		<SELECT class=InputStyle name=OrgReftype onchange="onChangeShareType()"> 
						<%
				        	list = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
				        	for(int i=0;i<list.size();i++){
				        		Selectitem _selectitem = (Selectitem)list.get(i);        		
				        %>
				          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
				          <%}%>     
				</SELECT>        
        </span> 
        
        <span id=showRoleObjID name=showRoleObjID style="display:''"> 
          <%=labelService.getLabelName("402881ea0bfa67d7010bfa68fe0b0005")%>:
          		<SELECT class=InputStyle name=RoleType2 onchange="onChangeShareType()"> 
						<%
				        	list = selectitemService.getSelectitemList("4028819a0f16b8f1010f179d1c2c000e",null);
				        	for(int i=0;i<list.size();i++){
				        		Selectitem _selectitem = (Selectitem)list.get(i);        		
				        %>
				          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
				          <%}%>     
				</SELECT>        
        </span> 
        <span id=showrolename name=showrolename style="display:''">
        <BUTTON type="button" class=Browser style="display:''"  onclick="onshowRoleObjID('showrolename2','RoleObjID')" ></BUTTON>
        <INPUT type=hidden name="RoleObjID" id ="RoleObjID" value="">
        <span id=showrolename2 name=showrolename2 style="display:''"><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></span>
        </span>  
        <span id=role_zidu name=role_zidu style="display:'none'"> 
     			相关字段：

          		<SELECT class=InputStyle name=role_ziduid > 
    
				</SELECT>
		</span>
        
        
        <span id=showUserShareType name=showUserShareType style="display:''">
          <%=labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")%>:
          <SELECT class=InputStyle name=UserShareType onchange="onChangeShareType()"> 
          <%
        	list = selectitemService.getSelectitemList("402880151176095801117665f7c30009",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);        		
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%>           
	</SELECT>
        </span>
        
        <span id=showPositionType name=showPositionType style="display:''">
          岗位级别:
           <SELECT class=InputStyle name="position"> 
          <%
        	list = selectitemService.getSelectitemList("40288019120556350112058e3b92000c",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);        		
        %>	
        
          <option value="<%=_selectitem.getId()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%}%> 
          </SELECT>
        </span>
        <span id=showOrgUnitType name=showOrgUnitType style="display:''">
          <SELECT class=InputStyle name=OrgUnitType>        
	       <% 
	       
        	list = orgunittypeService.getOrgunittypeList();
        	for(int i=0;i<list.size();i++){
        		Orgunittype _orgunittype = (Orgunittype)list.get(i);        		
        %>	
        
          <option value="<%=_orgunittype.getId()%>"><%=StringHelper.null2String(_orgunittype.getObjname())%></option>
          <%}%>   
	</SELECT>
        </span>
        
        <span id=showOrgManager name=showOrgManager style="display:''">
          <SELECT class="InputStyle2"  name=OrgManager onchange="onChangeShareType()">      
          <option value="0" selected ><%=labelService.getLabelName("402881e70b774c35010b774cceb80008")%></option>
          <option value="1"><%=labelService.getLabelName("402881ea0bfa7679010bfa7948b20005")%></option>             
	</SELECT>
        </span>
        	
        <span id=showseclevel name=showseclevel style="display:''">
        <%=labelService.getLabelName("402881e70b774c35010b774cceb80008")%>:
        <INPUT type=text class="InputStyle2"  id=minseclevel name=minseclevel size=6 value="10">
        <SPAN id=seclevelimage name=seclevelimage><IMG src='<%= request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></SPAN> -&nbsp;<INPUT type=text class="InputStyle2"  id=maxseclevel name=maxseclevel size=6 value="">
        
        </span>
        
	
      </TD>
      </tr>
      
      <% if((refobjtype!=1 || nodetype==1 || nodetype == 4 || isworkflowid ==1)){%>
      <tr>
      <TD class=FieldValue colspan=2>   
        <%=labelService.getLabelName("402881ea0bfa7679010bfa8999a3001b")%>:
      <SELECT class="InputStyle2"  name=RightType>   
       <%
        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa83d68a0007",null);
        	for(int i=0;i<list.size();i++){
        		Selectitem _selectitem = (Selectitem)list.get(i);   
        		if("4028802319dace9e0119daf56710001d".equals(_selectitem.getId()) //提醒 
        				|| "40288035ed218a250120218c03515802".equals(_selectitem.getId()) //监控
        				|| "E958387905FA4CA2AA1F9D96CF380DC4".equals(_selectitem.getId())){//督办
        			continue;
        		}
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		//非类型设置不允许给创建权限。


        		if(optcode.equalsIgnoreCase("2") && (istype == 0 || nodetype == 4 || isworkflowid ==1))
        			continue;     		
        		if(!optcode.equalsIgnoreCase("2") && (nodetype == 1))
        			continue;
        				
        		if(!optcode.equalsIgnoreCase("3") && (isworkflowid == 1))
        			continue;
        		
        %>	
        
          <option value="<%=optcode%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
          <%
          }%>   
      </SELECT>
      </td>
      </tr>
      <%}%>

	      <tr id="trDocAttach" >
	      <TD class=FieldValue colspan=2>   
	        <%=labelService.getLabelName("402881ea0bfa7679010bfa8c18dc001d")%>:
	      <SELECT class="InputStyle2"  name=RightType2>   
	       <%
	        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa854d8a000e",null);
	        	for(int i=0;i<list.size();i++){
	        		Selectitem _selectitem = (Selectitem)list.get(i);        		
	        %>	
	        
	          <option value="<%=_selectitem.getObjdesc()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          <%}%>   
	      </SELECT>
	      </td>
	      </tr>

      
      <% if(refobjtype==1 && nodetype!= 1 && nodetype != 4 && isworkflowid == 0){%>
	      <tr>
	      <TD class=FieldValue colspan=2>   
	        <%=labelService.getLabelName("402881ea0bfa7679010bfa8c8765001f")%>:
	      <SELECT class="InputStyle2"  name=RightType3>   
	       <%
	        	list = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
	        	for(int i=0;i<list.size();i++){
	        		Selectitem _selectitem = (Selectitem)list.get(i);        		
	        %>	
	        
	          <option value="<%=_selectitem.getObjdesc()%>"><%=StringHelper.null2String(_selectitem.getObjname())%></option>
	          <%}%>   
	      </SELECT>
	      </td>
	      </tr>
      <%}
      if(refobjtype==1 && nodetype == 4){
      %>
      <input type="hidden" name="RightType3" value="3">
      <%}%>      
<TR><TD class=Line colSpan=2></TD></TR>
    </TBODY>
  </TABLE>
  

		</FORM>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>


<script language="javascript">
WeaverUtil.load(function(){
	onChangeShareType();
	
	//当objtable=docbase时显示文档附件操作类型
	var oObjTable = document.getElementById("objtable");
	var oTrDocAttach = document.getElementById("trDocAttach");
	oTrDocAttach.style.display = 'none';
	WeaverUtil.watch(oObjTable, function(){
		if(oTrDocAttach){
			oTrDocAttach.style.display = "docbase"==oObjTable.value ? "block" : "none";
		}
	})
});

function check_by_ShareType() {
    //alert(document.mainform.ShareType.value);
    if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80007" && document.mainform.UserObjType.value=="402881ea0bf559c7010bf55ddf210006") {
        return checkForm(mainform, "UserIDs","必填项不能为空！");
    }else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009" && document.all("showOrgObjID").style.display!="none"){
      
       return checkForm(mainform, "OrgObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e510efab3d0110efb21a700005" && document.mainform.StationObjType.value=="297e828210f211130110f21d99710009"){
      
       return checkForm(mainform, "StationIDs","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80008" || document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009") {
        return checkForm(mainform, "minseclevel","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f80009" && document.mainform.OrgObjType.value=="402881ea0bf559c7010bf5608b560014") {
        return checkForm(mainform, "OrgObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f8000c" && document.mainform.OrgObjType.value=="402881ea0bf559c7010bf5608b560014" && document.mainform.RoleType.value==1) {
        return checkForm(mainform, "RoleObjID","必填项不能为空！");
    } else if (document.mainform.ShareType.value == "402881e60bf4f747010bf4fec8f8000c" && document.all("RoleType2").value=="1") {
        return checkForm(mainform, "RoleObjID","必填项不能为空！");
    } else {
      
        return true;
    }
        
}

function doSave() {
	if(confirm("是否确定批量授权？")){
	   	checkfields="objtable,objsql";
	   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
	   	if(checkForm(mainform,checkfields,checkmessage)){
	   		if (check_by_ShareType()) {
				wait.style.display="";
			    document.mainform.submit();
			}
	   	}
	   	event.srcElement.disabled = false;
   	}
}

function recreate(){
	document.mainform.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=recreate";
	document.mainform.submit();
}

function onChangeShareType(from) {
    
	thisvalue=document.mainform.ShareType.value;
	
//	if (typeof(from)=='undefined'){
//	  document.mainform.OrgObjID.value="";
//	}
	
	
//	document.mainform.UserIDs.value="";
//	document.mainform.StationIDs.value="";
//	document.mainform.RoleObjID.value="";
	
//	document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>";
	
 	document.all("showrolename").style.display='none';
    document.all("role_zidu").style.display='none';
    
	document.all("showPositionType").style.display = 'none';	
   		
	if (thisvalue == "402881e60bf4f747010bf4fec8f80007") {
		_sharetype = document.all("UserObjType").value;
		if(_sharetype == "402881ea0bf559c7010bf55ddf210006"){	//指定人员 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = '';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
		//	document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"	
			document.all("showrolename").style.display = 'none';	 		
	 			 		
	 	}else if(_sharetype == "402881ea0bf559c7010bf55ddf210007"){	//流程操作者相关


		 	//需要将当前工作流的节点信息读取到下拉框中。。。。


		 
					 
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
		//	document.all("showrelatedsharename").innerHTML = ""	
				 		
	 			 		
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = '';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""		 
	 	}
    }else if (thisvalue == "402881e510efab3d0110efb21a700005") {
		_sharetype = document.all("StationObjType").value;
		if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"	
			document.all("showrolename").style.display = 'none';	 		
	 			 		
	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
		//	document.all("showrelatedsharename").innerHTML = ""	
			document.all("showrolename").style.display = 'none';	 		
	 			 		
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';			
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""		 
	 	}
    }
	else if (thisvalue == "402881e60bf4f747010bf4fec8f80008") {	//所有人+安全级别
	
					 
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = '';	 		
		//	document.all("showrelatedsharename").innerHTML = ""	
			document.all("showrolename").style.display = 'none';	
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f80009") {	//组织单元+安全级别+作用域

		
	    _sharetype = document.all("OrgObjType").value;
		if(_sharetype == "402881ea0bf559c7010bf5608b560014"){	//指定组织单元
		
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
	 		document.all("showOrgObjID").style.display = '';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showrolename").style.display = 'none';			
			//document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
			
	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 			
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 			
	 		document.all("showseclevel").style.display = '';
	 		
	 			document.all("showOrgManager").style.display = '';	
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else	 			
		 			document.all("showseclevel").style.display = 'none'; 
		 	
	 		
	 	}else if(_sharetype == "402881ea0bf559c7010bf5608b560015"){	//流程节点操作者相关组织单元


		
		 	//需要将当前工作流的节点信息读取到下拉框中。。。。


	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';			
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';	
			
	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 			
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 			
	 		document.all("showseclevel").style.display = '';
	 		
	 			document.all("showOrgManager").style.display = '';	
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else	 			
		 			document.all("showseclevel").style.display = 'none'; 
		 
	 	       
	 	
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


	 		
			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = '';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = '';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';			
	//		document.all("showrelatedsharename").innerHTML = ""
			document.all("showrolename").style.display = 'none';	
			
	 		document.all("showOrgShareType").style.display = '';
	 		_orgSharetype = document.all("OrgShareType").value;
	 		if(_orgSharetype == "402881ea0bfa0b45010bfa19f3bb000a" || _orgSharetype == "402881ea0bfa0b45010bfa19f3bb000b")
	 			document.all("showOrgUnitType").style.display = 'none';
	 		else	 			
	 			document.all("showOrgUnitType").style.display = '';
	 			
	 		
	 		if(_orgSharetype != "402881ea0bfa0b45010bfa19f3bb000a")
	 			document.all("showOrgReftype").style.display = '';
	 			
	 		document.all("showseclevel").style.display = '';
	 		
	 			document.all("showOrgManager").style.display = '';	
		 		_OrgManage = document.all("OrgManager").value;
		 		if(_OrgManage == 0 )
		 			document.all("showseclevel").style.display = '';
		 		else	 			
		 			document.all("showseclevel").style.display = 'none'; 	
		 }	 	
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000a") {	 //人员+经理	
		_sharetype = document.all("StationObjType").value;
	    _usersharetype = document.all("UserShareType").value;
		if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"	
			document.all("showrolename").style.display = 'none';		
			if(_usersharetype == "4028801511760958011176701f79000f")	 			
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';	  
	 		
	 		if(_usersharetype == "4028804112055e810112059ba0c10007")	 			
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';	  			
	 			 		
	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""	
			document.all("showrolename").style.display = 'none';	 		
	 		if(_usersharetype == "4028801511760958011176701f79000f")	 			
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';	  
	 			
	 		if(_usersharetype == "4028804112055e810112059ba0c10007")	 			
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';	
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';			
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""		 
	 		if(_usersharetype == "4028801511760958011176701f79000f")	 			
	 			document.all("showOrgUnitType").style.display = '';
	 		else
	 			document.all("showOrgUnitType").style.display = 'none';	  
	 			
	 		if(_usersharetype == "4028804112055e810112059ba0c10007")	 			
	 			document.all("showPositionType").style.display = '';
	 		else
	 			document.all("showPositionType").style.display = 'none';	
	 	} 
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000b") {	 //人员+经理	
		_sharetype = document.all("StationObjType").value;
		if(_sharetype == "297e828210f211130110f21d99710009"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = '';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showPositionType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"	
			document.all("showrolename").style.display = 'none';		
	 			 		
	 	}else if(_sharetype == "40288015117609580111763947b80007"){	//指定岗位 

	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = '';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showPositionType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""	
			document.all("showrolename").style.display = 'none';
	 	}else {	//其他
	 		//需要读取不同的字段到选择框中。。。


			getformfield(_sharetype);
	 		document.all("showRoleType").style.display = 'none';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = '';
			document.all("showStationIDs").style.display = 'none';			
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = '';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = '';
	 		document.all("showRoleObjID").style.display = 'none';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showPositionType").style.display = '';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 		
	//		document.all("showrelatedsharename").innerHTML = ""		 
	 	} 
	}
	else if (thisvalue == "402881e60bf4f747010bf4fec8f8000c") { //组织单元+角色+作用域

			_roletype = document.all("RoleType").value;
			_roletype2 = document.all("RoleType2").value;
		if(_roletype2=="4028819a0f16b8f1010f179d98730010"){
				_sharetype = document.all("RoleType2").value;
				getformfield2(_sharetype);
			 	document.all("showrolename").style.display='none';
	 	       document.all("role_zidu").style.display='';
	 	 }else{
	 	       document.all("showrolename").style.display='';
	 	       document.all("role_zidu").style.display='none';
	 	 }
		if(_roletype == 0){
		
	 		document.all("showRoleType").style.display = '';	
	 		document.all("showOrgObjType").style.display = 'none';
	 		document.all("showUserObjType").style.display = 'none';
			document.all("showUserIDs").style.display = 'none';	
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';		
	 		document.all("showOrgObjID").style.display = 'none';
	 		document.all("showWFOperators").style.display = 'none';	 
	 		document.all("showFormfileds").style.display = 'none';
	 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
	 		document.all("showRoleObjID").style.display = '';
	 		document.all("showUserShareType").style.display = 'none';	
	 		document.all("showOrgUnitType").style.display = 'none';		
	 		document.all("showOrgManager").style.display = 'none';	
	 		document.all("showseclevel").style.display = 'none';	 					
		//	document.all("showrelatedsharename").innerHTML = "" 
		
		}else{
			_sharetype = document.all("OrgObjType").value;
			if(_sharetype == "402881ea0bf559c7010bf5608b560014"){	//指定组织单元
			
		 		document.all("showRoleType").style.display = '';	
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
		 		document.all("showOrgObjID").style.display = '';
		 		document.all("showWFOperators").style.display = 'none';	 
		 		document.all("showFormfileds").style.display = 'none';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';	
		 		document.all("showOrgUnitType").style.display = 'none';		
		 		document.all("showOrgManager").style.display = 'none';	
		 		document.all("showseclevel").style.display = 'none';	
		//		document.all("showrelatedsharename").innerHTML = "<IMG src='/images/base/checkinput.gif' align=absMiddle>"
		 		
		 	}else if(_sharetype == "402881ea0bf559c7010bf5608b560015"){	//流程节点操作者相关组织单元


			
			 	//需要将当前工作流的节点信息读取到下拉框中。。。。


		 		document.all("showRoleType").style.display = '';	
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
		 		document.all("showOrgObjID").style.display = 'none';
		 		document.all("showWFOperators").style.display = '';	 
		 		document.all("showFormfileds").style.display = 'none';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';	
		 		document.all("showOrgUnitType").style.display = 'none';		
		 		document.all("showOrgManager").style.display = 'none';	
		 		document.all("showseclevel").style.display = 'none';			
			//	document.all("showrelatedsharename").innerHTML = "";
		 		
		 	}else {	//其他
		 		//需要读取不同的字段到选择框中。。。

				getformfield(_sharetype);
		 		document.all("showRoleType").style.display = '';	
		 		document.all("showOrgObjType").style.display = '';
		 		document.all("showUserObjType").style.display = 'none';
				document.all("showUserIDs").style.display = 'none';		
	 		document.all("showStationObjType").style.display = 'none';
			document.all("showStationIDs").style.display = 'none';	
		 		document.all("showOrgObjID").style.display = 'none';
		 		document.all("showWFOperators").style.display = 'none';	 
		 		document.all("showFormfileds").style.display = '';
		 		document.all("showOrgShareType").style.display = 'none';
	 		document.all("showOrgReftype").style.display = 'none';
		 		document.all("showRoleObjID").style.display = '';
		 		document.all("showUserShareType").style.display = 'none';	
		 		document.all("showOrgUnitType").style.display = 'none';		
		 		document.all("showOrgManager").style.display = 'none';	
		 		document.all("showseclevel").style.display = 'none';			
			//	document.all("showrelatedsharename").innerHTML = "";	
			 }	 
		 
		 }
	}
	
}
  function deleteperrule(ruleid,objid,objtable,istype){
  		if(confirm("是否确认删除?")){
  		 	location.href="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.PermissionAction?action=delete&RuleID="+ ruleid +"&objid=" + objid + "&objtable=" + objtable + "&istype="+istype;
  		}
  }
</script>
<script type="text/javascript">

    function getBrowser(url,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>"+url);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
 function onshowOrgObjID(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/orgunit/orgunitbrowser.jsp");
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '';
            }
         }
 }
 function onshowRoleObjID(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/security/sysrole/sysrolebrowser.jsp");
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '';
            }
         }
 }
 function onShowMutiResource(tdname,inputname){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/humres/base/humresbrowserm.jsp?sqlwhere=hrstatus%3D'4028804c16acfbc00116ccba13802935'&humresidsin="+document.all(inputname).value);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(tdname).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		document.all(tdname).innerHTML = '';
            }
         }
 }
</script>

</BODY>
</HTML>