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
	String sblday = StringHelper.null2String(request.getParameter("sblday"));//提单日期(起)
	String eblday = StringHelper.null2String(request.getParameter("eblday"));//提单日期(止)
	String hyfee = "";
	String hyfeeloc = "";
	String asql = "select a.requestid,a.itcterm1 from uf_dmsd_expboxmain a left join requestbase req on a.requestid=req.id where req.isdelete=0 and a.isvalid='40288098276fc2120127704884290210'";
	if(!sblday.equals("")&&!eblday.equals(""))
	{
		asql = asql + " and a.laddate>='"+sblday+"' and a.laddate<='"+eblday+"'";
	}
	else if(!sblday.equals("")&&eblday.equals(""))
	{
		asql = asql + " and a.laddate>='"+sblday+"'";
	}
	else if(sblday.equals("")&&!eblday.equals(""))
	{
		asql = asql + " and a.laddate<='"+eblday+"'";
	}
	//System.out.println(asql);
	List alist = baseJdbc.executeSqlForList(asql);
	if(alist.size()>0)
	{
		//System.out.println("alist.size:"+alist.size());
		for(int i=0;i<alist.size();i++)
		{
			Map amap = (Map)alist.get(i);
			String resid = StringHelper.null2String(amap.get("requestid"));//外销单resid
			String itc1 = StringHelper.null2String(amap.get("itcterm1"));//国贸条件1
			
			String bsql = "select nvl(sum(a.jine),0)hyfee,nvl(sum(a.bwb),0)hyfeeloc from uf_dmsd_feedivvy a where a.requestid=(select requestid from uf_dmsd_exfeezg where cknos='"+resid+"' and spgroup='40285a8c5e08c702015e3084068b6096' and isvalid='40288098276fc2120127704884290210') and a.feename in (select requestid from uf_dmdb_feename where (feename= 'Ocean Freight Fees' or feename='Manifest Surcharge' or feename='OWSC 18MT' or feename='OWSC 21MT' or feename='Flexibag Charge') and imextype='40285a8d56d542730156e95e821c3061')";
			
			//System.out.println(bsql);
			
			List blist = baseJdbc.executeSqlForList(bsql);
			if(blist.size()>0)
			{
				Map bmap = (Map)blist.get(0);
				hyfee = StringHelper.null2String(bmap.get("hyfee"));//海运费--当前币别
				hyfeeloc = StringHelper.null2String(bmap.get("hyfeeloc"));//海运费--本位币
			}
			
			String csql = "select a.saleorder,a.orderitem from uf_dmsd_shipment a where a.requestid='"+resid+"'";
			List clist = baseJdbc.executeSqlForList(csql);
			if(clist.size()>0)
			{
				for(int j=0;j<clist.size();j++)
				{
					Map cmap = (Map)clist.get(j);
					String ordno = StringHelper.null2String(cmap.get("saleorder"));//Order Number
					String item = StringHelper.null2String(cmap.get("orderitem"));//Order Item
					String ordtxt = ordno;//作为更新至数据库的条件
					String itemtxt = item;//作为更新至数据库的条件
					if(!ordno.equals("")&&ordno.indexOf(",")==-1)
					{
						//创建SAP对象
						SapConnector sapConnector = new SapConnector();
						String functionName = "ZOA_SD_MY_GST";
						JCoFunction function = null;
						try {
							function = SapConnector.getRfcFunction(functionName);
						} catch (Exception e) {
							e.printStackTrace();
						}

						item = item.replaceFirst("^0*", "");//去掉开头的0
						//输入字段
						function.getImportParameterList().setValue("VBELN",ordno);//销售订单号
						function.getImportParameterList().setValue("POSNR",item);//订单项次
						

						try {
							function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
						} 
						catch (JCoException e) {
							e.printStackTrace();
						} 
						catch (Exception e) {
							e.printStackTrace();
						}
						
						//获取SAP返回值
						String fpno = function.getExportParameterList().getValue("VBELN1").toString();//发票号码
						String fpamt = function.getExportParameterList().getValue("NETWR").toString();//发票金额
						String taxamt = function.getExportParameterList().getValue("MWSBP").toString();//税额
						String curr = function.getExportParameterList().getValue("WAERK").toString();//币种
						String taxrate = function.getExportParameterList().getValue("KBETR").toString();//税率
						String taxcode = function.getExportParameterList().getValue("MWSK1").toString();//税码
						String hl = function.getExportParameterList().getValue("KURRF").toString();//汇率
						String ordamt = function.getExportParameterList().getValue("NETWR1").toString();//订单金额
						
						double cifvae1 = 0.00;//Custom CIF + Duty Amt(Foreign)
						double cifvae2 = 0.00;//Custom CIF + Duty Amt(RM) 
						double taxvae1 = 0.00;//Custom GST Tax(Foreign)
						double taxvae2 = 0.00;//Custom GST Tax(RM) 
						double fpvae1 = 0.00;//Invoice Amount(Foreign Currency) 
						double fpvae2 = 0.00;//Invoice Amount (RM)


						if(itc1.equals("FOB"))
						{
							cifvae1 = Double.valueOf(hyfee) + Double.valueOf(ordamt);
							cifvae2 = Double.valueOf(hyfeeloc) + Double.valueOf(ordamt)*Double.valueOf(hl);
						}
						else
						{
							cifvae1 = Double.valueOf(ordamt);
							cifvae2 = Double.valueOf(ordamt)*Double.valueOf(hl);
						}
						
						taxvae1 = Double.valueOf(taxamt)*(1.00 + Double.valueOf(taxrate)/100);
						taxvae2 = Double.valueOf(taxamt)*(1.00 + Double.valueOf(taxrate)/100)*Double.valueOf(hl);
						
						fpvae1 = Double.valueOf(fpamt);
						fpvae2 = Double.valueOf(fpamt)*Double.valueOf(hl);
						
						//Double转成String并保留两位小数
						String cifstr1 = String.format("%.2f",cifvae1);//Custom CIF + Duty Amt(Foreign)
						String cifstr2 = String.format("%.2f",cifvae2);//Custom CIF + Duty Amt(RM)
						String taxstr1 = String.format("%.2f",taxvae1);//Custom GST Tax(Foreign)
						String taxstr2 = String.format("%.2f",taxvae2);//Custom GST Tax(RM) 
						String fpstr1 = String.format("%.2f",fpvae1);//Invoice Amount(Foreign Currency) 
						String fpstr2 = String.format("%.2f",fpvae2);//Invoice Amount (RM)

						
						
						System.out.println("发票号码:"+fpno);
						System.out.println("税码:"+taxcode);
						System.out.println("Custom CIF + Duty Amt(Foreign):"+cifstr1);
						System.out.println("Custom CIF + Duty Amt(RM):"+cifstr2);
						System.out.println("Custom GST Tax(Foreign):"+taxstr1);
						System.out.println("Custom GST Tax(RM):"+taxstr2);
						System.out.println("Invoice Amount(Foreign Currency):"+fpstr1);
						System.out.println("Invoice Amount (RM):"+fpstr2);

						//更新至
						String upsql = "update uf_dmsd_shipment set billno='"+fpno+"',cifstr1='"+cifstr1+"',cifstr2='"+cifstr2+"',taxstr1='"+taxstr1+"',taxstr2='"+taxstr2+"',taxcode='"+taxcode+"',fpstr1='"+fpstr1+"',fpstr2='"+fpstr2+"' where requestid='"+resid+"' and saleorder='"+ordtxt+"' and orderitem='"+itemtxt+"'";
						baseJdbc.update(upsql);
					}
				}
			}
			//System.out.println("i++++++++++++++++++++++++++++++++++:"+i);
		}
	}
	

	JSONObject jo = new JSONObject();		
	jo.put("res", "true");
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();
%>
