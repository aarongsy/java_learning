<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.eweaver.base.DataService"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="com.eweaver.base.util.DateHelper"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.eweaver.workflow.request.service.RequestbaseService"%>
<%@page import="com.eweaver.app.meeting.service.MeetingService"%>
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
//	总部门/分公司:	orgid
//	申请部门:	reqdept
//	申请时间:	reqtime
//	传阅人:	copyreader
//	申请人:	reqman
//	是否添加到汇添富日程:	isadd
//	会签部门:	csigndept
//	会签人:	csignman
//	会议二级类型:	msubtype
//	会议名称:	mname
//---------------------------------------

	String targeturl = StringHelper.null2String(request.getParameter("targeturl"));
	String operatemode = StringHelper.null2String(request.getParameter("operatemode"));
	String otherextpages = StringHelper.null2String(request.getParameter("otherextpages"));
	String requestid = StringHelper.null2String(request.getParameter("requestid"));
	String directnodeid = StringHelper.null2String(request.getParameter("directnodeid"));
	String [] workarray = {"日","六","一","二","三","四","五"};

	DataService dataService = new DataService();
	MeetingService meetingService = new MeetingService();
	DateFormat dateFormat = DateFormat.getDateInstance();
	Map basedatemap = new HashMap();
	
	String meetingsql = "select a.iparticipant,(select roomname from uf_admin_meetingroom where "+
	"requestid=a.mloc) as mloc,a.mloc as mlocrequestid,a.isadd,a.msponsor,a.spondept,a.spontime,"+
	"a.mtopic,a.mbdate,a.medate,a.mname,a.mcircle from uf_admin_meeting a where a.requestid='"+requestid+"'";

	List meetlist = dataService.getValues(meetingsql);
	
	if(meetlist!=null && meetlist.size()>0){
	     for(int i=0;i<meetlist.size();i++){
	         Map meetMap = (Map)meetlist.get(i);
	         String isadd = StringHelper.null2String(meetMap.get("isadd")); 
			 String mbdate = StringHelper.null2String(meetMap.get("mbdate"));//开始日期
			 String medate = StringHelper.null2String(meetMap.get("medate"));//结束日期
             String mloc = StringHelper.null2String(meetMap.get("mloc"));//地点
             String mlocrequestid = StringHelper.null2String(meetMap.get("mlocrequestid"));//会议室requestid
	         String iparticipant = StringHelper.null2String(meetMap.get("iparticipant"));//内部参加人员
	         String mcircle = StringHelper.null2String(meetMap.get("mcircle"));//会议周期

	         long datelength = DateHelper.getDaysBetween(medate,mbdate,false);//取得日期差

	         if(datelength == 0){	
	        	 datelength = 1;
	         }

	         if("4028818231a311210131a3539e7a00ec".equals(mcircle)){ //1.单次
	        	 if(isadd.equals("1")){  //1.代表发布到公司日程并且发布到个人日程
	        	    meetMap.put("leixing","40288182306cae59013072625b240703");//公司日程
	        		meetingService.companySchedule(meetMap,requestid);	
	        		/* for(int j=0; j<datelength; j++){ //此处往个人日程表及明细表中插入多条记录
		          		    String returnstartdate = DateHelper.dayMove(mbdate,j);
		          		   Date getDate = dateFormat.parse(returnstartdate);
			    	       int dateval = DateHelper.getDayOfWeek(getDate);
		           		   if (meetingService.isweek(returnstartdate)){
		          				 continue;
		          		   }
		           		   meetMap.put("leixing","40288182306cae59013072625b240704");
		           		   meetMap.put("xingqi",workarray[dateval]);
		           		   meetingService.extract(meetMap,requestid);
		           	  }*/
	        		meetingService.extract(meetMap,requestid);
	             }else if(!StringHelper.isEmpty(iparticipant)){			//2.否则发布到个人日程
	           	    /*for(int j=0; j<datelength; j++){ //此处往个人日程表及明细表中插入多条记录
	          		    String returnstartdate = DateHelper.dayMove(mbdate,j);
	          		   Date getDate = dateFormat.parse(returnstartdate);
		    	       int dateval = DateHelper.getDayOfWeek(getDate);
	           		   if (meetingService.isweek(returnstartdate)){
	          				 continue;
	          		   }
	           		   meetMap.put("leixing","40288182306cae59013072625b240704");
	           		   meetMap.put("xingqi",workarray[dateval]);
	           		   meetingService.extract(meetMap,requestid);
	           	    }*/
	            	 meetingService.extract(meetMap,requestid);
	             }else {
	            	 break;
	             }
	          }else if("4028818231a311210131a3539e7a00ed".equals(mcircle)){//每天
	        	  
	        	  if(isadd.equals("1")){  //1.代表发布到公司日程并且发布到个人日程
	        		  
           		    meetMap.put("leixing","40288182306cae59013072625b240703");
	        		meetingService.companySchedule(meetMap,requestid);	
	        		/*
	        		 for(int j=0; j<datelength; j++){ //此处往个人日程表及明细表中插入多条记录
		          		   String returnstartdate = DateHelper.dayMove(mbdate,j);
		          		    Date getDate = dateFormat.parse(returnstartdate);
			    	        int dateval = DateHelper.getDayOfWeek(getDate);
		           		   if (meetingService.isweek(returnstartdate)) {
		          				    continue;
		          		   }
		           		   meetMap.put("mbdate",returnstartdate+" "+mbdate.substring(11,16));
		           		   meetMap.put("medate",returnstartdate+" "+medate.substring(11,16));
		           		   meetMap.put("richenshijian",returnstartdate+" "+mbdate.substring(11,16));
		           		   meetMap.put("xingqi",workarray[dateval]);
		           		   meetMap.put("leixing","40288182306cae59013072625b240704");
		           		   meetingService.extract(meetMap,requestid);
		           	  }*/
	        		meetingService.extract(meetMap,requestid);
		        	
		           }else if(!StringHelper.isEmpty(iparticipant)){					//2.否则发布到个人日程
		           	    /*for(int j=0; j<datelength; j++){ //此处往个人日程表及明细表中插入多条记录
		          		   String returnstartdate = DateHelper.dayMove(mbdate,j);
		          		    Date getDate = dateFormat.parse(returnstartdate);
			    	        int dateval = DateHelper.getDayOfWeek(getDate);
		           		   if (meetingService.isweek(returnstartdate)) {
		          				    continue;
		          		   }
		           		   meetMap.put("mbdate",returnstartdate+" "+mbdate.substring(11,16));
		           		   meetMap.put("medate",returnstartdate+" "+medate.substring(11,16));
		           		   meetMap.put("richenshijian",returnstartdate+" "+mbdate.substring(11,16));
		           		   meetMap.put("xingqi",workarray[dateval]);
		           		   meetMap.put("leixing","40288182306cae59013072625b240704");
		           		   meetingService.extract(meetMap,requestid);
		           	    }*/
		        	   meetingService.extract(meetMap,requestid);
		           }else{
		        	   break;
		           }
	          }else if("4028818231a311210131a3539e7a00ee".equals(mcircle)){ //每周一

	              basedatemap.put("datelength",datelength);
	              basedatemap.put("isflag",2);
	              meetingService.pubfun(meetMap,basedatemap);
	              
	          }else if("4028818231a311210131a3539e7a00ef".equals(mcircle)){ //每周二
	        	  
	        	  basedatemap.put("datelength",datelength);
	              basedatemap.put("isflag",3);
	              meetingService.pubfun(meetMap,basedatemap);
	              
	          }else if("4028818231a311210131a3539e7a00f0".equals(mcircle)){  //每周三
	        	  
	        	  basedatemap.put("datelength",datelength);
	              basedatemap.put("isflag",4);
	              meetingService.pubfun(meetMap,basedatemap);
	         
	          }else if("4028818231a311210131a3539e7a00f1".equals(mcircle)){ //每周四
	        	  
	        	  basedatemap.put("datelength",datelength);
	              basedatemap.put("isflag",5);
	              meetingService.pubfun(meetMap,basedatemap);
	              
	          }else {
	        	  
	        	  basedatemap.put("datelength",datelength);
	              basedatemap.put("isflag",6);
	              meetingService.pubfun(meetMap,basedatemap);
	          }
	     }  
	}      
	if (!StringHelper.isEmpty(otherextpages)) {
		if (otherextpages.indexOf("/workflow/extpage/") < 0){
			otherextpages = "/workflow/extpage/" + otherextpages;
		otherextpages += "?requestid="
				+ StringHelper.null2String(requestid) + "&operatemode="
				+ operatemode + "&directnodeid=" + directnodeid
				+ "&targeturl=" + URLEncoder.encode(targeturl);
		response.sendRedirect(otherextpages);
		}
		return;
	} else {
		targeturl = "/workflow/request/close.jsp?mode=submit&requestname="
				+ StringHelper.getEncodeStr("会议发起")+"&requestid="+requestid;
	}
%>
<script>
window.location.href = "<%=targeturl%>";
</script>
