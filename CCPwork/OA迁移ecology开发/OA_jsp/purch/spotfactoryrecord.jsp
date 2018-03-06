<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>
<%

	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	Humres currentuser = eweaveruser.getHumres();
	String userid=currentuser.getId();//当前用户	
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String idcard=StringHelper.null2String(request.getParameter("idcard"));//身份证号
	String ddate=StringHelper.null2String(request.getParameter("ddate"));//需求日期
	String dstart=StringHelper.null2String(request.getParameter("dstart"));//时间段(起)
	String dend=StringHelper.null2String(request.getParameter("dend"));//时间段(止)
	String sdate=StringHelper.null2String(request.getParameter("sdate"));//起始时间段
	String edate=StringHelper.null2String(request.getParameter("edate"));//终止时间段
	String factype=StringHelper.null2String(request.getParameter("factype"));//厂区别
	String inout = "";//进出厂类型
	String repeat = "";//是否重复
	String cardtime = "";//出入厂时间
	String mark="1";//标识
	//点击按钮前先清空原来的出入厂记录
	String upsql="update uf_oa_listdetail set infactory='',outfactory='' where requestid='"+requestid+"' and identity='"+idcard+"' and neesdate='"+ddate+"' and sdate='"+dstart+"' and edate='"+dend+"'";
	baseJdbc.update(upsql);

    DataService fkkqdataservices = new DataService();
	if(factype.equals("4028804d2083a7ed012083ebb988005b"))
	{
		fkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("csfkkq"));//常熟访客
	}
	if(factype.equals("40285a90488ba9d101488bbd09100007"))
	{
		fkkqdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("pjfkkq"));//盘锦访客
	}	
	String sql = "select CONVERT(varchar(16), acc_monitor_log.time,120)  as cardtime,(case when acc_door.id in ('1','5','7','9','10','11','13','14','18','17') then '进' else '出' end) as inout,(select max(b.id) from acc_monitor_log as b left join userinfo as d on d.badgenumber = b.pin left join DEPARTMENTS as c on c.deptid = d.DEFAULTDEPTID where b.id < acc_monitor_log.id and b.event_point_id = acc_monitor_log.event_point_id  and b.device_id = acc_monitor_log.device_id and CONVERT(varchar(16), b.time,120) >= '"+sdate+"'and CONVERT(varchar(16), b.time,120) <= '"+edate+"' and d.name = userinfo.name and b.card_no = acc_monitor_log.card_no and (b.id = acc_monitor_log.id-1 or b.id = acc_monitor_log.id-2 or b.id = acc_monitor_log.id-3  or b.id = acc_monitor_log.id-4 or b.id = acc_monitor_log.id-5 ) and b.event_type in ( '0','14','1000') group by b.event_point_id) as repeat from acc_monitor_log as acc_monitor_log left join userinfo on userinfo.badgenumber = acc_monitor_log.pin left join DEPARTMENTS on DEPARTMENTS.deptid = userinfo.DEFAULTDEPTID left join acc_door on acc_door.door_no = acc_monitor_log.event_point_id and acc_door.device_id = acc_monitor_log.device_id left join machines on machines.id = acc_monitor_log.device_id where CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"'  and acc_monitor_log.event_type in ( '0','14','1000') and userinfo.identitycard = '"+idcard+"' and CONVERT(varchar(16), acc_monitor_log.time,120) >= '"+sdate+"' and CONVERT(varchar(16), acc_monitor_log.time,120) <= '"+edate+"' order by CONVERT(varchar(16), acc_monitor_log.time,120)";
	List list = fkkqdataservices.getValues(sql);

   	String  flagj="false";
	if(list.size()>0)
	{
			Map<String,String> m2=new HashMap<String,String>();
			for(int i=0;i<list.size();i++)
			{
				m2 = (Map)list.get(i);	
				inout = StringHelper.null2String(m2.get("inout"));//进出厂类型
				repeat = StringHelper.null2String(m2.get("repeat"));//是否重复
				cardtime = StringHelper.null2String(m2.get("cardtime"));//打卡时间
				//System.out.println("0000000000000--------------------------"+cardtime);
				//System.out.println("0000000000000--------------------------"+inout);
				if(repeat.equals("")&&inout.equals("进"))
				{
					if(flagj.equals("false"))
					{
						String upsql1="update uf_oa_listdetail set infactory='"+cardtime+"' where requestid='"+requestid+"' and identity='"+idcard+"' and neesdate='"+ddate+"' and sdate='"+dstart+"' and edate='"+dend+"'";
						baseJdbc.update(upsql1);//执行SQL
						flagj="true";
					}
				}
				else if(repeat.equals("")&&inout.equals("出"))
				{
						String upsql2="update uf_oa_listdetail set outfactory='"+cardtime+"' where requestid='"+requestid+"' and identity='"+idcard+"' and neesdate='"+ddate+"' and sdate='"+dstart+"' and edate='"+dend+"'";
						baseJdbc.update(upsql2);//执行SQL
				}
				else
				{
					System.out.println("--------------------------------不符合条件未取到数据！");
					mark="0";
				}
			}
	}
	else
	{
		mark="0";
	}
	JSONObject jo = new JSONObject();
	if(mark.equals("1"))
	{			
		jo.put("msg","true");
	}
	else
	{
		jo.put("msg","false");
	}
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>