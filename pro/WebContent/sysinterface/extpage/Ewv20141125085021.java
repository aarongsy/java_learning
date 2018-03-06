package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import java.util.List;
import java.util.Map;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;

 public class Ewv20141125085021 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
    String requestid = this.requestid;//当前流程requestid 	
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String title= "select ('试用期评核：' || b.flowno || '-' || a.objname || '-' || c.objname) title from uf_hr_probation b,humres a,orgunit c where a.id=b.jobname  and a.orgid=c.id and b.requestid='"+requestid+"'";
	String upsql = "update uf_hr_probation set title=("+title+") where requestid='"+requestid+"'";
	baseJdbc.update(upsql);  
 } 

 }






