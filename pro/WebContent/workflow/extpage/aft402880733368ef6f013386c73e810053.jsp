<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//当前工作流包含表单是实际表单
//表单ID:402880733368ef6f013386717a35000e	文档借阅表单
//	借阅结束时间:	enddate
//	文档名称:	doctitle
//	开始时间:	startdate
//	文档ID:	docid
//	借阅人:	browwer
//	是否永久借阅:	isforever
//	文档:	doc
//	文档编号:	docno
//	借阅说明:	comments
//	借阅类型:	borrowtype
//	文档作者:	author
//	创建人部门:	docdept
//	是否同意:	isactive
//---------------------------------------
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
   <%@ page import="org.springframework.beans.BeanUtils"%>
   <%@ page import="com.eweaver.base.BaseJdbcDao"%>
   <%@ page import="com.eweaver.base.BaseContext"%>
   <%@ page import="com.eweaver.base.category.service.CategoryService"%>
   <%@ page import="com.eweaver.base.category.model.Category"%>
   <%@ page import="com.eweaver.base.security.model.Permissionrule"%>
   <%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
   <%@ page import="com.eweaver.base.security.service.logic.PermissionruleService"%>
   <%@ page import="com.eweaver.base.util.StringHelper"%>
   <%@ page import="com.eweaver.base.util.NumberHelper"%>
   <%@ page import="com.eweaver.base.util.DateHelper"%>
   <%@ page import="com.eweaver.base.util.MathHelper"%>
   <%@ page import="java.util.Map" %>
   <%@ page import="com.eweaver.app.HrmScheduleDiffUtil" %>
<%

   String targeturl = request.getParameter("targeturl");
   String requestid= request.getParameter("requestid");
   String hsql="";
   BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    PermissionruleService permissionruleService=(PermissionruleService)BaseContext.getBean("permissionruleService");
       String sql1="select doc,browwer from uf_docborrow where requestid='"+requestid+"'";
       List liststr=baseJdbcDao.getJdbcTemplate().queryForList(sql1);
       String docid="";
       String browwer="";
       for(int i=0;i<liststr.size();i++){
          Map m=(Map)liststr.get(i);
          docid=StringHelper.null2String(m.get("doc"));
          browwer=StringHelper.null2String(m.get("browwer"));    
           Permissionrule permissionrule2 = new Permissionrule();
                        permissionrule2.setId(null);
                        permissionrule2.setIstype(0);
                        permissionrule2.setObjid((String) docid);
                        permissionrule2.setIsdefault(1);
                        permissionrule2.setObjtable("docbase");
                        permissionrule2.setSharetype("402881e60bf4f747010bf4fec8f80007");
                        permissionrule2.setOrgobjtype("402881ea0bf559c7010bf5608b560014");
                        permissionrule2.setRoletype("1");
                        permissionrule2.setOrgsharetype("402881ea0bfa0b45010bfa19f3bb000a");
                        permissionrule2.setUsersharetype("4028801511760958011176701f79000b");
                        permissionrule2.setOrgunittype("4028803621c42bdb0121c4bcac650078");//402881ea0bf559c7010bf55ddf210006
                        permissionrule2.setUserobjtype("402881ea0bf559c7010bf55ddf210006");//
                        permissionrule2.setUserids(browwer);
                        permissionrule2.setOpttype(3);
                        permissionrule2.setStationobjtype("297e828210f211130110f21d99710009");
                        permissionrule2.setOrgreftype("402881e510e8223c0110e83d427f0018");
                        permissionruleService.createPermissionrule(permissionrule2);  
       }
       String upsql="update uf_docborrow set isactive=1 where requestid='"+requestid+"'";
       baseJdbcDao.getJdbcTemplate().update(upsql);
   %>
<%
targeturl="/workflow/request/close.jsp?mode=submit";
%>
<script>
var commonDialog=top.leftFrame.commonDialog;

if(commonDialog){
 var frameid=parent.contentPanel.getActiveTab().id+'frame';
 var tabWin=parent.Ext.getDom(frameid).contentWindow;
 if(!commonDialog.hidden)
	{
		commonDialog.hide();
		tabWin.location.reload();
	}
 else
	{
		
		tabWin.location.href="<%=targeturl%>";
	}
}
</script>

