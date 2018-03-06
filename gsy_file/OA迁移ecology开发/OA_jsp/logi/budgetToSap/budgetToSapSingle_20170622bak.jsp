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
<%@ page import="com.eweaver.app.weight.service.Uf_lo_toSapService"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>


<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	Humres currentuser = eweaveruser.getHumres();
	String userid=currentuser.getId();//当前用户
	
	String action=StringHelper.null2String(request.getParameter("action"));	
	response.setContentType("application/json; charset=utf-8");	
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	
	
	String username = ds.getSQLValue("select objname || '/' || objno from humres where id='"+userid+"'");
	if (action.equals("budgetToSAPSingle")){	//物流费用申请抛SAP，单笔手工上抛
		JSONObject jsonObject = new JSONObject();		
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		//Boolean force=new Boolean(StringHelper.null2String(request.getParameter("force")));	
		String sql = "select a.requestid,a.invoiceno,a.loadplanno,a.createdate from uf_lo_budget a where a.requestid='"+requestid+"' and a.invoicestatue='402864d149e039b10149e080b01600c0' and exists(select 1 from formbase where id=a.requestid and isdelete=0) ";

		List list = baseJdbcDao.executeSqlForList(sql);
		if ( list.size()>0 ) {		      
			Uf_lo_toSapService app = new Uf_lo_toSapService();
			String starttime = ds.getSQLValue("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual");
			String endtime = "";
			String currentime = "";
			String delaymin = ds.getSQLValue("select delaymin from uf_lo_budgettosappara where rownum=1");

			Map map = (Map)list.get(0);
			String invoiceno = StringHelper.null2String(map.get("invoiceno"));
			String loadplanno = StringHelper.null2String(map.get("loadplanno"));			
			//String requestid = StringHelper.null2String(map.get("requestid"));
			String lastday = ds.getSQLValue("select to_char(last_day(trunc(sysdate)),'YYYY-MM-DD') lastday from dual");
			String today = ds.getSQLValue("select to_char(sysdate,'YYYY-MM-DD') from dual");
			try {
				String createdate = StringHelper.null2String(map.get("createdate"));
				String chktime = "";
				Boolean tosapflag = true;
				if ( today.equals(lastday)  ) {
					if ( createdate.equals(today) ) {
						String createtime =  ds.getSQLValue("select (createdate || ' ' ||  createtime) cretime from formbase id='"+requestid+"'");
						currentime = ds.getSQLValue("select to_char(sysdate,'YYYY-MM-DD hh24:mi:ss') curtime from dual");
						chktime = ds.getSQLValue("select to_char((to_date('"+createtime+"','yyyy-MM-dd hh24:mi:ss')+"+delaymin+"/60/24),'YYYY-MM-DD hh24:mi:ss') chktime  from dual");
						chktime = ds.getSQLValue("select case when ('"+currentime+"'>'"+chktime+"') then 1 else 0 from dual");
						if ( "1".equals(chktime) ) {
							tosapflag = false;
						}
					}
				}
				String str = invoiceno +" "+loadplanno;

				if ( tosapflag) {
					String a = app.budgetToSapByRequestid(requestid, username);
					//System.out.println("tosapflag="+tosapflag);
					System.out.println("str="+str + "  a="+a);
					jsonObject.put(str, a);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			endtime = ds.getSQLValue("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual");			
			StringBuffer buffer = new StringBuffer(512);
			buffer = new StringBuffer(512);
			buffer.append("insert into uf_lo_tosaplog ");
			buffer.append("(id,requestid,typename,autoflag,result,stime,etime,psn) values ");	
			buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
			buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
			buffer.append("'暂估费用上传',");
			buffer.append("'手动单笔',");
			buffer.append("'").append(jsonObject.toString()).append("',");			
			buffer.append("'").append(starttime).append("',");
			buffer.append("'").append(endtime).append("',");
			buffer.append("'").append(username).append("')");
			String upsql = buffer.toString();
			baseJdbcDao.update(upsql);
		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}	
%>