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
<%@ include file="/base/init.jsp"%>
<%@ include file="stationInclude.jsp"%>
<%
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");   

String id = StringHelper.trimToNull(request.getParameter("id"));


String reftype = StringHelper.trimToNull(request.getParameter("reftype"));

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";

	
	
Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(id);


String isrefresh = StringHelper.null2String(request.getParameter("isrefresh"));
String messageid = StringHelper.null2String(request.getParameter("messageid"));
String action = StringHelper.null2String(request.getParameter("action"));

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
	<script language="JScript.Encode" src="/js/rtxint.js"></script>
	<script language="JScript.Encode" src="/js/browinfo.js"></script>
	<script language="javascript">
        <% if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("create")){ %>
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
		var pnode=selectedNode.parentNode;
		if(selectedNode.isLeaf()){
        	pnode.reload();
        	pnode.select();
	        location=pnode.attributes.href;
        }else{
        	selectedNode.reload();
			selectedNode.select();
	        location=selectedNode.attributes.href;
        }
	<%}
	
			if(StringHelper.isEmpty(messageid) && !StringHelper.isEmpty(isrefresh) && action.equals("delete")){ %>
		var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
        pnode=selectedNode.parentNode;
        pnode.reload() ;
        pnode.select();
        location=pnode.attributes.href;

	<%}%> 	
	 var win;                                                               
	function AddHumresOK(id) {
		if (id == "" ) {
			return false;
		}
		var url = "<%=request.getContextPath()%>/humres/base/humresbrowser.jsp";
		var popuptitle = encode("<%=labelService.getLabelName("402881e70b7728ca010b772b02510008")%>");
		var b;
		if(!Ext.isSafari){
			 b = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?popuptitle="+popuptitle+"&url="+url);
			if(b==undefined){
				return false;
			}
	
	   		
			var objid = getValidStr(b[0]);	
			var objname = getValidStr(b[1]);	
			
			if(objid != "" && objname != "") {
				
				var stationid = getEncodeStr(id);
				var humresid = getEncodeStr(objid);
				
				objname = objname+"(<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003e")%>)";//兼
				
				addHumresStation(stationid,humresid);
			}
		}else{
		    var callback = function() {
	            try {
	                b = dialog.getFrameWindow().dialogValue;
	            } catch(e) {
	            }
	            var objid = getValidStr(b[0]);	
				var objname = getValidStr(b[1]);	
				
				if(objid != "" && objname != "") {
					
					var stationid = getEncodeStr(id);
					var humresid = getEncodeStr(objid);
					
					objname = objname+"(<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003e")%>)";//兼
					
					addHumresStation(stationid,humresid);
				}
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.8;
		    var winWidth = Ext.getBody().getWidth() * 0.8;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	             win = new Ext.Window({
	                layout:'border',
	                width:winWidth,
	                height:winHeight,
	                plain: true,
	                modal:true,
	                items: {
	                    id:'dialog',
	                    region:'center',
	                    iconCls:'portalIcon',
	                    xtype     :'iframepanel',
	                    frameConfig: {
	                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
	                        eventsFollowFrameLinks : false
	                    },
	                    closable:false,
	                    autoScroll:true
	                }
	            });
	        }
	        win.close=function(){
	                    this.hide();
	                    win.getComponent('dialog').setSrc('about:blank');
	                    callback();
	                } ;
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(url);
	        win.show();
		}
	}

	function addHumresStation(stationid,humresid){//添加兼职岗位
		$.ajax({
			   type: "POST",
			   async: false,
			   url: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=addstationhumres",
			   data: "stationid="+stationid+"&humresid="+humresid,
			   success: function(msg){
			     //alert( "Data Saved: " + msg );
			     if(parent.orgTree!=undefined) {
					var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
	                if(selectedNode.isLeaf()){
	                selectedNode.parentNode.reload();
	                }else
	                selectedNode.reload();
	             }
			   }
			});
	}
	</script>
	
  </head>
  <%
  if(StringHelper.isEmpty(stationinfo.getId())){
	out.println(labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003d"));//该岗位不存在，请与系统管理员联系！
	return;
}
String orgid = stationinfo.getOrgid();
Orgunit orgunit = orgunitService.getOrgunit(orgid);

	int mtype = 0;
	if(orgunit.getMtype() != null)
		mtype = orgunit.getMtype().intValue();
  
   %>
  
  <body>
    
<!--页面菜单开始-->     
<%
paravaluehm.put("{id}",id);
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
    if(sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.StationinfoService.modifyStationinfo")){
    	//编辑
        pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e70b774c35010b7750a15b000b")+"','E','application_edit',function(){location.href='"+request.getContextPath()+"/humres/base/stationinfomodify.jsp?reftype="+reftype+"&id="+StringHelper.null2String(id)+"'});";
    }
    if(sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.StationinfoService.deleteStationinfo")){
        //	if(!reftypedesc.equals("2")){
		Stationlink stationlink=stationinfoService.getStationlink(id, null, reftype);
        String linkid ="";
        String toorgunit="";
            if(stationlink!=null){
            	linkid=stationlink.getId();
            	toorgunit=stationlink.getToOrgUnit();
            }
            if(!StringHelper.isEmpty(toorgunit)){
            	pagemenustr += "addBtn(tb,'移除','D','delete',function(){if (confirm('是否移除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=remove&linkid="+StringHelper.null2String(linkid)+"'}});";
            }else{
            	if(StringHelper.isEmpty(linkid)){
                	//删除
                	if(!id.equals("402881eb112f5af201112ff3afe10004")){//最高岗位无删除按钮
              		  pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){if (confirm('是否删除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=delete&reftype="+reftype+"&id="+StringHelper.null2String(id)+"'}});";
                	}
                }
                else{
                	//删除
                	if(!id.equals("402881eb112f5af201112ff3afe10004")){//最高岗位无删除按钮
               		 pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){if (confirm('是否删除?')) {location.href='"+request.getContextPath()+"/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=delete&reftype="+reftype+"&id="+StringHelper.null2String(id)+"&linkid="+StringHelper.null2String(linkid)+"'}});";
                	}
                }
            }
    }
    if(sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.HumresService.createHumres")){
        if(reftype.equals("402881e510e8223c0110e83d427f0018")){	//新建人员	
            pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003f")+"','N','add',function(){location.href='"+request.getContextPath()+"/humres/base/humrescreate.jsp?reftype="+reftype+"&stationid="+StringHelper.null2String(id)+"&stationtype="+StringHelper.null2String(stationinfo.getStationtype())+"&stationsequence="+StringHelper.null2String(stationinfo.getStationsequence())+"'});";
        }
        //添加兼岗人员
        pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0040")+"','A','add',function(){AddHumresOK('"+StringHelper.null2String(id)+"')});";
    }
    if(sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.HumresService.deleteHumres")){
        //移除兼岗人员
    	pagemenustr += "addBtn(tb,'"+labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0041")+"','R','delete',function(){RemoveHumresOK('"+StringHelper.null2String(id)+"')});";
    }



