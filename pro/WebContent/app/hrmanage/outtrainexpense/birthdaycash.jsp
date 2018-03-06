<%@ page contentType="text/html; charset=UTF-8"%>
 
<%@ page import="java.text.ParseException"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%@ page import="com.eweaver.base.*"%> 
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase"%> 
<%@ page import="com.eweaver.app.configsap.SapConnector"%>
<%@ page import="com.sap.conn.jco.JCoException"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>


<%
	String requestid = this.requestid;//当前流程requestid 
	String sapno="";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = " select t.xzjsmonth from uf_hr_birthdaycash t where t.requestid='"+requestid+"'";
	//薪资发放月
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String month = StringHelper.null2String(map.get("xzjsmonth"));//薪资发放月





		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT0015_M2_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		month=month.repalce("-","");
		function.getImportParameterList().setValue("LGART","6030");//工资项编码
		function.getImportParameterList().setValue("MONTH",month);//薪资发放月
		

		


		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT0015");
		sql = "select t.money,b.sapid from uf_hr_birthdaycashsub t,uf_hr_sapinfo  b  where t.requestid=b.requestid and b.msgty='E' and t.requestid='"+requestid+"'";
		//人员编号，金额，货币代码
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				 map = (Map)list.get(i);
				 sapno=StringHelper.null2String(map.get("sapid"));
				String money = StringHelper.null2String(map.get("money"));//金额

				retTable.appendRow();
				retTable.setValue("PERNR", sapno); //人员编号
				retTable.setValue("BETRG", money);//工资项金额
				retTable.setValue("WAERS", "RMB");//货币码


			}
		}
		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
		String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
		String upsql="update uf_hr_sapinfo set msgty='"+MSGTY+"',msgtx='"+MESSAGE+"' where requestid='"+requestid+"' and sapid='"+sapno+"'";
		//String upsql="update uf_hr_leave set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where requestid='"+requestid+"'";
		baseJdbc.update(upsql);

	}
}
     
%>


