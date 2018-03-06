package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;
import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.base.*;

public class Ewv20141107132936 extends EweaverExecutorBase{

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
	     	//取得主表数据
	     	String inqsql = "select * from uf_tr_freightforwarders where requestid ='"+requestid+"'";
	        List list = baseJdbc.executeSqlForList(inqsql);
	        if(list.size()>0){ 
	        	Map inmap = (Map) list.get(0);
	        	String imexptype = StringHelper.null2String(inmap.get("imexptype"));//进出口类别
	        	String ffcode = StringHelper.null2String(inmap.get("ffcode"));//货运代理
	        	String invoicetype = StringHelper.null2String(inmap.get("invoicetype"));//发票类型
	        	String taxtype = StringHelper.null2String(inmap.get("taxtype"));//税别
	        	String vat = StringHelper.null2String(inmap.get("vat"));//增值税率	 
	        	
	        	String[] fflist = ffcode.split(",");
	        	for(int i=0;i<fflist.length;i++){
	        		String priceman = fflist[i].toString();
	        		//循环明细表，并创建至报价明细报表中
	        		String sqldt = "select costname,operateport,cabinettype,danordtype,remarks from uf_tr_ffdetail where requestid = '"+requestid+"'";
	        		List listdt =  baseJdbc.executeSqlForList(sqldt);
	        		if(listdt.size()>0){
	        			for(int j=0;j<listdt.size();j++){
	        				Map dtmap = (Map)listdt.get(j);
	        				String costname = StringHelper.null2String(dtmap.get("costname"));
	        				String operateport = StringHelper.null2String(dtmap.get("operateport"));
	        				String cabinettype = StringHelper.null2String(dtmap.get("cabinettype"));
	        				String danordtype = StringHelper.null2String(dtmap.get("danordtype"));
	        				String remarks = StringHelper.null2String(dtmap.get("remarks"));
//	        				String id = IDGernerator.getUnquieID();
	        				String inertsql = "insert into uf_tr_ffpricedetail(id,requestid,priceman,costname,operateport,cabinettype,danordtype,remarks) " +
	        						"values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+priceman+"','"+costname+"','"+operateport+"','"+cabinettype+"','"+danordtype+"','"+remarks+"')";
	        				baseJdbc.update(inertsql);
	        			}
	        		}
	        	}
	        	
	        	

	        } 
	}
}
