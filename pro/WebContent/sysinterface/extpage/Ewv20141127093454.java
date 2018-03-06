package com.eweaver.sysinterface.extclass; 
 
import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
public class Ewv20141127093454 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 


	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select sdate,stime,edate,etime,flowno,days,reqdate from uf_hr_outlesson where requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String sdate = StringHelper.null2String(map.get("sdate"));//开始日期
		sdate = sdate.replace("-", "");
		String stime = StringHelper.null2String(map.get("stime"));//开始时间
		stime = stime.replace(":", "");
		String edate = StringHelper.null2String(map.get("edate"));//结束日期
		edate = edate.replace("-", "");
		String etime = StringHelper.null2String(map.get("etime"));//结束时间
		etime = etime.replace(":", "");
		String flowno = StringHelper.null2String(map.get("flowno"));//流程单号
		String days = StringHelper.null2String(map.get("days"));//天数
		//int nums = Integer.parseInt(days)*8;//时数
		String nowdate = StringHelper.null2String(map.get("reqdate"));//申请日期
		nowdate = nowdate.split(" ")[0];
		nowdate = nowdate.replace("-", "");
		sql = "select id,sapno from uf_hr_outlessonsub where requestid='"+requestid+"'";
		List sublist = baseJdbc.executeSqlForList(sql);
		if(sublist.size()>0){
			for(int i=0;i<sublist.size();i++){
				Map submap = (Map)sublist.get(i);
				String theid = StringHelper.null2String(submap.get("id"));//子表ID
				String sapno = StringHelper.null2String(submap.get("sapno"));//员工SAP编号
				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT2002_AT_CREATE";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapno);
				function.getImportParameterList().setValue("AWART","2010");
				//function.getImportParameterList().setValue("ANZHL",Integer.toString(nums));
				function.getImportParameterList().setValue("BEGDA",sdate);
				function.getImportParameterList().setValue("BEGUZ",stime);
				function.getImportParameterList().setValue("ENDDA",edate);
				function.getImportParameterList().setValue("ENDUZ",etime);
				function.getImportParameterList().setValue("ZZNUM",flowno);
				function.getImportParameterList().setValue("ZZADA",nowdate);

				try {
					function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

				//返回值
				String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
				String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
				String upsql="update uf_hr_outlessonsub set message='"+MESSAGE+"',msgtype='"+MSGTY+"' where id='"+theid+"'";
				baseJdbc.update(upsql);
			}
			
		}
	}
} 
}


