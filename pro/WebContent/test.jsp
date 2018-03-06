<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<html>
<head>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script src='<%=request.getContextPath()%>/dwr/interface/FormbaseService.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/AutoRefresher.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<script type="text/javascript" language="javascript" src="/app/jscript/validate.js"></script>
<script type="text/javascript" language="javascript" src="/app/jscript/pubUtil.js"></script>
<script type="text/javascript" language="javascript" src="/app/jscript/eventUtil.js"></script>
<script type="text/javascript" language="javascript" src="/app/jscript/strUtil.js"></script>
<script>


</script>

</head>

<body>
<div id="warpp">
	 
	 <div class="mainbg">
     <div class="mainleft"><img src="/images/fotile/223_17.gif" width="97" height="35" /></div>
     <div class="mainright">
       <div style="width:410px; float:left;">
       <div class="titlebg"><img src="/images/fotile/223_18.gif" width="15" height="14" /> 年度预算编制</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
       <ul>
			<li><a href="javascript:if(top.frames[1])onUrl('/workflow/request/workflow.jsp?workflowid=4028e40f2fcb9c97012fce90e7d501ae','管理费用年度预算编制',url.replace('/','/'))" >管理费用年度预算编制</a></li> 
			<li><a href="javascript:window.open('/workflow/request/workflow.jsp?workflowid=4028e40f2fcb9c97012fd2dbfd4f5c8b','')">营业费用年度预算编制</a></li>
			<li><a href="/workflow/request/workflow.jsp?workflowid=4028e40f2fcb9c97012fd38211b1777e">制造费用年度预算编制</a></li>
			<li><a target="_blank" href="/workflow/request/workflow.jsp?workflowid=4028e40f2fcb9c97012ff2b2086f25fa">技改年度预算编制</a></li>
       </ul>
       </div>
       </div>
       <div style="width:420px; float:left;">
       <div class="titlebg"><img src="/images/fotile/223_21.gif" width="17" height="18" /> 项目报告</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
       <ul>
			<li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482cdd4f7a012cdf50935203ed&amp;targeturl=">发起报告</a></li>
			<li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.report.servlet.ReportAction?action=search&amp;reportid=402889772ce80638012ce8ffa00a0a4b">项目报告汇总</a></li>
			<li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ce2cf35012ce383fbf2030f&amp;targeturl=">追加报告数量</a></li>
			<li>  <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ce2cf35012ce3c7400a04de&amp;targeturl=">修改报告</a></li>
			<li>   <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ce2cf35012ce3f5573c0a6a&amp;targeturl=">作废报告</a></li>
			<li>   <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ce2cf35012ce40699820a92&amp;targeturl=">报告空号</a></li>
       </ul>
       </div>
       </div>
       <div style="width:410px; float:left;">
       <div class="titlebg"><img src="/images/fotile/223_26.gif" width="18" height="18" /> 项目档案</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
       <ul>
         <li>  <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ccde921012ccefd04280512&amp;targeturl=">档案归档</a></li>
		  <li>  <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.report.servlet.ReportAction?action=search&amp;reportid=402881482ccde921012ccf4435be06e0">项目档案汇总表</a></li>
		  <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ccde921012ccf7ddaa40930&amp;targeturl=">档案借阅</a></li>
       </ul>
       </div>
       </div>
       <div style="width:420px; float:left;">
       <div class="titlebg"><img src="/images/fotile/223_27.gif" width="15" height="14" /> 项目财务</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
       <ul>
         <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ccde921012cce29236f0328&amp;targeturl=">开票管理</a></li>
		 <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ccde921012ccf451ec70718&amp;targeturl=">差旅费用借款</a></li>
		 <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402881482ccde921012ccf96a5a00994&amp;targeturl=">差旅费用报销</a></li> 
       </ul>
       </div>
       </div>
     </div>
   </div>
	 
	 
	 
