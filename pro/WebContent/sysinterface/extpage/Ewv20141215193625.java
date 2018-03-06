package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141215193625 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    String sql = "select a.objname,a.olddate,a.oldno,a.newno,c.classname newname,c.whours from uf_hr_alterclasssub a  left join uf_hr_classinfo c on a.newno=c.requestid inner join uf_hr_alterclass d on a.requestid=d.requestid and d.msgtype='I' where a.requestid='"+requestid+"'";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List list = baseJdbc.executeSqlForList(sql);
    if(list.size()>0){
    	for(int i=0;i<list.size();i++){
    		Map map = (Map)list.get(i);
    		String objname = StringHelper.null2String(map.get("objname"));
    		String thedate = StringHelper.null2String(map.get("olddate"));
    		String oldno = StringHelper.null2String(map.get("oldno"));
			String oname = StringHelper.null2String(map.get("oname"));
    		String newno = StringHelper.null2String(map.get("newno"));
			String newname = StringHelper.null2String(map.get("newname"));
			String whours = StringHelper.null2String(map.get("whours"));
    		String upsql = "update uf_hr_classplan set classname='"+newname+"',classno='"+newno+"',hours=to_number('"+whours+"') where objname='"+objname+"' and thedate='"+thedate+"' and classno='"+oldno+"'";
    		baseJdbc.update(upsql);
    	}
    }

} 
  
}





