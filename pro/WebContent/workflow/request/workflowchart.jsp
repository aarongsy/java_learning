<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.service.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>

<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunittype"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.security.model.Permissionrule"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysroleService"%>
<%@ page import="com.eweaver.base.security.model.Sysrole"%>
<%@ page import="com.eweaver.base.setitem.service.*"%>
<%@ page import="com.eweaver.base.setitem.model.*"%>


<%
    //  关联 rtx账号3
   boolean useRTX = false;
   SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
   Setitem rtxSet=setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");
   if(rtxSet!= null&&"1".equals(rtxSet.getItemvalue())){
	useRTX=true;
   }   
     
    String requestid = StringHelper.null2String(request.getParameter("requestid"));
    String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
    RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");
    HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
    PermissionruleService permissionruleService = (PermissionruleService) BaseContext.getBean("permissionruleService");
    NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
    FormfieldService formfieldService = (FormfieldService)BaseContext.getBean("formfieldService");
	OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
	OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
	SysroleService sysroleService = (SysroleService)BaseContext.getBean("sysroleService");
	Nodeinfo nodeinfo2 = new Nodeinfo();
     Humres humres = new Humres();
	 if (workflowid.equals(""))
		workflowid = "402881e80c86a6f3010c86eec3050021";
	// if (requestid.equals(""))	
	//    requestid = "402881eb0c7e3e77010c7e4011ce0008";
		
%> 
<%
response.setHeader("Pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
%>
<head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">
<style>

TABLE.ChartCompany A {
	COLOR: white; TEXT-DECORATION: underline
}
TABLE.ChartCompany A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

TABLE.ChartCompany A:link {
	COLOR: white; TEXT-DECORATION: underline
}
TABLE.ChartCompany A:visited {
	COLOR: white; TEXT-DECORATION: underline}

</style>
<script language="JScript.Encode" src="/js/rtxint.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
</head>
<div  id="oDiv" style="display:'';width:100%;height:500px;"> 
 
<tr>

<td></td>
<td>
     <img src="<%=request.getContextPath()%>/ShowFlow?workflowid=<%=workflowid%>" border=0>
</td>
</tr>  

<% 
	List nodeList = nodeinfoService.getNodelistByworkflowid(workflowid);
	int top0 = 0;   // 顶部空间
    int left0 = 0 ; // 左边空间
    int nodexsize = 60;
    int nodeysize = 40;	
    int currentNodeType;//节点类型 1 已流转；2  当前流转节点； 3 尚未流转
    int temp = 1;
    int icount = 0;             // 节点计数
    Iterator it = nodeList.iterator();
    String borderColor = "#00BDFF"; 
    String titelColour;
    
    
    while(it.hasNext()){
      icount++;
      titelColour = "#0079A5"; //深色
      Nodeinfo nodeinfo = (Nodeinfo)it.next();
      int drawxpos = NumberHelper.getIntegerValue(nodeinfo.getDrawxpos(),0); 
      int drawypos = NumberHelper.getIntegerValue(nodeinfo.getDrawypos(),0);
      
      String nodeid = StringHelper.null2String(nodeinfo.getId());
      String nodename = StringHelper.null2String(nodeinfo.getObjname());
      currentNodeType = requestlogService.getNodeType(nodeinfo.getId(),requestid); 
      List doList = new ArrayList();
      List undoList = new ArrayList();
      List viewList = new ArrayList();
      
      if (currentNodeType==0){//未操作 浅色
         titelColour = "#00BEFF"; 
         } 
      if (currentNodeType == 1) {//当前节点
      nodename = "<a href="+request.getContextPath()+"/workflow/request/workflow.jsp?requestid="+requestid+"&nodeid="+nodeid+">"+nodename+"</a>";
      
        titelColour = "#0079A5"; //深色
        List tempList = new ArrayList();
        tempList = requestlogService.getOperatorListCur(nodeinfo.getId(),requestid);
        undoList = (List)tempList.get(0);
        doList = (List)tempList.get(1);
        viewList = (List)tempList.get(2);
      }  
      if (currentNodeType == 2){//已操作

      nodename = "<a href="+request.getContextPath()+"/workflow/request/workflow.jsp?requestid="+requestid+"&nodeid="+nodeid+">"+nodename+"</a>";

        titelColour ="#0092C6";
        doList = requestlogService.getOperatorListPost(nodeinfo.getId(),requestid); 
      }
%>
<TABLE cellpadding=1 cellspacing=1 Class=ChartCompany 
STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;border:3px solid black;border-Color:<%=borderColor%>;
TOP:<%=drawypos-nodeysize+top0%>;LEFT:<%=drawxpos-nodexsize+left0%>;
height:<%=nodeysize*2%>;width:<%=nodexsize*2%>"  LANGUAGE=javascript 
onclick="return b_OnClick(<%=icount%>)" onmouseout="return a_OnMouseOut(<%=icount%>)" >
    <tr height=15px align=center>		
    <TD VALIGN=TOP style="padding-left:2px;background-color:<%=titelColour%>;color:white;border:1px solid black">
    <B><%=nodename%></B></TD>
    </TR>	
    <tr>
     <%//是否当前节点
        if (currentNodeType==1){
     %>
      <TD  VALIGN=TOP align=left style="background-color:#F5F5F5;border:3px solid red;padding-left:2px">
     <%
       }else{
     %>
      <TD VALIGN=TOP align=left style="background-color:#F5F5F5;border:1px solid black;padding-left:2px">
     <%
       }
     %>
      <%
         if (currentNodeType==2 && doList.size()>0){//已操作节点


         Object[] hum = (Object[])doList.get(0); 
         
      %>
        <img src="<%=request.getContextPath()%>/images/doperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260007") %>"><!-- 已操作者 --><%=hum[1]%>
        &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)hum[0])%>');"> <%if (doList.size()>1){%><%="..."%><%}%><br>
      <%
        }else if (currentNodeType==1){//当前结点
      %>
         <%
           if (undoList.size()>0) {
               Object[] undoHum = (Object[])undoList.get(0);
         %>
         <img src="<%=request.getContextPath()%>/images/notdoperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260008") %>"><!-- 未操作者 --><%=undoHum[1]%>
         &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)undoHum[0])%>');">
         <%if (undoList.size()>1){%><%="..."%><%}%><br>
         <%
         }else{
         %>
           <img src="<%=request.getContextPath()%>/images/notdoperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260008") %>"><!-- 未操作者 -->&nbsp<br>
         <%
         }
         %>
         <%
           if (doList.size()>0) {
             Object[] hasdoHum = (Object[]) doList.get(0);
         %>
         <img src="<%=request.getContextPath()%>/images/doperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260007") %>"><!-- 已操作者 --><%=hasdoHum[1]%>
         &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)hasdoHum[0])%>');">
         <%if (doList.size()>1){%><%="..."%><%}%><br>
         <%
         }else{
         %>
          <img src="<%=request.getContextPath()%>/images/doperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260007") %>"><!-- 已操作者 -->&nbsp<br>
         <%
         }
         %>


          <%
           if (viewList.size()>0) {
             Object[] viewHum = (Object[]) viewList.get(0);
         %>
          <img src="<%=request.getContextPath()%>/images/viewperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260009") %>"><!-- 查看者 --><%=viewHum[1]%>
          &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)viewHum[0])%>');">
          <%if (viewList.size()>1){%><%="..."%><%}%><br>
         <%
         } else{
         %>   
         <img src="<%=request.getContextPath()%>/images/viewperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260009") %>"><!-- 查看者 -->&nbsp <br>
         <%
         }
         %>    
      
      <%
      } else if (currentNodeType==0){
      %>
        <b><%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa8d96540021") %><!-- 规则 --></b>
      <%
       }
      %>
      <br>&nbsp<br>
    	<div align=right>
        	>>>
	    </div>
	    </td>
	</tr>
