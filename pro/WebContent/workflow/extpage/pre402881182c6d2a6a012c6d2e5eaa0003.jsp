<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 虚拟合同转正式合同 -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.workflow.form.model.*" %>
<%@ page import="com.eweaver.workflow.form.service.*" %>
<%@ page import="com.eweaver.base.security.util.*" %>
<%
DataService dataService=new DataService();
PermissionTool permissionTool = new PermissionTool();
FormBaseService formbaseService=(FormBaseService)BaseContext.getBean("formbaseService");
String requestid=request.getParameter("requestid");
//String requestid="402881172c68fba5012c699bceb5002f";
String targeturl = request.getParameter("targeturl");
String operatemode=request.getParameter("operatemode");
String categoryId="2c91a0302b0f7d47012b0fe16b7501f9";//正式合同分类ID
if(StringHelper.isEmpty(requestid)){
	out.println("requestid is null!");
	return;
}
String sql1 = "select devcontractno from uf_ctr_income where requestid='"+requestid+"'";
//虚拟合同ID
String virtualID = dataService.getSQLValue(sql1);
if(!StringHelper.isEmpty(virtualID)){
	//修改合同分类
	FormBase formBase = formbaseService.getFormBaseById(virtualID);
	formBase.setCategoryid(categoryId);
	formbaseService.modifyFormBase(formBase);
	//删除原有权限
	String delSQL1 = "delete from permissionrule where objid='"+virtualID+"'";
	String delSQL2 = "delete from permissiondetail where objid='"+virtualID+"'";
	dataService.executeSql(delSQL1);
	dataService.executeSql(delSQL2);
	//重构正式合同权限信息
	permissionTool.addPermission(categoryId,virtualID,"uf_contract");
	//修改合同类别
	String updateSQL = "update uf_contract set classes='2c91a0302a8cef72012a8ea9390903c6' where requestid='"+virtualID+"'";
	dataService.executeSql(updateSQL);
}
//设置合同表单主表字段信息
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

sql1="select contract,flowNO,customer,planstarttime,planendtime,10000*ctrmoney as ctrmoney,ctrtype,divideclasses,impldept,content,attach,content2,10000*money1 as money1,reqman,csman,10000*money2 as money2,10000*money3 as money3,content3,orgid,csdate,ifreturn from uf_ctr_income where requestid='"+requestid+"'";
List<Map> list=baseJdbcDao.executeSqlForList(sql1);
Map mainData=list.get(0);//取list第一行数据；
List<Map> ls =baseJdbcDao.executeSqlForList("select requestid from uf_contract where no='"+StringHelper.null2String(mainData.get("flowNO"))+"'");
if(ls.size()<1)
{
	
}
else
{
	String sqlupdate="update uf_contract set name='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("contract")))+"',customercoding='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("customer")))+"',predictbgdate='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("planstarttime")))+"',predictdate='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("planendtime")))+"',money="+StringHelper.null2String(mainData.get("ctrmoney"),"0.0")+",hosttypep='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("ctrtype")))+"',divideclasses='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("content")))+"',dodept='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("impldept")))+"',mainpoint='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("contract")))+"',electrontext='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("attach")))+"',field002='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("content2")))+"',bg1='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("money1"),"0.0"))+"',pjprincipal='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("reqman")))+"',csman='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("csman")))+"',budgetall='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("money3"),"0.0"))+"',budget='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("content3")))+"',bg2='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("money2"),"0.0"))+"',orgunit='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("orgid")))+"',isback='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("ifreturn")))+"',csdate='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("csdate")))+"',ctrflow='"+StringHelper.filterSqlChar(StringHelper.null2String(mainData.get("requestid")))+"' where no='"+StringHelper.null2String(mainData.get("flowNO"))+"'";
	baseJdbcDao.update(sqlupdate);
	Map mm = (Map)ls.get(0);
	String htrequestid=mm.get("requestid").toString();
	//TODO
	String hql="select rowindex,nodeid,pid,orgid,10000*distsum as distsum,contractno,remark from uf_contract_dist where requestid='"+requestid+"'";//
	List<Map> subDataList=baseJdbcDao.executeSqlForList(hql);
	for(int i=0;i<subDataList.size();i++){
		Map m = subDataList.get(i);
		String sorgid=m.get("orgid").toString();
		hql="select id from uf_contract_dist where requestid='"+htrequestid+"' and orgid='"+sorgid+"'";//
		List<Map> ls1=baseJdbcDao.executeSqlForList(hql);
		if(ls1.size()>0)
		{
			Map submap = (Map)ls1.get(0);
			sqlupdate="update uf_contract_dist set pid='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("pid")))+"',orgid='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("orgid")))+"',distsum="+StringHelper.null2String(m.get("distsum"),"0.0")+",contractno='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("contractno")))+"',remark='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("remark")))+"',nodeid='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("nodeid")))+"',rowindex='"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("rowindex")))+"'  where id='"+StringHelper.null2String(submap.get("id"))+"'";
	
		}
		else
		{
				sqlupdate="insert uf_contract_dist(id,requestid,rowindx,nodeid,pid,orgid,distsum,contractno,remark) values('"+IDGernerator.getUnquieID()+"','"+htrequestid+"','"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("rowindex")))+"','"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("nodeid")))+"','"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("pid")))+"','"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("orgid")))+"',"+StringHelper.null2String(m.get("distsum"),"0.0")+",'"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("contractno")))+"','"+StringHelper.filterSqlChar(StringHelper.null2String(m.get("remark")))+"')";  
		}
		baseJdbcDao.update(sqlupdate);
	}
}

response.sendRedirect(targeturl);
%>

