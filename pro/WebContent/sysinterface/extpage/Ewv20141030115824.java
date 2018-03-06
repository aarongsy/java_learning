package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
 
 public class Ewv20141030115824 extends EweaverExecutorBase{

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
    /* EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
     String issave = params.getParamValueStr("issave");//是否保存 
     String isundo = params.getParamValueStr("isundo");//是否撤回 
     String formid = params.getParamValueStr("formid");//流程关联表单ID 
     String editmode = params.getParamValueStr("editmode");//编辑模式 
     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写*/ 

	 BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String upflowtypesql = "update uf_hr_temploanform  set flowtype = '40285a8f489c17ce0148a12871bb0d9a' where requestid = '"+requestid+"'";
	 baseJdbc.update(upflowtypesql);
   
	 String sql = "select * from uf_hr_temploanform where requestid = '"+requestid+"'";
	 List list = baseJdbc.executeSqlForList(sql);
	 if(list.size()>0){
		Map map = (Map)list.get(0);
		String feetype = StringHelper.null2String(map.get("feetype"));//费用类型
		String businestrain = StringHelper.null2String(map.get("businestrain"));//出差/外训
		String businessreqno = StringHelper.null2String(map.get("businessreqno"));//出差申请
		String outtrainreqno = StringHelper.null2String(map.get("outtrainreqno"));//外训申请
		String flowno = StringHelper.null2String(map.get("flowno"));//暂借款申请单号

		if(feetype.equals("40285a904931f62b01495059a83228fa")) //如果费用类型为出差培训类
		{
			if(businestrain.equals("40285a90495b4eb001495ebc78d4090d")) //如果关联的是出差单
			{
				String upsql = "update uf_hr_businesstrip set zjkmark = '40285a8f489c17ce0148ba6c7e7d696b',zjkreq = '"+requestid+"' where requestid = '"+businessreqno+"' ";
				baseJdbc.update(upsql);
            }
			else //如果关联的是外训申请单
			{
				String upsql = "update uf_hr_outlesson  set jkmark = '40285a8f489c17ce0148ba6c7e7d696b',jkreq = '"+requestid+"' where requestid = '"+outtrainreqno+"' ";
				baseJdbc.update(upsql);
			}
		}
	  }//if end
 } 
 }



