package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141107120732 extends EweaverExecutorBase{ 


	@Override 
	public void doExecute (Param params) {
	 
	    String requestid = this.requestid;//当前流程requestid 
	    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select result,objname,inonedept,intwodept,inunit,indept,togroup,togroupsub from uf_hr_deptmove where requestid='"+requestid+"'";
	    List list = baseJdbc.executeSqlForList(sql);
	    if(list.size()>0){
	    	Map map = (Map)list.get(0);
	    	String entrytype = StringHelper.null2String(map.get("result"));
	    	if(entrytype.equals("40285a8f489c17ce0148fdd2c91a2f36")){//异动结果
	    		String objname = StringHelper.null2String(map.get("objname"));
	    		String inonedept = StringHelper.null2String(map.get("inonedept"));
	    		String intwodept = StringHelper.null2String(map.get("intwodept"));
	    		String inunit = StringHelper.null2String(map.get("inunit"));
	    		String indept = StringHelper.null2String(map.get("indept"));
	    		String togroup = StringHelper.null2String(map.get("togroup"));
	    		String togroupsub = StringHelper.null2String(map.get("togroupsub"));
	    		sql = "update humres set orgid='"+indept+"',orgids='"+indept+"',mainstation='"+inunit+"',station='"+inunit+"',extmrefobjfield8='"+
					inonedept+"',extmrefobjfield7='"+intwodept+"',extselectitemfield11='"+togroup+"',extselectitemfield12='"+togroupsub+"' where id='"+objname+"'";
	    		baseJdbc.update(sql);
	    	}
	    }
	
	} 

}