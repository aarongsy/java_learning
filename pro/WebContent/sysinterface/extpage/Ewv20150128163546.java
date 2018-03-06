package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20150128163546 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  //删除历史记录
  String delsql = "delete from uf_tr_taxsub where requestid='"+requestid+"'";
  baseJdbc.update(delsql);
	String sql = "select materialid,sum(paymoney) total from uf_tr_taxadvancesub where requestid='"+requestid+"' and (imtaxtype='关税' or imtaxtype='倾销税') and upper(NVL(materialid,'0')) not in ('K','A','Y') group by materialid";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String materialid = StringHelper.null2String(map.get("materialid"));
			String total = StringHelper.null2String(map.get("total"));
			String upsql = "insert into uf_tr_taxsub (id,requestid,no,materialno,money) values (sys_guid(),'"+requestid+"',to_number('"+(i+1)+"'),'"+materialid+"',to_number('"+total+"'))";
			baseJdbc.update(upsql);
		}
	}
} 

}


