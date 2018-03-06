package com.eweaver.app.autotask;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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

public class HrzzRemaind {

	public void doAction()
	  {
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

		String sql = "select * from (select comtype,objname,jobno,wcertype,ncertype,certno,max(startdate) startdate,max(enddate) enddate,(select orgid from humres where id=a.jobno) reqdept,(select extrefobjfield10 from humres where id=a.jobno) reqcomp,max(requestid) requestid from uf_hr_cardinfo a  where 0=(select isdelete from formbase where id=a.requestid) group by  comtype,objname,jobno,wcertype,ncertype,certno) b";
		//sql=sql+"select * from uf_hr_cardinfo a  where 0=(select isdelete from formbase where id=a.requestid)";
		sql=sql+" where  not exists(select c.id from uf_hr_zzremind c where c.zzreqid=b.requestid)";
		sql = sql +" and (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') from dual) >= to_date(to_char(to_date(b.enddate,'yyyy-mm-dd')+60,'yyyy-mm-dd'),'yyyy-mm-dd')";
		
		System.out.println("人事证照到期提醒："+sql);

	    List list = baseJdbc.executeSqlForList(sql);
	    if (list.size() > 0)
	    {
	      for (int i = 0; i < list.size(); i++) {
	        Map map = (Map)list.get(i);
			String comtype = StringHelper.null2String(map.get("comtype"));//厂区别
			String objname = StringHelper.null2String(map.get("objname"));//姓名
			String jobno = StringHelper.null2String(map.get("jobno"));//工号
			String wcertype = StringHelper.null2String(map.get("wcertype"));//证照类型（外籍）
			String ncertype = StringHelper.null2String(map.get("ncertype"));//证照类型（陆籍）
			String certno = StringHelper.null2String(map.get("certno"));//证照号码
			String startdate=StringHelper.null2String(map.get("startdate"));//有效开始日期
			String enddate=StringHelper.null2String(map.get("enddate"));//有效截止日期
			//String lessoncount=StringHelper.null2String(map.get("lessoncount"));//培训金额
			String reqdept=StringHelper.null2String(map.get("reqdept"));//所属部门
			String reqcomp=StringHelper.null2String(map.get("reqcomp"));
			System.out.println("公司"+reqcomp);
			//String flowno = getNo("WREPYYYYMM","40285a8d525ca58a0152a58baf9259f8",5);
			String requestid = StringHelper.null2String(map.get("requestid"));//出差单的requetsid
			WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
			RequestInfo request = new RequestInfo();
			request.setCreator("402881e70be6d209010be75668750014");
			request.setTypeid("40285a8d5307ce6701530baafbb000b3");
			request.setIssave("0");

			Dataset data = new Dataset();
			List list1 = new ArrayList();
			Cell cell1 = new Cell();

			cell1 = new Cell();
			cell1.setName("comtype");//
			cell1.setValue(comtype);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("objname");//
			cell1.setValue(objname);
			list1.add(cell1);
			

			cell1 = new Cell();
			cell1.setName("jobno");
			cell1.setValue(jobno);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("wcertype");
			cell1.setValue(wcertype);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("ncertype");
			cell1.setValue(ncertype);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("certno");
			cell1.setValue(certno);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("sdate");
			cell1.setValue(startdate);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("edate");
			cell1.setValue(enddate);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("reqdept");//所属部门
			cell1.setValue(reqdept);
			list1.add(cell1);
			

			cell1 = new Cell();
			cell1.setName("lessoncount");
			cell1.setValue(reqcomp);
			list1.add(cell1);

			cell1 = new Cell();
			cell1.setName("zzreqid");//
			cell1.setValue(requestid);
			list1.add(cell1);

			data.setMaintable(list1);
			request.setData(data);
			String str1 = workflowServiceImpl.createRequest(request);
			
	      }
	      }
	    System.out.println("人事证照到期提醒结束ss");
	  }
//
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
