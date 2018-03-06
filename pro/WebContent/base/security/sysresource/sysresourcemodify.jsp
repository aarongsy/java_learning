<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.label.model.Label" %>

<%
  String id = StringHelper.null2String(request.getParameter("id"));
  SysresourceService sysresourceService = (SysresourceService) BaseContext.getBean("sysresourceService");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  MenuService menuService = (MenuService) BaseContext.getBean("menuService");
  Sysresource sysresource = sysresourceService.get(id);
  Selectitem selectitem = new Selectitem();
  List selectitemlist = selectitemService.getSelectitemList("402881e80b9a072f010b9a36bfc80009",null);//资源类型    
  
%>

<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
/*
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa85e6aed0001")+"','N','add',function(){onCreate()});";
*/
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aa85b6e010aa8624c070003")+"','D','delete',function(){onDelete()});";
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

<div id="pagemenubar" style="z-index:100;"></div>
  <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=modify" name="EweaverForm"  method="post">
  <input type="hidden" name="id" value="<%=id%>"/>
  <table class=noborder>
	<colgroup> 
		<col width="30%">
		<col width="70%">
	</colgroup>	

	<tr>
    	<td class="Line" colspan=2 nowrap></td>		        	  
	</tr>		
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc694bf8001f ")%><!-- 资源名称-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="resname" value="<%=sysresource.getResname()%>" onChange="checkInput('resname','resnamespan')"/>
			 <span id="resnamespan"/></span>
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc9580e7002f")%><!-- 资源类型-->
	   </td>
	   <td class="FieldValue">
	     <select class="inputstyle" id="restype" name="restype">
            <option value="<%=Constants.RESTYPE_URL%>" <%if (sysresource.getRestype().toString().equals(Constants.RESTYPE_URL)){%> <%="selected"%> <%}%> >URL</option>
            <option value="<%=Constants.RESTYPE_FUNCTION%>"  <%if (sysresource.getRestype().toString().equals(Constants.RESTYPE_FUNCTION)){%> <%="selected"%> <%}%>>FUNCTION</option>
		 </select>
	   
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc96cb430030")%><!-- 资源串-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="resstring" value="<%=StringHelper.null2String(sysresource.getResstring())%>" onChange="checkInput('resstring','resstringspan')"/>
			 <span id="resstringspan"/></span>
		</td>
	 </tr>	   
	 <tr style="display:none">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b65f558010b65f9d4d40003")%><!-- 系统模块-->
		</td>
		<td class="FieldValue">
			<button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/menu/menubrowser.jsp?menutype=3','pid','pidspan','1');"></button>
			<input type="hidden"  name="pid" value="<%=sysresource.getPid()%>"/>
            <%
		    String menuname=labelService.getLabelName(StringHelper.null2String(menuService.getMenu(sysresource.getPid()).getMenuname()));
                if(StringHelper.isEmpty(menuname))
                menuname=StringHelper.null2String(menuService.getMenu(sysresource.getPid()).getMenuname());
			%>
            <%=menuname%>
			<span id="pidspan"/></span>
		</td>
	 </tr>	 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc6a98200020")%><!-- 资源描述-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="resdesc" value="<%=StringHelper.null2String(sysresource.getResdesc())%>"/>
		</td>
	 </tr>	 
	 <%
	   String selectitemname = "";
	   if (!StringHelper.isEmpty(sysresource.getObjtype())) {
	     selectitem = selectitemService.getSelectitemById(sysresource.getObjtype());
	     selectitemname = StringHelper.null2String(selectitem.getObjname());
	   }
	 %>	 
	 <tr>
	   <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc88fa9d002d")%><!-- 资源分类-->
	   </td>
	   <td class="FieldValue">
		    <select class="inputstyle" id="objtype" name="objtype">
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectitem.getId().equals(sysresource.getObjtype())) selected = "selected";
                   
                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>
                   
                   <%
                   } // end while
                   %>
		    </select>							
		</td>
	 </tr>
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70be696fd010be6b390970093")%><!-- 是否记录日志--> 
	   </td>
	   <td class="FieldValue">
			<input type="checkbox"   name="islog" value="<%=StringHelper.null2String(sysresource.getIslog())%>" <%if (StringHelper.null2String(sysresource.getIslog()).equals("1")) {%><%="checked"%> <%}%>  onClick="javascript:onCheck();"/>
		</td>
	 </tr>	  
	 <%
	   String logtypename = "";
	   if (!StringHelper.isEmpty(sysresource.getLogtype())) {
	     selectitem = selectitemService.getSelectitemById(sysresource.getLogtype());
	     logtypename = StringHelper.null2String(selectitem.getObjname());
	   }
	 %>	
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b65e2b3010b65e466610003")%><!-- 日志类型--> 
	   </td>
	   <td class="FieldValue">
			<button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=402881e50acce3e2010acd3ea4e70003','logtype','logtypespan','0');"></button>
			<input type="hidden"  name="logtype" value="<%=StringHelper.null2String(sysresource.getLogtype())%>"/>
			<span id="logtypespan"/><%=logtypename%></span>
		</td>
	 </tr> 
  </table>
  </form>
<script language="javascript"> 
function onSubmit(){
   	checkfields="resname,resstring";
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}    
function onDelete(){
  EweaverForm.action = "<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=delete";
  document.EweaverForm.submit();
}
function onCheck(){
  if (document.all("islog").checked) {
    document.all("islog").value="1";
  }else{
    document.all("islog").value="0";
  }
}
     function getBrowser(viewurl, inputname, inputspan, isneed) {
           var id;
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
       }
</script> 
  </body>
</html>
