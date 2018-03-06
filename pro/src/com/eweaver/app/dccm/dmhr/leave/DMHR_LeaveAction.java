package com.eweaver.app.dccm.dmhr.leave;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import com.eweaver.base.util.StringHelper;
import com.eweaver.app.configsap.SapConnector_EN;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoTable;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;

public class DMHR_LeaveAction {
  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  DataService dataService = new DataService();
  DataService ds = new DataService();

  public String LeaveAppToSAP(String requestid,Boolean force) throws Exception {
	String flag = "pass";
	String sql = "select a.flowno,a.empsapid,a.abtysapid,a.abtypetxt,a.thehours,a.sdate,a.stime,a.edate,a.etime,to_char(to_date(a.sdate || ' ' || a.stime,'yyyy-MM-dd HH24:MI:SS'),'yyyyMMdd HH24MI') || '00' sdatetime,to_char(to_date(a.edate || ' ' || a.etime,'yyyy-MM-dd HH24:MI:SS'),'yyyyMMdd HH24MI') || '00' edatetime,to_char(sysdate,'yyyyMMdd') today,a.isinadv,a.valid,a.msgty,a.message from uf_dmhr_leapp a where a.requestid='"+requestid+"'";
	
	List list = baseJdbcDao.executeSqlForList(sql);
	//System.out.println(list.size()+" sql="+sql);
	if ( list.size()>0 ) {
		Map map = (Map)list.get(0);
		String flowno = StringHelper.null2String(map.get("flowno"));
		String empsapid = StringHelper.null2String(map.get("empsapid"));
		String abtysapid = StringHelper.null2String(map.get("abtysapid"));
		String abtypetxt = StringHelper.null2String(map.get("abtypetxt"));
		String thehours = StringHelper.null2String(map.get("thehours"));
		String sdatetime = StringHelper.null2String(map.get("sdatetime"));
		String sdate = sdatetime.split(" ")[0];
		String stime = sdatetime.split(" ")[1];
		String edatetime = StringHelper.null2String(map.get("edatetime"));
		String edate = edatetime.split(" ")[0];
		String etime = edatetime.split(" ")[1];
		String today = StringHelper.null2String(map.get("today"));
		String valid = StringHelper.null2String(map.get("valid"));
		String isinadv = StringHelper.null2String(map.get("isinadv"));
		String message = StringHelper.null2String(map.get("message"));
		String msgty = StringHelper.null2String(map.get("msgty"));
				
			String sapcode = "";		
			String sapnum = "";		
			String delsql = "";
			String upsubsql = "";
			if	( "".equals(abtysapid) || "N/A".equals(abtysapid) )	{
				flag= "to_SAP:OnDuty Leave, no need to SAP!";
				System.out.println("DMHR_LeaveAction.LeaveAppToSAP: 请假申请OnDuty Leave,不执行！requestid="+requestid +" flowno="+flowno+" empsapid="+empsapid );
				return flag;
			}
			if ( ("1000".equals(abtysapid) || "1100".equals(abtysapid) || "1300".equals(abtysapid)) && ( "40288098276fc2120127704884290211".equals(isinadv)) ) {
				sapcode = "4080"; //Transportation Allowance
				sapnum = thehours;
				delsql = "delete uf_dmhr_leappsub where  requestid='"+requestid+"' and (sapcode is null or sapcode!='4080')";
			}else{
				delsql = "delete uf_dmhr_leappsub where  requestid='"+requestid+"'";
			}
			baseJdbcDao.update(delsql);
			
			Integer subexists = 0;
			StringBuffer buffer = new StringBuffer(512);
			if( !"".equals(sapcode) && !"".equals(sapnum)){
				subexists = Integer.valueOf(ds.getSQLValue("select count(1) from uf_dmhr_leappsub where requestid='"+requestid+"' and sapcode='"+sapcode+"' ")); 
				if (subexists==0){
					buffer = new StringBuffer(512);
					buffer.append("insert into uf_dmhr_leappsub ");
					buffer.append("(id,requestid,rowindex,sno,abtycode,abtyname,sapcode,sdate,hours) values ");	
					buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
					buffer.append("'").append(requestid).append("',");
					buffer.append("'000','1',");
					buffer.append("'").append(abtysapid).append("',");
					buffer.append("'").append(abtypetxt).append("',");
					buffer.append("'").append(sapcode).append("',");
					buffer.append("'").append(sdate).append("',");
					buffer.append("'").append(sapnum).append("')");
					upsubsql = buffer.toString();
					baseJdbcDao.update(upsubsql);				
				}else{
					upsubsql = "update uf_dmhr_leappsub set sno='1',abtycode='"+abtysapid+"',abtyname='"+abtypetxt+"',sapcode='"+sapcode+"',sdate='"+sdate+"',hours='"+sapnum+"' where requestid='"+requestid+"' and sapcode='"+sapcode+"'";
					baseJdbcDao.update(upsubsql);
				}
			}
			
			String functionName = "";
			JCoFunction function = null;
			String errorMessage = "";
			if(force || "".equals(msgty) || !"I".equals(msgty) ){
				functionName = "ZHR_IT2001_CREATE_MY";
				function = null;
				try {
					function = SapConnector_EN.getRfcFunction(functionName);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				if (function == null) {
					System.out.println(functionName + " not found in SAP.");
					System.out.println("SAP_RFC中没有此函数!");
					errorMessage = functionName + " not found in SAP.";
				}
				function.getImportParameterList().setValue("PERNR", empsapid);
				function.getImportParameterList().setValue("AWART", abtysapid);
				function.getImportParameterList().setValue("BEGDA", sdate);
				function.getImportParameterList().setValue("BEGUZ", stime);
				function.getImportParameterList().setValue("ENDDA", edate);
				function.getImportParameterList().setValue("ENDUZ", etime);
				function.getImportParameterList().setValue("ZZNUM", flowno);
				function.getImportParameterList().setValue("APPDA", today);
				System.out.println("DMHR_LeaveAction.LeaveAppToSAP: PERNR="+empsapid +" AWART="+abtysapid+" BEGDA="+sdate+" BEGUZ="+stime+" ENDDA="+edate+" ENDUZ="+etime+" ZZNUM="+flowno+" APPDA="+today);
	
				
				JCoTable jcotable = function.getTableParameterList().getTable("IT_2010");
				String subsql = "select * from uf_dmhr_leappsub where requestid = '"+requestid+"'";
				List sublist = baseJdbcDao.executeSqlForList(subsql);
				if ( sublist.size()>0 ) {
					for ( int i=0;i<sublist.size(); i++ ){
						Map submap = (Map)sublist.get(i);
						String subid =  StringHelper.null2String(submap.get("id"));
						//String submsgtype = StringHelper.null2String(submap.get("msgty"));
						//String submessage = StringHelper.null2String(submap.get("message"));
						String subsapcode = StringHelper.null2String(submap.get("sapcode"));
						//String subsdate = StringHelper.null2String(submap.get("sdate"));
						String subhours= StringHelper.null2String(submap.get("hours"));	
						
						jcotable.appendRow();
						jcotable.setValue("DATUM", sdate);
						jcotable.setValue("PERNR", empsapid);
						jcotable.setValue("LGART", subsapcode);
						jcotable.setValue("ANZHL", subhours);
						System.out.println("DMHR_LeaveAction.LeaveAppToSAP: PERNR="+empsapid +" DATUM="+sdate+" LGART="+subsapcode+" ANZHL="+subhours);
					}
				}
				
				try {
					function.execute(SapConnector_EN.getDestination("sanpowersapen"));
					//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
				} catch (JCoException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}	
	
				//返回值
				String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
				String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();		
				String upsql="update uf_dmhr_leapp set message='"+sapmsg+"',msgty='"+sapmsgtype+"' where requestid='"+requestid+"'";
				//System.out.println(upsql);
				baseJdbcDao.update(upsql);
				String subupsql = "update uf_dmhr_leappsub set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"'";
				//System.out.println(subupsql);
				baseJdbcDao.update(subupsql); 
				upsql = "update uf_dmhr_leapp set appdate='"+today+"' where requestid='"+requestid+"'";		
				//System.out.println(upsql);
				baseJdbcDao.update(upsql);
			}else{
				flag= "to_SAP:error:double";
				System.out.println("DMHR_LeaveAction.LeaveAppToSAP: 请假申请抛转重复,不执行！requestid="+requestid +" flowno="+flowno+" empsapid="+empsapid );
			}
		
	}else{ 
		flag= "to_SAP:error:noexist";		
	}
	return flag;
  }	  
  
  public String GetLeftQuota(String empsapid,String begindate,String enddate,String quotasapid ) throws Exception {
	  String str="";	  
	  if( "".equals(empsapid) || "".equals(enddate) || "".equals(quotasapid)){
		  str = "error@@Parameters is null";
	  }else{
		  String functionName = "";
		  JCoFunction function = null;
		  String errorMessage = "";
		  
			functionName = "ZHR_IT2006_GET_MY"; //PT004 员工缺勤定额获取
			function = null;
			try {
				function = SapConnector_EN.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			if (function == null) {
				System.out.println(functionName + " not found in SAP.");
				System.out.println("SAP_RFC中没有此函数!");
				errorMessage = functionName + " not found in SAP.";
			}
			function.getImportParameterList().setValue("PERNR", empsapid);
			function.getImportParameterList().setValue("BEGDA", begindate);
			function.getImportParameterList().setValue("ENDDA", enddate);
			function.getImportParameterList().setValue("KTART", quotasapid);
			System.out.println("DMHR_LeaveAction.GetLeftQuota: PERNR="+empsapid +" BEGDA="+begindate+" ENDDA="+enddate+" KTART="+quotasapid);
			
			try {
				function.execute(SapConnector_EN.getDestination("sanpowersapen"));
				//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
			} catch (JCoException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
	
			//返回值
			String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
			String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
			JCoTable jcotable = function.getTableParameterList().getTable("IT2006");
		    if ( "I".equals(sapmsgtype) && jcotable != null ) {
		        for (int i = 0; i < jcotable.getNumRows(); i++)
		        {		        
		          String PERNR = StringHelper.null2String(jcotable.getString("PERNR"));
		          String KTART = StringHelper.null2String(jcotable.getString("KTART"));
		          String KTEXT = StringHelper.null2String(jcotable.getString("KTEXT"));
		          String ANZHL = StringHelper.null2String(jcotable.getString("ANZHL"));
		          String ZEINH = StringHelper.null2String(jcotable.getString("ZEINH"));
		          str = KTART +"@@"+KTEXT+"@@"+ANZHL+"@@"+ZEINH;
		          System.out.println("DMHR_LeaveAction.GetLeftQuota: str="+str);
		          break;
		        }  
		    }else{
		    	str = "error@@SAP Search fail";
		    }	
	  }
	  return str;
  }
	  
}
