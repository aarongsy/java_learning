package com.eweaver.app.autotask;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import java.io.PrintStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.sap.conn.jco.JCoTable;
import com.eweaver.base.*;



public class CreateWDB
{
    public void doAction()
    {
		System.out.println("哈哈哈哈.....................................1");
		BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");	
		baseJdbc.update("delete uf_oa_returndestruct where requestid is null");
		
		//计算系统当前日期
		Date dt = new Date();
		SimpleDateFormat matter1 = new SimpleDateFormat("yyyy-MM-dd");
		String curdate = matter1.format(dt);
		//计算系统当前日期的前一天
		Calendar c = Calendar.getInstance();   
		c.add(Calendar.DAY_OF_MONTH,-1);  
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
		String mDateTime = formatter.format(c.getTime());  
		String tyear = mDateTime.substring(0,4);
		String tmonth = mDateTime.substring(5,7);
		String tday = mDateTime.substring(8,10);
		String thedate = tyear + tmonth + tday;//SAP接口中日期参数的格式
		System.out.println("thedate"+thedate);
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZGET_SECRET_PO";
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
		//function.getImportParameterList().setValue("P_DATE",thedate);//运行日期
		function.getImportParameterList().setValue("P_DATE","20170823");//运行日期
		
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
		System.out.println("哈哈哈哈.....................................2");
		JCoTable newretTable = function.getTableParameterList().getTable("POITEM");
		System.out.println("行数："+newretTable.getNumRows());
		if(newretTable.getNumRows() >0)
		{
			for(int j = 0;j<newretTable.getNumRows();j++)
			{
				String tmpid = IDGernerator.getUnquieID();//自动生成32位
				int tnumber = j + 1;
				if(j == 0)
				{
					newretTable.firstRow();//获取返回表格数据中的第一行
				}
				else
				{
					newretTable.nextRow();//获取下一行数据
				}

				String types = newretTable.getString("BSART");//请购类型
				String itemss = newretTable.getString("EBELP");//项次
				String pono = newretTable.getString("EBELN");//采购订单号
				String ccode = newretTable.getString("BUKRS");//公司代码
				String cname = newretTable.getString("BUKRS_NAME");//公司名称
				String znno = newretTable.getString("ANLN");//专案号
				String poorder = newretTable.getString("BANFN");//采购申请号，请购案号
				String pteam = newretTable.getString("EKGRP");//采购组
				String pname = newretTable.getString("AFNAM");//采购员
				String orddate = newretTable.getString("BEDAT");//订单日期
				String ungetsup = newretTable.getString("UN_USE_LIFNR");//未得标
				String getsup = newretTable.getString("LINFR_NAME");//得标供应商
				String texts = newretTable.getString("TXZ01");//文本

				//数据插入未得标主表
				String upsql1 = "insert into uf_oa_returndestruct(id,requestid,ccode,cname,projectname,packdate,purchaserorder,applyoeder,content,supplyname,nosupplyname,applynum,applytype,purchaser,purchase)values('"+tmpid+"','','"+ccode+"','"+cname+"','"+znno+"','"+orddate+"','"+pono+"','"+poorder+"','"+texts+"','"+getsup+"','"+ungetsup+"','"+poorder+"','"+types+"','"+pname+"','"+pteam+"')";
				System.out.println("upsql1...................................:"+upsql1);
				baseJdbc.update(upsql1);
			}
			String sql1 = "select distinct(purchaserorder) purchaseno,applytype,(select name from uf_oa_purchaser  where num=purchase) as purchase  from uf_oa_returndestruct where requestid is null";
			List tlist1 = baseJdbc.executeSqlForList(sql1);
			if(tlist1.size()>0)
			{
				for(int i=0;i<tlist1.size();i++)
				{
					System.out.println("哈哈哈哈.....................................成功！");
					Map map1 = (Map)tlist1.get(i);
					String txt2 = StringHelper.null2String(map1.get("applytype"));//请购类型
					String qgmanager = "";//初始化请购主管(32位)
					String managername = "";//初始化请购主管(中文)
					String cdept = "";//初始化请购部门(32位)
					String qgdept = "";//初始化请购部门(中文)
					String purchase=StringHelper.null2String(map1.get("purchase"));
					String ysql = "select purmanager,purdept,(select objname from humres where id=a.purmanager)txtname,(select objname from orgunit where id=a.purdept)txtdept from uf_oa_purtypemanager a where a.purtype='"+txt2+"'";
					System.out.println(ysql);
					List ylist = baseJdbc.executeSqlForList(ysql);
					if(ylist.size()>0)
					{
						Map ymap = (Map)ylist.get(0);
						qgmanager = StringHelper.null2String(ymap.get("purmanager"));//请购部门主管(32位)
						managername = StringHelper.null2String(ymap.get("txtname"));//请购部门主管(中文)
						cdept = StringHelper.null2String(ymap.get("purdept"));//请购部门(32位)
						qgdept = StringHelper.null2String(ymap.get("txtdept"));//请购部门(中文)
						String txt5 = StringHelper.null2String(map1.get("purchaseno"));//采购订单号						
					    String flowno = "WDBFX"+tyear+tmonth+txt5;
					    System.out.println("flowno:"+flowno);
						WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
						RequestInfo request = new RequestInfo();
						request.setCreator(purchase);//管理员
						request.setTypeid("40285a8d5b26d75d015bd0ee2fc60905");//未得标流程id
						request.setIssave("1");
						
						Dataset data1 = new Dataset();
						List list1 = new ArrayList();
						Cell cell1 = new Cell();
						
						cell1 = new Cell();
						cell1.setName("title");//标题
						cell1.setValue("未得标厂家数据返还或销毁确认单："+managername+"-"+qgdept+"-"+flowno);
						
						cell1 = new Cell();
						cell1.setName("flowno");//流程单号
						cell1.setValue(flowno);
						list1.add(cell1);
						
						cell1 = new Cell();
						cell1.setName("times");//填单日期
						//cell1.setValue("2017-01-01");
						cell1.setValue(curdate);
						list1.add(cell1);
						
						cell1 = new Cell();
						cell1.setName("applytype");//请购类型
						cell1.setValue(txt2);
						list1.add(cell1);
													
						
						cell1 = new Cell();
						cell1.setName("purchaserorder");//采购订单号
						cell1.setValue(txt5);
						list1.add(cell1);
						
						
						data1.setMaintable(list1);
						request.setData(data1);
						String str1 = workflowServiceImpl.createRequest(request);
						
						//未得标厂家数据主表
						String sql2 = "select requestid from uf_oa_returndestruct  where flowno='"+flowno+"'";
						 System.out.println(sql2);
						List tlist2 = baseJdbc.executeSqlForList(sql2);
						if(tlist2.size()>0)
						{
							Map map2 = (Map)tlist2.get(0);
							String resid = StringHelper.null2String(map2.get("requestid"));//requestid
							baseJdbc.update("delete uf_oa_returndestruct where requestid='"+resid+"' ");
							String upsql2 = "update uf_oa_returndestruct set requestid='"+resid+"' where purchaserorder='"+txt5+"' and requestid is null";
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