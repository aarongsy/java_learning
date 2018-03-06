<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.module.service.ModuleService" %>
<%@ page import="com.eweaver.base.module.model.Module" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ include file="/base/init.jsp"%>
<%
 pagemenustr =  "addBtn(tb,'确定','S','accept',function(){OnConfirm()});";
    SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
    Setitem setitem7 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt094"); 
    Setitem setitem8 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt095"); 
    Setitem setitem10 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt097"); 
    Setitem setitem12 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt099"); 
    Setitem setitem13 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt100"); 
    Setitem setitem14 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt101"); 
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
 <script type="text/javascript" src="<%=request.getContextPath()%>/js/document.js"></script>
 <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
   <script type="text/javascript">
     Ext.onReady(function() {
         Ext.QuickTips.init();
     <%if(!pagemenustr.equals("")){%>
         var tb = new Ext.Toolbar();
         tb.render('pagemenubar');
         <%=pagemenustr%>
     <%}%>
     	loadFormFields(true);
     	hiddenOrShowBorrow();
     });
     
     function clearSelect(selId){
     	var sel = document.getElementById(selId);
		while(sel.childNodes.length > 0)	//清空下拉列表
		{
			sel.removeChild(sel.childNodes[0]);
		}	
     }
     
     function bindSelect(selId,v){
     	var sel = document.getElementById(selId);
     	for(var i = 0; i < sel.options.length; i++){
     		if(sel.options[i].value == v){
     			sel.options[i].selected = true;
     			break;
     		}
     	}
     }
     
     function loadFormFields(doBind){
     	var workflowId = document.getElementById("292e269b2d530567012d5a31ef5gt093").value;
     	Ext.Ajax.request({   
			url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=getFormfieldByWorkflowidWithJSONData',   
			method : 'post',
			params:{   
				workflowId : workflowId
			}, 
			success: function (response)    
	        {   
	        	function createOption(data){
	        		var option = new Option(data["labelname"] + "-" + data["fieldname"],data["fieldname"]);
	        		return option;
	        	}
				var datas = Ext.decode(response.responseText);
				clearSelect("292e269b2d530567012d5a31ef5gt094");
				clearSelect("292e269b2d530567012d5a31ef5gt095");
				clearSelect("292e269b2d530567012d5a31ef5gt097");
				clearSelect("292e269b2d530567012d5a31ef5gt099");
				clearSelect("292e269b2d530567012d5a31ef5gt100");
				clearSelect("292e269b2d530567012d5a31ef5gt101");
				var startDateFields = document.getElementById("292e269b2d530567012d5a31ef5gt094");
				var endDateFields = document.getElementById("292e269b2d530567012d5a31ef5gt095");
				var docFields = document.getElementById("292e269b2d530567012d5a31ef5gt097");
				var browwerFields = document.getElementById("292e269b2d530567012d5a31ef5gt099");
				var isforeverFields = document.getElementById("292e269b2d530567012d5a31ef5gt100");
				var isactiveFields = document.getElementById("292e269b2d530567012d5a31ef5gt101");
				for(var i = 0; i < datas.length; i++){
					if(datas[i]["htmltype"] == 6){	//选择项
						docFields.options.add(createOption(datas[i]));
						browwerFields.options.add(createOption(datas[i]));
					}else if(datas[i]["htmltype"] == 1 && datas[i]["fieldtype"] == 4){	//日期
						startDateFields.options.add(createOption(datas[i]));
						endDateFields.options.add(createOption(datas[i]));
					}else if(datas[i]["htmltype"] == 4){	//checkbox
						isforeverFields.options.add(createOption(datas[i]));
						isactiveFields.options.add(createOption(datas[i]));
					}
				}
				if(doBind){
					bindSelect("292e269b2d530567012d5a31ef5gt094",'<%=StringHelper.null2String(setitem7.getItemvalue())%>');
	     			bindSelect("292e269b2d530567012d5a31ef5gt095",'<%=StringHelper.null2String(setitem8.getItemvalue())%>');
	     			bindSelect("292e269b2d530567012d5a31ef5gt097",'<%=StringHelper.null2String(setitem10.getItemvalue())%>');
	     			bindSelect("292e269b2d530567012d5a31ef5gt099",'<%=StringHelper.null2String(setitem12.getItemvalue())%>');
	     			bindSelect("292e269b2d530567012d5a31ef5gt100",'<%=StringHelper.null2String(setitem13.getItemvalue())%>');
	     			bindSelect("292e269b2d530567012d5a31ef5gt101",'<%=StringHelper.null2String(setitem14.getItemvalue())%>');
     			}
	        },
		 	failure: function(response,opts) {    
			 	Ext.Msg.alert('loadFormFields Error', response.responseText);   
			}  
		}); 
   }
   
   function hiddenOrShowBorrow(){
   	  var isUseBorrow = document.getElementById("292e269b2d530567012d5a31ef5gt092");
   	  if(isUseBorrow.checked){
   	  	document.getElementById("borrowWorkflowTR").style.display = "block";
        document.getElementById("borrowStartDateFieldTR").style.display = "block";
        document.getElementById("borrowEndDateFieldTR").style.display = "block";
        document.getElementById("borrowOtherConditionTR").style.display = "block";
        document.getElementById("docFieldTR").style.display = "block";
        document.getElementById("isforeverFieldTR").style.display = "block";
        document.getElementById("browwerFieldTR").style.display = "block";
        document.getElementById("isactiveFieldTR").style.display = "block";
   	  }else{
   	  	document.getElementById("borrowWorkflowTR").style.display = "none";
        document.getElementById("borrowStartDateFieldTR").style.display = "none";
        document.getElementById("borrowEndDateFieldTR").style.display = "none";
        document.getElementById("borrowOtherConditionTR").style.display = "none";
        document.getElementById("docFieldTR").style.display = "none";
        document.getElementById("isforeverFieldTR").style.display = "none";
        document.getElementById("browwerFieldTR").style.display = "none";
        document.getElementById("isactiveFieldTR").style.display = "none";
   	  }
   }
 </script>
