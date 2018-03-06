package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import org.hibernate.SessionFactory;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.label.service.LabelService;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141202085436 extends EweaverExecutorBase{ 


	@Override 
	public void doExecute (Param params) {
	 
	    String requestid = this.requestid;//当前流程requestid 
	    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select leavepattern,objname from uf_hr_leave where requestid='"+requestid+"'";
	    List list = baseJdbc.executeSqlForList(sql);
	    if(list.size()>0){
	    	Map map = (Map)list.get(0);
	    	String leavepattern = StringHelper.null2String(map.get("leavepattern"));
	    	if(!leavepattern.equals("40285a8f490d114a0149127eea5b419f")){//离职形态不为跨企业调出
	    		String objname = StringHelper.null2String(map.get("objname"));
	    		sql = "update humres set extselectitemfield14='40288098276fc2120127704884290210' where id='"+objname+"'";
	    		baseJdbc.update(sql);
	    	}
	    }
	
	} 

}



