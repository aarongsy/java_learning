<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.*"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
%>
<script language="javascript">
var obj = window;
while(obj.parent != null && obj.parent != obj)
	obj = obj.parent; 
obj.location = "/main/login.jsp";
</script>
<%
	return;
}%>
<%!
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");

List<Map> getWorkflow(String sql,int rowcount,int titleLength, HttpServletRequest request){
	Page pageObject= baseJdbcDao.pagedQuery2(sql,1,rowcount);
	int totalSize = pageObject.getTotalSize();
	List<Map> listResult = new ArrayList<Map>();
	String targeturl = "/base/blank.jsp?isclose=1";
	try{
		targeturl= URLEncoder.encode(targeturl,"UTF-8");
	}catch(UnsupportedEncodingException uee){
		uee.printStackTrace(System.out);
	}
	if(totalSize!=0){
		List listRequest=(List)pageObject.getResult();
		Nodeinfo nodeinfo = new Nodeinfo();
		List listTemp = null;
		
		String mapValue = "";
		String icon = "";
		String received = "";
		String requestId="", requestName="";
		String creatorId="", creatorName="";
		String createDate="", createTime="";
		String lastorId="", lastorName="";
		String operateDate="", operateTime="";
		int isViewTime=0;
		for(int i=0; i<rowcount; i++){
			Map dataMap = (Map)listRequest.get(i);
			Map mapResult = new HashMap();
			received = StringHelper.null2String(dataMap.get("isreceived"));
	        requestId = StringHelper.null2String(dataMap.get("id"));
	        requestName = StringHelper.null2String(dataMap.get("requestname"));
	        if(!StringHelper.isEmpty(requestName)){
	            if(requestName.indexOf("&#39;")!=-1){//把html特殊符号还原成英文单引号"'"
	            	requestName = requestName.replaceAll("&#39;","'");
	            }
	        }
	        creatorId = StringHelper.null2String(dataMap.get("creater"));
	        createDate = StringHelper.null2String(dataMap.get("createdate"));
	        createTime = StringHelper.null2String(dataMap.get("createtime"));
	
	       	if(!"1".equals(received)){
	       		icon = "<img src='/images/base/new_red.gif'>";
	       	}else{
	       	    icon = "";		
	       	}
			
			//处理流程创建人
			creatorName = humresService.getHrmresNameById(creatorId);
			mapResult.put("creater", creatorName);
			
			//处理流程创建日期时间
			mapValue = isViewTime==1 ? createDate+" "+createTime : createDate; 
			mapResult.put("createDatetime", mapValue);
	        nodeinfo=nodeinfoService.get(StringHelper.null2String(dataMap.get("nodeid")));
	        
			mapValue = labelCustomService.getLabelNameByNodeinfoForCurrentLanguage(nodeinfo);
			//替换"\n"为空，节点名称过长，则显示....,鼠标移上去，则显示全部
			mapValue = mapValue.replaceAll("\\\\n","");
			String substr = mapValue;
			if(mapValue.length()>14){
				substr = mapValue.substring(0,14) + "...";
			}
			mapValue= "<a title=\""+mapValue+"\" href=\"#\">"+substr+"</a>";
			mapResult.put("currentNode", mapValue);
			
			//处理流程标题 
	        if(requestName.length()>titleLength){
	        	requestName = requestName.substring(0,titleLength) + "...";
	        }
			mapValue = "<a title=\""+StringHelper.null2String(dataMap.get("requestname"))+"\" href=\"javascript:onUrl('/workflow/request/workflow.jsp?targeturl="+targeturl+"&requestid="+requestId+"&nodeid="+nodeinfo.getId()+"')\">"+requestName+"</a>";
			mapResult.put("workflow", mapValue+" "+icon);
			
			//处理最后操作人、操作日期时间
			String sql2 = "select operator,operatedate,operatortime from requestlog where requestid='"+requestId+"' order by operatedate desc,operatortime desc";
			listTemp = baseJdbcDao.executeSqlForList(sql2);
			if(listTemp!=null && !listTemp.isEmpty()){
				Map mapTemp = (Map)listTemp.get(0);
				lastorId = StringHelper.null2String(mapTemp.get("operator"));
				lastorName = humresService.getHrmresNameById(lastorId);
				operateDate = StringHelper.null2String(mapTemp.get("operatedate"));
	            operateTime = StringHelper.null2String(mapTemp.get("operatortime"));
	            
				mapValue = "<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id="+lastorId+"','"+lastorName+ "','tab"+lastorId+"')\" >"+lastorName+"</a>";
				mapResult.put("lastCreater",mapValue);
	
	 			mapValue = isViewTime==1 ? operateDate+" "+operateTime : operateDate; 
	 			mapResult.put("lastCreateDate", mapValue);
			}
			listResult.add(mapResult);
			if(totalSize==(i+1)) break;
		}
	}
	return listResult;
}
%>
<%
int titleLength=20;
int rowcount=NumberHelper.getIntegerValue(request.getParameter("rowcount"),10);
String userid = eweaveruser.getId();
String sWhere="";
String sql = "select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,max(wi.isreceived) as isreceived,rt.nodeid,rb.updatetime from Requestbase rb, Requestoperators wo,Requeststatus wi,Requeststep rt " +
"where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid and wo.stepid = rt.id " +
"and wo.userid='"+userid+"' and (wi.ispaused=0 and wo.operatetype!=1 and rb.isfinished=0 or wo.operatetype=1 and wo.issubmit!=1) "+sWhere
+ " group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime,rt.nodeid "
+" order by max(wo.updatetime) desc,createdate desc,createtime desc";
List list = getWorkflow(sql, rowcount, titleLength, request);
Map map = null;
ArrayList fieldsName=new ArrayList();
fieldsName.add("workflow");
fieldsName.add("currentNode");
fieldsName.add("creater");
fieldsName.add("createDatetime");
ArrayList fieldsWidth=new ArrayList();
fieldsWidth.add("*");
fieldsWidth.add("20");
fieldsWidth.add("18");
fieldsWidth.add("12");
StringBuffer sb=new StringBuffer();
sb.append("<table class='requestTabTable'>");
for(int i=0;i<list.size();i++){
	sb.append("<tr class='"+(i%2==0?"odd":"even")+"'><td class='itemIcon'></td>");
	map = (Map)list.get(i);
	for(int j=0;j<fieldsName.size();j++){
		String fieldName = StringHelper.null2String(fieldsName.get(j));
		String fieldValue = StringHelper.null2String(map.get(fieldName));
		sb.append("<td width='"+fieldsWidth.get(j)+"%'>");
		sb.append(fieldValue);
		sb.append("</td>");
	}
	sb.append("</tr>");
}
sb.append("</table>");
%>
<html>
<head>
<link href="<%=request.getContextPath()%>/css/eweaver-default.css" rel="stylesheet" type="text/css"/>
<link href="<%=request.getContextPath()%>/css/portal.css" rel="stylesheet" type="text/css"/>
<script>
function onUrl(url){
	window.open(url);
}
</script>
</head>
<body>
<%=sb.toString()%>
</body>
</html>