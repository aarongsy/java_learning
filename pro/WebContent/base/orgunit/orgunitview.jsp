<%@ include file="/base/init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunitlink"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%> 
<%
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");  
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");   
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");  

String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
String id = StringHelper.trimToNull(request.getParameter("id"));

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";

	
	
if(StringHelper.isEmpty(id)){
	out.println("该组织不存在，请与系统管理员联系！");
	return;
}

String isrefresh = StringHelper.null2String(request.getParameter("isrefresh"));
String messageid = StringHelper.null2String(request.getParameter("messageid"));
String action = StringHelper.null2String(request.getParameter("action"));

	Orgunit orgunit = orgunitService.getOrgunit(id);

	int mtype = 0;
	if(orgunit.getMtype() != null)
		mtype = orgunit.getMtype().intValue();
	%>   
	
<html>
  <head>
    <style type="text/css">
     .x-toolbar table {width:0}
     #pagemenubar table {width:0}
       .x-panel-btns-ct {
         padding: 0px;
     }
     .x-panel-btns-ct table {width:0}
   </style>
 
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
	<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
	<script language="javascript">
	<% if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("create")){ %>
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode;
        if(pnode.hasChildNodes()){
        	pnode.reload();
        	pnode.select();
        }else{
        	pnode.parentNode.reload();
        }
        location=pnode.attributes.href;
	<%}  if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("delete")){ %>
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode.parentNode;
        pnode.reload() ;
        pnode.select();
        location=pnode.attributes.href;
	<%}%>
	
	function AddOrgUnit(id){
       if (id == "" ) {
			return false;
		}

		if("<%=StringHelper.null2String(orgunit.getMstationid())%>" == ""){
			alert("该组织单元没有负责岗位，不能执行该操作！");
			return false;
		}
        location.href="<%=request.getContextPath()%>/base/orgunit/orgunitcreate.jsp?reftype=<%=reftype%>&createtype=2&pid=<%=StringHelper.null2String(id)%>";
    }
	function AddStationOK(id) {
		
		if (id == "" ) {
			return false;
		}
		
		if("<%=StringHelper.null2String(orgunit.getMstationid())%>" == ""){
			alert("该组织单元没有负责岗位，不能执行该操作！");
			return false;
		}
			
		var url = "<%=request.getContextPath()%>/humres/base/stationlist.jsp?type=browser&orgid="+id;
		var popuptitle = encode("选择岗位");
		
		var b = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?popuptitle="+popuptitle+"&url="+url);
		if(b==undefined){
			return false;
		}

   		
		var objid = getValidStr(b[0]);	
		var objname = getValidStr(b[1]);	
		
		if(objid != "" && objname != "") {
			
			var orgid = getEncodeStr(id);
			var stationid = getEncodeStr(objid);
			
			objname = objname;
			
	   		var param=new Object();
			param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=addstation&reftype=<%=reftype%>";
			
			var updatestring ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
			updatestring += "<data>";
			updatestring += "<orgid>"+orgid+"</orgid>";
			updatestring += "<stationid>"+stationid+"</stationid>";
			
			updatestring += "</data>";
			
			param.updatestring=updatestring;		
			param.sourceurl=window.location.pathname;
			var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
				"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
		   	
			if(result){
				var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
		        selectedNode.reload();
		        selectedNode.select();
		        location=selectedNode.attributes.href;
			}else{
				alert("操作失败，当前维度下已添加该岗位。");
			}
		}
			
	}
	</script>
  </head>
  
  <body>

<!--页面菜单开始-->     
<%
paravaluehm.put("{id}",id);
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");

    if(sysuserService.checkUserPerm(su,"com.eweaver.base.orgunit.service.OrgunitService.modifyOrgunit")){
        pagemenustr += "addBtn(tb,'编辑','E','application_edit',function(){location.href='"+request.getContextPath()+"/base/orgunit/orgunitmodify.jsp?reftype="+reftype+"&id="+StringHelper.null2String(id)+"'});";
    }
    if(sysuserService.checkUserPerm(su,"com.eweaver.base.orgunit.service.OrgunitService.deleteOrgunit")){
        if(orgunit.getIsRoot()==null||orgunit.getIsRoot()!=1){
            Orgunitlink orgunitlink = orgunitService.getOrgunitlink(id, null, reftype);
            String linkid ="";
            String objreftype="";
            if(orgunitlink!=null){
            	linkid=orgunitlink.getId();
            	objreftype=orgunitlink.getTypeid();
            }
            //如果是从其他维度添加过来则显示"移除"按钮
            if(!StringHelper.isEmpty(objreftype)&&!objreftype.equals(orgunit.getReftype())){
            	pagemenustr += "addBtn(tb,'移除','D','delete',function(){if (confirm('是否移除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=remove&linkid="+StringHelper.null2String(linkid)+"'}});";
            }else{
            	if(StringHelper.isEmpty(linkid))
                    pagemenustr += "addBtn(tb,'删除','D','delete',function(){if (confirm('是否删除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=delete&reftype="+reftype+"&id="+StringHelper.null2String(id)+"'}});";
                else{
                    pagemenustr += "addBtn(tb,'删除','D','delete',function(){if (confirm('是否删除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=delete&reftype="+reftype+"&id="+StringHelper.null2String(id)+"&linkid="+StringHelper.null2String(linkid)+"'}});";
                }
            }
        }
    }
    if(sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.StationinfoService.createStationinfo")){
            pagemenustr += "addBtn(tb,'新建岗位','N','add',function(){location.href='"+request.getContextPath()+"/humres/base/stationinfocreate.jsp?reftype="+reftype+"&pid="+StringHelper.null2String(id)+"'});";
        if(!reftype.equals("402881e510e8223c0110e83d427f0018"))
            pagemenustr += "addBtn(tb,'添加岗位','A','add',function(){AddStationOK('"+StringHelper.null2String(id)+"')});";
    }


    if(sysuserService.checkUserPerm(su,"com.eweaver.base.orgunit.service.OrgunitService.createOrgunit")){
        //	if(!reftypedesc.equals("3") || mtype != 1)
        pagemenustr += "addBtn(tb,'新建下属组织','O','add',function(){location.href='"+request.getContextPath()+"/base/orgunit/orgunitcreate.jsp?reftype="+reftype+"&createtype=1&pid="+StringHelper.null2String(id)+"'});";
        if(!reftype.equals("402881e510e8223c0110e83d427f0018"))
        pagemenustr += "addBtn(tb,'添加下属组织','L','add',function(){AddOrgUnit('"+StringHelper.null2String(id)+"')});";
    }


