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

public class Ewv20141107163255 extends EweaverExecutorBase{

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
       //取得报价明细数据
       String inqsql = "select priceman,costname,operateport,cabinettype,danordtype,moneytype,taxamount,taxrate,other,moneytotal,currencytype,remarks,effect from uf_tr_ffpricedetail where requestid ='"+requestid+"'";
       List listdt = baseJdbc.executeSqlForList(inqsql);
         if(listdt.size()>0){
          int no = 0;
          String rowindex = "";
          for(int i=0;i<listdt.size();i++){
           Map inmap = (Map) listdt.get(0);
           String priceman = StringHelper.null2String(inmap.get("priceman"));
           String costname = StringHelper.null2String(inmap.get("costname"));
     String operateport = StringHelper.null2String(inmap.get("operateport"));
     String cabinettype = StringHelper.null2String(inmap.get("cabinettype"));
     String danordtype = StringHelper.null2String(inmap.get("danordtype"));
     String moneytype = StringHelper.null2String(inmap.get("moneytype"));
     String taxamount = StringHelper.null2String(inmap.get("taxamount"));
     String taxrate = StringHelper.null2String(inmap.get("taxrate"));
     String other = StringHelper.null2String(inmap.get("other"));
     String moneytotal = StringHelper.null2String(inmap.get("moneytotal"));
     String currencytype = StringHelper.null2String(inmap.get("currencytype"));
     String remarks = StringHelper.null2String(inmap.get("remarks"));
     String effect = StringHelper.null2String(inmap.get("effect"));
        no = no + 1;
        rowindex = ""+no;
        if(rowindex.length()<3){
         for(int m=0;m<(3-rowindex.length());m++){
          rowindex = "0"+rowindex;
         }
        }
//    	 String id = IDGernerator.getUnquieID();
        
        String inertsql = "insert into uf_tr_ffpricedetail(id,requestid,rowindex,priceman,costname,operateport,cabinettype,danordtype,moneytype,taxamount,taxrete,other,moneytotal,currencytype,remarks,effect) " +
          "values('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+rowindex+"','"+priceman+"','"+costname+"','"+operateport+"','"+cabinettype+"','"+danordtype+"'," +
            "'"+moneytype+"','"+taxamount+"','"+taxrate+"','"+other+"','"+moneytotal+"','"+currencytype+"','"+remarks+"','"+effect+"')";
        baseJdbc.update(inertsql);
          }
          
         }
 }
}
