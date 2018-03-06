<%--<%@page import="weaver.general.Util"%>--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%--<%@ page import="weaver.conn.*" %>--%>
<%@page import="java.util.HashMap"%> 
<%@page import="net.sf.json.JSONObject"%>
<%--<%@page import="weaver.hrm.User"%>--%>
<%--<%@page import="weaver.hrm.HrmUserVarify"%>--%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@page import="com.eweaver.blog.BlogReplyVo"%>
<%@page import="com.eweaver.blog.BlogDiscessVo"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.IDGernerator"%>
<%@page import="java.util.*"%>
<%@page import="com.eweaver.base.util.NumberHelper"%>
<%--<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />--%>
<%--<jsp:useBean id="cs" class="weaver.conn.ConnStatement" scope="page" />--%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%
	//User user = HrmUserVarify.getUser (request , response) ;
	request.setCharacterEncoding("UTF-8");
	HashMap result=new HashMap();
	if(user==null){
    	result.put("status","2"); //超时
    	JSONObject json=JSONObject.fromObject(result);
		out.println(json);
		return ;
    }
	Date today=new Date();
	String userid=""+user.getId();
	String curDate=new SimpleDateFormat("yyyy-MM-dd").format(today);//当前日期
	String curTime=new SimpleDateFormat("HH:mm:ss").format(today);//当前时间
	
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");
	
	String content=StringHelper.null2String(request.getParameter("content"));//日志内容
	String discussid=StringHelper.null2String(request.getParameter("discussid"));//被评论的日志id
	String replyid=StringHelper.null2String(request.getParameter("replyid"));//被评论的评论的id
	String tempreplyid=StringHelper.null2String(request.getParameter("replyid")); //被评论的评论的id
	
	String relatedid=StringHelper.null2String(request.getParameter("relatedid")); //评论中相关人id
	
	String commentType=StringHelper.null2String(request.getParameter("commentType"));//被评论的日志id
	String workdate=StringHelper.null2String(request.getParameter("workdate"));//被评论的评论的id
	String bediscussantid=StringHelper.null2String(request.getParameter("bediscussantid"));//被评论的评论的id

	String action=StringHelper.null2String(request.getParameter("action")).trim();
	
	HashMap backData=new HashMap();
	ArrayList array=new ArrayList();
	String remindSql="";
	if("add".equals(action)){
	 try{
		String sql="insert into blog_reply (userid, discussid, createdate, createtime, content,comefrom,workdate,bediscussantid,commentType,relatedid)"+
			"VALUES (?, ?,?,?,?,?,?,?,?,?)";
		/*
		cs.setStatementSql(sql);
		cs.setString(1,""+userid);
		cs.setString(2,""+discussid);
		cs.setString(3,""+curDate);
		cs.setString(4,""+curTime);
		cs.setString(5,""+content);
		cs.setString(6,"0");
		cs.setString(7,""+workdate);
		cs.setString(8,""+bediscussantid);
		cs.setString(9,""+commentType);
		cs.setString(10,""+relatedid);
		*/
		Object[] objects = new Object[10];
		objects[0] = userid;
		objects[1] = NumberHelper.getIntegerValue(discussid);
		objects[2] = curDate;
		objects[3] = curTime;
		objects[4] = content;
		objects[5] = 0;
		objects[6] = workdate;
		objects[7] = bediscussantid;
		objects[8] = NumberHelper.getIntegerValue(commentType);
		objects[9] = relatedid;
		if(baseJdbcDao.update(sql,objects)>0){ 
			sql="select max(id) maxid from blog_reply where userid='"+userid+"'";
			List list = baseJdbcDao.executeSqlForList(sql);
			if(list.size()>0){
				Map map = (Map)list.get(0);
				replyid = StringHelper.null2String(map.get("maxid"));
			}
			result.put("status","1");
			backData.put("id",replyid);
			backData.put("discussid",discussid);
			backData.put("createDate",curDate);
			backData.put("createTime",curTime);
			backData.put("createTime",curTime);
			
			String createdatetime=dateFormat3.format(dateFormat.parse(curDate+" "+curTime));
			backData.put("createdatetime",createdatetime);
			
			backData.put("userid",user.getId());
			backData.put("username",user.getObjname());
			
			backData.put("commentType",commentType);
			
			result.put("backdata",backData);
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
		}else{
			result.put("status","0");
			result.put("backdata","内部错误");
			JSONObject json=JSONObject.fromObject(result);
			out.println(json);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		finally{
		}
		BlogDao blogdao=new BlogDao();
		if(!"0".equals(tempreplyid)){
			
			if(!bediscussantid.equals(userid))
				blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
			
			if(!relatedid.equals(userid)&&!bediscussantid.equals(relatedid))
			    blogdao.addRemind(relatedid,userid,"9",discussid+"|"+tempreplyid+"|"+replyid,"0");
		}else{ 
			
			if(!bediscussantid.equals(userid))
				   blogdao.addRemind(bediscussantid,userid,"9",discussid+"|0|"+replyid,"0");
		}
	}else if("del".equals(action)){
		replyid=StringHelper.null2String(request.getParameter("replyid"));    //评论的id
		String sql="select * from blog_reply where id='"+replyid+"' and discussid="+discussid;
		List list = baseJdbcDao.executeSqlForList(sql);
		Map map = (Map)list.get(0);
		String discussant=StringHelper.null2String(map.get("userid"));
		String createdate=StringHelper.null2String(map.get("createdate"));
		String createtime=StringHelper.null2String(map.get("createtime"));
		
		Date nowdate=new Date();
		long sepratorTime=(nowdate.getTime()-dateFormat.parse(createdate+" "+createtime).getTime())/(1000*60);
		
		sql="select max(id) maxid from blog_reply where discussid="+discussid;
		List list1 = baseJdbcDao.executeSqlForList(sql);
		
		String maxReplayid="0";
		if(list1.size()>0){
			Map map1 = (Map)list1.get(0);
			maxReplayid=StringHelper.null2String(map1.get("maxid"));
		}
		
		boolean flag=true;
		String status="1";
		if(!userid.equals(discussant))
			flag=false;
		else if(!replyid.equals(maxReplayid)){
			status="-1";
			flag=false;
		}else if(sepratorTime>10){
			status="-2";
			flag=false;
		}
			
        if(flag){
        	//删除评论
        	sql="delete from blog_reply where id="+replyid;
        	baseJdbcDao.update(sql);
        	//删除评论提醒
        	sql="delete from blog_remind where relatedid='"+userid+"' and remindType=9 and remindValue like '"+discussid+"|%%|"+replyid+"'";
        	baseJdbcDao.update(sql);
        }
        
		result.put("status",status);
		JSONObject json=JSONObject.fromObject(result);
		out.println(json);
	}else{
		result.put("status","-4");
		result.put("backdata","未知操作");
		JSONObject json=JSONObject.fromObject(result);
		out.println(json);
	}
%>