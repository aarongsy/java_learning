package com.eweaver.sysinterface.extclass; 
 
 import java.net.*;
 import java.util.*;
 import com.eweaver.base.util.StringHelper;
 import com.eweaver.base.*; 
 import com.eweaver.base.util.*;
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 import com.eweaver.workflow.form.model.FormBase;
 import com.eweaver.workflow.form.service.FormBaseService;
 import com.eweaver.base.security.util.PermissionTool;
 public class Ewv20150115113844 extends EweaverExecutorBase{ 

 
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
	String sql = "select t.reqappflowno,t.colno from uf_oa_gensupcheckdetail t,uf_oa_generalsuppapp c  where t.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
   	//String num="0";
       //循环数据
	if(list.size()>0){
      for(int i=0;i<list.size();i++)
      {
		Map map = (Map)list.get(i);		
		String reqappflowno = StringHelper.null2String(map.get("reqappflowno"));
		String colno = StringHelper.null2String(map.get("colno"));//总务用品申请主表requestid
        //num=StringHelper.null2String(map.get("ordernum"));
		String upsql;
		upsql="update uf_oa_goodsdetailapp a set a.flowstatus='40285a904a4199dc014a5094b47f619a' where a.requestid='"+reqappflowno+"' and no='"+colno+"'";//申请明细表状态
		System.out.println(upsql);
		baseJdbc.update(upsql);
        }
	}
 } 

 }


