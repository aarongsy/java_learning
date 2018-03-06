<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissionruleService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>

<%
  FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
  String objtype= StringHelper.null2String(request.getParameter("objtype"),"2");
  isSysAdmin = false;
  if(BaseContext.getRemoteUser().getUsername().equals("sysadmin"))
  isSysAdmin=true;

  
%>



<html>
  <head>

  </head>
  <body><!--"系统权限"-->  
<!--页面菜单开始-->     
<%
pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aabb6f6010aabbda07e0009") + "','S','accept',function(){onSubmit()});";
//pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881e60aabb6f6010aabe32990000f") + "','B','arrow_redo',function(){window.close()});";
%>
      <style type="text/css">
          .x-toolbar table {
              width: 0
          }

          #pagemenubar table {
              width: 0
          }

          .x-panel-btns-ct {
              padding: 0px;
          }

          .x-panel-btns-ct table {
              width: 0
          }
      </style>
      <script src='<%= request.getContextPath()%>/dwr/interface/SysresourceService.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

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
<div id="pagemenubar" style="z-index:100;"></div> 
<!--页面菜单结束-->   

 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysGroupAction?action=create" name="EweaverForm"  method="post">
 
 <table class=noborder>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	
	<tr class=Title>
		<th colspan=2 nowrap></th>
	</tr>
	<tr>
    	<td class="Line" colspan=2 nowrap>
		</td>		        	  
	 </tr>	
	  <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001")%><!-- 顺序 -->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" onblur="fieldcheck(this,'^-?\\d+$','<%=labelService.getLabelNameByKeyId("402881e50ad58ade010ad58f1aef0001")%>')"   name="dsporder"/>
		</td>
	 </tr> 
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460003")%><!-- 名称 -->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="groupname" onchange='checkInput("groupname","groupnamespan")'/>
			 <span id = "groupnamespan"><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
		</td>
	 </tr>	
 	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000")%><!-- 描述 -->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="groupdesc"/>
		</td>
	 </tr> 	
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c002e")%><!-- 类型 -->
	   </td>
	   <td class="FieldValue">
           <select name="grouptype">
               <%if(isSysAdmin){%><option value="1" <%if(objtype.equals("1")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050002")%></option> <%}%>
               <option value="2" <%if(objtype.equals("2")){%>selected<%}%>><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050003")%></option>
           </select>
		</td>
	 </tr>
  	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelNameByKeyId("402883bd358a00ee01358a00f20c0031")%><!-- 排序 -->
	   </td>
	   <td class="FieldValue">
           <select name="orderfield">
               <option></option>
              <%
                List listformfield=formfieldService.getAllFieldByFormId("402881e80c33c761010c33c8594e0005");
                  for(int i=0;i<listformfield.size();i++){
                   Formfield formfield=(Formfield)listformfield.get(i);
                   if(StringHelper.isEmpty(formfield.getLabelname()))continue;
                %>
                   <option value="<%=formfield.getId()%>"><%=formfield.getLabelname()%></option>
                  <%}%>
           </select>
           <select name="ordercontent" id="ordercontent" >
               <option value="asc"><%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%></option>
               <option value="desc"><%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%></option>
           </select>
		</td>
	 </tr>
 </table>     
</form>  
<script language="javascript">
  function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
function onSubmit(){
   	checkfields="groupname";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    

</script>     
  </body>
</html>
