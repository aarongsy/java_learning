<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %> 
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %> 
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="com.eweaver.app.configsap.SapSync"%> 
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	if(action.equals("getData"))
	{
		EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
		BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		String requestid = StringHelper.null2String(request.getParameter("requestid"));//表单的requestid
		String delsql = "delete uf_oa_reconformdetail where requestid = '"+requestid+"'";
		baseJdbc.update(delsql);
		String companycode = StringHelper.null2String(request.getParameter("companycode"));//公司代码
		String supplycode = StringHelper.null2String(request.getParameter("supplycode"));//快递公司简码
		String startdate = StringHelper.null2String(request.getParameter("startdate"));//收发件日期(起)
		String enddate = StringHelper.null2String(request.getParameter("enddate"));//收发件日期(止)
		
		String sql = "select a.requestid as kdrequestid,a.netweight as netweight,a.sendcomname as sendcomname,a.consigdate as consigdate,a.costowncenter as costowncenter,";
		sql = sql +"a.delivno as delivno,a.costownpan as costownpan,a.costowndept as costowndept,";
		sql = sql +"a.speed as speed,a.delivtype as delivtype,a.goodclass as goodclass,a.area as area,";
		sql = sql +"a.predictgorss as predictgorss,a.grossprice as grossprice,a.abnormcost as abnormcost,a.allmon as allmon,a.tax as tax,";
		sql = sql +"a.notaxamount as notaxamount,a.generledger as generledger,a.abnormreason as abnormreason,b.orderrow as orderrow,";

		sql = sql +"b.orderno as orderno,b.netpriceall as netpriceall,b.amort as amort,b.weight as weight,b.no as no from uf_oa_deliveryapp a left join uf_oa_delivsaleorder b ";  

		sql = sql +"on a.requestid = b.requestid where 1=(select isfinished from requestbase where id =a.requestid) "; 
		sql = sql +" and (a.isvalid ='40288098276fc2120127704884290210' or a.isvalid is null) ";
		sql = sql +" and a.sendcomname ='"+supplycode+"'";
		sql = sql +" and a.costcomcode ='"+companycode+"'"; 
		//sql = sql +" and a.ifdz is null";
		//sql = sql +"and a.requestid not in(select c.reqno from uf_oa_reconformdetail c where 1<>(select isdelete from requestbase where id = c.requestid)) order by b.no asc";
		if(startdate != "")  
		{  
			//sql = sql + " and (a.consigdate >='"+startdate+"' or a.reqdate >='"+startdate+"') ";  
			sql = sql + " and (a.consigdate >='"+startdate+"' ) ";  
		}  
		if(enddate != "")  
		{  
			//sql = sql +" and (a.consigdate <='"+enddate+"' or a.reqdate <='"+enddate+"')"; 
			sql = sql +" and (a.consigdate <='"+enddate+"')";  			
		}  
		sql = sql +"and a.requestid not in(select c.reqno from uf_oa_reconformdetail c where 1<>(select isdelete from requestbase where id = c.requestid) and c.requestid in(select d.requestid from uf_oa_reconform d where 1<>(select isdelete from requestbase where id = d.requestid ) and (d.isvalid = '40288098276fc2120127704884290210' or d.isvalid is null ))) order by b.no asc";
		System.out.println("快递查询——————————————————————————————————————————————-------");
		System.out.println(sql);

		List list = baseJdbc.executeSqlForList(sql);

		Float allfees = 0.00f;
		Float notaxfees = 0.00f;
		Float allmon= 0.00f;
		Float notaxamount=0.00f;
		Float amort = 0.00000f;
		Float grossprice = 0.00f;
		//DecimalFormat df = new DecimalFormat(".00");
		if(list.size()>0){
		for(int s=0;s<list.size();s++){
			Map map = (Map)list.get(s);
			String kdrequestid = StringHelper.null2String(map.get("kdrequestid"));//快递申请单的requestid
			
			String sendcomname = StringHelper.null2String(map.get("sendcomname"));//快递公司
			String consigdate = StringHelper.null2String(map.get("consigdate"));//收发件日期
			String costowncenter = StringHelper.null2String(map.get("costowncenter"));//成本中心
			String delivno = StringHelper.null2String(map.get("delivno"));//快递单号
			String costownpan = StringHelper.null2String(map.get("costownpan"));//费用归属人		
			String costowndept = StringHelper.null2String(map.get("costowndept"));//费用归属部门
			
			String speed = StringHelper.null2String(map.get("speed"));//速度
			String delivtype = StringHelper.null2String(map.get("delivtype"));//快递业务类型
			String goodclass = StringHelper.null2String(map.get("goodclass"));//快递物品类别
			String area = StringHelper.null2String(map.get("area"));//区域
			String netweight = StringHelper.null2String(map.get("netweight"));//净重
			String predictgorss = StringHelper.null2String(map.get("predictgorss"));//实际毛重
			String weight = StringHelper.null2String(map.get("weight"));//销售订单明细中的重量
			
			if(StringHelper.null2String(map.get("grossprice")).equals(""))//如果毛重费用的值为空
			{
				grossprice = 0.00f;
			}
			else
			{
				grossprice = Float.parseFloat(StringHelper.null2String(map.get("grossprice")));//毛重费用
			}
			
			//System.out.println("actgross"+actgross);abnormreason
			String abnormcost = StringHelper.null2String(map.get("abnormcost"));//异常费用
			String abnormreason = StringHelper.null2String(map.get("abnormreason"));//异常说明
			if(StringHelper.null2String(map.get("allmon")).equals(""))
			{
				allmon = 0.00f;
			}
			else
			{
				 allmon = Float.parseFloat(StringHelper.null2String(map.get("allmon")));//费用小计
			}
			
			//System.out.println("allmon"+allmon);
			String tax = StringHelper.null2String(map.get("tax"));//税码
			if(StringHelper.null2String(map.get("notaxamount")).equals(""))
			{
				notaxamount = 0.00f;
			}
			else
			{
				notaxamount = Float.parseFloat(StringHelper.null2String(map.get("notaxamount")));//未税金额
			}

			String generledger = StringHelper.null2String(map.get("generledger"));//总账科目
			
			if(delivtype.equals("40285a9049a3a72a0149a71f7f8d0de4"))//如果是出货
			{
				generledger = "55060600";
			}
			else{//其他业务类型
			
				generledger = "55060700";
			}
			
			String orderno = StringHelper.null2String(map.get("orderno"));//采购订单号
			String orderrow = StringHelper.null2String(map.get("orderrow"));//采购订单项次
			if(StringHelper.null2String(map.get("amort")).equals(""))
			{
				amort = 0.00f;
			}
			else
			{
				amort = Float.parseFloat(StringHelper.null2String(map.get("amort")));//销售订单分摊比例
			}
			
			
			String no = StringHelper.null2String(map.get("no"));//序号
			
			if(amort >0)
			{
				predictgorss = weight;//毛重的值为销售订单中对应的重量
				if(!no.equals(""))
				{
					String sql1 = "select max(no) as maxno from uf_oa_delivsaleorder where requestid = '"+kdrequestid+"'";//查询到最大的序号的值
					//System.out.println(sql1);
					List list1 = baseJdbc.executeSqlForList(sql1);
					if(list1.size()>0)
					{
						Map map1 = (Map)list1.get(0);
						String maxno = StringHelper.null2String(map1.get("maxno"));//序号的最大值
						if(no.equals(maxno))//如果是最大的序号，也就是最后一行数据
						{
							//System.out.println("no:"+no);
							String sumsql = "select sum(sumfee) as sumfee,sum(notaxfee) as notaxfee,sum(grossweight) as grossweight from uf_oa_reconformdetail where reqno='"+kdrequestid+"' and requestid = '"+requestid+"' ";
							//System.out.println(sumsql);
							List sumlist = baseJdbc.executeSqlForList(sumsql);
							if(sumlist.size()>0)
							{
								
								Map summap = (Map)sumlist.get(0);
								Float sumfee = 0.00f;
								Float sumnotaxfee = 0.00f;
								Float grossweight = 0.00f;
								//System.out.println("Str:"+StringHelper.null2String(summap.get("sumfee")));
								if(StringHelper.null2String(summap.get("sumfee")).equals(""))
								{
									//System.out.println("null");
									allmon = allmon * amort;
									notaxamount = notaxamount * amort;
								}
								else
								{

									sumfee = Float.parseFloat(StringHelper.null2String(summap.get("sumfee")));//费用合计
									sumnotaxfee = Float.parseFloat(StringHelper.null2String(summap.get("notaxfee")));//未税费用合计
									grossweight = Float.parseFloat(StringHelper.null2String(summap.get("grossweight")));//毛重费用合计

									if(sumfee >0 )
									{
										grossprice = grossprice-grossweight;
										allmon = allmon -sumfee;
										//System.out.println("after minus:"+allmon);
										notaxamount = notaxamount-sumnotaxfee;
									}
								}
							}
						}
						else
						{
							if(amort > 0)
							{
								grossprice = grossprice * amort;
								allmon = allmon * amort;
								//System.out.println("after appendix:"+allmon);
								notaxamount = notaxamount * amort;
							}
						}
					}
				}

			}
			
			/*if(amort <= 0)
			{
			}
			else
			{
				allmon = allmon * amort;
				notaxamount = notaxamount * amort;
			}*/

			allfees = allfees + allmon;//计算累计金额
			notaxfees = notaxfees + notaxamount;//计算累计未税金额
			String upsql = "insert into uf_oa_reconformdetail (delivcompany,style,thedate,costcenter,delivno,";
			upsql = upsql +"belongpsn,belongdept,speed,ywstyle,goodclass,area,actualgross,specialfee,sumfee,";
			upsql = upsql +"tax,notaxfee,genledger,saleorder,saleorderrow,requestid,id,no,reqno,netweight,amort,grossweight,abnormreason)";
			upsql = upsql +"values('"+sendcomname+"','快递发送','"+consigdate+"','"+costowncenter+"','"+delivno+"',";
			upsql = upsql +"'"+costownpan+"','"+costowndept+"','"+speed+"','"+delivtype+"','"+goodclass+"',";
			upsql = upsql +"'"+area+"','"+predictgorss+"','"+abnormcost+"',"+allmon+",'"+tax+"','"+notaxamount+"',";
			upsql = upsql+"'"+generledger+"','"+orderno+"','"+orderrow+"',";
			upsql = upsql +"'"+requestid+"','"+IDGernerator.getUnquieID()+"',(select count(no)+1 from uf_oa_reconformdetail where requestid = '"+requestid+"')";
			upsql = upsql +",'"+kdrequestid+"','"+netweight+"','"+amort+"','"+grossprice+"','"+abnormreason+"')";
			
			//System.out.println(upsql);
			//System.out.println("insert");
			baseJdbc.update(upsql);
		}//end for
		}//end if
		String updatesql = "update uf_oa_reconform set allfees = '"+allfees+"',notaxfees = '"+notaxfees+"' where requestid = '"+requestid+"'";
		baseJdbc.update(updatesql);
		String MSG = "You have successfully searched "+list.size()+" records";
		JSONObject jo = new JSONObject();		
		jo.put("msg", MSG);
		response.setContentType("application/json; charset=utf-8");
		response.getWriter().write(jo.toString());
		response.getWriter().flush();
		response.getWriter().close();
	}//end if
%>
