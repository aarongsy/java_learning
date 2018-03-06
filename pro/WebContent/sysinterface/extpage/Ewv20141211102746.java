package com.eweaver.sysinterface.extclass; 
 
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.eweaver.app.configsap.SapSync;
 public class Ewv20141211102746 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select advise from uf_hr_zzapply where requestid = '"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String result = StringHelper.null2String(map.get("advise"));//评核建议
		System.out.println("SYZZ  11 advise="+result);	
		if(result.equals("40285a8f489c17ce0148f379227367f5"))//正式录用
		{
			SapSync s = new SapSync();
			try {
				s.syncSap("40285a9049a3a72a0149a6ef88180acb",requestid);
              System.out.println("SYZZ 22 TOSAP advise="+result + "requestid="+requestid);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
 
 
 } 

 }



