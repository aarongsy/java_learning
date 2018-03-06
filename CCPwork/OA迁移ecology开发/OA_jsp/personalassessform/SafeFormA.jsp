<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>



<style type="text/css"> 
tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 

} 
</style>

<script type='text/javascript' language="javascript">
//js代码
</script>

<DIV>
<TABLE id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="100%">
</COLGROUP>
<TR height="25"  class="title">
<TD noWrap class="td1" align=center ><font size=6>安全生产责任制</font></TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>生产操作人员安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）认真学习和严格遵守各项规章制度，遵守劳动纪律，不违章作业，对本岗位的安全生产负直接责任。<br/>
2）熟练掌握本岗位操作技能，严格执行工艺纪律和操作纪律，精心正确的操作，做好各项记录。交接班应交接安全情况，交班应为接班创造良好的安全生产条件。<br/>
3）正确分析、判断和处理各种事故苗头，把事故消灭在萌芽状态。在发生事故时，及时的如实向上级报告，按事故预案正确处理，并保护现场，做好详细记录。<br/>
4）按时认真进行巡回检查，发现异常情况及时处理和报告。<br/>
5）精心维护设备，保持作业环节整洁，搞好文明生产。<br/>
6）上岗按规定着装，熟练正确的使用各种防护器具和灭火器具。<br/>
7）积极参加各种安全活动，岗位技术练兵和事故预案演练。<br/>
8）有权拒绝违章作业的指令，并对他人违章作业加以劝阻和制止。<br/>
9）特种作业人员要做好持证上岗，严格按照本专业的标准及操作程序进行。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>一般员工安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）安全生产，人人有责。每位员工都应在自己的岗位上，认真履行各自的安全职责，对岗位的安全生产和活动区域内的安全负直接责任。<br/>
2）针对公司存在易燃易爆、有毒有害的特点，公司的每位员工都应提高安全生产意识，认真做好各项工作。<br/>
3）认真学习和遵守劳动纪律和公司各项安全生产规章制度及安全操作规程，努力学习安全知识，积极参加各种安全活动，不断提高安全生产意识和安全技能。对本职工作要搞清楚。<br/>
弄明白，不懂和没有把握的事要先学习或请示上级，不可以盲目和不文明操作或作业。<br/>
4）掌握各种防护器具和消防器材的使用方法，保持作业环境整洁，进入生产和施工现场，要穿戴好劳动保护用品，做好劳动保护工作。<br/>
5）主动提出保障安全生产，改善作业环境，维护职工健康，改进安全文明生产的措施和意见。<br/>
6）有权拒绝违章作业的指令，劝阻和制止他人违章作业。对玩忽职守人员有权举报和控告，有防止事故和事故发生，保护现场，抢救人员，抢险恢复的义务。
</font>
</TD>
</TR>
</TABLE>
</DIV>