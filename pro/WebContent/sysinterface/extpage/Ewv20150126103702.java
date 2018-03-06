package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;

import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.service.FormBaseService;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.humres.base.model.Humres;

public class Ewv20150126103702 extends EweaverExecutorBase {

	@Override
	public void doExecute(Param params) {
	     String requestid = this.requestid;//当前流程requestid 
	     EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
	     String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
	     String issave = params.getParamValueStr("issave");//是否保存 0提交
	     String isundo = params.getParamValueStr("isundo");//是否撤回 1撤回
	     String formid = params.getParamValueStr("formid");//流程关联表单ID 
	     String editmode = params.getParamValueStr("editmode");//编辑模式 
	     String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
	     String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
	     String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 		
	     	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	     	/**
	     	 * 提交操作
	     	 * 1、首先判断该流程为非自提流程
	     	 * 2、更新派车需求单明细中对应明细的已装卸数，打是否装卸完成标识，完成记录0，未完成打1
	     	 * 
	     	 */
	     	String inqsql = "select a.isself isself,b.deliverdnum,b.cardetailid from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid and a.isself='40288098276fc2120127704884290211' and a.requestid ='"+requestid+"'";
	        List list = baseJdbc.executeSqlForList(inqsql);
	        if(list.size()>0){
		        Map inmap = (Map) list.get(0);
			    Float deliverdnum = StringHelper.null2String(inmap.get("deliverdnum"))==null?0:Float.parseFloat(StringHelper.null2String(inmap.get("deliverdnum")));
			    String cardetailid = StringHelper.null2String(inmap.get("cardetailid"));
			    String upsql = "update uf_lo_dgcardetail set yetloadnum=nvl(yetloadnum,0)-"+deliverdnum+" where id='"+cardetailid+"'";
			    baseJdbc.update(upsql);		     		
		        String sql1 = "select requestid from uf_lo_dgcardetail where nvl(deliverdnum,0)-nvl(yetloadnum,0)=0 and id='"+cardetailid+"'";
		        List list1 = baseJdbc.executeSqlForList(sql1);
		        	String upsql1 = "";
			        if(list1.size()>0){
			        	upsql1 = "update uf_lo_dgcardetail set xiemark='0' where id='"+cardetailid+"'";
			        }else{
			        	upsql1 = "update uf_lo_dgcardetail set xiemark='1' where id='"+cardetailid+"'";
			        }
			        baseJdbc.update(upsql1);		        
       	
	        }
	}

}



