<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.label.model.Label" %>
<%@ include file="/base/init.jsp"%>
<%
MenuService menuService =(MenuService)BaseContext.getBean("menuService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
String _target="mainframe";
List menuList = menuService.getSubMenus(null,"1,2","1");
paravaluehm.put("{currentuserid}",currentuser.getId());
paravaluehm.put("{curorgid}",currentuser.getOrgid());
String curcompanyid = orgunitService.getCompanyOrgid(currentuser.getOrgid());
paravaluehm.put("{curcompanyid}",curcompanyid);
%>

<html>
  <head>
  
<script language="javascript">
function doUrl(url){
	if(url != ""){
			parent.mainframe.location.href = "<%= request.getContextPath()%>"+url;
	
	}	

}
</script>
  </head> 
  <body >
<table height=100% cellspacing="0" cellpadding="0"> 

<%
for(int i=0;i<menuList.size();i++){
	Menu menu = (Menu)menuList.get(i);
   String _menuname=labelService.getLabelName(menu.getMenuname());  // 把menuname存放的是标签管理的关键字
    if(StringHelper.isEmpty(_menuname))
    _menuname=menu.getMenuname();
	String _url=menu.getUrl()==null?"javascript:":menu.getUrl();
	 
	 //菜单配置里参数{?}需转换
	 Iterator paravaluehmkeyit = paravaluehm.keySet().iterator();	 
	 while (paravaluehmkeyit.hasNext()) {
		String paravaluehmkey = (String)paravaluehmkeyit.next();
		_url = StringHelper.replaceString(_url,paravaluehmkey,(String)paravaluehm.get(paravaluehmkey));
	 }
	 
	String _imgfile=StringHelper.null2String(menu.getImgfile());
	String _id=menu.getId();
	String _pid=menu.getPid();
%>
	<tr height=20 style="BACKGROUND-IMAGE: url(<%=request.getContextPath()%>/images/menuleftbg.gif); BACKGROUND-REPEAT: repeat-x">
		<td><span id='A<%=_id%>'></span></td>
		<td align=center><a href='#'  onclick=doUrl('<%=_url%>'); ><%=_menuname%></a></td>
		<td><span id='B<%=_id%>'></span></td>
	</tr>	
	<tr height=5><td></td></tr>		
<%
List menuList2 = menuService.getSubMenus(_id,"1,2","1");
for(int j=0;j<menuList2.size();j++){
	 menu = (Menu)menuList2.get(j);
	 _menuname=labelService.getLabelName(menu.getMenuname());
        if(StringHelper.isEmpty(_menuname))
        _menuname=menu.getMenuname();
	 _url=menu.getUrl()==null?"javascript:":menu.getUrl();
	 
	 //菜单配置里参数{?}需转换
	 Iterator paravaluehmkeyit2 = paravaluehm.keySet().iterator();	 
	 while (paravaluehmkeyit2.hasNext()) {
		String paravaluehmkey = (String)paravaluehmkeyit2.next();
		_url = StringHelper.replaceString(_url,paravaluehmkey,(String)paravaluehm.get(paravaluehmkey));
	 }
	 
	 _imgfile=StringHelper.null2String(menu.getImgfile());
	 _id=menu.getId();
	 _pid=menu.getPid();
	  int _nodetype=menu.getNodetype().intValue();
	 if(_nodetype==0){
%>	
<script language=javascript> 
	 	document.all("A<%=_pid%>").innerHTML="<a href='#'  onclick=doUrl('<%=_url%>');><img src=<%=_imgfile%> border=0></a>"
</script>
<%
	 continue;
	 }
	
	 if(_nodetype==2){
%>	
<script language=javascript> 
	 	document.all("B<%=_pid%>").innerHTML="<a href='#'  onclick=doUrl('<%=_url%>');><img src=<%=_imgfile%> border=0></a>"
</script>
<%
	 continue;
	 }
%>		
	
	<tr height=25>		

		<td colspan=3 align=center valign=middle><img src=<%=_imgfile%>>&nbsp<a href='#'  onclick=doUrl('<%=_url%>');><%=_menuname%></a>&nbsp&nbsp&nbsp&nbsp</td>

	</tr>	


<%
}
%>
	<tr height=10><td>&nbsp</td></tr>	
<%
}
%>	
	<tr><td></td></tr>
</table>

  </body>
</html>
