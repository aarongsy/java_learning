<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ include file="/base/init.jsp"%>
<html>
<head>
<%
 
  String workflowType = StringHelper.null2String(request.getParameter("workflowType"));//传输过来的参数类型
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
  String printTitle = "";
  String printImg = "";
  int totalCount = 0;
  String modulesql = "";
  String workflowsql = "";
  StringBuffer contentl = new StringBuffer("<td vAlign=\"top\"><table class=\"Shadow\"><tbody><tr><td>");
  StringBuffer contentc = new StringBuffer("<td/>");
  StringBuffer contentr = new StringBuffer("<td vAlign=\"top\"><table class=\"Shadow\"><tbody><tr><td>");
  /**
	根据参数获取相应流程(待办（1），已办(2)，办结(3)，未完成(4)，已完成(5))
  **/
  if("1".equals(workflowType)){
	 Setitem todoSetitem=setitemService0.getSetitem("4028833039d773910139d7739b370000");
		//------------------------
		  printTitle = "待办事宜";
		  printImg = "/images/silk/arrow_rotate_clockwise.gif";
		 
		  if(todoSetitem!=null&&"1".equals(todoSetitem.getItemvalue())){
			  modulesql="select t.mid id,t.mname objname,count(*) num from "+
			  		  "(SELECT rb.id,m.id mid,m.objname mname "+
					  "FROM Requestbase rb, todoitems ti,Requeststatus wi, MODULE m,workflowinfo w where rb.workflowid=w.id and w.moduleid=m.id AND rb.isdelete<>1 "+
					  "and (ti.todotype!=1 and rb.ISFINISHED=0 or ti.todotype=1) and rb.id = ti.requestid and wi.curstepid=ti.stepid "+
					  "and ti.userid='"+currentuser.getId()+"') t group by t.mid, t.mname";
			  workflowsql = "select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from "+
			  		  "(SELECT DISTINCT rb.id,rb.workflowid,w.objname workflowname,w.moduleid"+
					  " FROM Requestbase rb, todoitems ti,Requeststatus wi,workflowinfo w where rb.workflowid=w.id  AND rb.isdelete<>1 and "+
					  "(ti.todotype!=1 and rb.ISFINISHED=0 or ti.todotype=1) and rb.id = ti.requestid and wi.curstepid=ti.stepid and ti.userid='"+currentuser.getId()+
					  "' ) t group by t.workflowid, t.workflowname,t.moduleid";
			}else{
			  modulesql="select t.mid id,t.mname objname,count(*) num from  ("+
				 " select rb.id,rb.workflowid,rb.requestname "+
				 " ,(SELECT m.OBJNAME from workflowinfo w ,MODULE m where  w.ID=rb.workflowid and m.ID=w.MODULEID ) as mname"+
				 " ,(SELECT m.id from workflowinfo w ,MODULE m where  w.ID=rb.workflowid and m.ID=w.MODULEID ) as mid"+
				 " from Requestbase rb, Requestoperators wo,Requeststatus wi,Requeststep rt "+ 
				 " where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and "+ 
				 " rb.id = wo.requestid and wi.curstepid=wo.stepid and wo.stepid = rt.id and "+ 
				 " wo.userid='"+currentuser.getId()+"' and (wi.ispaused=0 and wo.operatetype!=1"+
				 " and rb.isfinished=0 or wo.operatetype=1 and wo.issubmit!=1)"+  
				 " group by rb.id,rb.workflowid,rb.requestname"+
				 " ,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime,"+
				 "  rt.nodeid ) t group by t.mid, t.mname";
			  workflowsql ="select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from"+
				  " (select rb.id,rb.workflowid,rb.requestname "+
				  " ,(SELECT w.OBJNAME from workflowinfo w where w.ID=rb.workflowid) as workflowname,(SELECT w.MODULEID from workflowinfo w where w.ID=rb.workflowid) as moduleid"+
				  " from Requestbase rb, Requestoperators wo,Requeststatus wi,Requeststep rt "+ 
				  " where rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid and wo.stepid = rt.id and wo.userid='"+
				  currentuser.getId()+"' and (wi.ispaused=0 and wo.operatetype!=1 and rb.isfinished=0 or wo.operatetype=1 and wo.issubmit!=1)   group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.updatetime,rt.nodeid  )"+
				  " t group by t.workflowid, t.workflowname,t.moduleid";
			}
  }else if ("2".equals(workflowType)) {
	  printTitle = "已办事宜";
	  printImg = "/images/silk/arrow_rotate_clockwise.gif";
	  
	  modulesql = "select t.mid id,t.mname objname,count(*) num from(select distinct rb.id,m.id mid,m.objname mname from requestbase rb,workflowinfo w,module m " +
		  "where rb.workflowid=w.id and w.moduleid=m.id and rb.isdelete<>1 and rb.creater <> '"+currentuser.getId()+"' and rb.id in (" +
		  "select wl.requestid from requestlog wl " +
		  "where wl.logtype in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a') and  wl.operator ='"+currentuser.getId()+"') " +
		  "and rb.isfinished = 0 and rb.isdelete = 0 " +
		  ") t group by t.mid, t.mname";
	  workflowsql = "select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from (select distinct rb.id,rb.workflowid,w.objname workflowname,w.moduleid from requestbase rb,workflowinfo w " +
		  "where rb.workflowid=w.id and rb.isdelete<>1 and rb.creater <> '"+currentuser.getId()+"' and rb.id in (" +
		  "select wl.requestid from requestlog wl " +
		  "where wl.logtype in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a') and  wl.operator ='"+currentuser.getId()+"') " +
		  "and rb.isfinished = 0 and rb.isdelete = 0 " +
		  ") t group by t.workflowid, t.workflowname,t.moduleid";
  } else if ("3".equals(workflowType)) {
	  printTitle = "办结事宜";
	  printImg = "/images/silk/arrow_undo.gif";
	  
	  modulesql = "select t.mid id,t.mname objname,count(*) num from("+
			  "select distinct rb.id,m.id mid,m.objname mname "+
			  " from requestbase rb,workflowinfo w,module m "+
			  "where rb.workflowid=w.id and w.moduleid=m.id and rb.isdelete<>1 	and("+
			  "(rb.creater <> '"+currentuser.getId()+"'"+
			  " and  rb.id in (select wl.requestid from requestlog wl "+
			  "where wl.logtype in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a','4028832e3eef93c8013eef93c9a8028d')  "+
			  "and  wl.operator ='"+currentuser.getId()+"'))"+
			  "or (rb.id in (SELECT wo.REQUESTID from Requestoperators wo where wo.USERID='"+currentuser.getId()+"' and wo.operatetype=1 and wo.ISSUBMIT=1)))"+
			  " and rb.isfinished = 1 and rb.isdelete = 0  ) t group by t.mid, t.mname";
  	  workflowsql = "select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from ("+
  			  		"SELECT distinct rb.id,rb.workflowid,w.objname workflowname,w.moduleid "+
  			  		"from requestbase rb,workflowinfo w where rb.workflowid=w.id and rb.isdelete<>1 and(( rb.creater <> '"+currentuser.getId()+"' and rb.id in (select wl.requestid from requestlog wl where wl.logtype"+
  			  		" in('402881e50c5b4646010c5b5afd17000b','402881e50c5b4646010c5b5afd17000a','4028832e3eef93c8013eef93c9a8028d') and  wl.operator ='"+currentuser.getId()+"')) "+
  			  		"or (rb.id in (SELECT wo.REQUESTID from Requestoperators wo where wo.USERID='"+currentuser.getId()+"' and wo.operatetype=1 and wo.ISSUBMIT=1)) ) "+
  			  		"and rb.isfinished = 1 and rb.isdelete = 0 ) t group by t.workflowid, t.workflowname,t.moduleid";
  } else if ("4".equals(workflowType)) {
	  printTitle = "我的请求(未完成)";
	  printImg = "/images/silk/control_repeat_blue.gif";
	  
	  modulesql = "select t.mid id,t.mname objname,count(*) num from (select distinct rb.id,m.id mid,m.objname mname from requestbase rb,workflowinfo w,module m where rb.workflowid=w.id and w.moduleid=m.id and rb.creater like '"+currentuser.getId()+"'" + 
	       "and rb.isfinished = 0 and rb.isdelete = 0 " + 
		   "and  exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+currentuser.getId()+"') or " + 
		   "(p.stationid is not null and p.stationid in('"+currentuser.getMainstation()+"'))or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('"+currentuser.getOrgid()+"'))) " + 
		   "and (p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) " + 
		   "and p.opttype in (3))  ) t group by t.mid, t.mname"; 
      workflowsql = "select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from (select distinct rb.id,rb.workflowid,w.objname workflowname,w.moduleid from requestbase rb,workflowinfo w where rb.workflowid=w.id and rb.creater like '"+currentuser.getId()+"'" + 
          "and rb.isfinished = 0 and rb.isdelete = 0 " + 
	      "and  exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+currentuser.getId()+"') or " + 
	      "(p.stationid is not null and p.stationid in('"+currentuser.getMainstation()+"'))or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('"+currentuser.getOrgid()+"'))) " + 
	      "and (p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) " + 
	      "and p.opttype in (3)) ) t group by t.workflowid, t.workflowname,t.moduleid"; 
  }  else if ("5".equals(workflowType)) {
	  printTitle = "我的请求(已完成)";
	  printImg = "/images/silk/control_power_blue.gif";
	  
	  modulesql = "select t.mid id,t.mname objname,count(*) num from (select distinct rb.id,m.id mid,m.objname mname from requestbase rb,workflowinfo w,module m where rb.workflowid=w.id and w.moduleid=m.id and rb.creater like '"+currentuser.getId()+"'" + 
	      "and rb.isfinished = 1 and rb.isdelete = 0 " + 
		  "and  exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+currentuser.getId()+"') or " + 
		  "(p.stationid is not null and p.stationid in('"+currentuser.getMainstation()+"'))or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('"+currentuser.getOrgid()+"'))) " + 
		  "and (p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) " + 
		  "and p.opttype in (3)) ) t group by t.mid, t.mname"; 
	 workflowsql = "select t.workflowid id,t.workflowname objname,t.moduleid,count(*) num from (select distinct rb.id,rb.workflowid,w.objname workflowname,w.moduleid from requestbase rb,workflowinfo w where rb.workflowid=w.id and rb.creater like '"+currentuser.getId()+"'" + 
	      "and rb.isfinished = 1 and rb.isdelete = 0 " + 
	      "and  exists (select 'X' from Permissiondetail p where p.objid=rb.id and ((p.userid='"+currentuser.getId()+"') or " + 
	      "(p.stationid is not null and p.stationid in('"+currentuser.getMainstation()+"'))or (( p.isalluser=1 or (p.orgid is not null and p.orgid in('"+currentuser.getOrgid()+"'))) " + 
	      "and (p.minseclevel <= 10 and ((( p.maxseclevel is not null) and (10<= p.maxseclevel)) or (p.maxseclevel is null))))) " + 
	      "and p.opttype in (3))  ) t group by t.workflowid, t.workflowname,t.moduleid";
  } else if ("7".equals(workflowType)) {
	  printTitle = "知会事宜";
	  printImg = "/images/silk/user_go.gif";
	  
      modulesql = "select  t.mid id,t.mname objname,count(*) num from (select distinct rb.id,m.id mid,m.objname mname,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,wi.isreceived,rb.updatetime " + 
    	  "from Requestbase rb,module m, Requestoperators wo,Requeststatus wi,workflowinfo w " +
		  "where rb.workflowid=w.id and w.moduleid=m.id and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid "+
		  "and wo.userid='"+currentuser.getId()+"' and (wo.operatetype=1) order by wi.isreceived,updatetime desc,createdate desc,createtime desc) t group by t.mid, t.mname";
  	  workflowsql = "select t.workflowid id,t.objname objname,t.moduleid,count(*) num from (select distinct rb.id,wf.moduleid,wf.objname,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.isreject,rb.objno,wi.isreceived,rb.updatetime " + 
	      "from Requestbase rb, Requestoperators wo,Requeststatus wi,workflowinfo wf " +
		  "where rb.workflowid=wf.id and rb.workflowid=wf.id and rb.isdelete<>1 and rb.id = wo.requestid and wi.curstepid=wo.stepid "+
		  "and wo.userid='"+currentuser.getId()+"' and (wo.operatetype=1) order by wi.isreceived,updatetime desc,createdate desc,createtime desc) t group by t.workflowid, t.objname,t.moduleid";
  }
  List moduleList = baseJdbcDao.executeSqlForList(modulesql);
  List workflowList = baseJdbcDao.executeSqlForList(workflowsql);
  for (int i = 0 ; moduleList != null && i < moduleList.size() ; i++) {
	  Map moduleMap = (Map) moduleList.get(i);
	  String moduleid = StringHelper.null2String(moduleMap.get("id"));
	  String modulename = StringHelper.null2String(moduleMap.get("objname"));
	  String modulenum = StringHelper.null2String(moduleMap.get("num"));
	  totalCount += NumberHelper.string2Int(modulenum);
	  String str = "";
	  if ("1".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall&isfinished=0&moduleid="+moduleid+"','待办事宜','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  } else if ("2".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=0&moduleid="+moduleid+"','已办事宜','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  } else if ("3".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=1&moduleid="+moduleid+"','办结事宜','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  } else if ("4".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=0&moduleid="+moduleid+"','我的请求未完成','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  }  else if ("5".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=1&moduleid="+moduleid+"','我的请求已完成','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  } else if ("7".equals(workflowType)) {
		  str = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchinform&moduleid="+moduleid+"','知会事宜','tab"+moduleid+workflowType+"')\">"+modulename+"</a>";
	  }
	  if (i % 2 == 0) {
		  contentl.append("<div class=\"list_box\"><table style='width:100%;' height=\"25\" border=\"0\" cellSpacing=\"0\" cellPadding=\"0\"><tbody><tr><td class=\"t-center\"><span></span><span class=\"title_1\">");
		  contentl.append(str).append("(<b>").append(modulenum).append("</b>)");
		  contentl.append("</span></td></tr></tbody></table><ul>");
	  } else {
		  contentr.append("<div class=\"list_box\"><table style='width:100%;' height=\"25\" border=\"0\" cellSpacing=\"0\" cellPadding=\"0\"><tbody><tr><td class=\"t-center\"><span></span><span class=\"title_1\">");
		  contentr.append(str).append("(<b>").append(modulenum).append("</b>)");
		  contentr.append("</span></td></tr></tbody></table><ul>");
	  }
	  
	  for (int j = 0 ; workflowList != null && j < workflowList.size() ; j++) {
		  Map workflowMap = (Map) workflowList.get(j);
		  String workflowid = StringHelper.null2String(workflowMap.get("id"));
		  String workflowname = StringHelper.null2String(workflowMap.get("objname"));
		  String mid = StringHelper.null2String(workflowMap.get("moduleid"));
		  String workflownum = StringHelper.null2String(workflowMap.get("num"));
		  if (mid.equals(moduleid)) {
			  String str2 = "";
			  if ("1".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall&isfinished=0&workflowid="+workflowid+"','待办事宜','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  }else if ("2".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=0&workflowid="+workflowid+"','已办事宜','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  } else if ("3".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchall_sp&isfinished=1&workflowid="+workflowid+"','办结事宜','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  } else if ("4".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=0&workflowid="+workflowid+"','我的请求未完成','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  }  else if ("5".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchmyall&isfinished=1&workflowid="+workflowid+"','我的请求已完成','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  } else if ("7".equals(workflowType)) {
				  str2 = "<a href=\"javascript:onUrl('/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=searchinform&workflowid="+workflowid+"','知会事宜','tab"+workflowid+"2')\">"+workflowname+"</a>";
			  }
			  if (i % 2 == 0) {
				  contentl.append("<li>").append(str2).append("(").append(workflownum).append(")").append("</li>");
			  } else {
				  contentr.append("<li>").append(str2).append("(").append(workflownum).append(")").append("</li>");
			  }
		  }
	  }
	  if (i % 2 == 0) {
		  contentl.append("</ul></div>");
	  } else {
		  contentr.append("</ul></div>");
	  }
  }
  contentl.append("</td></tr></tbody></table></td>");
  contentr.append("</td></tr></tbody></table></td>");
