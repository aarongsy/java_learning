<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ page import="java.util.*" %><%@ page import="com.eweaver.base.IDGernerator" %>
<%
	String requestid= request.getParameter("requestid");
	String type = request.getParameter("action");
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	if(type.equals("finish"))//人工完成
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));
		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
			
		}
		baseJdbc.update("update edo_task  set STATUS='2c91a0302aa21947012aa232f1860012',INDENTFINISHDATE='"+DateHelper.getCurrentDate()+"' where  requestid in ("+ids+") and STATUS='2c91a0302aa21947012aa232f1860010'");
		out.println("yes");
	}
	else if(type.equals("cancel"))//取消完成
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));

		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		baseJdbc.update("update edo_task  set STATUS='2c91a0302b278cea012b27d28c3a0014',INDENTFINISHDATE=null where  requestid in ("+ids+") and STATUS='2c91a0302aa21947012aa232f1860012'");
		out.println("yes");
	}
	else if(type.equals("contractfinish"))//合同结项
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));

		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		baseJdbc.update("update uf_contract_dist set implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in ("+ids+") and orgid=(select extrefobjfield10 from humres where id='"+BaseContext.getRemoteUser().getId()+"' ) ");
		baseJdbc.update("update uf_contract t set state='2c91a0302a8cef72012a8eabe0e803f2',implementdate='"+DateHelper.getCurrentDate()+"' where  requestid in ("+ids+") and not exists(select id from uf_contract_dist where implementdate is null and requestid=t.requestid)");
		out.println("yes");
	}
		else if(type.equals("contractcancel"))//取消合同结项
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));

		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		baseJdbc.update("update uf_contract_dist set implementdate= null where  requestid in ("+ids+") ");

		baseJdbc.update("update uf_contract t set state='2c91a0302a8cef72012a8eabe0e803f1',implementdate=null where  requestid in ("+ids+") and exists(select id from uf_contract_dist where implementdate is null and requestid=t.requestid)");

		//baseJdbc.update("update uf_contract set state='2c91a0302a8cef72012a8eabe0e803f1',implementdate=null where  requestid in ("+ids+") and state='2c91a0302a8cef72012a8eabe0e803f2'");
		out.println("yes");
	}
	else if(type.equals("contractdistfinish"))//合同分解完成
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));

		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		baseJdbc.update("update uf_contract set state='2c91a0302ab11213012ab12bf0f00022' where  requestid in ("+ids+") and state='2c91a0302a8cef72012a8eabe0e803f1'");
		out.println("yes");
	}
		else if(type.equals("contractundistfinish"))//取消合同分解完成
	{
		String delids = StringHelper.null2String(request.getParameter("delids"));

		String[] delidsArr=delids.split(",");
		String ids = "'0'";
		for(int i=0,len=delidsArr.length;i<len;i++)
		{
			ids=ids+",'"+delidsArr[i]+"'";
		}
		baseJdbc.update("update uf_contract set state='2c91a0302a8cef72012a8eabe0e803f1' where  requestid in ("+ids+") and state='2c91a0302ab11213012ab12bf0f00022'");
		out.println("yes");
	}
	else if(type.equals("contractdist"))//合同分解处理
	{

		String hql="select IMPLEMENTDATE,PREDICTDATE,nvl(money,0.0) money,requestid,orgunit from uf_contract where not exists(select id from uf_contract_dist where requestid=uf_contract.requestid) and instr(orgunit,',')<1";
		List contract=baseJdbc.executeSqlForList(hql);
		for(int i=0,size=contract.size();i<size;i++)
		{
			Map m = (Map)contract.get(i);
			requestid=StringHelper.null2String(m.get("requestid"));
			String orgunit=StringHelper.null2String(m.get("orgunit"));
			String IMPLEMENTDATE=StringHelper.null2String(m.get("IMPLEMENTDATE"));
			String PREDICTDATE=StringHelper.null2String(m.get("PREDICTDATE"));
			String money=StringHelper.null2String(m.get("money"));
			sql="insert into uf_contract_dist(ID,REQUESTID,NODEID,ROWINDEX,PID,CONTRACTNO,ORGID,DISTSUM,IMPLEMENTDATE,PREDICTDATE) values('"+IDGernerator.getUnquieID()+"','"+requestid+"','001','','"+requestid+"','"+requestid+"','"+orgunit+"',"+money+",'"+IMPLEMENTDATE+"','"+PREDICTDATE+"')";
			baseJdbc.update(sql);
		}
	}
%>