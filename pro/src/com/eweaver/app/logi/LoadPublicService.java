package com.eweaver.app.logi;

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

public class LoadPublicService
{
  public int refreshBillStateNumByRequest(String runningno, String needtype)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }
    List sqlList = new ArrayList();
    String sql = "";

    sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverdnum) from uf_lo_dgcar a,uf_lo_dgcardetail b where a.requestid=b.requestid  and  a.state not in ('402864d14931fb790149328a92bd0018') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
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
    return 0;
  }

  public int refreshBillStateNumByPlan(String needtype, String requestid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();
    String sql = "";
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }

    List detaillist = baseJdbc.executeSqlForList("select id,runningno,cardetailid from uf_lo_loaddetail where requestid='" + requestid + "'");
    int i = 0; for (int sizei = detaillist.size(); i < sizei; i++) {
      Map mi = (Map)detaillist.get(i);
      String cardetailid = StringHelper.null2String(mi.get("cardetailid"));
      String runningno = StringHelper.null2String(mi.get("runningno"));

      sql = "update " + tablename + "  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
      sqlList.add(sql);

      sql = "update " + tablename + "  t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
      sqlList.add(sql);

      sql = "update uf_lo_dgcardetail    t set yetloadnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id='" + cardetailid + "'";
      sqlList.add(sql);
      sql = "update uf_lo_dgcardetail    t set leftloadnum=deliverdnum-yetloadnum where id ='" + cardetailid + "'";
      sqlList.add(sql);

      sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverdnum) from uf_lo_dgcar a,uf_lo_dgcardetail b where a.requestid=b.requestid  and  a.state not in ('402864d14931fb790149328a92bd0018') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
      sqlList.add(sql);
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

  public int refreshBillStateNumByPlanOne(String needtype, String requestid, String runningno, String cardetailid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();
    String sql = "";
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }

    sql = "update " + tablename + "  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
    sqlList.add(sql);

    sql = "update " + tablename + "  t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
    sqlList.add(sql);

    if (cardetailid.length() > 10) {
      sql = "update uf_lo_dgcardetail    t set yetloadnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id='" + cardetailid + "'";
      sqlList.add(sql);
      sql = "update uf_lo_dgcardetail    t set leftloadnum=deliverdnum-yetloadnum where id ='" + cardetailid + "'";
      sqlList.add(sql);
    } else {
      sql = "update uf_lo_dgcardetail    t set yetloadnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id in (select cardetailid from uf_lo_loaddetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
      sqlList.add(sql);
      sql = "update uf_lo_dgcardetail    t set leftloadnum=deliverdnum-yetloadnum where id in (select cardetailid from uf_lo_loaddetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
      sqlList.add(sql);
    }

    sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverdnum) from uf_lo_dgcar a,uf_lo_dgcardetail b where a.requestid=b.requestid  and  a.state not in ('402864d14931fb790149328a92bd0018') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
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
    return 0;
  }

  public int refreshBillStateByRequest(String runningno, String needtype)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }
    List sqlList = new ArrayList();
    String sql = "";

    sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverdnum) from uf_lo_dgcar a,uf_lo_dgcardetail b where a.requestid=b.requestid  and  a.state not in ('402864d14931fb790149328a92bd0018') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
    sqlList.add(sql);
    sql = "update " + tablename + "  t set yetmark=decode(yetnum,quantity,'1','0') where runningno='" + runningno + "'";
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
    return 0;
  }

  public int refreshBillStateByPlan(String needtype, String requestid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();
    String sql = "";
    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }

    List detaillist = baseJdbc.executeSqlForList("select id,runningno,cardetailid from uf_lo_loaddetail where requestid='" + requestid + "'");
    int i = 0; for (int sizei = detaillist.size(); i < sizei; i++) {
      Map mi = (Map)detaillist.get(i);
      String cardetailid = StringHelper.null2String(mi.get("cardetailid"));
      String runningno = StringHelper.null2String(mi.get("runningno"));

      sql = "update " + tablename + "  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
      sqlList.add(sql);

      sql = "update " + tablename + "  t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
      sqlList.add(sql);
      sql = "update " + tablename + "  t set xiemark=decode(xienum,quantity,'1','0'),bangmark=decode(bangnum,quantity,'1','0') where runningno='" + runningno + "'";
      sqlList.add(sql);
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

  public int reCalcFreightFee(String requestid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();

    List mainlist = baseJdbc.executeSqlForList("select * from uf_lo_loadplan where  requestid='" + requestid + "'");
    List lsdtil = baseJdbc.executeSqlForList("select runningno from uf_lo_loaddetail where  requestid='" + requestid + "'");
    String runningnos = "";
    for (int i = 0; i < lsdtil.size(); i++) {
      Map mdtil = (Map)lsdtil.get(0);
      runningnos = StringHelper.null2String(mdtil.get("runningno"));
    }
    String materialtype = "";
    String bulkflag = "";
    List list003 = baseJdbc.executeSqlForList("select materialtype from uf_lo_delivery where runningno = '" + runningnos + "'");
    if (list003.size() > 0) {
      Map m01 = (Map)list003.get(0);
      materialtype = StringHelper.null2String(m01.get("materialtype"));
    }
    List list002 = baseJdbc.executeSqlForList("select bulkflag from uf_lo_purchase  where runningno = '" + runningnos + "'");
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
        if ((!rconname.equals("")) && (!pricetype.equals("")) && (sendtype.equals("402864d14931fb790149324ec6de0006"))) {
          double lineprice = 0.0D;
          double mcityprice = 0.0D;
          int mcitiesnums = 0;
          double mcitypricesum = 0.0D;
          double citypricesum = 0.0D;
          double dsum = 0.0D;
          if ((pricetype.equalsIgnoreCase("40285a9048f924a70148fd0d027f0525")) && (!ispond.equals("40288098276fc2120127704884290211"))) {
            String tablename = "";
            String flagname = "";
            String permissiontable = "";
            String flagvalue = "";
            DataService ds = new DataService();
            if (needtype.equals("402864d14931fb79014932928fae0026")) {
              tablename = "uf_lo_delivery";
              flagname = "packagetype";
              permissiontable = "formbase";
              flagvalue = "X";
            }
            else if (needtype.equals("402864d14931fb79014932928fae0027")) {
              tablename = "uf_lo_purchase";
              flagname = "bulkflag";
              permissiontable = "formbase";
              flagvalue = "Z01";
            }
            else if (needtype.equals("402864d14931fb79014932928fae0029")) {
              tablename = "uf_lo_passdetail";
              flagname = "packagetype";
              permissiontable = "bulkflag";
              flagvalue = "40285a904c3230d7014c4a7868205d36";
            }

            List xls = baseJdbc.executeSqlForList("select " + flagname + " from " + tablename + " t where exists(select id from " + permissiontable + " where id=t.requestid and isdelete=0) and runningno in (select runningno from uf_lo_loaddetail where requestid='" + requestid + "')");
            if (xls.size() > 0)
            {
              String sql1 = " and tend= '" + transitton + "'";
              String sqlb = "select consolidator,lineprice,cityprice from (select a.consolidator,a.lineprice,a.cityprice from uf_lo_trackprice a where a.consolidator='" + rconname + "' and a.linecode='" + linecode + "' and a.linetype = '" + linetype + "' and a.cartype = '" + cartype + "' and a.transittype='" + transittype + "' and a.company = '" + factory + "' and a.pricetype ='" + pricetype + "'" + sql1 + " and '" + currentdate + "' between a.valid and a.validutil  and ((LOCKBEG is null  or LOCKend is null) or ('" + currentdate + "' not between LOCKBEG and LOCKend )) and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0) order by a.lineprice asc) where rownum=1";
              List listb = baseJdbc.executeSqlForList(sqlb);

              if (listb.size() > 0) {
                lineprice = Double.parseDouble(((Map)listb.get(0)).get("lineprice") == null ? "0.0" : ((Map)listb.get(0)).get("lineprice").toString());
                mcityprice = Double.parseDouble(((Map)listb.get(0)).get("cityprice") == null ? "0.0" : ((Map)listb.get(0)).get("cityprice").toString());
              }
              String sqlcn = "select nvl(sum(deliverdnum)/1000,0.00) dsum from uf_lo_loaddetail where requestid='" + requestid + "'";
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
              double tonnum = Double.parseDouble(ds.getValue("select nvl(b.objdesc,0) tonnum from uf_lo_loadplan a,selectitem b where a.transitton=b.id and a.transitton='" + transitton + "'"));
              double tonsum = Double.parseDouble(ds.getValue("select nvl(sum(deliverdnum)/1000,0.00) dsum from uf_lo_loaddetail where requestid='" + requestid + "'"));
              if (tonsum > tonnum) {
                flag = flag + "吨数超出";
              }
              baseJdbc.update("update uf_lo_loadplan set flag='" + flag + "',assistprice=" + fcitypricesum + ",cities=" + allcitynums + ",cityprice=" + citypricesum + ",fare=" + fare + " where requestid='" + requestid + "'");

              LoadPlanService ft = new LoadPlanService();
              ft.planningFreightExes(fare, requestid);

              List detaillist = baseJdbc.executeSqlForList("select id,runningno,cardetailid from uf_lo_loaddetail where requestid='" + requestid + "'");
              int i = 0; for (int sizei = detaillist.size(); i < sizei; i++) {
                Map mi = (Map)detaillist.get(i);
                String cardetailid = StringHelper.null2String(mi.get("cardetailid"));
                String str1 = StringHelper.null2String(mi.get("runningno"));
              }

            }

          }

        }
        else if ((!rconname.equals("")) && (!pricetype.equals("")) && (sendtype.equals("402864d14931fb790149324ec6de0007"))) {
          flag = "系统暂不支持信用优先运输，请先调整！";
          baseJdbc.update("update uf_lo_loadplan set flag='" + flag + "' where requestid='" + requestid + "'");
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

  public int refreshRealLoadPlanOne(String needtype, String requestid, String runningno, String cardetailid, double realsum, String detailid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();

    String sql = "";
    cardetailid.length();

    cardetailid.length();

    String tablename = "";
    if (needtype.equals("402864d14931fb79014932928fae0026")) {
      tablename = "uf_lo_delivery";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0027")) {
      tablename = "uf_lo_purchase";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0028")) {
      tablename = "uf_lo_salesorder";
    }
    else if (needtype.equals("402864d14931fb79014932928fae0029")) {
      tablename = "uf_lo_passdetail";
    }

    sql = "update " + tablename + "  t set xienum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
    sqlList.add(sql);

    sql = "update " + tablename + "  t set bangnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state  in ('402864d1493b112a01493bfaf09a0009','402864d1493b112a01493bfaf09a000a') and exists(select id from requestbase where id=a.requestid and isdelete=0) and  runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
    sqlList.add(sql);

    if (cardetailid.length() > 10) {
      sql = "update uf_lo_dgcardetail    t set yetloadnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id='" + cardetailid + "'";
      sqlList.add(sql);
      sql = "update uf_lo_dgcardetail    t set leftloadnum=deliverdnum-yetloadnum where id ='" + cardetailid + "'";
      sqlList.add(sql);
    } else {
      sql = "update uf_lo_dgcardetail    t set yetloadnum=nvl((select sum(deliverdnum) from uf_lo_loadplan a,uf_lo_loaddetail b where a.requestid=b.requestid  and  a.state not in ('402864d1493b112a01493bfaf09b000c') and exists(select id from formbase where id=a.requestid and isdelete=0) and   b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where id in (select cardetailid from uf_lo_loaddetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
      sqlList.add(sql);
      sql = "update uf_lo_dgcardetail    t set leftloadnum=deliverdnum-yetloadnum where id in (select cardetailid from uf_lo_loaddetail where requestid='" + requestid + "' and runningno='" + runningno + "')";
      sqlList.add(sql);
    }

    sql = "update " + tablename + "  t set yetnum=nvl((select sum(deliverdnum) from uf_lo_dgcar a,uf_lo_dgcardetail b where a.requestid=b.requestid  and  a.state not in ('402864d14931fb790149328a92bd0018') and exists(select id from formbase where id=a.requestid and isdelete=0) and  b.runningno=t.runningno and b.needtype='" + needtype + "' ),0.0) where runningno='" + runningno + "'";
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

  public int refreshRealLoadPlan(String requestid)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    List sqlList = new ArrayList();
    String sql = "";
    String tablename = "";

    List detaillist = baseJdbc.executeSqlForList("select id,runningno,cardetailid,(select needtype from uf_lo_loadplan where requestid=t.requestid) needtype,nvl((select sum(yetloadnum) from uf_lo_provedoc a,uf_lo_shipprove  b  where a.requestid=b.requestid and  a.loadno in (select reqno from uf_lo_loadplan where requestid=t.requestid) and  b.runningno=t.runningno and exists(select id from formbase where id=a.requestid and isdelete=0) ),0.0) realsum from uf_lo_loaddetail t where requestid='" + requestid + "'");
    int i = 0; for (int sizei = detaillist.size(); i < sizei; i++) {
      Map mi = (Map)detaillist.get(i);
      String cardetailid = StringHelper.null2String(mi.get("cardetailid"));
      String runningno = StringHelper.null2String(mi.get("runningno"));
      String needtype = StringHelper.null2String(mi.get("needtype"));
      String id = StringHelper.null2String(mi.get("id"));
      double realsum = NumberHelper.string2Double(StringHelper.null2String(mi.get("realsum")), 0.0D);
      refreshRealLoadPlanOne(needtype, requestid, runningno, cardetailid, realsum, id);
    }

    int ret = 0;
    return ret;
  }
}