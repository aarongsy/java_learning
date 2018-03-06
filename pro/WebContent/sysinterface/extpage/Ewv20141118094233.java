package com.eweaver.sysinterface.extclass; 
 
 import java.util.List;
 import java.util.Map;
 import com.eweaver.base.BaseContext;
 import com.eweaver.base.BaseJdbcDao;
 import com.eweaver.base.util.StringHelper;

 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141118094233 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
 	String upsql = "update uf_oa_carapp set stateflag='2' where requestid ='"+requestid+"'";
	baseJdbc.update(upsql);	
 } 

 }
