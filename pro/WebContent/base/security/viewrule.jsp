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
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>

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

    ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");

    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
    FormlayoutService formlayoutService = (FormlayoutService)BaseContext.getBean("formlayoutService");
    String objid = StringHelper.null2String(request.getParameter("objid"));
    String formid = StringHelper.null2String(request.getParameter("formid"));
	String objtable = StringHelper.null2String(request.getParameter("objtable")).trim();
    String refactorTable="";
    if(objtable.equals("docbase")){
        refactorTable="docbase";
    }else{
        refactorTable="formbase";
    }

    String objtable1=objtable;
    if(objtable1.equals("formbase")) objtable1="requestbase";
    
    int istype = NumberHelper.string2Int(request.getParameter("istype"),0);
	
	if(!(istype==1)){
		boolean opttype = permissiondetailService.checkOpttype(objid,165);
		if(!opttype){
			response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
			return;
		}
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
<html>
  <head>

  </head>
     
  <body>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="0">
<col width="">
<col width="0">

<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">



  <table class=ViewForm>
  <colgroup> 
  <col width="30%"> 
  <col width="60%">
  <col width="10%">
  <tr class=Title> 
    <th colspan=3>         
        <%=labelService.getLabelName("402881ea0bfa7679010bfa8d96540021")%>
</th>
    </tr>
  <tr class=Spacing> 
    <td class=Line1 colspan=3></td>
  </tr>
  
  <%
  	String hsql = "from Permissionrule where objid ='"+objid+"' and istype='"+istype+"'  order by opttype,docattopttype,wfopttype,priority";
	List list = permissionruleService.find(hsql);
	for(int index=0;index<list.size();index++){
		Permissionrule permissionrule = (Permissionrule)list.get(index);
		String RuleID = StringHelper.trimToNull(permissionrule.getId());
  		String ShareType = StringHelper.trimToNull(permissionrule.getSharetype());
		String RoleType = StringHelper.trimToNull(permissionrule.getRoletype());
		String OrgObjType = StringHelper.trimToNull(permissionrule.getOrgobjtype());
		String UserObjType = StringHelper.trimToNull(permissionrule.getUserobjtype());
		String UserIDs = StringHelper.trimToNull(permissionrule.getUserids());
		String OrgObjID = StringHelper.trimToNull(permissionrule.getOrgobjid());
		String WFOperatorNodeID = StringHelper.trimToNull(permissionrule.getWfoperatornodeid());
		String FormfieldID = StringHelper.trimToNull(permissionrule.getFormfieldid());
		String OrgShareType = StringHelper.trimToNull(permissionrule.getOrgsharetype());
		String RoleObjID = StringHelper.trimToNull(permissionrule.getRoleobjid());
		String UserShareType = StringHelper.trimToNull(permissionrule.getUsersharetype());
		String OrgUnitType = StringHelper.trimToNull(permissionrule.getOrgunittype());
		
		String StationObjType = StringHelper.trimToNull(permissionrule.getStationobjtype());
		String StationIDs = StringHelper.trimToNull(permissionrule.getStationid());
		String OrgReftype = StringHelper.trimToNull(permissionrule.getOrgreftype());
		
		Integer OrgManager = permissionrule.getOrgmanager();
		Integer minseclevel = permissionrule.getMinseclevel();
		Integer maxseclevel = permissionrule.getMaxseclevel();
		Integer RightType1 = permissionrule.getOpttype();
		Integer RightType2 = permissionrule.getDocattopttype();
		Integer RightType3 = permissionrule.getWfopttype();
		String orderopt = StringHelper.null2String(permissionrule.getOrderopt());
        String layoutid = permissionrule.getLayoutid();
        String layoutid1 = permissionrule.getLayoutid1();
        Integer priority = permissionrule.getPriority();
        String detailFilter = permissionrule.getDetailFilter();
        String restrictionsField = permissionrule.getRestrictionsField();
        Formfield restrictionsObj = formfieldService.getFormfieldById(restrictionsField);
        String fieldOf = permissionrule.getFieldOf();
        List listObj = StringHelper.string2ArrayList(fieldOf,",");
        List fieldOfList = new ArrayList();
        String selectitemid;
        for(int i=0;i<listObj.size();i++){
            selectitemid=(String)listObj.get(i);
            Selectitem selectitem=selectitemService.getSelectitemById(selectitemid);
            fieldOfList.add(selectitem.getObjname());
        }
  %>
  	<TR>
      <TD>
      <% 
      if(RightType1!=null){
      		List list1 = selectitemService.getSelectitemList("402881ea0bfa7679010bfa83d68a0007",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType1.intValue() == NumberHelper.string2Int(optcode))
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        	}	
       }
      if(RightType2!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa854d8a000e",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType2.intValue() == NumberHelper.string2Int(optcode))
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        	}	
       }
      if(RightType3!=null){
      		List list1  = selectitemService.getSelectitemList("402881ea0bfa7679010bfa86f3f70016",null);
        	for(int i=0;i<list1.size();i++){
        		Selectitem _selectitem = (Selectitem)list1.get(i);   
        		String optcode = StringHelper.null2String(_selectitem.getObjdesc());
        		if(RightType3.intValue() == NumberHelper.string2Int(optcode)){
        			String orderoptstr = "";
        			if(RightType3.intValue()==5){
        				Selectitem orderoptitem = selectitemService.getSelectitemById(orderopt);
     					orderoptstr = orderoptitem.getObjname();
        			}
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+(StringHelper.isEmpty(orderoptstr)?"":"-"+orderoptstr)+"]</b>");
        		}
        	}	
       }
       Selectitem _selectitem = selectitemService.getSelectitemById(ShareType);
       out.print("&nbsp;"+StringHelper.null2String(_selectitem.getObjname()));      
      	%>	
      </TD>
	  <TD class=FieldValue colspan="2">
      <table>
      <tr><td>
	  <% 
	  	String outString = "";
	  	if("402881e60bf4f747010bf4fec8f80007".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(UserObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("402881ea0bf559c7010bf55ddf210006".equals(UserObjType)){
       		 	ArrayList arrUserids = StringHelper.string2ArrayList(UserIDs,",");
  				for(int i=0;i<arrUserids.size();i++){
  					String _userid = ""+arrUserids.get(i);
  					Humres humres = (Humres)humresService.getHumresById(_userid);
  					outString += StringHelper.null2String(humres.getObjname())+"&nbsp;";
  				}
      		}else if("402881ea0bf559c7010bf55ddf210007".equals(UserObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}	  		
      	}else 	if("402881e510efab3d0110efb21a700005".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}	  		
      	}else if("402881e60bf4f747010bf4fec8f80008".equals(ShareType)){      		
        	outString += labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";        	
        	if(minseclevel != null)
        		outString += ""+minseclevel.intValue();
        	if(maxseclevel != null)
        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
      	}else if("402881e60bf4f747010bf4fec8f80009".equals(ShareType)){ 
	  		_selectitem = selectitemService.getSelectitemById(OrgObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("402881ea0bf559c7010bf5608b560014".equals(OrgObjType)){
       		 	ArrayList arrUserids = StringHelper.string2ArrayList(OrgObjID,",");
  				for(int i=0;i<arrUserids.size();i++){
  					String _userid = ""+arrUserids.get(i);
  					Orgunit orgunit = (Orgunit)orgunitService.getOrgunit(_userid);
  					outString += StringHelper.null2String(orgunit.getObjname())+"&nbsp;";
  				}
      		}else if("402881ea0bf559c7010bf5608b560015".equals(OrgObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}	  		
      		
        	outString += "/"+labelService.getLabelName("402881ea0bfa0b45010bfa16884d0007")+":";      	
	  		_selectitem = selectitemService.getSelectitemById(OrgShareType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";
       		
       		if(!"402881ea0bfa0b45010bfa19f3bb000a".equals(OrgShareType)){    	
		  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
	       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";
			}   
       	if(!"402881ea0bfa0b45010bfa19f3bb000a".equals(OrgShareType) && !"402881ea0bfa0b45010bfa19f3bb000b".equals(OrgShareType)){
       	 		Orgunittype orgunittype = (Orgunittype)orgunittypeService.getOrgunittype(OrgUnitType);       	 						
  				outString += StringHelper.null2String(orgunittype.getObjname())+"&nbsp;";
			}       		
			if(OrgManager.equals(new Integer(0))){
				outString += "/"+labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";
	        	outString += ""+minseclevel.intValue();
	        	if(maxseclevel != null)
	        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
			}else
				outString += "/"+labelService.getLabelName("402881ea0bfa7679010bfa7948b20005");
      	}else if("402881e60bf4f747010bf4fec8f8000a".equals(ShareType)){
      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
				Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}
      		
	  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";
       		
	  		_selectitem = selectitemService.getSelectitemById(UserShareType);
       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";
       		
       		if("4028801511760958011176701f79000f".equals(UserShareType)){
       			Orgunittype orgunittype = (Orgunittype)orgunittypeService.getOrgunittype(OrgUnitType);       	 						
  				outString += "&nbsp;"+StringHelper.null2String(orgunittype.getObjname());
       		}
       		if("4028804112055e810112059ba0c10007".equals(UserShareType)){
	  			_selectitem = selectitemService.getSelectitemById(OrgUnitType);    	 						
  				outString += "&nbsp;"+StringHelper.null2String(_selectitem.getObjname());
       		}
       		if("4028801511760958011176701f79000c".equals(UserShareType)){
       			outString += "/"+labelService.getLabelName("402881e70b774c35010b774cceb80008")+":";
	        	outString += ""+StringHelper.null2String(minseclevel);
	        	if(maxseclevel != null)
	        		outString +="&nbsp;－&nbsp;"+maxseclevel.intValue();
       		}
      	}else if("402881e60bf4f747010bf4fec8f8000b".equals(ShareType)){ 
      	
      		  		
      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}	  	
      		
		  		_selectitem = selectitemService.getSelectitemById(OrgReftype);
	       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+"&nbsp;";
	       		
	  		_selectitem = selectitemService.getSelectitemById(UserShareType);
       		outString += "("+StringHelper.null2String(_selectitem.getObjname())+")&nbsp;";
      	}else if("402881e60bf4f747010bf4fec8f8000c".equals(ShareType)){ 
      		if("-1".equals(UserShareType)){
      			UserShareType = "402881d90f2cbe0d010f2d048cdc000d";
      		}
      		
      		_selectitem = selectitemService.getSelectitemById(UserShareType);
      		outString += StringHelper.null2String(_selectitem.getObjname())+":";	
      		if("402881d90f2cbe0d010f2d048cdc000d".equals(UserShareType)||"-1".equals(UserShareType)){
      			Sysrole sysrole = (Sysrole)sysroleService.get(RoleObjID);
      			outString += StringHelper.null2String(sysrole.getRolename())+"&nbsp;";	
      		}else{
      			Formfield formfield = formfieldService.getFormfieldById(RoleObjID);      				
  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
      		}
      		if("1".equals(RoleType)){
      			_selectitem = selectitemService.getSelectitemById(OrgObjType);
	       		outString += "/"+StringHelper.null2String(_selectitem.getObjname())+":";	  	
		  		if("402881ea0bf559c7010bf5608b560014".equals(OrgObjType)){
	       		 	ArrayList arrUserids = StringHelper.string2ArrayList(OrgObjID,",");
	  				for(int i=0;i<arrUserids.size();i++){
	  					String _userid = ""+arrUserids.get(i);
	  					Orgunit orgunit = (Orgunit)orgunitService.getOrgunit(_userid);
	  					outString += StringHelper.null2String(orgunit.getObjname())+"&nbsp;";
	  				}
	      		}else if("402881ea0bf559c7010bf5608b560015".equals(OrgObjType)){
	      			Nodeinfo nodeinfo = nodeinfoService.get(WFOperatorNodeID);      			
	  				outString += StringHelper.null2String(nodeinfo.getObjname())+"&nbsp;";
	      		}else{
	      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
	  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
	      		}	  		
	      		
      		}

      	}
      	%>
	  <%=outString%>
      </td></tr>
      
      <%if("1".equals(detailFilter)){ %>
      		<tr><td>子表记录:非所在行隐藏</td></tr>
      <%}else if("2".equals(detailFilter)){ %>
      		<tr><td>子表记录:非所在行只读</td></tr>
      <%} %>

      <% if((refobjtype!=1 || nodetype == 4 || isworkflowid ==1)){%>
            <%if(layoutid!=null && !layoutid.equals("")){%>
            <tr><td>页面布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
      <%}%>
      <% if((nodetype==1 || nodetype == 2 )){%>
            <%if((layoutid!=null && !layoutid.equals(""))||(layoutid1!=null && !layoutid1.equals(""))){%>
            <tr><td>编辑布局:<%=formlayoutService.getFormlayoutById(layoutid).getLayoutname()%></td></tr>
            <tr><td>查看布局:<%=formlayoutService.getFormlayoutById(layoutid1).getLayoutname()%></td></tr>
            <tr><td>优先级:<%=priority%></td></tr>
            <%}%>
      <%}%>
      <%
          if(restrictionsField!=null&&!"".equals(restrictionsField)){
      %>
            <tr><td>限制字段:<%=restrictionsObj.getFieldname()+"→"+restrictionsObj.getLabelname()%>&nbsp;<a href="javascript:void(0)" onmouseover="showFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')" onmouseout="closeFieldOf('<%=RuleID%>','<%=fieldOfList.size()%>')">查看相关限制项?</a></td></tr>
      <%
            for(int i=0;i<fieldOfList.size();i++){
            %>
            <tr id="<%=RuleID+","+i%>" style="display:none"><td><%=fieldOfList.get(i).toString()%></td></tr>
            <%
            }
          }
      %>
    </table>
    </td>

  </tr>
  <%}%>
  




		</TABLE>

        </div>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>
</td>
<td ></td>
</tr>
</table>



</BODY>
</HTML>