</head>
<div id="pagemenubar"> </div>
<body>
<form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=doc" name="EweaverForm" method="post">
    <table>
          <colgroup>
                <col width="20%">
                <col width="">
            </colgroup>
        <tr>
            <td class="FieldName" nowrap >文档是否压缩</td>
            <td class="FieldValue" colspan="2">
                  <%
                       Setitem setitem1=setitemService.getSetitem("402881e50b14f840010b14fbae82000a");
                        String selected1no="";
                          String selected1yes="";
                        if(setitem1.getItemvalue().equals("1")) {
                            selected1yes="selected";
                        } else{
                            selected1no="selected";
                        }
                    %>
                <select style="width:40%;" id="402881e50b14f840010b14fbae82000a" name="402881e50b14f840010b14fbae82000a">
                    <option value="1" <%=selected1yes%>>是</option>
                      <option value="0" <%=selected1no%>>否</option>
                </select>
            </td>
        </tr>
          <tr>
            <td class="FieldName" nowrap>文件保存路径</td>
            <td class="FieldValue" colspan="2">
                <%
                    Setitem setitem2=setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a");
                
                %>
               <input type="text" name="402881e80b7544bb010b754c7cd8000a" id="402881e80b7544bb010b754c7cd8000a" style="width:90%;" value="<%=setitem2.getItemvalue()%>">
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap >启用附件大小控件检测</td>
            <td class="FieldValue" colspan="2">
                  <%
                       	Setitem setitem15=setitemService.getSetitem("402881e50b14f840010b14fbae82000b");
                        String selected15no="";
                        String selected15yes="";
                        if(setitem15.getItemvalue().equals("1")) {
                        	selected15yes="selected";
                        } else{
                        	selected15no="selected";
                        }
                    %>
                <select style="width:40%;" id="402881e50b14f840010b14fbae82000b" name="402881e50b14f840010b14fbae82000b">
                    <option value="1" <%=selected15yes%>>是</option>
                      <option value="0" <%=selected15no%>>否</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="FieldName" nowrap>文档附件大小</td>
            <td class="FieldValue" colspan="2">
                    <%
                    Setitem setitem3=setitemService.getSetitem("402881e50b14f840010b153bbc17000b");

                %>
               <input type="text" name="402881e50b14f840010b153bbc17000b" id="402881e50b14f840010b153bbc17000b" style="width:90%;" value="<%=setitem3.getItemvalue()%>">M
            </td>
        </tr>
         <tr>
            <td class="FieldName" nowrap> FTP上传文件目录(区分大小)</td>
            <td class="FieldValue" colspan="2">
                   <%
                    Setitem setitem4=setitemService.getSetitem("40288183121d455601121d5c78640053");

                %>
               <input type="text" name="40288183121d455601121d5c78640053" id="40288183121d455601121d5c78640053" style="width:90%;" value="<%=setitem4.getItemvalue()%>">
            </td>
        </tr>
        <tr>
        	<td class="FieldName" nowrap>是否使用文档借阅</td>
        	<td class="FieldValue" colspan="2">
        		<% Setitem setitem5 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt092"); %>
        		<input type="checkbox" name="292e269b2d530567012d5a31ef5gt092" id="292e269b2d530567012d5a31ef5gt092" <%if("1".equals(setitem5.getItemvalue())){ %> checked="checked" <%} %> value="1" onclick="javascript:hiddenOrShowBorrow();"/>
        	</td>
        </tr>
        <tr id="borrowWorkflowTR" style="display:none;">
        	<td class="FieldName" nowrap>文档借阅流程</td>
        	<td class="FieldValue" colspan="2">
        		<% Setitem setitem6 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt093"); 
        		   WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
				   String workflowNames = workflowinfoService.getWorkflowNames(setitem6.getItemvalue());
        		%>
        		<button type=button  class=Browser name="button_292e269b2d530567012d5a31ef5gt093" onclick="javascript:getrefobj('292e269b2d530567012d5a31ef5gt093','292e269b2d530567012d5a31ef5gt093span','402880371d60e90c011d6107be5c0008','','0');"></button>
        		<input type="hidden" name="292e269b2d530567012d5a31ef5gt093" id="292e269b2d530567012d5a31ef5gt093" value="<%=setitem6.getItemvalue() %>" onpropertychange="javascript:loadFormFields();"/>
        		<span id="292e269b2d530567012d5a31ef5gt093span" name="292e269b2d530567012d5a31ef5gt093span"><%=workflowNames %></span>
        	</td>
        </tr>
        <tr id="docFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>文档标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt097" name="292e269b2d530567012d5a31ef5gt097">
                </select>
        	</td>
        </tr>
        <tr id="browwerFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>借阅人标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt099" name="292e269b2d530567012d5a31ef5gt099">
                </select>
        	</td>
        </tr>
        <tr id="borrowStartDateFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>借阅开始时间标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt094" name="292e269b2d530567012d5a31ef5gt094">
                </select>
        	</td>
        </tr>
        <tr id="borrowEndDateFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>借阅结束时间标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt095" name="292e269b2d530567012d5a31ef5gt095">
                </select>
        	</td>
        </tr>
        <tr id="isforeverFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>是否永久借阅标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt100" name="292e269b2d530567012d5a31ef5gt100">
                </select>
        	</td>
        </tr>
        <tr id="isactiveFieldTR" style="display:none;">
        	<td class="FieldName" nowrap>审批是否同意标识字段</td>
        	<td class="FieldValue" colspan="2">
        		<select style="width:25%;" id="292e269b2d530567012d5a31ef5gt101" name="292e269b2d530567012d5a31ef5gt101">
                </select>
        	</td>
        </tr>
        <!-- 
        <tr id="borrowDateOtherConditionTR" style="display:none;">
        	<td class="FieldName" nowrap>时间段内嵌其他条件</td>
        	<td class="FieldValue">
        		<% Setitem setitem11 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt098"); %>
        		<textarea rows="4" cols="45" name="292e269b2d530567012d5a31ef5gt098" id="292e269b2d530567012d5a31ef5gt098"><%=StringHelper.null2String(setitem11.getItemvalue()) %></textarea>
        	</td>
        	<td class="FieldValue">
        		注：此条件会和借阅起止时间条件放在一个()内,和借阅起止时间并列使用作为sql语句的查询条件,如假如有"是否永久借用"字段和时间起止判断并列使用，可在此处加入条件: or isforever = 1
        	</td>
        </tr> -->
        <tr id="borrowOtherConditionTR" style="display:none;">
        	<td class="FieldName" nowrap>其他后缀标识条件</td>
        	<td class="FieldValue">
        		<% Setitem setitem9 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt096"); %>
        		<textarea rows="4" cols="45" name="292e269b2d530567012d5a31ef5gt096" id="292e269b2d530567012d5a31ef5gt096"><%=StringHelper.null2String(setitem9.getItemvalue()) %></textarea>
        	</td>
        	<td class="FieldValue">
        		注：此条件将作为sql语句的查询条件放置在sql语句的末尾,例如：and isactive = 1
        	</td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    function OnConfirm(){
        document.EweaverForm.submit();
    }
</script>
</body>
</html>