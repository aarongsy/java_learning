<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	//System.out.println("传入的requestid 为："+requestid);
	String sql = "select requestid  from uf_oa_gyszz where pdjg = '40285a8d4fbaabf8014fbf02d88515c8' and 1=(select isfinished from requestbase where id = requestid)  and 1<>(select isdelete from requestbase where id = requestid) and instr('"+requestid+"',requestid)>0";
	sql = sql +" and (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd')  as sysdates from dual) =add_months(to_date(zzyxrq,'yyyy-mm-dd'),-2)";
	JSONObject jo = new JSONObject();
	//System.out.println("供应商资质到期"+sql);//找到过期前两个月的数据
	List list = baseJdbc.executeSqlForList(sql);
	//System.out.println(list.size());
	if(list.size()>0)
	{
		for(int i = 0;i<list.size();i++)
		{
			Map map = (Map)list.get(i);
			String requests = StringHelper.null2String(map.get("requestid"));//即将到期的表单的requestid
			WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
			RequestInfo rs=new RequestInfo();
			rs.setCreator("40285a9049ade1710149ade8dde506d3"); //创建人为吴妹丹
			rs.setTypeid("40285a8d51b3178b0151c83be6a61adc");//流程为“供应商资质到期提醒”
			rs.setIssave("1"); 
			Dataset data=new Dataset();
			List<Cell> list1=new ArrayList<Cell>();
			Cell cell1=new Cell();
			cell1.setName("sqdh");
			cell1.setValue(requests);
			list1.add(cell1);				

			data.setMaintable(list1);
			rs.setData(data);
			String requestids = workflowServiceImpl.createRequest(rs);

		}
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
