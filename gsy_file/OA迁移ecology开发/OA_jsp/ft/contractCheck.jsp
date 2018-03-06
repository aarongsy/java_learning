<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="/base/init.jsp"%>
<%
	String uptype= request.getParameter("uptype");
	if(uptype.equals("contractcheck1"))//支出合同验证1-主合同
	{
		String requestid = request.getParameter("requestid");
		if(requestid==null||requestid.length()<1)
		{
			requestid="0";
		}
		String subids = request.getParameter("subids");
		String stocks = request.getParameter("stocks");
		
		String throwstr="";//验证出错，请联系系统管理员！
		if(subids!=null)
		{
			String[] stocksArr = stocks.split(",");
			String[] subidsArr = subids.split(",");
			List ls=null;
			DataService ds= new DataService();
			ls=ds.getValues("select requestid,name,round((nvl(bgetbudget0,0.0)+nvl(bg1,0.0)+nvl(bg2,0.0))/10000,2) sums,nvl((select sum(pay) from uf_ctr_bug_sub where mainctrno=t.REQUESTID and requestid<>'"+requestid+"' and exists(select x.id from requestbase x where x.isdelete=0 and x.isfinished=1 and x.id=uf_ctr_bug_sub.requestid)),0.0) hasstock from uf_contract t where '"+subids+"' like '%'||requestid||'%'");
			for(int i=0,size=ls.size();i<size;i++)
			{
				Map m = (Map)ls.get(i);
				String requestidb=StringHelper.null2String(m.get("requestid"));
				double sums=Double.valueOf(StringHelper.null2String(m.get("sums")));
				double hasstock=Double.valueOf(StringHelper.null2String(m.get("hasstock")));
				double thisstock=0.0;
				for(int j=0,len=subidsArr.length;j<len;j++)
				{
						
					if(subidsArr[j].equals(requestidb))
					{
						thisstock=stocksArr[j].length()>0?Double.valueOf(stocksArr[j]):0.0;
						break;
					}
				
				}
				if(sums-hasstock-thisstock<0)
				{
					String name=StringHelper.null2String(m.get("name"));
					throwstr=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0053")+" [ "+name+" ] "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0054");//合同   金额超出预算！
					break;
				}

			}
		}
		else
		{
			throwstr=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0055");//合同未关联主合同！
		}
		if(throwstr.length()<1)throwstr="yes";
		out.println(throwstr);
	}
	else if(uptype.equals("contractcheck2"))//支出合同验证2-计划
	{

		String requestid = request.getParameter("requestid");
		if(requestid==null||requestid.length()<1)
		{
			requestid="0";
		}
		String subids = request.getParameter("subids");
		String stocks = request.getParameter("stocks");
		
		String throwstr="";//验证出错，请联系系统管理员！
		if(subids!=null)
		{
			String[] stocksArr = stocks.split(",");
			String[] subidsArr = subids.split(",");
			List ls=null;
			DataService ds= new DataService();
			ls=ds.getValues("select requestid,devicename,sums,nvl((select sum(pay) from uf_ctr_bug_sub where planno=t.requestid and requestid<>'"+requestid+"' and exists(select x.id from requestbase x where x.isdelete=0 and x.isfinished=1 and x.id=uf_ctr_bug_sub.requestid)),0.0) hasstock from uf_fn_pcplan t  where '"+subids+"' like '%'||requestid||'%'");
			for(int i=0,size=ls.size();i<size;i++)
			{
				Map m = (Map)ls.get(i);
				String requestidb=StringHelper.null2String(m.get("requestid"));
				double sums=Double.valueOf(StringHelper.null2String(m.get("sums")));
				double hasstock=Double.valueOf(StringHelper.null2String(m.get("hasstock")));
				double thisstock=0.0;
				for(int j=0,len=subidsArr.length;j<len;j++)
				{
						
					if(subidsArr[j].equals(requestidb))
					{
						thisstock=stocksArr[j].length()>0?Double.valueOf(stocksArr[j]):0.0;
						break;
					}
				
				}
				if(sums-hasstock-thisstock<0)
				{
					String devicename=StringHelper.null2String(m.get("devicename"));
					throwstr=labelService.getLabelNameByKeyId("402883d934c110890134c11089c30000")+" [ "+devicename+" ] "+labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0054");//计划   金额超出预算！
					break;
				}

			}
		}
		else
		{
			throwstr=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0056");//合同未关联生产计划！
		}
		if(throwstr.length()<1)throwstr="yes";
		out.println(throwstr);
	}
%>