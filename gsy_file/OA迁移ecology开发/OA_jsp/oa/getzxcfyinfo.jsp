<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DecimalFormat" %>

<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>

<%
 
	//String requestid = StringHelper.null2String(request.getParameter("requestid"));//requestid
	String thedate = StringHelper.null2String(request.getParameter("thedate"));//日期
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    //System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
	String delsql = " delete uf_oa_zxcfydetail ";
	baseJdbc.update(delsql);

	String sql = "select distinct v1.comtype,v1.comcode,v1.zcjm,count(v.bltype) gszy from uf_oa_zxcodemtainz v right join (select a.requestid,a.comtype comtype,a.comcode comcode,decode(decode((select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010'),'',(select zccode from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010'),(select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010')),'',(select zccode from uf_oa_zxcckmtain where requestid=a.zccode and comcode<>'1010'),decode((select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010'),'',(select zccode from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010'),(select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=a.zccode and comcode='1010'))) zcjm from uf_oa_zxcodemtainz a left join formbase b on b.id=a.requestid where a.bltype='40285a8d531bf8a601532bb2739036ad' and a.useless='40288098276fc2120127704884290211' and substr(b.createdate,0,7)<='"+thedate+"'  and (0=(select isdelete from formbase where id=a.requestid) or 1=(select isdelete from formbase where id=a.requestid and modifydate>='"+thedate+"')))v1 on v1.requestid=v.requestid group by  v1.comtype,v1.comcode,v1.zcjm";   // …………公司部门等相同…………
	List list = baseJdbc.executeSqlForList(sql);
	if( list.size() > 0 )
	{
		for( int i = 0 ; i < list.size() ; i++ )
		{
			Map map = (Map)list.get(i);
			String comtype = StringHelper.null2String(map.get("comtype"));//公司名称
			String comcode = StringHelper.null2String(map.get("comcode"));//公司代码
			String zcjm = StringHelper.null2String(map.get("zcjm"));//制程编码
			String gszy = StringHelper.null2String(map.get("gszy"));//公司自有数量
			Double wxsum = 0.00;   //维修数量
			Double jine = 0.00;    //维修金额
			Double gailv = 0.00;

			String sql2 = "select distinct v2.reqdate,v2.comtype2,v2.comcode2,v2.zcjm2,count(distinct v2.bnum) wxsl2,sum(v2.taxamount) jine2 from uf_oa_zxcodemtainz e right join (select d.requestid,v1.reqdate,d.comtype comtype2,d.comcode comcode2,v1.bnum,v1.taxamount,decode(decode((select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010'),'',(select zccode from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010'),(select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010')),'',(select zccode from uf_oa_zxcckmtain where requestid=d.zccode and comcode<>'1010'),decode((select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010'),'',(select zccode from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010'),(select substr(zccode,1,instr(zccode,'-')-1) from uf_oa_zxcckmtain where requestid=d.zccode and comcode='1010'))) zcjm2 from uf_oa_zxcodemtainz d left join (select v.taxamount,v.reqdate,c.bnum from uf_oa_goodsdetailapp c  left join (select a.reqappflowno,a.colno,a.taxamount,to_char(to_date(b.reqdate,'yyyy-MM-dd HH24:MI:SS'),'yyyy-MM') reqdate from  uf_oa_gensupcheckdetail a,uf_oa_supaccountcheck b where b.requestid=a.requestid and exists(select 1 from requestbase where id=a.requestid and isdelete=0)) v on v.reqappflowno=c.requestid and v.colno=c.no where c.bnum is not null and exists(select 1 from requestbase where id=c.requestid and isdelete=0)) v1 on v1.bnum=d.requestid where v1.reqdate='"+thedate+"') v2 on e.requestid=v2.requestid group by v2.reqdate,v2.comtype2,v2.comcode2,v2.zcjm2";
			List list2 = baseJdbc.executeSqlForList(sql2);
			if ( list2.size() > 0 )
			{
				for( int j = 0 ; j < list2.size() ; j++ )
				{
					Map map2 = (Map)list2.get(j);
					String comtype2 = StringHelper.null2String(map2.get("comtype2"));//公司名称
					String comcode2 = StringHelper.null2String(map2.get("comcode2"));//公司代码
					String zcjm2 = StringHelper.null2String(map2.get("zcjm2"));//部门
					String wxsl2 = StringHelper.null2String(map2.get("wxsl2"));//维修数量
					String jine2 = StringHelper.null2String(map2.get("jine2"));//维修金额
					
					if (comtype2.equals(comtype))
					{
						if(zcjm2.equals(zcjm))
						{
							wxsum = Double.valueOf(wxsl2);
							jine = Double.valueOf(jine2);
							break;
						}
					}
				}
			}
			
			Double zong = Double.valueOf(gszy);
			gailv = (wxsum/zong)*100;
		  
		    DecimalFormat format = new DecimalFormat("0.00");
			String gailv2 = format.format(gailv);

			String insql = "insert into uf_oa_zxcfydetail (id,requestid,no,company,cocode,zccode,zysum,wxsum,wxmon,gailv)values('"+IDGernerator.getUnquieID()+"','40285a90589efb750158adeb75115ae9','"+(i+1)+"','"+comtype+"','"+comcode+"','"+zcjm+"','"+gszy+"','"+wxsum+"','"+jine+"','"+gailv2+"%')";
			System.out.println(insql);
			baseJdbc.update(insql);
		}
	}

	JSONObject jo = new JSONObject();		
	//jo.put("sum", gszy);
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
