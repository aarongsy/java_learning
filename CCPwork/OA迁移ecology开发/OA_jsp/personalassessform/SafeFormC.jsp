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
<TD noWrap class="td2"  align=left ><font size=4>部门安全员安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）组织或者参与拟订本单位安全生产规章制度、操作规程和生产安全事故应急救援预案。<br/>
2）组织或者参与本单位安全生产教育和培训，如实记录安全生产教育和培训情况。<br/>
3）督促落实本单位重大危险源的安全管理措施。<br/>
4）组织或者参与本单位应急救援演练和调查处理。<br/>
5）检查本单位的安全生产状况，及时排查生产安全事故隐患，提出改进安全生产管理的建议。<br/>
6）制止和纠正违章指挥、强令冒险作业、违反操作规程的行为。<br/>
7）督促落实本单位安全生产整改措施。<br/>
8）组织安全生产日常检查、岗位检查和专业性检查，并每月至少组织一次安全生产全面检查。<br/>
9）督促各部门、各岗位履行安全生产职责，并组织考核、提出奖惩意见。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>制造工程师安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）负责生产工艺中的安全技术工作，确保工艺技术安全可靠。<br/>
2）负责编制辖区安全技术规程及有关管理制度。编制开停工、技术改造方案时、应有可靠的安全卫生技术措施，并对执行情况进行检查监督。<br/>
3）负责对生产操作人员进行生产安全操作技术与安全生产知识培训，组织安全生产技术练兵和考核。<br/>
4）每天深入现场检查安全生产情况，发现事故隐患及时整改。制止违章作业、违章指挥、紧急情况下有权停止作业，并立即报请领导处理。<br/>
5）参加公司新建、扩建、改建工程设计审查、竣工验收；参加工艺改造、工艺条件变动方案的审查，使之符合安全技术要求。<br/>
6）负责公司生产线检修、停工、开工安全技术方案的制订，对方案执行情况进行检查监督。<br/>
7）及时报告与生产有关的事故，并参加调查、分析。
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
3）认真学习和遵守劳动纪律和公司各项安全生产规章制度及安全操作规程，努力学习安全知识，积极参加各种安全活动，不断提高安全生产意识和安全技能。对本职工作要搞清楚弄明白，不懂和没有把握的事要先学习或请示上级，不可以盲目和不文明操作或作业。<br/>
4）掌握各种防护器具和消防器材的使用方法，保持作业环境整洁，进入生产和施工现场，要穿戴好劳动保护用品，做好劳动保护工作。<br/>
5）主动提出保障安全生产，改善作业环境，维护职工健康，改进安全文明生产的措施和意见。<br/>
6）有权拒绝违章作业的指令，劝阻和制止他人违章作业。对玩忽职守人员有权举报和控告，有防止事故和事故发生，保护现场，抢救人员，抢险恢复的义务。
</font>
</TD>
</TR>
</TABLE>
</DIV>