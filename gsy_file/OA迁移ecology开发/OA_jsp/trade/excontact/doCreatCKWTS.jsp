<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoStructure" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.base.BaseContext"%>

<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>


<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String action=StringHelper.null2String(request.getParameter("action"));
	String expno=StringHelper.null2String(request.getParameter("expno"));

	DataService ds = new DataService();
	int existflag = Integer.parseInt(ds.getValue("select count(*) n from uf_tr_ckwts a,formbase b where a.requestid=b.id and b.isdelete=0 and a.expno='"+expno+"'"));	

String startdate = "";
String icon1text = "";
String icon2text = "";
String companyname = "";
String coname = "";
String comcode = "";
String comtype = "";
String reqcom = "";
String sagentname = "";
String shipper = "";
String destport = "";
String departure = "";
String consignee = "";
String notifyparty = "";
String shipping = "";
String goodsgroup = "";
String notifyparty2 = "";
String cbms = "";
String gwsum = "";
String stocktotal = "";
String xtbtotal = "";
String packtotal = "";
String packtype = "";
String llr = "";
String tel = "";
String fax = "";
String comfax = "";
String lastname = "";
String selectname = "";
String freedate = "";
String freestack = "";
String deliremark = "";
String leavedate = "";
String deadline = "";
String destfee = "";
String destfeedes = "";
String feeproj = "";
String shipyears = "";
String outland = "";
String outcompany = "";
String transtype = "";

	String err="";	

	System.out.println(" existflag="+existflag);
	if ( existflag==0 ) {	//不存在，则新增
	
		//SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmss");
		//String Dtime = format.format(new Date());
		//String currentno = ds.getValue("SELECT CURRENTNO from SEQUENCE where ID ='2c91a0302bbcd476012c1127e22c3fbe'");
		//String bookno="GDZC-"+Dtime+"-"+currentno;
		
		//根据requestid来获取外销联络单相关数据
		String sql = "select u1.*,u2.companyname,u3.describe describe1,u4.describe describe2,u5.pcategory,h.objname,s.objname selectname,fydl.contacts fyllr,fydl.telephone fytel,fydl.fax fyfax,hydl.contacts hyllr,hydl.telephone hytel,hydl.fax hyfax  from uf_tr_expboxmain u1 left join uf_tr_cgswhd u2 on u1.shipcompany = u2.requestid left join uf_tr_gkwhd u3 on u1.departure = u3.requestid left join uf_tr_gkwhd u4 on u1.destport = u4.requestid left join uf_tr_prodcate u5 on u5.requestid = u1.goodsgroup left join humres h on u1.bginfopsn = h.id left join selectitem s on u1.billtype = s.id left join uf_tr_ffinfo  fydl on fydl.concode=u1.agentcodetxt and fydl.company=u1.factory and fydl.state='40288098276fc2120127704884290210' left join uf_tr_ffinfo hydl on hydl.concode=u1.sagentcodetxt and hydl.company=u1.factory and hydl.state='40288098276fc2120127704884290210' where u1.requestid = '"+requestid+"'";
		List list = baseJdbcDao.getJdbcTemplate().queryForList(sql);
		if (list.size() > 0) {
			
			Map map001 = (Map) list.get(0);
			expno = StringHelper.null2String(map001.get("expno"));//出口编号
			startdate = StringHelper.null2String(map001.get("startdate"));//预计开航日 
			icon1text = StringHelper.null2String(map001.get("icon1text"));//国贸条件1
			icon2text = StringHelper.null2String(map001.get("icon2text"));//国贸条件2
			companyname = StringHelper.null2String(map001.get("companyname"));//船公司名称 
			coname = StringHelper.null2String(map001.get("coname"));//公司名称 
			comcode = StringHelper.null2String(map001.get("cocode"));//公司代码 
			comtype = StringHelper.null2String(map001.get("factory"));//厂区别
			reqcom = StringHelper.null2String(map001.get("company"));//所属公司
			
			sagentname = StringHelper.null2String(map001.get("sagentname"));//海运代理名称 
			shipper = StringHelper.null2String(map001.get("SHIPPER"));//SHIPPER
			departure = StringHelper.null2String(map001.get("describe1"));//起运港
			destport = StringHelper.null2String(map001.get("describe2"));//目的港
			consignee = StringHelper.null2String(map001.get("consignee"));//consignee
			notifyparty = StringHelper.null2String(map001.get("notifyparty"));//notifyparty
			shipping = StringHelper.null2String(map001.get("shipping"));//shipping
			notifyparty2 = StringHelper.null2String(map001.get("notifyparty2"));//中英文品名 提单要求(货物描述)
			cbms = StringHelper.null2String(map001.get("cbmtotal"));//材积cbm合计
			gwsum = StringHelper.null2String(map001.get("gwsum"));//毛重合计
			stocktotal = StringHelper.null2String(map001.get("stocktotal"));//托盘数合计
			xtbtotal = StringHelper.null2String(map001.get("packtotal"));//木箱数/包数/桶数合计
			packtype = "包";
			packtotal = xtbtotal +"  "+packtype;
			if(!"".equals(sagentname)){ //2016-08-16 11:08 xxy 修改，营业要求如没有海运代理，则取货运代理，不要管国贸条件
				llr = StringHelper.null2String(map001.get("hyllr"));//联络人	海运代理
				tel = StringHelper.null2String(map001.get("hytel"));//tel
				fax = StringHelper.null2String(map001.get("hyfax"));//fax				
			}else{
				sagentname = StringHelper.null2String(map001.get("agentname"));//货运代理名称 
				llr = StringHelper.null2String(map001.get("fyllr"));//联络人	货运代理
				tel = StringHelper.null2String(map001.get("fytel"));//tel
				fax = StringHelper.null2String(map001.get("fyfax"));//fax				
			}
			/*
			if ("FOB".equals(icon1text)) {
				llr = StringHelper.null2String(map001.get("fyllr"));//联络人	货运代理
				tel = StringHelper.null2String(map001.get("fytel"));//tel
				fax = StringHelper.null2String(map001.get("fyfax"));//fax
			}else{
				llr = StringHelper.null2String(map001.get("hyllr"));//联络人	海运代理
				tel = StringHelper.null2String(map001.get("hytel"));//tel
				fax = StringHelper.null2String(map001.get("hyfax"));//fax	
			}
			*/
			llr = llr + "  " + tel + "  " + fax;
			lastname = StringHelper.null2String(map001.get("bginfopsn"));//报关人
			selectname = StringHelper.null2String(map001.get("selectname"));//提单形式
			freedate = StringHelper.null2String(map001.get("freedate"));//免箱期
			freestack = StringHelper.null2String(map001.get("freestack"));//免堆期
			deliremark = StringHelper.null2String(map001.get("deliremark"));//出货备注
			leavedate = StringHelper.null2String(map001.get("leavedate"));//预计可出厂日 装箱日期
			deadline = StringHelper.null2String(map001.get("deadline")); //客户要求最晚到货日
			destfee = StringHelper.null2String(map001.get("destfee")); //目的港费用
			feeproj = StringHelper.null2String(map001.get("feeproj")); //费用项目

			shipyears = StringHelper.null2String(map001.get("shipyears")); //船龄小于
			outland = StringHelper.null2String(map001.get("outland")); //排除船舶国籍
			outcompany = StringHelper.null2String(map001.get("outcompany")); //排除船公司
			transtype = StringHelper.null2String(map001.get("traveltypetext")); //运输方式
			goodsgroup = StringHelper.null2String(map001.get("pcategory")); //产品大类
			if ( "1010".equals(comcode) ) {
				comfax = "0512-52645556"; 
			}
		}	

		String sql1 = "select v.cabtype,count(*) cabnums from (select  u1.cabtype,u1.cabno from uf_tr_packtype u1 where u1.requestid = '"+requestid+"' group by u1.cabtype,u1.cabno) v  group by v.cabtype";
		List list1 = baseJdbcDao.getJdbcTemplate().queryForList(sql1);
		String cabtype = "";
		String cabtypenums = "";
		if (list1.size() > 0) {
			for (int i=0;i<list1.size();i++) {
				Map map001 = (Map) list1.get(i);
				if (i==0) {
					cabtype = StringHelper.null2String(map001.get("cabtype"));//柜型
					cabtypenums =  StringHelper.null2String(map001.get("cabnums"));//柜数
				} else {
					cabtype =cabtype+"/"+ StringHelper.null2String(map001.get("cabtype"));//柜型
					cabtypenums =cabtypenums +"/"+  StringHelper.null2String(map001.get("cabnums"));//柜数
				}
			}
		}
		 
		 String sql2 = "select distinct (select objname from selectitem where id= b.dangerouslv) isdager,b.unno from uf_tr_shipment a,uf_tr_materialsp b "
		 +"where a.stockno=b.materialno and a.requestid='"+requestid+"' order by isdager desc";
		 List list2 = baseJdbcDao.getJdbcTemplate().queryForList(sql2);
		 String isdager = "";
		 String unno = "";
		 String isdagerflag = "";
		 if (list2.size() > 0) {
			for (int i=0;i<list2.size();i++){
				Map map001 = (Map) list2.get(i);					
				if ( i==0 ) {
					isdager = StringHelper.null2String(map001.get("isdager"));				
					unno = StringHelper.null2String(map001.get("unno"));
					if ( "".equals(isdager) || "0".equals(isdager) ) {
						isdagerflag = "0";
						isdagerflag = "40288098276fc2120127704884290211"; //否
					}else{
						isdagerflag = "1";
						isdagerflag = "40288098276fc2120127704884290210"; //是
					}
				} else {
					isdager += "/"+StringHelper.null2String(map001.get("isdager"));
					unno += "/"+StringHelper.null2String(map001.get("unno"));
				}
			}
		 } 
					 
		 String sql3 = "select freighttype,notaxprice,currency from uf_tr_ocfreight where requestid='"+requestid+"' and freighttype='海运费'";
		 List list3 = baseJdbcDao.getJdbcTemplate().queryForList(sql3);
		 String strs = "";
		 if (list3.size() > 0 && list1.size() > 0) {
			Map map003 = (Map) list1.get(0);
			String cabtype1 = StringHelper.null2String(map003.get("cabtype"));//柜型
			for(int i = 0;i < list3.size();i++){
				Map map001 = (Map) list3.get(i);
				String freighttype = StringHelper.null2String(map001.get("freighttype"));
				String notaxprice = StringHelper.null2String(map001.get("notaxprice"));
				String currency = StringHelper.null2String(map001.get("currency"));
				if(strs!=""){
					strs += " " + freighttype + currency+ notaxprice + "/" + cabtype1;
				}else{
					strs = freighttype +" "+ currency+ notaxprice + "/" + cabtype1;
				}
			}
		 }
		 if ( !"".equals(strs) ) {
				strs += "\r\n" ;
		}
		 if ( "40285a9049a231e70149a2b184c30ade".equals(destfee) ){	//承担				
			strs += "目的港费用 承担 ";
			if (!"".equals(feeproj) ) {
				String [] stringArr= feeproj.split(",");
				for ( int i = 0;i < stringArr.length;i++ ) {
					strs += ds.getValue("select costname from uf_tr_fymcwhd where requestid='"+stringArr[i]+"'") + " " ; //费用名称
				}
			}
		 } else if ( "40285a9049a231e70149a2b184c30adf".equals(destfee) ){	//不承担
			strs += "目的港费用 不承担";
		 }		

					 
		 if ( !"".equals(shipyears) &&  !"0".equals(shipyears) ) {
			deliremark = deliremark + "             " + "船龄小于：" + shipyears;
		 }
		 if ( !"".equals(outland) &&  !"0".equals(outland) ) {
			deliremark = deliremark + "             " + "排除船舶国籍：" + outland;
		 }
		 if ( !"".equals(outcompany) &&  !"0".equals(outcompany) ) {
			deliremark = deliremark + "             " + "排除船公司" + outcompany;
		 }			 
	

		
		
		String orgid = ds.getValue("select orgid from humres where ID ='"+lastname+"'");
		System.out.println(" start create uf_tr_ckwts: "+expno);
		StringBuffer buffer = new StringBuffer(1024);
		//String newrequestid = IDGernerator.getUnquieID();
		buffer.append("insert into uf_tr_ckwts").append("(id,requestid,reqman,reqdate,checkman,checkdate,printpsn,printdate,reqdept,comname,comcode,comtype,reqcom,sagentname,llr,expno,shipper,consignee,notifyparty,shipping,notifyparty2,destport,departure,icon1text,yunfei,shipcom,deadline,startdate,leavedate,iszy,cararr,packtotal,gwsum,cbms,cabtype,cabtypenums,temperature,isdager,dagerlv,unno,cabprice,ladway,ladtype,speneed,freedate,freestack,transtype,goodsgroup,stocktotal,xtbtotal,packtype,fax) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

		buffer.append("'").append(lastname).append("',");//委托人
		buffer.append("'").append(DateHelper.getCurrentDate()).append("',");//委托日期
        buffer.append("'',");//审核人
		buffer.append("'',");//审核日期
		buffer.append("'',");//打印人
		buffer.append("'',");//打印日期
		buffer.append("'").append(orgid).append("',");//委托人部门
		buffer.append("'").append(coname).append("',");//公司名称
		buffer.append("'").append(comcode).append("',");//公司代码		
		buffer.append("'").append(comtype).append("',");//厂区别		
		buffer.append("'").append(reqcom).append("',");//所属公司		
		buffer.append("'").append(sagentname).append("',");//致货代公司		
		buffer.append("'").append(llr).append("',");//联络人/TEL/FAX
		buffer.append("'").append(expno).append("',");//委托编号		
		buffer.append("'").append(shipper).append("',");//SHIPPER		
		buffer.append("'").append(consignee).append("',");//CONSIGNEE		
		buffer.append("'").append(notifyparty).append("',");//NOTIFYPARTY		
		buffer.append("'").append(shipping).append("',");//唛头		
		buffer.append("'").append(notifyparty2).append("',");//中英文品名		
		buffer.append("'").append(destport).append("',");//目的港		
		buffer.append("'").append(departure).append("',");//出运港		
		buffer.append("'").append(icon1text).append("',");//国贸条件		
		buffer.append("'',");//运费
		buffer.append("'").append(companyname).append("',");//船公司
		buffer.append("'").append(deadline).append("',");//客户要求最晚到货日
		buffer.append("'").append(startdate).append("',");//船期
		buffer.append("'").append(leavedate).append("',");//装箱日期
		buffer.append("'',");//是否可以转运
		buffer.append("'',");//拖车安排
		buffer.append("'").append(packtotal).append("',");//件数
		buffer.append("'").append(gwsum).append("',");//毛重（公斤）
		buffer.append("'").append(cbms).append("',");//体积（M3）		
		buffer.append("'").append(cabtype).append("',");//柜型
		buffer.append("'").append(cabtypenums).append("',");//柜数
		buffer.append("'',");//温度要求		
		buffer.append("'").append(isdagerflag).append("',");//是否危险品
		buffer.append("'").append(isdager).append("',");//CLASS
		buffer.append("'").append(unno).append("',");//UN NO
		buffer.append("'").append(strs).append("',");//单柜海运费
		buffer.append("'").append(selectname).append("',");//提单形式
		buffer.append("'',");//海运代理/货运代理
		buffer.append("'").append(deliremark).append("',");//特殊要求		
		buffer.append("'").append(freedate).append("',");//免箱期		
		buffer.append("'").append(freestack).append("',");//免堆期
		buffer.append("'").append(transtype).append("',");//运输方式
		buffer.append("'").append(goodsgroup).append("',");//产品大类
		buffer.append("'").append(stocktotal).append("',");//托盘数合计
		buffer.append("'").append(xtbtotal).append("',");//木箱数/包数/桶数合计
		buffer.append("'").append(packtype).append("',");//包装类型		
		buffer.append("'").append(comfax).append("')");//FAX		

		FormBase formBase = new FormBase();
		String categoryid = "40285a8d5363b186015382023c5324d5";
		//创建formbase
		formBase.setCreatedate(DateHelper.getCurrentDate());
		formBase.setCreatetime(DateHelper.getCurrentTime());
		formBase.setCreator(StringHelper.null2String(userid));
		formBase.setCategoryid(categoryid);
		formBase.setIsdelete(0);
		FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
		formBaseService.createFormBase(formBase);
		String insertSql = buffer.toString();
		insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
		baseJdbcDao.update(insertSql);
		PermissionTool permissionTool = new PermissionTool();
		permissionTool.addPermission(categoryid,formBase.getId(), "uf_tr_ckwts");				
		System.out.println(" end create uf_tr_ckwts: "+expno);
	} else {	//存在，则更新
		err = "1";
	}

	
	JSONObject jo = new JSONObject();	

	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("existflag",existflag);
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("existflag",existflag);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    