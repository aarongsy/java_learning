/*
	部门奖惩申请到达结束：更新状态
*/

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


 public class Ewv20141110105137 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
	 
    // EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	//部门奖惩uf_hr_punrew
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	//更新状态为审核
	String upsql="update uf_hr_punrew set stateflag = '2' where requestid = '"+requestid+"'";
	baseJdbc.update(upsql);
	System.out.println("更新部门奖惩状态为审核为2"+upsql);
 } 

 }

