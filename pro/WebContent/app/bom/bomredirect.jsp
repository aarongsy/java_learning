<%@ page contentType="text/html; charset=UTF-8"%><%@ page import="com.eweaver.base.BaseContext" %><%@ page import="com.eweaver.base.BaseJdbcDao" %><%@ page import="com.eweaver.base.*" %><%@ page import="com.eweaver.base.util.*" %><%@ page import="java.util.*" %><%@ include file="/base/init.jsp"%>
<%
	String type = StringHelper.null2String(request.getParameter("type"));
	String sql = "";
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	List ls=null;
	String browserSqlwhere ="sqlwhere=1=1 "; //40288182315f4cb601316022b7153c8d
	String tourl="/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=ff80808131f5d7a70131fa31edcc1d20";
	if(type.equals("lp")||true)	{
	    String userid=eweaveruser.getId();
		String deptid=eweaveruser.getOrgid();
	    //是否是公司领导 
         String companyleaderSql = " select count(1) as total from humres s where s.orgid='HRMDEPARTMENTECOLOGYAA0000000001' and (s.id='"+userid+"' or to_char(s.extmrefobjfield0)='"+userid+"')" ; 
         //是否是部门负责人 
         String orgunitleaderSql = " select count(1) as total from humres h where h.station in(select o.mstationid from orgunit o where o.isdelete=0) and id='"+userid+"' "; 
         int iscpleader = 0; 
         Map comCountMap =(Map) baseJdbc.executeForMap(companyleaderSql);
         iscpleader = NumberHelper.getIntegerValue(comCountMap.get("total")).intValue() ;
         if(iscpleader>0){ 
             //是公司领导 可以查看所有查询权限的礼品 
         }else{ 
             int isorgleader = 0; 
             Map orgCountMap = (Map) baseJdbc.executeForMap(orgunitleaderSql);
             isorgleader = NumberHelper.getIntegerValue(orgCountMap.get("total")).intValue() ;
             if(isorgleader>0){ 
                 //部门负责人 只可以查看查询权限为“部门负责人和所有人”的礼品 
                 browserSqlwhere += " and (AUTHORITY='4028818230b4e3450130b5c576b60696' or AUTHORITY='4028818230b4e3450130b5c576b60695') ";
                 //browserSqlwhere += " and exists (select 1 from uf_gift_info g where uf_gift_store.giftname=g.requestid and (g.AUTHORITY='4028818230b4e3450130b5c576b60696' or g.authority= '4028818230b4e3450130b5c576b60695')) "; 
             }else{ 
                 //不是公司领导，不是部门负责人，就只能查看查询权限为“所有人”的礼品 
                 browserSqlwhere += " and AUTHORITY='4028818230b4e3450130b5c576b60695' ";
                 //browserSqlwhere += " and exists (select 1 from uf_gift_info g where uf_gift_store.giftname=g.requestid and (g.authority= '4028818230b4e3450130b5c576b60695')) "; 
             } 
         }
         int isadmin=0;
		//行政部门和投理部门、公司领导及助理可以查看和领用行政及投理的库。 
         String isadminSql = "select ( ";    
         //人员是否是投理部门或者是行政部门 
         isadminSql +=" (select count(1) from (select * from orgunit g where g.id = '"+deptid+"' and g.id in (select oid "; 
         isadminSql +=" from orgunitlink k start with k.oid = 'HRMDEPARTMENTECOLOGYAA0000000002' connect by prior k.oid = k.pid) "; 
         isadminSql +=" union all ";
         isadminSql +=" select * from orgunit g where g.id = '"+deptid+"' and g.id in ";
         isadminSql +=" (select k.oid from orgunitlink k start with k.oid = 'HRMDEPARTMENTECOLOGYAA0000000004' connect by prior k.oid = k.pid))) +"; 
         //人员是否是公司高管或者高管助理
         isadminSql +=" ("+companyleaderSql+")  ";
         /**** 系统管理员权限暂时不要
         isadminSql +=' +(select count(1) as cou from (select id from humres h where h.hrstatus <> \'402881ea0b1c751a010b1cd0a73e0004\' ';    
         isadminSql +=' and exists (select s.objid from sysuser s where s.id in (select userid from sysuserrolelink l ';    
         isadminSql +=' where l.roleid =\'402881e50bf0a737010bf0a96ba70004\') and mtype = \'2\' and h.station like \'%\' || s.objid || \'%\') ';    
         isadminSql +=' union all select id from humres h where h.hrstatus <>  \'402881ea0b1c751a010b1cd0a73e0004\' ';    
         isadminSql +=' and h.id in (select s.objid from sysuser s where s.id in (select userid from sysuserrolelink l ';    
         isadminSql +=' where l.roleid =\'402881e50bf0a737010bf0a96ba70004\') and mtype = \'1\')) a where a.id = \''+userid+'\')' ; 
         **/
         isadminSql +=" ) as cou ";
         isadminSql +=" from dual ";
         System.out.println(isadminSql);
		 ls = baseJdbc.executeSqlForList(isadminSql);
		 
		if(ls.size()>0){
			Map m = (Map)ls.get(0);
			isadmin = Integer.parseInt(StringHelper.null2String(m.get("cou"),"0"));
		}
		
		if(isadmin>0){
		    System.out.println("11>>"+browserSqlwhere);
			response.sendRedirect(tourl+"&"+browserSqlwhere);
			return;
		}
		else{
		    browserSqlwhere += " and bdept='4028818231402b05013141f634690cdc'";
		    System.out.println("22>>"+browserSqlwhere);
			response.sendRedirect(tourl+"&"+browserSqlwhere);
			return;
		}
	}
%>