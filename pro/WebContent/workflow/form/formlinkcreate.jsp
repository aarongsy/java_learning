<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.util.FormlinkTranslate"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%
String strForminfoId=request.getParameter("forminfoid");
Forminfo forminfo = ((ForminfoService)BaseContext.getBean("forminfoService")).getForminfoById(strForminfoId);
List list=FormlinkTranslate.getAllRelaType();
String moduleid=StringHelper.null2String(request.getParameter("moduleid"));
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title><%=labelService.getLabelName("402881ea0b9b879b010b9b9ae8820009")%></title> 
  	<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
  	<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
    <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
    
    

  </head>
  
  <body>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlinkAction?action=create" target="_self" name="EweaverForm"  method="post">
		<input type="hidden" name="forminfoid" value='<%=strForminfoId%>' />
				
<!--页面菜单开始-->     
<%
pagemenustr += "{S,"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+",javascript:onSubmit()}";
pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:closeWin()}";
%>
<div id="pagemenubar" style="z-index:100;"></div> 
<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束--> 

		<table>
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>			
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881ec0bdbf198010bdbf5cf580004")%>
					</td>
					<td class="FieldValue">
						<input type="hidden" name="relaTbId" id="relaTbId"/>
          				<input type="button"  class="Browser" onclick="getBrowser('/workflow/form/forminfobrowser.jsp?objtype=0&moduleid=<%=moduleid%>','relaTbId','relaTbIdspan','0');" />
             			<span id="relaTbIdspan"></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881ec0bdbf198010bdbf6a5350005")%>
					</td>
					<td class="FieldValue">
					<select name="relaType">
					<%
					    if(forminfo.getObjtype().intValue()==0)
					    {
					%>
					   	<option value='2' selected><%=list.get(1)%></option>
					   	<option value='3'><%=list.get(2)%></option>
				    <%
						}
						else{
						%>
						<option value='1' selected><%=list.get(0)%></option>    
						  <%
						  }
						  %>
    					 </select>
					</td>
				</tr><%
					    if(forminfo.getObjtype().intValue()==0)
					    {
					%>
				<!--tr>
					<td class="FieldName" nowrap>
						<%=labelService.getLabelName("402881ec0bdbf198010bdbf73bda0006")%>
					</td>
					<td class="FieldValue">
					<select name="filedMap" id = "filedMap">
    				</select>
					</td>
				</tr-->
				<%}%>
		</table>
	</form>
  </body>
    <!--调用browser -->

<script language="javascript">
	var win;
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    if(!Ext.isSafari){
    	try{
	    	id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
	    }catch(e){}
		if (id!=null) {
	    if(id[0] == "<%=strForminfoId%>"){
	       alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0021") %>");//关联表单不能是同一个表单!
	    }
		else if (id[0] != '0') {
			document.all(inputname).value = id[0];
			document.all(inputspan).innerHTML = id[1];
	        if (<%=forminfo.getObjtype().intValue()%> == 0) {
				//getformfield(document.all(inputname).value) ;
	    }
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
	
	            }
	         }
    	}else{
		//----
    	    var callback = function() {
    	            try {
    	                id = dialog.getFrameWindow().dialogValue;
    	            } catch(e) {
    	            }
    	            if (id!=null) {
    	        	    if(id[0] == "<%=strForminfoId%>"){
    	        	       alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0021") %>");//关联表单不能是同一个表单!
    	        	    }
    	        		else if (id[0] != '0') {
    	        			document.all(inputname).value = id[0];
    	        			document.all(inputspan).innerHTML = id[1];
    	        	        if (<%=forminfo.getObjtype().intValue()%> == 0) {
    	        				//getformfield(document.all(inputname).value) ;
    	        	    }
    	        	    }else{
    	        			document.all(inputname).value = '';
    	        			if (isneed=='0')
    	        			document.all(inputspan).innerHTML = '';
    	        			else
    	        			document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';
    	        	
    	        	            }
    	        	         }
    	        }
    	        if (!win) {
    	             win = new Ext.Window({
    	                layout:'border',
    	                width:window.parent.dlg0.width*0.8,
    	                height:window.parent.dlg0.height*0.8,
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
    		
		//----
 }
    function getformfield(formid){
       	DataService.getValues(createList,"select fieldname from formfield where formid='"+formid+"' and isdelete<1 ",'fieldname');
    }
    function createList(data)
	{
	    DWRUtil.removeAllOptions('filedMap');
	    DWRUtil.addOptions('filedMap',data,'fieldname','fieldname');
	}

   function onSubmit()
   {
   	checkfields="relaTbId";
   	checkmessage='<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf5cf580004") %>:<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>';//关联表单
   	if(!checkForm(EweaverForm,checkfields,checkmessage)){
   		return false;
   	}
     document.EweaverForm.submit();
   }

   function closeWin(){//相当于关闭按钮
	    var parent = window.parent;
		var dlg0 = parent.dlg0;
		var store = parent.store;
		dlg0.hide();
        dlg0.getComponent('dlgpanel').setSrc('about:blank');
        store.load({params:{start:0, limit:20}});
   }
	
    </script>
</html>