</table>	
    <DIV id="oc_divMenuDivision<%=icount%>" name="oc_divMenuDivision<%=icount%>" 
    style="background-color:white;visibility:hidden; LEFT:<%=drawxpos%>; POSITION:absolute; TOP:<%=drawypos+top0%>; WIDTH:240px; Z-INDEX: 200">
    <TABLE cellpadding=2 cellspacing=0 class="MenuPopup" LANGUAGE=javascript 
     onmouseout="return a_OnMouseOut(<%=icount%>)" onmouseover="return b_OnClick(<%=icount%>)"
     style="HEIGHT: 79px; WIDTH: 246px">
      <%
         if (currentNodeType==2 && doList.size()>0){//已操作节点

      %>
          <tr>
          <td>  <img src="<%=request.getContextPath()%>/images/doperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260007") %>"><!-- 已操作者 -->
      <%
            Iterator itor = doList.iterator();
            while (itor.hasNext()){ 
            Object[] hums = (Object[]) itor.next(); 
      %>

             <%=hums[1]%>
             &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)hums[0])%>');">
             <%if (itor.hasNext()){%><%=","%><%}%>

        <%
          } //end while
        %>
         </td>
       </tr><br>
     <%
       }else if (currentNodeType==1){//当前结点
     %>  
     <tr>
           <td><img src="<%=request.getContextPath()%>/images/notdoperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260008") %>"><!-- 未操作者 -->
         <%
        if (undoList.size()>0) {
          Iterator undoIt = undoList.iterator();
          while(undoIt.hasNext()){
           Object[] undoIthums = (Object[]) undoIt.next();
        %>

               <%=undoIthums[1]%>
               &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)undoIthums[0])%>');">
               <%if (undoIt.hasNext()){%><%=","%><%}%>

        <%
         } //end while
        }//end if 
        %>   
          </td>
         </tr><br> 
           <tr>
           <td>
                <img src="<%=request.getContextPath()%>/images/doperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260007") %>"><!-- 已操作者 -->
        <%
        if (doList.size()>0) {
          Iterator doIt = doList.iterator();
          while(doIt.hasNext()){
           Object[] doIthums = (Object[]) doIt.next();
        %>
         <%=doIthums[1]%>

        <%
         } //end while
        }//end if f
        %> 
            </td>
         </tr><br>
          
         <tr>
           <td>
               <img src="<%=request.getContextPath()%>/images/viewperson.gif" title="<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260009") %>"><!-- 查看者 -->
           <%
        if (viewList.size()>0) {
          Iterator viewIt = viewList.iterator();
          while(viewIt.hasNext()){
           Object[] viewIthums = (Object[]) viewIt.next();
        %>
              <%=viewIthums[1]%>
              &nbsp;<img align="absbottom" width=16 height=16 src="<%=request.getContextPath()%>/rtx/images/blank.gif" onload="RAP('<%=humresService.getRTXById((String)viewIthums[0])%>');">
              <%if (viewIt.hasNext()){%><%=","%><%}%>

        <%
         } //end while
        }//end if 
        %>   
          </td>
         </tr><br>    
     <%
      }// end of first if
     %>
     <!--规则begin -->
   <%
    if (currentNodeType==0 || requestid.equals("")){
  %>
     <table class=ViewForm>
  <colgroup> 
  <col width="30%"> 
  <col width="60%">
  <col width="10%">
 
  <tr class=Spacing> 
    <td class=Line1 colspan=3></td>
  </tr>
  
  <%
  
  	String hsql =  "from Permissionrule where objid ='"+nodeinfo.getId()+"' and istype= 1 and objtable = 'requestbase' order by opttype,docattopttype,wfopttype";
  	
  	System.out.println(hsql);
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
        		if(RightType3.intValue() == NumberHelper.string2Int(optcode))
        			out.print("<B>["+StringHelper.null2String(_selectitem.getObjname())+"]</b>");
        	}	
       }
       Selectitem _selectitem = selectitemService.getSelectitemById(ShareType);
       out.print("&nbsp;"+StringHelper.null2String(_selectitem.getObjname()));      
      	%>	
      </TD>
	  <TD class=FieldValue>
	  <% 
	  String outString = "";
	  	if("402881e60bf4f747010bf4fec8f80007".equals(ShareType)){
	  		_selectitem = selectitemService.getSelectitemById(UserObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("402881ea0bf559c7010bf55ddf210006".equals(UserObjType)){
       		 	ArrayList arrUserids = StringHelper.string2ArrayList(UserIDs,",");
  				for(int i=0;i<arrUserids.size();i++){
  					String _userid = ""+arrUserids.get(i);
  					 humres = (Humres)humresService.getHumresById(_userid);
  					outString += StringHelper.null2String(humres.getObjname())+"&nbsp;";
  				}
      		}else if("402881ea0bf559c7010bf55ddf210007".equals(UserObjType)){
      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
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
      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
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
      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
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
      	}else if("402881e60bf4f747010bf4fec8f8000a".equals(ShareType) ){ 
      	
      		  		
      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
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
      	}else if("402881e60bf4f747010bf4fec8f8000b".equals(ShareType)){ 
      	
      		  		
      		_selectitem = selectitemService.getSelectitemById(StationObjType);
       		outString += StringHelper.null2String(_selectitem.getObjname())+":";	  	
	  		if("297e828210f211130110f21d99710009".equals(StationObjType)){
	  			StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(StationIDs);
				   outString += StringHelper.null2String(stationinfo.getObjname())+"&nbsp;";
      		}else if("40288015117609580111763947b80007".equals(StationObjType)){
      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
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
	      			 nodeinfo2 = nodeinfoService.get(WFOperatorNodeID);      			
	  				outString += StringHelper.null2String(nodeinfo2.getObjname())+"&nbsp;";
	      		}else{
	      			Formfield formfield = formfieldService.getFormfieldById(FormfieldID);      				
	  				outString += StringHelper.null2String(formfield.getLabelname())+"&nbsp;";
	      		}	  		
	      		
      		}

      	}
      	%>
	  <%=outString%></td>

  </tr>
  <%}%>
  </table> 
  <%
   }//end if
  %>
     <!--规则end -->
     </TABLE>  
     </DIV>
<%
}// end node it while ,the outer while
%>	

	
</div>