</div>
  
   
   
   
   
   <div class="mainbg">
     <div class="mainleft"><img src="/images/fotile/223_31.gif" width="97" height="35" /></div>
     <div class="mainright">
       <div class="titlebg"><img src="/images/fotile/223_32.gif" width="18" height="18" />个人财务</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
	    <ul>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c060a12012c064659f00099&amp;targeturl=">办公费备用金申请</a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c060a12012c06776ee10162&amp;targeturl=">办公费用报销申请</a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c060a12012c06ef94a202fc&amp;targeturl=">个人福利报销申请</a></li>
       </ul>
       </div>

       <div class="titlebg"><img src="/images/fotile/223_35.gif" width="18" height="18" />行政管理</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
	    <ul>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889792bf58ac5012bf5b8b19b0029&amp;targeturl=">用章申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504b38ac4459"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889792bf58ac5012bf5e9dadf00b6&amp;targeturl=">名片印刷申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504bf7bb44c9"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889792bf58ac5012bf60e024e00fa&amp;targeturl=">注册会计师印章申请(HR发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504ca1d144e5"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
		 <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889792bf69491012bf6a18e37001f&amp;targeturl=">鹏城所证书借用申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504d1b374500"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
		 </ul>
		 <ul>
		 <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889792bf69491012bf6e053fb00ed&amp;targeturl=">低值易耗品购买申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504d9b05451b"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
		 <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c060a12012c062d17240028&amp;targeturl=">公文审批申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504f28ae4536"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
		 <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=297edff82dbdd610012e00d9d9cb7786&amp;targeturl=">行政合同申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504fd9224550"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a></li>
       </ul>
       </div>

       <div class="titlebg"><img src="/images/fotile/223_39.gif" width="18" height="18" />人事管理</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
	    <ul>
         <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c14b175012c15c548ca017a&amp;targeturl=">人员招聘申请(部门经理发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504290874248"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c14b175012c1634858901fe&amp;targeturl=">员工入职申请(HR发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e50438df0426e"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c3a3742012c3a47fa350003&amp;targeturl=">人员异动申请(部门经理发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e5044fdcf42d0"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c3490aa012c34ff914a0083&amp;targeturl=">员工转正定级申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e50461ac6434c"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a></li>
       </ul>
	    <ul>
         <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c4d72ca012c4e58d9e100b4&amp;targeturl=">人员借用申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e50481db443a0"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889782c52b254012c537ae3fc0076&amp;targeturl=">员工请销假申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e5049026b43fd"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889782c5780d1012c589955fc011f&amp;targeturl=">员工辞职（退）申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e504976b4441a"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c060a12012c06ca26d80238&amp;targeturl=">加班申请(行政部各部门经理发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e50f1a74f65cf"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a></li>
       </ul>
       </div>

       <div class="titlebg"><img src="/images/fotile/223_13.gif" width="18" height="18" />IT管理</div>
       <div class="sublink" style="border-bottom:1px #cbd5d8 solid;">
	    <ul>
         <li> <a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=402889772c85a90d012c86fc861400b1&amp;targeturl=">IT资产购买申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e503b96cb4082"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=297edff82d5178f8012d73e90a8f0e17&amp;targeturl=">IT资产维修申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e503d8b1f4156"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=297edff82d5178f8012d77df125521dd&amp;targeturl=">IT资产领用借用申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e503eaa554176"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=297edff82d7a17ba012d7d02786f06a8&amp;targeturl=">IT资产更换归还申请</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e503fe8a641a7"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;</li>
		 </ul>
		 <ul>
         <li><a id="" target="_blank" href="/ServiceAction/com.velcro.workflow.workflow.servlet.WfViewAction?pipeid=297edff82d7a17ba012d7e7af0a63cdb&amp;targeturl=">IT资产报废申请(IT室发起)</a>&nbsp;<a id="" target="_blank" href="/vdocument/base/docbaseview.jsp?id=297edff82dbdd610012e5040e8bf41c3"><img src="/images/fotile/223_attach.gif" width="12" height="12" border="0"></a></li>
       </ul>
       </div>


     </div>
   </div>
   </div>
</div>
</body>
</html>
