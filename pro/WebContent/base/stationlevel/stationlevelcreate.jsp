<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.*"%>
<%@ page import="com.eweaver.base.selectitem.service.*"%>
<%
String id=StringHelper.null2String(request.getParameter("id"));
SelectitemService selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
Selectitem stationlevel=selectitemService.getSelectitemById(id);
%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','N','accept',function(){onSubmit()});";
%>
<html>
  <head>
<title>岗位级别信息</title>
        <style type="text/css">
      .x-toolbar table {width:0}
      #pagemenubar table {width:0}
        .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
</style>
   
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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
  <body><!--"系统权限"-->
<div id="pagemenubar" style="z-index:100;"></div> 
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.stationlevel.servlet.StationlevelAction?action=save&close=true" name="EweaverForm"  method="post">
<input type="hidden" name="id" value="<%=id%>">
<table class=noborder>
<colgroup> 
	<col width="30%">
	<col width="70%">
</colgroup>	
<tr class=Title>
	<th colspan=2 nowrap>岗位级别信息</th>		        	  
</tr>
<tr>
   	<td class="Line" colspan=2 nowrap>
	</td>		        	  
 </tr>	
 <tr>
   <td class="FieldName" nowrap>岗位级别名称</td>
   <td class="FieldValue">
	 <input type="text" class="InputStyle2" style="width=95%" name="objname" value="<%=StringHelper.null2String(stationlevel.getObjname())%>" onchange='checkInput("objname","objnamespan")'/>
	 <span id = "objnamespan">
	 	<%if(StringHelper.isEmpty(StringHelper.null2String(stationlevel.getObjname()))){%>
	 		<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>
	 	<%}%>
	 </span>
	</td>
 </tr>	
 <tr>
   <td class="FieldName" nowrap>岗位级别描述</td>
   <td class="FieldValue">
	<input type="text" class="InputStyle2" style="width=95%" name="objdesc"  value="<%=StringHelper.null2String(stationlevel.getObjdesc())%>">
	</td>
 </tr>
 <tr>
   <td class="FieldName" nowrap>排序</td>
   <td class="FieldValue">
	<input type="text" name="dsporder" size="2" value="<%=StringHelper.null2String(stationlevel.getDsporder())%>">
	</td>
 </tr>
 </table>    
     
     
     
</form>
<script language="javascript"> 
function onSubmit(){
   	checkfields="objname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

</script>     
  </body>
</html>
