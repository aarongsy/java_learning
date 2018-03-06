<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="com.eweaver.base.Constants"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %> 
<%@ page import="com.eweaver.document.base.service.AttachService" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<html>
<%
String reportid=StringHelper.null2String(request.getParameter("reportid"));
String isformbase=StringHelper.null2String(request.getParameter("isformbase"));
String curdate= DateHelper.getCurrentDate();
if(StringHelper.isEmpty(isformbase)){
isformbase="1";
}
String sql="select * from reportfield where reportid='"+reportid+"' and isdelete=0 order by dsporder asc ";
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
ForminfoService forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
SelectitemService selectitemService=(SelectitemService)BaseContext.getBean("selectitemService");
RefobjService refobjService=(RefobjService)BaseContext.getBean("refobjService");
AttachService attachService=(AttachService)BaseContext.getBean("attachService");
ReportdefService reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");
Reportdef reportdef=reportdefService.getReportdef(reportid);
String formidt=reportdef.getFormid();
Forminfo Forminfomain=new Forminfo();
String objtablename="";

String secformid=reportdef.getSecformid();
Forminfo finfosec=new Forminfo();
if(!StringHelper.isEmpty(secformid)){
 finfosec=forminfoService.getForminfoById(secformid);
}
 Forminfo finfo=forminfoService.getForminfoById(formidt);
 String maintablename=finfo.getObjtablename();
 if(finfo.getObjtype()==1&&!StringHelper.isEmpty(finfosec.getId())){
 String forminfotable = finfo.getObjtablename();
  String sqlform = "select id from forminfo where objtablename='" + forminfotable + "' and objtype=0";
 List listform = baseJdbcDao.getJdbcTemplate().queryForList(sqlform);
  String forminfoid="";
for (Object o : listform) {
forminfoid = ((Map) o).get("id") == null ? "" : ((Map) o).get("id").toString();
 }
Forminfomain=forminfoService.getForminfoById(forminfoid);
maintablename=Forminfomain.getObjtablename();
objtablename=Forminfomain.getObjtablename()+","+finfosec.getObjtablename();
}else{
objtablename=finfo.getObjtablename();
}
String sqlwhere="where "+maintablename+".requestid in( select id from formbase fb where fb.isdelete<>1 )";
if(isformbase.equals("1")){//表单
if(finfo.getObjtype()==1){
sqlwhere=maintablename+".requestid="+finfosec.getObjtablename()+".requestid and "+maintablename+".requestid in( select id from formbase fb where fb.isdelete<>1 )";
}else{
sqlwhere=maintablename+".requestid in( select id from formbase fb where fb.isdelete<>1 )";
}

}else if(isformbase.equals("2")){//流程
if(finfo.getObjtype()==1){
sqlwhere=maintablename+".requestid="+finfosec.getObjtablename()+".requestid and "+maintablename+".requestid in( select id from requestbase fb where fb.isdelete<>1 )";
}else{
sqlwhere=maintablename+".requestid in( select id from requestbase fb where fb.isdelete<>1 )";
}
sqlwhere += " and " + maintablename+".printstate='2c91a0302d36b806012d36d2f2b7000c'";
}else if(isformbase.equals("0")){//全部

if(finfo.getObjtype()==1){
sqlwhere=maintablename+".requestid="+finfosec.getObjtablename()+".requestid and ("+maintablename+".requestid in( select id from requestbase fb where fb.isdelete<>1 ) or "+maintablename+".requestid in( select id from formbase fb where fb.isdelete<>1 ))";

}else{
sqlwhere="("+maintablename+".requestid in( select id from requestbase fb where fb.isdelete<>1 ) or "+maintablename+".requestid in( select id from formbase fb where fb.isdelete<>1 ))";

}

}
List list=baseJdbcDao.getJdbcTemplate().queryForList(sql);

%>
  <head>
   <title><%=labelService.getLabelNameByKeyId("402883de35273f910135273f955b0039")%><!-- 南京方天电力有限公司 --></title>
