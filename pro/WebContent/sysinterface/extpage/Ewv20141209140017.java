package com.eweaver.sysinterface.extclass; 

import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
 public class Ewv20141209140017 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 

	 String sql = "select reqno from uf_oa_reconformdetail where requestid ='"+requestid+"'";
	 EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	 BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	 DataService ds = new DataService();
	 List list = baseJdbc.executeSqlForList(sql);
	 if(list.size()>0)
	 {
		 for(int s = 0;s<list.size();s++)
		 {
			 Map map = (Map)list.get(s);
			 String request = StringHelper.null2String(map.get("reqno"));
			 String upsql = "update uf_oa_deliveryapp set ifdz = '2' where requestid = '"+request+"'";
			 baseJdbc.update(upsql);
		 }
	 }
 } 

 }

