package com.eweaver.sysinterface.extclass; 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20140925161140 extends EweaverExecutorBase{ 

 
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
     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select entrytype from uf_hr_entry where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if (list.size()>0)
	{
		Map map = (Map)list.get(0);
		String entrytype = StringHelper.null2String(map.get("entrytype"));
		if (entrytype.equals("40285a8f489c17ce0148a19c762e16b5"))
		{
			sql = "select reqid from uf_hr_entrysub where requestid='"+requestid+"'";
			List list2 = baseJdbc.executeSqlForList(sql);
			if(list2.size()>0){
				for(int s=0;s<list2.size();s++){
					Map map2 = (Map)list2.get(s);
					String reqid = StringHelper.null2String(map2.get("reqid"));
					String upsql="update uf_hr_talentpool set rqtype='40285a8f489c17ce0148a12871bb0d9a',rqreqid='"+requestid+"' where requestid='"+reqid+"'";
					baseJdbc.update(upsql);
				}//for end
			}//if end		
		}
	}
 } 
 }



