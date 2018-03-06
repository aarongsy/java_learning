<%@ page contentType="text/html; charset=UTF-8"%>
<%request.setAttribute("exportExcel","xxxx"); %>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="java.net.*" %>
<script type="text/javascript">
var chasm = screen.availWidth;
var mount = screen.availHeight;
function openCenterWin(url,id,w,h) {
   window.showModalDialog(url,id,'scrollbars=no,resizable=no,location=no,width=' + w + ',height=' + h + ',left=' + ((chasm - w - 10) * .5) + ',top=' + ((mount - h - 30) * .5));
}
</script>
<%
String categoryid=StringHelper.null2String(request.getParameter("categoryid"));
String url=request.getContextPath()+"/app/birthday/birthday.jsp";
if(StringHelper.isEmpty(categoryid))
categoryid="4028803529d3bbfb0129d3d18c740003";
String currentdate=DateHelper.getCurrentDate();
CategoryService categoryService=(CategoryService)BaseContext.getBean("categoryService");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService dataService = new DataService();
Category category=categoryService.getCategoryById(categoryid);
if(StringHelper.isEmpty(category.getFormid()))
return;
Forminfo forminfo=(Forminfo)forminfoService.getForminfoById(category.getFormid());
String objtable=forminfo.getObjtablename();
String sql="select objname,humresid,formid,formfieldid,viewfield from "+objtable;
List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);

if(list.size()>0){
 for(int i=0;i<list.size();i++){
	 Map m = (Map)list.get(i);
 String objnamestr="";
String objnameostr="";
 String objnamestrid="";
String objnameostrid="";
 String formfieldid= StringHelper.null2String(m.get("formfieldid"));
  String formid= StringHelper.null2String(m.get("formid")); 
  String humresid= StringHelper.null2String(m.get("humresid"));
   String viewfield= StringHelper.null2String(m.get("viewfield"));  
   String objtablename="";
  if(!StringHelper.isEmpty(formid))
 	objtablename=forminfoService.getForminfoById(formid).getObjtablename();
	String fieldname = StringHelper.isID(formfieldid) ? formfieldService.getFormfieldName(formfieldid) : formfieldid;
  	String viewfieldname = StringHelper.isID(viewfield) ? formfieldService.getFormfieldName(formfieldid) : viewfield;
 
 String sqlsel="select "+fieldname+ ","+viewfieldname+",id from "+objtablename+" where "+fieldname+" like '%"+currentdate.substring(4,currentdate.length())+"%'";
 if ("humres".equals(objtablename)) {
	 sqlsel += " and hrstatus <> '4028804c16acfbc00116ccba13802936' and hrstatus <> '4028804c16acfbc00116ccba13802937'";
 }else{
	 String isformbase = dataService.getValue("select isformbase from reportdef where formid='"+formid+"'");
	 if("1".equals(isformbase.trim())){
		 sqlsel += " and exists(select 'x' from formbase where "+objtablename+".requestid=formbase.id and formbase.isdelete=0) ";
	 }
 }
 List listsel=baseJdbcDao.getJdbcTemplate().queryForList(sqlsel);

 if(listsel.size()>0){
 for(int j=0;j<listsel.size();j++){
 	String objname=((Map)listsel.get(j)).get(viewfieldname)==null?"":((Map)listsel.get(j)).get(viewfieldname).toString();
 	String id=((Map)listsel.get(j)).get("id")==null?"":((Map)listsel.get(j)).get("id").toString();
	if(StringHelper.isEmpty(humresid)){ 
		 if(StringHelper.isEmpty(objnamestrid)){
		 	 objnamestrid = id;
			 objnamestr=objname;
		 }else{
		 	 objnamestrid+=","+id;
		 	 objnamestr+=","+objname;
		  }
	}else{
	   if(StringHelper.isEmpty(objnameostrid)){
	    objnameostrid=id;
	    objnameostr=objname;
	   }else{
	   	objnameostrid+=","+id;
	    objnameostr+=","+objname;
	  }
	}

 }//end listsel
 }//end if
 
 
	if(!StringHelper.isEmpty(objnamestr)){
		if(!StringHelper.isEmpty(objtablename)&&"humres".equals(objtablename)){
%>
	<script>openCenterWin('<%=url%>?o=<%=URLEncoder.encode(objnamestrid, "UTF-8")%>&tablename=<%=URLEncoder.encode(objtablename, "UTF-8")%>','w<%=i%>',495,420);</script>
	<%}else{%>
	<script>openCenterWin('<%=url%>?o=<%=URLEncoder.encode(objnamestr, "UTF-8")%>&tablename=<%=URLEncoder.encode(objtablename, "UTF-8")%>','w<%=i%>',495,420);</script>
<%}}else if(!StringHelper.isEmpty(objnameostr)){
		if(humresid.contains(eweaveruser.getId())){
			if(!StringHelper.isEmpty(objtablename)&&"humres".equals(objtablename)){
%>
	<script>openCenterWin('<%=url%>?o=<%=URLEncoder.encode(objnameostrid, "UTF-8")%>&tablename=<%=URLEncoder.encode(objtablename, "UTF-8")%>','w<%=i%>',495,420);</script>
	<%}else{%>
	<script>openCenterWin('<%=url%>?o=<%=URLEncoder.encode(objnameostr, "UTF-8")%>&tablename=<%=URLEncoder.encode(objtablename, "UTF-8")%>','w<%=i%>',495,420);</script>
<%			}
		}
	}
  }
}
%>