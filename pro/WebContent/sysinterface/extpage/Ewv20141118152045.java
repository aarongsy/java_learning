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

public class Ewv20141118152045 extends EweaverExecutorBase{

	@Override
	public void doExecute(Param params) {
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
	     	//取得报价明细数据
	     	String grpsql = "select id from uf_tr_details where requestid ='"+requestid+"'";
	     	
	     	List listdt = baseJdbc.executeSqlForList(grpsql);
	        if(listdt.size()>0){
	        	for(int i=0;i<listdt.size();i++){
		        	Map inmap = (Map) listdt.get(i);
		        	String groupid = StringHelper.null2String(inmap.get("id"));//取得项目
		        	String prisql = "select * from uf_tr_details where rmbtotal is not null and id='"+groupid+"' order by routes desc,costname desc,arktype desc,partitions desc,rmbtotal asc";
		        	List pricelist = baseJdbc.executeSqlForList(prisql);
		        	if(pricelist.size()>0){
		        		for(int j=0;j<pricelist.size();j++){
		        			Map primap = (Map) pricelist.get(j);
		        			String id = StringHelper.null2String(primap.get("id"));//取得要更改为启用的价格
		        			System.out.println(id);
		        			String upprisql = "";
		        			if(j<=2){
			        			upprisql = "update uf_tr_details set effect='40288098276fc2120127704884290210' where id='"+id+"'";
			        			System.out.println("first:"+upprisql);
			        			baseJdbc.update(upprisql);		
		        			}else{
			        			upprisql = "update uf_tr_details set effect='40288098276fc2120127704884290211' where id='"+id+"'";
			        			System.out.println("second:"+upprisql);
			        			baseJdbc.update(upprisql);				        				
		        			}
		        		}
		        	}
	        	}
	        	
	        }
	}
}





