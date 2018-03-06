package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141231133907 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
    String requestid = this.requestid;//当前流程requestid 	
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String title= "select (d.objname || ':' || a.flowno || '-' || b.objname || '-' || c.objname) title from uf_hr_zzapply  a,humres b,orgunit c,selectitem d where a.objname=b.id and a.objdept =c.id and a.turntype=d.id and a.requestid='"+requestid+"'";
   	String upsql = "update uf_hr_zzapply set title=("+title+") where requestid='"+requestid+"'";
	baseJdbc.update(upsql);   
 } 

 }
