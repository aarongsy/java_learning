/*
	部门奖惩申请开始提交：更新定额表和定额明细表
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


 public class Ewv20141108170107 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
    // EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	//额度表uf_hr_punrewquota 额度明细表uf_hr_punrewquotasub //部门奖惩uf_hr_punrew
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
   	String sql = "select quotano,usedquo,flowno,jobno,objname,reqtype,pubtype,rewtype,stateflag from uf_hr_punrew where requestid='"+requestid+"'";
	List tlist = baseJdbc.executeSqlForList(sql);
	if(tlist.size()>0){
		Map map = (Map)tlist.get(0);
		String quotano = StringHelper.null2String(map.get("quotano"));//定额表ID
		String flowno = StringHelper.null2String(map.get("flowno"));//申请单号
		String jobno = StringHelper.null2String(map.get("jobno"));//工号
		String objname = StringHelper.null2String(map.get("objname"));//姓名
		String reqtype = StringHelper.null2String(map.get("reqtype"));//类型
		String pubtype = StringHelper.null2String(map.get("pubtype"));//奖惩类型
		String rewtype = StringHelper.null2String(map.get("rewtype"));//奖惩次数
		String usedquo = StringHelper.null2String(map.get("usedquo"));//扣减数		
		String stateflag = StringHelper.null2String(map.get("stateflag"));//状态
      
		String upsql ="";
        if(reqtype.equals("40285a904931f62b01495088b56c2b2c") || reqtype.equals("40285a904931f62b01495088b56c2b2d")  ){ //非安环环保类更新额度表
        
			//更新额度表
			upsql="update uf_hr_punrewquota set usedquota = (usedquota-("+usedquo+")),leftquota = (leftquota+("+usedquo+")) where requestid = '"+quotano+"'";		
			baseJdbc.update(upsql);
			System.out.println("更新额度表"+upsql);
		
			//插入额度明细表
      		upsql = "insert into uf_hr_punrewquotasub (ID,REQUESTID,PUNREWNO,MONTHPUNNO,JOBNO,JOBNAME,REQTYPE,PUBTYPE,REWTYPE,USEDQUO,DIFFQUO) values (sys_guid(),'"+quotano+"','"+requestid+"','','"+jobno+"','"+objname+"','"+reqtype+"','"+pubtype+"','"+rewtype+"','"+usedquo+"','')";
			baseJdbc.update(upsql);
			System.out.println("插入额度明细表"+upsql);
        }
		
		//更新状态为审核
		upsql="update uf_hr_punrew set stateflag = '1' where requestid = '"+requestid+"'";
		baseJdbc.update(upsql);
		System.out.println("更新部门奖惩状态为审核"+upsql);
    }
 } 

 }






