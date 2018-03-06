package com.eweaver.sysinterface.extclass; 
 
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoTable;
 public class Ewv20141108163129 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = " select h.exttextfield15,t.welfaretype,t.jsmonth,t.money from uf_hr_welfare t,humres h where h.id=t.objnum and t.requestid='"+requestid+"'";
	//薪资发放月
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String sapno = StringHelper.null2String(map.get("exttextfield15"));//
		String salaryno ="";
		String type = StringHelper.null2String(map.get("welfaretype"));//
		if(type.equals("40285a90492d52480149315f7a141a96"))//结婚礼金
		{
			salaryno="6035";
		}
		else if(type.equals("40285a90492d52480149315f7a141a97"))//丧葬慰问金
		{
			salaryno="6040";
		}
		else if(type.equals("40285a90492d52480149315f7a151a98"))//生育津贴
		{
			salaryno="6045";
		}
		else if(type.equals("40285a90492d52480149315f7a151a9a"))//临召津贴
		{
			salaryno="6035";
		}
		else //话费补贴
		{
			salaryno="6035";
		}
		
		String month = StringHelper.null2String(map.get("jsmonth"));//
		String amount = StringHelper.null2String(map.get("money"));//


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
      	month=month.replace("-","");
		function.getImportParameterList().setValue("PERNR",sapno);//人员编号
		function.getImportParameterList().setValue("LGART",salaryno);//工资项编码
		function.getImportParameterList().setValue("MONTH",month);//薪资发放月
		function.getImportParameterList().setValue("BETRG",amount);//金额
		function.getImportParameterList().setValue("WAERS","RMB");//货币码
		
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

	}
 
 
 } 

 }

