package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141201115554 extends EweaverExecutorBase{ 


	@Override 
	public void doExecute (Param params) {
	 
	    String requestid = this.requestid;//当前流程requestid 
	    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select entrytype,entryname,onedept,twodept,comtype,entrycom,oaunit,entryno,entrydept from uf_hr_entry where requestid='"+requestid+"'";
	    List list = baseJdbc.executeSqlForList(sql);
	    if(list.size()>0){
	    	Map map = (Map)list.get(0);
	    	String entrytype = StringHelper.null2String(map.get("entrytype"));
	    	if(entrytype.equals("40285a8f489c17ce0148a19c762e16b6")){//公司异动入职
	    		String entryname = StringHelper.null2String(map.get("entryname"));
	    		String onedept = StringHelper.null2String(map.get("onedept"));
	    		String twodept = StringHelper.null2String(map.get("twodept"));
	    		String comtype = StringHelper.null2String(map.get("comtype"));
	    		String entrycom = StringHelper.null2String(map.get("entrycom"));
	    		String oaunit = StringHelper.null2String(map.get("oaunit"));
	    		String entryno = StringHelper.null2String(map.get("entryno"));
	    		String entrydept = StringHelper.null2String(map.get("entrydept"));
	    		sql = "update humres set orgid='"+entrydept+"',orgids='"+entrydept+"',mainstation='"+oaunit+"',station='"+oaunit+"',extmrefobjfield8='"+onedept+"',extmrefobjfield7='"+twodept+"',extmrefobjfield9='"+
	    		entrycom+"',extrefobjfield10='"+entrycom+"',objno='"+entryno+"',extrefobjfield5='"+comtype+"' where id='"+entryname+"'";
	    		baseJdbc.update(sql);
	    	}
	    }
	
	} 

}

