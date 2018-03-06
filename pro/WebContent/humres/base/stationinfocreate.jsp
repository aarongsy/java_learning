<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%
SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
String pid = StringHelper.trimToNull(request.getParameter("pid"));
String reftype = StringHelper.trimToNull(request.getParameter("reftype"));
Sysuser su=(Sysuser)request.getSession(true).getAttribute("eweaver_user@bean");
if(!sysuserService.checkUserPerm(su,"com.eweaver.humres.base.service.StationinfoService.createStationinfo")){
	String sUrl="/base/orgunit/orgunitview.jsp?reftype="+reftype+"&id="+pid;
	response.sendRedirect(sUrl);
}
 %>
<%@ include file="/base/init.jsp"%>
<%@ include file="stationInclude.jsp"%>
<%
StationinfoService stationinfoService = (StationinfoService)BaseContext.getBean("stationinfoService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");

if(StringHelper.isEmpty(reftype))
	reftype = "402881e510e8223c0110e83d427f0018";
Stationinfo stationinfo = new Stationinfo();

String orgid = stationinfo.getOrgid();

if(pid != null){
	orgid = pid;
}
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
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/engine.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/dwr/util.js'></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/js/main.js'></script>
  </head> 
  <body>
  		
		
<!--页面菜单开始-->     
<%
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+"','R','arrow_turn_left',function(){history.go(-1)});";
%>
<div id="pagemenubar"></div>
<!--页面菜单结束--> 
	
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.StationAction?action=create" name="EweaverForm" method="post">
		<input type="hidden" name="reftype"  id="reftype" value="<%=reftype%>"/>
			<table>	
				<!-- 列宽控制 -->		
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				 <tbody>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0032")%></td><!-- 编码 -->
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="code"  id="code" value="<%=StringHelper.null2String(stationinfo.getCode())%>"/>
          			</td>
        		</tr>
  				<tr>
          			<td class="FieldName"><%=labelService.getLabelName("402881eb0bcbfd19010bcc16ecb1000b")%></td>
          			<td class="FieldValue"><input class="inputstyle" type="text" size="30" name="objname"  id="objname" onchange='checkInput("objname","objnamespan")' onkeypress="checkQuotes_KeyPress()" value="<%=StringHelper.null2String(stationinfo.getObjname())%>"/>
          				<span id="objnamespan"><img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle></span></td>
        		</tr>


        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0033")%></td><!-- 所属组织单元 -->
          			<td class="FieldValue"><input type="hidden" name="orgid"  id="orgid" value="<%=StringHelper.null2String(orgid)%>"/>       			
          			<span id="pidspan"><%=orgunitService.getOrgunitPath(orgid,null,reftype)%></span>
             		</td>
        		</tr>
        		
				<%
				String parentobjid = stationinfo.getParentobjid();
				if(StringHelper.isEmpty(parentobjid)&&!StringHelper.isEmpty(orgid)){
					Orgunit orgunit = orgunitService.getOrgunit(orgid);
					parentobjid = orgunit.getMstationid();
				}				
				if(StringHelper.isEmpty(parentobjid)&&!StringHelper.isEmpty(orgid)){
					Orgunit _porgunit = orgunitService.getParentOrgunit(orgid,null,reftype);
					parentobjid = _porgunit.getMstationid();
				}
				
				 String station = "";
				 if(!StringHelper.isEmpty(parentobjid)){
					Stationinfo _stationinfo = stationinfoService.getStationinfoByObjid(parentobjid);
				   station = StringHelper.null2String(_stationinfo.getObjname());
				 }
				 %>	
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0034")%></td><!-- 上级管理岗位 -->
	          			<td class="FieldValue">
	          				<button type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/humres/base/stationlist.jsp?type=browser&reftype=<%=reftype %>','parentobjid','parentobjspan','1');"></button>
	        					<span id="parentobjspan">
	        					<%if(station.equals("")){ %>
	        					<img src="<%=request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle>
	        					<%}else{ %>
	        					<%=station%>
	        					<%} %>
	        					</span>
	        				<input type="hidden" name="parentobjid"  id="parentobjid" value="<%=StringHelper.null2String(parentobjid)%>"></td>
	        		</tr>
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
				        <button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=402881ea0b1c751a010b1ccf13390001','position','stationspan','0');"></button>
						<input type="hidden"  id="position"  name="position" value="<%=position%>"/>
						<span id="stationspan"/><%=station%></span>
						
						
					</td>
				</tr>
        		<tr>
        			<td class="FieldName">岗位类别</td><!-- 岗位类别 -->
          			<td class="FieldValue">
					<input type="hidden" name="field_stationType_fieldcheck" value="stationSequence" >
					<select name="stationType" id="stationType" style="width: 25%"  onchange="fillotherselect(this,'stationType',-1)">
					<option value=""></option>
					<%
					List list = selectitemService.getSelectitemList("4028804c169e921e0116a8203c9d0ffc","");
					for(int i=0; i<list.size(); i++){

						Selectitem _selectitem = (Selectitem) list.get(i);
						String _selectvalue = StringHelper.null2String(_selectitem.getId());
						String _selectname = StringHelper.null2String(_selectitem.getObjname());
						String selected = "";
						if (_selectvalue.equalsIgnoreCase(""))
							selected = " selected ";%>
						<option value=<%=_selectvalue%> <%=selected%> ><%=_selectname%></option>
					<%}%>
          			</select>
					</td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0036")%></td><!-- 岗位序列 -->
          			<td class="FieldValue">
					<input type="hidden" name="field_stationSequence_fieldcheck" value="" >
					<select name="stationSequence" id="stationSequence" style="width: 25%"  onchange="fillotherselect(this,'stationSequence',-1)">
					<option value=""></option>
					<%
					for(int i=0; i<list.size(); i++){
						Selectitem _selectitem = (Selectitem) list.get(i);
						String _selectvalue = StringHelper.null2String(_selectitem.getId());
						String _selectname = StringHelper.null2String(_selectitem.getObjname());
						String selected = "";
						if (_selectvalue.equalsIgnoreCase(""))
							selected = " selected ";%>
						<option value=<%=_selectvalue%> <%=selected%> ><%=_selectname%></option>
					<%}%>
          			</select></td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0037")%></td><!-- 岗位等级下限 -->
					<td class="FieldValue"><input class="inputstyle" type="text" size="3" name="minLevel" id="minLevel"  onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','岗位等级下限')" value=""></td>
        		</tr>
        		<tr>
        			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0038")%></td><!-- 岗位等级上限 -->
					<td class="FieldValue"><input class="inputstyle" type="text" size="3" name="maxLevel" id="maxLevel"  onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','岗位等级上限')" value=""></td>
        		</tr>
				<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a0039")%></td><!-- 其他信息 -->
          			<td class="FieldValue"><textarea class="inputstyle" style="width:90%" name="objdesc" id="objdesc"><%=StringHelper.null2String(stationinfo.getObjdesc()) %></textarea></td>
        		</tr>
	        		<tr>
	          			<td class="FieldName"><%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%></td>
	          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="dsporder" id="dsporder"  onkeypress="checkInt_KeyPress" value=""></td>
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
          			<td class="FieldValue"><input class="inputstyle" type="text" size="2" name="maxnum" id="maxnum"  onChange="fieldcheck(this,'^(-?\\d+)(\\.\\d+)?$','定编')" value="<%=maxnum%>"></td>
        		</tr>
        		
        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003b")%></td><!-- 在编 -->
          			<td class="FieldValue"><input type="hidden" size="2" name="curnum" id="curnum" value="<%=curnum%>"><%=curnum%></td>
        		</tr>

        		<tr>
          			<td class="FieldName"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da0a003c")%></td><!--缺编  -->
          			<td class="FieldValue"><%=neednum%></td>
        		</tr>
        		<tr>
        		<td class="FieldName"><%=labelService.getLabelNameByKeyId("402881ee0c715de3010c71b909de0019")%></td><!--  状态-->
          			<td class="FieldValue"><select name="stationStatus" id="stationStatus">
          			<%PageHelper.outputOptions(stationStatusMap,"402880d319eb81720119eba4e1e70004",out);%>
          			</select></td>
        		</tr>
 				</tbody>
 			</table>
 			
		</form>

