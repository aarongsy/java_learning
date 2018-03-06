package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141226095524 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select hours,reqtype,gsreq from uf_hr_vacation where requestid='"+requestid+"'";
    List list = baseJdbc.executeSqlForList(sql);
    if(list.size()>0){
    	Map map = (Map)list.get(0);
    	String reqtype = StringHelper.null2String(map.get("reqtype"));
    	if(reqtype.equals("40285a904931f62b0149368f72ae1e02")){
    		String hours = StringHelper.null2String(map.get("hours"));
    		String reqid = StringHelper.null2String(map.get("gsreq"));
    		String upsql = "update uf_hr_jobinjury set nums = NVL(nums,0)+to_number('"+hours+"') where requestid='"+reqid+"'";
    		baseJdbc.update(upsql);
    	}
    }
} 

}


