package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141230102723 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     DataService ds = new DataService();
     String sql = "update uf_lo_budget b"
    		 	+" set isremark = 1"
    		 	+" where b.invoiceno in"
    		 	+" (select d.invoiceno"
    		 	+" from uf_lo_checkzxzgdetail d"
    		 	+" where d.requestid = '"+requestid+"')";
     ds.executeSql(sql);
 } 
 }