<script language="javascript">
    Ext.onReady(function(){
                         Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
            <%=pagemenustr%>
        <%}%>
        });
 function getBrowser(viewurl, inputname, inputspan, isneed) {
            var id;
            try {
                id = window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
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
 <!--
   function onSubmit(){
   	 checkfields="objname,orgid,maxnum,parentobjid";
   	 checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	 if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
     }
   }
   function onReturn(){
     history.go(-1);
   }

	function fillotherselect(elementobj,fieldid,rowindex){
		var elementvalue = Trim(getValidStr(elementobj.value));
		var objname = "field_"+fieldid+"_fieldcheck";
		var fieldcheck = Trim(getValidStr(document.all(objname).value));

		if(fieldcheck=="")
			return;	
			var sql = "select ''  id,' '  objname   from selectitem union (select id,objname from selectitem where pid = '"+elementvalue+"')";

		DataService.getValues(sql,{
		  callback:function(dataFromServer) {
			createList(dataFromServer, fieldcheck,rowindex);
		  }
		});  	
	}

    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = select_array[loop];
			if(rowindex != -1)
				objname += "_"+rowindex;
		    DWRUtil.removeAllOptions(objname);
		    DWRUtil.addOptions(objname, data,"id","objname");
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}

 -->
 </script>
  
  </body>
</html>
 			
 			
