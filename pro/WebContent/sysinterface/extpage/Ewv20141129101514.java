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
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.app.configsap.ConfigSapAction;
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
 public class Ewv20141129101514 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
        String requestid = this.requestid;//当前流程requestid 
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select welfaretype from uf_hr_welfare where requestid = '"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String welfaretype = StringHelper.null2String(map.get("welfaretype"));//福利类型
      System.out.println(welfaretype);
      System.out.println(requestid);
		if(welfaretype.equals("40285a90492d52480149315f7a151a9a"))//临召津贴
		{
          System.out.println("111111111111111111111111");
			SapSync s = new SapSync();
			try {
				s.syncSap("40285a904a9639b6014a994015b71f2f",requestid);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else
		{
          System.out.println("0000000000000000000000");
			SapSync s = new SapSync();
			try {
				s.syncSap("40285a904999a7ad01499d62699d25a3",requestid);
              System.out.println("111111111111111111111111");
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
	}
 
 
 } 

 }


 





