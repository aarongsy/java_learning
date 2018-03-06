/**
 * 月度奖惩名单
 */
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
import java.io.OutputStream; 

 public class Ewv20141031165438 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid
  
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select jcjxy,flowno from uf_hr_monthreward where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String theMonth = StringHelper.null2String(map.get("jcjxy"));//生效月份
        String flowno =  StringHelper.null2String(map.get("flowno"));//生效月份
        System.out.println("flowno="+flowno +" theMonth="+theMonth);
		theMonth = theMonth.replace("-", "");
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT9001_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("MONTH",theMonth);
		//建表
		JCoTable retTable = function.getTableParameterList().getTable("IT9001");
		sql = "select sapid,pubresult from uf_hr_monthrewardsub where requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
        
		if(list.size()>0){
			for(int i=0;i<list.size();i++){
				Map m = (Map)list.get(i);
				String sapid = StringHelper.null2String(m.get("sapid"));
				String pubid = StringHelper.null2String(m.get("pubresult"));                
				retTable.appendRow();
				retTable.setValue("PERNR", sapid);
				retTable.setValue("ZETYP", pubid);
				retTable.setValue("ZENUM", flowno);
                System.out.println("PERNR="+sapid +" ZETYP="+pubid+" ZENUM="+flowno);
                
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
		String upsql="update uf_hr_monthreward set errmsg='"+MESSAGE+"',tohr='"+MSGTY+"' where requestid='"+requestid+"'";
   System.out.println("upsql="+upsql);		
      baseJdbc.update(upsql);
	}
 
 } 

 }






