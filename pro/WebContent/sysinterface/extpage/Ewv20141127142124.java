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


 public class Ewv20141127142124 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
	 BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = " select grade from uf_yz_ansupplyeval where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String grade = StringHelper.null2String(map.get("grade"));//SAP员工工号
		if(grade.equals("D"))
		{
			SapSync s = new SapSync();
			try {
				s.syncSap("40285a9049eeab010149efdbb43f1909", requestid);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
 } 

 }


