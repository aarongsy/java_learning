package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141028162517 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
     String issave = params.getParamValueStr("issave");//是否保存 
     String isundo = params.getParamValueStr("isundo");//是否撤回 
     String formid = params.getParamValueStr("formid");//流程关联表单ID 
     String editmode = params.getParamValueStr("editmode");//编辑模式 
     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 


     String field1 = params.getParamValueStr("TRIPNO");//获取表单中的字段值,字段名参数要大写
  
     BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
     String upflowtypesql = "update uf_hr_tripexpense  set flowtype = '40285a8f489c17ce0148a12871bb0d9b' where requestid = '"+requestid+"'";
	 baseJdbc.update(upflowtypesql);
	 String sql = "select a.needjk as needjk,a.requestid as requestid  from uf_hr_businesstrip a,uf_hr_tripexpense b  where (a.requestid = b.tripno or a.requestid = b.tripno2 or a.requestid = b.tripno3)   and b.requestid='"+requestid+"'";
	 List list = baseJdbc.executeSqlForList(sql);
	 if(list.size()>0){
	 for(int s=0;s<list.size();s++){
		Map map = (Map)list.get(s);
		String tripid = StringHelper.null2String(map.get("requestid"));//出差申请requestid
		String needjk = StringHelper.null2String(map.get("needjk"));//是否需要暂借款标志
        String upsql="";
		if(needjk.equals("40288098276fc2120127704884290210"))
		{//如果该申请单需要暂借款
			upsql="update uf_hr_businesstrip set canceltype='40285a8f489c17ce0148ba60c731687e',zjkmark ='40285a8f489c17ce0148ba6c7e7e696d' where requestid = '"+tripid+"'";
			
		}
		else
		{
			upsql="update uf_hr_businesstrip set canceltype='40285a8f489c17ce0148ba60c731687e' where requestid = '"+tripid+"'";
			
		}
		baseJdbc.update(upsql);
	}//for end
	}//if end
 } 

 }