%>
<div id="pagemenubar"></div>
<!--页面菜单结束 -->
 
	<% if(!StringHelper.isEmpty(messageid)){ %>
	
<DIV><font color=red><%=StringHelper.getDecodeStr(messageid)%></font></div>
	<%} %>
	
<FIELDSET style="WIDTH: 100%"><LEGEND><B><%=labelService.getLabelNameByKeyId("402881e70b7728ca010b772e24f50009")%></B></LEGEND><!-- 基本信息 -->
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				 <tbody>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0032")%></td><!-- 编码 -->
          			<td class="FieldValue"><%=StringHelper.null2String(stationinfo.getCode())%>
          			</td>
        		</tr>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
          			<td class="FieldValue">
          				<span id="objnamespan"><%=StringHelper.null2String(stationinfo.getObjname())%></span></td>
        		</tr>


        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0033")%></td><!-- 所属组织单元 -->
          			<td class="FieldValue">
          			<span id="pidspan"><%=orgunitService.getOrgunitPath(orgid,null,reftype)%></span>
             		</td>
        		</tr>
        		
				<%
				 String station = "";
				 %>	
				<%
					station = "";
					String position = StringHelper.null2String(stationinfo.getPosition());
					if(!StringHelper.isEmpty(position)){
					
					   Selectitem selectitem = selectitemService.getSelectitemById(position);
					   station = StringHelper.null2String(selectitem.getObjname());
					}
				 %>
				<tr>
				<td class="FieldName" nowrap>
					  <%=labelService.getLabelName("402881e70b7728ca010b7741f3e2000e")%>

					</td>
					<td class="FieldValue">			
						<span id="stationspan"/><%=station%></span>
					</td>
				</tr>

        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0035")%></td><!-- 岗位类别 -->
          			<td class="FieldValue">
						<%=selectitemService.getSelectitemNameById(stationinfo.getStationtype())%>
					</td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0036")%></td><!-- 岗位序列 -->
          			<td class="FieldValue">
						<%=selectitemService.getSelectitemNameById(stationinfo.getStationsequence())%>
					</td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0037")%></td><!-- 岗位等级下限 -->
					<td class="FieldValue"><%=stationinfo.getMinlevel()%></td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0038")%></td><!-- 岗位等级上限 -->
					<td class="FieldValue"><%=stationinfo.getMaxlevel()%></td>
        		</tr>

        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0039")%></td><!-- 其他信息 -->
          			<td class="FieldValue"><%=StringHelper.null2String(stationinfo.getObjdesc()) %></td>
        		</tr>
        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
	          			<td class="FieldValue"><%=StringHelper.null2String(stationinfo.getDsporder())%></td>
	        		</tr>
				<%
					Integer iMaxnum = stationinfo.getMaxnum();
					Integer iCurnum = stationinfo.getCurnum();
					
					int maxnum = 1;
					int curnum = 0;
					if(iMaxnum != null)
						maxnum = iMaxnum.intValue();
					if(iCurnum != null)
						curnum = iCurnum.intValue();
					int neednum = maxnum - curnum;	
				 %>
        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003a")%></td><!-- 定编 -->
          			<td class="FieldValue"><%=maxnum%></td>
        		</tr>
        		
        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003b")%></td><!-- 在编 -->
          			<td class="FieldValue"><%=curnum%></td>
        		</tr>

        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003c")%></td><!-- 缺编 -->
          			<td class="FieldValue"><%=neednum%></td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")%></td><!-- 状态 -->
          			<td class="FieldValue">          			
          			<%=selectitemService.getSelectitemNameById(stationinfo.getStationStatus())%></td>
        		</tr>
 				</tbody>
 			</table>
	 	</FIELDSET> 	
	 	
