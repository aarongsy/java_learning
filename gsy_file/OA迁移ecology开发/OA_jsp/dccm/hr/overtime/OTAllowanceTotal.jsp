<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>


<%@ page import="com.eweaver.app.configsap.SapConnector_EN"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoException"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.sap.conn.jco.JCoStructure"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	

	if ( action.equals("getAllowance") ) {	//OT Allowance查询
		JSONObject jsonObject = new JSONObject();		
		String sdate=StringHelper.null2String(request.getParameter("sdate"));		
		String edate=StringHelper.null2String(request.getParameter("edate"));	
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		if ( !"".equals(sdate) && !"".equals(edate) && !"".equals(requestid) ) {
			String otdate = ds.getSQLValue("select to_char(to_date('"+edate+"','yyyy-MM-dd'),'yyyyMMdd') from dual");
			//String today = ds.getSQLValue("select to_char(sysdate,'yyyyMMdd') from dual");
			String flag = "";
			try {
				Integer subexists = 0;
				//String sql = "select sys_guid(),'"+requestid+"',to_char(rownum,'000') rowsno,rownum,v.otapp,v.flowno,v.jobnametxt,v.jobno,v.empsapid,v.actsdate,v.otreason,v.otcode,v.sapcode,v.nums from (select a.requestid otapp,a.jobnametxt,a.jobno,a.empsapid,a.actsdate,a.flowno,b.otreason,b.otcode,b.sapcode,b.sdate,b.nums,b.id,b.requestid,b.msgty,b.message from uf_dmhr_otapp a,uf_dmhr_otappsub b where a.requestid=b.requestid and a.valid='40288098276fc2120127704884290210' and NVL(b.msgty,'0')!='I' and exists(select 1 from requestbase where id=a.requestid and isdelete=0 and isfinished=1) and to_date(a.actsdate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd') and to_date('"+edate+"','yyyy-MM-dd') order by a.jobno asc, a.actsdate asc,a.flowno asc,b.sapcode asc ) v";
				String sql = "select sys_guid(),'"+requestid+"',to_char(rownum,'000') rowsno,rownum,v.otapp,v.flowno,v.jobnametxt,v.jobno,v.empsapid,v.actsdate,v.otreason,v.otcode,v.sapcode,v.nums from (select a.requestid otapp,a.jobnametxt,a.jobno,a.empsapid,a.actsdate,a.flowno,b.otreason,b.otcode,b.sapcode,b.sdate,b.nums,b.id,b.requestid,b.msgty,b.message from uf_dmhr_otapp a,uf_dmhr_otappsub b where a.requestid=b.requestid and a.valid='40288098276fc2120127704884290210' and exists(select 1 from requestbase where id=a.requestid and isdelete=0 and isfinished=1) and to_date(a.actsdate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd') and to_date('"+edate+"','yyyy-MM-dd') order by a.jobno asc, a.actsdate asc,a.flowno asc,b.sapcode asc ) v";
				System.out.println(sql);
				String sumsql = "";
				
				//删除明细和汇总
				String delsql = "delete from uf_dmhr_allowdetail where requestid='"+requestid+"'";
				Integer excuteflag = baseJdbcDao.update(delsql);
				delsql = "delete from uf_dmhr_allowtotal where requestid='"+requestid+"'";
				excuteflag = baseJdbcDao.update(delsql);
				
				List list = baseJdbcDao.executeSqlForList(sql);	
				if ( list.size() > 0 ) {
					StringBuffer buffer = new StringBuffer(512);
					subexists = Integer.valueOf(ds.getSQLValue("select count(*) hadnum from uf_dmhr_allowdetail where requestid='"+requestid+"'")); 
					if(subexists==0){
						//新增明细
						buffer = new StringBuffer(512);
						buffer.append("insert into uf_dmhr_allowdetail ");
						buffer.append("(id,requestid,rowindex,sno,otapp,otappno,jobnametxt,jobno,empsapid,actsdate,otreason,allowname,allowcode,nums) ");
						buffer.append(" ( ").append(sql).append(")");
						String upsubsql = buffer.toString();
						
						excuteflag = baseJdbcDao.update(upsubsql);
						//System.out.println(" excuteflag="+excuteflag +" upsubsql="+ upsubsql);
						
						//sumsql = "select sys_guid(),'"+requestid+"',to_char(rownum,'000') rowsno,rownum,v.jobnametxt,v.jobno,v.empsapid,'"+today+"',v.allowcode,v.nums from (select empsapid,jobnametxt,jobno,allowcode,sum(nums) nums from uf_dmhr_allowdetail where requestid='"+requestid+"' group by empsapid,jobnametxt,jobno,allowcode order by empsapid asc,allowcode asc) v ";
						sumsql = "select sys_guid(),'"+requestid+"',to_char(rownum,'000') rowsno,rownum,v.jobnametxt,v.jobno,v.empsapid,'"+otdate+"',v.allowcode,v.nums from (select empsapid,jobnametxt,jobno,allowcode,sum(nums) nums from uf_dmhr_allowdetail where requestid='"+requestid+"' group by empsapid,jobnametxt,jobno,allowcode order by empsapid asc,allowcode asc) v ";
						subexists = Integer.valueOf(ds.getSQLValue("select count(*) hadnum from uf_dmhr_allowtotal where requestid='"+requestid+"'"));
						if(subexists==0){
							//新增汇总
							buffer = new StringBuffer(512);
							buffer.append("insert into uf_dmhr_allowtotal ");
							buffer.append("(id,requestid,rowindex,sno,jobnametxt,jobno,empsapid,otdate,sapcode,nums) ");
							buffer.append(" ( ").append(sumsql).append(")");
							upsubsql = buffer.toString();
							excuteflag = baseJdbcDao.update(upsubsql);
							//System.out.println(" excuteflag="+excuteflag +" upsubsql="+ upsubsql);
						}
						
					}
					jsonObject.put("info","successful");	
					jsonObject.put("msg","true");
				}else{
					flag = "error@No OT Allowance Detail";
					jsonObject.put("info","No OT Allowance Detail");	
					jsonObject.put("msg","false");
				}
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());	
				jsonObject.put("msg","false");				
			}

		}else{
			jsonObject.put("info","Parameter error");	
			jsonObject.put("msg","false");
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();		
	}
	
%>