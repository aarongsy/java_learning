package com.eweaver.app.dccm.dmlo.weigh;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
public class LoadPublicService {
	  public int refreshRealLoadPlan(String requestid)
	  {
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    List sqlList = new ArrayList();
	    String sql = "";
	    String tablename = "";

	    List detaillist = baseJdbc.executeSqlForList("select id,runningno,carreqid cardetailid,(select needtype from uf_dmlo_loadplan where requestid=t.requestid) needtype,nvl((select sum(yetloadnum) from uf_dmlo_provedoc a,uf_dmlo_shipprove  b  where a.requestid=b.requestid and  a.loadno in (select reqno from uf_dmlo_loadplan where requestid=t.requestid) and  b.runningno=t.runningno and exists(select id from formbase where id=a.requestid and isdelete=0) ),0.0) realsum from uf_dmlo_transhortdetail t where requestid='" + requestid + "'");
	    int i = 0; for (int sizei = detaillist.size(); i < sizei; i++) {
	      Map mi = (Map)detaillist.get(i);
	      String cardetailid = StringHelper.null2String(mi.get("cardetailid"));//派车需求id
	      String runningno = StringHelper.null2String(mi.get("runningno"));
	      String needtype = StringHelper.null2String(mi.get("needtype"));
	      String id = StringHelper.null2String(mi.get("id"));
	      double realsum = NumberHelper.string2Double(StringHelper.null2String(mi.get("realsum")), 0.0D);//已派车数量
	      refreshRealLoadPlanOne(needtype, requestid, runningno, cardetailid, realsum, id);
	    }

	    int ret = 0;
	    return ret;
	  }
	  public int refreshRealLoadPlanOne(String needtype, String requestid, String runningno, String cardetailid, double realsum, String detailid)
	  {
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    List sqlList = new ArrayList();

	    String sql = "";
	    cardetailid.length();

	    cardetailid.length();

	    String tablename = "";
	    if (needtype.equals("40285a8d56d542730156f8327a23460f")) {
	      tablename = "uf_dmlo_delivery";
	    }
	    else if (needtype.equals("40285a8d56d542730156f8327a234610")) {
	      tablename = "uf_dmlo_purchase";
	    }
	    else if (needtype.equals("40285a8d56d542730156f8327a234611")) {
	      tablename = "uf_dmlo_salesorder";
	    }
	    else if (needtype.equals("40285a8d57d51e140157d5ae436c4a6e")) {
	      tablename = "uf_dmlo_passdetail";
	    }

	    sql = "update " + tablename + "  t set pnum=nvl((select sum(deliverynum) from uf_dmlo_loadplan a,uf_dmlo_transhortdetail   b where a.requestid=b.requestid  and  a.state not in ('40285a8d5b142875015b2309388f2839') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
	    sqlList.add(sql);//单价取消

	    sql = "update " + tablename + "  t set pondnum=nvl((select sum(deliverynum) from uf_dmlo_loadplan a,uf_dmlo_transhortdetail   b where a.requestid=b.requestid  and  a.state  in ('40285a8d5b142875015b2309388f2838','40285a8d5b142875015b2309388f2837') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
	    sqlList.add(sql);//过磅完成，核算完成

	    if (cardetailid.length() > 10) {
	      sql = "update uf_dmlo_sentcarchild   t set yetloadnum=nvl((select sum(deliverynum) from uf_dmlo_loadplan a,uf_dmlo_transhortdetail b where a.requestid=b.requestid  and  a.state not in ('40285a8d5b142875015b2309388f2839') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id='" + cardetailid + "'";
	      sqlList.add(sql);
	      sql = "update uf_dmlo_sentcarchild   t set leftloadnum=deliverynum-yetloadnum where id ='" + cardetailid + "'";
	      sqlList.add(sql);
	    } else {
	      sql = "update uf_dmlo_sentcarchild   t set yetloadnum=nvl((select sum(deliverynum) from uf_dmlo_loadplan a,uf_dmlo_transhortdetail b where a.requestid=b.requestid  and  a.state not in ('40285a8d5b142875015b2309388f2839') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id in (select carreqid from uf_dmlo_transhortdetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
	      sqlList.add(sql);
	      sql = "update uf_dmlo_sentcarchild   t set leftloadnum=deliverynum-yetloadnum where id in (select carreqid from uf_dmlo_transhortdetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
	      sqlList.add(sql);
	    }

	    sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverynum) from uf_dmlo_sentcarmain  a,uf_dmlo_sentcarchild   b where a.requestid=b.requestid  and  a.state not in ('40285a8d5b142875015b2314697f2841') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
	    sqlList.add(sql);

