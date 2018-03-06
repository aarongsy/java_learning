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
import com.eweaver.app.configsap.SapSync;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;
import com.eweaver.base.security.util.PermissionTool;
 public class Ewv20141108115034 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
	 String objnum = "";
		String orgid = "";
		String contype ="";
		String startrenew = "";
		String endrenew ="";
        String mainstation="";
		String COMPAREA="";
		String ONEDEPT="";
		String TWODEPT="";
	 SapSync s = new SapSync();
			try {
				s.syncSap("40285a904999a7ad01499cfe50b321e8",requestid);
			} catch (Exception e) {
				e.printStackTrace();
			}
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select t.objnum,h.orgid,t.contype,t.startrenew,t.endrenew,h.mainstation,h.extmrefobjfield7,h.extmrefobjfield8,h.extrefobjfield5 from uf_hr_contract t,humres h where h.id=t.objnum and t.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		 objnum = StringHelper.null2String(map.get("objnum"));
		 orgid = StringHelper.null2String(map.get("orgid"));
		 contype = StringHelper.null2String(map.get("contype"));
		 startrenew = StringHelper.null2String(map.get("startrenew"));
		 endrenew = StringHelper.null2String(map.get("endrenew"));
         mainstation = StringHelper.null2String(map.get("mainstation"));
		 COMPAREA = StringHelper.null2String(map.get("extrefobjfield5"));
		 ONEDEPT = StringHelper.null2String(map.get("extmrefobjfield8"));
		 TWODEPT = StringHelper.null2String(map.get("extmrefobjfield7"));
    }

   	StringBuffer buffer = new StringBuffer(512);
			//String newrequestid = IDGernerator.getUnquieID();
	buffer.append("insert into uf_hr_contractinfo (ID, REQUESTID,objnum,objname,orgid,contacttype,constdate,conenddate,mainstation, COMPAREA, ONEDEPT, TWODEPT)  values ").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

   buffer.append("'").append(objnum).append("',");//员工工号
   buffer.append("'").append(objnum).append("',");//员工姓名
   
   buffer.append("'").append(orgid).append("',");//所属部门
   buffer.append("'").append(contype).append("',");//合同类型
   buffer.append("'").append(startrenew).append("',");//开始日期
   buffer.append("'").append(endrenew).append("',");//结束日期
   buffer.append("'").append(mainstation).append("',");//岗位
    buffer.append("'").append(COMPAREA).append("',");//厂区别
	buffer.append("'").append(ONEDEPT).append("',");//一级部门
	buffer.append("'").append(TWODEPT).append("')");//二级部门
   
   
   FormBase formBase = new FormBase();
   String categoryid = "40285a90497eab15014988d27d585135";
   //创建formbase
   //formBase.setCreatedate(DateHelper.getCurrentDate());
   //formBase.setCreatetime(DateHelper.getCurrentTime());
   //formBase.setCreator(StringHelper.null2String(userId));
   formBase.setCategoryid(categoryid);
   formBase.setIsdelete(0);
   FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
   formBaseService.createFormBase(formBase);
   String insertSql = buffer.toString();
   insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
   baseJdbc.update(insertSql);
   PermissionTool permissionTool = new PermissionTool();
   permissionTool.addPermission(categoryid,formBase.getId(), "uf_hr_contractinfo");	
 } 

 }










