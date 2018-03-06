<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.menu.model.Menu"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.*" %>
<%@ page import="com.eweaver.humres.base.service.*" %>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.orgunit.model.*"%>
<%@ page import="com.eweaver.base.menu.model.*"%>
<%@ page import="com.eweaver.base.menu.service.*"%>
<%
EweaverUser user = BaseContext.getRemoteUser();
Calendar cal = Calendar.getInstance();
Calendar initCal = Calendar.getInstance();
//initCal.setTime(EweaverContext.getStartDate());
//initCal.set(Calendar.DAY_OF_MONTH,3);
//initCal.set(Calendar.HOUR_OF_DAY,3);

Map weekMap = new HashMap();
weekMap.put(1,"星期日");
weekMap.put(2,"星期一");
weekMap.put(3,"星期二");
weekMap.put(4,"星期三");
weekMap.put(5,"星期四");
weekMap.put(6,"星期五");
weekMap.put(7,"星期六");
//查看内容
Runtime run = Runtime.getRuntime();
long max = run.maxMemory();
long total = run.totalMemory();
long free = run.freeMemory();
long used = total - free; 
long usable = max - total + free; 
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>管理界面</title>
<style type="text/css">
body{padding: 5px;}
.welcome{
	border: solid #bec9d4 1px;
	width: 100%;padding: 5px;
}
.welcome .left{
	width: 60%;height: 70px; float: left;font-size: 11px;border-right: solid #bec9d4 1px;
}
.welcome .right{
	width: 30%;height: 70px; float: left;font-size: 11px;padding-left: 10px;
}
.welcome .left div{
	height: 22px;line-height: 22px;color: #666;
}
.welcome .right div{
	height: 22px;line-height: 22px;color: #008000;
}
.shortCut{
	margin-top: 10px;border: solid #b7cde5 1px;
}
.shortCut .title{
	border-bottom: solid #b7cde5 1px;height: 25px;vertical-align: middle;padding-left:10px;
	font-size: 14px;color:#666;font-weight: bold;background: #f3f7fd;
}
.shortCut .menus{
	
}
.shortCut .menus span{
	margin: 10px; padding:5px; border: solid #ccc 1px;width: 100px;height: 40px;
}
.color-f60{
	color: #ff6600;
}
</style>
</head>
<body>
<div class="welcome">	
  <div style="width: 60px;height: 60px; float: left;padding: 5px;"><img  src="/images/icon_big/home.png" /></div>
  <div class="left">
  	<div style="height: 20px;">你好，<%=user.getHumres().getObjname()%></div>
  	<div style="height: 20px;">
  		当前时间：<span class="color-f60"><%=cal.get(Calendar.YEAR)%>年<%=cal.get(Calendar.MONTH)+1%>月<%=cal.get(Calendar.DAY_OF_MONTH)%>日
  		<%=cal.get(Calendar.HOUR_OF_DAY)%>:<%=cal.get(Calendar.MINUTE)%> <%=weekMap.get(cal.get(Calendar.DAY_OF_WEEK))%></span>
  	</div>
  	<div style="height: 20px;">
  		<!--系统启动时间：<span class="color-f60"><%=initCal.get(Calendar.YEAR)%>年<%=initCal.get(Calendar.MONTH)+1%>月<%=initCal.get(Calendar.DAY_OF_MONTH)%>日
  		<%=initCal.get(Calendar.HOUR_OF_DAY)%>:<%=initCal.get(Calendar.MINUTE)%> </span>
  		 系统已正常运行：<span class="color-f60"><%=(cal.getTime().getTime() - initCal.getTime().getTime()) / (3600 * 24 * 1000)%></span>天
  		<span class="color-f60">	<%=(cal.getTime().getTime() - initCal.getTime().getTime()) / (3600 * 1000)%24%></span>小时
  		<span class="color-f60"><%=(cal.getTime().getTime() - initCal.getTime().getTime()) / (60 * 1000)%60%></span>分钟
  		<span class="color-f60"><%=(cal.getTime().getTime() - initCal.getTime().getTime()) / 1000%60%></span>秒-->
  	</div>
  </div>
  <div class="right">
  	<div>最大内存 :<span class="color-f60"><%=max/(1024*1024)%>M</span></div>
	<div>已使用内存 : <span class="color-f60"><%=used/(1024*1024)%>M</span></div>
	<div>空闲可用内存 : <span class="color-f60"><%=usable/(1024*1024)%>M</span></div>
  </div>
</div>
<div class="shortCut">
	<div class="title">快速入口</div>
	<div class="menus">
		<span>
			<img alt="帐号管理" src="/images/icon_middle/user.png" align="absmiddle"op">
			<a href="javascript:onUrl('/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=list','帐号管理','tab402881b00d1aa007010d1aa2dacb0009');">帐号管理</a>
		</span>
		<span>
			<img alt="组织单元" src="/images/icon_middle/sitemap.png" align="absmiddle"op">
			<a href="javascript:onUrl('/base/orgunit/orgunitlist.jsp','组织单元','tab402881e70ad1d990010ad1dabd4b0005');">组织单元</a>
		</span>
		<span>
			<img alt="模块管理" src="/images/icon_middle/objects.png" align="absmiddle"op">
			<a href="javascript:onUrl('/base/module/modulemanager.jsp','模块管理','tab402880321dd8b75f011dd8bc92880002')">模块管理</a>
		</span>
		<span>
			<img alt="系统菜单" src="/images/icon_middle/appllications2.png" align="absmiddle"op">
			<a href="javascript:onUrl('/base/menu/menumanager.jsp?menutype=1','系统菜单','tab402881e70b5b89e7010b5b9578090004')">系统菜单</a>
		</span>
		<span>
			<img alt="角色管理" src="/images/icon_middle/admin.png" align="absmiddle"op">
			<a href="javascript:onUrl('/base/security/sysrole/sysrolelist.jsp','角色管理','tab402881e80b995631010b9959d59c0008')">角色管理</a>
		</span>
	</div>
</div>
</body>
</html>
<script>
function onUrl(url,title,id,inactive,image){

        top.onUrl(url,title,id,inactive,image);
}
</script>
