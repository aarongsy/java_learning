
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
public class Ewv20141108143751 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
	String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	//String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = " select s.objname from uf_hr_festivalcash t,selectitem s where s.id=t.month and t.requestid='"+requestid+"'";
	//薪资发放月
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String month = StringHelper.null2String(map.get("objname"));//薪资发放月





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

		function.getImportParameterList().setValue("LGART","6050");//工资项编码
		function.getImportParameterList().setValue("MONTH",month);//薪资发放月
		

		


		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT0015");
		sql = "select t.money,b.exttextfield15 from uf_hr_festivalcashsub t,humres b  where t.objnum=b.id and t.requestid='"+requestid+"'";
		//人员编号，金额，货币代码
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				 map = (Map)list.get(i);
				String sapno=StringHelper.null2String(map.get("exttextfield15"));
				String money = StringHelper.null2String(map.get("money"));//付款方式

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

	}
}
     
 
 } 

 }



