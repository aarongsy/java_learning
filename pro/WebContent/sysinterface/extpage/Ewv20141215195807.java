package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141215195807 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    String sql = "select a.objname,a.olddate,a.oldclass,b.classname oldname,a.pobjname,a.poldclass,c.classname poldname from uf_hr_changeclass a left join uf_hr_classinfo b on a.oldclass=b.requestid left join uf_hr_classinfo c on a.poldclass=c.requestid where a.requestid='"+requestid+"'";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List list = baseJdbc.executeSqlForList(sql);
    if(list.size()>0){
    	for(int i=0;i<list.size();i++){
    		Map map = (Map)list.get(i);
    		String objname = StringHelper.null2String(map.get("objname"));
    		String thedate = StringHelper.null2String(map.get("olddate"));
    		String oldclass = StringHelper.null2String(map.get("oldclass"));
			String oldname = StringHelper.null2String(map.get("oldname"));
    		String pobjname = StringHelper.null2String(map.get("pobjname"));
    		String poldclass = StringHelper.null2String(map.get("poldclass"));
			String poldname = StringHelper.null2String(map.get("poldname"));
    		String upsql = "update uf_hr_classplan set classno='"+poldclass+"',classname='"+poldname+"' where objname='"+objname+"' and thedate='"+thedate+"'";
    		baseJdbc.update(upsql);
    		upsql = "update uf_hr_classplan set classno='"+oldclass+"',classname='"+oldname+"' where objname='"+pobjname+"' and thedate='"+thedate+"'";
    		baseJdbc.update(upsql);
    	}
    }

} 

}



