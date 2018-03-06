package com.eweaver.sysinterface.extclass; 
 
import com.eweaver.app.configsap.ConfigSapAction;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141211192555 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    String id = "297e55a6499d3d3a01499da5d04e02bc";
    ConfigSapAction c = new ConfigSapAction();
	try {
		c.syncSap(id,requestid);
	} catch (Exception e) {
		e.printStackTrace();
	}

} 

}

