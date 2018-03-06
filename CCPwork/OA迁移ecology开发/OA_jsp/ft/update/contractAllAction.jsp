<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.subprocess.service.SubprocesssetService" %>
<%@ page import="com.eweaver.workflow.subprocess.model.Subprocessset" %>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService" %>
<%@ page import="com.eweaver.base.msg.EweaverMessage" %>
<%@ page import="com.app.fangtian.ContractSubmit"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<html>
<%	
	String sql = "select requestid from uf_contract where classes='2c91a0302a8cef72012a8ea9390903c6'  and hosttypep='2c91a0302db7a8ef012dbb230b0e1870' and  orgunit='2c91a0302a87f19c012a8979573b0012' and divideclasses='2c91a0302e76867f012eb8bb19f45fbf'";
	
	DataService ds = new DataService();
	List<Map> list = ds.getValues(sql);
	if(list!=null){
		out.println(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0037")+list.size()+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0038"));//共有...条数据需同步
	}
	int pass=0;
	for(Map map:list){
		pass++;
		out.println(labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e0039")+"--"+pass+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7e003a"));//已同步    条
		String requestid=StringHelper.null2String(map.get("requestid"));
		if(!"".equals(requestid)){	
			ContractSubmit cation = new ContractSubmit();
			cation.sycContract(requestid);
		}
	}
%>
  <head>
  </head>
  <body>
  
  </body>
</html>