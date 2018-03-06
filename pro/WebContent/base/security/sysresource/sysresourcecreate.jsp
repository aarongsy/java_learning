<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%
MenuService menuService = (MenuService) BaseContext.getBean("menuService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");

String pid= StringHelper.null2String(request.getParameter("pid"));
String objtype= StringHelper.null2String(request.getParameter("objtype"));
String pidname= pid==""?"":menuService.getMenu(pid).getMenuname();

Selectitem selectitem = new Selectitem();
List selectitemlist = selectitemService.getSelectitemList("402881e80b9a072f010b9a36bfc80009",null);//资源类型    

%>
 <%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881e60aabb6f6010aabbda07e0009")+"','S','accept',function(){onSubmit()});";
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
  
  <body><!--"系资源"-->
   <div id="pagemenubar" style="z-index:100;"></div>
  <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysresourceAction?action=create" name="EweaverForm"  method="post">
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
			 <input type="text" class="InputStyle2" style="width=95%" name="resname" onChange="checkInput('resname','resnamespan')"/>
			 <span id="resnamespan"/><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc9580e7002f")%><!-- 资源类型-->
	   </td>
	   <td class="FieldValue">
     	 <select class="inputstyle" id="restype" name="restype" >
            <option value="<%=Constants.RESTYPE_URL%>" select>URL</option>
            <option value="<%=Constants.RESTYPE_FUNCTION%>" >FUNCTION</option>
		 </select>	
	   
			 <!-- input type="text" class="InputStyle2" style="width=95%" name="restype"/-->
		</td>
	 </tr>	
	<tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc96cb430030")%><!-- 资源串-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="resstring" onChange="checkInput('resstring','resstringspan')"/>
			 <span id="resstringspan"/><img src=<%= request.getContextPath()%>/images/base/checkinput.gif></span>
		</td>
	 </tr>	   
	 <tr style="display:none">
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b65f558010b65f9d4d40003")%><!-- 系统模块-->
	   </td>
	   <td class="FieldValue">
			<button type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/menu/menubrowser.jsp?menutype=3','pid','pidspan','1');"></button>
			<input type="hidden"  name="pid" value="<%=pid%>"/>
			<span id="pidspan"/></span>
		</td>
	 </tr>	 
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881eb0bcbfd19010bcc6a98200020 ")%><!-- 资源描述-->
	   </td>
	   <td class="FieldValue">
			 <input type="text" class="InputStyle2" style="width=95%" name="resdesc"/>
		</td>
	 </tr>	 
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
                   %>
                  	 <option value='<%=selectitem.getId()%>'  <%if (selectitem.getId().equals(objtype)){%><%="selected"%> <%}%>><%=selectitem.getObjname()%></option>                   
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
			<input type="checkbox"   name="islog" value="0" onClick="javascript:onCheck();"/>
		</td>
	 </tr>	  
	 <tr>
	    <td class="FieldName" nowrap>
			<%=labelService.getLabelName("402881e70b65e2b3010b65e466610003")%><!-- 日志类型-->
	   </td>
	   <td class="FieldValue">
			<button  type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/base/selectitem/selectitembrowser.jsp?typeid=402881e50acce3e2010acd3ea4e70003','logtype','logtypespan','0');"></button>
			<input type="hidden"  name="logtype" />
			<span id="logtypespan"/></span>
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
