package com.eweaver.sysinterface.extclass; 
 
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;

public class Ewv20141128102710 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
     String sql = "select a.result,a.reqman,a.objname hid,a.jobno,a.outdept,a.outcome,a.onedept,a.twodept,a.comtype,a.movereason,b.objname hname,b.mainstation,b.extrefobjfield4,b.extdatefield0,b.seclevel,b.exttextfield15 sapno,c.objname oname from uf_hr_comanymove a left join humres b on a.objname=b.id left join orgunit c on a.outdept=c.id where a.requestid='"+requestid+"'";
     List list = baseJdbc.executeSqlForList(sql);
     if(list.size()>0){
    	 Map map = (Map)list.get(0);
    	 String result = StringHelper.null2String(map.get("result"));
    	 if(result.equals("40285a8f489c17ce0148fdd2c91a2f36")){//异动结果为可调动
    		 String reqman = StringHelper.null2String(map.get("reqman"));
        	 String hid = StringHelper.null2String(map.get("hid"));
        	 String hname = StringHelper.null2String(map.get("hname"));
        	 String jobno = StringHelper.null2String(map.get("jobno"));
        	 String outdept = StringHelper.null2String(map.get("outdept"));
        	 String outcome = StringHelper.null2String(map.get("outcome"));
        	 String mainstation = StringHelper.null2String(map.get("mainstation"));
        	 String sszc = StringHelper.null2String(map.get("extrefobjfield4"));
        	 String rzrq = StringHelper.null2String(map.get("extdatefield0"));
        	 String seclevel = StringHelper.null2String(map.get("seclevel"));
        	 String onedept = StringHelper.null2String(map.get("onedept"));
        	 String twodept = StringHelper.null2String(map.get("twodept"));
        	 String comtype = StringHelper.null2String(map.get("comtype"));
			 String oname = StringHelper.null2String(map.get("oname"));
        	 String sapno = StringHelper.null2String(map.get("sapno"));
        	 String movereason = StringHelper.null2String(map.get("movereason"));
        	 String workflowid = "40285a8f490d114a014912abf78e489f";
        	 WorkflowServiceImpl ws = new WorkflowServiceImpl();
        	 RequestInfo ri = new RequestInfo();
        	 ri.setCreator(reqman);
        	 ri.setTypeid(workflowid);
        	 ri.setIssave("1");
        	 Dataset data = new Dataset();
        	 List<Cell> lc = new ArrayList<Cell>();
        	 Cell cell = new Cell();
        	 Date newdate = new Date();
        	 cell.setName("reqman");
        	 cell.setValue(reqman);
        	 lc.add(cell);//申请人
        	 String nowdate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newdate);
        	 cell = new Cell();
        	 cell.setName("reqdate");
        	 cell.setValue(nowdate);
        	 lc.add(cell);//申请日期       	 
        	 cell = new Cell();
        	 cell.setName("jobno");
        	 cell.setValue(jobno);
        	 lc.add(cell);//离职员工工号      	 
        	 cell = new Cell();
        	 cell.setName("objname");
        	 cell.setValue(hid);
        	 lc.add(cell);//离职员工姓名
        	 cell = new Cell();
        	 cell.setName("objdept");
        	 cell.setValue(outdept);
        	 lc.add(cell);//所属部门
        	 cell = new Cell();
        	 cell.setName("objcom");
        	 cell.setValue(outcome);
        	 lc.add(cell);//所属公司
        	 cell = new Cell();
        	 cell.setName("objunit");
        	 cell.setValue(mainstation);
        	 lc.add(cell);//所属岗位
        	 cell = new Cell();
        	 cell.setName("sszc");
        	 cell.setValue(sszc);
        	 lc.add(cell);//所属职称
        	 cell = new Cell();
        	 cell.setName("indate");
        	 cell.setValue(rzrq);
        	 lc.add(cell);//入职日期
        	 cell = new Cell();
        	 cell.setName("leavetype");
        	 cell.setValue("40285a8f490d114a0149127d62584191");
        	 lc.add(cell);//离职类型
        	 cell = new Cell();
        	 cell.setName("leavepattern");
        	 cell.setValue("40285a8f490d114a0149127eea5b419f");
        	 lc.add(cell);//离职形态
        	 cell = new Cell();
        	 cell.setName("leavereason");
        	 cell.setValue("40285a8f490d114a01491280a8aa41b8");
        	 lc.add(cell);//离职原因
        	 cell = new Cell();
        	 cell.setName("moveid");
        	 cell.setValue(requestid);
        	 lc.add(cell);//公司异动reqid
        	 cell = new Cell();
        	 cell.setName("seclevel");
        	 cell.setValue(seclevel);
        	 lc.add(cell);//安全级别
        	 cell = new Cell();
        	 cell.setName("onedept");
        	 cell.setValue(onedept);
        	 lc.add(cell);//一级部门
        	 cell = new Cell();
        	 cell.setName("twodept");
        	 cell.setValue(twodept);
        	 lc.add(cell);//二级部门
        	 cell = new Cell();
        	 cell.setName("comtype");
        	 cell.setValue(comtype);
        	 lc.add(cell);//厂区别
        	 cell = new Cell();
        	 cell.setName("sapno");
        	 cell.setValue(sapno);
        	 lc.add(cell);//离职员工sap编号
        	 cell = new Cell();
        	 cell.setName("title");
        	 cell.setValue("异动离职-"+hname+"-"+oname);
        	 lc.add(cell);//标题
			 cell = new Cell();
        	 cell.setName("reason");
        	 cell.setValue(movereason);
        	 lc.add(cell);//事由
        	 data.setMaintable(lc);
        	 ri.setData(data);
        	 ws.createRequest(ri);
    	 }
     }
 } 

}







