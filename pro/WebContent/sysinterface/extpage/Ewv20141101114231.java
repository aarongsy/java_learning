package com.eweaver.sysinterface.extclass;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.lang.String;
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

public class Ewv20141101114231 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 
    BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
  	String upflowtypesql = "update uf_hr_businesstrip set flowtype = '40285a8f489c17ce0148a12871bb0d9b' where requestid = '"+requestid+"'";
	 baseJdbc.update(upflowtypesql);
	String nsql = "select to_char(sysdate,'YYYY-MM-DD') as appdate from dual";
	List nlist = baseJdbc.executeSqlForList(nsql);
	if(nlist.size()>0){
		Map nmap = (Map)nlist.get(0);
		String appdate = StringHelper.null2String(nmap.get("appdate"));//审批时间
		String upsql = "update uf_hr_businesstrip set appdate = '"+appdate+"' where requestid = '"+requestid+"'";
		baseJdbc.update(upsql);
	}
	String sql = "select ifreturn from uf_hr_businesstrip where requestid = '"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		Map map = (Map)list.get(0);
		String ifreturn = StringHelper.null2String(map.get("ifreturn"));//是否为返台休假
		if(ifreturn.equals("40288098276fc2120127704884290211") || ifreturn=="" ||ifreturn==null)
		{//如果不是返台休假
			SapSync s = new SapSync();
			try {
				s.syncSap("40285a904999a7ad01499cfd12be21b6",requestid);
			
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else
		{//如果是返台休假，需要回写返台请假记录信息。

			String searchsql = "select requestid,sdate,edate,psnno,sums,reqdate from uf_hr_businesstrip where requestid ='"+requestid+"'";
			List searchlist = baseJdbc.executeSqlForList(searchsql);
			if(searchlist.size()>0){
				Map searchmap = (Map)searchlist.get(0);
				String ccrequestid = StringHelper.null2String(searchmap.get("requestid"));//出差申请单号
				String sdate = StringHelper.null2String(searchmap.get("sdate"));//出差开始日期
				String edate = StringHelper.null2String(searchmap.get("edate"));//出差结束日期
				String psnno = StringHelper.null2String(searchmap.get("psnno"));//出差人员的Id
				String reqdate = StringHelper.null2String(searchmap.get("reqdate"));//出差单填单日期
				String year = reqdate.split("-")[0];//出差申请单对应的出差所属年份
				int  sums = Integer.parseInt(StringHelper.null2String(searchmap.get("sums")));//表单中计算的累计在常天数
				String selectsql = "select requestid,max(no) as nos,godate,id from uf_hr_backdetails where requestid =(select requestid from uf_hr_backstatic where year ='"+year+"' and reqno = '"+psnno+"') group by requestid,godate,id";
                
				List selectlist = baseJdbc.executeSqlForList(selectsql);
				if(selectlist.size()>0)
				{
					Map  selectmap = (Map)selectlist.get(0);
					String id = StringHelper.null2String(selectmap.get("requestid"));//对应的统计表的requestid
					String ids = StringHelper.null2String(selectmap.get("id"));//对应的统计表的ID
					String godate = StringHelper.null2String(selectmap.get("godate"));//对应的统计表的requestid

					int nos = Integer.parseInt(StringHelper.null2String(selectmap.get("nos")));//对应的统计表的子表中的最大行数的值；
					String uniqueid = IDGernerator.getUnquieID();
					String insertsql="";
                    String xs ="";
                    String [] ss = {"00","0"};

					if(nos==1 && (godate=="" || godate == null || godate == "null"))
					{
						nos=nos;
                        if(nos <10)
                        {
                          xs = "00"+String.valueOf(nos-1);
                        }
                        else
                        {
                          xs = "0"+String.valueOf(nos-1);
                        }
						//insertsql= "insert into uf_hr_backdetails(ccflowno,godate,backdate,requestid,no,ljdays,tickets)";
						String updatesql = "update uf_hr_backdetails set rowindex ='"+xs+"',ccflowno='"+ccrequestid+"',godate='"+sdate+"',backdate='"+edate+"',ljdays=("+sums+"-jydays),tickets='0'";
						updatesql = updatesql+" where requestid = '"+id+"' and id = '"+ids+"'";
						System.out.println(updatesql);
						baseJdbc.update(updatesql);

					}
					else
					{
                      nos = nos+1;
						if(nos <10)
                        {
                          
                          xs = "00"+String.valueOf(nos-1);
                        }
                        else
                        {
                          xs = "0"+String.valueOf(nos-1);
                        }
						insertsql= "insert into uf_hr_backdetails(rowindex,ccflowno,godate,backdate,requestid,id,no,ljdays,jydays,tickets)";
						insertsql = insertsql +" values('"+xs+"','"+ccrequestid+"','"+sdate+"','"+edate+"','"+id+"','"+uniqueid+"','"+nos+"','"+sums+"'";
						insertsql = insertsql +",'"+(sums-60)+"','0')";
						baseJdbc.update(insertsql);
					}
					
				}
			}
			
		}
		//更新排班表中的信息
		String ssql = "select sdate,edate,psnno,msgty,ifreturn from uf_hr_businesstrip where requestid = '"+requestid+"' ";
		List stlist = baseJdbc.executeSqlForList(ssql);
		if(stlist.size()>0)
		{
            Map newmap = (Map)stlist.get(0);
			String ksdate = StringHelper.null2String(newmap.get("sdate"));//出差开始日期
			String jsdate = StringHelper.null2String(newmap.get("edate"));//出差结束日期
			String ygno = StringHelper.null2String(newmap.get("psnno"));//出差员工
			String msgty = StringHelper.null2String(newmap.get("msgty"));//SAP消息类型
			String ifyon = StringHelper.null2String(newmap.get("ifreturn"));//是否返台休假
			if(ifyon.equals("40288098276fc2120127704884290210") || msgty.equals("I") )
			{
				String ssql1 = "update uf_hr_classplan  set ifbusiness='Y' where jobno='"+ygno+"' and thedate >='"+ksdate+"' and thedate<='"+jsdate+"'";
				baseJdbc.update(ssql1);
			}
		}
	}
} 
}





















