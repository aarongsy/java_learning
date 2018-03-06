<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="org.hibernate.SessionFactory" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.eweaver.base.label.service.LabelService"%>
<%
		LabelService labelService = (LabelService)BaseContext.getBean("labelService");
	    SessionFactory sessionFactory = (SessionFactory)BaseContext.getBean("sessionFactory");
		sessionFactory.evict( com.eweaver.base.orgunit.model.Orgunit.class);
		sessionFactory.evict( com.eweaver.humres.base.model.Humres.class);
		sessionFactory.evict( com.eweaver.humres.base.model.Stationinfo.class);
		sessionFactory.evict( com.eweaver.humres.base.model.Stationlink.class);
		sessionFactory.evict( com.eweaver.base.orgunit.model.Orgunitlink.class);
		sessionFactory.evict( com.eweaver.base.security.model.Sysuser.class);
           sessionFactory.evictQueries();
	    out.println(labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000a"));//缓存清理完毕
%>