package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141215113104 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "delete from uf_hr_alterclasssub where requestid='"+requestid+"'";
	baseJdbc.update(sql);
 } 
 }

