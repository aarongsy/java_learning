/*
人事主管提交，改状态为2
*/
package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 import com.eweaver.base.BaseContext;
 import com.eweaver.base.BaseJdbcDao;

 public class Ewv20141111095337 extends EweaverExecutorBase{ 
 
 @Override 
 public void doExecute (Param params) {
  
    String requestid = this.requestid;//当前流程requestid 

    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
   	//更新状态为审核
	String upsql="update uf_hr_monthreward set stateflag = '2' where requestid = '"+requestid+"'";
	baseJdbc.update(upsql);
	System.out.println("更新月度奖惩状态为总经理审核"+upsql);
 
 
 } 

 }
