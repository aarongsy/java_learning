<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>
<%@ page contentType="text/html; charset=UTF-8"%>
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
<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String shipping=StringHelper.null2String(request.getParameter("shipping"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	JSONObject jo = new JSONObject();	
	if ( !"".equals(shipping) ) {
		shipping = "DCE180002";
	} 
	//清空历史数据
	//String sql = "delete from uf_dmsd_loadtally   where requestid='"+requestid+"'";
	//baseJdbc.update(sql);
	//更新主表
	//sql = "update uf_dmsd_expboxmain  set stuffingflag='0' where requestid='"+requestid+"'";
	//baseJdbc.update(sql);
	
	DataService otherdataservices = new DataService();
	otherdataservices._setJdbcTemplate(BaseContext.getJdbcTemp("ecology"));	
	DataService ds = new DataService();	
	String where="";
	
	String ghlrsql = "select a.id,case when a.sfyg=0 then 'NO' when a.sfyg=1 then 'YES' else '' end iscon,a.shipping,a.cabtype,a.amount cabum from uf_ghlr a where a.shipping='"+shipping+"' ";
	String ghlrdetailsql = "";
	String stuffdetailsql = "";
	List ghlrlist = otherdataservices.getValues(ghlrsql);  
	int count = 0;
 try {
	if ( ghlrlist.size()>0 ){
		Map m = (Map)ghlrlist.get(0);
		String iscon = StringHelper.null2String(m.get("iscon"));
		String id = StringHelper.null2String(m.get("id"));
		String cabtype = StringHelper.null2String(m.get("cabtype"));
		String cabtypeid = "";
		if( !"".equals(cabtype) ) {
			cabtypeid = ds.getSQLValue("select requestid from uf_dmdb_cabtype where cabtype='"+cabtype+"' and rownum=1");
		}
		
		String cabum = StringHelper.null2String(m.get("cabum"));
		if ( "YES".equals(iscon) ) { //有柜明细1
			ghlrdetailsql = "select b.code,b.cj cbm,'NO' sfpg,b.fqh sealno from uf_ghlr_dt1 b where b.mainid="+id+" and b.sfyx=1 ";			
		} else if ( "NO".equals(iscon) ) { //无柜明细1
			ghlrdetailsql = "select b.code,b.cj cbm,case when b.sfpg=0 then 'NO' when b.sfpg=1 then 'YES' else '' end sfpg,'' sealno from uf_ghlr_dt2 b where b.mainid="+id+" and b.sfyx=1 ";
		}
		if ( !"".equals(ghlrdetailsql)  ) { 
			List ghlrdetaillist = otherdataservices.getValues(ghlrdetailsql);  
			if ( ghlrdetaillist.size()>0 ){  //柜号录入不为空
				for ( int i=0; i<ghlrdetaillist.size();i++  ) { //按每个柜子循环查找stuffing order
					Map detailmap = (Map)ghlrdetaillist.get(i);
					String containerno = StringHelper.null2String(detailmap.get("code"));
					String sfpg = StringHelper.null2String(detailmap.get("sfpg"));
					String cbm = StringHelper.null2String(detailmap.get("cbm"));
					String sealno = StringHelper.null2String(detailmap.get("sealno"));
					if ( "YES".equals(iscon)   ) { //有柜
						stuffdetailsql = "select a.id,b.jydh sapdono,b.xc sapdoitem,b.wlh,b.wlms grade,b.dw unitcode,b.dwms unitdesc,b.sapph sapbatchno,b.SALEORDER sapsono,b.ORDERITEM sapsoitem, b.shipno,b.bczxsl,b.lljz nw,b.ZZWEIGHT packweight,(b.lljz +b.ZZWEIGHT) gw  from formtable_main_43 a,formtable_main_43_dt1 b where a.id=b.mainid and a.shipping='"+shipping+"' and a.gh='"+containerno+"' and a.sfyg=1 and a.sfzf=0 and b.shipno='"+shipping+"'";
						
					} else if ( "NO".equals(iscon)   ) { //无柜
						stuffdetailsql = "select a.id,b.jydh sapdono,b.xc sapdoitem,b.wlh,b.wlms grade,b.dw unitcode,b.dwms unitdesc,b.sapph sapbatchno,b.SALEORDER sapsono,b.ORDERITEM sapsoitem, b.shipno,b.bczxsl,b.lljz nw,b.ZZWEIGHT packweight,(b.lljz +b.ZZWEIGHT) gw  from formtable_main_43 a,formtable_main_43_dt1 b where a.id=b.mainid and instr(a.pgshipping, '"+shipping+"')>0 and a.xngh='"+containerno+"' and a.sfyg=1 and a.sfzf=0 and b.shipno='"+shipping+"'";
					}
					if (  !"".equals(stuffdetailsql)   ) {
						List stuffdetaillist = otherdataservices.getValues(stuffdetailsql);  
						if ( stuffdetaillist.size()>0 ){ 
							for ( int j=0; j<stuffdetaillist.size();j++  ) {
								count ++;
								System.out.println("查询到的stuffdetaillist 明细 j="+j);
								Map stuffdetailmap = (Map)stuffdetaillist.get(j);
								String stuffmainid = StringHelper.null2String(stuffdetailmap.get("id"));
								String sapdono = StringHelper.null2String(stuffdetailmap.get("sapdono"));
								System.out.println("sapdono="+sapdono);
								String sapdoitem = StringHelper.null2String(stuffdetailmap.get("sapdoitem"));
								System.out.println("sapdoitem="+sapdoitem);
								String wlh = StringHelper.null2String(stuffdetailmap.get("wlh"));
								System.out.println("wlh="+wlh);
								String grade = StringHelper.null2String(stuffdetailmap.get("grade"));
								System.out.println("grade="+grade);
								String unitcode = StringHelper.null2String(stuffdetailmap.get("unitcode"));
								System.out.println("unitcode="+unitcode);
								String unitdesc = StringHelper.null2String(stuffdetailmap.get("unitdesc"));
								System.out.println("unitdesc="+unitdesc);
								String sapbatchno = StringHelper.null2String(stuffdetailmap.get("sapbatchno"));
								System.out.println("sapbatchno="+sapbatchno);
								String sapsono = StringHelper.null2String(stuffdetailmap.get("sapsono"));
								System.out.println("sapsono="+sapsono);
								String sapsoitem = StringHelper.null2String(stuffdetailmap.get("sapsoitem"));
								System.out.println("sapsoitem="+sapsoitem);
								String shipno = StringHelper.null2String(stuffdetailmap.get("shipno"));
								System.out.println("shipno="+shipno);
								String bczxsl = StringHelper.null2String(stuffdetailmap.get("bczxsl"));
								System.out.println("bczxsl="+bczxsl);
								String nw = StringHelper.null2String(stuffdetailmap.get("nw"));
								System.out.println("nw="+nw);
								String gw = StringHelper.null2String(stuffdetailmap.get("gw"));
								System.out.println("gw="+gw);
								
								String shipdate = "";
								
								String plansql ="select a.ygshipno,a.ghcx,a.zxjhh planno,a.cp lorryno, a.gbrq ponddate,a.sjysrq actshipdate,a.yglhbhcx,b.gbh,b.fqh from  formtable_main_45 a, formtable_main_45_dt1 b where a.id=b.mainid and a.ygshipno='"+shipping+"'  and instr(a.ghcx,'"+containerno+"' )>0 and   a.sfyg=1 and a.sfzf=0 and NVL(a.zxjhh,'0')！='0' and yglhbhcx is null and b.gbh='"+containerno+"'";
								List planlist = otherdataservices.getValues(plansql);
								if ( planlist.size()>0 ){ 
									Map planmap = (Map)planlist.get(0);
									sealno =  StringHelper.null2String(planmap.get("fqh"));
									System.out.println("sealno="+sealno);
									shipdate = StringHelper.null2String(planmap.get("ponddate"));
									System.out.println("shipdate="+shipdate);
									//jo.put("msg","true");
									//jo.put("info","ecology ：shipping="+shipping+" 柜号="+containerno + "找到了对应的装卸计划柜明细");
								}
								String insql = "insert into uf_dmsd_loadtally(id,requestid,sno,cabtype,gxtxt,cbm,boxno,sealno,jyordno,jyitem,materno,materdes,pc,quantity,saleunit,nw,gw,shipdate)values('"+IDGernerator.getUnquieID()+"','"+requestid+"',"+count+",'"+cabtypeid+"','"+cabtype+"','"+cbm+"','"+containerno+"','"+sealno+"','"+sapdono+"','"+sapdoitem+"','"+wlh+"','"+grade+"','"+sapbatchno+"','"+bczxsl+"','"+unitcode+"','"+nw+"','"+gw+"','"+shipdate+"')";
								//baseJdbc.update(insql);
								System.out.println(insql);
								
							}
							jo.put("msg","true");
							jo.put("info","ecology ：shipping="+shipping+" 柜号="+containerno + "找到了对应的装柜理货清单明细");
						}else{
							jo.put("msg","false");
							jo.put("info","ecology ：shipping="+shipping+" 柜号="+containerno + " 没有对应的装柜理货清单");
						}
					}else{
						jo.put("msg","false");
						jo.put("info","ecology柜号录入的是否有柜没有值，无法继续查询理货清单");
					}
				}
			}else{
				jo.put("msg","false");
				jo.put("info","ecology没有对应的柜号录入的明细信息");
			}
		}else{
			jo.put("msg","false");
			jo.put("info","ecology柜号录入的是否有柜没有值，无法继续");
		}
	}else{
		jo.put("msg","false");
		jo.put("info","ecology没有对应的柜号录入信息");
	}
  } catch (Exception e) {
		// TODO Auto-generated catch block
		jo.put("msg","false");
		e.printStackTrace();
  }
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>