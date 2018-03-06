<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase"%>
<%@ page import="com.eweaver.workflow.form.model.FormBase"%>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService"%>
<%@ page import="com.eweaver.base.security.util.PermissionTool"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.interfaces.form.Formdata"%>
<%@ page import="com.eweaver.interfaces.form.FormdataServiceImpl"%>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	

	String delsql="delete from uf_dmsd_shipmdetail where (linkid is null) or (linkid is not null and isvalid='40288098276fc2120127704884290211')";
	baseJdbc.update(delsql);
	//System.out.println("Start................................");
	String humid = StringHelper.null2String(request.getParameter("humid"));//当前登录人
	String tmpid = StringHelper.null2String(request.getParameter("tmpid"));//uf_dmsd_shipmtmp中的ID
	String soldside = StringHelper.null2String(request.getParameter("soldside"));//售达方名称
	String soldcode = StringHelper.null2String(request.getParameter("soldcode"));//售达方简码
	String sendside = StringHelper.null2String(request.getParameter("sendside"));//送达方名称
	String sendcode = StringHelper.null2String(request.getParameter("sendcode"));//送达方简码
	String lcno = StringHelper.null2String(request.getParameter("lcno"));//信用证编号
	String paytxt = StringHelper.null2String(request.getParameter("paytxt"));//付款方式文本
	if(paytxt.indexOf("'")!=-1)
	{
		paytxt = paytxt.replace("'","’");
	}
	String shipm = StringHelper.null2String(request.getParameter("shipm"));//Shipping Mark
	String spec = StringHelper.null2String(request.getParameter("spec"));//特殊需求

	String saleno="";//销售订单
	String item="";//项次
	String materno="";//物料描述
	String packtype="";//包装类型
	String packnum="";//包装数量
	String commodity="";//客户物料描述



	StringBuffer buffer = new StringBuffer(512);
	buffer.append("insert into uf_dmsd_shipmdetail")
	.append("(id,requestid,contactid) values").append("('").append(IDGernerator.getUnquieID()).
	append("',").append("'").append("$ewrequestid$").append("',");

	buffer.append("'").append(tmpid).append("')");//
	FormBase formBase = new FormBase();
	//40285a8d5cf7b570015d2b5da23c0e33
	String categoryid = "40285a8d5cf7b570015d2b5da23c0e33";//分类id
	//创建formbase
	formBase.setCreatedate(DateHelper.getCurrentDate());
	formBase.setCreatetime(DateHelper.getCurrentTime());
	formBase.setCreator(StringHelper.null2String(humid));
	formBase.setCategoryid(categoryid);
	formBase.setIsdelete(0);
	FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
	formBaseService.createFormBase(formBase);
	String insertSql = buffer.toString();
	insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
	baseJdbc.update(insertSql);
	PermissionTool permissionTool = new PermissionTool();
	permissionTool.addPermission(categoryid,formBase.getId(), "uf_dmsd_shipmdetail");



	//先更新售达方简码及名称,送达方简码及名称,特殊需求,shipping mark,信用证编号,付款方式文本
	String upsql="update uf_dmsd_shipmdetail set soldside='"+soldcode+"',soldtxt='"+soldside+"',sendside='"+sendcode+"',sendtxt='"+sendside+"',xyzno='"+lcno+"',paytxt='"+paytxt+"' where contactid='"+tmpid+"'";
	
	System.out.println("upsql:"+upsql);
	baseJdbc.update(upsql);

	String sql="select * from uf_dmsd_shipmtmp where requestid='"+tmpid+"' order by num";
	List list = baseJdbc.executeSqlForList(sql);
	System.out.println("len....................."+list.size());
	if(list.size()>0)
	{
		for(int i=0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			saleno = StringHelper.null2String(map.get("saleno"));//销售订单
			item = StringHelper.null2String(map.get("item"));//项次
			materno = StringHelper.null2String(map.get("materno"));//物料描述
			packtype = StringHelper.null2String(map.get("packtype"));//包装类型
			packnum = StringHelper.null2String(map.get("packnum"));//包装数量
			commodity = StringHelper.null2String(map.get("commodity"));//客户物料描述
			if(i==0)
			{
				System.out.println("1xxxxxxxxxxxxxxx");
				String upsql1="update uf_dmsd_shipmdetail set saleno1='"+saleno+"',item1='"+item+"',materno1='"+materno+"',packtype1='"+packtype+"',packnum1='"+packnum+"',shipm1='"+shipm+"',specneeds1='"+spec+"',commodity1='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql1);
			}
			if(i==1)
			{
				System.out.println("2xxxxxxxxxxxxxxxxx");
				String upsql2="update uf_dmsd_shipmdetail set saleno2='"+saleno+"',item2='"+item+"',materno2='"+materno+"',packtype2='"+packtype+"',packnum2='"+packnum+"',shipm2='"+shipm+"',specneeds2='"+spec+"',commodity2='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql2);
			}
			if(i==2)
			{
				System.out.println("3xxxxxxxxxxxxxxxxx");
				String upsql3="update uf_dmsd_shipmdetail set saleno3='"+saleno+"',item3='"+item+"',materno3='"+materno+"',packtype3='"+packtype+"',packnum3='"+packnum+"',shipm3='"+shipm+"',specneeds3='"+spec+"',commodity3='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql3);
			}
			if(i==3)
			{
				//System.out.println("4xxxxxxxxxxxxxxxxxx");
				String upsql4="update uf_dmsd_shipmdetail set saleno4='"+saleno+"',item4='"+item+"',materno4='"+materno+"',packtype4='"+packtype+"',packnum4='"+packnum+"',shipm4='"+shipm+"',specneeds4='"+spec+"',commodity4='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql4);
			}
			if(i==4)
			{
				//System.out.println("5xxxxxxxxxxxxxxxxxxxxx");
				String upsql5="update uf_dmsd_shipmdetail set saleno5='"+saleno+"',item5='"+item+"',materno5='"+materno+"',packtype5='"+packtype+"',packnum5='"+packnum+"',shipm5='"+shipm+"',specneeds5='"+spec+"',commodity5='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql5);
			}
			if(i==5)
			{
				//System.out.println("6xxxxxxxxxxxxxxxxxxxxxxxx");
				String upsql6="update uf_dmsd_shipmdetail set saleno6='"+saleno+"',item6='"+item+"',materno6='"+materno+"',packtype6='"+packtype+"',packnum6='"+packnum+"',shipm6='"+shipm+"',specneeds6='"+spec+"',commodity6='"+commodity+"' where contactid='"+tmpid+"'";
				baseJdbc.update(upsql6);
			}
		}
	}

%>
