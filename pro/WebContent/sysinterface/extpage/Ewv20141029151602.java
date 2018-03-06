package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141029151602 extends EweaverExecutorBase{ 

 
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
	 String sql = "select canceltype from uf_hr_businesstrip  where requestid='"+field1+"'";
	 List list = baseJdbc.executeSqlForList(sql);
	 if(list.size()>0){
	 for(int s=0;s<list.size();s++){
		Map map = (Map)list.get(s);
		String canceltype = StringHelper.null2String(map.get("canceltype"));

		//String lysl = StringHelper.null2String(map.get("lysl"));

		String upsql="update uf_hr_businesstrip set canceltype='40285a8f489c17ce0148ba60c731687d' where requestid = '"+field1+"'";
		baseJdbc.update(upsql);
	}//for end
	}//if end
 
 
 } 

 }

