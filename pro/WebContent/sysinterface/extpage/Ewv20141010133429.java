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

 public class Ewv20141010133429 extends EweaverExecutorBase{ 

 
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
	String sql = "select objname,jobno,dept,startdate,enddate,lessoncount,reqman,reqdate,reqdept from uf_hr_certificates where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
       //循环数据
	if(list.size()>0){
		Map map = (Map)list.get(0);		
		String objname = StringHelper.null2String(map.get("objname"));
		String jobno = StringHelper.null2String(map.get("jobno"));
		String objdept = StringHelper.null2String(map.get("dept"));
		String startdate = StringHelper.null2String(map.get("startdate"));
		String enddate = StringHelper.null2String(map.get("enddate"));
		String money = StringHelper.null2String(map.get("lessoncount"));
		String reqman = StringHelper.null2String(map.get("reqman"));
		String reqdate = StringHelper.null2String(map.get("reqdate"));
		String reqdept = StringHelper.null2String(map.get("reqdept"));
		String cardtype = "40285a8f489c17ce0148bf2a545f0b22";
		String certificates = requestid;

		StringBuffer buffer = new StringBuffer(512);
		//String newrequestid = IDGernerator.getUnquieID();
		buffer.append("insert into uf_hr_renege")
		.append("(id,requestid,objname,jobno,objdept,startdate,enddate,money,renegemoney,reqman,reqdate,reqdept,cardtype,certificates) values").append("('").append(IDGernerator.getUnquieID()).
		append("',").append("'").append("$ewrequestid$").append("',");

		buffer.append("'").append(objname).append("',");
		buffer.append("'").append(jobno).append("',");
		buffer.append("'").append(objdept).append("',");
		buffer.append("'").append(startdate).append("',");
		buffer.append("'").append(enddate).append("',");
		buffer.append("'").append(money).append("',");
		buffer.append("'").append(money).append("',");
		buffer.append("'").append(reqman).append("',");
		buffer.append("'").append(reqdate).append("',");
		buffer.append("'").append(reqdept).append("',");
		buffer.append("'").append(cardtype).append("',");
		buffer.append("'").append(certificates).append("')");

		FormBase formBase = new FormBase();
		String categoryid = "40285a8f489c17ce0148bf4a69c40cc9";
		//创建formbase
		formBase.setCreatedate(DateHelper.getCurrentDate());
		formBase.setCreatetime(DateHelper.getCurrentTime());
		formBase.setCreator(StringHelper.null2String(reqman));
		formBase.setCategoryid(categoryid);
		formBase.setIsdelete(0);
		FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
		formBaseService.createFormBase(formBase);
		String insertSql = buffer.toString();
		insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
		baseJdbc.update(insertSql);
		PermissionTool permissionTool = new PermissionTool();
		permissionTool.addPermission(categoryid,formBase.getId(), "uf_hr_renege");
		
		}
        
	}
 } 



