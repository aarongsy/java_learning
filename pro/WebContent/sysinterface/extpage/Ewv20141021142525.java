package com.eweaver.sysinterface.extclass; 
import com.eweaver.app.configsap.ConfigSapAction;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;

public class Ewv20141021142525 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid  
	ConfigSapAction c = new ConfigSapAction();
	try {
		c.syncSap("297e55a6499d3d3a01499dcc3774042a", requestid);
	} catch (Exception e) {
		e.printStackTrace();
	}
} 
}






