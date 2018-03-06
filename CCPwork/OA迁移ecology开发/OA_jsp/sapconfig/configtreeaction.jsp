<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String id = StringHelper.null2String(request.getParameter("id"));
String treeid = StringHelper.null2String(request.getParameter("treeid"));
String pid = StringHelper.null2String(request.getParameter("pId"));
String actiontype = StringHelper.null2String(request.getParameter("actiontype"));
String showtype = StringHelper.null2String(request.getParameter("showtype"));
System.out.println("showtype:"+showtype);
// System.out.println("id:"+id+">>pid:"+pid+">>actiontype:"+actiontype);
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
String sql = "";
JSONArray nodes = new JSONArray();
if(StringHelper.isEmpty(id)){
	id =treeid;
	sql = "select f1.id,f1.pid,f1.name,f1.remark,f1.type,f1.otabname,f1.ofield,f1.oconvert,f1.oremark,"+
	"(select '1' from sapconfig f2 where f2.pid=f1.id and rownum=1  ) as havsub from sapconfig f1 where f1.id='"+id+"' order by f1.type ,f1.name";	
}else{
	sql = "select f1.id,f1.pid,f1.name,f1.remark,f1.type,f1.otabname,f1.ofield,f1.oconvert,f1.oremark,"+
	"(select '1' from sapconfig f2 where f2.pid=f1.id and rownum=1  ) as havsub from sapconfig f1 where f1.pid='"+id+"' order by f1.type ,f1.name";
}
// System.out.println(sql);
List list = baseJdbcDao.executeSqlForList(sql);
for(int i=0;i<list.size();i++){
	Map map = (Map)list.get(i);
	JSONObject node = new JSONObject();
	node.put("id", StringHelper.null2String(map.get("id")));
	node.put("pId", StringHelper.null2String(map.get("pid")));
	String name = "";
	name = StringHelper.null2String(map.get("name"));
	String otabname = StringHelper.null2String(map.get("otabname"));
	String convert =  StringHelper.null2String(map.get("oconvert"));
	if("输入参数".equals(name)||"输出参数".equals(name)){
		name = "<span style='color:red'>"+name+"</span>";
	}else{
		name = "<span style='color:#006600'>"+name+"</span>";
	}
	
	
	if(showtype.equals("1")){
	     
	}else if(showtype.equals("2")){
		if(!StringHelper.isEmpty(otabname)){
			name+="|"+"<span style='color:blue'>"+otabname+"</span>";
		}
	}else{
		if(!StringHelper.isEmpty(otabname)){
			name+="|"+"<span style='color:blue'>"+otabname+"</span>";
		}
		if(!StringHelper.isEmpty(convert)){
			name+="|"+"<span style='color:#CC66CC'>"+convert+"</span>";
		}
	}
	
	
	node.put("name", name);
	node.put("remark", StringHelper.null2String(map.get("remark")));
	String type = StringHelper.null2String(map.get("type"));
	node.put("actiontype", type);
	node.put("otabname", StringHelper.null2String(map.get("otabname")));
	node.put("ofield", StringHelper.null2String(map.get("ofield")));
	node.put("oconvert", StringHelper.null2String(map.get("oconvert")));
	node.put("oremark", StringHelper.null2String(map.get("oremark")));
	node.put("showTitle", StringHelper.null2String(map.get("name"))+"\n"+StringHelper.null2String(map.get("otabname")));
	node.put("icon", getIconPath(type));
// 	System.out.println(StringHelper.null2String(map.get("havsub")));
	if("1".equals(StringHelper.null2String(map.get("havsub")))){
		node.put("isParent", "true");
// 	obj.put("isclick",false);
	}
	nodes.add(node);
}
out.print(nodes);
%>
<%!
public String getIconPath(String actiontype){
	String path = "zTree_v3/css/zTreeStyle/img/diy/";
	return path+actiontype+".png";
}
%>