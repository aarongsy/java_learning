package com.eweaver.app.autotask;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.sun.org.apache.bcel.internal.generic.NEW;

import java.util.*;

public class CreateCG {
	public void doAction()
	{
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    String sql = "select (select to_char(sysdate,'yyyy-mm-dd') from dual) as nowdate,a.requestid,a.tx1,a.tx3,a.no,a.enddate,a.persoon,a.xqperson,a.zhperson,a.zg,a.company,a.isvalid from uf_ph_ndhtsq a where a.isvalid='40285a8d4fbaabf8014fbf03219615cc' and 1=(select isfinished from requestbase where id=a.requestid) and 0=(select isdelete from requestbase where id=a.requestid)";
	    System.out.println("采购年度合同申请提醒" + sql);

	    List list = baseJdbc.executeSqlForList(sql);
	    if (list.size() > 0)
	    {
	      for (int i = 0; i < list.size(); i++) {
	        Map map = (Map)list.get(i);
	        String requestid = StringHelper.null2String(map.get("requestid"));
			String tx1 = StringHelper.null2String(map.get("tx1"));
			String tx3 = StringHelper.null2String(map.get("tx3"));
	        String no = StringHelper.null2String(map.get("no"));//申请单号
	        String enddate = StringHelper.null2String(map.get("enddate"));//合同截止日期

	        String person = StringHelper.null2String(map.get("persoon"));//申请人
	        String xqperson = StringHelper.null2String(map.get("xqperson"));//需求人
	        String zhperson = StringHelper.null2String(map.get("zhperson"));//知会人
	        String zg = StringHelper.null2String(map.get("zg"));//知会人
	        String company = StringHelper.null2String(map.get("company"));//厂区别

	        String psnno=person+","+xqperson+","+zhperson+","+zg;//提醒人员
	        String context=no+":请于"+enddate+"号前执行并回复";
	        boolean flag=false;

			String cal=StringHelper.null2String(map.get("nowdate"));
	        //Calendar cal = Calendar.getInstance();
	        //String calsString=cal.toString();
			if(cal.equals(tx1))
				flag=true;
			if(cal.equals(tx3))
				flag=true;
			if(cal.equals(enddate))
				flag=true;
			else 
				flag=false;

	        //flag=true 执行提醒流程
	        if(flag==true)
	        {
	        	String flowno=getNo("TXYYYYMMDD", "40285a8d5644a7870156965583b109c4", 3);
	        	WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
				RequestInfo request = new RequestInfo();
				request.setCreator("402881e70be6d209010be75668750014");
				request.setTypeid("40285a8d5644a787015659863330255b");
				request.setIssave("0");

				Dataset data = new Dataset();
				List list1 = new ArrayList();
				Cell cell1 = new Cell();

				cell1 = new Cell();
				cell1.setName("title");
				cell1.setValue("采购年度合同申请提醒-"+no+"!");
				list1.add(cell1);
				
				cell1 = new Cell();
				cell1.setName("flowno");
				cell1.setValue(flowno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("rdate");//提醒日期
				cell1.setValue(new SimpleDateFormat("yyyy-mm-dd").format(new Date()));
				list1.add(cell1);
				

				cell1 = new Cell();
				cell1.setName("area");//厂区别
				cell1.setValue(company);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("model");//提醒模块
				cell1.setValue("采购管理");
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("psnno");//提醒人员
				cell1.setValue(psnno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("context");//提醒内容
				cell1.setValue(context);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("linkflow");//链接流程
				cell1.setValue(requestid);
				list1.add(cell1);
				
				data.setMaintable(list1);
				request.setData(data);
				String str1 = workflowServiceImpl.createRequest(request);
	        }
	      }
	    }
	}
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
