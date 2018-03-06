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
  MenuService menuService = (MenuService) BaseContext.getBean("menuService");
  SysresourceService sysresourceService = (SysresourceService) BaseContext.getBean("sysresourceService");
  SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
  Sysresource sysresource = sysresourceService.get(id);
  Selectitem selectitem = new Selectitem();
%>
<html>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e70b774c35010b7750a15b000b")+"','M','application_form_edit',function(){edit()});";
%>
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
			<%=sysresource.getResname()%>
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc9580e7002f")%><!-- 资源类型-->
	   </td>
	   <td class="FieldValue">
			 
		<% String restype = "";
		   if (sysresource.getRestype().toString().equals(Constants.RESTYPE_URL))
		      restype = "URL";
	       if (sysresource.getRestype().toString().equals(Constants.RESTYPE_FUNCTION))
	          restype = "FUNCTION";
		%>
		<%=restype%>
		 
			 
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc96cb430030")%><!-- 资源串-->
	   </td>
	   <td class="FieldValue">
			<%=StringHelper.null2String(sysresource.getResstring())%>
		</td>
	 </tr>	   
	 <tr style="display:none">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b65f558010b65f9d4d40003")%><!-- 系统模块-->
	   </td>
	   <td class="FieldValue">
               <%
			 String menuname=labelService.getLabelName(StringHelper.null2String(menuService.getMenu(sysresource.getPid()).getMenuname()));  // 把menuname存放的是标签管理的关键字
             if(StringHelper.isEmpty(menuname))
              menuname=StringHelper.null2String(menuService.getMenu(sysresource.getPid()).getMenuname());
			%>
            <%=menuname%>
		</td>
	 </tr>	 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc6a98200020 ")%><!-- 资源描述-->
	   </td>
	   <td class="FieldValue">
			<%=StringHelper.null2String(sysresource.getResdesc())%>
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
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc88fa9d002d")%><!-- 资源类型-->
	   </td>
	   <td class="FieldValue">
			<%=selectitemname%>				
		</td>
	 </tr>	 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70be696fd010be6b390970093")%><!-- 是否记录日志-->
	   </td>
	   <td class="FieldValue">
			<input type="checkbox"   name="islog" value="<%=StringHelper.null2String(sysresource.getIslog())%>" <%if (StringHelper.null2String(sysresource.getIslog()).equals("1")) {%><%="checked"%> <%}%>  readonly/>
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
			<%=labelService.getLabelName("402881e70b65e2b3010b65e466610003")%> <!-- 日志类型-->
	   </td>
	   <td class="FieldValue">
            <%=logtypename%>
		</td>
	 </tr>  
  </table>
  </form>
  </body>
<script type="text/javascript">
    function edit(){
        document.location.href="<%=request.getContextPath()%>/base/security/sysresource/sysresourcemodify.jsp?id=<%=id%>";
    }
</script>
</html>