	    if (sqlList.size() > 0)
	    {
	      JdbcTemplate jdbcTemp = baseJdbc.getJdbcTemplate();
	      PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());
	      DefaultTransactionDefinition def = new DefaultTransactionDefinition();
	      TransactionStatus status = tm.getTransaction(def);
	      try {
	        jdbcTemp.batchUpdate((String[])sqlList.toArray(new String[sqlList.size()]));
	        tm.commit(status);
	      } catch (DataAccessException ex) {
	        tm.rollback(status);
	        throw ex;
	      }
	    }
	    int ret = 0;
	    return ret;
	  }
	  public int reCalcFreightFee(String requestid)
	  {
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	    List sqlList = new ArrayList();

	    List mainlist = baseJdbc.executeSqlForList("select * from uf_dmlo_loadplan where  requestid='" + requestid + "'");
	    List lsdtil = baseJdbc.executeSqlForList("select runningno from uf_dmlo_transhortdetail where  requestid='" + requestid + "'");
	    String runningnos = "";
	    for (int i = 0; i < lsdtil.size(); i++) {
	      Map mdtil = (Map)lsdtil.get(0);
	      runningnos = StringHelper.null2String(mdtil.get("runningno"));
	    }
	    String materialtype = "";
	    String bulkflag = "";
	    List list003 = baseJdbc.executeSqlForList("select sotype from uf_dmlo_delivery where runningno = '" + runningnos + "'");
	    if (list003.size() > 0) {
	      Map m01 = (Map)list003.get(0);
	      materialtype = StringHelper.null2String(m01.get("sotype"));
	    }
	    List list002 = baseJdbc.executeSqlForList("select bulkflag from uf_dmlo_purchase  where runningno = '" + runningnos + "'");
	    if (list002.size() > 0) {
	      Map m02 = (Map)list002.get(0);
	      bulkflag = StringHelper.null2String(m02.get("bulkflag"));
	    }
	    if (("Z01".equals(materialtype)) || (!"".equals(bulkflag)))
	    {
	      if (mainlist.size() > 0) {
	        Map mainmap = (Map)mainlist.get(0);
	        String ispond = StringHelper.null2String(mainmap.get("ispond"));
	        String linetype = mainmap.get("linetype") == null ? "" : mainmap.get("linetype").toString();
	        String linecode = mainmap.get("linecode") == null ? "" : mainmap.get("linecode").toString();
	        String needtype = StringHelper.null2String(mainmap.get("needtype"));
	        String transittype = mainmap.get("transittype") == null ? "" : mainmap.get("transittype").toString();
	        String cartype = mainmap.get("cartype") == null ? "" : mainmap.get("cartype").toString();
	        String pricetype = StringHelper.null2String(mainmap.get("pricetype"));
	        String factory = mainmap.get("factory") == null ? "" : mainmap.get("factory").toString();
	        String transitton = mainmap.get("transitton") == null ? "" : mainmap.get("transitton").toString();
	        String sendtype = mainmap.get("sendtype") == null ? "" : mainmap.get("sendtype").toString();
	        String arrivecity = mainmap.get("arrivecity") == null ? "" : mainmap.get("arrivecity").toString();
	        String rconcode = mainmap.get("rconcode") == null ? "" : mainmap.get("rconcode").toString();
	        String rconname = mainmap.get("actname") == null ? "" : mainmap.get("actname").toString();
	        String currentdate = DateHelper.getCurrentDate();
	        String flag = "OK";
	        if ((!rconname.equals("")) && (!pricetype.equals("")) && (sendtype.equals("40285a8d57d51e140157daa3350f2c41"))) {//价格优先
	          double lineprice = 0.0D;
	          double mcityprice = 0.0D;
	          int mcitiesnums = 0;
	          double mcitypricesum = 0.0D;
	          double citypricesum = 0.0D;
	          double dsum = 0.0D;
	          if ((pricetype.equalsIgnoreCase("40285a8d56d542730156e90d0ed52f57")) && (!ispond.equals("40288098276fc2120127704884290211"))) {//配载
	            String tablename = "";
	            String flagname = "";
	            String permissiontable = "";
	            String flagvalue = "";
	            DataService ds = new DataService();
	            if (needtype.equals("40285a8d56d542730156f8327a23460f")) {
	              tablename = "uf_dmlo_delivery";
	              flagname = "packagetype";
	              permissiontable = "formbase";
	              flagvalue = "X";
	            }
	            else if (needtype.equals("40285a8d56d542730156f8327a234610")) {
	              tablename = "uf_dmlo_purchase";
	              flagname = "bulkflag";
	              permissiontable = "formbase";
	              flagvalue = "Z01";
	            }
	            else if (needtype.equals("40285a8d57d51e140157d5ae436c4a6e")) {
	              tablename = "uf_dmlo_passdetail";
	              flagname = "packagetype";
	              permissiontable = "bulkflag";
	              flagvalue = "Z01";
	            }

	            List xls = baseJdbc.executeSqlForList("select " + flagname + " from " + tablename + " t where exists(select id from " + permissiontable + " where id=t.requestid and isdelete=0) and runningno in (select runningno from uf_dmlo_transhortdetail where requestid='" + requestid + "')");
	            if (xls.size() > 0)
	            {
	              String sql1 = " and tend= '" + transitton + "'";
	              String sqlb = "select agentid,lineprice,cityaddprice from (select agentid,a.lineprice,cityaddprice from uf_dmlo_lineprice   a where agentid='" + rconname + "' and a.linecode='" + linecode + "' and a.linetype = '" + linetype + "' and a.cartype = '" + cartype + "' and transtype='" + transittype + "' and a.pricetype ='" + pricetype + "'" + sql1 + " and '" + currentdate + "' between a.sdate and a.edate  and ((elockdate is null  or elockdate is null) or ('" + currentdate + "' not between slockdate and elockdate )) and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) order by a.lineprice asc) where rownum=1";
	              List listb = baseJdbc.executeSqlForList(sqlb);

	              if (listb.size() > 0) {
	                lineprice = Double.parseDouble(((Map)listb.get(0)).get("lineprice") == null ? "0.0" : ((Map)listb.get(0)).get("lineprice").toString());
	                mcityprice = Double.parseDouble(((Map)listb.get(0)).get("cityaddprice") == null ? "0.0" : ((Map)listb.get(0)).get("cityaddprice").toString());
	              }
	              String sqlcn = "select nvl(sum(deliverynum)/1000,0.00) dsum from uf_dmlo_transhortdetail where requestid='" + requestid + "'";
	              dsum = NumberHelper.string2Double(Double.valueOf(Double.parseDouble(ds.getValue(sqlcn))), 0.0D);
	              lineprice *= dsum;
	              int fcitiesnums = 0;
	              double fcitypricesum = 0.0D;
	              double fxlpricesum = 0.0D;
	              citypricesum = mcitypricesum + fcitypricesum;
	              int allcitynums = fcitiesnums + mcitiesnums;
	              double fare = lineprice + citypricesum + fxlpricesum;
	              if (fare <= 0.0D) {
	                flag = "配载价格计算有错，请检查！";
	              }
	              //运输吨位
	              double tonnum = Double.parseDouble(ds.getValue("select nvl(b.objdesc,0) tonnum from uf_dmlo_loadplan a,selectitem b where a.transitton=b.id and a.transitton='" + transitton + "'"));
	              double tonsum = Double.parseDouble(ds.getValue("select nvl(sum(deliverynum)/1000,0.00) dsum from uf_dmlo_transhortdetail where requestid='" + requestid + "'"));
	              if (tonsum > tonnum) {
	                flag = flag + "吨数超出";
	              }
	             // baseJdbc.update("update uf_dmlo_loadplan set flag='" + flag + "',assistprice=" + fcitypricesum + ",cities=" + allcitynums + ",cityprice=" + citypricesum + ",fare=" + fare + " where requestid='" + requestid + "'");
	              baseJdbc.update("update uf_dmlo_loadplan set flag='" + flag + "' where requestid='" + requestid + "'");
	              LoadPlanService ft = new LoadPlanService();
	              ft.planningFreightExes(fare, requestid);

	           
	            }

	          }

	        }
	        else if ((!rconname.equals("")) && (!pricetype.equals("")) && (sendtype.equals("402864d14931fb790149324ec6de0007"))) {
	          flag = "系统暂不支持信用优先运输，请先调整！";
	          baseJdbc.update("update uf_dmlo_loadplan set flag='" + flag + "' where requestid='" + requestid + "'");
	        }
	      }

	    }

	    if (sqlList.size() > 0)
	    {
	      JdbcTemplate jdbcTemp = baseJdbc.getJdbcTemplate();
	      PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());
	      DefaultTransactionDefinition def = new DefaultTransactionDefinition();
	      TransactionStatus status = tm.getTransaction(def);
	      try {
	        jdbcTemp.batchUpdate((String[])sqlList.toArray(new String[sqlList.size()]));
	        tm.commit(status);
	      } catch (DataAccessException ex) {
	        tm.rollback(status);
	        throw ex;
	      }
	    }

	    int ret = 0;
	    return ret;
	  }
}
