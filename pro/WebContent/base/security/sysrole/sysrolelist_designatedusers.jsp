<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>

<%
   String selectItemId = StringHelper.null2String(request.getParameter("selectItemId"));
   String id = StringHelper.null2String(request.getParameter("id"));
   String objname = StringHelper.null2String(request.getParameter("objname"));
   if(selectItemId.equals("")) selectItemId = "402881ea0b8bf8e3010b8bfd2885000a";//系统角色
   SysroleService sysroleService = (SysroleService) BaseContext.getBean("sysroleService");
   SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
 //  SysuserrolelinkService sysuserrolelinkService = (SysuserrolelinkService) BaseContext.getBean("sysuserrolelinkService");
   SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
   List selectitemlist = selectitemService.getSelectitemList("402881ea0b8bf8e3010b8bfc850b0009",null);//角色类型
   Sysuser sysuser=sysuserService.getSysuserByObjid(id);
   List sysroleList = sysroleService.searchSysroleByUserid(selectItemId,objname,sysuser.getId());
   Selectitem selectitem = new Selectitem();
   Sysrole sysrole = new Sysrole();

%>
<html>
  <head>
  <STYLE>
.infoinput {
	font-size: 9pt;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-bottom-style: solid;
	border-bottom-color: #cccccc;
}
</STYLE>
</head>

  <body>
<!--页面菜单开始-->
<%
//pagemenustr += "{C,"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+",javascript:onCreate('/base/security/sysrole/sysrolecreate.jsp','1')}";
%>
<div id="pagemenubar" style="z-index:100;"></div>

<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

   <form action="<%= request.getContextPath()%>/base/security/sysrole/sysrolelist_designatedusers.jsp?id=<%=id%>" name="EweaverForm"  method="post">
   <input type="hidden" name="searchName" value="">
   <table id=searchTable>
       <tr>
		 <td class="FieldName" width=5% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcca6ef9c0034")%>:
		 </td>
         <td class="FieldValue"width="5%">
		     <select class="inputstyle" id="selectItemId" name="selectItemId" onChange="javascript:onSubmit();">
                  <%
                   Iterator it= selectitemlist.iterator();
                   while (it.hasNext()){
                      selectitem =  (Selectitem)it.next();
					  String selected = "";
					  if(selectItemId.equals(selectitem.getId())) selected = "selected";

                   %>
                   <option value=<%=selectitem.getId()%> <%=selected%>><%=selectitem.getObjname()%></option>

                   <%
                   } // end while
                   %>
	       </select>
         </td>
         <td class="FieldName" width=5% nowrap>
			 <%=labelService.getLabelName("402881eb0bcbfd19010bcca8f4b90035")%>:
		 </td>
    	<td width="80%">&nbsp;&nbsp;<input class="infoinput" name="inputText" type="text" size="10" value="<%=objname%>">
    	<input type="button" name="Button" value="Search" onClick="javascript:onSearch();"></td>
     </tr>

   </table>
 <table>
       	<COLGROUP>
      		<COL width="">
			<COL width="10%">
			<COL width="10%">
		</COLGROUP>
	<tr class="Header">
		<th nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bcca8f4b90035")%></th>
		<th nowrap><%=labelService.getLabelName("402881eb0bcbfd19010bccbcd445003a")%></th>
		<th nowrap><%=labelService.getLabelName("402881ec0bdc2afd010bdd200dea0013")%></th>
	</tr>
	<%
	     if (sysroleList.size()!=0) {
	   		boolean isLight=false;
			String trclassname="";
			for (int i=0;i<sysroleList.size();i++){
			  sysrole = (Sysrole) sysroleList.get(i);
			  isLight=!isLight;
			  if(isLight) trclassname="DataLight";
			  else trclassname="DataDark";

	%>
	  <tr class="<%=trclassname%>">
	    <td nowrap>
	      <a href="javascript:onCreate('/base/security/sysrole/sysroleview.jsp?id=<%=sysrole.getId()%>','0')"><%=StringHelper.null2String(sysrole.getRolename())%></a>
	    </td>
	    <td nowrap>
	      <a href="<%= request.getContextPath()%>/base/security/sysrole/userrolelinklist.jsp?roleId=<%=sysrole.getId()%>&id=<%=id%>&selectItemId=<%=selectItemId%>">+</a>
	    </td>
	    <td nowrap>
	      <a href="<%= request.getContextPath()%>/base/security/sysrole/rolepermslink.jsp?roleId=<%=sysrole.getId()%>&id=<%=id%>&selectItemId=<%=selectItemId%>">+</a>
	    </td>
	  </tr>

	<%
	  }// end for
	 }// end if
	%>


 </table>
 </form>
<SCRIPT language="javascript">
  function onSubmit(){
    document.EweaverForm.submit();
  }
  function onCreate(url,flag){
    if (flag=="1")
      url += "?objtype=" +  document.all("selectItemId").value;
    openDialog("<%= request.getContextPath()%>/base/popupmain.jsp?url=<%= request.getContextPath()%>"+url);
    document.EweaverForm.submit();
  }
function onSearch(){
  var objname=document.all("inputText").value;
  objname=encodeURI(Trim(objname));
  EweaverForm.action="<%= request.getContextPath()%>/base/security/sysrole/sysrolelist_designatedusers.jsp?objname="+objname+"&id=<%=id%>";
  EweaverForm.submit();
}
</SCRIPT>
  </body>
</html>
