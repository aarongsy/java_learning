package com.eweaver.app.autotask; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class deptMove{ 

	public void updateInfo () {
	    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select movedate,result,objname,inonedept,intwodept,inunit,indept,togroup,togroupsub from uf_hr_deptmove where to_date(movedate,'yyyy-mm-dd') =(select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) and 1=(select isfinished from requestbase where id = requestid) and 1<>(select isdelete from requestbase where id = requestid)";
	    List list = baseJdbc.executeSqlForList(sql);
	    if(list.size()>0){
			for(int i = 0;i<list.size();i++)
			{
				Map map = (Map)list.get(i);
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

}

