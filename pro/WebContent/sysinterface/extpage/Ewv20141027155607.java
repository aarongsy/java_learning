package com.eweaver.sysinterface.extclass;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.StringHelper;
import com.eweaver.base.*; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import com.eweaver.app.configsap.SapConnector;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
public class Ewv20141027155607 extends EweaverExecutorBase{ 


@Override 
public void doExecute (Param params) {
 
	String requestid = this.requestid;//当前流程requestid 
    EweaverUser currentuser = BaseContext.getRemoteUser();//获取当前用户对象 
    String nodeid = params.getParamValueStr("nodeid");//流程当前节点 
    String issave = params.getParamValueStr("issave");//是否保存 
    String isundo = params.getParamValueStr("isundo");//是否撤回 
    String formid = params.getParamValueStr("formid");//流程关联表单ID 
    String editmode = params.getParamValueStr("editmode");//编辑模式 
    String maintablename = params.getParamValueStr("maintablename");//关联流程的主表 
    String args = params.getParamValueStr("arg");//获取接口中传入的文本参数 
    String field1 = params.getParamValueStr("FIELD1");//获取表单中的字段值,字段名参数要大写 

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String sql = "select a.sapno,a.rleavedate,b.objdesc,a.compen,a.renegemoney from uf_hr_leave a,selectitem b where a.leavepattern=b.id and a.requestid='"+requestid+"'";
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){
		System.out.println("---------取数开始--------------");
		Map map = (Map)list.get(0);
		String sapno = StringHelper.null2String(map.get("sapno"));//SAP员工工号
		String rleavedate = StringHelper.null2String(map.get("rleavedate"));//离职日期
		String objdesc = StringHelper.null2String(map.get("objdesc"));//离职形态
		String compen = StringHelper.null2String(map.get("compen"));//补偿金额
		String renegemoney = StringHelper.null2String(map.get("renegemoney"));//培训违约金金额
		//传给SAP的离职日期为OA的离职日期+1
		SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
		Date d = null;
		try {
			d = ft.parse(rleavedate);
		} catch (ParseException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		Calendar cdr = Calendar.getInstance();
		cdr.setTime(d);
		cdr.add(Calendar.DAY_OF_MONTH,1);
		String theDate = ft.format(cdr.getTime());
		System.out.println("---------theDate--------------"+theDate);
		//创建SAP对象
		SapConnector sapConnector = new SapConnector();
		String functionName = "ZHR_IT0000_Z7_CREATE";
		JCoFunction function = null;
		try {
			function = SapConnector.getRfcFunction(functionName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//插入字段
		function.getImportParameterList().setValue("PERNR",sapno);
		function.getImportParameterList().setValue("BEGDA",theDate);
		function.getImportParameterList().setValue("MASSG",objdesc);
		function.getImportParameterList().setValue("BETRG",compen);

		try {
			function.execute(sapConnector.getDestination(sapConnector.fdPoolName));
			System.out.println("---------更新完成--------------");
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//返回值
		String MESSAGE = function.getExportParameterList().getValue("MESSAGE").toString();
		String MSGTY = function.getExportParameterList().getValue("MSGTY").toString();
		System.out.println("---------MESSAGE--------------"+MESSAGE);
		String upsql="update uf_hr_leave set message='"+MESSAGE+"',msgty='"+MSGTY+"' where requestid='"+requestid+"'";
		baseJdbc.update(upsql);
	}
} 
}

