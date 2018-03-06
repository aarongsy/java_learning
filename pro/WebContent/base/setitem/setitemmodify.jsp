<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>

<%@ include file="/base/init.jsp"%>

<%
     response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	 SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    ReportdefService reportdefService = (ReportdefService) BaseContext.getBean("reportdefService");

 	 String id = request.getParameter("id");
	 Setitem setitem = setitemService.getSetitem(id);
	    	   
%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete('"+setitem.getId()+"')});";
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
  
  <body>
<%
%>
<div id="pagemenubar" style="z-index:100;"></div> 
		
		<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=modify" target="_self" name="EweaverForm"  method="post">

	    	<table>
				<colgroup> 
					<col width="20%">
					<col width="">
					<col width="">
					
				</colgroup>	
				<tr style="display:none">
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881e50ad60ffa010ad6109bf50002")%>
					</td>
					<td class="FieldValue">
						<input type="text" style="width=95%" name="id" value="<%=setitem.getId()%>" readonly />
					</td>
				</tr>				
				<tr>
					<td class="FieldName" nowrap>
						工具栏快捷搜索项名称
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="itemname" value="<%=setitem.getItemname()%>" onChange="checkInput('itemname','itemnamespan')" />
						<span id=itemnamespan></span>
					</td>
				</tr>	
				<tr>
					<td class="FieldName" nowrap>
						工具栏快捷搜索项关联报表
					</td>
					<td class="FieldValue">
                           <button  type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/report/reportbrowser.jsp','itemvalue','itemvaluespan','0');"></button>
                        <input type="hidden"  name="itemvalue" id="itemvalue" value="<%=setitem.getItemvalue()%>" onChange="checkInput('itemvalue','itemvaluespan')"/>
						<span id=itemvaluespan>
                            <%=reportdefService.getReportdef(setitem.getItemvalue()).getObjname() %>
                           </span>
					</td>
				</tr>				
				<tr>
					<td class="FieldName" nowrap>
							搜索字段
					</td>
					<td class="FieldValue">
						<input style="width=95%" type="text" name="itemdesc" value="<%=setitem.getItemdesc()%>"/>
					</td>
				</tr>	
				<TR style="display:none">
				  <td class="FieldName" nowrap>
				        <%=labelService.getLabelName("402881e90aac5fd0010aac9f68f80001")%>
				  </td>
				  <td>		  
				        <input  style="width=95%" type="text" name="setitemtypeid" value="<%=setitem.getSetitemtypeid()%>" onChange="checkInput('setitemtypeid','setitemtypeidspan')" />
						<span id=setitemtypeidspan></span>
				  </td>				  
				</TR>	
				<TR>
				  <td class="FieldName" nowrap>
				        <%=labelService.getLabelName("402881e50ad58ade010ad58f1aef0001")%>
				  </td>
				  <td>		  
				        <input  style="width=95%" type="text" name="itemorder" value="<%=StringHelper.null2String(setitem.getItemorder())%>"  />
				  </td>				  
				</TR>		
						    
		    </table>
		    	
		
		</form>  
<script language="javascript">
   function onSubmit(){
   	checkfields="itemname,itemvalue,setitemtypeid";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>"
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
   }
   function onDelete(id){
 
   	confirmmessage="<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>"
   	if( confirm(confirmmessage)){
    	document.EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=delete";
    	document.EweaverForm.submit();
   	} 
   }
       function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
 }
 </script>	
  
  </body>
</html>
