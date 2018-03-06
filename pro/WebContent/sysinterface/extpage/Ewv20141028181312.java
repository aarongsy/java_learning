package com.eweaver.sysinterface.extclass; 
 
 import java.util.List;
import java.util.Map;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
public class Ewv20141028181312 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select sapid,valimonth,nowtype from uf_oa_dormchange where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String theMonth = StringHelper.null2String(map.get("valimonth"));//生效月份
		theMonth = theMonth + "-01";
		String sapid = StringHelper.null2String(map.get("sapid"));//SAP员工工号
		String nowtype = StringHelper.null2String(map.get("nowtype"));//勤宿状态
		String money = "0";
		if(nowtype.equals("40285a904931f62b0149560be5650421")){
			money = "100";
		}
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT0014_S1_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("PERNR",sapid);
		function.getImportParameterList().setValue("BEGDA",theMonth);
		function.getImportParameterList().setValue("ENDDA","9999-12-31");
		function.getImportParameterList().setValue("LGART","7060");
		function.getImportParameterList().setValue("BETRG",money);
		function.getImportParameterList().setValue("WAERS","RMB");

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//返回值
		String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
		String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
		String upsql="update uf_oa_dormchange set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where requestid='"+requestid+"'";
		baseJdbc.update(upsql);
	}
} 
}
