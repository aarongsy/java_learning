package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;

import com.eweaver.base.*; 
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.app.sap.product.*;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.humres.base.service.HumresService;
import com.eweaver.workflow.form.service.FormBaseService;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.humres.base.model.Humres;

public class Ewv20141224143024 extends EweaverExecutorBase {

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
			DataService ds = new DataService();
	     	String sql = "select * from uf_lo_excepcover where requestid ='"+requestid+"'";
	        List list = baseJdbc.executeSqlForList(sql);
	        if(list.size()>0){
		        Map inmap = (Map) list.get(0);
			    String billtype = StringHelper.null2String(inmap.get("billtype"));
			    String billno = StringHelper.null2String(inmap.get("billno"));
				//String tablename="";
				//String fieldname="";
				if(billtype.equals("40285a904a6fdaa1014a7701b87d74de")){//交运单
					//tablename="uf_lo_delivery";
					//fieldname="deliveryno";
                  Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG("Z_CCP_DELIVERY_DG");
                  app.saveProduct(billno);
				}else if(billtype.equals("40285a904a6fdaa1014a7701b87d74df")){//销售订单
					//tablename="uf_lo_salesorder";
					//fieldname="salesdocno";
                  Order_Z_CCP_ORDER_DG app = new Order_Z_CCP_ORDER_DG("Z_CCP_ORDER_DG");
                  app.saveOrder(billno);
				}else{
					//tablename="uf_lo_purchase";
					//fieldname="purchaseorder";
                  Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
                  app.savePurchase(billno);
				}
		        //String upsql = "update "+tablename+" set covermark='1' where "+fieldname+"='"+billno+"'";
		        //baseJdbc.update(upsql);
	        }
	        /*
	         * 以后再增加自动同步操作
	         */
	}

}


