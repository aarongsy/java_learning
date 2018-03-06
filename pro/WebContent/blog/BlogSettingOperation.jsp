<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.eweaver.blog.BlogDao"%>
<%@ page import="com.eweaver.blog.BlogShareManager"%>
<%@page import="com.eweaver.humres.base.model.Humres"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.humres.base.service.HumresService"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.util.StringHelper"%>
<%
Humres user=BaseContext.getRemoteUser().getHumres();
HumresService humresService = (HumresService)BaseContext.getBean("humresService");
OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
%>
<%
    String userid=""+user.getId();
	String operation=StringHelper.null2String(request.getParameter("operation"));
	BlogShareManager shareManager=new BlogShareManager();
	
	if(operation.equals("add")){           //添加共享条件
	   shareManager.addShare(""+userid,request);
	   BlogDao blogDao=new BlogDao();
	   blogDao.delUpdateRemind(userid);
	   response.sendRedirect("shareSetting.jsp");
	}else if(operation.equals("delete")){ //删除共享条件
	   String shareid=StringHelper.null2String(request.getParameter("shareid"));
	   shareManager.deleteShare(userid,shareid); 
	   BlogDao blogDao=new BlogDao();
	   blogDao.delUpdateRemind(userid);
	}else if(operation.equals("edit")){
	   String isReceive=StringHelper.null2String(request.getParameter("isReceive"));
	   isReceive=isReceive.equals("1")?"1":"0";
	   String isThumbnail=StringHelper.null2String(request.getParameter("isThumbnail"));
	   isThumbnail=isThumbnail.equals("1")?"1":"0";
	   String maxAttention=StringHelper.null2String(request.getParameter("maxAttention"));
	   String sqlstr="update blog_setting set isReceive="+isReceive+",maxAttention="+maxAttention+",isThumbnail="+isThumbnail+" where userid='"+userid+"'";
	   
	   //RecordSet.execute(sqlstr);
	   baseJdbcDao.update(sqlstr);
	   
	   response.sendRedirect("baseSetting.jsp");
	}else if(operation.equals("editApp")){ //保存微博应用选项 
		String[] appids=request.getParameterValues("appid"); 
		
		String isActives[]=new String[appids.length];
		for(int i=0;i<appids.length;i++){
			String isActive=StringHelper.null2String(request.getParameter("isActive_"+appids[i]));
			isActive=isActive.equals("1")?"1":"0";
			String sql="update blog_app set isActive="+isActive+" where id="+appids[i];
			baseJdbcDao.update(sql);
		}
		response.sendRedirect("BlogAppSetting.jsp");
    }else if(operation.equals("editBaseSetting")){ //保存微博应用选项 
		String allowRequest=StringHelper.null2String(request.getParameter("allowRequest"));
		String isSingRemind=StringHelper.null2String(request.getParameter("isSingRemind"));
		String isManagerScore=StringHelper.null2String(request.getParameter("isManagerScore"));
		String enableDate=StringHelper.null2String(request.getParameter("enableDate")); 
		String attachmentDir=StringHelper.null2String(request.getParameter("attachmentDir"));
		allowRequest=allowRequest.equals("1")?"1":"0";
		isSingRemind=isSingRemind.equals("1")?"1":"0";
		isManagerScore=isManagerScore.equals("1")?"1":"0";
		String sql="update blog_sysSetting set allowRequest="+allowRequest+",enableDate='"+enableDate+"',isSingRemind="+isSingRemind+",isManagerScore="+isManagerScore+",attachmentDir='"+attachmentDir+"'";
		baseJdbcDao.update(sql);
		response.sendRedirect("BlogbaseSetting.jsp");
    }
%>