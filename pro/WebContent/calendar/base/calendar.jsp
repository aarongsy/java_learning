<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.calendar.util.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%LabelService labelService = (LabelService)BaseContext.getBean("labelService");%>
<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
if(eweaveruser == null){
	response.sendRedirect("/main/login.jsp");
	return;
}
Humres currentuser = eweaveruser.getHumres();
%>
<html>
<head>
<title><%=labelService.getLabelNameByKeyId("402883d934c10c0c0134c10c0cdb0000")%></title><!-- 日程管理 -->
<script type="text/javascript" src="<%= request.getContextPath()%>/calendar/basecal.js"></script>
<link href="<%= request.getContextPath()%>/calendar/basecal.css" type="text/css" rel="stylesheet">
</head>
<body>
<table width="100%" cellpadding="1" cellspacing="1" style="border:none">
  <tr>
    <td><!--左侧部分-->
    <table width="100%" cellpadding="0" cellspacing="0" style="border:none">
      <tr>
        <td><table width="100%" cellpadding="0" cellspacing="0" class="navtime" style="border:none">
          <tr>            
            <td width="30" align="right" valign="middle"><img src="<%= request.getContextPath()%>/calendar/imgs/btn_prev.gif" width="29" height="17"></td>
            <td width="2"></td>
            <td width="30" align="left" valign="middle"><img src="<%= request.getContextPath()%>/calendar/imgs/btn_next.gif" width="29" height="17"></td>
          	<td width="50" align="center" valign="middle"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001e")%></td><!-- 今天 -->
          	<td align="center" valign="middle">2007<%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7c001d")%>6<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%>18<%=labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")%></td><!-- 年   月   日 -->
          </tr>
        </table>
        </td>
        <td width="120" align="right">
        <!-- 顶部导航 -->
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none">
          <tr>
            <td align="center" valign="middle"><div class="link1">&nbsp;<%=labelService.getLabelNameByKeyId("402883d934c1f3e80134c1f3e8c40000")%></div></td><!-- 日 -->
            <td>&nbsp;</td>
            <td align="center" valign="middle"><div class="link2">&nbsp;<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768a4f830025")%></div></td><!-- 周 -->
            <td>&nbsp;</td>
            <td align="center" valign="middle"><div class="link2">&nbsp;<%=labelService.getLabelNameByKeyId("402881ee0c765f9b010c768ac6960028")%></div></td><!-- 月 -->
          </tr>
        </table></td>
      </tr>
    </table></td>
    <td width="150">&nbsp;</td>
  </tr>
  <tr>
    <td><!--日历日视图-->
    <div id="dayViewMain" class="printborder">
    	<div class="colheadersmiddle" id="colHeaders">
        	<div style="width: 100%; left: 0%;" class="chead">
            	<span id="headDate">Friday</span></div>
            </div>
            <div style="height: 17px; margin-bottom: 5px;margin-left: 38px;" class="inset grid" id="allDayGrid">
                <div style="left: 0px; height: 17px;" id="allDay" class="allDayCell"></div>
                <div id="alldayeventowner"></div>
            </div>
            <div style="height: 445px; overflow-x: hidden; overflow-y: scroll;" id="gridcontainer">
            <table width="100%" cellspacing="0" cellpadding="0">
              <tr>
                <td id="rowheadcell" style="width: 40px;">
                  <div id="rowheaders" style="height: 102ex; top: 0px; left: 0px;">
                  	<%for(int i=0;i<17;i++){ %>
                    <div class="rhead rheadeven" id="rhead<%=2*i%>" style="height: 3ex; top: <%=6*i%>ex;"><div class="rheadtext"><%=i+7%><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f7001f")%></div></div><!-- 点 -->
                    <div class="rhead rheadodd" id="rhead<%=2*i+1%>" style="height: 3ex; top: <%=6*i+3%>ex;"></div>
                    <%}%>
				</div>
                </td>
                <td id="gridcontainercell" title="<%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f70020")%>"><!-- 双击添加新日程 -->
                  <div id="grid" class="grid" style="height: 102ex;" onClick="javascript:clickGrid(this);" onDblClick="javascript:dblClickGrid(this);">
                    <div class="gutter" id="c0" style="width: 1px; left: 0%; height: 102ex; z-index: 1;"></div>
                    <div class="hrule hruleeven" id="r0" style="top: 0ex; z-index: 1;"></div>
                    <%for(int i=1;i<=17;i++){%>
                    <div class="hrule hruleodd" id="r<%=2*i-1%>" style="top: <%=6*i-3%>ex; z-index: 1;"></div>
                    <div class="hrule hruleeven" id="r<%=2*i%>" style="top: <%=6*i%>ex; z-index: 1;"></div>
                    <%}%>
                  </div>
                </td>
              </tr>
            </table>
            </div>
    	</div>
    </div>
    </td>
    <td align="center" valign="top"><!--右侧小日历-->
    <div id="minical" class="minicalborder"><%=CalendaerUtil.getMiniCal(-1,-1,0)%></div>
    </td>
  </tr>
</table>
<div id="eventDiv" name="eventDiv" style="display:none" class="eventDiv">
<div class="eventTitle"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b111f70021")%></div><!-- 新建日程安排 -->
<iframe id="eventFrame" height="100%" width="100%" frameborder="0" scrolling="no"></iframe></div>
<div id="maskDiv" class="maskDiv" style="display:none"></div>
</body>
</html>