package com.eweaver.sysinterface.extclass; 
 
import java.util.Calendar;
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
public class Ewv20141205102000 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select objtype,inout,sapjobno from uf_hr_overtime where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String objtype = StringHelper.null2String(map.get("objtype"));//加班类别
		String inout = StringHelper.null2String(map.get("inout"));//班前/班后加班
		String LGART = "";
		if(objtype.equals("40285a8f489c17ce0149082fab7548cd") && inout.equals("40285a8f489c17ce0149082f325248c7")) LGART = "3060";//临召加班
		if(objtype.equals("40285a8f489c17ce0149082fab7548cd") && (inout.equals("40285a904a132ef8014a142553780f6b") || inout.equals("40285a904a132ef8014a142553790f6c"))) LGART = "3055";//驻厂加班
		if(LGART.length()>1){
			String sapjobno = StringHelper.null2String(map.get("sapjobno"));//SAP员工编号
			String moneyMonth = "";
			//当前时间判断，是否跨薪资月
			Calendar cd= Calendar.getInstance();
			int year = cd.get(Calendar.YEAR);
			int month = cd.get(Calendar.MONTH);
			int day = cd.get(Calendar.DAY_OF_MONTH);
			if(day>27){
				month = month + 1;
			}
			if(month<10) moneyMonth = year+"0"+month;else moneyMonth = year+""+month;
			
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZHR_IT2010_S1_CREATE";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			function.getImportParameterList().setValue("PERNR",sapjobno);
			function.getImportParameterList().setValue("LGART",LGART);
			function.getImportParameterList().setValue("ANZHL","1");
			function.getImportParameterList().setValue("MONTH",moneyMonth);

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

			String upsql="update uf_hr_overtime set lzzcmessage='"+MESSAGE+"',lzzcmsgty='"+MSGTY+"' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
			//更新表单所属薪资月
			upsql = "update uf_hr_overtime set themonth='"+moneyMonth+"' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
		}			
	}
} 
}




