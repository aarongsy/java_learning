package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.app.configsap.ConfigSapAction; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141217175439 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
	String requestid = this.requestid;//当前流程requestid 
	String id= "40285a9049bb5ef30149bbae322705b4";
	ConfigSapAction c = new ConfigSapAction();
	try {
	 c.syncSap(id, requestid);
	} catch (Exception e) {
	 e.printStackTrace();
	}
 } 
 }