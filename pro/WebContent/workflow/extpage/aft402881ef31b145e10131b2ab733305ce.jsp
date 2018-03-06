<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//当前工作流包含表单是实际表单
//表单ID:4028818230686b49013069007363003b	会议申请单
//	会议类型:	mtype
//	会议议题:	mtopic
//	会议状态:	mstatus
//	开始日期:	mbdate
//	会议地点:	mloc
//	结束日期:	medate
//	内部参加人员:	iparticipant
//	外部参加人员:	oparticipant
//	会议人数:	mpopu
//	会议周期:	mcircle
//	召集人:	morganizer
//	联系人:	mcontact
//	发起人:	msponsor
//	发起部门:	spondept
//	发起日期:	spontime
//	附件:	attach
//	是否重要客户来访:	isimportant
//	来访单位:	visitor
//	来访人数:	popuvs
//	接待部门:	reception
//	招待负责人:	receman
//	备注:	remarks
//	前台ppt:	ppt
//	席卡内容:	seatcard
//	矿泉水:	mwater
//	茶水:	mtea
//	咖啡:	mcoffee
//	豆浆:	msbmilk
//	水果:	mfruit
//	鲜花:	mflower
//	摄影:	mfilm
//	录音:	mreco
//	其他:	others
//	申请人:	reqman
//	申请部门:	reqdept
//	申请时间:	reqtime
//	总部门/分公司:	orgid
//	会签部门:	csigndept
//	会签人:	csignman
//	传阅人:	copyreader
//	是否添加到汇添富日程:	isadd
//	会议名称:	mname
//---------------------------------------
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%@ page import="java.util.*"%>
<%@page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%
   String requestid = request.getParameter("requestid");
   String operatemode = StringHelper.null2String(request.getParameter("operatemode"));
   String targeturl = request.getParameter("targeturl");
   String otherextpages = StringHelper.null2String(request.getParameter("otherextpages"));
   String directnodeid = StringHelper.null2String(request.getParameter("directnodeid"));
   BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
   String meetroominfosql = "select mloc,mbdate,medate,mcircle from uf_admin_meeting " + 
            "where requestid = '" + requestid + "'";
   List mriList = baseJdbc.executeSqlForList(meetroominfosql);
    if (mriList!= null && mriList.size() > 0) {
      Iterator mriIter = mriList.iterator();
	   if (mriIter.hasNext()) {
		   Map mriMap = (Map) mriIter.next();
		   String mloc = StringHelper.null2String(mriMap.get("mloc"));//会议室id
           String mbdate = StringHelper.null2String(mriMap.get("mbdate"));//开始日期
           String medate = StringHelper.null2String(mriMap.get("medate"));//结束日期
		   String mbtime = "";
           String metime = "";
		   if(!StringHelper.isEmpty(mbdate)){
			   mbtime = mbdate.split(" ")[1];
		   }
		   
		   if(!StringHelper.isEmpty(medate)){
			   metime = medate.split(" ")[1];
		   }
		   
		   String mcircle = StringHelper.null2String(mriMap.get("mcircle"));//会议周期
           Long disDays = DateHelper.getDaysBetween(medate,mbdate,false);
           for (int i = 0 ; i <= disDays ; i++) {
			   StringBuffer insertMeetingRoomSqlBuffer = new StringBuffer("insert into " +
				   "uf_meetingroomuser(id,requestid,roomid,startdate,starttime,endtime,enddate) " +
				   "values('" + IDGernerator.getUnquieID() + "','" + requestid + "','" + 
				    mloc + "','");
			   String startdate = DateHelper.dayMove(mbdate,i).split(" ")[0];
			   if(!StringHelper.isEmpty(startdate)){
				   if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 7 
						   || DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 1) {
					   continue;
				   }
			   }
		//单次4028818231a311210131a3539e7a00ec
              if ("4028818231a311210131a3539e7a00ec".equals(mcircle)) {
				if (disDays == 0) {
                  insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
					.append("','").append(metime).append("','").append(startdate).append("')");
				   baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
				} else {
				    if (i == 0) {
                       insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
						.append("','").append("20:00:00").append("','").append(startdate).append("')");
					    baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
                    } else if (i != 0 && i != disDays) {
                       insertMeetingRoomSqlBuffer.append(startdate).append("','").append("08:00:00")
					 .append("','").append("20:00:00").append("','").append(startdate).append("')");
					    baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
				    } else {
                      insertMeetingRoomSqlBuffer.append(startdate).append("','").append("08:00:00")
					 	   .append("','").append(metime).append("','").append(startdate).append("')");
					  baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
				    }
				}
			    //每天
			  } else if ("4028818231a311210131a3539e7a00ed".equals(mcircle)) {
                   insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
					 .append("','").append(metime).append("','").append(startdate).append("')");
				  baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
			    //每周一
			  } else if ("4028818231a311210131a3539e7a00ee".equals(mcircle)) {
       		     if(!StringHelper.isEmpty(startdate)){
       		    	if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 2) {
                        insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
  					     .append("','").append(metime).append("','").append(startdate).append("')");
                           	baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
  				    }
       		     }
              //每周二
			  } else if ("4028818231a311210131a3539e7a00ef".equals(mcircle)) {
                if(!StringHelper.isEmpty(startdate)){
                	if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 3) {
                        insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
      				 .append("','").append(metime).append("','").append(startdate).append("')");
      				   baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
      				}
                }
              //每周三
			  } else if ("4028818231a311210131a3539e7a00f0".equals(mcircle)) {
                if(!StringHelper.isEmpty(startdate)){
                	if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 4) {
                        insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
      					  .append("','").append(metime).append("','").append(startdate).append("')");
      				   baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
      				}
                }
              //每周四
			  } else if ("4028818231a311210131a3539e7a00f1".equals(mcircle)) {
                if(!StringHelper.isEmpty(startdate)){
                	if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 5) {
                        insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
      					  .append("','").append(metime).append("','").append(startdate).append("')");
      				   baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
      				}
                }
			  //每周五
			  } else if ("4028818231a311210131a3539e7a00f2".equals(mcircle)) {
                if(!StringHelper.isEmpty(startdate)){
                	if (DateHelper.getDayOfWeek(new Date(startdate.replace("-","/"))) == 6) {
                        insertMeetingRoomSqlBuffer.append(startdate).append("','").append(mbtime)
      					  .append("','").append(metime).append("','").append(startdate).append("')");
      				   baseJdbc.update(insertMeetingRoomSqlBuffer.toString());
      				}
                }
			  }
		   }
	   }
   }
   if(!StringHelper.isEmpty(otherextpages)){
		if(otherextpages.indexOf("/workflow/extpage/")<0)
			otherextpages = "/workflow/extpage/"+otherextpages;
		otherextpages += "?requestid="+StringHelper.null2String(requestid)+"&operatemode="
		    +operatemode+"&directnodeid="+directnodeid+"&targeturl="+URLEncoder.encode(targeturl);
		response.sendRedirect(otherextpages);
		return;
	}
   targeturl="/workflow/request/close.jsp?mode=submit&requestname="
      +StringHelper.getEncodeStr("会议预定流程")+"&requestid="+requestid;
%>
<script>
  window.location.href="<%=targeturl%>";
</script>

