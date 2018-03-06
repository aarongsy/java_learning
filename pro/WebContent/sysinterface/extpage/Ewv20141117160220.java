package com.eweaver.sysinterface.extclass;

import java.util.List;
import java.util.Map;
import com.eweaver.base.*;
import com.eweaver.base.security.service.acegi.EweaverUser;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.sysinterface.base.Param;
import com.eweaver.sysinterface.javacode.EweaverExecutorBase;
import com.eweaver.base.*;

public class Ewv20141117160220 extends EweaverExecutorBase{

 @Override
 public void doExecute(Param params) {
  // TODO Auto-generated method stub
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
       //取得主表数据
       String inqsql = "select * from uf_tr_shipping where requestid ='"+requestid+"'";
         List list = baseJdbc.executeSqlForList(inqsql);
         if(list.size()>0){
          Map inmap = (Map) list.get(0);
          String category = StringHelper.null2String(inmap.get("category"));//进出口类别
          String transportcode = StringHelper.null2String(inmap.get("transportcode"));//海运代理简码
          String invoicecategory = StringHelper.null2String(inmap.get("invoicecategory"));//发票类型
          String taxtype = StringHelper.null2String(inmap.get("taxtype"));//税别
          String vat = StringHelper.null2String(inmap.get("vat"));//增值税率
         
          String[] sealist = transportcode.split(",");
          for(int i=0;i<sealist.length;i++){
           String priceman = sealist[i].toString();
           //循环明细表，并创建至报价明细报表中
	   		String sqldt = "select id,line,startport,endport,costname,cabinettype,danous,remarks from uf_tr_shipdetails where requestid = '"+requestid+"'";
	   		List listdt =  baseJdbc.executeSqlForList(sqldt);
	   		if(listdt.size()>0){
	   			for(int j=0;j<listdt.size();j++){
	   				Map dtmap = (Map)listdt.get(j);
	   				String line = StringHelper.null2String(dtmap.get("line"));//航线
	   				String startport = StringHelper.null2String(dtmap.get("startport"));//起运港
	   				String endport = StringHelper.null2String(dtmap.get("endport"));//目的港
	   				String costname = StringHelper.null2String(dtmap.get("costname"));//费用名称
	   				String cabinettype = StringHelper.null2String(dtmap.get("cabinettype"));//柜型
	   				String danous = StringHelper.null2String(dtmap.get("danous"));//危普区分
	   				String remarks = StringHelper.null2String(dtmap.get("remarks"));//备注
	   				String id = StringHelper.null2String(dtmap.get("id"));//询价表明细ID放至报价groupid做区分
	   				String updatesql = "insert into uf_tr_details(id,priceman,routes,starting,purpose,costname,arktype,partitions,note,groupid,requestid) " +
	   						"values('"+IDGernerator.getUnquieID()+"','"+priceman+"','"+line+"','"+startport+"','"+endport+"','"+costname+"','"+cabinettype+"','"+danous+"','"+remarks+"','"+id+"','"+requestid+"')";
	   				System.out.println(updatesql);
	   				baseJdbc.update(updatesql);
	   			}
	   		}
          }
         }
 }
}
