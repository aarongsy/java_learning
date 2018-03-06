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
 	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String delsql="delete from uf_dmsd_saledetails";//（马来）销售订单明细SAP
	baseJdbc.update(delsql);


	String saleno = StringHelper.null2String(request.getParameter("saleno"));//销售单号
	String cptype = StringHelper.null2String(request.getParameter("procategory"));//产品大类
	String soldcode = StringHelper.null2String(request.getParameter("soldcode"));//售达方简码
	String shipcode = StringHelper.null2String(request.getParameter("shipcode"));//送达方简码
	//String ddtype = StringHelper.null2String(request.getParameter("ordertype"));//订单类型
	String materno = StringHelper.null2String(request.getParameter("materno"));//物料号
	String fspay = StringHelper.null2String(request.getParameter("payway"));//付款方式
	String tkpay = StringHelper.null2String(request.getParameter("payterm"));//付款条款
	
	String closdate1 = StringHelper.null2String(request.getParameter("closdate1"));//预计结关日(起)
	String tclosdate1 = "";
	if(!closdate1.equals(""))
	{
		tclosdate1 = closdate1.replace("-", "");//转格式
	}
	
	String closdate2 = StringHelper.null2String(request.getParameter("closdate2"));//预计结关日(止)
	String tclosdate2 = "";
	if(!closdate2.equals(""))
	{
		tclosdate2 = closdate2.replace("-", "");
	}


	String orddate1 = StringHelper.null2String(request.getParameter("orddate1"));//Order Date(Start)
	String orddate2 = StringHelper.null2String(request.getParameter("orddate2"));//Order Date(End)
	String packtype = StringHelper.null2String(request.getParameter("packtype"));//Packing Type
	String cusorderno = StringHelper.null2String(request.getParameter("cusorderno"));//Customer Order Number
	String desport = StringHelper.null2String(request.getParameter("desport"));//Destination Port
	String country = StringHelper.null2String(request.getParameter("country"));//Country(送达方国别)
	String liner = StringHelper.null2String(request.getParameter("liner"));//Liner
	String lcno = StringHelper.null2String(request.getParameter("lcno"));//LC Number
	String mother = StringHelper.null2String(request.getParameter("mother"));//Mother Vessel
	String feeder = StringHelper.null2String(request.getParameter("feeder"));//Feeder Vessel


	//OA.......................................................................................................................
	//get data from OA
	String sql="select a.salno saleorder,a.ordtype ordertype,a.num item,a.procategory,a.materdes,a.specnorm,b.telno,b.salecode soldparty,b.saleside soldname,b.salecoun soldcountry,b.sendcode shipparty,b.sendside shipname,b.sendcoun shipcountry,a.wldes grade,a.amount qtypac,a.pagdes packaging,a.qtykg,a.unit,b.curr currency,a.price,a.per,b.tradcon1 shipterm1,b.tradcon2 shipterm2,(select objname from selectitem where id=b.jhstatus)jhstatus,(select objname from selectitem where id=b.status)status,b.jgdate closdate,b.khdate etd,b.dgdate eta,b.qyg,b.mdg,b.salecoun shipcode,a.podate recedate,a.ordno cuspono,b.paytytxt payway,b.paytxt payterm,''actgldate,''invono,''invodate,''dono,''dodate,''bldate,''blnumber,a.wlno matercode,a.pc lotnumber,''postqty,''saleunit,''baseqty,''baseunit,a.yj commvalue,a.rebate,b.hydltxt forwarder,b.shipno,b.shipcomtxt shipline,b.month movessel,b.feeder fevessel,''lcdate,b.xyzno lcno,''lcamount,''adpaydate,''paystatus,''paydate from uf_dmsd_deldetail a left join uf_dmsd_delnotes b on a.requestid=b.requestid left join requestbase req on b.requestid=req.id where req.isdelete=0 and b.isvalid='40288098276fc2120127704884290210' and b.area='40285a8d56d542730156e9932c4d32e4'";
	
	//System.out.println("sql:--------"+sql);
	
	//以下为查询条件
	if(!saleno.equals(""))//销售单号
	{
		sql=sql+" and a.salno='"+saleno+"'";
	}

	if(!cptype.equals(""))//产品大类
	{
		sql=sql+" and a.procategory='"+cptype+"'";
	}

	if(!soldcode.equals(""))
	{
		sql=sql+" and b.salecode='"+soldcode+"'";
	}

	if(!shipcode.equals(""))
	{
		sql=sql+" and b.sendcode='"+shipcode+"'";
	}
	if(!materno.equals(""))
	{
		sql=sql+" and a.wlno='"+materno+"'";
	}
	if(!fspay.equals(""))
	{
		sql=sql+" and b.paytytxt='"+fspay+"'";
	}
	if(!tkpay.equals(""))
	{
		sql=sql+" and b.paytxt='"+tkpay+"'";
	}
	if(!closdate1.equals(""))
	{
		sql=sql+" and b.jgdate>='"+closdate1+"'";
	}
	if(!closdate2.equals(""))
	{
		sql=sql+" and b.jgdate<='"+closdate2+"'";
	}
	if(!orddate1.equals(""))
	{
		sql=sql+" and a.podate>='"+orddate1+"'";
	}
	if(!orddate2.equals(""))
	{
		sql=sql+" and a.podate<='"+orddate2+"'";
	}
	if(!packtype.equals(""))
	{
		sql=sql+" and a.unit='"+packtype+"'";
	}
	if(!cusorderno.equals(""))
	{
		sql=sql+" and a.ordno='"+cusorderno+"'";
	}
	if(!desport.equals(""))
	{
		sql=sql+" and b.mdg='"+desport+"'";
	}
	if(!country.equals(""))
	{
		sql=sql+" and b.sendcoun='"+country+"'";
	}
	if(!liner.equals(""))
	{
		sql=sql+" and b.shipcom='"+liner+"'";
	}
	if(!lcno.equals(""))
	{
		sql=sql+" and b.lcno='"+lcno+"'";
	}
	if(!mother.equals(""))
	{
		sql=sql+" and b.month='"+mother+"'";
	}
	if(!feeder.equals(""))
	{
		sql=sql+" and b.feeder='"+feeder+"'";
	}
	//System.out.println("哈哈哈哈哈哈");

	List list = baseJdbc.executeSqlForList(sql);
	System.out.println("list.size():"+list.size());
	if(list.size()>0)
	{
		for(int k=0;k<list.size();k++)
		{
			Map map = (Map)list.get(k);
			String xsaleorder = StringHelper.null2String(map.get("saleorder"));//Sales Order
			String xordertype = StringHelper.null2String(map.get("ordertype"));//Order Type
			String xitem = StringHelper.null2String(map.get("item"));//Item
			if(xitem.length()==2)
			{
				xitem = "0000" + xitem;
			}
			else if(xitem.length()==3)
			{
				xitem = "000" + xitem;
			}
			else if(xitem.length()==4)
			{
				xitem = "00" + xitem;
			}
			else if(xitem.length()==5)
			{
				xitem = "0" + xitem;
			}
			else{}
			String xprocategory = StringHelper.null2String(map.get("procategory"));//Product Category
			String xsoldparty = StringHelper.null2String(map.get("soldparty"));//Sold To Party
			String xsoldname = StringHelper.null2String(map.get("soldname"));//Sold To Party Name
			String xsoldcountry = StringHelper.null2String(map.get("soldcountry"));//Sold To Country
			String xshipparty = StringHelper.null2String(map.get("shipparty"));//Ship To Party
			String xshipname = StringHelper.null2String(map.get("shipname"));//Ship To Party Name
			String xshipcountry = StringHelper.null2String(map.get("shipcountry"));//Ship To Country

			String xgrade = StringHelper.null2String(map.get("grade"));//Grade
			String xqtypac = StringHelper.null2String(map.get("qtypac"));//Qty(Package)
			String xpackaging = StringHelper.null2String(map.get("packaging"));//Packaging
			String xqtykg = StringHelper.null2String(map.get("qtykg"));//Qty(KG)
			String xunit = StringHelper.null2String(map.get("unit"));//Unit
			String xcurrency = StringHelper.null2String(map.get("currency"));//Currency
			String xprice = StringHelper.null2String(map.get("price"));//Price
			String xper = StringHelper.null2String(map.get("per"));//Per

			String xshipterm1 = StringHelper.null2String(map.get("shipterm1"));//Shipping Term1
			String xshipterm2 = StringHelper.null2String(map.get("shipterm2"));//Shipping Term2
			String xstatus = StringHelper.null2String(map.get("status"));//Status
			String xjhstatus = StringHelper.null2String(map.get("jhstatus"));//jhStatus
			String xclosdate = StringHelper.null2String(map.get("closdate"));//Closing Date
			String xetd = StringHelper.null2String(map.get("etd"));//ETD
			String xeta = StringHelper.null2String(map.get("eta"));//ETA
			String xqyg = StringHelper.null2String(map.get("qyg"));//Departure Port
			String xmdg = StringHelper.null2String(map.get("mdg"));//Arrived Port
			String xshipcode = StringHelper.null2String(map.get("shipcode"));//Ship To Country Code
			String xfhno = StringHelper.null2String(map.get("telno"));//Order Advice Flowno
			String xshipno = StringHelper.null2String(map.get("shipno"));//Booking Number
			String xcuswltxt = StringHelper.null2String(map.get("materdes"));//Customer Material Name
			String xspecnorm = StringHelper.null2String(map.get("specnorm"));//Special Specifications

			String xrecedate = StringHelper.null2String(map.get("recedate"));//PO Received Date
			String xcuspono = StringHelper.null2String(map.get("cuspono"));//Customer PO NO
			String xpayway = StringHelper.null2String(map.get("payway"));//Payment Method(付款方式文本)
			if(xpayway.indexOf("'")!=-1)//若付款方式文本中存在英文单引号
			{
				xpayway = xpayway.replace("'","’");//将英文单引号转换成中文单引号
			}
			
			String xpayterm = StringHelper.null2String(map.get("payterm"));//Payment Term(付款条款文本)
			if(xpayterm.indexOf("'")!=-1)//若付款条款文本中存在英文单引号
			{
				xpayterm = xpayterm.replace("'","’");//将英文单引号转换成中文单引号
			}

			String xactgldate = StringHelper.null2String(map.get("actgldate"));//Actual Gl Date
			String xinvono = StringHelper.null2String(map.get("invono"));//Invoice NO(90)
			String xinvodate = StringHelper.null2String(map.get("invodate"));//Invoice Date
			String xdono = StringHelper.null2String(map.get("dono"));//Delivery NO(80)
			String xdodate = StringHelper.null2String(map.get("dodate"));//DO Create Date
			String xbldate = StringHelper.null2String(map.get("bldate"));//B/L Date
			String xblnumber = StringHelper.null2String(map.get("blnumber"));

			String xmatercode = StringHelper.null2String(map.get("matercode"));//Material Code
			String xlotnumber = StringHelper.null2String(map.get("lotnumber"));//Batch(Lot Number)
			String xpostqty = StringHelper.null2String(map.get("postqty"));//Posted Qty
			String xsaleunit = StringHelper.null2String(map.get("saleunit"));//Sales Unit
			String xbaseqty = StringHelper.null2String(map.get("baseqty"));//Base Qty
			String xbaseunit = StringHelper.null2String(map.get("baseunit"));//Base Unit

			String xcommvalue = StringHelper.null2String(map.get("commvalue"));//Commission(Percentage/Unit Price)
			String xrebate = StringHelper.null2String(map.get("rebate"));//Rebate
			String xforwarder = StringHelper.null2String(map.get("forwarder"));//Forwarder(海运代理商名称)
			String xshipline = StringHelper.null2String(map.get("shipline"));//Shipping Line
			String xmovessel = StringHelper.null2String(map.get("movessel"));//Mother Vessel
			String xfevessel = StringHelper.null2String(map.get("fevessel"));//Feeder Vessel

			String xlcdate = StringHelper.null2String(map.get("lcdate"));//LC received date
			String xlcno = StringHelper.null2String(map.get("lcno"));//LC NO
			String xlcamount = StringHelper.null2String(map.get("lcamount"));//LC Amount
			String xadpaydate = StringHelper.null2String(map.get("adpaydate"));//Advance Payment Date
			String xpaystatus = StringHelper.null2String(map.get("paystatus"));//Payment Status
			String xpaydate = StringHelper.null2String(map.get("paydate"));//Paid Date

			String xbackstatus = "X";

			String insql="insert into uf_dmsd_saledetails(id,requestid,saleorder,ordertype,item,soldparty,soldname,soldcountry,shipparty,shipname,shipcountry,grade,qtypac,packaging,qtykg,unit,currency,price,per,shipterm1,shipterm2,status,jhstatus,closdate,etd,eta,qyg,recedate,cuspono,payway,payterm,actgldate,invono,invodate,dono,dodate,bldate,blnumber,matercode,lotnumber,postqty,saleunit,baseqty,baseunit,commform,rebate,forwarder,shipline,movessel,fevessel,lcdate,lcno,lcamount,adpaydate,paystatus,paydate,procategory,backstatus,mdg,shipcode,telno,shipno,specnorm,materdes)values((select sys_guid() from dual),'"+IDGernerator.getUnquieID()+"','"+xsaleorder+"','"+xordertype+"','"+xitem+"','"+xsoldparty+"','"+xsoldname+"','"+xsoldcountry+"','"+xshipparty+"','"+xshipname+"','"+xshipcountry+"','"+xgrade+"','"+xqtypac+"','"+xpackaging+"','"+xqtykg+"','"+xunit+"','"+xcurrency+"','"+xprice+"','"+xper+"','"+xshipterm1+"','"+xshipterm2+"','"+xstatus+"','"+xjhstatus+"','"+xclosdate+"','"+xetd+"','"+xeta+"','"+xqyg+"','"+xrecedate+"','"+xcuspono+"','"+xpayway+"','"+xpayterm+"','"+xactgldate+"','"+xinvono+"','"+xinvodate+"','"+xdono+"','"+xdodate+"','"+xbldate+"','"+xblnumber+"','"+xmatercode+"','"+xlotnumber+"','"+xpostqty+"','"+xsaleunit+"','"+xbaseqty+"','"+xbaseunit+"','"+xcommvalue+"','"+xrebate+"','"+xforwarder+"','"+xshipline+"','"+xmovessel+"','"+xfevessel+"','"+xlcdate+"','"+xlcno+"','"+xlcamount+"','"+xadpaydate+"','"+xpaystatus+"','"+xpaydate+"','"+xprocategory+"','"+xbackstatus+"','"+xmdg+"','"+xshipcode+"','"+xfhno+"','"+xshipno+"','"+xspecnorm+"','"+xcuswltxt+"')";
			baseJdbc.update(insql);
		}
	}







    //SAP......................................................................................................................
    //创建SAP对象(get data from SAP)		
	SapConnector sapConnector = new SapConnector();
	String functionName = "ZOA_SD_SO_DISPLAY";
	JCoFunction function = null;
	try {
		function = SapConnector.getRfcFunction(functionName);
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	//插入字段至SAP(作为查询条件)
	function.getImportParameterList().setValue("VBELN",saleno);//销售单号
	function.getImportParameterList().setValue("SPART",cptype);//产品大类
	function.getImportParameterList().setValue("KUNNR",soldcode);//售达方简码
	function.getImportParameterList().setValue("KUNNR1",shipcode);//送达方简码
	function.getImportParameterList().setValue("AUART",packtype);//订单类型
	function.getImportParameterList().setValue("MATNR",materno);//物料号
	function.getImportParameterList().setValue("ZLSCH",fspay);//付款方式
	function.getImportParameterList().setValue("ZTERM",tkpay);//付款条款
	function.getImportParameterList().setValue("ZCLDATE1",tclosdate1);//预计结关日(起)
	function.getImportParameterList().setValue("ZCLDATE2",tclosdate2);//预计结关日(止)



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




	//获取SAP子表返回值(销售订单明细)
	JCoTable newretTable = function.getTableParameterList().getTable("ZSD_DISPLAY");
	//System.out.println("lenxxx:"+newretTable.getNumRows());
	if(newretTable.getNumRows() >0)
	{
		System.out.println("len:"+newretTable.getNumRows());
		for(int i= 0;i<newretTable.getNumRows();i++)
		{
			if(i == 0)
			{
				newretTable.firstRow();//获取返回表格数据中的第一行
			}
			else
			{
				newretTable.nextRow();//获取下一行数据
			}

			String saleorder = newretTable.getString("VBELN");//Sales Order
			String ordertype = newretTable.getString("AUART");//Order Type
			String item = newretTable.getString("POSNR");//Item
			String soldparty = newretTable.getString("KUNNR");//Sold To Party
			String soldname = newretTable.getString("NAME");//Sold To Party Name
			String soldcountry = newretTable.getString("LANDNAME");//Sold To Country
			String shipparty = newretTable.getString("KUNNR1");//Ship To Party
			String shipname = newretTable.getString("NAME1");//Ship To Party Name

			String shipcountry = newretTable.getString("LANDNAME1");//Ship To Country
			String grade = newretTable.getString("MAKTX");//Grade
			String qtypac = newretTable.getString("KWMENG");//Qty(Package)
			String packaging = newretTable.getString("MSEHL");//Packaging
			String qtykg = newretTable.getString("KLMENG");//Qty(KG)
			String unit = newretTable.getString("MEINS");//Unit
			String currency = newretTable.getString("WAERK");//Currency
			String price = newretTable.getString("NETPR");//Price

			String per = newretTable.getString("KPEIN");//Per
			String shipterm1 = newretTable.getString("INCO1");//Shipping Term1
			String closdate = newretTable.getString("ZCLDATE");//Closing Date
			String etd = newretTable.getString("ZETD");//ETD
			String eta = newretTable.getString("ZETA");//ETA
			String recedate = newretTable.getString("BSTDK");//PO Received Date
			String cuspono = newretTable.getString("BSTKD");//Customer PO NO

			String payway = newretTable.getString("TEXT2");//Payment Method(付款方式文本)
			if(payway.indexOf("'")!=-1)
			{
				payway = payway.replace("'","’");
			}
			
			String payterm = newretTable.getString("TEXT1");//Payment Term(付款条款文本)
			if(payterm.indexOf("'")!=-1)
			{
				payterm = payterm.replace("'","’");
			}
			
			String actgldate = newretTable.getString("DO_WADAT");//Actual Gl Date
			String invodate = newretTable.getString("INV_ERDAT");//Invoice Date
			String dodate = newretTable.getString("DO_DATE");//DO Create Date
			String bldate = newretTable.getString("INV_FKDAT");//B/L Date
			
			String shipterm2 = newretTable.getString("INCO2");//Shipping Term2/AirPort(目的港或者国贸条件2)
			String deliverycode = newretTable.getString("LAND1");//Ship To Country Code(送达方国家代码)
			String specnorm = newretTable.getString("KDKG2");//Special Specifications(特殊规格)
			String commform = newretTable.getString("ZYJ");//Commission(Price/Percentage)(佣金 百分比或者单价)
			String rebate = newretTable.getString("ZHK");//Rebate(回扣)
			String dono = newretTable.getString("DO_NO");//Delivery NO(80)
			String invono = newretTable.getString("INV_NO");//Invoice NO(90)
			

			String matercode = newretTable.getString("MATNR");//Material Code
			String lotnumber = newretTable.getString("DO_CHARG");//Batch(Lot Number)
			String postqty = newretTable.getString("DO_LFIMG");//Posted Qty
			String saleunit = newretTable.getString("DO_VRKME");//Sales Unit
			String baseqty = newretTable.getString("DO_ZLFIMG");//Base Qty
			String baseunit = newretTable.getString("DO_ZMEINS");//Base Unit
			String xyzno = newretTable.getString("LC_BAANR");//LC NO
			String lcamount = newretTable.getString("LC_WRTAK");//LC Amount
			String procategory = newretTable.getString("SPART");//Product Category


			//System.out.println("Successfully!");
			//将从SAP中取到的数据插入OA
			String insql="insert into uf_dmsd_saledetails(id,requestid,saleorder,ordertype,item,soldparty,soldname,soldcountry,shipparty,shipname,shipcountry,grade,qtypac,packaging,qtykg,unit,currency,price,per,shipterm1,shipterm2,closdate,etd,eta,recedate,cuspono,payway,payterm,actgldate,invono,invodate,dono,dodate,bldate,matercode,lotnumber,postqty,saleunit,baseqty,baseunit,lcno,lcamount,procategory,shipcode,specnorm,commform,rebate)values((select sys_guid() from dual),'"+IDGernerator.getUnquieID()+"','"+saleorder+"','"+ordertype+"','"+item+"','"+soldparty+"','"+soldname+"','"+soldcountry+"','"+shipparty+"','"+shipname+"','"+shipcountry+"','"+grade+"','"+qtypac+"','"+packaging+"','"+qtykg+"','"+unit+"','"+currency+"','"+price+"','"+per+"','"+shipterm1+"','"+shipterm2+"','"+closdate+"','"+etd+"','"+eta+"','"+recedate+"','"+cuspono+"','"+payway+"','"+payterm+"','"+actgldate+"','"+invono+"','"+invodate+"','"+dono+"','"+dodate+"','"+bldate+"','"+matercode+"','"+lotnumber+"','"+postqty+"','"+saleunit+"','"+baseqty+"','"+baseunit+"','"+xyzno+"','"+lcamount+"','"+procategory+"','"+deliverycode+"','"+specnorm+"','"+commform+"','"+rebate+"')";
			baseJdbc.update(insql);
		}
	}





	
	System.out.println("---------------2");
	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                