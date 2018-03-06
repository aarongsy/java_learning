package com.eweaver.app.autotask;

import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import org.springframework.jdbc.core.JdbcTemplate;
import java.util.*;
import com.eweaver.base.util.*;
import com.eweaver.base.*;

public class UpdateDgCardtime {
	public void doAction(){

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService csfkkqdataservices = new DataService();
		System.out.println("auto start 采购点工获取刷卡信息......");
        //List list = baseJdbc.executeSqlForList(sql);
		String sql="select a.id,a.requestid,a.identity identify,a.neesdate ddate,a.sdate stime,a.edate etime,a.infactory infactorytime,a.outfactory outfactorytime,b.factype  from uf_oa_listdetail a left join uf_oa_yjgsryrc b on a.requestid=b.requestid where 1<>(select isdelete from requestbase where id = a.requestid) and ((select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) = to_date(a.neesdate,'yyyy-mm-dd')+1 or (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) = to_date(a.neesdate,'yyyy-mm-dd')) and a.identity is not null and a.sdate is not null and a.edate is not null";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{
			for (int i = 0; i < list.size(); i++) 
			{
				Map map = (Map)list.get(i);
				String id = StringHelper.null2String(map.get("id"));
				String requestid = StringHelper.null2String(map.get("requestid"));
				String identify = StringHelper.null2String(map.get("identify"));
				String ddate = StringHelper.null2String(map.get("ddate"));
				String stime = StringHelper.null2String(map.get("stime"));
				String etime = StringHelper.null2String(map.get("etime"));
				String factype=StringHelper.null2String(map.get("factype"));
				System.out.println("身份证号--------------------------"+identify);
				System.out.println("需求日期--------------------------"+ddate);
				String sdate="";
				String edate="";
				int shour=Integer.parseInt(stime.toString().split(":")[0].toString())-1;
				int ehour=Integer.parseInt(etime.toString().split(":")[0].toString())+1;
				//System.out.println("shour--------------------------"+shour);
				////System.out.println("ehour--------------------------"+ehour);
				String shourString=""+String.valueOf(shour)+"";
				String ehourString=""+String.valueOf(ehour)+"";
				//System.out.println("shourString--------------------------"+shourString);
				//System.out.println("ehourString--------------------------"+ehourString);
				if(shourString.toString().length()<2)
				{
					shourString=String.valueOf(0)+shourString.toString()+"";
				}
				if(ehourString.toString().length()<2)
				{
					ehourString=String.valueOf(0)+ehourString.toString()+"";
				}
				sdate=ddate+" "+shourString+":"+stime.split(":")[1];
				edate=ddate+" "+ehourString+":"+etime.split(":")[1];
				
				String inout = "";//进出厂类型
				String repeat = "";//是否重复
				String cardtime = "";//出入厂时间


				//点击按钮前先清空原来的出入厂记录
				String upsql="update uf_oa_listdetail set infactory='',outfactory='' where id='"+id+"'";
				baseJdbc.update(upsql);
				System.out.println("sdate--------------------------"+sdate);
				System.out.println("edate--------------------------"+edate);
				if(factype.equals("4028804d2083a7ed012083ebb988005b"))
				{
					csfkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfkkq"));//访客	
				}
				else {
					csfkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("pjfkkq"));//访客	
				}
				String sqlc = "select CONVERT(varchar(16), acc_monitor_log.time,120)  as cardtime,(case when acc_door.id in ('1','5','7','9','10','11','13','14','18','17') then '进' else '出' end) as inout,(select max(b.id) from acc_monitor_log as b left join userinfo as d on d.badgenumber = b.pin left join DEPARTMENTS as c on c.deptid = d.DEFAULTDEPTID where b.id < acc_monitor_log.id and b.event_point_id = acc_monitor_log.event_point_id  and b.device_id = acc_monitor_log.device_id and CONVERT(varchar(16), b.time,120) >= '"+sdate.toString()+"'and CONVERT(varchar(16), b.time,120) <= '"+edate.toString()+"' and d.name = userinfo.name and b.card_no = acc_monitor_log.card_no and (b.id = acc_monitor_log.id-1 or b.id = acc_monitor_log.id-2 or b.id = acc_monitor_log.id-3  or b.id = acc_monitor_log.id-4 or b.id = acc_monitor_log.id-5 ) and b.event_type in ( '0','14') group by b.event_point_id) as repeat from acc_monitor_log as acc_monitor_log left join userinfo on userinfo.badgenumber = acc_monitor_log.pin left join DEPARTMENTS on DEPARTMENTS.deptid = userinfo.DEFAULTDEPTID left join acc_door on acc_door.door_no = acc_monitor_log.event_point_id and acc_door.device_id = acc_monitor_log.device_id left join machines on machines.id = acc_monitor_log.device_id where CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate.toString()+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"'  and acc_monitor_log.event_type in ( '0','14') and userinfo.identitycard = '"+identify.toString()+"' and CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate.toString()+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"' order by CONVERT(varchar(16), acc_monitor_log.time,120) ";
				//System.out.println(sqlc);
				List listc = csfkkqdataservices.getValues(sqlc);
				String  flagj="false";
				if(listc.size()>0)
				{
					Map<String,String> m2=new HashMap<String,String>();
					for(int j=0;j<listc.size();j++)
					{
						m2 = (Map)listc.get(j);			
						inout = StringHelper.null2String(m2.get("inout"));//进出厂类型
						cardtime = StringHelper.null2String(m2.get("cardtime"));//打卡时间
						System.out.println(j);
						System.out.println(listc.size());
						System.out.println("身份证"+identify.toString()+"进出厂类型----------------"+inout.toString());
						System.out.println("身份证"+identify.toString()+"刷卡时间------"+cardtime.toString());
						if(inout.toString().equals("进"))
						{
							if(flagj.toString().equals("false"))
							{
								String upsql1="update uf_oa_listdetail set infactory='"+cardtime.toString()+"' where id='"+id.toString()+"' ";
								baseJdbc.update(upsql1);//执行SQL
								System.out.println(upsql1);
								flagj="true";
							}
						}
						else if(inout.toString().equals("出"))
						{
							String upsql2="update uf_oa_listdetail set outfactory='"+cardtime.toString()+"' where id='"+id.toString()+"'";
							baseJdbc.update(upsql2);//执行SQL
							System.out.println(upsql2);
						}
						else
						{
							System.out.println("不符合条件未取到数据！");

						}
					}
				}
			}
		}
		
		
       	System.out.println("auto END 采购点工获取刷卡信息.......");
		
        
	}
}
