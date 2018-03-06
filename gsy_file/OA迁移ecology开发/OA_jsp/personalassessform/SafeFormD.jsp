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
<TD noWrap class="td2"  align=left ><font size=4>安环卫部主管安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）贯彻执行国家安全生产的方针、政策、法律、法规、规定、制度和标准，在协理和安委会的领导下开展安全生产管理和监督工作。<br/>
2）负责厂级安全教育培训和考核工作。组织开展各种厂级安全宣传、教育活动和应急预案演练。<br/>
3）组织制订、修订全厂性的安全管理制度和安全技术规程，编制安全技术措施计划并监督检查执行情况。<br/>
4）组织全厂性安全检查，协助和督促有关部门对查处的隐患制订防范措施和整改计划，并检查监督隐患整改工作的完成情况。组织重大隐患治理项目的评估、立项、申报及项目实施的检查监督工作。<br/>
5）参加新建、改建、扩建工程及大修、技改技措项目的劳动保护设施“三同时”审查、验收，保证符合安全卫生技术要求。<br/>
6）依据相关的法律法规要求，委托具有资质的中介机构，做好本企业的安全评价和职业安全健康体系的认证工作，建立危险源的监控体系，制定事故应急救援预案等保障安全生产的基础工作。<br/>
7）建立和保管特种设备档案，会同使用部门和工服部对特种设备及其各类安全附件进行安全监督检查。<br/>
8）深入现场进行安全监督，检查安全管理制度执行情况，纠正违章、督促并协助解决有关安全生产的重大问题。遇有危机安全生产的紧急情况，有权责令其停止作业。<br/>
9）参加各类事故的调查、处理和工伤认定工作。<br/>
10）按照国家有关规定，负责制订职工劳动防护用品的发放标准，并按规定及时发放并监督使用情况。<br/>
11）综合分析公司安全生产中的突出问题，及时向公司主管领导及安委会汇报，并会同有关部门提出改进意见。<br/>
12）对公司各部门安全工作进行考核评比，对在安全生产中有贡献者或事故责任者提出奖惩意见。开展安全生产竞赛活动，总结交流安全生产先进经验。<br/>
13）建立、健全从安委会到基层班组的安全生产管理网络。指导基层安全工作。加强安全基础建设。<br/>
14）会同有关部门搞好公司职业安全卫生和劳动保护工作、不断改善劳动条件。<br/>
15）按照国家有关规定组织好职工健康检查，建立健全职工健康监护档案。<br/>
16）主导全厂消防设施的维护保养与管理工作。<br/>
17）负责对外包商实施资质审查，不让无资质的外包进厂工作。负责外包人员进厂时的安全培训，核发出入证（工安讲习卡）。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>制造部主管安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）负责领导和组织本部门的安全工作，对本部门的安全生产全面负责。<br/>
2）在组织管理生产过程中，必须认真执行政府安全生产方针、政策、法令和公司的规章制度，落实公司安委会的决议，切实贯彻安全生产“五同时”，对部门员工在生产中的安全健康负全面责任。<br/>
3）在分管上级领导下，制定生产工艺过程中各岗位（工种）安全操作规程，检查安全规章制度的执行情况，保证工艺文件、技术资料和工具设备等符合安全方面的要求。<br/>
4）在进行生产作业前，制定和贯彻作业规程、操作规程的安全措施，并经常检查执行情况。<br/>
5）负责各类危险作业许可证的审批，组织落实好各项安全防范措施，安排危险作业监护人员。<br/>
6）组织制定临时任务和大、中、小修的安全措施，经主管审查后执行，并负责检查执行情况。<br/>
7）经常检查部门内生产建筑物、设备、工具和安全设施，组织整理工作场所，及时排除隐患。发现危及人身安全的紧急情况，立即下令停止作业，撤出人员。<br/>
8）组织对员工进行劳动纪律、规章制度和安全知识、操作技术教育。对新员工、新换岗员工，在其上岗工作之前进行安全教育并考核。<br/>
9）负责生产事故的调查处理，发生事故后及时向上级和安全管理部门报告。组织抢救，保护现场，参加事故调查。<br/>
10）定期召开部门安全生产例会，分析部门安全生产动态，及时解决安全生产中存在的问题，组织班组安全活动，支持部门安全员工作。<br/>
11）各部门对本部门内部安全设施（消防、气体警报、安全联锁装置等）负责。<br/>
12）做好对女工特殊保护的具体工作。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>制造部课长安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）协助生产部主管做好本部门安全生产工作，在主管的领导下，对所分管业务范围内的安全生产负直接责任。<br/>
2）组织员工认真执行国家有关安全生产的法规、标准和公司规章制度，坚持生产与安全“五同时”。<br/>
3）在保证安全的前提下组织指挥生产，及时制止违法安全生产制度和安全技术规程的行为。<br/>
4）在生产过程中发现不安全因素、险情和事故时，应果断正确处理，立即报告主管领导，并通知有关职能部门，防止事态扩大。<br/>
5）贯彻执行工艺操作记律和操作规程，杜绝或减少非计划停工和跑、冒、滴、漏事故，实现安、稳、长、满、优生产。<br/>
6）定期组织安全检查。对检查出的有关问题，应有计划的及时整改，按期实现安全技术措施计划和事故隐患整改项目。<br/>
7）负责员工生产技术培训和考核，检查新入职员工二、三级安全教育工作。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>公用部主管安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）负责领导和组织本部门的安全工作，对本部门的安全全面负责。<br/>
2）认真贯彻执行政府安全生产方针、政策、法令和公司的规章制度，落实公司安委会决议。<br/>
3）组织制订、修订和审批部门有关机械/电气、仪表设备检修、维护保养及施工等方面的安全规章制度和安全操作规程，并组织实施。<br/>
4）负责各种机械/电气、仪表设备、设备元件及工业建筑物的安全管理，使其符合安全技术规范和标准的要求。<br/>
5）负责各种机械/电气、仪表设备、设备元件及工业建筑物的维护保养和安全检查，消除事故隐患，确保安全生产。<br/>
6）定期组织本部门辖区内的安全检查（例:粉尘、消防），及时消除各类安全隐患。<br/>
7）组织所属员工的安全培训与考核。对新员工、新换岗员工，在其上岗工作之前进行安全教育并考核。<br/>
8）对外来检修作业等有关人员，应组织做好安全教育工作及施工中的安全管理工作，负责贯彻有关施工纪律的管理规定。<br/>
9）负责本部门安全事故的调查处理，发生事故后及时向上级和安全管理部门报告。组织抢救，保护现场，参加事故调查。<br/>
10）定期召开部门安全生产例会，分析部门安全动态，及时解决安全管理中存在的问题，组织班组安全活动，支持部门安全员工作。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>机械部/仪电部主管安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）协助领导和组织本部门的安全工作，对本部门的安全全面负责。<br/>
2）负责各类仪表、电气连锁装置、安全检测测量设备的定期安全检查和校验工作。<br/>
3）协助本部门主管辖区内的安全检查，及时消除各类安全隐患。<br/>
4）协助本部门安全事故的调查处理，发生事故后及时向上级和安全管理部门报告。组织抢救，保护现场，参加事故调查。<br/>
5）协助召开部门安全生产例会，分析部门安全动态，及时解决安全管理中存在的问题，组织班组安全活动，支持部门安全员工作。<br/>
6）负责安全阀等设备安全附件的定期检校工作。<br/>
7）负责辖区员工专业技术培训和考核，检查新入职员工二、三级安全教育工作。
</font>
</TD>
</TR>

<TR class="tr1">
<TD noWrap class="td2"  align=left ><font size=4>财务部主管安全职责</font></TD>
</TR>
<TR class="tr1">
<TD noWrap class="td2"  align=left>
<font size=3>
1）认真贯彻执行国家相关的安全生产方针、政策和法规，落实公司安委会决议。<br/>
2）贯彻国家关于安全措施经费提取使用的规定，专款专用，并监督执行，建立安全措施经费专项帐户。<br/>
3）定期缴纳安全生产风险抵押金，为在职员工缴纳工伤保险。<br/>
4）保证事故隐患治理、安全教育等各项安全费用所需资金及时到位。利用经济手段协助安全监督管理部门搞好安全生产工作。<br/>
5）在组织成本分析、经济核算等经济活动时，分析安全费用情况。<br/>
6）负责审核各类事故处理费用开支，提出发生事故后的经济损失数字，并将其纳入公司经济活动分析内容。<br/>
7）保证现金管理制度的有效执行，协助有关部门对财务违章违规行为进行调查处理。
</font>
</TD>
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
</TABLE>
</DIV>