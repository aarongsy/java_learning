<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="com.eweaver.base.*"%>
<%@ page import="com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.workflow.request.model.*"%>
<%@ page import="com.eweaver.workflow.request.service.*"%>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.workflow.workflow.service.*"%>
<%@ page import="org.light.portlets.*"%>
<%@ page import="org.light.portal.core.entity.PortletObject"%>
<%@ page import="org.light.portal.core.service.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="org.json.simple.*"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%@page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@page import="com.eweaver.workflow.request.dao.RequeststepDaoHB"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
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
LabelService labelService = (LabelService)BaseContext.getBean("labelService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
RequestlogService requestlogService = (RequestlogService)BaseContext.getBean("requestlogService");
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
NodeinfoService nodeinfoService = (NodeinfoService)BaseContext.getBean("nodeinfoService");
PortalService portalService = (PortalService)BaseContext.getBean("portalService");
SetitemService setitemService=(SetitemService)BaseContext.getBean("setitemService");
RequeststepDaoHB requeststepDaoHB=(RequeststepDaoHB) BaseContext.getBean("requeststepDao");
Setitem setitem=setitemService.getSetitem("4028833039d773910139d7739b370000");

List<Map> getWorkflow(int titleLength,int rowcount,int status,int isViewTime, String workflowids, HttpServletRequest request){
	 
	Page pageObject= baseJdbcDao.pagedQuery2(getQuerySql(status,workflowids),1,rowcount);
	int totalSize = pageObject.getTotalSize();
	int unreadSize = 0;	
	
	request.setAttribute("totalSize", totalSize);
	
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
		String sql = "";
		
		String mapValue = "";
		String icon = "";
		String received = "";
		String requestId="", requestName="";
		String creatorId="", creatorName="";
		String createDate="", createTime="";
		String lastorId="", lastorName="";
		String operateDate="", operateTime="";
		//String stepid = "";
		for(int i=0; i<rowcount; i++){
			Map dataMap = (Map)listRequest.get(i);
			Map mapResult = new HashMap();
			//stepid = StringHelper.null2String(dataMap.get("stepid"));
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

            if(status==5){//流程反馈
            	icon = "<img src='/images/base/new_yellow.gif'>";
            	unreadSize++;
            }else if(status==0){//待办事宜
            	if(!"1".equals(received)){
            		icon = "<img src='/images/base/new_red.gif'>";
            		unreadSize++;
            	}else{
            		//Start 修复EWV2013024605 ：转发给多人时出现一人操作，其他人的未读标记消失的情况
            		/** 修复存在问题,先注释掉需要在考虑重新实现。
            		EweaverUser remoteUser = BaseContext.getRemoteUser();
					String userid = "";
					if(remoteUser!=null){
						userid = remoteUser.getId();
					}
            		String logsql = " select id from requestlog where requestid='" + requestId
            	              	  + " ' and stepid = '" + stepid + "' and operator = '" + userid + "'";
            	    List loglist = baseJdbcDao.executeSqlForList(logsql);
            	    if(loglist.isEmpty()) {
            	    	icon = "<img src='/images/base/new_red.gif'>";
            	    	unreadSize++;
            	    } else {
            	    	icon = "";
            	    }   
            	    **/
            	    //End    
            	    icon = "";		
            	}
            }else{
            	icon = "";
            }
			
            //处理流程标题 
 //           if(requestName.length()>titleLength){
//            	requestName = requestName.substring(0,titleLength) + "...";
//            }
//			mapValue = "<a title=\""+StringHelper.null2String(dataMap.get("requestname"))+"\" href=\"javascript:onUrl('/workflow/request/workflow.jsp?targeturl="+targeturl+"&requestid="+requestId+"','"+StringHelper.filterJString2(requestName)+"','tab"+requestId+"')\" >"+requestName+"</a>";
//			mapResult.put("workflow", mapValue+" "+icon);
			
			//处理流程创建人
			creatorName = humresService.getHrmresNameById(creatorId);
			mapValue = "<a href=\"javascript:onUrl('/humres/base/humresview.jsp?id="+creatorId+"','"+creatorName+ "','tab"+creatorId+"')\" >"+creatorName+"</a>";
			mapResult.put("creater", mapValue);
			
			//处理流程创建日期时间
			mapValue = isViewTime==1 ? createDate+" "+createTime : createDate; 
			mapResult.put("createDatetime", mapValue);
			
			//处理当前节点
//			listTemp = requestlogService.getCurrentNodeIds(requestId);
//			if(listTemp.size() > 0){
//				nodeinfo = nodeinfoService.get((String) listTemp.get(0));
//			}
			nodeinfo = new Nodeinfo();
	        if(status==0){
	        	nodeinfo=nodeinfoService.get(StringHelper.null2String(dataMap.get("nodeid")));
	        }
	        else{
	            List nodelist = requestlogService.getCurrentNodeIds(dataMap.get("id").toString());
	            if (nodelist.size() > 0)
	                  nodeinfo = nodeinfoService.get((String) nodelist.get(0));
	        }
	        
			mapValue = labelCustomService.getLabelNameByNodeinfoForCurrentLanguage(nodeinfo);
			//替换"\n"为空，节点名称过长，则显示....,鼠标移上去，则显示全部
			mapValue = mapValue.replaceAll("\\\\n","");
			String substr = mapValue;
			if(mapValue.length()>14){
				substr = mapValue.substring(0,14) + "...";
			}
			mapValue= "<a title=\""+mapValue+"\">"+substr+"</a>";
			mapResult.put("currentNode", mapValue);
			
			//处理流程标题 
			int o = requestName.indexOf("&quot;");
			while(o>=0){
				titleLength+=5;
				o = requestName.indexOf("&quot;",o+5);
			}
			o = requestName.indexOf("&#34;");
			while(o>=0){
				titleLength+=5;
				o = requestName.indexOf("&#34;",o+5);
			}
			//if(requestName.indexOf("&quot;")>-1){
				//titleLength+=5;
			//}
			//if(requestName.indexOf("&#34;")>-1){
			//	titleLength+=5;
			//}
            if(requestName.length()>titleLength){
            	requestName = requestName.substring(0,titleLength) + "...";
            }
			mapValue = "<a title=\""+StringHelper.null2String(dataMap.get("requestname"))+"\" href=\"javascript:onUrl('/workflow/request/workflow.jsp?targeturl="+targeturl+"&requestid="+requestId+"&nodeid="+nodeinfo.getId()+"','"+StringHelper.convertToUnicode(requestName)+"','tab"+requestId+"')\" >"+requestName+"</a>";
			mapResult.put("workflow", mapValue+" "+icon);
			
			//处理最后操作人、操作日期时间
			sql = "select operator,operatedate,operatortime from requestlog where requestid='"+requestId+"' order by operatedate desc,operatortime desc";
			listTemp = baseJdbcDao.executeSqlForList(sql);
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
	request.setAttribute("unreadSize", unreadSize);
	return listResult;
}
private String getQuerySql(int status, String workflowids) {
	//待办事宜isfinish==0
	String sql = "";
	String sWhere=" ";
	if(!StringHelper.isEmpty(workflowids)){//控制只显示某部分工作流
		sWhere=" and rb.workflowid in ("+StringHelper.formatMutiIDs(workflowids)+") ";
	}
	EweaverUser remoteUser = BaseContext.getRemoteUser();
	String userid = "";
	if(remoteUser!=null){
		userid = remoteUser.getId();
	}
	setitem=setitemService.getSetitem("4028833039d773910139d7739b370000");
	if(status==0){
		if(setitem!=null&&"1".equals(setitem.getItemvalue())){
			sql="select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno," +
			"wi.isreceived,wi.curstepid stepid,ti.nodeid,ti.createdatetime updatetime " +
			"from Requestbase rb, todoitems ti,Requeststatus wi " +
			"where exists(select 1 from workflowinfo where id=rb.workflowid) and rb.isdelete<>1 and (ti.todotype!=1 and rb.ISFINISHED=0 or ti.todotype=1) and rb.id = ti.requestid and wi.curstepid=ti.stepid and ti.userid='"+userid+"' " +sWhere+
			"order by ti.createdatetime desc";
		}else{
			sql = "select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,max(wi.isreceived) as isreceived,rt.nodeid,rb.updatetime from Requestbase rb, Requestoperators wo,Requeststatus wi,Requeststep rt " +
			"where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid and wo.stepid = rt.id " +
			"and wo.userid='"+userid+"' and (wi.ispaused=0 and wo.operatetype!=1 and rb.isfinished=0 or wo.operatetype=1 and wo.issubmit!=1) "+sWhere
			+ " group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime,rt.nodeid "
			+" order by max(wo.updatetime) desc,createdate desc,createtime desc";
		}
	}else if(status==1 || status==2){
		int isFinish=(status==1)?0:1;
		sql="select distinct rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime from requestbase rb " +
				"where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and ((rb.creater <> '"+userid+"' and rb.id in (" +
				"select wl.requestid from requestlog wl " +
				"where wl.logtype in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a','4028832e3eef93c8013eef93c9a8028d') and  wl.operator ='"+userid+"')) " +
				"or (rb.id in (SELECT wo.REQUESTID from Requestoperators wo where wo.USERID='"+userid+"' and wo.operatetype=1 and wo.ISSUBMIT=1))) " +
				"and rb.isfinished = "+isFinish+" and rb.isdelete = 0 " +sWhere+
						"order by rb.updatetime desc,createdate desc,createtime desc";
	}else if(status==5){//流程反馈 //记录最后一次操作的提交时间
		sql = "select a.* from requestbase a left join requestoperatormark b on a.id=b.requestid where b.userid='"+userid+"' and b.feedback='1' order by a.updatetime desc";

	}else if(status==6){//流程知会
		sql = "select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,max(wi.isreceived) as isreceived,rb.updatetime from Requestbase rb, Requestoperators wo,Requeststatus wi " +
		"where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid "+// and (wi.isreceived=0 or wi.issubmited=0) " +
		"and wo.userid='"+userid+"' and (wo.operatetype=1) "+sWhere+
		" group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,rb.updatetime "+
		" order by rb.updatetime desc,createdate desc,createtime desc";//去除过滤提交过的
		//"and wo.userid='"+userid+"' and (wo.operatetype=1 and wo.issubmit!=1) "+sWhere+" order by createdate desc,createtime desc";
	}else if(status==7){//流程退回 seclevel 10 ?
		sql="select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,max(wi.isreceived) as isreceived,rb.updatetime from requestbase rb, Requestoperators wo,Requeststatus wi where rb.workflowid in(select id from workflowinfo) and  rb.isdelete=0 and rb.isreject='1' and rb.id = wo.requestid and wi.curstepid=wo.stepid and " +
		"exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+userid+"') or " +
				"(p.stationid is not null and p.stationid in('nonestation')) or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('noneorg'))) and " +
				"(p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) ) " +
				sWhere+" group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,rb.updatetime order by rb.updatetime desc,createdate desc,createtime desc";
	}else if(status==8){
		sql="select distinct rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,rb.updatetime from requestbase rb, Requestoperators wo,Requeststatus wi where rb.workflowid in(select id from workflowinfo) and rb.isdelete=0 and rb.id = wo.requestid and wi.curstepid=wo.stepid and " +
			" exists (select 'X' from Permissiondetail p where p.objid = rb.id "+ 
  			" and ((p.userid = '"+remoteUser.getId()+"') or (p.stationid is not null and p.stationid in ("+StringHelper.formatMutiIDs(remoteUser.getHumres().getStation())+")) or "+
  			" ((p.isalluser = 1 or (p.orgid is not null and p.orgid in ("+StringHelper.formatMutiIDs(remoteUser.getOrgids())+"))) and "+
   			" (p.minseclevel <= "+remoteUser.getSeclevel()+" and (((p.maxseclevel is not null) and ("+remoteUser.getSeclevel()+" <= p.maxseclevel)) or (p.maxseclevel is null))))) "+
   			" and p.opttype = 13)"+
			sWhere+" order by rb.updatetime desc,createdate desc,createtime desc";
	}else{
		int isFinish=(status==3)?0:1;
		sql="select distinct rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime from requestbase rb  where 1=1 and rb.workflowid in(select id from workflowinfo) and rb.creater like '%"+userid+"%' and rb.isfinished = "+isFinish+" and rb.isdelete = 0 and  " +
				"exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+userid+"') or " +
						"(p.stationid is not null and p.stationid in('nonestation')) or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('noneorg'))) and " +
						"(p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) and p.opttype=3) " +
						sWhere+" order by rb.updatetime desc,createdate desc,createtime desc";
	}
	return sql;
}
%>
<%
int portletId = NumberHelper.string2Int(request.getParameter("id"));//TODO 每种流程元素单独设置
String tabParams = StringHelper.null2String(request.getParameter("tabParams"));
JSONObject json = (JSONObject)JSONValue.parse(tabParams);

PortletObject portlet = portalService.getPortletById(portletId);
JSONArray fieldsName = (JSONArray)json.get("fieldsName");
JSONArray fieldsWidth = (JSONArray)json.get("fieldsWidth");

int status = NumberHelper.string2Int(json.get("status"), -1);
int titleLength = NumberHelper.string2Int(json.get("titleLength"),0);
int nCount = NumberHelper.string2Int(json.get("nCount"),0);
int isViewTime = NumberHelper.string2Int(json.get("isViewTime"),0);
String workflowIds = "";

String workflow = "";
String currentNode = "";
String creater = "";
String createDate = "";
String createTime = "";
String lastCreater = "";
String lastCreateDate = "";
String lastCreateTime = "";
StringBuffer sb = new StringBuffer();
Map map = null;
List list = getWorkflow(titleLength, nCount, status, isViewTime, workflowIds, request);
int totalSize = NumberHelper.string2Int(request.getAttribute("totalSize"), 0);
int unreadSize = NumberHelper.string2Int(request.getAttribute("unreadSize"), 0);
sb.append("<table class='requestTabTable' id='rqstListContainer"+portletId+"'>");
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
	//sb.append("<tr height='1'><td class='line' colspan='10'></td></tr>");
}
sb.append("</table>");
out.println(sb);
%>

<div class="requestTabPortletFooter"><span class="refresh" onclick="doTabPortletRefresh('<%=portletId %>');"></span>
<%if(totalSize>0){
	String[] sTitle = {labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0069"),labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006a"),labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006b"),labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006c"),labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006d"),labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f006e"),labelService.getLabelNameByKeyId("40288035247afa9601247b8810a4002f"),labelService.getLabelNameByKeyId("402881e50c7bd518010c7be0ab0e0007"),labelService.getLabelNameByKeyId("FB445239E75A44339AD1433D1048EA93")};//TODO Label
	String sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=0";
	if(status==0)		sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall&isfinished=0";
	else if(status==1)	sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=0";
    else if(status==2)	sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=1";
	else if(status==5)	sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchfeedback";
	else if(status==4)	sUrl = "/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=1";
    else if(status==6)	sUrl="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchinform";
    else if(status==7)	sUrl="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchreject";
    else if(status==8)	sUrl="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchsupervise";
	String strSize = status==0 ? ""+unreadSize+"/"+totalSize : ""+totalSize;
%>
<a href="javascript:onUrl('<%=request.getContextPath()+sUrl%>','<%=sTitle[status] %>','moreWorkflow<%=status %>')"><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7b0015") %><!-- 更多 -->(<%=strSize%>)...</a>
<%}%>
</div>


<script type="text/javascript">
function doTabPortletRefresh(id){
	var activeTab = Ext.getCmp('tabPanel_'+id).getActiveTab();
	if(!activeTab){
		activeTab = Ext.getCmp('tabPanel_'+id).getItem("0");
	}
	var url = activeTab.autoLoad.url;
	url += ((url.indexOf("?") == -1) ? "?" : "&") + activeTab.autoLoad.params;
	activeTab.load(url);
}

<%if(totalSize>0 && (status==0 || status==5 || status==6)){%>
var o = Ext.getCmp('t<%=portletId+"_"+status%>');
if(o!=null){
	var title = o.title + '(<%=totalSize%>)';
}
//o.setTitle(title);
<%}%>
</script>