</head>
  <body>
  <table>
 <!-- <tr style="text-align:center;"><td colspan="2" ><font size="5px">印刷信息列表</font></td></tr> -->
    <tr style="text-align:center"><td colspan="2" style="text-align:center"><font size="2px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=reportdef.getObjname()%> </font></td></tr>
   <tr><td colspan="2">
  <table width="100%" border="1" style="border-collapse:collapse;border:1px solid #EAEAEA" bordercolor="#EAEAEA">
<COLGROUP>
<%for(int i=0;i<list.size();i++){ %>
<COL width=2%>
<%} %>
</COLGROUP>
<tr style="height:20px;text-align:center;font-weight:bold;background-color:#EAEAEA;" >
<%
String  fieldnamestr="";
String objtable="";
String fieldname="";
List listf=new ArrayList();
for(int i=0;i<list.size();i++){
String showname=((Map) list.get(i)).get("showname") == null ? "" : ((Map) list.get(i)).get("showname").toString();
String formfieldid=((Map) list.get(i)).get("formfieldid") == null ? "" : ((Map) list.get(i)).get("formfieldid").toString();
fieldname=formfieldService.getFormfieldById(formfieldid).getFieldname();
String formid=formfieldService.getFormfieldById(formfieldid).getFormid();
objtable=forminfoService.getForminfoById(formid).getObjtablename();
if("".equals(fieldnamestr)){
fieldnamestr=objtable+"."+fieldname;
}else{
fieldnamestr+=","+objtable+"."+fieldname;
}
 %>
<td><%=showname %></td>
<%} %>
</tr>
<%
listf=StringHelper.string2ArrayList(fieldnamestr,",");
String sql2="select "+maintablename+".id,"+maintablename+".requestid,"+fieldnamestr+" from "+objtablename+" where "+sqlwhere;
List list2=baseJdbcDao.getJdbcTemplate().queryForList(sql2);
for(int i=0;i<list2.size();i++){%>
<tr style="text-align:center">
 <% for(int j=0;j<list.size();j++){
  String formfieldid1=((Map) list.get(j)).get("formfieldid") == null ? "" : ((Map) list.get(j)).get("formfieldid").toString();
   fieldname=formfieldService.getFormfieldById(formfieldid1).getFieldname();
   int htmltype=formfieldService.getFormfieldById(formfieldid1).getHtmltype().intValue();
   String fieldtype=formfieldService.getFormfieldById(formfieldid1).getFieldtype();
   String shownamev=((Map) list2.get(i)).get(fieldname) == null ? "" : ((Map) list2.get(i)).get(fieldname).toString();
  
   if(htmltype==5&&!StringHelper.isEmpty(shownamev)){
    shownamev=selectitemService.getSelectitemById(shownamev).getObjname();
   }else if(htmltype==6&&!StringHelper.isEmpty(fieldtype)&&!StringHelper.isEmpty(shownamev)){
    Refobj refobj = refobjService.getRefobj(fieldtype);
   if (refobj != null) {
      String _reftable = StringHelper.null2String(refobj.getReftable());
      String _keyfield = StringHelper.null2String(refobj.getKeyfield());
      String _viewfield = StringHelper.null2String(refobj.getViewfield());
       String sqlref = "select " + _viewfield + " from " + _reftable + " where " + _keyfield + "=?";
        List<Map> listref =baseJdbcDao.getJdbcTemplate().queryForList(sqlref, new Object[]{shownamev});
       for (Map m : listref) {
             shownamev = m.values().toString().substring(1, (m.values().toString().length()) - 1);
            }

        }
   
   }else if(htmltype==7&&!StringHelper.isEmpty(shownamev))
    {
      Attach attach = attachService.getAttach(shownamev);
      String attachname = StringHelper.null2String(attach.getObjname());
     shownamev=attachname;
     }
  
 %>
<td><%=shownamev %></td>
 <%}%>
 </tr>
 <%} %>
</table>
 </td></tr>
  </table>
  </body>
</html>
