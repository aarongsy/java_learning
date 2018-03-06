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
import com.sap.conn.jco.JCoTable;
public class Ewv20141028164241 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
	 
	String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select tomonth from uf_hr_foodmoney where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String theMonth = StringHelper.null2String(map.get("tomonth"));//生效月份
		theMonth = theMonth.replace("-", "");
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT0015_M1_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("LGART","7020");
		function.getImportParameterList().setValue("MONTH",theMonth);
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT0015");
		sql = "select sapid,total from uf_hr_foodmoneysub where requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String sapid = StringHelper.null2String(map.get("sapid"));
				String total = StringHelper.null2String(map.get("total"));
				retTable.appendRow();
				retTable.setValue("PERNR", sapid);
				retTable.setValue("BETRG", total);
				retTable.setValue("WAERS", "RMB");
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
		//返回值
		String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
		String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
		String upsql="update uf_hr_foodmoney set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where requestid='"+requestid+"'";
		baseJdbc.update(upsql);
	}
} 
}