%>
<div id="pagemenubar"></div> 
<!--页面菜单结束 -->
 
	<% if(!StringHelper.isEmpty(messageid)){ %>
	
<DIV><font color=red><%=StringHelper.getDecodeStr(messageid)%></font></div>
	<%} %>
	<input type="hidden" name="id"  id="id" value="<%=StringHelper.null2String(orgunit.getId())%>"/>
	
<FIELDSET style="WIDTH: 100%"><LEGEND><B>基本信息</B></LEGEND>
				<table>	
					<!-- 列宽控制 -->		
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					 <tbody>
	  				<tr>
	          			<td class="FieldName">公司代码</td>
	          			<td class="FieldValue"><%=StringHelper.null2String(orgunit.getObjno())%>
	          			</td>
	        		</tr>
					<tr>
						<td class="FieldName">公司简码</td>
						<td class="FieldValue"><%=StringHelper.null2String(orgunit.getCol2())%>
						</td>
					</tr>
	        		<tr>
	          			<td class="FieldName">SAP编码</td>
	          			<td class="FieldValue"><%=StringHelper.null2String(orgunit.getCol1())%>
	          			</td>
	        		</tr>
	  				<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
	          			<td class="FieldValue"><%=StringHelper.null2String(orgunit.getObjname())%>
	          				<span id="objnamespan"></span></td>
	        		</tr>
	
	  				<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc187bfa000c")%></td>
	          			<td class="FieldValue">
	             			<span id="typeidspan"><%=orgunittypeService.getOrgunittypeName(orgunit.getTypeid())%></span>
	             		</td>
	        		</tr>
	
				<%
				 String station = "";
				 
				 if(!StringHelper.isEmpty(orgunit.getMstationid())){
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(orgunit.getMstationid());
				   station = StringHelper.null2String(stationinfo.getObjname());
				 }
				 %>	
	        		<tr>
	          			<td class="FieldName">组织负责岗位</td>
	          			<td class="FieldValue">
							<span id="mstationidspan"><%=station%></span>
	        			</td>
	        		</tr>
	        		
					<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
	          			<td class="FieldValue"><%=StringHelper.null2String(orgunit.getDsporder())%></td>
	        		</tr>
	        		<!-- //非活跃－0，活跃－1 -->
					<tr>
						<td class="FieldName">状态</td>
						<td class="FieldValue">
						<%=selectitemService.getSelectitemNameById(orgunit.getUnitStatus())%>
						</td>
					</tr>
	 				</tbody>
	 			</table>
	 	</FIELDSET> 		
<% if(!id.equals("402881e70ad1d990010ad1e5ec930008")){ %>
<FIELDSET style="WIDTH: 100%"><LEGEND><B>组织关系</B></LEGEND>			
		<table>	
					<!-- 列宽控制 -->		
					<colgroup>
						<col width="20%">
						<col width="40%">
						<col width="40%">
					</colgroup>
					 <tbody>
	  				
			<tr class="Header">				
					<td nowrap>纬度</td>
					<td nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcc19258f000d")%></td>
					<td nowrap>上级管理岗位</td>	
			</tr>	
			<%
			List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
			Iterator it = selectlist.iterator();
			boolean isdark = true;
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String _selectitemid = selectitem.getId();					
					Orgunitlink orgunitlink = orgunitService.getOrgunitlink(id, null, _selectitemid);
					String pid = orgunitlink.getPid(); 
					if(pid == null)
						continue;
					station = "";
					 if(!StringHelper.isEmpty(orgunitlink.getPmstationid())){
						Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(orgunitlink.getPmstationid());
					   	station = StringHelper.null2String(stationinfo.getObjname());
					 }
			 %>
	        		<tr class="<%=isdark?"DataLight":"DataDark" %>">
	          			<td><%=selectitem.getObjname()%></td>
	          			<td><%=orgunitService.getOrgunitPath(pid,null,reftype)%></td>
	          			<td><%=station%></td>
	
	        		</tr>
			<%
				isdark = !isdark;
			} %>
	 				</tbody>
	 			</table>

	 	</FIELDSET> 	
	<%} %>

	</body>
<script type="text/javascript">
    Ext.onReady(function(){
                         Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
        });
</script>
	</html>