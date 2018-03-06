package com.eweaver.sysinterface.extclass; 
 
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.eweaver.app.configsap.SapSync;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import com.sap.conn.jco.JCoTable;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.BaseContext;
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.app.configsap.ConfigSapAction;
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
 public class Ewv20141129093347 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
      String requestid = this.requestid;//当前流程requestid 
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select flowtype,leaveflowno,businessflowno,outtrainflowno,overworkno,changeworkno,alterworkno,msgty from uf_hr_expdatacancel  where requestid = '"+requestid+"'  ";
	List list = baseJdbc.executeSqlForList(sql);
   String upsql="";
   String msgty ="";
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String flowtype = StringHelper.null2String(map.get("flowtype"));//流程类型
        String leaveflowno = StringHelper.null2String(map.get("leaveflowno"));//请假申请流程requestid
   	  	String businessflowno = StringHelper.null2String(map.get("businessflowno"));//出差申请流程requestid
     	String outtrainflowno = StringHelper.null2String(map.get("outtrainflowno"));//外训申请流程requestid
      	String overworkno = StringHelper.null2String(map.get("overworkno"));//加班申请流程requestid
		String changeworkno = StringHelper.null2String(map.get("changeworkno"));//换班申请流程requestid
		String alterworkno = StringHelper.null2String(map.get("alterworkno"));//改班申请流程requestid
		
		if(flowtype.equals("40285a9049ade1710149b238a3911163"))//请假
		{
			sql= "select msgty from uf_hr_vacation  where requestid = '"+leaveflowno+"'  ";
			list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				map = (Map)list.get(0);
				msgty = StringHelper.null2String(map.get("msgty"));
				if(!msgty.equals("I"))
				{
					upsql="update uf_hr_vacation set isvalided='40288098276fc2120127704884290211' where requestid='"+leaveflowno+"'";
					baseJdbc.update(upsql);
					upsql="update uf_hr_expdatacancel set msgty='不回写' where requestid='"+requestid+"'";
					baseJdbc.update(upsql);
				}
				
				else{
				
					SapSync s = new SapSync();
					System.out.println("aaaa啊啊啊啊啊啊啊啊啊啊啊啊");
					try {
						s.syncSap("40285a9049c0b9570149c6f246882f4d",requestid);
						sql= "select msgty from uf_hr_expdatacancel  where requestid = '"+requestid+"'  ";
						list = baseJdbc.executeSqlForList(sql);
						if(list.size()>0){
							map = (Map)list.get(0);
							msgty = StringHelper.null2String(map.get("msgty"));
							if(!msgty.equals("E"))
							{
								upsql="update uf_hr_vacation set isvalided='40288098276fc2120127704884290211' where requestid='"+leaveflowno+"'";
								baseJdbc.update(upsql);
							}
						}
						} catch (Exception e) {
						e.printStackTrace();
						}
				}
			}
		}
		else if(flowtype.equals("40285a9049ade1710149b238a3911164"))//出差
		{
			sql= "select msgty from uf_hr_businesstrip  where requestid = '"+businessflowno+"'  ";
			list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0){
				map = (Map)list.get(0);
				msgty = StringHelper.null2String(map.get("msgty"));
				if(!msgty.equals("I"))
					{
						upsql="update uf_hr_businesstrip set isvalided='40288098276fc2120127704884290211' where requestid='"+businessflowno+"'";
						baseJdbc.update(upsql);
						upsql="update uf_hr_expdatacancel set msgty='不回写' where requestid='"+requestid+"'";
						baseJdbc.update(upsql);
					}
				
				else{
					SapSync s = new SapSync();
					try {
						s.syncSap("40285a9049c0b9570149c6f0e23e2f44",requestid);
						sql= "select msgty from uf_hr_expdatacancel  where requestid = '"+requestid+"'";
						list = baseJdbc.executeSqlForList(sql);
						if(list.size()>0){
							map = (Map)list.get(0);
							msgty = StringHelper.null2String(map.get("msgty"));
							if(msgty.equals("I"))
							{
								upsql="update uf_hr_businesstrip set isvalided='40288098276fc2120127704884290211' where requestid='"+businessflowno+"'";
								baseJdbc.update(upsql);
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
				
					}
				}
			}
		}
      	else if(flowtype.equals("40285a8d4b7b329a014b81cc497f36bc"))//加班
		{
			
			upsql="update uf_hr_overtime  set valid='40288098276fc2120127704884290211' where requestid='"+overworkno+"'";
			baseJdbc.update(upsql);
			upsql="update uf_hr_expdatacancel set msgty='不回写' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
		}
		else if(flowtype.equals("40285a8d4b7b329a014b81cc497f36be"))//换班
		{
			
			upsql="update uf_hr_changeclass set isvalid='40288098276fc2120127704884290211' where requestid='"+changeworkno+"'";
			baseJdbc.update(upsql);
			upsql="update uf_hr_expdatacancel set msgty='不回写' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
		}
		else if(flowtype.equals("40285a8d4b7b329a014b81cc497f36bd"))//改班
		{
			
			upsql="update uf_hr_alterclass set isvalid='40288098276fc2120127704884290211' where requestid='"+alterworkno+"'";
			baseJdbc.update(upsql);
			upsql="update uf_hr_expdatacancel set msgty='不回写' where requestid='"+requestid+"'";
			baseJdbc.update(upsql);
		}
		else//外训
		{
			
			sql="select outtrainflowno,no,flag2 from uf_hr_expdatacancel where requestid='"+requestid+"'";
			String flowno="";//流程号
			String flow="";//单号
			String flag="";
            list = baseJdbc.executeSqlForList(sql);
			if(list.size()>0)
			{
				for(int i = 0;i<list.size();i++)
				{
					Map map1 = (Map)list.get(i);
					flowno=StringHelper.null2String(map1.get("outtrainflowno"));//流程号
					flow=StringHelper.null2String(map1.get("no"));//单号
					flag=StringHelper.null2String(map1.get("flag2"));//标识2
				}
			}

		
		 sql ="select t.requestid as requestid,a.exttextfield15 as exttextfield15 from uf_hr_outlessonsub t,humres a where a.id=t.objname and  t.requestid='"+flowno+"'"; 
		 list = baseJdbc.executeSqlForList(sql);
		String sapid;
		if(list.size()>0){
			for(int i = 0;i<list.size();i++)
			{
				Map map2 = (Map)list.get(i);
				sapid = StringHelper.null2String(map2.get("exttextfield15"));//SAP员工工号

				//创建SAP对象
				SapConnector sapConnector = new SapConnector();
				String functionName = "ZHR_IT2002_DELETE";
				JCoFunction function = null;
				try {
					function = SapConnector.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
				//插入字段
				function.getImportParameterList().setValue("PERNR",sapid);
				function.getImportParameterList().setValue("AWART",flag);//出勤类型
				function.getImportParameterList().setValue("ZZNUM",flow);//审批单号
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
				System.out.println(MESSAGE);
				System.out.println(MSGTY);
			}
		}
		sql= "select msgty from uf_hr_outtrainsap  where requestid = '"+requestid+"' and (msgty='E' or msgty is null)";
		list = baseJdbc.executeSqlForList(sql);
		if(list.size()==0){
          upsql="update uf_hr_outlesson set isvalided='40288098276fc2120127704884290211' where requestid='"+outtrainflowno+"'";
		        baseJdbc.update(upsql);
		}
		}
	}
 
 
 } 

 }





















