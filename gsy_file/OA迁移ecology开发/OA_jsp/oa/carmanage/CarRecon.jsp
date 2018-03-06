<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@page import="jxl.biff.IntegerHelper"%>

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
<%@ page import="java.math.BigDecimal"%>

<%
	EweaverUser eweaveruser = BaseContext.getRemoteUser();
	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	String action=StringHelper.null2String(request.getParameter("action"));
	String flowno=StringHelper.null2String(request.getParameter("flowno"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));	
	String imtype = StringHelper.null2String(request.getParameter("imtype"));	
	
	String wjcstyle = "";
	String czcstyle = "";	
	StringBuffer buf = new StringBuffer();
	String delsql = "";
	String sql = "";
	
String err = "";
JSONObject jo = new JSONObject();	

	String cartype=StringHelper.null2String(request.getParameter("cartype"));
	String stcomcode=StringHelper.null2String(request.getParameter("comcode"));
	String supplyname=StringHelper.null2String(request.getParameter("supplyname"));
	String carno=StringHelper.null2String(request.getParameter("carno"));
	String sdate=StringHelper.null2String(request.getParameter("sdate"));	
	String edate=StringHelper.null2String(request.getParameter("edate"));		
	
	if(!requestid.equals("")){
		//清空历史数据
		delsql = "delete from uf_oa_carreconsub where requestid='"+requestid+"'";
		baseJdbc.update(delsql);	
		if(action.equals("search")){
			//更新主表
			delsql = "update uf_oa_carreconapp set imtype='1' where requestid='"+requestid+"'";
			baseJdbc.update(delsql);	
		}
	}
	
	if(cartype.equals("40285a8f489c17ce0149070983113560")){
		wjcstyle = "block";
		czcstyle = "none";
	}
	if(cartype.equals("40285a8f489c17ce0149070983113561")){
		wjcstyle = "none";
		czcstyle = "block";	
	}
	if(cartype.equals("") ){
		wjcstyle = "block";
		czcstyle = "block";
	}
	String comcodewhere = "";
	String reconwhere = "";
	if(!stcomcode.equals("")){    
		comcodewhere = " and  b.comcode='"+stcomcode+"' ";   
		reconwhere = " and a.comcode='"+stcomcode+"'";
	} 

	if(cartype.equals("40285a8f489c17ce0149070983113560") && action.equals("search")){
		sql = "select a.flowno,a.requestid,a.arrsdate,a.isreturn,a.carmodel,a.arrstime,a.arretime,a.totalpsn,a.carno,a.driver,a.drivertel,a.supplyname,a.actroute,a.isbaoche,a.mile miletotal,a.gpsmile gpsmiletotal,a.actmile actmiletotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c62' and c.requestid=a.requestid) bcftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c5f' and c.requestid=a.requestid) jbftotal, (select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c60' and c.requestid=a.requestid) dbftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c65' and c.requestid=a.requestid) glftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c66' and c.requestid=a.requestid) tcftotal, (select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c63' and c.requestid=a.requestid) yftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c61' and c.requestid=a.requestid) fjftotal,(select c.remark from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c61' and c.requestid=a.requestid) fjfyy,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c64' and c.requestid=a.requestid) zcftotal,(select sum(c.amount) from uf_oa_cararrfee c where c.requestid=a.requestid) amounttotal,(select sum(c.notax) from uf_oa_cararrfee c where c.requestid=a.requestid) notaxtotal,(select sum(c.tax) from uf_oa_cararrfee c where c.requestid=a.requestid) taxtotal from uf_oa_cararrange a where a.cartype='"+cartype+"' and to_date(a.arrsdate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd') and to_date('"+edate+"','yyyy-MM-dd') and a.supplyname='"+supplyname+"' and (a.stateflag=3 or a.stateflag=5) order by a.arrsdate asc,a.arrstime asc";
		//System.out.println("wjc search sql="+sql);
	}
	if(cartype.equals("40285a8f489c17ce0149070983113561")  && action.equals("search")){
		sql = "select a.flowno,a.requestid,a.arrsdate,a.isreturn,a.carmodel,a.arrstime,a.arretime,a.totalpsn,a.carno,a.driver,a.drivertel,a.supplyname,a.actroute,a.isbaoche,a.mile miletotal,a.gpsmile gpsmiletotal,a.actmile actmiletotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c62' and c.requestid=a.requestid) bcftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c5f' and c.requestid=a.requestid) jbftotal, (select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c60' and c.requestid=a.requestid) dbftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c65' and c.requestid=a.requestid) glftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c66' and c.requestid=a.requestid) tcftotal, (select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c63' and c.requestid=a.requestid) yftotal,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c61' and c.requestid=a.requestid) fjftotal,(select c.remark from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c61' and c.requestid=a.requestid) fjfyy,(select c.amount from uf_oa_cararrfee c where c.feename='40285a904a56bc58014a6f992c652c64' and c.requestid=a.requestid) zcftotal,(select sum(c.amount) from uf_oa_cararrfee c where c.requestid=a.requestid) amounttotal,(select sum(c.notax) from uf_oa_cararrfee c where c.requestid=a.requestid) notaxtotal,(select sum(c.tax) from uf_oa_cararrfee c where c.requestid=a.requestid) taxtotal from uf_oa_cararrange a where a.cartype='"+cartype+"' and to_date(a.arrsdate,'yyyy-MM-dd') between to_date('"+sdate+"','yyyy-MM-dd') and to_date('"+edate+"','yyyy-MM-dd') and a.supplyname='"+supplyname+"' and a.carno='"+carno+"' and (a.stateflag=3 or a.stateflag=5) order by a.arrsdate asc,a.arrstime asc";
		//System.out.println("CZC search sql="+sql);
	}
	if(action.equals("show")){
		sql = "select a.comcode,a.cararrno requestid,(select flowno from uf_oa_cararrange where requestid=a.cararrno) flowno,a.arrsdate,a.costdept,a.costcenter,a.appuser,a.feeaccount,a.innerorder,a.approute,a.actroute,a.isreturn,a.isbaoche,a.carmodel,a.mile,a.gpsmile,a.actmile,a.bcf,a.jbf,a.dbf,a.glf,a.tcf,a.yf,a.fjf,a.zcf,a.amount,a.notax,a.tax,a.fjfyy,a.appstime,a.appetime,a.arrstime,a.arretime,a.gotonum,a.backnum,a.totalpsn,a.ratio,a.carno,a.driver,a.drivertel,a.supplyname,a.carappno,a.detailno,a.reason from uf_oa_forcarreconsub a where a.flowno='"+flowno+"' order by a.no asc";
	}
	if(action.equals("doselect")){
		sql = "select a.comcode,a.cararrno requestid,(select flowno from uf_oa_cararrange where requestid=a.cararrno) flowno,a.arrsdate,a.costdept,a.costcenter,a.appuser,a.feeaccount,a.innerorder,a.approute,a.actroute,a.isreturn,a.isbaoche,a.carmodel,a.mile,a.gpsmile,a.actmile,a.bcf,a.jbf,a.dbf,a.glf,a.tcf,a.yf,a.fjf,a.zcf,a.amount,a.notax,a.tax,a.fjfyy,a.appstime,a.appetime,a.arrstime,a.arretime,a.gotonum,a.backnum,a.totalpsn,a.ratio,a.carno,a.driver,a.drivertel,a.supplyname,a.carappno,a.detailno,a.reason from uf_oa_forcarreconsub a where a.flowno='"+flowno+"' " +reconwhere +" order by a.no asc";
	}
	List list = baseJdbc.executeSqlForList(sql);

	//清空历史数据
	delsql = "delete from uf_oa_forcarreconsub where flowno='"+flowno+"'";	
	baseJdbc.update(delsql);	
	if((cartype.equals("40285a8f489c17ce0149070983113561") ||  cartype.equals("40285a8f489c17ce0149070983113560")) && action.equals("search")){	
		if(!stcomcode.equals("")){  
			buf.append("<TR><TD colspan=40>搜索前请确保已清空公司代码！</TD></TR>");
			return;
		}
		if(list.size()>0){	
			int no=0;
			for(int k=0;k<list.size();k++){
				Map map = (Map)list.get(k);						
				String cararrid = StringHelper.null2String(map.get("requestid"));
				String cararrno = StringHelper.null2String(map.get("flowno"));
				String arrsdate = StringHelper.null2String(map.get("arrsdate"));			
				String actroute = StringHelper.null2String(map.get("actroute"));
				String isreturn = StringHelper.null2String(map.get("isreturn"));
				String isbaoche = StringHelper.null2String(map.get("isbaoche"));				
				String carmodel = StringHelper.null2String(map.get("carmodel"));
				String arrstime = StringHelper.null2String(map.get("arrstime"));
				String arretime = StringHelper.null2String(map.get("arretime"));
				String totalpsn = StringHelper.null2String(map.get("totalpsn"));
				String pccarno = StringHelper.null2String(map.get("carno"));					
				String driver = StringHelper.null2String(map.get("driver"));
				String drivertel = StringHelper.null2String(map.get("drivertel"));	
	
				String fjfyy = StringHelper.null2String(map.get("fjfyy"));	

				String bcftotal = StringHelper.null2String(map.get("bcftotal"));	
				String jbftotal = StringHelper.null2String(map.get("jbftotal"));	
				String dbftotal = StringHelper.null2String(map.get("dbftotal"));	
				String glftotal = StringHelper.null2String(map.get("glftotal"));	
				String tcftotal = StringHelper.null2String(map.get("tcftotal"));	
				String yftotal = StringHelper.null2String(map.get("yftotal"));	
				String fjftotal = StringHelper.null2String(map.get("fjftotal"));	
				String zcftotal = StringHelper.null2String(map.get("zcftotal"));
				String miletotal = StringHelper.null2String(map.get("miletotal"));	
				String gpsmiletotal = StringHelper.null2String(map.get("gpsmiletotal"));	
				String actmiletotal = StringHelper.null2String(map.get("actmiletotal"));	
				String amounttotal = StringHelper.null2String(map.get("amounttotal"));	
				String notaxtotal = StringHelper.null2String(map.get("notaxtotal"));	
				String taxtotal = StringHelper.null2String(map.get("taxtotal"));	
				
				BigDecimal pcdbcf = new BigDecimal(bcftotal==""?"0":bcftotal);
				BigDecimal pcdjbf = new BigDecimal(jbftotal==""?"0":jbftotal);
				BigDecimal pcddbf = new BigDecimal(dbftotal==""?"0":dbftotal);
				BigDecimal pcdglf = new BigDecimal(glftotal==""?"0":glftotal);
				BigDecimal pcdtcf = new BigDecimal(tcftotal==""?"0":tcftotal);
				BigDecimal pcdyf = new BigDecimal(yftotal==""?"0":yftotal);
				BigDecimal pcdfjf = new BigDecimal(fjftotal==""?"0":fjftotal);
				BigDecimal pcdzcf = new BigDecimal(zcftotal==""?"0":zcftotal);
				BigDecimal pcdmile = new BigDecimal(miletotal==""?"0":miletotal);
				BigDecimal pcdgpsmile = new BigDecimal(gpsmiletotal==""?"0":gpsmiletotal);
				BigDecimal pcdactmile = new BigDecimal(actmiletotal==""?"0":actmiletotal);
				BigDecimal pcdamount = new BigDecimal(amounttotal==""?"0":amounttotal);
				BigDecimal pcdnotax = new BigDecimal(notaxtotal==""?"0":notaxtotal);
				BigDecimal pcdtax= new BigDecimal(taxtotal==""?"0":taxtotal);
				
				//System.out.println("pcdxx k="+k + " pcdbcf="+pcdbcf+"  pcdjbf="+pcdjbf +"  pcddbf="+pcddbf + "  pcdglf="+pcdglf+ " pcdtcf="+pcdtcf + "  pcdyf="+pcdyf + " pcdfjf="+pcdfjf+" pcdzcf="+pcdzcf + " pcdmile="+pcdmile+"  pcdgpsmile="+pcdgpsmile+"  pcdactmile="+pcdactmile);

				String detailsql = "select vf.comcode,vf.costdept,vf.costcenter,vf.appuser,vf.feeaccount,vf.innerorder,app.planroute approute,vf.mile,vf.gpsmile,vf.actmile,vf.bcf,vf.jbf,vf.dbf ,vf.glf,vf.tcf,vf.yf ,vf.fjf,vf.zcf,(vf.bcf+vf.jbf+vf.dbf+vf.glf+vf.tcf+vf.yf +vf.fjf+vf.zcf) amount,vf.notax,vf.tax,app.stime appstime,app.etime appetime,app.reason,u.gotonum,u.backnum,vf.ratio,u.carappno,u.detailno from (select  a.requestid,b.comcode,b.costdept,b.costcenter,b.appuser,b.feeaccount,b.innerorder,round("+pcdmile+"*b.ratio,0) mile,round("+pcdgpsmile+"*b.ratio,0) gpsmile,round("+pcdactmile+"*b.ratio,0) actmile,round("+pcdbcf+"*b.ratio,0) bcf,round("+pcdjbf+"*b.ratio,0) jbf,round("+pcddbf+"*b.ratio,0) dbf ,round("+pcdglf+"*b.ratio,0) glf,round("+pcdtcf+"*b.ratio,0) tcf,round("+pcdyf+"*b.ratio,0) yf ,round("+pcdfjf+"*b.ratio,0) fjf,round("+pcdzcf+"*b.ratio,0) zcf ,b.amount,b.notax,round("+pcdtax+"*b.ratio,0) tax,b.ratio,b.rowindex,b.detailno from uf_oa_cararrange a,uf_oa_carfeeshare b where a.requestid=b.requestid and a.requestid='"+cararrid+"' and  (b.stateflag is null or b.stateflag='40288098276fc2120127704884290211') and b.reconno is null "+comcodewhere+" ) vf left join uf_oa_cararruser u on vf.detailno = u.detailno and vf.requestid=u.requestid left join uf_oa_carapp app on app.requestid=u.carappno order by vf.rowindex";
				//System.out.println("CZC search detailsql="+detailsql);
				List Detaillist = baseJdbc.executeSqlForList(detailsql);
				if(Detaillist.size()>0){						
					BigDecimal tmpbcf = new BigDecimal(0);
					BigDecimal tmpjbf = new BigDecimal(0);
					BigDecimal tmpdbf = new BigDecimal(0);
					BigDecimal tmpglf = new BigDecimal(0);
					BigDecimal tmptcf = new BigDecimal(0);
					BigDecimal tmpyf = new BigDecimal(0);
					BigDecimal tmpfjf = new BigDecimal(0);
					BigDecimal tmpzcf = new BigDecimal(0);
					BigDecimal tmpmile = new BigDecimal(0);
					BigDecimal tmpgpsmile = new BigDecimal(0);
					BigDecimal tmpactmile = BigDecimal.valueOf(0);	
					BigDecimal tmpamount = new BigDecimal(0);
					BigDecimal tmpnotax= new BigDecimal(0);
					BigDecimal tmptax = BigDecimal.valueOf(0);					
					
					for(int j=0;j<Detaillist.size();j++){
						no = no+1;
						Map dmap = (Map)Detaillist.get(j);	
						String comcode = StringHelper.null2String(dmap.get("comcode"));
						String costdept = StringHelper.null2String(dmap.get("costdept"));					
						String costcenter = StringHelper.null2String(dmap.get("costcenter"));						
						String appuser = StringHelper.null2String(dmap.get("appuser"));
						String feeaccount = StringHelper.null2String(dmap.get("feeaccount"));
						
						String newcost = costcenter.replaceFirst("^0*", "");
						String innerorder = "";
						if(newcost.startsWith("10163") || newcost.startsWith("20163") || newcost.startsWith("30163") || newcost.startsWith("50163") || newcost.startsWith("60163")){
							innerorder = StringHelper.null2String(dmap.get("innerorder"));
						}	
						//2016-09-01 xxy add 盘锦厂事由内部订单	
						/*用车事由 内部订单
						洽谈业务： OP10QG-长春洽公
						OP20QG-长连洽公
						加班：OP10JB-长春加班
						OP20JB-长连加班
						接/送机：OP10JJ-长春接机
						OP20JJ-长连接机 
						*/
						//40285a90490d16a3014911edf7c2084b 洽谈业务		40285a90490d16a3014911edf7c2084c 接/送机  	40285a8d56d542730156e3815a571d9d 加班
						String reason = StringHelper.null2String(dmap.get("reason"));
						if ( "2010".equals(comcode) ) {
							if ( reason.startsWith("40285a90490d16a3014911edf7c2084b") ) {
								innerorder = "OP10QG";
							} else if ( reason.startsWith("40285a90490d16a3014911edf7c2084c") ) {
								innerorder = "OP10JJ";
							} else if ( reason.startsWith("40285a8d56d542730156e3815a571d9d") ) {
								innerorder = "OP10JB";
							}						
						} else if( "2020".equals(comcode) ) {
							if ( reason.startsWith("40285a90490d16a3014911edf7c2084b") ) {
								innerorder = "OP20QG";
							} else if ( reason.startsWith("40285a90490d16a3014911edf7c2084c") ) {
								innerorder = "OP20JJ";
							} else if ( reason.startsWith("40285a8d56d542730156e3815a571d9d") ) {
								innerorder = "OP20JB";
							}					
						}
						/*
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						reason = reason.replaceFirst(",", "','");
						*/
						reason = ds.getValue("select wm_concat(objname) from selectitem where instr(id,'"+reason+"')>0 and typeid='40285a90490d16a3014911ecca1c084a'");
						
						
						String approute = StringHelper.null2String(dmap.get("approute"));
						String appstime = StringHelper.null2String(dmap.get("appstime"));
						String appetime = StringHelper.null2String(dmap.get("appetime"));
						String gotonum = StringHelper.null2String(dmap.get("gotonum"));
						String backnum = StringHelper.null2String(dmap.get("backnum"));
						String ratio = StringHelper.null2String(dmap.get("ratio"));							
						String carappid = StringHelper.null2String(dmap.get("carappno"));					
						String detailno = StringHelper.null2String(dmap.get("detailno"));				

						String bcf = StringHelper.null2String(dmap.get("bcf"));					
						String jbf = StringHelper.null2String(dmap.get("jbf"));					
						String dbf = StringHelper.null2String(dmap.get("dbf"));					
						String glf = StringHelper.null2String(dmap.get("glf"));					
						String tcf = StringHelper.null2String(dmap.get("tcf"));					
						String yf = StringHelper.null2String(dmap.get("yf"));					
						String fjf = StringHelper.null2String(dmap.get("fjf"));					
						String zcf = StringHelper.null2String(dmap.get("zcf"));
						String mile = StringHelper.null2String(dmap.get("mile"));	
						String gpsmile = StringHelper.null2String(dmap.get("gpsmile"));	
						String actmile = StringHelper.null2String(dmap.get("actmile"));		
						String amount = StringHelper.null2String(dmap.get("amount"));											
						String tax = StringHelper.null2String(dmap.get("tax"));		
						BigDecimal tmpdamount = new BigDecimal(amount==""?"0":amount);
						BigDecimal tmpdtax= new BigDecimal(tax==""?"0":tax);
						String notax = StringHelper.null2String( tmpdamount.subtract(tmpdtax).toString() );
							
						if(j!=Detaillist.size()-1){									
							tmpbcf = tmpbcf.add(new BigDecimal(bcf==""?"0":bcf));
							tmpjbf = tmpjbf.add(new BigDecimal(jbf==""?"0":jbf));
							tmpdbf = tmpdbf.add(new BigDecimal(dbf==""?"0":dbf));
							tmpglf = tmpglf.add(new BigDecimal(glf==""?"0":glf));
							tmptcf = tmptcf.add(new BigDecimal(tcf==""?"0":tcf));
							tmpyf = tmpyf.add(new BigDecimal(yf==""?"0":yf));
							tmpfjf = tmpfjf.add(new BigDecimal(fjf==""?"0":fjf));
							tmpzcf = tmpzcf.add(new BigDecimal(zcf==""?"0":zcf));
							tmpmile = tmpmile.add(new BigDecimal(mile==""?"0":mile));
							tmpgpsmile = tmpgpsmile.add(new BigDecimal(gpsmile==""?"0":gpsmile));
							tmpactmile = tmpactmile.add(new BigDecimal(actmile==""?"0":actmile));	
							tmpamount = tmpamount.add(tmpdamount);
							tmptax = tmptax.add(tmpdtax);
							tmpnotax = tmpnotax.add(new BigDecimal(notax==""?"0":notax));
						}else{																
							bcf = StringHelper.null2String( pcdbcf.subtract(tmpbcf).toString() );
							jbf = StringHelper.null2String( pcdjbf.subtract(tmpjbf).toString() );					
							dbf = StringHelper.null2String( pcddbf.subtract(tmpdbf).toString()  );					
							glf = StringHelper.null2String( pcdglf.subtract(tmpglf).toString() );		
							tcf = StringHelper.null2String( pcdtcf.subtract(tmptcf).toString() );			
							yf = StringHelper.null2String( pcdyf.subtract(tmpyf).toString() );				
							fjf = StringHelper.null2String( pcdfjf.subtract(tmpfjf).toString() );		
							zcf = StringHelper.null2String( pcdzcf.subtract(tmpzcf).toString() );
							mile = StringHelper.null2String( pcdmile.subtract(tmpmile).toString() );
							gpsmile = StringHelper.null2String( pcdgpsmile.subtract(tmpgpsmile).toString() );
							actmile = StringHelper.null2String( pcdactmile.subtract(tmpactmile).toString() );	
							amount = StringHelper.null2String( pcdamount.subtract(tmpamount).toString() );
							tax = StringHelper.null2String( pcdtax.subtract(tmptax).toString() );
							notax = StringHelper.null2String( pcdnotax.subtract(tmpnotax).toString() );
						}	
						supplyname = StringHelper.null2String(map.get("supplyname"));
						isreturn = StringHelper.null2String(map.get("isreturn"));
						isbaoche = StringHelper.null2String(map.get("isbaoche"));				
						carmodel = StringHelper.null2String(map.get("carmodel"));						
						pccarno = StringHelper.null2String(map.get("carno"));
						String usql = "insert into uf_oa_forcarreconsub (flowno, NO, COMCODE, ARRSDATE, COSTDEPT, COSTCENTER, APPUSER, FEEACCOUNT, INNERORDER, APPROUTE, ACTROUTE, ISRETURN, ISBAOCHE, CARMODEL, MILE, GPSMILE, ACTMILE, BCF, JBF, DBF, GLF, TCF, YF, FJF, ZCF, AMOUNT, NOTAX, TAX, FJFYY, APPSTIME, APPETIME, ARRSTIME, ARRETIME, GOTONUM, BACKNUM, TOTALPSN, RATIO, CARNO, DRIVER, DRIVERTEL, SUPPLYNAME, CARAPPNO, DETAILNO, CARARRNO, REASON) values ('"+flowno+"', "+no+", '"+comcode+"', '"+arrsdate+"', '"+costdept+"', '"+costcenter+"', '"+appuser+"', '"+feeaccount+"', '"+innerorder+"', '"+approute+"', '"+actroute+"', '"+isreturn+"', '"+isbaoche+"', '"+carmodel+"', '"+mile+"', '"+gpsmile+"', '"+actmile+"', '"+bcf+"', '"+jbf+"', '"+dbf+"', '"+glf+"', '"+tcf+"','"+yf+"', '"+fjf+"', '"+zcf+"', '"+amount+"', '"+notax+"', '"+tax+"', '"+fjfyy+"', '"+appstime+"', '"+appetime+"', '"+arrstime+"', '"+arretime+"', '"+gotonum+"', '"+backnum+"', '"+totalpsn+"', '"+ratio+"', '"+pccarno+"', '"+driver+"', '"+drivertel+"', '"+supplyname+"', '"+carappid+"', '"+detailno+"', '"+cararrid+"', '"+reason+"')";
						//System.out.println("usql="+usql);
						baseJdbc.update(usql);
						//更新排车单费用分摊明细的金额						
						baseJdbc.update("update uf_oa_carfeeshare set amount='"+amount+"',notax='"+notax+"',tax='"+tax+"' where detailno='"+detailno+"' and requestid='"+cararrid+"'");
						
						String costdeptname = ds.getValue("select objname from orgunit where id='"+costdept+"'");
						String carappno = ds.getValue("select flowno from uf_oa_carapp  where requestid='"+carappid+"'");		
					
						String supname = ds.getValue("select supplyname from uf_oa_supplyinfo where requestid='"+supplyname+"'");	
						isreturn = ds.getValue("select objname from selectitem where id='"+isreturn+"'");
						isbaoche = ds.getValue("select objname from selectitem where id='"+isbaoche+"'");
						carmodel = ds.getValue("select objname from selectitem where id='"+carmodel+"'");
						pccarno = ds.getValue("select carno from uf_oa_carinfo where requestid='"+pccarno+"'");	
											
						buf.append("<TR ondblclick=window.open(\"/workflow/request/formbase.jsp?categoryid=40285a904a6fdaa1014a70d5b81521fe&requestid="+cararrid+"\")>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+(no-1)+"\" name=\"checkbox\"/>");
						buf.append("<input type=\"hidden\" id=\"node_"+(no-1)+"\" name=\"node_"+(no-1)+"\" value=\""+((no-1)+1)+"\"/><span id=\"node_"+(no-1)+"span\" name=\"node_"+(no-1)+"span\">"+((no-1)+1)+"</span></TD>");					
						buf.append("<TD class=\"td2\"  align=center>"+comcode+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+cararrno+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+arrsdate+"</TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+(no-1)+"\" value=\""+costdept+"\" ><span id=\"dept_"+(no-1)+"span\" name=\"dept_"+(no-1)+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+costdept+"','"+costdeptname+"','tab"+costdept+"') >&nbsp;"+costdeptname+"&nbsp;</a></span></TD>");
						
						buf.append("<TD class=\"td2\"  align=center>"+costcenter+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+appuser+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+feeaccount+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+innerorder+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+reason+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+approute+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+actroute+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isreturn+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isbaoche+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+carmodel+"</TD>");			
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+mile+"\" id=\"mile_"+(no-1)+"\" name=\"mile_"+(no-1)+"\"/><span id=\"mile_"+(no-1)+"span\">"+mile+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+gpsmile+"\" id=\"gpsmile_"+(no-1)+"\" name=\"gpsmile_"+(no-1)+"\"/><span>"+gpsmile+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+actmile+"\" id=\"actmile_"+(no-1)+"\" name=\"actmile_"+(no-1)+"\"/><span>"+actmile+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+bcf+"\" id=\"bcf_"+(no-1)+"\" name=\"bcf_"+(no-1)+"\"/><span>"+bcf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+jbf+"\" id=\"jbf_"+(no-1)+"\" name=\"jbf_"+(no-1)+"\"/><span>"+jbf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+dbf+"\" id=\"dbf_"+(no-1)+"\" name=\"dbf_"+(no-1)+"\"/><span>"+dbf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+glf+"\" id=\"glf_"+(no-1)+"\" name=\"glf_"+(no-1)+"\"/><span>"+glf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+tcf+"\" id=\"tcf_"+(no-1)+"\" name=\"tcf_"+(no-1)+"\"/><span>"+tcf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+yf+"\" id=\"yf_"+(no-1)+"\" name=\"yf_"+(no-1)+"\"/><span>"+yf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+fjf+"\" id=\"fjf"+(no-1)+"\" name=\"fjf_"+(no-1)+"\"/><span>"+fjf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+zcf+"\" id=\"zcf_"+(no-1)+"\" name=\"zcf_"+(no-1)+"\"/><span>"+zcf+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+amount+"\" id=\"amount_"+(no-1)+"\" name=\"amount_"+(no-1)+"\"/><span>"+amount+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+notax+"\" id=\"notax_"+(no-1)+"\" name=\"notax_"+(no-1)+"\"/><span>"+notax+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+tax+"\" id=\"tax_"+(no-1)+"\" name=\"tax_"+(no-1)+"\"/><span>"+tax+"</span></TD>");
						buf.append("<TD class=\"td2\"  align=center>"+fjfyy+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appstime+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appetime+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+arrstime+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+arretime+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+gotonum+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+backnum+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+totalpsn+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+ratio+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+pccarno+"</TD>");
						buf.append("<TD class=\"td2\"  align=center>"+driver+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+drivertel+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+supname+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+carappno+"</TD>");
						buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+detailno+"</TD>");						
						buf.append("</TR>");
						//buf.append("<tr>"+usql+"</tr>");							
					}
				}	
			}
		} else {
			buf.append("<TR><TD colspan=40>无数据！</TD></TR>");
			if (imtype.equals("") && action.equals("show")) {
				return;
			}
		}		
	}
	if(action.equals("show") || action.equals("doselect")){
		if(list.size()>0){		
			for(int k=0;k<list.size();k++){
				Map map = (Map)list.get(k);						
				String comcode = StringHelper.null2String(map.get("comcode"));
				String cararrid = StringHelper.null2String(map.get("requestid"));
				String cararrno = StringHelper.null2String(map.get("flowno"));
				String arrsdate = StringHelper.null2String(map.get("arrsdate"));
				String costdept = StringHelper.null2String(map.get("costdept"));					
				String costcenter = StringHelper.null2String(map.get("costcenter"));
				String appuser = StringHelper.null2String(map.get("appuser"));
				String feeaccount = StringHelper.null2String(map.get("feeaccount"));
				String innerorder = StringHelper.null2String(map.get("innerorder"));
				String approute = StringHelper.null2String(map.get("approute"));
				String actroute = StringHelper.null2String(map.get("actroute"));
				String isreturn = StringHelper.null2String(map.get("isreturn"));					
				String isbaoche = StringHelper.null2String(map.get("isbaoche"));					
				String carmodel = StringHelper.null2String(map.get("carmodel"));					
				String mile = StringHelper.null2String(map.get("mile"));					
				String gpsmile = StringHelper.null2String(map.get("gpsmile"));					
				String actmile = StringHelper.null2String(map.get("actmile"));					
				String bcf = StringHelper.null2String(map.get("bcf"));					
				String jbf = StringHelper.null2String(map.get("jbf"));					
				String dbf = StringHelper.null2String(map.get("dbf"));					
				String glf = StringHelper.null2String(map.get("glf"));					
				String tcf = StringHelper.null2String(map.get("tcf"));					
				String yf = StringHelper.null2String(map.get("yf"));					
				String fjf = StringHelper.null2String(map.get("fjf"));					
				String zcf = StringHelper.null2String(map.get("zcf"));					
				String amount = StringHelper.null2String(map.get("amount"));					
				String notax = StringHelper.null2String(map.get("notax"));					
				String tax = StringHelper.null2String(map.get("tax"));					
				String fjfyy = StringHelper.null2String(map.get("fjfyy"));
				String appstime = StringHelper.null2String(map.get("appstime"));
				String appetime = StringHelper.null2String(map.get("appetime"));
				String arrstime = StringHelper.null2String(map.get("arrstime"));
				String arretime = StringHelper.null2String(map.get("arretime"));
				String gotonum = StringHelper.null2String(map.get("gotonum"));
				String backnum = StringHelper.null2String(map.get("backnum"));
				String totalpsn = StringHelper.null2String(map.get("totalpsn"));
				String ratio = StringHelper.null2String(map.get("ratio"));
				String pccarno = StringHelper.null2String(map.get("carno"));
			
				String driver = StringHelper.null2String(map.get("driver"));
				String drivertel = StringHelper.null2String(map.get("drivertel"));	
				if(action.equals("show") || action.equals("doselect")){
					supplyname = StringHelper.null2String(map.get("supplyname"));
				}
				String supname = ds.getValue("select supplyname from uf_oa_supplyinfo where requestid='"+supplyname+"'");					
				String carappid = StringHelper.null2String(map.get("carappno"));					
				String detailno = StringHelper.null2String(map.get("detailno"));
				String reason = StringHelper.null2String(map.get("reason"));
				
				
				String usql = "insert into uf_oa_forcarreconsub (flowno, NO, COMCODE, ARRSDATE, COSTDEPT, COSTCENTER, APPUSER, FEEACCOUNT, INNERORDER, APPROUTE, ACTROUTE, ISRETURN, ISBAOCHE, CARMODEL, MILE, GPSMILE, ACTMILE, BCF, JBF, DBF, GLF, TCF, YF, FJF, ZCF, AMOUNT, NOTAX, TAX, FJFYY, APPSTIME, APPETIME, ARRSTIME, ARRETIME, GOTONUM, BACKNUM, TOTALPSN, RATIO, CARNO, DRIVER, DRIVERTEL, SUPPLYNAME, CARAPPNO, DETAILNO, CARARRNO, REASON) values ('"+flowno+"', "+(k+1)+", '"+comcode+"', '"+arrsdate+"', '"+costdept+"', '"+costcenter+"', '"+appuser+"', '"+feeaccount+"', '"+innerorder+"', '"+approute+"', '"+actroute+"', '"+isreturn+"', '"+isbaoche+"', '"+carmodel+"', '"+mile+"', '"+gpsmile+"', '"+actmile+"', '"+bcf+"', '"+jbf+"', '"+dbf+"', '"+glf+"', '"+tcf+"','"+yf+"', '"+fjf+"', '"+zcf+"', '"+amount+"', '"+notax+"', '"+tax+"', '"+fjfyy+"', '"+appstime+"', '"+appetime+"', '"+arrstime+"', '"+arretime+"', '"+gotonum+"', '"+backnum+"', '"+totalpsn+"', '"+ratio+"', '"+pccarno+"', '"+driver+"', '"+drivertel+"', '"+supplyname+"', '"+carappid+"', '"+detailno+"', '"+cararrid+"','"+reason+"')";
				//System.out.println("usql="+usql);
				baseJdbc.update(usql);
				
				String costdeptname = ds.getValue("select objname from orgunit where id='"+costdept+"'");	
				
				isreturn = ds.getValue("select objname from selectitem where id='"+isreturn+"'");
				isbaoche = ds.getValue("select objname from selectitem where id='"+isbaoche+"'");
				carmodel = ds.getValue("select objname from selectitem where id='"+carmodel+"'");
				pccarno = ds.getValue("select carno from uf_oa_carinfo where requestid='"+pccarno+"'");
				String carappno = ds.getValue("select flowno from uf_oa_carapp  where requestid='"+carappid+"'");
				
				buf.append("<TR ondblclick=window.open(\"/workflow/request/formbase.jsp?categoryid=40285a904a6fdaa1014a70d5b81521fe&requestid="+cararrid+"\")>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"checkbox\" value=\"-1\" id=\"checkbox_"+k+"\" name=\"checkbox\"/>");
				buf.append("<input type=\"hidden\" id=\"node_"+k+"\" name=\"node_"+k+"\" value=\""+(k+1)+"\"/><span id=\"node_"+k+"span\" name=\"node_"+k+"span\">"+(k+1)+"</span></TD>");					
				buf.append("<TD class=\"td2\"  align=center>"+comcode+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+cararrno+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+arrsdate+"</TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" id=\"dept_"+k+"\" value=\""+costdept+"\" ><span id=\"dept_"+k+"span\" name=\"dept_"+k+"span\"><a href=javascript:onUrl('/base/orgunit/orgunitview.jsp?id="+costdept+"','"+costdeptname+"','tab"+costdept+"') >&nbsp;"+costdeptname+"&nbsp;</a></span></TD>");
				
				buf.append("<TD class=\"td2\"  align=center>"+costcenter+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+appuser+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+feeaccount+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+innerorder+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+reason+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+approute+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+actroute+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isreturn+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+isbaoche+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\">"+carmodel+"</TD>");			
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+mile+"\" id=\"mile_"+k+"\" name=\"mile_"+k+"\"/><span id=\"mile_"+k+"span\">"+mile+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+gpsmile+"\" id=\"gpsmile_"+k+"\" name=\"gpsmile_"+k+"\"/><span>"+gpsmile+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+actmile+"\" id=\"actmile_"+k+"\" name=\"actmile_"+k+"\"/><span>"+actmile+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+bcf+"\" id=\"bcf_"+k+"\" name=\"bcf_"+k+"\"/><span>"+bcf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+jbf+"\" id=\"jbf_"+k+"\" name=\"jbf_"+k+"\"/><span>"+jbf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+wjcstyle+"\"><input type=\"hidden\" value=\""+dbf+"\" id=\"dbf_"+k+"\" name=\"dbf_"+k+"\"/><span>"+dbf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+glf+"\" id=\"glf_"+k+"\" name=\"glf_"+k+"\"/><span>"+glf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+tcf+"\" id=\"tcf_"+k+"\" name=\"tcf_"+k+"\"/><span>"+tcf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+yf+"\" id=\"yf_"+k+"\" name=\"yf_"+k+"\"/><span>"+yf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+fjf+"\" id=\"fjf"+k+"\" name=\"fjf_"+k+"\"/><span>"+fjf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:"+czcstyle+"\"><input type=\"hidden\" value=\""+zcf+"\" id=\"zcf_"+k+"\" name=\"zcf_"+k+"\"/><span>"+zcf+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+amount+"\" id=\"amount_"+k+"\" name=\"amount_"+k+"\"/><span>"+amount+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+notax+"\" id=\"notax_"+k+"\" name=\"notax_"+k+"\"/><span>"+notax+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center><input type=\"hidden\" value=\""+tax+"\" id=\"tax_"+k+"\" name=\"tax_"+k+"\"/><span>"+tax+"</span></TD>");
				buf.append("<TD class=\"td2\"  align=center>"+fjfyy+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appstime+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+appetime+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+arrstime+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+arretime+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+gotonum+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+backnum+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+totalpsn+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+ratio+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+pccarno+"</TD>");
				buf.append("<TD class=\"td2\"  align=center>"+driver+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+drivertel+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+supname+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+carappno+"</TD>");
				buf.append("<TD class=\"td2\"  align=center style=\"display:none\">"+detailno+"</TD>");				
				buf.append("</TR>");
				//buf.append("<tr>"+usql+"</tr>");		
			}		
		}else{
			buf.append("<TR><TD colspan=40>无数据！</TD></TR>");
			if(imtype.equals("") && action.equals("show")){
				return;
			}
		}
	}	
	buf.append("</table></div>");
