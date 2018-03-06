package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;
import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 


public class Ewv20150207112833 extends EweaverExecutorBase{

	@Override
	public void doExecute(Param params) {
		// TODO Auto-generated method stub
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
	     	//取得提入单主表数据
	     	String sql = "select * from uf_lo_ladingmain where requestid ='"+requestid+"'";
	        List list = baseJdbc.executeSqlForList(sql);
	        if(list.size()>0){ 
	        	Map inmap = (Map) list.get(0);
	        	String loadingno = StringHelper.null2String(inmap.get("loadingno"));//装卸计划编号  reqno
	        	String drivername = StringHelper.null2String(inmap.get("drivername"));//司机姓名 drivername
	        	String cellphone = StringHelper.null2String(inmap.get("cellphone"));//联系电话 cellphone
	        	String carno = StringHelper.null2String(inmap.get("carno"));//车牌号
	        	String trailerno = StringHelper.null2String(inmap.get("trailerno"));//挂车号
	        	String loanno = StringHelper.null2String(inmap.get("loanno"));//货柜号
	        	String signno = StringHelper.null2String(inmap.get("signno"));//封签号
	        	
	        	String upsql="update uf_lo_loadplan set drivername='"+drivername+"',cellphone='"+cellphone+"',carno='"+carno+"',trailerno='"+trailerno+"',loanno='"+loanno+"',signno='"+signno+"' where reqno='"+loadingno+"'";
	        	baseJdbc.update(upsql);//更新装卸计划信息
	        	String upsql1="update uf_lo_ladingmain set drivername='"+drivername+"',cellphone='"+cellphone+"',carno='"+carno+"',trailerno='"+trailerno+"',loanno='"+loanno+"',signno='"+signno+"' where loadingno='"+loadingno+"' and requestid!='"+requestid+"'";
	        	baseJdbc.update(upsql1);//更新该装卸计划对应其它的提入单信息
  	

	        } 
	}



}