%>

	<title></title>
	<script type='text/javascript' language="javascript" src='/js/main.js'></script>
	<style type="text/css">
		* {font-family: "微软雅黑" !important;}
		.list_box{
			width: 90%;
			margin-left: 10px;
		}
		.list_box .title_1 {color: #333; font-weight: bold;}
		.list_box .t-center {border-bottom: 2px solid #D2DCE8;}
		.list_box ul {padding-bottom: 25px; list-style-type: none;  padding-top: 8px;}
		.list_box li {line-height: 20px; padding-left: 6px; background-position: 0px 8px; height: 20px;}
		table .Shadow {width: 100%; border-collapse: collapse; height: 100%;}
		.flowTopTitle{
		    background-color:#E0E9F0;
		    border: 1px solid #E8ECEF;
		    height: 30px;
		}
		a:link {color: #123885}     /* 未访问的链接 */
		a:visited {color: #123885}  /* 已访问的链接 */
		a:hover {color: red;text-decoration: none;}    /* 当有鼠标悬停在链接上 */
		a:active {color: #0000FF}   /* 被选择的链接 */
		
	</style>
	<script>
	     
	</script>
</head>
<body style="overflow-x:hidden; ">
	<div>
      <table >
      	<tbody>
      		<tr>
      			<td width="10"></td>
      			<td width="*">
      				<table width="100%" class="flowTopTitle" border="0" cellSpacing="0" cellPadding="0">
      					<tbody>
      						<tr>
      							<td width="25" align="left">
      								<img height="18" src="/images/hdReport.gif" />
      							</td>
      							<td align="left" style="padding-top: 3px;">
      								<span id="BacoTitle"><%=printTitle %>：查看      (共<%=totalCount %>项)</span>
      							</td>
      							<td align="right"></td>
      							<td width="5"></td>
      							<td width="24" align="center"></td>
      							<td width="24" align="center"></td>
      							<td align="right"></td>
      							<td widht="10"></td>
      						</tr>
      					</tbody>
      				</table>
      			</td>
      			<td width="10"></td>
      		</tr>
      	</tbody>
      </table>
      <table width="100%" height="100%" border="0" cellSpacing="0" cellPadding="0">
      	  <colgroup>
	         	<col width="10"/>
	            <col/>
	            <col width="10"/>
	      </colgroup>
	      <tbody>
	      	  <tr style="height: 5px;"></tr>
	      	  <tr>
	      	  	<td/>
	      	  	<td vAlign="top">
			      <table>
			         <colgroup>
			         	<col width="49%"/>
			            <col/>
			            <col width="49%"/>
			         </colgroup>
			         <tbody>
			         	<tr>
			         		<%=contentl.toString()%>
			         		<%=contentc.toString()%>
			         		<%=contentr.toString()%>
			         	</tr>
			         </tbody>
			      </table>
			    </td>
			  </tr>
		  </tbody>
	  </table>
   </div>
</body>
</html>