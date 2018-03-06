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
public class Ewv20141106155027 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select result,sapid,movedate,reasonid,insapunit,togroup,togroupsub from uf_hr_deptmove where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String result = StringHelper.null2String(map.get("result"));//异动结果
		if(result.equals("40285a8f489c17ce0148fdd2c91a2f36")){//可调动
			String sapid = StringHelper.null2String(map.get("sapid"));//生效月份
			String movedate = StringHelper.null2String(map.get("movedate"));//生效日期
			movedate = movedate.replace("-", "");
			String reasonid = StringHelper.null2String(map.get("reasonid"));//异动原因id
			String insapunit = StringHelper.null2String(map.get("insapunit"));//sap职位
			String togroup = StringHelper.null2String(map.get("togroup"));//员工组
			String togroupsub = StringHelper.null2String(map.get("togroupsub"));//员工子组

			//创建SAP对象		
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZHR_IT0000_Z4_CREATE";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//插入字段
			function.getImportParameterList().setValue("PERNR",sapid);
			function.getImportParameterList().setValue("BEGDA",movedate);
			function.getImportParameterList().setValue("MASSG",reasonid);
			function.getImportParameterList().setValue("PLANS",insapunit);
			function.getImportParameterList().setValue("PERSG",togroup);
			function.getImportParameterList().setValue("PERSK",togroupsub);

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
			String upsql="update uf_hr_deptmove set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where id='"+requestid+"'";
			baseJdbc.update(upsql);
			}		
		}
	} 
}



