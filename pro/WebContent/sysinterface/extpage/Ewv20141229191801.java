package com.eweaver.sysinterface.extclass; 
import java.util.*;
import com.eweaver.base.*; 
import com.eweaver.base.util.*;
import com.eweaver.app.logi.*;
import com.eweaver.base.security.service.acegi.EweaverUser; 
import com.eweaver.sysinterface.base.Param; 
import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import org.json.simple.JSONValue;
import com.eweaver.workflow.request.service.FormService;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.*;import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.transaction.TransactionStatus;
public class Ewv20141229191801 extends EweaverExecutorBase{ 
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
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		DataService ds = new DataService();
		List ls = ds.getValues("select uf_lo_plancancel.*,(select max(uf_lo_loadplan.reqno) from uf_lo_loadplan where uf_lo_loadplan.requestid = uf_lo_plancancel.cancplan) planno  from uf_lo_plancancel where requestid='"+requestid+"'");
		List<String> sqlList =new ArrayList<String>();
		String sql="";
		for(int i=0,sizei=ls.size();i<sizei;i++)
		{
			Map mi = (Map) ls.get(i);
			String loadno=StringHelper.null2String(mi.get("loadno"));
			String estno=StringHelper.null2String(mi.get("estno"));
			String clearno=StringHelper.null2String(mi.get("clearno"));
			String cancplan=StringHelper.null2String(mi.get("cancplan"));
          	LoadPlanService lps = new LoadPlanService();
            lps.loadPlanToCancel(StringHelper.null2String(mi.get("planno")));
          
			if(!StringHelper.isEmpty(loadno)){
				String[] tempnos = loadno.split(","); 
				//提入作废
				for(int j=0,sizej=tempnos.length;j<sizej;j++)
				{
					sql = "update uf_lo_ladingmain set state='402864d14940d265014941e9d82900dc' where ladingno='"+tempnos[j]+"'";
					sqlList.add(sql);
				}
			}
			if(!StringHelper.isEmpty(estno)){
				String[] tempnos = estno.split(","); 
				//暂估单作废
				for(int j=0,sizej=tempnos.length;j<sizej;j++)
				{
					sql = "update uf_lo_budget set invoicestatue='402864d149e039b10149e080b01600c2' where invoiceno='"+tempnos[j]+"'";
					sqlList.add(sql);
				}
			}
			if(!StringHelper.isEmpty(clearno)){
				String[] tempnos = clearno.split(","); 
				//清账单
				for(int j=0,sizej=tempnos.length;j<sizej;j++)
				{
					sql = "update uf_lo_checkaccount set state='402864d149e039b10149e080b01600c2' where reqno='"+tempnos[j]+"'";
					sqlList.add(sql);
				}
			}
			//更新计划状态
			sql = "update uf_lo_loadplan set state='402864d1493b112a01493bfaf09b000c' where requestid='"+cancplan+"'";
			sqlList.add(sql);
			//更新派车单数据
			 
			List ls2 = ds.getValues("select * from uf_lo_loaddetail where requestid='"+cancplan+"'");
			for(int j=0,sizej=ls2.size();j<sizej;j++)
			{
				Map mj= (Map) ls2.get(j);
				String cardetailid=StringHelper.null2String(mj.get("cardetailid"));
				String runningno=StringHelper.null2String(mj.get("runningno"));
				String needtype=StringHelper.null2String(mj.get("needtype"),"402864d14931fb79014932928fae0026");//402864d14931fb79014932928fae0026 交运单  402864d14931fb79014932928fae0027 采购订单 402864d14931fb79014932928fae0029 非SAP
				double deliverdnum = NumberHelper.string2Double(StringHelper.null2String(mj.get("deliverdnum")));
				if(needtype.equals("402864d14931fb79014932928fae0026")){
					sql = "update uf_lo_delivery  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
					sql = "update uf_lo_delivery  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
				}
				if(needtype.equals("402864d14931fb79014932928fae0027")){
					sql = "update uf_lo_purchase  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
					sql = "update uf_lo_purchase  t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a')  and exists(select id from requestbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
				}
				if(needtype.equals("402864d14931fb79014932928fae0029")){
					sql = "update uf_lo_passdetail    t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
					sql = "update uf_lo_passdetail    t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a')  and exists(select id from requestbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='402864d14931fb79014932928fae0026' ),0.0) where runningno='"+runningno+"'";
					sqlList.add(sql);
				}
			}
			//runningno  子表是交运单号
			
			//更新交运单数据
			//update uf_lo_delivery  set yetnum=nvl(,0.0),xienum=nvl(,0.0) where deliveryno=
		}

		if(sqlList.size()>0)
		{
			JdbcTemplate jdbcTemp=baseJdbc.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
			}catch(DataAccessException ex){
				tm.rollback(status);
				throw ex;
			}

		} 
	}
 }