%>


<style type="text/css"> 
tr.tr1{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.title{ 
	font-size:12px; 
	font-weight:bold;
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#f8f8f0; 
} 
tr.hj{     
    TEXT-INDENT: -1pt; 
    TEXT-ALIGN: left; 
    height: 22px; 
    background-color:#e46d0a; 
} 
td.td1{ 
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none 

} 
td.td2{ 
	height: 22px;
    font-size:12px; 
    PADDING-RIGHT: 4px; 
    PADDING-LEFT: 4px;     
    TEXT-DECORATION: none; 
    color:#000; 
} 
</style>

<script type='text/javascript' language="javascript" src='/js/main.js'></script>
<!--<div id="warpp" style="height:600px;overflow-y:auto">-->
<div id="warpp" >
<table id="dataTable" style="BORDER-COLLAPSE: collapse" border=1 cellSpacing=0 cellPadding=0   style="width: 100%;font-size:12" bordercolor="#adae9d">
<COLGROUP>
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="4%">
<COL width="5%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="1%">
<COL width="1%">
<COL width="2%">
<COL width="2%">
<COL width="4%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%">
<COL width="2%"></COLGROUP>

<TR height="25"  class="title">
<TD  noWrap class="td2"  align=center><input type="checkbox" value="-1" id="selectall" name="selectall" onclick="getAll(this)"/>序号</TD>
<TD  noWrap class="td2"  align=center>公司代码</TD>
<TD  noWrap class="td2"  align=center>排车单号</TD>
<TD  noWrap class="td2"  align=center>出 发 日 期</TD>
<TD  noWrap class="td2"  align=center>费 用 部 门</TD>
<TD  noWrap class="td2"  align=center>成本中心</TD>
<TD  noWrap class="td2"  align=center>乘  车  人</TD>
<TD  noWrap class="td2"  align=center>总账科目</TD>
<TD  noWrap class="td2"  align=center>内部订单</TD>
<TD  noWrap class="td2"  align=center>用车事由</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请行程</TD>
<TD  noWrap class="td2"  align=center style="display:none">实际行程</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">是否往返</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">是否包车</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">车    型</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">登记里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">GPS里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">实际核算里程数</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">包 车 费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">基 本 费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=wjcstyle%>">短 驳 费</TD>
<TD  noWrap class="td2"  align=center>过 路 费</TD>
<TD  noWrap class="td2"  align=center>停 车 费</TD>
<TD  noWrap class="td2"  align=center>油      费</TD>
<TD  noWrap class="td2"  align=center>附 加 费</TD>
<TD  noWrap class="td2"  align=center style="display:<%=czcstyle%>">租 车 费</TD>
<TD  noWrap class="td2"  align=center>费用小计</TD>
<TD  noWrap class="td2"  align=center>未税金额</TD>
<TD  noWrap class="td2"  align=center>税      金</TD>
<TD  noWrap class="td2"  align=center>附加费说明</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请出发时间</TD>
<TD  noWrap class="td2"  align=center style="display:none">申请返回时间</TD>
<TD  noWrap class="td2"  align=center>出发时间</TD>
<TD  noWrap class="td2"  align=center>返回时间</TD>
<TD  noWrap class="td2"  align=center>去程人数</TD>
<TD  noWrap class="td2"  align=center>返程人数</TD>
<TD  noWrap class="td2"  align=center>排车单总人数</TD>
<TD  noWrap class="td2"  align=center>分摊比例</TD>
<TD  noWrap class="td2"  align=center>车 牌 号</TD>
<TD  noWrap class="td2"  align=center>司机姓名</TD>
<TD  noWrap class="td2"  align=center style="display:none">司机电话</TD>
<TD  noWrap class="td2"  align=center style="display:none">租赁公司</TD>
<TD  noWrap class="td2"  align=center style="display:none">用车单号</TD>
<TD  noWrap class="td2"  align=center style="display:none">用车明细单号</TD>
</tr>

<%
out.println(buf.toString());
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 