<% if(!id.equals("402881eb112f5af201112ff3afe10004")){ %>
<FIELDSET style="WIDTH: 100%"><LEGEND><B><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0042")%></B></LEGEND>	<!-- 组织关系 -->		
		<table>	
					<!-- 列宽控制 -->		
					<colgroup>
						<col width="20%">
						<col width="40%">
						<col width="40%">
					</colgroup>
					 <tbody>
	  				
			<tr class="Header">				
					<td nowrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0f0043")%></td><!-- 纬度 -->
					<td nowrap><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0034")%></td>	<!--上级管理岗位  -->
			</tr>	
			<%
			List selectlist = selectitemService.getSelectitemList("402881e510e8223c0110e83c36010016",null);
			Iterator it = selectlist.iterator();
			boolean isdark = true;
				while (it.hasNext()){
					Selectitem selectitem = (Selectitem)it.next();					
					String _selectitemid = selectitem.getId();					
					Stationlink stationlink = stationinfoService.getStationlink(id, null, _selectitemid);
					String pid = stationlink.getPid(); 
					if(pid == null)
						continue;
					station = "";
					  Stationinfo __stationinfo = stationinfoService.getStationinfoByObjid(pid);
					  station = StringHelper.null2String(__stationinfo.getObjname());
					  String orgid_ = StringHelper.null2String(__stationinfo.getOrgid());
					  String orgPath = orgunitService.getOrgunitPath(orgid_,0,_selectitemid);
					 String newStationPath = orgPath+"/	"+station;
					   	
			 %>
	        		<tr class="<%=isdark?"DataLight":"DataDark" %>">
	          			<td><%=selectitem.getObjname()%></td>
	          			<td><%=newStationPath%></td>
	
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
	//移除人员
	function RemoveHumresOK(id) {
		var url = "<%=request.getContextPath()%>/humres/base/humresremovestation.jsp?stationid="+id+"&orgid=<%=orgid%>";
		var popuptitle = encode("<%=labelService.getLabelName("402881e70b7728ca010b772b02510008")%>");
		var b ;
		if(!Ext.isSafari){
			 b = openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url="+url);
			if(b==undefined){
				return false;
			}
			var objid = getValidStr(b[0]);	
			var objname = getValidStr(b[1]);	
			
			if(objid != "" && objname != "") {
				
				var stationid = getEncodeStr(id);
				var humresid = getEncodeStr(objid);
				
				delHumresStation(stationid,humresid);
			}
		}else{
			var callback = function() {
	            try {
	                b = dialog.getFrameWindow().dialogValue;
	            } catch(e) {
	            }
	            var objid = getValidStr(b[0]);	
				var objname = getValidStr(b[1]);	
				
				if(objid != "" && objname != "") {
					
					var stationid = getEncodeStr(id);
					var humresid = getEncodeStr(objid);
					
					objname = objname+"(<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003e")%>)";//兼
					
					delHumresStation(stationid,humresid);
				}
	        }
		    var winHeight = Ext.getBody().getHeight() * 0.8;
		    var winWidth = Ext.getBody().getWidth() * 0.8;
		    if(winHeight>500){//最大高度500
		    	winHeight = 500;
		    }
		    if(winWidth>880){//最大宽度800
		    	winWidth = 880;
		    }
	        if (!win) {
	             win = new Ext.Window({
	                layout:'border',
	                width:winWidth,
	                height:winHeight,
	                plain: true,
	                modal:true,
	                items: {
	                    id:'dialog',
	                    region:'center',
	                    iconCls:'portalIcon',
	                    xtype     :'iframepanel',
	                    frameConfig: {
	                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
	                        eventsFollowFrameLinks : false
	                    },
	                    closable:false,
	                    autoScroll:true
	                }
	            });
	        }
	        win.close=function(){
	                    this.hide();
	                    win.getComponent('dialog').setSrc('about:blank');
	                    callback();
	                } ;
	        win.render(Ext.getBody());
	        var dialog = win.getComponent('dialog');
	        dialog.setSrc(url);
	        win.show();
		}			
	}

	function delHumresStation(stationid,humresid){
		$.ajax({
			   type: "POST",
			   async: false,
			   url: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=removestationhumres",
			   data: "stationid="+stationid+"&humresid="+humresid,
			   success: function(msg){
			     //alert( "Data Saved: " + msg );
			     if(parent.orgTree!=undefined) {
			    	 var selectedNode = parent.orgTree.getSelectionModel().getSelectedNode();
		                if(selectedNode.isLeaf()){
		                selectedNode.parentNode.reload();
		                }else
		                selectedNode.reload();
	             }
			   }
			});
	}
	</script>
	</html>