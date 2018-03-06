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

public class UpdateBgCardtime1 {
	public void doAction(){

		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService csfkkqdataservices = new DataService();
		System.out.println("auto start 采购发包获取刷卡信息......");
        //
		String sql="select id,requestid,identify,ddate,stime,etime,infactorytime,outfactorytime  from uf_oa_forwarderlist  where 1<>(select isdelete from requestbase where id = requestid) and ((select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) = to_date(ddate,'yyyy-mm-dd')+1 or (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) = to_date(ddate,'yyyy-mm-dd'))";
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
				String infactorytime = StringHelper.null2String(map.get("infactorytime"));
				String outfactorytime = StringHelper.null2String(map.get("outfactorytime"));
				System.out.println("身份证号--------------------------"+identify);
				System.out.println("需求日期--------------------------"+ddate);
				String sdate="";
				String edate="";
				int shour=Integer.parseInt(stime.split(":")[0])-1;
				int ehour=Integer.parseInt(etime.split(":")[0])+1;
				String shourString=shour+"";
				String ehourString=ehour+"";
				if(shour<10)
				{
					shourString="0"+shour+"";
				}
				if(ehour<10)
				{
					ehourString="0"+ehour+"";
				}
				sdate=ddate+" "+shourString+":"+stime.split(":")[1];
				edate=ddate+" "+ehourString+":"+etime.split(":")[1];
				
				String inout = "";//进出厂类型
				String repeat = "";//是否重复
				String cardtime = "";//出入厂时间


				//点击按钮前先清空原来的出入厂记录
				String upsql="update uf_oa_forwarderlist set infactorytime='',outfactorytime='' where id='"+id+"'";
				baseJdbc.update(upsql);
				
				csfkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfkkq"));//访客	
				String sqlc = "select CONVERT(varchar(16), acc_monitor_log.time,120)  as cardtime,(case when acc_door.id in ('1','5','7','9','10','11','13','14','18','17') then '进' else '出' end) as inout,(select max(b.id) from acc_monitor_log as b left join userinfo as d on d.badgenumber = b.pin left join DEPARTMENTS as c on c.deptid = d.DEFAULTDEPTID where b.id < acc_monitor_log.id and b.event_point_id = acc_monitor_log.event_point_id  and b.device_id = acc_monitor_log.device_id and CONVERT(varchar(16), b.time,120) >= '"+sdate+"'and CONVERT(varchar(16), b.time,120) <= '"+edate+"' and d.name = userinfo.name and b.card_no = acc_monitor_log.card_no and (b.id = acc_monitor_log.id-1 or b.id = acc_monitor_log.id-2 or b.id = acc_monitor_log.id-3  or b.id = acc_monitor_log.id-4 or b.id = acc_monitor_log.id-5 ) and b.event_type in ( '0','14') group by b.event_point_id) as repeat from acc_monitor_log as acc_monitor_log left join userinfo on userinfo.badgenumber = acc_monitor_log.pin left join DEPARTMENTS on DEPARTMENTS.deptid = userinfo.DEFAULTDEPTID left join acc_door on acc_door.door_no = acc_monitor_log.event_point_id and acc_door.device_id = acc_monitor_log.device_id left join machines on machines.id = acc_monitor_log.device_id where CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"'  and acc_monitor_log.event_type in ( '0','14') and userinfo.identitycard = '"+identify+"' and CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"' order by CONVERT(varchar(16), acc_monitor_log.time,120) ";
				System.out.println(sqlc);
				List listc = csfkkqdataservices.getValues(sqlc);
				String  flagj="false";
				if(listc.size()>0)
				{
					Map<String,String> m2=new HashMap<String,String>();
					for(int j=0;j<listc.size();j++)
					{
						m2 = (Map)listc.get(j);			
						inout = StringHelper.null2String(m2.get("inout"));//进出厂类型
						repeat = StringHelper.null2String(m2.get("repeat"));//是否重复
						cardtime = StringHelper.null2String(m2.get("cardtime"));//打卡时间
		               
						System.out.println("进出厂类型--------------------------"+inout);
						System.out.println("刷卡时间--------------------------"+cardtime);
						if(repeat.equals("")&&inout.equals("进"))
						{
							if(flagj.equals("false"))
							{
								String upsql1="update uf_oa_forwarderlist set infactorytime='"+cardtime+"' where id='"+id+"' ";
								baseJdbc.update(upsql1);//执行SQL
								flagj="true";
							}
						}
						else if(repeat.equals("")&&inout.equals("出"))
						{
							String upsql2="update uf_oa_forwarderlist set outfactorytime='"+cardtime+"' where id='"+id+"'";
							baseJdbc.update(upsql2);//执行SQL
						}
						else
						{
							System.out.println("不符合条件未取到数据！");

						}
					}
				}
			}
		}
		
		
       	System.out.println("auto END 采购发包获取刷卡信息.......");
		
        
	}
}
