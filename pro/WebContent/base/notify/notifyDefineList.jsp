<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>

<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.base.notify.model.NotifyDefine" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>

<%
   String categoryId = StringHelper.null2String(request.getParameter("categoryId"));
   CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
   String formId=StringHelper.null2String(categoryService.getCategoryById(categoryId).getPFormid());
   NotifyDefineService notifyDefineService = (NotifyDefineService) BaseContext.getBean("notifyDefineService");
   Map filter=new HashMap();
   filter.put("categoryId",categoryId);
   List notifyDefineList = notifyDefineService.findBy(filter);
   NotifyDefine notifyDefine=new NotifyDefine();


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
if(!formId.equals(""))
pagemenustr += "{C,"+labelService.getLabelName("402881eb0bcbfd19010bcc7bf4cc0028")+",javascript:onCreate('"+request.getContextPath()+"/base/notify/notifyDefineCreate.jsp?categoryId="+categoryId+"&formId="+formId+"')}";
%>
<div id="pagemenubar" style="z-index:100;"></div>

<%@ include file="/base/pagemenu.jsp"%>
<!--页面菜单结束-->

   <form action="<%=request.getContextPath()%>/base/notify/notifyDefineList.jsp" name="EweaverForm"  method="post">
   <input type="hidden" name="searchName" value="">
  
 <table>
       	<COLGROUP>
      		<COL width="">
			<COL width="50%">
			<COL width="10%">
		</COLGROUP>
	<tr class="Header">
		<th nowrap>提醒名称</th>
        <th nowrap>内容</th>
        <th nowrap>类型</th>

	</tr>
	<%
	     if (notifyDefineList.size()!=0 && !formId.equals("")) {
	   		boolean isLight=false;
			String trclassname="";
			for (int i=0;i<notifyDefineList.size();i++){
			  notifyDefine = (NotifyDefine) notifyDefineList.get(i);
			  isLight=!isLight;
			  if(isLight) trclassname="DataLight";
			  else trclassname="DataDark";

	%>
	  <tr class="<%=trclassname%>">
	    <td nowrap>
	      <a href="javascript:onCreate('<%=request.getContextPath()%>/base/notify/notifyDefineView.jsp?id=<%=notifyDefine.getId()%>')"><%=StringHelper.null2String(notifyDefine.getNotifyName())%></a>
	    </td>
	    <td nowrap>
	      <%=StringHelper.null2String(notifyDefine.getContent())%>
	    </td>
        <td nowrap>
	      <%if(notifyDefine.getRemindType()==1){%>到期提醒<%}else{if(notifyDefine.getRemindType()==4){%>即时提醒<%}}%>
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
  function onCreate(url){
	  openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url="+url);
    window.location.reload();
  }
function onSearch(){
  var objname=document.all("inputText").value;
  objname=encodeURI(Trim(objname));
  EweaverForm.action="<%=request.getContextPath()%>/base/notify/notifyDefineList.jsp?objname="+objname;
  EweaverForm.submit();
}
</SCRIPT>
  </body>
</html>
