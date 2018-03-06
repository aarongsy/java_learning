<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.eweaver.app.bbs.discuz.client.Client" %>
<%@ page import="com.eweaver.app.bbs.interfaces.BBSService" %>
<%@ page import="com.eweaver.app.bbs.interfaces.BBSServiceDiscuz" %>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink" %>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.app.bbs.discuz.util.XMLHelper" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%
    EweaverUser eweaveruser = BaseContext.getRemoteUser();
	Humres currentuser = eweaveruser.getHumres();
    SysuserService sysuserService = (SysuserService) BaseContext.getBean("sysuserService");
    BBSService discuz = new BBSServiceDiscuz();
    Client client = new Client();
    List threadList = null;
    try {
        threadList = discuz.findBbsThreadinfo();
    } catch (ClassNotFoundException e) {
        System.out.println("找不到类");
    } catch (SQLException e) {
        System.out.println("SQL异常");
    }
  Sysuser sysuser = new Sysuser();
  Sysuserrolelink sysuserrolelink  = new Sysuserrolelink();
  sysuser = sysuserService.getSysuserByObjid(currentuser.getId());
  String bbsusername = StringHelper.null2String(sysuser.getLongonname());
  String result = client.uc_user_login(bbsusername, "123456");
   PrintWriter pw = response.getWriter();
			LinkedList<String> rs = XMLHelper.uc_unserialize(result);
			if(rs.size()>0){
				int $uid = Integer.parseInt(rs.get(0));
				String $username = rs.get(1);
				String $password = rs.get(2);
				String $email = rs.get(3);
				if($uid > 0) {
					response.addHeader("P3P"," CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");
	
				    System.out.println("登录成功");
					System.out.println($username);
					System.out.println($password);
					System.out.println($email);
						
					String $ucsynlogin = client.uc_user_synlogin($uid);
			        //pw.write($ucsynlogin);
			        out.println($ucsynlogin);
				} else if($uid == -1) {
					System.out.println("用户不存在,或者被删除");
				} else if($uid == -2) {
					System.out.println("密码错");
				} else {
					System.out.println("未定义");
				}
			}
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>BBS帖子信息</title>
<base href="<%=client.BBS_API %>" />
<link rel="stylesheet" type="text/css" href="data/cache/style_1_common.css?N9t" />
<link rel="stylesheet" type="text/css" href="data/cache/style_1_home_space.css?N9t" />
<link rel="stylesheet" id="css_widthauto" type="text/css" href="data/cache/style_1_widthauto.css?N9t" />
<style type="text/css">
table {width:1000px;}
.icn {width:30px;}
.thread {width:300px;}
.frm {width:100px;}
.auther {width:80px;}
.threadonline {width:200px;}
.by {width:100px;}
.bydate {width:200px;}
BODY {FONT-SIZE: 9pt} 
TH {FONT-SIZE: 11pt;padding-top:5px;} 
TD {FONT-SIZE: 9pt;border-bottom: 1px dashed RGB(204,204,204);padding: 5px;} 


</style>

</head>
<body>
<table cellspacing="0" cellpadding="0">
<tr class="th">
<th class="icn">&nbsp;</th>
<th class="thread">主题</th>
<th class="frm">版块</th>
<th class="auther">作者</th>
<th class="threadonline">发帖时间</th>
<th class="by">最近发布者</th>
<th class="bydate">最近发布时间</th>
</tr>
<%for (int i = 0 ; threadList != null && i < threadList.size(); i++) { 
  Map threadMap = (Map) threadList.get(i);
%>
<tr>

<td>
<a href="<%=client.BBS_API %>forum.php?mod=viewthread&amp;tid=<%=threadMap.get("tid") %>&amp;highlight=" title="新窗口打开" target="_blank">
<img src="<%=client.BBS_API %>static/image/common/folder_new.gif" />
</a>
</td>

<td>
<a href="<%=client.BBS_API %>forum.php?mod=viewthread&amp;tid=<%=threadMap.get("tid") %>" target="_blank" ><%=StringHelper.null2String(threadMap.get("subject")) %></a>
</td>

<td>
<a href="<%=client.BBS_API %>forum.php?mod=forumdisplay&amp;fid=<%=threadMap.get("fid") %>" target="_blank"><%=StringHelper.null2String(threadMap.get("name")) %></a>
</td>

<td>
<%=StringHelper.null2String(threadMap.get("author")) %>
</td>

<td>
<%=StringHelper.null2String(threadMap.get("dateline")).substring(0,StringHelper.null2String(threadMap.get("dateline")).lastIndexOf(".")) %>
</td>

<td>
<%=StringHelper.null2String(threadMap.get("lastposter")) %>
</td>

<td>
<%=StringHelper.null2String(threadMap.get("lastpost")).substring(0,StringHelper.null2String(threadMap.get("lastpost")).lastIndexOf(".")) %>
</td>
</tr>
<%} %>
</table>

</body>
</html>