<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="java.text.SimpleDateFormat" %><%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %><%@ page import="com.eweaver.workflow.request.service.FormService" %><%@ page import="com.eweaver.workflow.form.model.*" %><%@ page import="com.eweaver.workflow.form.service.*" %><%@ page import="com.eweaver.base.security.util.*" %><%
	
	String requestid= request.getParameter("requestid");
	String type = request.getParameter("action");
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	System.out.println("1111111111111111");
	if(type.equals("CheckPlanSubmit"))//溯源计划确认
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));
		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		CheckPlanSubmit(ids,baseJdbc);
		out.println("yes");
	}
%>
<%!

public void CheckPlanSubmit(String ids,BaseJdbcDao baseJdbc)
{
	PermissionTool permissionTool = new PermissionTool();
	FormBaseService formbaseService=(FormBaseService)BaseContext.getBean("formbaseService");
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	
	List ls=baseJdbc.executeSqlForList("select b.requestid requestida,a.requestid,nvl(a.weekunit,'2c91a0302c619c72012c6206290c06b1') syunit,nvl(a.period,0) period,a.sydate,b.syunit syunitnew,a.nextsydate,b.sydate sydateb,verdict,a.rank from uf_device_equipment a,uf_device_result b where a.requestid=b.fsn and b.requestid in ("+ids+") and state='402881162c3940f0012c39ab2817002b' ");
	 

	
	List requestlist=new ArrayList();
	if(ls.size()>0)
	{
		for(int i=0,size=ls.size();i<size;i++)
		{
			Map m = (Map)ls.get(0);
			String requestida=m.get("requestida").toString();
			requestlist.add(requestida);
			String requestidb=m.get("requestid").toString();
			String syunit = StringHelper.null2String(m.get("syunit"));
			int period = Integer.parseInt(StringHelper.null2String(m.get("period")));
			String sydate=StringHelper.null2String(m.get("sydate"));
			String sydateb=StringHelper.null2String(m.get("sydateb"));
			String nextsydate= StringHelper.null2String(m.get("nextsydate"));
			//String verdict= StringHelper.null2String(m.get("verdict"));
			String syunitnew = StringHelper.null2String(m.get("syunitnew"));
        String verdict = StringHelper.null2String(m.get("verdict"));//结论
        String rank = StringHelper.null2String(m.get("rank"));//等级
			
			if(syunit.equals("2c91a0302c619c72012c6206290c06b1"))//日
			{
				nextsydate=this.addDate(sydateb, period);
			} 
			else if(syunit.equals("2c91a0302c619c72012c6206290c06b2"))//周
			{
				nextsydate=this.addDate(sydateb, period*7);
			}
			else if(syunit.equals("2c91a0302c619c72012c6206290c06b3"))//月
			{
				nextsydate=this.addMonth(sydateb, period);
			}
			else if(syunit.equals("2c91a0302c619c72012c6206290c06b4"))//季
			{
				nextsydate=this.addMonth(sydateb, period*3);
			}
			else if(syunit.equals("2c91a0302c619c72012c6206290c06b5"))//年
			{
				nextsydate=this.addYear(sydateb, period);
			}

			if ("2c91a0303103b67a0131042267cc01b6".equals(verdict)){//降级使用
        	if ("2c91a0302c2fe2d1012c349759490387".equals(rank)){// 一级  2c91a0302c2fe2d1012c349759490387  二级  2c91a0302c2fe2d1012c349759490388  三级  2c91a0302c2fe2d1012c349759490389
        		rank = "2c91a0302c2fe2d1012c349759490388";
        	}else if ("2c91a0302c2fe2d1012c349759490388".equals(rank)){
        		rank = "2c91a0302c2fe2d1012c349759490389";//三级
        	}
        }
			//修改为失效状态
			//baseJdbc.update("update uf_device_equipment set  sydate='"+sydateb+"',nextsydate='"+nextsydate+"',utenstilstate='"+verdict+"',syunit='"+syunit+"' where requestid='"+requestidb+"'");

		 String upstrsql = "update uf_device_equipment set  sydate='" + sydateb + "',syunit='"+syunitnew+"',nextsydate='" + nextsydate + "',rank='"+rank+"',utenstilstate='"+verdict+"' where requestid='" + requestidb + "'";
        	baseJdbc.update(upstrsql);
        	System.out.println("upstrsql======="+upstrsql);
		}
		baseJdbc.update("update uf_device_result set checkman='"+eweaveruser.getId()+"',checkdate='"+DateHelper.getCurrentDate()+"',state='402881162c3940f0012c39ab2817002c'  where  requestid in ("+ids+") and state='402881162c3940f0012c39ab2817002b'");//402881162c3940f0012c39ab2817002b
		
	   
		for(int i=0,size=requestlist.size();i<size;i++)
		{
			//删除原有权限
			String delSQL1 = "delete from permissionrule where objid='"+requestlist.get(i).toString()+"'";
			String delSQL2 = "delete from permissiondetail where objid='"+requestlist.get(i).toString()+"'";
			baseJdbc.update(delSQL1);
			baseJdbc.update(delSQL2);
			//重构权限信息
			permissionTool.addPermission("402881162c3940f0012c39fc02b301a4",requestlist.get(i).toString(),"uf_device_result");
		}
	}
	//verdict uf_device_result  syunit

	

}

private String addDate(String date,int num)
{

	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	Calendar today = new GregorianCalendar();
	Date startdate;
	try {
		startdate = f.parse(date);
		today.setTime(startdate);
		today.add(Calendar.DATE,num);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return f.format(today.getTime());
	
}
private String addMonth(String date,int num)
{

	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	Calendar today = new GregorianCalendar();
	Date startdate;
	try {
		startdate = f.parse(date);
		today.setTime(startdate);
		today.add(Calendar.MONTH,num);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return f.format(today.getTime());
	
}

private String addYear(String date,int num)
{
	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
	Calendar today = new GregorianCalendar();
	Date startdate;
	try {
		startdate = f.parse(date);
		today.setTime(startdate);
		today.add(Calendar.YEAR,num);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	return f.format(today.getTime());
	
}


%>