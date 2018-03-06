<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.app.configsap.dccm.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.eweaver.app.configsap.SapSync"%>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eweaver.sysinterface.base.Param"%>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase"%>


<%
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		String requestid = StringHelper.null2String(request.getParameter("requestid"));

		//以下为主表数据
		String flowerno = "";//税金请款编号
		String factype = "";//厂区别
		String manager = "";//经办人
		String handledate = "";//经办日期
		String depart = "";//经办部门
		String isvalid = "";//是否有效
		String telephone = "";//联系电话
		String ladingno = "";//进口提单编号
		String comtype = "";//公司别
		String k1number = "";//报关单号
		String k1date = "";//报关日期
		String exrate = "";//报关汇率
		String invno = "";//发票号码
		String invdate = "";//发票日期
		String curr = "";//币种
		String ffscode = "";//供应商简码
		String ffsname = "";//供应商名称
		String payway = "";//付款方式简码
		String paywaytxt = "";//付款方式文本
		String payterm = "";//付款条款简码
		String paytermtxt = "";//付款条款文本
		String payfreeze = "";//付款冻结
		String paydate = "";//付款基准日
		String actamount1 = "";//实际支付金额(Duties)
		String actamount2 = "";//实际支付金额(GST)
		
		

		
		String asql = "select sj.flowerno,(select objname from orgunittype where id = sj.factype)factype,(select objname from humres where id = sj.manager)manager,sj.handledate,(select objname from orgunit where id = sj.depart)depart,sj.isvalid,sj.telephone,(select ibolnum from uf_dmph_importbilllad where requestid = sj.ladingno)ladingno,(select objname from orgunit where id = sj.comtype)comtype,sj.k1number,sj.k1date,sj.exrate,sj.invno,sj.invdate,sj.ffscode,sj.ffsname,sj.payway,sj.paywaytxt,sj.payterm,sj.paytermtxt,sj.payfreeze,sj.paydate,sj.actamount1,sj.actamount2 from uf_dmph_sjqkmain sj where sj.requestid='"+requestid+"'";
		List alist = baseJdbc.executeSqlForList(asql);
		if(alist.size()>0)
		{
			Map amap = (Map)alist.get(0);
			//以下为抬头字段
			flowerno = StringHelper.null2String(amap.get("flowerno")); 
			factype = StringHelper.null2String(amap.get("factype")); 
			manager = StringHelper.null2String(amap.get("manager")); 
			handledate = StringHelper.null2String(amap.get("handledate")); 
			if(!handledate.equals(""))
			{
				handledate = handledate.replaceAll("-","");
			}
			depart = StringHelper.null2String(amap.get("depart")); 
			isvalid = StringHelper.null2String(amap.get("isvalid")); 
			if(isvalid.equals("40285a8d5763da3c0157646db1b4053a"))
			{
				isvalid = "YSE";
			}
			else
			{
				isvalid = "NO";
			}
			telephone = StringHelper.null2String(amap.get("telephone")); 
			ladingno = StringHelper.null2String(amap.get("ladingno")); 
			comtype = StringHelper.null2String(amap.get("comtype")); 
			k1number = StringHelper.null2String(amap.get("k1number")); 
			k1date = StringHelper.null2String(amap.get("k1date")); 
			if(!k1date.equals(""))
			{
				k1date = k1date.replaceAll("-","");
			}
			exrate = StringHelper.null2String(amap.get("exrate")); 
			invno = StringHelper.null2String(amap.get("invno")); 
			invdate = StringHelper.null2String(amap.get("invdate")); 
			if(!invdate.equals(""))
			{
				invdate = invdate.replaceAll("-","");
			}
			curr = StringHelper.null2String(amap.get("curr")); 
			ffscode = StringHelper.null2String(amap.get("ffscode")); 
			ffsname = StringHelper.null2String(amap.get("ffsname")); 
			payway = StringHelper.null2String(amap.get("payway")); 
			paywaytxt = StringHelper.null2String(amap.get("paywaytxt")); 
			payterm = StringHelper.null2String(amap.get("payterm")); 
			paytermtxt = StringHelper.null2String(amap.get("paytermtxt")); 
			payfreeze = StringHelper.null2String(amap.get("payfreeze")); 
			paydate = StringHelper.null2String(amap.get("paydate")); 
			if(!paydate.equals(""))
			{
				paydate = paydate.replaceAll("-","");
			}
			actamount1 = StringHelper.null2String(amap.get("actamount1")); 
			actamount2 = StringHelper.null2String(amap.get("actamount2")); 
		}
		
		



		System.out.println("flowerno:"+flowerno);
		System.out.println("factype:"+factype);
		System.out.println("manager:"+manager);
		System.out.println("handledate:"+handledate);
		System.out.println("depart:"+depart);
		System.out.println("isvalid:"+isvalid);
		System.out.println("telephone:"+telephone);
		System.out.println("ladingno:"+ladingno);
		System.out.println("comtype:"+comtype);
		System.out.println("k1number:"+k1number);
		System.out.println("k1date:"+k1date);
		System.out.println("exrate:"+exrate);
		System.out.println("invno:"+invno);
		System.out.println("invdate:"+invdate);
		System.out.println("curr:"+curr);
		System.out.println("ffscode:"+ffscode);
		System.out.println("ffsname:"+ffsname);
		System.out.println("payway:"+payway);
		System.out.println("paywaytxt:"+paywaytxt);
		System.out.println("payterm:"+payterm);
		System.out.println("paytermtxt:"+paytermtxt);
		System.out.println("payfreeze:"+payfreeze);
		System.out.println("paydate:"+paydate);
		System.out.println("actamount1:"+actamount1);
		System.out.println("actamount2:"+actamount2);
		
		
		
		//创建SAP对象		
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZMY_SAVE_TX";
		JCoFunction function = null;
		try 
		{
			function = SapConnector.getRfcFunction(functionName);
		} 
		catch (Exception e) 
		{
			//TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		//将抬头数据插入SAP
		JCoTable retTable0 = function.getTableParameterList().getTable("HEAD");
		retTable0.appendRow();
		retTable0.setValue("ZZFLOWERNO",flowerno);
		retTable0.setValue("ZZFACTYPE",factype);
		retTable0.setValue("ZZMANAGER",manager);
		retTable0.setValue("ZZHANDLEDATE",handledate);
		retTable0.setValue("ZZDEPART",depart);
		retTable0.setValue("ZZISVALID",isvalid);
		retTable0.setValue("ZZTELEPHONE",telephone);
		retTable0.setValue("ZZLADINGNO",ladingno);
		retTable0.setValue("ZZCOMTYPE",comtype);
		retTable0.setValue("ZZK1NUMBER",k1number);
		retTable0.setValue("ZZK1DATE",k1date);
		retTable0.setValue("ZZEXRATE",exrate);
		retTable0.setValue("ZZINVNO",invno);
		retTable0.setValue("ZZINVDATE",invdate);
		retTable0.setValue("ZZCURR",curr);
		retTable0.setValue("ZZFFSCODE",ffscode);
		retTable0.setValue("ZZFFSNAME",ffsname);
		retTable0.setValue("ZZPAYWAY",payway);
		retTable0.setValue("ZZPAYWAYTXT",paywaytxt);
		retTable0.setValue("ZZPAYTERM",payterm);
		retTable0.setValue("ZZPAYTERMTXT",paytermtxt);
		retTable0.setValue("ZZPAYFREEZE",payfreeze);
		retTable0.setValue("ZZPAYDATE",paydate);
		retTable0.setValue("ZZACTAMOUNT1",actamount1);
		retTable0.setValue("ZZACTAMOUNT2",actamount2);

		

		
		//税金试算表
		String csql = "select a.ordno,a.orditem,a.num,a.invqty,a.invamt,a.fobvalue,a.freight,a.insurance,a.cifvalue,a.hscode,a.dutrate,a.duties,a.dutextem,a.taxbase,a.gstrate,a.gst,a.toltax,(select tax from uf_dmsd_taxwh where requestid = a.gstcode)gstcode,a.exchvalue,a.tolamt,a.shorttxt,a.unit,a.pztxt from uf_dmph_sjssdet a where a.requestid='"+requestid+"'";
		List clist = baseJdbc.executeSqlForList(csql);
		if(clist.size()>0)
		{
			for(int k2=0;k2<clist.size();k2++)
			{
				Map cmap = (Map)clist.get(k2);
				String ordno = StringHelper.null2String(cmap.get("ordno"));//PO NO
				ordno = ordno.replaceFirst("^0*", "");//去掉开头的0  
				String orditem = StringHelper.null2String(cmap.get("orditem"));//PO Item
				orditem = orditem.replaceFirst("^0*", "");////去掉开头的0 
				String num = StringHelper.null2String(cmap.get("num"));//Serial Number
				String invqty = StringHelper.null2String(cmap.get("invqty"));//Inv Qty
				String invamt = StringHelper.null2String(cmap.get("invamt"));//Inv Amt
				String fobvalue = StringHelper.null2String(cmap.get("fobvalue"));//FOB Value
				String freight = StringHelper.null2String(cmap.get("freight"));//Freight Value
				String insurance = StringHelper.null2String(cmap.get("insurance"));//Insurance Value
				String cifvalue = StringHelper.null2String(cmap.get("cifvalue"));//CIF Value
				String hscode = StringHelper.null2String(cmap.get("hscode"));//H.S.Code
				String dutrate = StringHelper.null2String(cmap.get("dutrate"));//Duties Rate(%)
				String duties = StringHelper.null2String(cmap.get("duties"));//Duties
				String dutextem = StringHelper.null2String(cmap.get("dutextem"));//Duties Extemption
				if(dutextem.equals("40288098276fc2120127704884290210"))
				{
					dutextem = "YES";
				}
				else
				{
					dutextem = "NO";
				}
				String taxbase = StringHelper.null2String(cmap.get("taxbase"));//Tax Base
				String gstrate = StringHelper.null2String(cmap.get("gstrate"));//GST Rate(%)
				String gst = StringHelper.null2String(cmap.get("gst"));//GST
				String toltax = StringHelper.null2String(cmap.get("toltax"));//Total Tax
				String gstcode = StringHelper.null2String(cmap.get("gstcode"));//GST Tax Code
				String exchvalue = StringHelper.null2String(cmap.get("exchvalue"));//Exchange Value
				String tolamt = StringHelper.null2String(cmap.get("tolamt"));//Total Amt
				String shorttxt = StringHelper.null2String(cmap.get("shorttxt"));//Short Tex
				String unit = StringHelper.null2String(cmap.get("unit"));//PO Unit
				String pztxt = StringHelper.null2String(cmap.get("pztxt"));//Item Text
				
				
				
				
				System.out.println("ordno:"+ordno);
				System.out.println("orditem:"+orditem);
				System.out.println("num:"+num);
				System.out.println("invqty:"+invqty);
				System.out.println("invamt:"+invamt);
				System.out.println("fobvalue:"+fobvalue);
				System.out.println("freight:"+freight);
				System.out.println("insurance:"+insurance);
				System.out.println("cifvalue:"+cifvalue);
				System.out.println("hscode:"+hscode);
				System.out.println("dutrate:"+dutrate);
				System.out.println("duties:"+duties);
				System.out.println("dutextem:"+dutextem);
				System.out.println("taxbase:"+taxbase);
				System.out.println("gstrate:"+gstrate);
				System.out.println("gst:"+gst);
				System.out.println("toltax:"+toltax);
				System.out.println("gstcode:"+gstcode);
				System.out.println("exchvalue:"+exchvalue);
				System.out.println("tolamt:"+tolamt);
				System.out.println("shorttxt:"+shorttxt);
				System.out.println("unit:"+unit);
				System.out.println("pztxt:"+pztxt);	
				

				
				JCoTable retTable5 = function.getTableParameterList().getTable("ITEM");
				retTable5.appendRow();
				retTable5.setValue("ZZFLOWERNO",flowerno);
				retTable5.setValue("ZZPO",ordno);
				retTable5.setValue("ZZPOITEM",orditem);
				retTable5.setValue("ZZNUM",num);
				retTable5.setValue("ZZINVQTY",invqty);
				retTable5.setValue("ZZINVAMT",invamt);
				retTable5.setValue("ZZFOBVALUE",fobvalue);
				retTable5.setValue("ZZFREIGHT",freight);
				retTable5.setValue("ZZINSURANCE",insurance);
				retTable5.setValue("ZZCIFVALUE",cifvalue);
				retTable5.setValue("ZZHSCODE",hscode);
				retTable5.setValue("ZZDUTRATE",dutrate);
				retTable5.setValue("ZZDUTIES",duties);
				retTable5.setValue("ZZDUTEXTEM",dutextem);
				retTable5.setValue("ZZTAXBASE",taxbase);
				retTable5.setValue("ZZGSTRATE",gstrate);
				retTable5.setValue("ZZGST",gst);
				retTable5.setValue("ZZTOLTAX",toltax);
				retTable5.setValue("ZZGSTCODE",gstcode);
				retTable5.setValue("ZZEXCHVALUE",exchvalue);
				retTable5.setValue("ZZINVAMT",tolamt);
				retTable5.setValue("ZZSHORTTXT",shorttxt);
				retTable5.setValue("ZZUNIT",unit);
				retTable5.setValue("ZZPZTXT",pztxt);
				
				
				

			
			}
		}
		
		
		
		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}


		JSONObject jo = new JSONObject();		
		jo.put("res", "true");
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();

%>
