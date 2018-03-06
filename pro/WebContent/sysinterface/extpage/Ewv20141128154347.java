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
import com.eweaver.app.configsap.SapSync;


 public class Ewv20141128154347 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
	 BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String nsql = "select to_char(sysdate,'YYYY-MM-DD') as appdate from dual";
	List nlist = baseJdbc.executeSqlForList(nsql);
	if(nlist.size()>0){
		Map nmap = (Map)nlist.get(0);
		String appdate = StringHelper.null2String(nmap.get("appdate"));//审批时间
		String upsql = "update uf_yz_enginaccept  set appdate = '"+appdate+"' where requestid = '"+requestid+"'";
		baseJdbc.update(upsql);
	}
	SapSync s = new SapSync();
	try {
		s.syncSap("40285a9049eeab010149f5719dce3258",requestid);
	} catch (Exception e) {
		e.printStackTrace();
	}
 } 
 }
