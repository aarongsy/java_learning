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

public class Ewv20141129131420 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
     String sql = "select a.moveid,a.reqman,e.orgid,e.extrefobjfield5 comtype,a.objname hid,b.objname hname,c.indept,c.income,c.inonedept,c.intwodept,d.objname indeptname,d.col1 from uf_hr_leave a left join humres b on a.objname=b.id left join uf_hr_comanymove c on a.moveid=c.requestid left join orgunit d on c.indept=d.id left join humres e on a.reqman=e.id where a.requestid='"+requestid+"'";
     List list = baseJdbc.executeSqlForList(sql);
     if(list.size()>0){
    	 Map map = (Map)list.get(0);
    	 String moveid = StringHelper.null2String(map.get("moveid"));
    	 if(!moveid.equals("")){//公司异动字段有值
    		 String reqman = StringHelper.null2String(map.get("reqman"));
    		 String orgid = StringHelper.null2String(map.get("orgid"));
    		 String comtype = StringHelper.null2String(map.get("comtype"));
        	 String hid = StringHelper.null2String(map.get("hid"));
        	 String hname = StringHelper.null2String(map.get("hname"));
        	 String indept = StringHelper.null2String(map.get("indept"));
        	 String income = StringHelper.null2String(map.get("income"));       	 
        	 String indeptname = StringHelper.null2String(map.get("indeptname"));
        	 String indeptid = StringHelper.null2String(map.get("col1"));
        	 String inonedept = StringHelper.null2String(map.get("inonedept"));
        	 String intwodept = StringHelper.null2String(map.get("intwodept"));
        	 String workflowid = "40285a8f489c17ce0148a1b2be07197f";
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
        	 cell.setName("reqdept");
        	 cell.setValue(orgid);
        	 lc.add(cell);//制单部门      	 
        	 cell = new Cell();
        	 cell.setName("entrytype");
        	 cell.setValue("40285a8f489c17ce0148a19c762e16b6");
        	 lc.add(cell);//入职类型
        	 cell = new Cell();
        	 cell.setName("moveid");
        	 cell.setValue(moveid);
        	 lc.add(cell);//公司异动reqid
        	 cell = new Cell();
        	 cell.setName("entryname");
        	 cell.setValue(hid);
        	 lc.add(cell);//入职员工
        	 cell = new Cell();
        	 cell.setName("entrydept");
        	 cell.setValue(indept);
        	 lc.add(cell);//入职员工部门
        	 cell = new Cell();
        	 cell.setName("entrycom");
        	 cell.setValue(income);
        	 lc.add(cell);//入职员工公司
        	 cell = new Cell();
        	 cell.setName("reqcom");
        	 cell.setValue(income);
        	 lc.add(cell);//所属公司
        	 cell = new Cell();
        	 cell.setName("comtype");
        	 cell.setValue(comtype);
        	 lc.add(cell);//厂区别
        	 cell = new Cell();
        	 cell.setName("entrydeptid");
        	 cell.setValue(indeptid);
        	 lc.add(cell);//员工部门id
        	 cell = new Cell();
        	 cell.setName("onedept");
        	 cell.setValue(inonedept);
        	 lc.add(cell);//员工一级部门
        	 cell = new Cell();
        	 cell.setName("twodept");
        	 cell.setValue(intwodept);
        	 lc.add(cell);//员工二级部门
        	 cell = new Cell();
        	 cell.setName("title");
        	 cell.setValue("公司间异动入职-"+hname+"-"+indeptname);
        	 lc.add(cell);//标题
        	 data.setMaintable(lc);
        	 ri.setData(data);
        	 ws.createRequest(ri);
    	 }
     }
 } 

}








