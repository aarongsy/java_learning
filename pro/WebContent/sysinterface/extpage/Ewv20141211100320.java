package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
 public class Ewv20141211100320 extends EweaverExecutorBase{ 

 
 @Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    String sql = "select hours,classhour,objname,startdate,reqtype,gsreq from uf_hr_vacation where requestid='"+requestid+"'";
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		int hours = NumberHelper.string2Int(StringHelper.null2String(map.get("hours")));
		int classhour = NumberHelper.string2Int(StringHelper.null2String(map.get("classhour")));
		String reqtype =  StringHelper.null2String(map.get("reqtype"));
		//更新排班表
		if(classhour==12 && hours<=4){//12小时的班且请假时数<=4
			String objname = StringHelper.null2String(map.get("objname"));
			String startdate = StringHelper.null2String(map.get("startdate"));
			String upsql = "update uf_hr_classplan set vacation=NVL(vacation,0)-to_number('"+Integer.toString(hours)+"') where objname='"+objname+"' and thedate='"+startdate+"'";
			baseJdbc.update(upsql);
		}
		//更新工伤假
		if(reqtype.equals("40285a904931f62b0149368f72ae1e02")){
			String reqid = StringHelper.null2String(map.get("gsreq"));
			String upsql2 = "update uf_hr_jobinjury set nums = NVL(nums,0)-to_number('"+hours+"') where requestid='"+reqid+"'";
    		baseJdbc.update(upsql2);
		}
	}
} 

}



