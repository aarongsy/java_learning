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


<%
	String ismark = "0";
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String requestid = StringHelper.null2String(request.getParameter("requestid"));//resid
	String saleno = StringHelper.null2String(request.getParameter("saleno"));//销售单号
	String items = StringHelper.null2String(request.getParameter("items"));//销售单项次
	//System.out.println("saleno:"+saleno);
	//System.out.println("items:"+items);
	String neworder = "";
	String newitem = "";
	if(saleno.indexOf(",")!=-1)//同一张Order Adv含有多个订单号
	{
		System.out.println("More Sales Order!");	
		String[] array = saleno.split("\\,");//分割字符串
		String[] tarray = items.split("\\,");
		for(int i=0;i<array.length;i++)
		{
			neworder = array[i];
			newitem = tarray[i];
			//System.out.println("neworder:"+array[i]);
			//System.out.println("newitem:"+tarray[i]);
			//创建SAP对象
			SapConnector sapConnector = new SapConnector();
			String functionName = "ZOA_SD_SO_INFO_MM";
			JCoFunction function = null;
			try {
				function = SapConnector.getRfcFunction(functionName);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//插入字段至SAP(作为查询条件)
			function.getImportParameterList().setValue("VBELN",array[i]);//销售单号
			function.getImportParameterList().setValue("POSNR",tarray[i]);//订单项次
			function.getImportParameterList().setValue("MARK","X");//标记符(表示本次操作是更新)
			
			try 
			{
				function.execute(sapConnector.getDestination(sapConnector.fdPoolName));	
			} 
			catch (JCoException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			catch (Exception e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			//返回值(主表)
			String comcode = function.getExportParameterList().getValue("BUKRS_VF").toString();//公司代码
			//System.out.println(comcode);
			String comtype = "";
			String sql1 = "select requestid from getcompanyview where objno = '"+comcode+"'";
			List list1 = baseJdbc.executeSqlForList(sql1);
			if(list1.size()>0)
			{
				Map map1 = (Map)list1.get(0);
				comtype = StringHelper.null2String(map1.get("requestid"));//公司别
			}
			String fxqd = function.getExportParameterList().getValue("VTWEG").toString();//分销渠道
			String exlo = "";//内/外销
			if(fxqd.equals("10"))
			{
				exlo = "40285a8d5de3a2c2015de3bd00a70042";
			}
			else
			{
				exlo = "40285a8d5de3a2c2015de3bd00a70043";
			}
			
			String lcnum =StringHelper.null2String(function.getExportParameterList().getValue("LCNUM"));//财务凭证号(信用证)
			String ordtype = StringHelper.null2String(function.getExportParameterList().getValue("TYPED"));//订单类型(子表)
			String costcen = StringHelper.null2String(function.getExportParameterList().getValue("KOSTL"));//成本中心(子表)
			String profit = StringHelper.null2String(function.getExportParameterList().getValue("PRCTR"));//利润中心(子表)
			String cpdl = StringHelper.null2String(function.getExportParameterList().getValue("VTEXT"));//产品大类(子表)
			String pono = StringHelper.null2String(function.getExportParameterList().getValue("BSTNK"));//客户订单编号(子表)
			String xdfreeze = StringHelper.null2String(function.getExportParameterList().getValue("CMPSA"));//信贷冻结(子表)
			
			String lcno = "";
			String issdate = "";
			if(!lcnum.equals(""))
			{
				lcnum = lcnum.replaceFirst("^0*", "");//去掉字符串开头的0  
				String sql2 = "select creditno,outdate from uf_dmsd_excredit where finproofno = '"+lcnum+"'";
				List list2 = baseJdbc.executeSqlForList(sql2);
				if(list2.size()>0)
				{
					Map map2 = (Map)list2.get(0);
					lcno = StringHelper.null2String(map2.get("creditno"));//信用证编号
					issdate = StringHelper.null2String(map2.get("outdate"));//发行日期
				}
			}

			SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
			//预计到港日
			String xdate = StringHelper.null2String(function.getExportParameterList().getValue("ZETA"));
			String dgdate="";
			if(!xdate.equals(""))
			{
				Date date1 = new Date(xdate);
				dgdate = sdf.format(date1);
			}
			//预计开航日
			String ydate = StringHelper.null2String(function.getExportParameterList().getValue("ZETD"));
			String khdate ="";
			if(!ydate.equals(""))
			{
				Date date2 = new Date(ydate);
				khdate = sdf.format(date2);
			}
			//预计结关日
			String zdate = StringHelper.null2String(function.getExportParameterList().getValue("ZCLDATE"));
			String clodate = "";
			if(!zdate.equals(""))
			{
				Date date3 = new Date(zdate);
				clodate = sdf.format(date3);
			}
			

			String kunnr = StringHelper.null2String(function.getExportParameterList().getValue("KUNNR"));//售达方代码
			if(kunnr.indexOf("'")!=-1)//英文单引号转中文单引号
			{
				kunnr = kunnr.replace("'","’"); 
			}
			String name1 = StringHelper.null2String(function.getExportParameterList().getValue("NAME1"));//售达方名称
			if(name1.indexOf("'")!=-1)
			{
				name1 = name1.replace("'","’"); 
			}
			String land1 = StringHelper.null2String(function.getExportParameterList().getValue("LAND1"));//售达方国别
			if(land1.indexOf("'")!=-1)
			{
				land1 = land1.replace("'","’"); 
			}
			String stras1 =StringHelper.null2String( function.getExportParameterList().getValue("STRAS1"));//售达方地址
			if(stras1.indexOf("'")!=-1)
			{
				stras1 = stras1.replace("'","’"); 
			}
			String sunnr = StringHelper.null2String(function.getExportParameterList().getValue("SUNNR"));//送达方代码
			if(sunnr.indexOf("'")!=-1)
			{
				sunnr = sunnr.replace("'","’"); 
			}
			String name2 = StringHelper.null2String(function.getExportParameterList().getValue("NAME2"));//送达方名称
			if(name2.indexOf("'")!=-1)
			{
				name2 = name2.replace("'","’"); 
			}
			String land2 = StringHelper.null2String(function.getExportParameterList().getValue("LAND2"));//送达方国别
			if(land2.indexOf("'")!=-1)
			{
				land2 = land2.replace("'","’"); 
			}
			String stras2 =StringHelper.null2String( function.getExportParameterList().getValue("STRAS2"));//送达方地址
			if(stras2.indexOf("'")!=-1)
			{
				stras2 = stras2.replace("'","’"); 
			}
			String zterm = StringHelper.null2String(function.getExportParameterList().getValue("ZTERM"));//付款条款代码
			if(zterm.indexOf("'")!=-1)
			{
				zterm = zterm.replace("'","’"); 
			}
			String text1 =StringHelper.null2String( function.getExportParameterList().getValue("TEXT1"));//付款条款文本
			if(text1.indexOf("'")!=-1)
			{
				text1 = text1.replace("'","’"); 
			}
			String inco1 = StringHelper.null2String(function.getExportParameterList().getValue("INCO1"));//国贸条件1
			if(inco1.indexOf("'")!=-1)
			{
				inco1 = inco1.replace("'","’"); 
			}
			String inco2 = StringHelper.null2String(function.getExportParameterList().getValue("INCO2"));//国贸条件2
			if(inco2.indexOf("'")!=-1)
			{
				inco2 = inco2.replace("'","’"); 
			}
			String waerk = StringHelper.null2String(function.getExportParameterList().getValue("WAERK"));//币种
			if(waerk.indexOf("'")!=-1)
			{
				waerk = waerk.replace("'","’"); 
			}
			String zlsch = StringHelper.null2String(function.getExportParameterList().getValue("ZLSCH"));//付款方式代码
			if(zlsch.indexOf("'")!=-1)
			{
				zlsch = zlsch.replace("'","’"); 
			}
			String text2 = StringHelper.null2String(function.getExportParameterList().getValue("TEXT2"));//付款方式文本
			if(text2.indexOf("'")!=-1)
			{
				text2 = text2.replace("'"," "); 
			}
			//代理商客户简码+代理商客户名称
			String agentcus = StringHelper.null2String(function.getExportParameterList().getValue("LIFNR"))+"    "+StringHelper.null2String(function.getExportParameterList().getValue("NAME3"));
			if(agentcus.indexOf("'")!=-1)
			{
				agentcus = agentcus.replace("'","’"); 
			}
			String consig ="";
			String notify ="";
			String remark ="";
			String tag1 ="";
			String tag2 ="";
			String tag3 ="";
			String tag4 ="";
			String sql3 = "select consig,notify,remark,tag1,tag2,tag3,tag4 from uf_dmsd_shipmark where saleparty='"+kunnr+"' and sendparty='"+sunnr+"'";
			List list3 = baseJdbc.executeSqlForList(sql3);
			if(list3.size()>0)
			{
				Map map3 = (Map)list3.get(0);
				consig = StringHelper.null2String(map3.get("consig"));
				notify = StringHelper.null2String(map3.get("notify"));
				remark = StringHelper.null2String(map3.get("remark"));
				tag1 = StringHelper.null2String(map3.get("tag1"));
				tag2 = StringHelper.null2String(map3.get("tag2"));
				tag3 = StringHelper.null2String(map3.get("tag3"));
				tag4 = StringHelper.null2String(map3.get("tag4"));
			}
			
			//获取SAP子表返回值
			JCoTable newretTable = function.getTableParameterList().getTable("SD_SO_ITEMS");
			//System.out.println("lenxxx:"+newretTable.getNumRows());
			String dostr = "";//拼接交运单号
			if(newretTable.getNumRows() >0)
			{
				System.out.println("len:"+newretTable.getNumRows());
				for(int j= 0;j<newretTable.getNumRows();j++)
				{
					if(j == 0)
					{
						newretTable.firstRow();//获取返回表格数据中的第一行
					}
					else
					{
						newretTable.nextRow();//获取下一行数据
					}

					String wlh = newretTable.getString("MATNR");//物料号
					String wlms = newretTable.getString("ARKTX");//物料描述
					String ordnum = newretTable.getString("KWMENG");//订单数量
					String unit = newretTable.getString("VRKME");//订单单位
					String price = newretTable.getString("NETPR2");//单价
					String jjz = newretTable.getString("NETWR");//净价值
					String yj = newretTable.getString("KWERT");//佣金
					String vdatu = newretTable.getString("VDATU");//预定交货日
					String pakdes = newretTable.getString("MSEHL");//包装描述
					String pc = newretTable.getString("CHARG");//批次
					String kw = newretTable.getString("LGORT");//库位
					String materdes = newretTable.getString("KMATNR");//客户物料描述
					String cusnotes = newretTable.getString("REMARK");//客户备注
					String sdcurr = newretTable.getString("WAERK");//SD货币凭证
					String unprice = newretTable.getString("NETPR1");//未税单价(1000KG)
					String podate = newretTable.getString("BSTDK");//客户采购订单日期
					String rebate = newretTable.getString("REBATE");//回扣
					String specnorm = newretTable.getString("KDKG2");//特殊规格
					String dono = newretTable.getString("DO");//交运单号
					String doitem = newretTable.getString("DO_ITEM");//交运单项次
					String doqty = newretTable.getString("DO_LFIMG");//交运单数量
					dostr = dostr + dono + ",";
					
					//更新Order Adv出货明细
					String upsql2 = "update uf_dmsd_deldetail set ordtype='"+ordtype+"',ccen='"+costcen+"',lcen='"+profit+"',procategory='"+cpdl+"',ordno='"+pono+"',wlno='"+wlh+"',wldes='"+wlms+"',amount='"+ordnum+"',unit='"+unit+"',price='"+price+"',worth='"+jjz+"',yj='"+yj+"',jhdate='"+vdatu+"',pagdes='"+pakdes+"',pc='"+pc+"',kw='"+kw+"',materdes='"+materdes+"',cusnotes='"+cusnotes+"',sdcurr='"+sdcurr+"',unprice='"+unprice+"',podate='"+podate+"',rebate='"+rebate+"',specnorm='"+specnorm+"',xdfreeze='"+xdfreeze+"' where requestid='"+requestid+"' and salno='"+neworder+"' and num='"+newitem+"'";
					//System.out.println("upsql2:"+upsql2);
					baseJdbc.update(upsql2);
					
					
					//判断是否存在未删除且有效的外销单(若存在则更新外销联络单信息)
					String resid = "";
					String sql4 = "select wx.* from uf_dmsd_expboxmain wx left join requestbase req on wx.requestid=req.id where req.isdelete=0 and wx.isvalid='40288098276fc2120127704884290210' and wx.shipnotice='"+requestid+"'";
					List list4 = baseJdbc.executeSqlForList(sql4);
					if(list4.size()>0)
					{
						Map map4 = (Map)list4.get(0);
						resid = StringHelper.null2String(map4.get("requestid"));//外销联络单requestid
						//更新Shipment Adv抬头信息
						String upsql3 = "update uf_dmsd_expboxmain set comcode='"+comcode+"',comtype='"+comtype+"',fxchannel='"+fxqd+"',xyzno='"+lcnum+"',creditno='"+lcno+"',toportdate='"+dgdate+"',saildate='"+khdate+"',cleardate='"+clodate+"',soldparty='"+name1+"',soldcountry='"+land1+"',soldaddress='"+stras1+"',sendparty='"+name2+"',sendcountry='"+land2+"',sendaddress='"+stras2+"',paytermcode='"+zterm+"',paytermtxt='"+text1+"',itcterm1='"+inco1+"',itcterm2='"+inco2+"',currency='"+waerk+"',paymethod='"+text2+"',consignee='"+consig+"',notifyparty='"+notify+"',shipnotes='"+remark+"',tag1='"+tag1+"',tag2='"+tag2+"',tag3='"+tag3+"',tag4='"+tag4+"' where shipnotice='"+requestid+"' and requestid='"+resid+"'";
						System.out.println("upsql3:"+upsql3);
						baseJdbc.update(upsql3);
						ismark = "1";
					}		
					if(ismark.equals("1"))
					{
						//更新Shipping Adv出货明细
						String upsql4 = "update uf_dmsd_shipment set deliveryno='"+dono+"',deliveryitem='"+doitem+"',realshipnum='"+doqty+"',costcenter='"+costcen+"',lcen='"+profit+"',procategory='"+cpdl+"',cusordno='"+pono+"',stockno='"+wlh+"',stockdesc='"+wlms+"',shipnum='"+ordnum+"',saleunit='"+unit+"',netprice='"+price+"',netvalue='"+jjz+"',location='"+kw+"',materdes='"+materdes+"',remark='"+cusnotes+"',xdfreeze='"+xdfreeze+"' where requestid='"+resid+"' and saleorder='"+neworder+"' and orderitem='"+newitem+"'";
						//System.out.println("upsql4:"+upsql4);
						baseJdbc.update(upsql4);
					}
				}
			}
			
			if(dostr.indexOf(",")!=-1)
			{
				dostr = dostr.substring(0,dostr.length()-1);
			}
			//更新Order Adv抬头信息
			String upsql1 = "update uf_dmsd_delnotes set jynumber='"+dostr+"',comcode='"+comcode+"',comtype='"+comtype+"',fxchannel='"+fxqd+"',inoutsale='"+exlo+"',xyzno='"+lcnum+"',lcno='"+lcno+"',issdate='"+issdate+"',dgdate='"+dgdate+"',khdate='"+khdate+"',jgdate='"+clodate+"',salecode='"+kunnr+"',saleside='"+name1+"',salecoun='"+land1+"',saleadd='"+stras1+"',sendcode='"+sunnr+"',sendside='"+name2+"',sendcoun='"+land2+"',sendadd='"+stras2+"',paycode='"+zterm+"',paytxt='"+text1+"',payty='"+zlsch+"',paytytxt='"+text2+"',tradcon1='"+inco1+"',tradcon2='"+inco2+"',curr='"+waerk+"',trader='"+agentcus+"',consign='"+consig+"',notify='"+notify+"',remark='"+remark+"',tag1='"+tag1+"',tag2='"+tag2+"',tag3='"+tag3+"',tag4='"+tag4+"' where requestid='"+requestid+"'";
			//System.out.println("upsql1:"+upsql1);
			baseJdbc.update(upsql1);
		}
	}
	
	else
	{
		System.out.println("One Sales Order!");
		String tsql = "select salno,num from uf_dmsd_deldetail where requestid='"+requestid+"' and salno='"+saleno+"'";
		List tlist = baseJdbc.executeSqlForList(tsql);
		if(tlist.size()>0)
		{
			Map tmap = (Map)tlist.get(0);
			neworder = StringHelper.null2String(tmap.get("salno"));//销售订单
			newitem = StringHelper.null2String(tmap.get("num"));//订单项次
		}
		
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZOA_SD_SO_INFO_MM";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//插入字段至SAP(作为查询条件)
		function.getImportParameterList().setValue("VBELN",saleno);//销售单号
		function.getImportParameterList().setValue("POSNR",items);//订单项次
		function.getImportParameterList().setValue("MARK","X");//标记符(表示本次操作是更新)

		try 
		{
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
		} 
		catch (JCoException e) 
		{
			//TODO Auto-generated catch block
			e.printStackTrace();
		} 
		catch (Exception e) 
		{
			//TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		//返回值(主表)
		String comcode = function.getExportParameterList().getValue("BUKRS_VF").toString();//公司代码
		String comtype = "";
		String sql1 = "select requestid from getcompanyview where objno = '"+comcode+"'";
		List list1 = baseJdbc.executeSqlForList(sql1);
		if(list1.size()>0)
		{
			Map map1 = (Map)list1.get(0);
			comtype = StringHelper.null2String(map1.get("requestid"));//公司别
		}
		String fxqd = function.getExportParameterList().getValue("VTWEG").toString();//分销渠道
		String exlo = "";//内/外销
		if(fxqd.equals("10"))
		{
			exlo = "40285a8d5de3a2c2015de3bd00a70042";
		}
		else
		{
			exlo = "40285a8d5de3a2c2015de3bd00a70043";
		}
		
		String lcnum =StringHelper.null2String(function.getExportParameterList().getValue("LCNUM"));//财务凭证号(信用证)
		String ordtype = StringHelper.null2String(function.getExportParameterList().getValue("TYPED"));//订单类型(子表)
		String costcen = StringHelper.null2String(function.getExportParameterList().getValue("KOSTL"));//成本中心(子表)
		String profit = StringHelper.null2String(function.getExportParameterList().getValue("PRCTR"));//利润中心(子表)
		String cpdl = StringHelper.null2String(function.getExportParameterList().getValue("VTEXT"));//产品大类(子表)
		String pono = StringHelper.null2String(function.getExportParameterList().getValue("BSTNK"));//客户订单编号(子表)
		String xdfreeze = StringHelper.null2String(function.getExportParameterList().getValue("CMPSA"));//信贷冻结(子表)
		
		String lcno = "";
		String issdate = "";
		if(!lcnum.equals(""))
		{
			lcnum = lcnum.replaceFirst("^0*", "");//去掉字符串开头的0
			String sql2 = "select creditno,outdate from uf_dmsd_excredit where finproofno = '"+lcnum+"'";
			List list2 = baseJdbc.executeSqlForList(sql2);
			if(list2.size()>0)
			{
				Map map2 = (Map)list2.get(0);
				lcno = StringHelper.null2String(map2.get("creditno"));//信用证编号
				issdate = StringHelper.null2String(map2.get("outdate"));//发行日期
			}
		}
		SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
		//预计到港日
		String xdate = StringHelper.null2String(function.getExportParameterList().getValue("ZETA"));
		String dgdate="";
		if(!xdate.equals(""))
		{
			Date date1 = new Date(xdate);
			dgdate = sdf.format(date1);
		}
		//预计开航日
		String ydate = StringHelper.null2String(function.getExportParameterList().getValue("ZETD"));
		String khdate ="";
		if(!ydate.equals(""))
		{
			Date date2 = new Date(ydate);
			khdate = sdf.format(date2);
		}
		//预计结关日
		String zdate = StringHelper.null2String(function.getExportParameterList().getValue("ZCLDATE"));
		String clodate = "";
		if(!zdate.equals(""))
		{
			Date date3 = new Date(zdate);
			clodate =sdf.format(date3);
		}

		String kunnr = StringHelper.null2String(function.getExportParameterList().getValue("KUNNR"));//售达方代码
		if(kunnr.indexOf("'")!=-1)//英文单引号转中文单引号
		{
			kunnr = kunnr.replace("'","’"); 
		}
		String name1 = StringHelper.null2String(function.getExportParameterList().getValue("NAME1"));//售达方名称
		if(name1.indexOf("'")!=-1)
		{
			name1 = name1.replace("'","’"); 
		}
		String land1 = StringHelper.null2String(function.getExportParameterList().getValue("LAND1"));//售达方国别
		if(land1.indexOf("'")!=-1)
		{
			land1 = land1.replace("'","’"); 
		}
		String stras1 =StringHelper.null2String( function.getExportParameterList().getValue("STRAS1"));//售达方地址
		if(stras1.indexOf("'")!=-1)
		{
			stras1 = stras1.replace("'","’"); 
		}
		String sunnr = StringHelper.null2String(function.getExportParameterList().getValue("SUNNR"));//送达方代码
		if(sunnr.indexOf("'")!=-1)
		{
			sunnr = sunnr.replace("'","’"); 
		}
		String name2 = StringHelper.null2String(function.getExportParameterList().getValue("NAME2"));//送达方名称
		if(name2.indexOf("'")!=-1)
		{
			name2 = name2.replace("'","’"); 
		}
		String land2 = StringHelper.null2String(function.getExportParameterList().getValue("LAND2"));//送达方国别
		if(land2.indexOf("'")!=-1)
		{
			land2 = land2.replace("'","’"); 
		}
		String stras2 =StringHelper.null2String( function.getExportParameterList().getValue("STRAS2"));//送达方地址
		if(stras2.indexOf("'")!=-1)
		{
			stras2 = stras2.replace("'","’"); 
		}
		String zterm = StringHelper.null2String(function.getExportParameterList().getValue("ZTERM"));//付款条款代码
		if(zterm.indexOf("'")!=-1)
		{
			zterm = zterm.replace("'","’"); 
		}
		String text1 =StringHelper.null2String( function.getExportParameterList().getValue("TEXT1"));//付款条款文本
		if(text1.indexOf("'")!=-1)
		{
			text1 = text1.replace("'","’"); 
		}
		String inco1 = StringHelper.null2String(function.getExportParameterList().getValue("INCO1"));//国贸条件1
		if(inco1.indexOf("'")!=-1)
		{
			inco1 = inco1.replace("'","’"); 
		}
		String inco2 = StringHelper.null2String(function.getExportParameterList().getValue("INCO2"));//国贸条件2
		if(inco2.indexOf("'")!=-1)
		{
			inco2 = inco2.replace("'","’"); 
		}
		String waerk = StringHelper.null2String(function.getExportParameterList().getValue("WAERK"));//币种
		if(waerk.indexOf("'")!=-1)
		{
			waerk = waerk.replace("'","’"); 
		}
		String zlsch = StringHelper.null2String(function.getExportParameterList().getValue("ZLSCH"));//付款方式代码
		if(zlsch.indexOf("'")!=-1)
		{
			zlsch = zlsch.replace("'","’"); 
		}
		String text2 = StringHelper.null2String(function.getExportParameterList().getValue("TEXT2"));//付款方式文本
		if(text2.indexOf("'")!=-1)
		{
			text2 = text2.replace("'"," "); 
		}
		//代理商客户简码+代理商客户名称
		String agentcus = StringHelper.null2String(function.getExportParameterList().getValue("LIFNR"))+"    "+StringHelper.null2String(function.getExportParameterList().getValue("NAME3"));
		if(agentcus.indexOf("'")!=-1)
		{
			agentcus = agentcus.replace("'","’"); 
		}
		String consig ="";
		String notify ="";
		String remark ="";
		String tag1 ="";
		String tag2 ="";
		String tag3 ="";
		String tag4 ="";
		String sql3 = "select consig,notify,remark,tag1,tag2,tag3,tag4 from uf_dmsd_shipmark where saleparty='"+kunnr+"' and sendparty='"+sunnr+"'";
		List list3 = baseJdbc.executeSqlForList(sql3);
		if(list3.size()>0)
		{
			Map map3 = (Map)list3.get(0);
			consig = StringHelper.null2String(map3.get("consig"));
			notify = StringHelper.null2String(map3.get("notify"));
			remark = StringHelper.null2String(map3.get("remark"));
			tag1 = StringHelper.null2String(map3.get("tag1"));
			tag2 = StringHelper.null2String(map3.get("tag2"));
			tag3 = StringHelper.null2String(map3.get("tag3"));
			tag4 = StringHelper.null2String(map3.get("tag4"));
		}
		
		
		//获取SAP子表返回值
		JCoTable newretTable = function.getTableParameterList().getTable("SD_SO_ITEMS");
		//System.out.println("lenxxx:"+newretTable.getNumRows());
		String dostr = "";//拼接交运单号
		if(newretTable.getNumRows() >0)
		{
			//System.out.println("len:"+newretTable.getNumRows());
			for(int j= 0;j<newretTable.getNumRows();j++)
			{
				if(j == 0)
				{
					newretTable.firstRow();//获取返回表格数据中的第一行
				}
				else
				{
					newretTable.nextRow();//获取下一行数据
				}

				String wlh = newretTable.getString("MATNR");//物料号
				String wlms = newretTable.getString("ARKTX");//物料描述
				String ordnum = newretTable.getString("KWMENG");//订单数量
				String unit = newretTable.getString("VRKME");//订单单位
				String price = newretTable.getString("NETPR2");//单价
				String jjz = newretTable.getString("NETWR");//净价值
				String yj = newretTable.getString("KWERT");//佣金
				String vdatu = newretTable.getString("VDATU");//预定交货日
				String pakdes = newretTable.getString("MSEHL");//包装描述
				String pc = newretTable.getString("CHARG");//批次
				String kw = newretTable.getString("LGORT");//库位
				String materdes = newretTable.getString("KMATNR");//客户物料描述
				String cusnotes = newretTable.getString("REMARK");//客户备注
				String sdcurr = newretTable.getString("WAERK");//SD货币凭证
				String unprice = newretTable.getString("NETPR1");//未税单价(1000KG)
				unprice = unprice.trim();
				String podate = newretTable.getString("BSTDK");//客户采购订单日期
				String rebate = newretTable.getString("REBATE");//回扣
				String specnorm = newretTable.getString("KDKG2");//特殊规格
				String dono = newretTable.getString("DO");//交运单号
				String doitem = newretTable.getString("DO_ITEM");//交运单项次
				String doqty = newretTable.getString("DO_LFIMG");//发货数量
				dostr = dostr + dono + ",";


				//更新Order Adv出货明细
				String upsql2 = "update uf_dmsd_deldetail set ordtype='"+ordtype+"',ccen='"+costcen+"',lcen='"+profit+"',procategory='"+cpdl+"',ordno='"+pono+"',wlno='"+wlh+"',wldes='"+wlms+"',amount='"+ordnum+"',unit='"+unit+"',price='"+price+"',worth='"+jjz+"',yj='"+yj+"',jhdate='"+vdatu+"',pagdes='"+pakdes+"',pc='"+pc+"',kw='"+kw+"',materdes='"+materdes+"',cusnotes='"+cusnotes+"',sdcurr='"+sdcurr+"',unprice='"+unprice+"',podate='"+podate+"',rebate='"+rebate+"',specnorm='"+specnorm+"',xdfreeze='"+xdfreeze+"' where requestid='"+requestid+"' and salno='"+neworder+"' and num='"+newitem+"'";
				//System.out.println("order advice details:"+upsql2);
				baseJdbc.update(upsql2);
				
				
				//判断是否存在未删除且有效的外销单(若存在则更新外销联络单信息)
				String resid = "";
				String sql4 = "select wx.* from uf_dmsd_expboxmain wx left join requestbase req on wx.requestid=req.id where req.isdelete=0 and wx.isvalid='40288098276fc2120127704884290210' and wx.shipnotice='"+requestid+"'";
				List list4 = baseJdbc.executeSqlForList(sql4);
				if(list4.size()>0)
				{
					Map map4 = (Map)list4.get(0);
					resid = StringHelper.null2String(map4.get("requestid"));//外销联络单requestid
					//更新Shipment Adv抬头信息
					String upsql3 = "update uf_dmsd_expboxmain set comcode='"+comcode+"',comtype='"+comtype+"',fxchannel='"+fxqd+"',xyzno='"+lcnum+"',creditno='"+lcno+"',toportdate='"+dgdate+"',saildate='"+khdate+"',cleardate='"+clodate+"',soldparty='"+name1+"',soldcountry='"+land1+"',soldaddress='"+stras1+"',sendparty='"+name2+"',sendcountry='"+land2+"',sendaddress='"+stras2+"',paytermcode='"+zterm+"',paytermtxt='"+text1+"',itcterm1='"+inco1+"',itcterm2='"+inco2+"',currency='"+waerk+"',paymethod='"+text2+"',consignee='"+consig+"',notifyparty='"+notify+"',shipnotes='"+remark+"',tag1='"+tag1+"',tag2='"+tag2+"',tag3='"+tag3+"',tag4='"+tag4+"' where shipnotice='"+requestid+"' and requestid='"+resid+"'";
					//System.out.println("upsql3:"+upsql3);
					baseJdbc.update(upsql3);
					ismark = "1";
				}
				if(ismark.equals("1"))
				{
					//更新Shipping Adv出货明细
					String upsql4 = "update uf_dmsd_shipment set deliveryno='"+dono+"',deliveryitem='"+doitem+"',realshipnum='"+doqty+"',costcenter='"+costcen+"',lcen='"+profit+"',procategory='"+cpdl+"',cusordno='"+pono+"',stockno='"+wlh+"',stockdesc='"+wlms+"',shipnum='"+ordnum+"',saleunit='"+unit+"',netprice='"+price+"',netvalue='"+jjz+"',location='"+kw+"',materdes='"+materdes+"',remark='"+cusnotes+"',xdfreeze='"+xdfreeze+"' where requestid='"+resid+"' and saleorder='"+neworder+"' and orderitem='"+newitem+"'";
					//System.out.println("upsql4:"+upsql4);
					baseJdbc.update(upsql4);
				}
			}
		}
		
		if(dostr.indexOf(",")!=-1)
		{
			dostr = dostr.substring(0,dostr.length()-1);
		}
		//更新Order Adv抬头信息
		String upsql1 = "update uf_dmsd_delnotes set jynumber='"+dostr+"',comcode='"+comcode+"',comtype='"+comtype+"',fxchannel='"+fxqd+"',inoutsale='"+exlo+"',xyzno='"+lcnum+"',lcno='"+lcno+"',issdate='"+issdate+"',dgdate='"+dgdate+"',khdate='"+khdate+"',jgdate='"+clodate+"',salecode='"+kunnr+"',saleside='"+name1+"',salecoun='"+land1+"',saleadd='"+stras1+"',sendcode='"+sunnr+"',sendside='"+name2+"',sendcoun='"+land2+"',sendadd='"+stras2+"',paycode='"+zterm+"',paytxt='"+text1+"',payty='"+zlsch+"',paytytxt='"+text2+"',tradcon1='"+inco1+"',tradcon2='"+inco2+"',curr='"+waerk+"',trader='"+agentcus+"',consign='"+consig+"',notify='"+notify+"',remark='"+remark+"',tag1='"+tag1+"',tag2='"+tag2+"',tag3='"+tag3+"',tag4='"+tag4+"' where requestid='"+requestid+"'";
		//System.out.println("upsql1:"+upsql1);
		baseJdbc.update(upsql1);
	}
	
	
	//response.setContentType("application/json; charset=utf-8");
	//response.getWriter().write(jo.toString());
	//response.getWriter().flush();
	//response.getWriter().close();
%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          