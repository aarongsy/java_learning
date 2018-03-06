<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.app.weight.servlet.LoadTr"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String action = StringHelper.null2String(request.getParameter("action"));
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
DataService dataService = new DataService();
Humres humres = BaseContext.getRemoteUser().getHumres();
if("rewrite".equals(action)){
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("success", "0");
	String loadno = StringHelper.null2String(request.getParameter("loadno"));
	String loadid = dataService.getValue("select requestid from uf_lo_loadplan where reqno='"+loadno+"'");
	List list = baseJdbcDao.executeSqlForList("select 1 from uf_lo_iolog where loadid='"+loadid+"' and isdelete=0");
	if(list!=null&&list.size()>0){
		jsonObject.put("info", "该装卸计划已回写!");
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();							
		return ;
	}
	String sql0 = "select ladingno,status from uf_lo_ladingmain where loadingno='"+loadno+"'";
	List list0 = baseJdbcDao.executeSqlForList(sql0);
	List<String> ladingnos = new ArrayList<String>();
	boolean canWrite = true;
	for(Object obj0:list0){
		Map map0 = (Map)obj0;
		String status = StringHelper.null2String(map0.get("status"));
		if(!"40285a8d4d5b981f014d6a12a9ec0009".equals(status)){
			canWrite = false;
			break;
		}
		String ladingno = StringHelper.null2String(map0.get("ladingno"));
		ladingnos.add(ladingno);
	}
	if(canWrite){
		for(String ladingno : ladingnos){
			LoadTr.reWrite(ladingno);
		}
		String insertsql = "insert into uf_lo_iolog(id,loadid,creator,createdatetime,isdelete) values(?,?,?,?,?)";
		Object[] values = new Object[5];
		values[0] = IDGernerator.getUnquieID();
		values[1] = loadid;
		values[2] = humres.getId();
		values[3] = DateHelper.getCurDateTime();
		values[4] = 0;
		baseJdbcDao.update(insertsql, values);
		jsonObject.put("success", "1");
	}else{
		jsonObject.put("info", "还有提入单未完成过磅!");
	}
	response.getWriter().write(jsonObject.toString());
	response.getWriter().flush();
	response.getWriter().close();							
	return ;
}
%>
