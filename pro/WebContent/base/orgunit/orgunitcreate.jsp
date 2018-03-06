<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunitlink"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunittypeService"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");  
String pid = StringHelper.trimToNull(request.getParameter("pid"));
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
if(!sysuserService.checkUserPerm(su,"com.eweaver.base.orgunit.service.OrgunitService.createOrgunit")){
	String sUrl="/base/orgunit/orgunitview.jsp?reftype="+reftype+"&id="+pid;
	response.sendRedirect(sUrl);
}
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
OrgunittypeService orgunittypeService = (OrgunittypeService)BaseContext.getBean("orgunittypeService");
HumresService humresService = (HumresService) BaseContext.getBean("humresService");  

String createtype = StringHelper.null2String(request.getParameter("createtype"));

if(createtype.equals(""))
	createtype = "1";
Orgunit orgunit = new Orgunit();
Orgunitlink orgunitlink = new Orgunitlink();
List<Selectitem> unitStatusList = selectitemService.getSelectitemList("402880d31a04dfba011a04e279140002",null);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  </head> 
  <body>

<!--页面菜单开始-->     
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_turn_left',function(){history.go(-1)});";
%>
<div id="pagemenubar"></div> 
<!--页面菜单结束-->
	
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.orgunit.servlet.OrgunitAction?action=create" name="EweaverForm" method="post">
			<input type="hidden" name="reftype"  id="reftype" value="<%=reftype%>"/>
			<%
				if(createtype.equals("1")){
			 %>
			
			 <table>	
					<!-- 列宽控制 -->		
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					 <tbody>
	  				<tr>
	          			<td class="FieldName">公司代码</td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="objno"  id="objno" value="<%=StringHelper.null2String(orgunit.getObjno())%>"/>
	          			</td>
	        		</tr>
	  				<tr>
	          			<td class="FieldName">公司简码</td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="col2"  id="col2" value="<%=StringHelper.null2String(orgunit.getCol2())%>"/>
	          			</td>
	        		</tr>	        		
	        		<tr>
	          			<td class="FieldName">SAP编码</td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="col1"  id="col1" value="<%=StringHelper.null2String(orgunit.getCol1())%>"/>
	          			</td>
	        		</tr>
	  				<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="objname"  id="objname" onchange='checkInput("objname","objnamespan")' onkeypress="checkQuotes_KeyPress()" value="<%=StringHelper.null2String(orgunit.getObjname())%>"/>
	          				<span id="objnamespan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span></td>
	        		</tr>
	
	  				<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc187bfa000c")%></td>
	          			<td class="FieldValue"><input type="hidden" name="typeid"  id="typeid" value="<%=StringHelper.null2String(orgunit.getTypeid())%>"/>	
	          				<input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/orgunit/orgunittypebrowser.jsp','typeid','typeidspan','1');" />
	             			<span id="typeidspan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span>
	             		</td>
	        		</tr>
	
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc19258f000d")%></td>
	          			<td class="FieldValue"><input type="hidden" name="pid"  id="pid" value="<%=StringHelper.null2String(pid)%>"/>       			
	          			<input type="hidden" name="oid"  id="oid" value="<%=StringHelper.null2String(pid)%>"/>       			
	          				<input type="button" class=Browser <%=orgunitlink.getPid()==null&&reftype.equals("402881eb0bcbfd19010bcc1c574c000f")?"disabled":"onclick=\"javascript:getBrowser('"+request.getContextPath()+"/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1c1ed58a011c20fd70590fa2&rootId=&mutil=false&showtype=false&orgTypeId="+reftype+"','pid','pidspan','1')\";"%> />
	             			<span id="pidspan"><%=orgunitService.getOrgunitPath(pid,null,reftype)%></span>
	             		</td>
	        		</tr>
				<%
				String pmstationid = orgunitlink.getPmstationid();
				if(StringHelper.isEmpty(pmstationid)&&!StringHelper.isEmpty(pid)){
					Orgunit _porgunit = orgunitService.getOrgunit(pid);
					pmstationid = _porgunit.getMstationid();
				}
				 String station = "";
				 if(!StringHelper.isEmpty(pmstationid)){
					StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(pmstationid);
				   station = StringHelper.null2String(stationinfo.getObjname());
				 }
				 %>	
	        		<tr>
	          			<td class="FieldName">上级管理岗位</td>
	          			<td class="FieldValue">
	          				<input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/stationlist.jsp?type=browser&reftype=<%=reftype %>&orgid='+document.all('pid').value,'pmstationid','pmstationidspan','1');" />
	        					<span id="pmstationidspan"><%=station%></span>
	        				<input type="hidden" name="pmstationid"  id="pmstationid" value="<%=StringHelper.null2String(pmstationid)%>"></td>
	        		</tr>
	        		<%
				 station = "";
				 if(!StringHelper.isEmpty(orgunit.getMstationid())){
					StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(orgunit.getMstationid());
				   station = StringHelper.null2String(stationinfo.getObjname());
				 }
				 %>	
	        		<tr>
	          			<td class="FieldName">组织负责岗位</td>
	          			<td class="FieldValue">
	          				<input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/stationlist.jsp?type=browser&reftype=<%=reftype %>&orgid='+document.all('pid').value,'mstationid','mstationidspan','0');" />
	        					<span id="mstationidspan"><%=station%></span>
	        				<input type="hidden" name="mstationid"  id="mstationid" value="<%=StringHelper.null2String(orgunit.getMstationid())%>"></td>
	        		</tr>
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="dsporder" id="dsporder"  onkeypress="checkInt_KeyPress" value="<%=StringHelper.null2String(orgunit.getDsporder())%>"></td>
	        		</tr>
					<tr>
						<td class="FieldName">状态</td>
						<td class="FieldValue"><select name="unitStatus" id="unitStatus">
						<%
						for(Selectitem unitStatus:unitStatusList){
						%>
						<option value="<%=unitStatus.getId()%>" <%if("402880d31a04dfba011a04e4db5f0003".equals(unitStatus.getId())){%> selected <%}%>><%=unitStatus.getObjname()%></option>				
						<%}%>
						</select>
						</td>
					</tr>
	 				</tbody>
	 			</table>
	 		<%}else if(!reftype.equals("402881e510e8223c0110e83d427f0018")){

	 		%>	
	 		
	 	<input type="hidden" name="linkid"  id="linkid" value="1"/>		
		<table>	
					<!-- 列宽控制 -->		
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					 <tbody>
	  				
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc19258f000d")%></td>
	          			<td class="FieldValue"><input type="hidden" name="pid"  id="pid" value="<%=StringHelper.null2String(pid)%>"/>       			
	          			<span id="pidspan"><%=orgunitService.getOrgunitPath(pid,null,reftype)%></span>
	          		</tr>
	
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881e70ad1d990010ad1da10900004")%></td>
	          			<td class="FieldValue"><input type="hidden" name="oid"  id="oid" value=""/> 
	             			<input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/refobj/treeviewerBrowser.jsp?id=4028bc5c1c1ed58a011c20fd70590fa2&rootId=&mutil=false','oid','oidspan','1');" />
	             			<span id="oidspan">
	             			<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
	             		</td>
	        		</tr>
				<%
				
				String pmstationid = orgunitlink.getPmstationid();
				if(StringHelper.isEmpty(pmstationid)&&!StringHelper.isEmpty(pid)){
					Orgunit _porgunit = orgunitService.getOrgunit(pid);
					pmstationid = _porgunit.getMstationid();
				}
				 String station = "";
				 if(!StringHelper.isEmpty(pmstationid)){
					StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
					Stationinfo stationinfo = stationinfoService.getStationinfoByObjid(pmstationid);
				   station = StringHelper.null2String(stationinfo.getObjname());
				 }
				 %>	
	        		<tr>
	          			<td class="FieldName">上级管理岗位</td>
	          			<td class="FieldValue">
	          				<input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/stationlist.jsp?type=browser&reftype=<%=reftype %>&orgid='+document.all('pid').value,'pmstationid','pmstationidspan','1');" />
	        					<span id="pmstationidspan"><%=station%></span>
	        				<input type="hidden" name="pmstationid"  id="pmstationid" value="<%=StringHelper.null2String(pmstationid)%>"></td>
	        		</tr>
	 				</tbody>
	 			</table>
	 		<%} %>
		</form>

<script language="javascript">
	var tb=null;
    Ext.onReady(function(){
        Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
        });
    var win;
 function getBrowser(viewurl, inputname, inputspan, isneed) {
            var id;
            if(!Ext.isSafari){
            try {
                id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                }
            }
            }else{
            	var callback = function() {
                    try {
                        id = dialog.getFrameWindow().dialogValue;
                    } catch(e) {
                    }
                    if (id != null) {
    	                if (id[0] != '0') {
    	                    document.all(inputname).value = id[0];
    	                    document.all(inputspan).innerHTML = id[1];
    	                } else {
    	                    document.all(inputname).value = '';
    	                    if (isneed == '0')
    	                        document.all(inputspan).innerHTML = '';
    	                    else
    	                        document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    	
    	                }
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
                dialog.setSrc(viewurl);
                win.show();
            }
        }

   function onSubmit(){
   	 checkfields="objname,typeid,pid,oid";
   	 checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	 if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
     }
   }
   function onReturn(){
     history.go(-1);
   }

 
 function disabledToolbar(){
	if(typeof(tb) != "undefined" && tb && (tb instanceof Ext.Toolbar) && !tb.disabled){
		tb.disable();
	}
}
 </script>
  
  </body>
</html>
