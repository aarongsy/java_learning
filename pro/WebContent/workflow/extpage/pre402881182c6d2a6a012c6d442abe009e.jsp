<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 签报支出合同流程归档前生成合同台帐 -->
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.interfaces.workflow.*" %>
<%@ page import="com.eweaver.interfaces.form.*" %>
<%@ page import="com.eweaver.interfaces.model.*" %>
<%
BaseJdbcDao baseJdbcDao=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String requestid=request.getParameter("requestid");
//String requestid="2c91a0302c5cbb33012c5cd24cc30077";
String targeturl = request.getParameter("targeturl");
String operatemode=request.getParameter("operatemode");
String categoryId="2c91a0302c7bdddd012c7c6625ac02dc";//正式合同
if(StringHelper.isEmpty(requestid)){
	out.println("requestid is null!");
	return;
}
FormdataServiceImpl formdataService=new FormdataServiceImpl();
Formdata formdata=new Formdata();
formdata.setCreator(BaseContext.getRemoteUser().getId());
formdata.setTypeid(categoryId);
Dataset data=new Dataset();
formdata.setData(data);

//设置合同表单主表字段信息
List<Cell> mainList=new ArrayList<Cell>();

String sql1="select contract,flowNO,supplier,planstarttime,planendtime,10000*ctrmoney as ctrmoney,ctrtype,divideclasses,reqdept,content,attach,content2,10000*money1 as money1,reqman,csman,10000*money2 as money2,10000*money3 as money3,content3,orgid,csdate,ifreturn,buystyles from uf_ctr_income where requestid='"+requestid+"'";
List<Map> list=baseJdbcDao.executeSqlForList(sql1);
Map mainData=list.get(0);//取list第一行数据；
mainList.add(new Cell("name",StringHelper.null2String(mainData.get("contract"))));//合同名称
mainList.add(new Cell("no",StringHelper.null2String(mainData.get("flowNO"))));//合同编号
mainList.add(new Cell("customercoding",StringHelper.null2String(mainData.get("supplier"))));//甲方单位
mainList.add(new Cell("predictbgdate",StringHelper.null2String(mainData.get("planstarttime"))));//预计开始
mainList.add(new Cell("predictdate",StringHelper.null2String(mainData.get("planendtime"))));//预计完成
mainList.add(new Cell("money",StringHelper.null2String(mainData.get("ctrmoney"))));//合同金额
mainList.add(new Cell("hosttypep",StringHelper.null2String(mainData.get("ctrtype"))));//合同主类型
mainList.add(new Cell("divideclasses",StringHelper.null2String(mainData.get("divideclasses"))));//合同分类型
mainList.add(new Cell("dodept",StringHelper.null2String(mainData.get("reqdept"))));//实施部门
mainList.add(new Cell("mainpoint",StringHelper.null2String(mainData.get("content"))));//合同主要内容
mainList.add(new Cell("electrontext",StringHelper.null2String(mainData.get("attach"))));//合同电子文本
mainList.add(new Cell("field002",StringHelper.null2String(mainData.get("content2"))));//采购服务中间产品
mainList.add(new Cell("bg1",StringHelper.null2String(mainData.get("money1"))));//预算中间产品A1
mainList.add(new Cell("pjprincipal",StringHelper.null2String(mainData.get("reqman"))));//项目负责人
mainList.add(new Cell("csman",StringHelper.null2String(mainData.get("csman"))));//合同签订人
mainList.add(new Cell("budgetall",StringHelper.null2String(mainData.get("money3"))));//总预算
mainList.add(new Cell("budget",StringHelper.null2String(mainData.get("content3"))));//已签大宗材料的预算
mainList.add(new Cell("bg2",StringHelper.null2String(mainData.get("money2"))));//预算大宗材料A2
mainList.add(new Cell("orgunit",StringHelper.null2String(mainData.get("orgid"))));//所属业务部
//mainList.add(new Cell("isback","2c91a0302b278cea012b28d82e7f001d"));//是否返回
mainList.add(new Cell("isback",StringHelper.null2String(mainData.get("ifreturn"))));//是否返回2c91a0302b278cea012b28d82e7f001d
mainList.add(new Cell("issign","2c91a8512b9a1688012b9a44255d0001"));//合同性质
mainList.add(new Cell("state","2c91a0302a8cef72012a8eabe0e803f0"));//合同默认状态
mainList.add(new Cell("classes","2c91a0302a8cef72012a8ea9390903c7"));//合同类别-支出合同
mainList.add(new Cell("csdate",StringHelper.null2String(mainData.get("csdate"))));//签订日期
mainList.add(new Cell("ctrflow",StringHelper.null2String(requestid)));//评审流程
mainList.add(new Cell("buystyles",StringHelper.null2String(mainData.get("buystyles"))));//采购方式
baseJdbcDao.update("update uf_ctr_income set flowstate='2c91a0302bbcd476012be610f27e0a39' where requestid='"+requestid+"'");

data.setMaintable(mainList);
//生成合同台帐
formdataService.createFormdata(formdata);

targeturl="/workflow/request/close.jsp?mode=submit";
%>
<script>
var commonDialog=top.leftFrame.commonDialog;
if(commonDialog){
	var frameid=parent.contentPanel.getActiveTab().id+'frame';
	var tabWin=parent.Ext.getDom(frameid).contentWindow;
	if(!commonDialog.hidden){
		commonDialog.hide();
		tabWin.location.reload();
	}else{
		tabWin.location.href="<%=targeturl%>";
	}
}
</script>

