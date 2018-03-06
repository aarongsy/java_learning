package com.eweaver.app.autotask;
import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class CreateCGJQYC
{
  public void doAction()
  {
    System.out.println("哈哈哈哈.....................................1");
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    baseJdbc.update("delete uf_oa_purchaseinfo where requestid is null");

    Date dt = new Date();
    SimpleDateFormat matter1 = new SimpleDateFormat("yyyy-MM-dd");
    String curdate = matter1.format(dt);
    String tmpdate = curdate.replaceAll("-","");//将日期格式中的"-"去掉

    SapConnector sapConnector = new SapConnector();
    String functionName = "ZOA_GET_MIGO_RECORD";
    JCoFunction function = null;
    try
    {
      function = SapConnector.getRfcFunction(functionName);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }

    //function.getImportParameterList().setValue("P_DATE", "20171017");
    function.getImportParameterList().setValue("P_DATE",tmpdate);
    try {
      function.execute(SapConnector.getDestination("sanpowersap"));
    }
    catch (JCoException e) {
      e.printStackTrace();
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    JCoTable newretTable = function.getTableParameterList().getTable("ZOA_PO_1");
    //System.out.println("行数：" + newretTable.getNumRows());
    if (newretTable.getNumRows() > 0)
    {
		//System.out.println("哈哈哈哈.....................................2");
        for (int j = 0; j < newretTable.getNumRows(); j++)
        {
			String tmpid = IDGernerator.getUnquieID();
			int tnumber = j + 1;
			if (j == 0)
			{
			  //System.out.println("哈哈哈哈.....................................3");
			  newretTable.firstRow();
			}
			else
			{
			  //System.out.println("哈哈哈哈.....................................4");
			  newretTable.nextRow();
			}
			String comcode = newretTable.getString("BUKRS");//公司代码
			String buytype = newretTable.getString("BSART");//请购类型
			String suppcode = newretTable.getString("LIFNR");//供应商简码
			String suppname = newretTable.getString("NAME1") + newretTable.getString("NAME2");//供应商名称
			String orderno = newretTable.getString("EBELN");//采购订单号
			String purname = newretTable.getString("EKNAM");//采购员姓名
			String purgroup = newretTable.getString("EKGRP");//采购组(即采购员SAP编号)
			String groupdes = newretTable.getString("EKNAM");//采购组描述(即采购员姓名)
			String items = newretTable.getString("EBELP");//订单项次
			String text = newretTable.getString("TXZ01");//短文本
			String unit = newretTable.getString("MEINS");//订购单位
			String pursum = newretTable.getString("MENGE");//采购订单数量
			String recesum = newretTable.getString("BPMNG");//验收数量
			String pactdate = newretTable.getString("EINDT");//合同交期(预计交货日)
			String checkdate = newretTable.getString("CPUDT");//验收日期(实际交货日)
			
			String gmtj = "";//国贸条件
			String khdate = "";//实际开航日
			String dgdate = "";//实际到港日
			String stritem = items.replaceFirst("^0*", "");//将'00010'转换为'10'
			
			String asql = "select v.orderid,v.item,v.condition1,v.begindate,v.factportdate from((select a1.orderid,a1.item,b1.condition1,b1.begindate,b1.factportdate from uf_tr_materialdt a1 left join uf_tr_lading b1 on a1.requestid=b1.requestid left join requestbase req1 on b1.requestid=req1.id where b1.isvalid='40288098276fc2120127704884290210' and a1.orderid='"+orderno+"' and a1.item='"+stritem+"' and req1.isdelete=0 and req1.isfinished=1)union all(select a2.orderid,a2.orderitem item,b2.condition1,b2.begindate,b2.factportdate from uf_tr_equipmentdt a2 left join uf_tr_lading b2 on a2.requestid=b2.requestid left join requestbase req2 on b2.requestid=req2.id where b2.isvalid='40288098276fc2120127704884290210' and a2.orderid='"+orderno+"' and a2.orderitem='"+stritem+"' and req2.isdelete=0 and req2.isfinished=1))v order by v.begindate desc,v.factportdate desc";
			System.out.println("asql:"+asql);
			List alist = baseJdbc.executeSqlForList(asql);
			if(alist.size()>0)//外购
			{
				Map amap = (Map)alist.get(0);
				gmtj = StringHelper.null2String(amap.get("condition1"));//国贸条件
				khdate = StringHelper.null2String(amap.get("begindate"));//实际开航日
				dgdate = StringHelper.null2String(amap.get("factportdate"));//实际到港日
				
				System.out.println("pactdate:"+pactdate);
				System.out.println("gmtj:"+gmtj);
				System.out.println("khdate:"+khdate);
				System.out.println("dgdate:"+dgdate);
				if((gmtj.equals("FOB")||gmtj.equals("FCK")||gmtj.equals("EXW"))&&!dgdate.equals(""))
				{
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
					try {
						Date date1 = sdf.parse(khdate);
						Date date2 = sdf.parse(pactdate);
						if(date1.getTime()>date2.getTime())
						{
							//数据插入交期异常确认明细表
							String upsql1 = "insert into uf_oa_purchaseinfo(id,requestid,orderno,items,text,unit,quantity,pactdate,checkdate,comcode,buytype,supcode,supname,purname,purgroup,desgroup,recesum)values('" + tmpid + "','','" + orderno + "','" + items + "','" + text + "','" + unit + "','" + pursum + "','" + pactdate + "','" + checkdate + "','" + comcode + "','" + buytype + "','" + suppcode + "','" + suppname + "','" + purname + "','" + purgroup + "','" + groupdes + "','" + recesum + "')";
							baseJdbc.update(upsql1);
						}
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} 
				}
				else if(!dgdate.equals(""))
				{
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
					try {
						Date date1 = sdf.parse(dgdate);
						Date date2 = sdf.parse(pactdate);
						if(date1.getTime()>date2.getTime())
						{
							//数据插入交期异常确认明细表
							String upsql1 = "insert into uf_oa_purchaseinfo(id,requestid,orderno,items,text,unit,quantity,pactdate,checkdate,comcode,buytype,supcode,supname,purname,purgroup,desgroup,recesum)values('" + tmpid + "','','" + orderno + "','" + items + "','" + text + "','" + unit + "','" + pursum + "','" + pactdate + "','" + checkdate + "','" + comcode + "','" + buytype + "','" + suppcode + "','" + suppname + "','" + purname + "','" + purgroup + "','" + groupdes + "','" + recesum + "')";
							baseJdbc.update(upsql1);
							System.out.print("sss");
						}
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} 
				}
			}
			else//内购
			{
				//数据插入交期异常确认明细表
				String upsql1 = "insert into uf_oa_purchaseinfo(id,requestid,orderno,items,text,unit,quantity,pactdate,checkdate,comcode,buytype,supcode,supname,purname,purgroup,desgroup,recesum)values('" + tmpid + "','','" + orderno + "','" + items + "','" + text + "','" + unit + "','" + pursum + "','" + pactdate + "','" + checkdate + "','" + comcode + "','" + buytype + "','" + suppcode + "','" + suppname + "','" + purname + "','" + purgroup + "','" + groupdes + "','" + recesum + "')";
				baseJdbc.update(upsql1);
			}
        }
		String sql1 = "select distinct(orderno) purchaseno,comcode,buytype,supcode,supname,purname,purgroup,desgroup from uf_oa_purchaseinfo where requestid is null";
		List tlist1 = baseJdbc.executeSqlForList(sql1);
		if (tlist1.size() > 0)
		{
			for (int i = 0; i < tlist1.size(); i++)
			{
				System.out.println("哈哈哈哈.....................................成功！");
				Map map1 = (Map)tlist1.get(i);
				String txt1 = StringHelper.null2String(map1.get("comcode"));//公司代码
				String txt2 = StringHelper.null2String(map1.get("buytype"));//请购类型
				String qgmanager = "";//初始化请购主管(32位)
				String managername = "";//初始化请购主管(中文)
				String cdept = "";//初始化请购部门(32位)
				String qgdept = "";//初始化请购部门(中文)
				String ysql = "select purmanager,purdept,(select objname from humres where id=a.purmanager)txtname,(select objname from orgunit where id=a.purdept)txtdept from uf_oa_purtypemanager a where a.purtype='" + txt2 + "'";
				System.out.println(ysql);
				List ylist = baseJdbc.executeSqlForList(ysql);
				if (ylist.size() > 0)
				{
					Map ymap = (Map)ylist.get(0);
					qgmanager = StringHelper.null2String(ymap.get("purmanager"));//请购部门主管(32位)
					managername = StringHelper.null2String(ymap.get("txtname"));//请购部门主管(中文)
					cdept = StringHelper.null2String(ymap.get("purdept"));//请购部门(32位)
					qgdept = StringHelper.null2String(ymap.get("txtdept"));//请购部门(中文)
					String txt3 = StringHelper.null2String(map1.get("supcode"));//供应商简码
					String txt4 = StringHelper.null2String(map1.get("supname"));//供应商名称
					String txt5 = StringHelper.null2String(map1.get("purchaseno"));//采购订单号
					String txt6 = StringHelper.null2String(map1.get("purname"));//采购员姓名
					String txt7 = StringHelper.null2String(map1.get("purgroup"));//采购组
					String txt8 = StringHelper.null2String(map1.get("desgroup"));//采购组描述

					String flowno = "CGJQYC" + getNo("YYYYMM", "40285a8d5a01d546015a02c26d490ee5", 3);
					//System.out.println("flowno:" + flowno);
					WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
					RequestInfo request = new RequestInfo();
					request.setCreator(qgmanager);//管理员
					request.setTypeid("40285a8d5a01d546015a02e1197f105f");//交期异常确认流程id
					request.setIssave("1");

					Dataset data1 = new Dataset();
					List list1 = new ArrayList();
					Cell cell1 = new Cell();

					cell1 = new Cell();
					cell1.setName("title");//标题
					cell1.setValue("交期异常确认：" + managername + "-" + qgdept + "-" + flowno);

					cell1 = new Cell();
					cell1.setName("processno");//流程单号
					cell1.setValue(flowno);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("filldate");//填单日期

					cell1.setValue(curdate);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("comcode");//公司代码
					cell1.setValue(txt1);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("purtype");//请购类型
					cell1.setValue(txt2);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("purmanager");//请购部门主管
					cell1.setValue(qgmanager);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("checkunit");//请购部门
					cell1.setValue(cdept);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("supplycode");//供应商简码
					cell1.setValue(txt3);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("supplyname");//供应商名称
					cell1.setValue(txt4);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("purchaseno");//采购订单号
					cell1.setValue(txt5);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("purchasing");//采购员姓名
					cell1.setValue(txt6);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("purchaseorg");//采购组
					cell1.setValue(txt7);
					list1.add(cell1);

					cell1 = new Cell();
					cell1.setName("buyer");//采购组描述
					cell1.setValue(txt8);
					list1.add(cell1);

					data1.setMaintable(list1);
					request.setData(data1);
					String str1 = workflowServiceImpl.createRequest(request);

					//交期异常确认主表
					String sql2 = "select requestid from uf_oa_jqycqr where processno='" + flowno + "'";
					//System.out.println(sql2);
					List tlist2 = baseJdbc.executeSqlForList(sql2);
					if (tlist2.size() > 0)
					{
					    Map map2 = (Map)tlist2.get(0);
					    String resid = StringHelper.null2String(map2.get("requestid"));
					    baseJdbc.update("delete uf_oa_purchaseinfo where requestid='" + resid + "' ");
					    String upsql2 = "update uf_oa_purchaseinfo set requestid='" + resid + "' where orderno='" + txt5 + "' and requestid is null";
					    baseJdbc.update(upsql2);
					}
			    }
		    }
        }
    }
 }

  //获取流程单号
  private String getNo(String formula, String id, int len)
  {
    Date newdate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd");
    formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
    formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
    formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
    formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));
    String o = NumberHelper.getSequenceNo(id, len);
    return formula + o;
  }
}
 