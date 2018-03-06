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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class Workremind
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	

	String sql = "select a.requestid,b.objdept,b.objcom,b.objgroup,b.comtype,b.safelevel,b.first,b.second,a.objecttype,a.supplycode,a.khcode,b.psnno from uf_hr_businesstripsub a inner join uf_hr_businesstrip b on a.requestid = b.requestid where b.isvalided = '40288098276fc2120127704884290210' and 1<>(select isdelete from requestbase where id = b.requestid) and 1=(select isfinished from requestbase where id = b.requestid)";
	sql = sql +" and (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) >= to_date(to_char(to_date(edate,'yyyy-mm-dd')+7,'yyyy-mm-dd'),'yyyy-mm-dd')";
	
	System.out.println("出差申请工作报告到期未填写提醒："+sql);

    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0)
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);

        String objecttype = StringHelper.null2String(map.get("objecttype"));//拜访对象性质
		String supplycode = StringHelper.null2String(map.get("supplycode"));//供应商简码
		String khcode = StringHelper.null2String(map.get("khcode"));//客户简码
		String psnno = StringHelper.null2String(map.get("psnno"));//出差员工
		String objgroup = StringHelper.null2String(map.get("objgroup"));//员工组

		String comtype = StringHelper.null2String(map.get("comtype"));//厂区别
		String safelevel = StringHelper.null2String(map.get("safelevel"));//安全级别
		String first = StringHelper.null2String(map.get("first"));//一级部门
		String second = StringHelper.null2String(map.get("second"));//二级部门
		String objdept = StringHelper.null2String(map.get("objdept"));//所属部门
		String objcom = StringHelper.null2String(map.get("objcom"));//所属公司
		String flowno = getNo("WREPYYYYMM","40285a8d525ca58a0152a58baf9259f8",5);
		String requestid = StringHelper.null2String(map.get("requestid"));//出差单的requetsid
		String subsql ="";
		if(objecttype.equals("40285a8d4aff85d1014b00fd85722038"))//如果拜访性质为客户
		{
			subsql = "select custcode as code,ccno from uf_hr_workrep where ccno = '"+requestid+"' and custcode = '"+khcode+"' and flowtype <>'40285a8f489c17ce0148a12871bb0d99' and 1<>(select isdelete from requestbase where id = requestid)"; 
		}
		else if(objecttype.equals("40285a8d4aff85d1014b00fd85712037"))//如果拜访性质为供应商
		{
			subsql = "select supcode as code,ccno from uf_hr_workrep where ccno = '"+requestid+"' and supcode = '"+supplycode+"' and flowtype <>'40285a8f489c17ce0148a12871bb0d99' and 1<>(select isdelete from requestbase where id = requestid)"; 
		}
		if(!subsql.equals("") )//如果查询用的sql语句不为空，则执行
		{
			List listsub = baseJdbc.executeSqlForList(subsql);
			if(listsub.size()>0)
			{
			}
			else
			{
				WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
				RequestInfo request = new RequestInfo();
				request.setCreator(""+psnno+"");
				request.setTypeid("40285a8d525ca58a0152a51905075956");
				request.setIssave("1");

				Dataset data = new Dataset();
				List list1 = new ArrayList();
				Cell cell1 = new Cell();
				cell1.setName("title");
				cell1.setValue("出差申请工作报告填写!");
				list1.add(cell1);
				cell1 = new Cell();
				cell1.setName("supcode");//供应商简码
				cell1.setValue(supplycode);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("flowno");//流程单号
				cell1.setValue(flowno);
				list1.add(cell1);

				

				cell1 = new Cell();
				cell1.setName("custcode");//客户简码
				cell1.setValue(khcode);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("ccno");//出差单号
				cell1.setValue(requestid);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("custparam");//拜访对象性质
				cell1.setValue(objecttype);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("wpsn");//填写人
				cell1.setValue(psnno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("types");//类型
				cell1.setValue("40285a8d525ca58a0152a4f7955557bc");
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("rempsn");//记录者
				cell1.setValue(psnno);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("dept");//所属部门
				cell1.setValue(objdept);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("company");//所属公司
				cell1.setValue(objcom);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("comtype");//厂区别
				cell1.setValue(comtype);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("objgroup");//员工组
				cell1.setValue(objgroup);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("safelev");//安全级别
				cell1.setValue(safelevel);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("onedept");//一级部门
				cell1.setValue(first);
				list1.add(cell1);

				cell1 = new Cell();
				cell1.setName("twodept");//二级部门
				cell1.setValue(second);
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