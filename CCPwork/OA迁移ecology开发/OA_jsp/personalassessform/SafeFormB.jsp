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
<TD noWrap class="td2"  align=left ><font size=4>班组长安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）落实执行上级对安全生产的指令和要求，全面负责本班组的安全生产。<br/>
2）组织员工学习并认真执行公司、部门各项安全生产规章制度和安全技术操作规程，教育员工遵章守纪，制止违章行为，确保本班组的安全生产。<br/>
3）参加公司、部门开展的各项安全活动，坚持班前讲安全、班中检查安全、班后总结安全。<br/>
4）负责对新员工进行岗位安全教育。<br/>
5）负责班组安全检查，发现不安全因素及时消除，并报告上级。发生事故立即报告，组织抢救，保护好现场，做好详细记录，并参加事故调查、分析落实防范措施。<br/>
6）负责生产设备、安全装备、消防设施、防护器材和急救器具的日常检查维护工作，使其经常保持完好和正常运行。督促教育职工合理使用劳动防护用品、用具，正确使用灭火和气防器材。<br/>
7）组织班组安全生产竞赛，表彰先进，总结经验。<br/>
8）负责班组基层建设、基础管理，提供班组管理水平。保持生产作业现场整齐、清洁，实现清洁文明生产。
</font>
</TD>
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
</TABLE>
</DIV>