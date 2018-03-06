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
import com.sap.conn.jco.JCoTable;
import com.eweaver.app.configsap.SapSync;
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.app.configsap.ConfigSapAction;
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
 public class Ewv20141108163010 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
         String requestid = this.requestid;//当前流程requestid 
	 SapSync s = new SapSync();
			try {
				s.syncSap("40285a9049a3a72a0149ac32e27b5b28",requestid);
			} catch (Exception e) {
				e.printStackTrace();
			}
 
 } 

 }




