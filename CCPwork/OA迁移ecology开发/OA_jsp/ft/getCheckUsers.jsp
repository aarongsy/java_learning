<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %>
<%
	String requestid= request.getParameter("requestid");
	String reqdept = request.getParameter("reqdept");
	String reqman = request.getParameter("reqman");
	String zy= request.getParameter("zy");
	String zyfx= request.getParameter("zyfx");
	String lx = request.getParameter("lx");
	String sql = "";
	String sqlwhere="";
	String userid="";
	String username="";
	String ids="\'0\'";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	if(StringHelper.isEmpty(zy)||StringHelper.isEmpty(lx)||StringHelper.isEmpty(reqdept))
	{
		sqlwhere="sqlwhere=1=2";
		out.println(sqlwhere+";"+userid+";"+username);
		return;
	}
	List datalist1= baseJdbc.executeSqlForList("select ID,OBJNAME,SECLEVEL from humres a where exists(select * from (select c.mainmaj,c.maintype,c.subtype,d.psimtype,d.checkman,d.mainstation from uf_doc_psimmain c,uf_doc_psimsub d where c.requestid=d.requestid and c.subtype='"+lx+"') e where (e.checkman=a.id or (a.station like'%'||e.mainstation||'%' and e.mainstation is not null))) and id<>'"+reqman+"' and a.isdelete=0 order by a.seclevel");
	//检查是否存在审批类型的规则
	if(datalist1.size()>0)
	{
	   for(int i=0,size=datalist1.size();i<size;i++){  
		   Map m = (Map) datalist1.get(i);
		   String id=m.get("ID").toString();
		   if(i==0)
		   {
				userid=id;
				username=m.get("OBJNAME").toString();
		   }
		   ids=ids+",\'"+id+"\'"; 
		}    
		sqlwhere="sqlwhere= id in ("+ids+")";
		out.println(sqlwhere+";"+userid+";"+username);
		return;
	}
	datalist1= baseJdbc.executeSqlForList("select ID,OBJNAME,SECLEVEL from humres a where exists(select * from (select c.mainmaj,c.maintype,c.subtype,d.psimtype,d.checkman,d.mainstation from uf_doc_psimmain c,uf_doc_psimsub d where c.requestid=d.requestid and c.mainmaj='"+zy+"' and c.majtype='"+zyfx+"' and (c.subtype='"+lx+"' or c.subtype is null)) e where (e.checkman=a.id or (a.station like'%'||e.mainstation||'%' and e.mainstation is not null))) and id<>'"+reqman+"' and a.isdelete=0 order by a.seclevel");

	//检查是否存在专业方向的规则
	if(datalist1.size()>0)
	{
		for(int i=0,size=datalist1.size();i<size;i++){  
		   Map m = (Map) datalist1.get(i);
		   String id=m.get("ID").toString();
		   if(i==0)
		   {
				userid=id;
				username=m.get("OBJNAME").toString();
		   }
		   ids=ids+",\'"+id+"\'"; 
		}    
		sqlwhere="sqlwhere= id in ("+ids+")";
		out.println(sqlwhere+";"+userid+";"+username);
		return;
	}
	datalist1= baseJdbc.executeSqlForList("select ID,OBJNAME,SECLEVEL from humres a where exists(select * from (select c.mainmaj,c.maintype,c.subtype,d.psimtype,d.checkman,d.mainstation from uf_doc_psimmain c,uf_doc_psimsub d where c.requestid=d.requestid and c.mainmaj='"+zy+"' and c.maintype is null and (c.subtype='"+lx+"' or c.subtype is null)) e where (e.checkman=a.id or (a.station like'%'||e.mainstation||'%' and e.mainstation is not null))) and id<>'"+reqman+"' and a.isdelete=0 order by a.seclevel");
	//检查是否存在有专业的规则
	if(datalist1.size()>0)
	{
		for(int i=0,size=datalist1.size();i<size;i++){  
		   Map m = (Map) datalist1.get(i);
		   String id=m.get("ID").toString();
		   if(i==0)
		   {
				userid=id;
				username=m.get("OBJNAME").toString();
		   }
		   ids=ids+",\'"+id+"\'"; 
		}    
		sqlwhere="sqlwhere= id in ("+ids+")";
		out.println(sqlwhere+";"+userid+";"+username);
		return;
	}
	//都不存上以上取专业总工和部门负责人
	datalist1= baseJdbc.executeSqlForList("select ID,OBJNAME,SECLEVEL from humres a where id in (select id from humres where extselectitemfield7='"+zy+"' and extselectitemfield10='402881182b22d4bc012b23816cfd009d' union all select a.id from humres a where a.orgid=trim('"+reqdept+"') and isdelete=0 and a.station like '%'||(select mstationid from orgunit where id=a.orgid)||'%') and id<>'"+reqman+"' and a.isdelete=0 order by a.seclevel"); 
	//检查是否存在有专业的规则
	if(datalist1.size()>0)
	{
		for(int i=0,size=datalist1.size();i<size;i++){  
		   Map m = (Map) datalist1.get(i);
		   String id=m.get("ID").toString();
		   if(i==0)
		   {
				userid=id;
				username=m.get("OBJNAME").toString();
		   }
		   ids=ids+",\'"+id+"\'"; 
		}    
		sqlwhere="sqlwhere= id in ("+ids+")";
		out.println(sqlwhere+";"+userid+";"+username);
		return;
	}
out.println(sqlwhere+";"+userid+";"+username);
%>