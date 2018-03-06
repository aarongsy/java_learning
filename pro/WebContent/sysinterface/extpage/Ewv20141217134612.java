package com.eweaver.sysinterface.extclass; 
 
import java.util.List;
import java.util.Map;

import com.eweaver.app.configsap.ConfigSapAction;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
public class Ewv20141217134612 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
    String requestid = this.requestid;//当前流程requestid 
    String sql = "select reqtype,unusual from uf_hr_brushcard where requestid='"+requestid+"'";
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String id="";
    List list = baseJdbc.executeSqlForList(sql);
    if(list.size()>0){
    	Map map = (Map)list.get(0);
    	String reqtype = StringHelper.null2String(map.get("reqtype"));
        String unusual = StringHelper.null2String(map.get("unusual"));
    	if(reqtype.equals("297e55a64ac856c4014ac85925a00004") || (reqtype.equals("297e55a649a1dc720149a21ffa3c00e2") && unusual.indexOf("旷工")!=-1 )){//补卡
    		id = "40285a8d4aff85d1014b057ac36a6a0b"; //无异常数据补卡
    	}
      	if(reqtype.equals("297e55a649a1dc720149a21ffa3c00e2") && (unusual.indexOf("早退")!=-1  || unusual.indexOf("迟到")!=-1)  ){//补卡
    		id = "40285a8d4aff85d1014b0597279b6aec"; //异常数据补卡
    	}
    	if(reqtype.equals("297e55a649a1dc720149a21ffa3c00e3")){//改卡
    		id = "297e55a649a2e3aa0149a3842f8a0364";
    	}
        if(reqtype.equals("297e55a64ac856c4014ac85925a00005")){//删卡
    		id = "297e55a64accb136014acd35aba701c4";
    	}
    	if(!id.equals("")){
    		ConfigSapAction c = new ConfigSapAction();
    		try {
    			c.syncSap(id, requestid);
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    }


} 

}






