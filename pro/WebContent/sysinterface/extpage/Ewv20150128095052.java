package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20150128095052 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String requestid = this.requestid;//当前流程requestid 
  //删除历史记录
  String delsql = "delete from uf_tr_taxadvanceinfo where requestid='"+requestid+"'";
  baseJdbc.update(delsql);
    String sql = "select a.orderitem,a.paymoney,a.enddate,b.payment,e.paycode,a.orderid,a.imtaxtype,c.objname dhlx,d.objname jbr,b.banktype from uf_tr_taxadvancesub a ,uf_tr_taxadvancemain b left join humres d on b.reqman=d.id left join selectitem c on b.goodstype=c.id left join uf_tr_paydetail e on b.payment=e.id where a.requestid=b.requestid and b.requestid='"+requestid+"'";
    List list = baseJdbc.executeSqlForList(sql);
    if(list.size()>0){
    	for(int i=0;i<list.size();i++){
    		Map map = (Map)list.get(i);
    		String orderitem = StringHelper.null2String(map.get("orderitem"));
    		String paymoney = StringHelper.null2String(map.get("paymoney"));
    		String enddate = StringHelper.null2String(map.get("enddate"));
    		String payment = StringHelper.null2String(map.get("payment"));
    		String orderid = StringHelper.null2String(map.get("orderid"));
    		String imtaxtype = StringHelper.null2String(map.get("imtaxtype"));
    		String dhlx = StringHelper.null2String(map.get("dhlx"));
    		String jbr = StringHelper.null2String(map.get("jbr"));
    		String banktype = StringHelper.null2String(map.get("banktype"));
    		String upsql = "insert into uf_tr_taxadvanceinfo (id,requestid,no,money,todate,payment,conno,therow,thetext,banktype) values "+
    		"(sys_guid(),'"+requestid+"',to_number('"+(i+1)+"'),to_number('"+paymoney+"'),'"+enddate+"','"+payment+"','"+orderid+"','"+orderitem+"','"+(imtaxtype+dhlx+jbr)+"','"+banktype+"')";
    		baseJdbc.update(upsql);
    	}
    }

} 
}


