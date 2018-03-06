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
 public class Ewv20141230091321 extends EweaverExecutorBase{ 

 
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
	String sql = "select t.outtarinno,t.reqappno from uf_hr_outtrainexpenses t where t.requestid='"+requestid+"' ";
	List list = baseJdbc.executeSqlForList(sql);
       //循环数据
	if(list.size()>0){
		Map map = (Map)list.get(0);		
		String outtarinno = StringHelper.null2String(map.get("outtarinno"));
		String reqappno = StringHelper.null2String(map.get("reqappno"));
		String upsql;
		if(reqappno==null||reqappno.equals("null")||reqappno.equals("")||reqappno=="")//无暂借款
		{
			sql="select t.getclassname from uf_hr_outtarinexpdetail t where t.requestid='"+outtarinno+"' group by t.getclassname ";
			list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0)
			{
				for(int i=0;i<list.size();i++)
				{
					Map map1 = (Map)list.get(i);	
					String name= StringHelper.null2String(map1.get("getclassname"));
					upsql="update uf_hr_outlessonsub set mark='40285a8f489c17ce0148ba60c731687e',wxreq='"+requestid+"' where requestid='"+outtarinno+"' and objname='"+name+"'";
					baseJdbc.update(upsql);					
				}
			}
			sql="select mark from  uf_hr_outlessonsub where requestid='"+outtarinno+"' and mark='40285a8f489c17ce0148ba60c731687c'";
			list = baseJdbc.executeSqlForList(sql);
			if(list.size()==0)
			{
				upsql="update uf_hr_outlesson a set a.bxmark='40285a8f489c17ce0148ba60c731687e' where a.requestid='"+outtarinno+"'";
				baseJdbc.update(upsql);
			}
		}
		else//有暂借款（子表现改为不报销，报销人员再次修改）
		{
			upsql="update uf_hr_outlessonsub set mark='40285a8f489c17ce0148ba6b51766962' where requestid='"+outtarinno+"'";//不报销
			baseJdbc.update(upsql);	
			sql="select t.getclassname from uf_hr_outtarinexpdetail t where t.requestid='"+outtarinno+"' group by t.getclassname ";
			list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0)
			{
				for(int i=0;i<list.size();i++)
				{
					Map map1 = (Map)list.get(i);	
					String name= StringHelper.null2String(map1.get("getclassname"));
					upsql="update uf_hr_outlessonsub set mark='40285a8f489c17ce0148ba60c731687e',wxreq='"+requestid+"' where requestid='"+outtarinno+"' and objname='"+name+"'";//已报销
					baseJdbc.update(upsql);					
				}
			}
			upsql="update uf_hr_outlesson a set a.bxmark='40285a8f489c17ce0148ba60c731687e',a.jkmark='40285a8f489c17ce0148ba6c7e7e696d' where a.requestid='"+outtarinno+"'";//主表报销标识,主表清账标示
			baseJdbc.update(upsql);
		}
		
		}
 
 
 } 

 }

