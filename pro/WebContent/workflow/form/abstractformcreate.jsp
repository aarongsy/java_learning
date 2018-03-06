<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:directive.page import="javax.sql.DataSource"/>
<%@page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@page import="com.eweaver.workflow.util.FormlinkTranslate"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
   List list=FormlinkTranslate.getAllRelaType();
   Selectitem selectitem;
    String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
    String selected=StringHelper.null2String(request.getParameter("selected"));
    
   if(!StringHelper.isEmpty(moduleid)){
       
   }
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
%>
<html>
  <head>
    <script>
    <%if(request.getParameter("issuccess")!=null){%>
        <%if(request.getParameter("issuccess").equals("1")){%>
                window.close();
        <%}else if(request.getParameter("issuccess").equals("2")){%>
                alert('<%=labelService.getLabelName("402880c018de680d0118deaeb832000c")%>');
        <%}else if("3".equalsIgnoreCase(request.getParameter("issuccess"))){
        	String url="/workflow/form/forminfomodify.jsp?toField=true&id="+request.getAttribute("formid")+"&moduleid="+moduleid;
        	out.println("parent.location.href='"+url+"';");
        	out.println("window.close();");
        	out.println("</script>");
        	return;
        }%>
    <%}%>
	</script>
  <style type="text/css">
       .x-toolbar table {width:0}
       #pagemenubar table {width:0}
         .x-panel-btns-ct {
           padding: 0px;
       }
       .x-panel-btns-ct table {width:0}
   </style>
   
      <style type="text/css">
   #pagemenubar table {width:0}
  </style>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
  <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/util.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js"></script>
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
    <script type="text/javascript">
      Ext.onReady(function() {

          Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
          var tb = new Ext.Toolbar();
          tb.render('pagemenubar');
          <%=pagemenustr%>
      <%}%>
      });
  </script>

  </head>
  
  <body>
  <div id="pagemenubar" style="z-index:100;"></div>   
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.ForminfoAction?action=createAbstract" target="_self" name="EweaverForm"  method="post">
 <input type="hidden" value="<%=moduleid%>" name="moduleid">
 <input type="hidden" value="" name="mainformid" id="mainformid">
 <input type="hidden" value="<%=selected %>" name="linkids">
		<table name="tbl1" id="tbl1">
				<colgroup>
					<col width="20%">
					<col width="40%">
					<col width="40%">
				</colgroup>		
				<tbody>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b3390af720002")%>:<!-- 表单名称 -->
					</td>
					<td class="FieldValue" colspan="2">
						<input style="width=95%" type="text" name="tbname"  onchange="checkInput('tbname','tbnamespan')" /><span id=tbnamespan name=tbnamespan><IMG src='<%=request.getContextPath()%>/images/base/checkinput.gif' align=absMiddle></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("297ee7020b338edd010b33919af10003")%>:<!-- 表单描述 -->
					</td>
					<td  class="FieldValue" colspan="2">
						<input style="width=95%" type="text" name="tbdesc"/>
					</td>
				</tr>
				<tr id="tablenametr">
					<td class="FieldName" nowrap rowspan="<%=selected.split(",").length %>">请选择主表:</td>
					<%
					if(StringHelper.isEmpty(selected) || selected.split(",").length==0){
					%>
					<td class="FieldValue"> </td>
					<%
					}
					%>
					<%
						if(!StringHelper.isEmpty(selected)){
							String[] ids = selected.split(",");
							for(int i=0; i<ids.length; i++){
								Forminfo forminfo = forminfoService.getForminfoById(ids[i]);
								if(i!=0){
						%>
				<tr>
						<%} %>
					<td class="FieldValue">
						<input type="radio" value="<%=forminfo.getId() %>" id="mainform" name="mainform" onclick="setLink('<%=forminfo.getId() %>',<%=forminfo.getObjtype().intValue() %>);"><%=forminfo.getObjname() %>-<%=forminfo.getObjtablename() %>
					</td>
					<td class="FieldValue"><div id="<%=forminfo.getId() %>div" style="display:none;"><select id="<%=forminfo.getId() %>sel" name="<%=forminfo.getId() %>sel">
							<!-- <option value='1'><%=list.get(0)%></option>  -->
							<option value='2' selected><%=list.get(1)%></option>
							<option value='3'><%=list.get(2)%></option>
						</select></div>
					</td>
						<%if(i!=ids.length-1){ %>
				</tr>
						<%} %>
						<%
							}
						}
					%>
				</tr>
				</tbody>
			</table> 

		</form>
<script language="javascript">
var select1,input1,tbl1;

   function onSubmit(){
    if(document.EweaverForm.tbname.value==''){
        alert("<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb3938006e") %>.");//表单名称不能为空
        return false;
    }if(document.EweaverForm.mainformid.value==''){
        alert("请选择一个主表");//请选择一个主表
        return false;
    }
   	document.EweaverForm.submit();

   }	

function setLink(id, objtype){
	$("#mainformid").val(id);
	var ids = "<%=selected %>".split(",");
	for(var v=0; v<ids.length; v++){
		if(ids[v]!=id){
			$("#"+ids[v]+"div").css("display", "block");
		}
		else{
			$("#"+ids[v]+"div").css("display", "none");
		}
	}
}
var DS={
getTables:function(obj){
	var val=obj.value;
	Ext.getDom('vtableName').innerHTML='';
	Ext.getDom('dlist').innerHTML='';
	if(val!='0'){
		var opt=document.createElement('option');
		Ext.getDom('vtableName').add(opt);
		opt.value='0';opt.text=' ';
		FormfieldService.getTablesByDS(val,function(l){
			for(var i=0;i<l.length;i++){
				var opt=document.createElement('option');
				Ext.getDom('vtableName').add(opt);
				opt.value=l[i];opt.text=l[i];
			}
		});
	}
},
getFields:function(obj){
	var val=obj.value;
	Ext.getDom('dlist').innerHTML='';
	if(val!='0'){
		FormfieldService.getFieldsByTable(Ext.getDom('vdatasource').value,val,function(l){
			for(var i=0;i<l.length;i++){
				Ext.DomHelper.append('dlist',{tag:'li',html:'<input type="checkbox" value="'+l[i]+'" checked name="vfieldName"/>'+l[i]});
			}
		});
	}
}

};

function onCheckAll(o) {
	var vfieldObj = document.getElementsByName("vfieldName");
	if (vfieldObj != null && typeof(vfieldObj) != "undefined") {
        if (o.checked == true) {
            for (var i = 0 ; i < vfieldObj.length ; i++) {
                vfieldObj[i].checked = true;;
            }
        } else {
        	for (var i = 0 ; i < vfieldObj.length ; i++) {
        		vfieldObj[i].checked = false;;
            }
        }
	}
}

 </script>
  </body>
</html>