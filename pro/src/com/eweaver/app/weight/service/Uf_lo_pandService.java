package com.eweaver.app.weight.service;

import com.eweaver.app.weight.model.Uf_lo_pandlog;
import com.eweaver.app.weight.model.Uf_lo_pandrecord;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class Uf_lo_pandService
{
  public boolean isInWeightable(String ladingno)
  {
    boolean ret = false;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    ret = isPrint(ladingno);
    String sql = "select * from uf_lo_pondrecord where (isvalid = '40288098276fc2120127704884290210' or isvirtual = '40288098276fc2120127704884290211') and ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      ret = false;
    }
    return ret;
  }

  public boolean isPrint(String ladingno)
  {
    boolean ret = false;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql1 = "select * from uf_lo_ladingmain where printtimes > 0 and ladingno = '" + ladingno + "' ";
    List list1 = baseJdbc.executeSqlForList(sql1);
    if (list1.size() > 0) {
      ret = true;
    }
    return ret;
  }

  public boolean isOutWeightable(String ladingno)
  {
    boolean ret = false;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select * from uf_lo_pondrecord where isvalid = '40288098276fc2120127704884290211' and tare <> 0 and ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      ret = true;
    }
    return ret;
  }

  public boolean isDeleteWeightable(String ladingno)
  {
    boolean ret = false;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select * from uf_lo_pondrecord where isvalid <> '40288098276fc2120127704884290210' and ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      ret = true;
    }
    return ret;
  }

  public int setInWeightLog(String ladingno, String weight, String weightype)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    if ("weighkc".equals(weightype.trim()))
      weightype = "40285a9049eeab010149eec7e21c0106";
    else if ("weighkg".equals(weightype.trim()))
      weightype = "40285a9049eeab010149eec7e21c0107";
    else {
      weightype = "40285a9049eeab010149eec7e21c0105";
    }

    StringBuffer buffer = new StringBuffer(4096);
    buffer.append("insert into uf_lo_pandlog");
    buffer.append("(id,requestid,company,ladingno,xieplanno,trailerno,carno,inweight,outweight,intype,createtime,factory) values");

    buffer.append("('").append(IDGernerator.getUnquieID())
      .append("',");
    buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("(select max(o.objno) from uf_lo_ladingmain a left join orgunit o on a.company = o.id where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("'").append(ladingno).append("',");
    buffer.append("(select max(loadingno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("(select max(a.trailerno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("(select max(a.carno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("'").append(weight).append("',");
    buffer.append("'0.00',");
    buffer.append("'").append(weightype).append("',");
    buffer.append("to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),");
    buffer.append("(select factory from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'))");

    ret = baseJdbc.update(buffer.toString());
    return ret;
  }

  public int setOutWeightLog(String ladingno, String weight, String weightype)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    if ("weighwg".equals(weightype.trim()))
      weightype = "40285a9049eeab010149eecda03a0127";
    else {
      weightype = "40285a9049eeab010149eecda03a0126";
    }

    StringBuffer buffer = new StringBuffer(4096);
    buffer.append("insert into uf_lo_pandlog");
    buffer.append("(id,requestid,company,ladingno,xieplanno,trailerno,carno,inweight,outweight,outtype,createtime,factory) values");

    buffer.append("('").append(IDGernerator.getUnquieID())
      .append("',");
    buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("(select max(o.objno) from uf_lo_ladingmain a left join orgunit o on a.company = o.id where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("'").append(ladingno).append("',");
    buffer.append("(select max(loadingno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("(select max(a.trailerno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("(select max(a.carno) from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'),");
    buffer.append("'0.00',");
    buffer.append("'").append(weight).append("',");
    buffer.append("'").append(weightype).append("',");
    buffer.append("to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'),");
    buffer.append("(select factory from uf_lo_ladingmain a where exists(select 1 from formbase where id = a.requestid and isdelete = 0) and ladingno = '").append(ladingno).append("'))");

    ret = baseJdbc.update(buffer.toString());
    return ret;
  }

  public int deleteWeigh(String ladingNo, String reason)
  {
    int ret = 0;
    DataService ds = new DataService();
    StringBuffer buffer = new StringBuffer(512);
    buffer.append("update uf_lo_pondrecord ");
    buffer.append("set tare = '',");
    buffer.append("grosswt = '',");
    buffer.append("accessvalue = '',");
    buffer.append("nw = '',");
    buffer.append("nottote = '40288098276fc2120127704884290211',");
    buffer.append("isvalid = '40288098276fc2120127704884290211',");
    buffer.append("isvirtual = '40288098276fc2120127704884290210' ");
    buffer.append("where ladingno = '").append(ladingNo).append("'");
    ret += ds.executeSql(buffer.toString());
    if (ret > 0) {
      buffer = new StringBuffer(512);
      buffer.append("insert into uf_lo_pandlog ");
      buffer.append("(id, requestid, ladingno, reason, deletetime) ");
      buffer.append("values ");
      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(ladingNo).append("',");
      buffer.append("'").append(reason).append("',");
      buffer.append("to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss')) ");

      ret += ds.executeSql(buffer.toString());
    }
    return ret;
  }

  public String getXiePlanNoByLading(String lading)
  {
    DataService ds = new DataService();
    StringBuffer buffer = new StringBuffer(512);
    buffer.append("select loadingno from uf_lo_ladingmain a ");
    buffer.append("where exists(select 1 from formbase where id = a.requestid and isdelete = 0) ");
    buffer.append("and ladingno = '").append(lading).append("'");
    String re = ds.getValue(buffer.toString());
    return re;
  }

  public Uf_lo_pandlog getLogByMap(Map m) {
    Uf_lo_pandlog lp = new Uf_lo_pandlog();
    if (m.containsKey("id"))
      lp.setId(StringHelper.null2String(m.get("id")));
    if (m.containsKey("requestid"))
      lp.setRequestid(StringHelper.null2String(m.get("requestid")));
    if (m.containsKey("factory"))
      lp.setFactory(StringHelper.null2String(m.get("factory")));
    if (m.containsKey("company"))
      lp.setCompany(StringHelper.null2String(m.get("company")));
    if (m.containsKey("ladingno"))
      lp.setLadingno(StringHelper.null2String(m.get("ladingno")));
    if (m.containsKey("xieplanno"))
      lp.setXieplanno(StringHelper.null2String(m.get("xieplanno")));
    if (m.containsKey("trailerno"))
      lp.setTrailerno(StringHelper.null2String(m.get("trailerno")));
    if (m.containsKey("carno"))
      lp.setCarno(StringHelper.null2String(m.get("carno")));
    if (m.containsKey("inweight"))
      lp.setInweight(Double.valueOf(Double.parseDouble(StringHelper.null2String(m.get("inweight")))));
    if (m.containsKey("outweight"))
      lp.setOutweight(Double.valueOf(Double.parseDouble(StringHelper.null2String(m.get("outweight")))));
    if (m.containsKey("intype"))
      lp.setIntype(StringHelper.null2String(m.get("intype")));
    if (m.containsKey("outtype"))
      lp.setOuttype(StringHelper.null2String(m.get("outtype")));
    if (m.containsKey("correction"))
      lp.setCorrection(StringHelper.null2String(m.get("correction")));
    if (m.containsKey("edittime")) {
      lp.setEdittime(StringHelper.null2String(m.get("edittime")));
    }
    return lp;
  }

  public List<Uf_lo_pandrecord> setInRecordByLadingno(String ladingno, String weight)
  {
    List recordList = new ArrayList();
    if (isFirstInWeigh(ladingno)) {
      setNewRecords(ladingno, weight);
      recordList = getNoInvalidRecords(ladingno);
    } else {
      recordList = getNoInvalidRecords(ladingno);
      for (int i = 0; i < recordList.size(); i++) {
        if (ladingno.trim().equals(((Uf_lo_pandrecord)recordList.get(i)).getLadingno())) {
          ((Uf_lo_pandrecord)recordList.get(i)).setIsvirtual("40288098276fc2120127704884290211");
        }
        if ("40288098276fc2120127704884290210".equals(((Uf_lo_pandrecord)recordList.get(i)).getNottote())) {
          double tare = NumberHelper.string2Double(((Uf_lo_pandrecord)recordList.get(i)).getTare(), 0.0D);
          double grosswt = NumberHelper.string2Double(((Uf_lo_pandrecord)recordList.get(i)).getGrosswt(), 0.0D);
          double we = NumberHelper.string2Double(weight, 0.0D);
          ((Uf_lo_pandrecord)recordList.get(i)).setTare(String.format("%.2f", new Object[] { Double.valueOf(tare - grosswt + we) }));
        } else {
          ((Uf_lo_pandrecord)recordList.get(i)).setTare(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(weight, 0.0D)) }));
        }
        updateRecord((Uf_lo_pandrecord)recordList.get(i));
      }
    }
    return recordList;
  }

  public List<Uf_lo_pandrecord> getNoInvalidRecords(String ladingno)
  {
    List recordList = new ArrayList();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select * from uf_lo_pondrecord c where c.ladingno in (select ladingno from uf_lo_ladingmain b where exists(select 1 from formbase f where b.requestid = f.id and isdelete <> 1) and b.loadingno = (select a.loadingno from uf_lo_ladingmain a where exists(select 1 from formbase f where a.requestid = f.id and isdelete <> 1) and a.ladingno = '" + 
      ladingno + "')) and c.isvalid != '40288098276fc2120127704884290210' ";
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      Map atMap = (Map)list.get(i);
      recordList.add(getRecordByMap(atMap));
    }
    return recordList;
  }

  public Uf_lo_pandrecord getRecord(String ladingno)
  {
    Uf_lo_pandrecord record = new Uf_lo_pandrecord();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select * from uf_lo_pondrecord c where c.ladingno = '" + ladingno + "' ";

    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      Map atMap = (Map)list.get(0);
      record = getRecordByMap(atMap);
    } else {
      record = null;
    }
    return record;
  }

  public void setNewRecords(String ladingno, String weight)
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select ladingno,trailerno,carno from uf_lo_ladingmain b where exists(select 1 from formbase f where b.requestid = f.id and isdelete <> 1) and b.loadingno = (select a.loadingno from uf_lo_ladingmain a where exists(select 1 from formbase f where a.requestid = f.id and isdelete <> 1) and a.ladingno = '" + 
      ladingno + "')";
    List list = baseJdbc.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      Map atMap = (Map)list.get(i);
      Uf_lo_pandrecord record = new Uf_lo_pandrecord();
      record.setLadingno(StringHelper.null2String(atMap.get("ladingno")));
      record.setTare(weight);
      record.setTrailerno(StringHelper.null2String(atMap.get("trailerno")));
      record.setCarno(StringHelper.null2String(atMap.get("carno")));
      if (ladingno.trim().equals(StringHelper.null2String(atMap.get("ladingno"))))
        record.setIsvirtual("40288098276fc2120127704884290211");
      else {
        record.setIsvirtual("40288098276fc2120127704884290210");
      }
      creatNewRecord(record);

      baseJdbc.update("update uf_lo_loadplan set inweighttime =to_char(sysdate,'yyyy-MM-dd hh24:mi:ss') where REQUESTID = (select REQUESTID from uf_lo_loadplan where reqno = ( select loadingno from uf_lo_ladingmain where ladingno = '" + StringHelper.null2String(atMap.get("ladingno")) + "'))");
    }
  }

  public int creatNewRecord(Uf_lo_pandrecord record)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(512);
    buffer.append("insert into uf_lo_pondrecord");
    buffer.append("(id,requestid,ladingno,isvirtual,pondcode,trailerno,carno,tare,grosswt,accessvalue,nw,nottote,isvalid,marked,edittime) values");

    buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append(StringHelper.null2String(record.getLadingno())).append("',");
    buffer.append("'").append(StringHelper.null2String(record.getIsvirtual())).append("',");
    buffer.append("to_char(weigh_sequence.NEXTVAL, '000000000000'),");
    buffer.append("'").append(StringHelper.null2String(record.getTrailerno())).append("',");
    buffer.append("'").append(StringHelper.null2String(record.getCarno())).append("',");
    buffer.append("'").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getTare(), 0.0D)) })).append("',");
    buffer.append("'").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getGrosswt(), 0.0D)) })).append("',");
    buffer.append("'").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getAccessvalue(), 0.0D)) })).append("',");
    buffer.append("'").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getNw(), 0.0D)) })).append("',");
    buffer.append("'40288098276fc2120127704884290211',");
    buffer.append("'40288098276fc2120127704884290211',");
    buffer.append("(select case when shipout = '40285a904a17fd75014a18e6bd85267c' then -1 when shipout = '40285a904a17fd75014a18e6bd85267b' then 1 else 0 end from uf_lo_ladingmain where ladingno = '").append(StringHelper.null2String(record.getLadingno())).append("'),");
    buffer.append("to_char(sysdate,'yyyy-mm-dd hh24:mi:ss'))");
    ret = baseJdbc.update(buffer.toString());
    return ret;
  }

  public int updateRecord(Uf_lo_pandrecord record)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    StringBuffer buffer = new StringBuffer(512);
    buffer.append("update uf_lo_pondrecord set ");
    buffer.append("isvirtual = '").append(StringHelper.null2String(record.getIsvirtual())).append("',");

    buffer.append("tare = '").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getTare(), 0.0D)) })).append("',");
    buffer.append("grosswt = '").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getGrosswt(), 0.0D)) })).append("',");
    buffer.append("accessvalue = '").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getAccessvalue(), 0.0D)) })).append("',");
    buffer.append("nw = '").append(String.format("%.2f", new Object[] { Double.valueOf(NumberHelper.string2Double(record.getNw(), 0.0D)) })).append("',");
    buffer.append("nottote = '").append(StringHelper.null2String(record.getNottote())).append("',");
    buffer.append("isvalid = '").append(StringHelper.null2String(record.getIsvalid())).append("',");
    buffer.append("edittime = to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') ");
    buffer.append("where ladingno = '").append(StringHelper.null2String(record.getLadingno())).append("'");

    ret = baseJdbc.update(buffer.toString());

    return ret;
  }

  public Uf_lo_pandrecord getRecordByMap(Map m)
  {
    Uf_lo_pandrecord record = new Uf_lo_pandrecord();
    if (m.containsKey("id"))
      record.setId(StringHelper.null2String(m.get("id")));
    if (m.containsKey("requestid"))
      record.setRequestid(StringHelper.null2String(m.get("requestid")));
    if (m.containsKey("ladingno"))
      record.setLadingno(StringHelper.null2String(m.get("ladingno")));
    if (m.containsKey("isvirtual"))
      record.setIsvirtual(StringHelper.null2String(m.get("isvirtual")));
    if (m.containsKey("pondcode"))
      record.setPondcode(StringHelper.null2String(m.get("pondcode")));
    if (m.containsKey("trailerno"))
      record.setTrailerno(StringHelper.null2String(m.get("trailerno")));
    if (m.containsKey("carno"))
      record.setCarno(StringHelper.null2String(m.get("carno")));
    if (m.containsKey("tare"))
      record.setTare(StringHelper.null2String(m.get("tare")));
    if (m.containsKey("grosswt"))
      record.setGrosswt(StringHelper.null2String(m.get("grosswt")));
    if (m.containsKey("accessvalue"))
      record.setAccessvalue(StringHelper.null2String(m.get("accessvalue")));
    if (m.containsKey("nottote"))
      record.setNottote(StringHelper.null2String(m.get("nottote")));
    if (m.containsKey("nw"))
      record.setNw(StringHelper.null2String(m.get("nw")));
    if (m.containsKey("isvalid"))
      record.setIsvalid(StringHelper.null2String(m.get("isvalid")));
    if (m.containsKey("edittime"))
      record.setEdittime(StringHelper.null2String(m.get("edittime")));
    if (m.containsKey("marked"))
      record.setMarked(NumberHelper.getIntegerValue(m.get("marked")));
    return record;
  }

  public boolean isFirstInWeigh(String ladingno)
  {
    boolean ret = true;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select * from uf_lo_pondrecord where ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      ret = false;
    }
    return ret;
  }

  public String setOutRecordByLadingno(String ladingno, String weight, String weightype)
  {
    System.out.println("--------------------------过磅 修改过磅记录 add---------------------------");
    String ret = "";
    double calc = calcPlanWeight(ladingno);
    Uf_lo_pandrecord record = getRecord(ladingno);
    double grosswt = NumberHelper.string2Double(weight, 0.0D);
    double tare = NumberHelper.string2Double(record.getTare(), 0.0D);

    record.setGrosswt(String.format("%.2f", new Object[] { Double.valueOf(grosswt) }));
    record.setAccessvalue(String.format("%.2f", new Object[] { Double.valueOf((grosswt - tare) * record.getMarked().intValue()) }));
    if ("weighwg".equals(weightype.trim())) {
      record.setIsvirtual("40288098276fc2120127704884290210");
      record.setNottote("40288098276fc2120127704884290210");
    } else {
      record.setNw(String.format("%.2f", new Object[] { Double.valueOf((grosswt - tare) * record.getMarked().intValue()) }));
      record.setIsvalid("40288098276fc2120127704884290210");
      record.setNottote("40288098276fc2120127704884290211");
      weighOverByLading(ladingno);

      Uf_lo_budgetService bs = new Uf_lo_budgetService();
      String requestid = bs.getRequestidByLadingno(ladingno);
      ofShortSingleState(requestid);

      weighingTime(requestid, ladingno);

      isOverWeighByPlan(ladingno);
    }

    if ((NumberHelper.string2Double(record.getNw(), 0.0D) >= 0.0D) || ("weighwg".equals(weightype.trim()))) {
      updateRecord(record);

      getLoadingNumber(ladingno);
      Uf_lo_proveService ps = new Uf_lo_proveService();
      ps.createProveByPlan(ladingno, record.getNw());

      calc -= NumberHelper.string2Double(record.getNw(), 0.0D);
    }
    else {
      getLoadingNumber(ladingno);
    }
    ret = record.getCarno() + ";;" + record.getGrosswt() + ";;" + record.getTare() + ";;" + record.getNw() + ";;" + calc;
    System.out.println("--------------------------------------- ret : " + ret);
    System.out.println("--------------------------过磅 修改过磅记录 end---------------------------");
    return ret;
  }

  public int weighingTime(String requestid, String ladingno)
  {
    int ret = 0;

    Date currentTime = new Date();
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String dateString = formatter.format(currentTime);
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    List list001 = baseJdbc.executeSqlForList("select runningno from uf_lo_ladingdetail where requestid =(select requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "')");
    if (list001.size() > 0) {
      Map map001 = (Map)list001.get(0);
      String runningno = StringHelper.null2String(map001.get("runningno"));

      String nw = "";
      List list004 = baseJdbc.executeSqlForList("select nw from uf_lo_pondrecord where ladingno = '" + ladingno + "'");
      if (list004.size() > 0) {
        Map map004 = (Map)list004.get(0);
        nw = StringHelper.null2String(map004.get("nw"));
      }

      String mainprice = "";
      List list005 = baseJdbc.executeSqlForList("select mainprice from uf_lo_loadplan where requestid = '" + requestid + "'");
      if (list005.size() > 0) {
        Map map005 = (Map)list005.get(0);
        mainprice = StringHelper.null2String(map005.get("mainprice"));
      }
      double fares = NumberHelper.string2Double(nw, 0.0D) * NumberHelper.string2Double(mainprice, 0.0D);

      List list002 = baseJdbc.executeSqlForList("select materialtype from uf_lo_delivery where runningno = '" + runningno + "'");
      if (list002.size() > 0) {
        Map map002 = (Map)list002.get(0);
        String materialtype = StringHelper.null2String(map002.get("materialtype"));
        if ("Z01".equals(materialtype))
          baseJdbc.update("update uf_lo_loadplan set fare = '" + fares + "' where requestid = '" + requestid + "'");
      }
      else {
        List list003 = baseJdbc.executeSqlForList("select bulkflag from uf_lo_purchase  where runningno = '" + runningno + "' ");
        if (list003.size() > 0) {
          Map map003 = (Map)list003.get(0);
          String bulkflag = StringHelper.null2String(map003.get("bulkflag"));
          if (!"".equals(bulkflag)) {
            baseJdbc.update("update uf_lo_loadplan set fare = '" + fares + "' where requestid = '" + requestid + "'");
          }
        }
      }
    }
    String sql = "update uf_lo_loadplan set finishpond = '" + dateString + "' where requestid = '" + requestid + "'";
    ret = baseJdbc.update(sql);
    return ret;
  }

  public int ofShortSingleState(String requestid)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "update uf_lo_budget set feetype = '40285a8d4d6fab42014d742812381730' where requestid = '" + requestid + "'";
    ret = baseJdbc.update(sql);
    return ret;
  }

  public String virOutRecordByLadingno(String ladingno, String weight, String weightype)
  {
    String ret = "";
    Uf_lo_pandrecord record = getRecord(ladingno);
    double grosswt = NumberHelper.string2Double(weight, 0.0D);
    double tare = NumberHelper.string2Double(record.getTare(), 0.0D);

    record.setGrosswt(String.format("%.2f", new Object[] { Double.valueOf(grosswt) }));
    record.setAccessvalue(String.format("%.2f", new Object[] { Double.valueOf((grosswt - tare) * record.getMarked().intValue()) }));
    if (!"weighwg".equals(weightype.trim())) {
      record.setNw(String.format("%.2f", new Object[] { Double.valueOf((grosswt - tare) * record.getMarked().intValue()) }));
      record.setIsvalid("40288098276fc2120127704884290210");
    }

    ret = record.getCarno() + ";;" + record.getGrosswt() + ";;" + record.getTare() + ";;" + record.getNw();
    return ret;
  }

  public boolean isOverWeighByPlan(String ladingno)
  {
    boolean ret = true;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql1 = "select uf_lo_loadplan.* from uf_lo_ladingmain left join uf_lo_loadplan on uf_lo_ladingmain.loadingno = uf_lo_loadplan.reqno where uf_lo_loadplan.isself = '40288098276fc2120127704884290210' and uf_lo_ladingmain.ladingno = '" + 
      ladingno + "'";
    List list1 = baseJdbc.executeSqlForList(sql1);
    if (list1.size() > 0) {
      ret = false;
    }
    String sql = "select l2.* from uf_lo_ladingmain l1 left join uf_lo_ladingmain l2 on l1.loadingno = l2.loadingno where exists (select 1 from formbase where id = l2.requestid and isdelete <> 1) and l2.ispond = '40288098276fc2120127704884290211' and l1.ladingno = '" + 
      ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      ret = false;
    }
    return ret;
  }

  public int weighOverByLading(String ladingno)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "update uf_lo_ladingmain set ispond = '40288098276fc2120127704884290210',state = '402864d14940d265014941e9d82900db' where ladingno = '" + ladingno + "'";
    ret = baseJdbc.update(sql);
    return ret;
  }

  public double calcPlanWeight(String ladingno)
  {
    double ret = 0.0D;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select deliverdnum,packcode from uf_lo_ladingdetail where requestid = (select requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "')";
    List list = baseJdbc.executeSqlForList(sql);
    if (list != null) {
      Map map = (Map)list.get(0);
      ret = NumberHelper.string2Double(map.get("deliverdnum"), 0.0D);
    }
    return ret;
  }

  public boolean EmptyWeight(String ladingno, String weight)
  {
    boolean ret = true;
    int weights = 0;
    int tares = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select ladingno,trailerno,carno from uf_lo_ladingmain b  where exists(select 1 from formbase f where b.requestid = f.id and isdelete <> 1) and b.loadingno = (select a.loadingno from uf_lo_ladingmain a  where exists(select 1 from formbase f where a.requestid = f.id and isdelete <> 1) and a.ladingno = '" + 
      ladingno + "')";
    List list = baseJdbc.executeSqlForList(sql);
    String carno = "";
    String tare = "";
    if (list != null) {
      Map map = (Map)list.get(0);
      carno = StringHelper.null2String(map.get("carno"));

      List list001 = baseJdbc.executeSqlForList("select tare from (select tare from uf_lo_pondrecord where carno = '" + carno + "' order by id desc)where rownum=1");
      if (list001 != null) {
        Map map001 = (Map)list.get(0);
        tare = StringHelper.null2String(map.get("tare"));

        tares = Integer.parseInt(tare);
        weights = Integer.parseInt(weight);
      }
    }
    return ret;
  }

  public boolean transceiver(String ladingno)
  {
    boolean ret = true;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    BaseJdbcDao baseJdbcs = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String sql = "select requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list != null) {
      Map map = (Map)list.get(0);
      String requestid = StringHelper.null2String(map.get("requestid"));
      List list001 = baseJdbcs.executeSqlForList("select * from uf_lo_spotmanager where ladingno = '" + requestid + "' and state = '402864d14940d265014941e9d82900da'");
      if (list001.size() <= 0)
      {
        ret = false;
      }
    }
    return ret;
  }

  public boolean getZxSlBj(String ladingno, String weight)
  {
    boolean ret = true;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    BaseJdbcDao baseJdbcs = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String materialtype = "";
    String deliverylimit = "";
    String quantity = "";
    double sl = 0.0D;
    double weights = 0.0D;

    double tare = 0.0D;
    List list0 = baseJdbc.executeSqlForList("select c.tare from uf_lo_pondrecord c where c.ladingno = '" + ladingno + "'");
    if (list0.size() > 0) {
      Map map0 = (Map)list0.get(0);
      tare = NumberHelper.string2Double(map0.get("tare"), 0.0D);
    }

    String sql = "select requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "'";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      String requestid = StringHelper.null2String(map.get("requestid"));

      List list001 = baseJdbc.executeSqlForList("select runningno from uf_lo_ladingdetail  where requestid = '" + requestid + "'");
      if (list001.size() > 0) {
        Map map001 = (Map)list001.get(0);
        String runningno = StringHelper.null2String(map001.get("runningno"));

        List list002 = baseJdbc.executeSqlForList("select materialtype,deliverylimit,quantity,overmark from uf_lo_delivery where runningno = '" + runningno + "'");
        if (list002.size() > 0) {
          Map map002 = (Map)list002.get(0);
          materialtype = StringHelper.null2String(map002.get("materialtype"));
          deliverylimit = StringHelper.null2String(map002.get("deliverylimit"));
          quantity = StringHelper.null2String(map002.get("quantity"));
          String overmark = StringHelper.null2String(map002.get("overmark"));
          if (("Z01".equals(materialtype)) && ("".equals(overmark))) {
            sl = NumberHelper.string2Double(quantity, 0.0D) + NumberHelper.string2Double(quantity, 0.0D) * NumberHelper.string2Double(deliverylimit, 0.0D);

            weights = NumberHelper.string2Double(weight, 0.0D);
            if (weights > sl + tare)
              ret = false;
          }
        }
        else {
          List list003 = baseJdbc.executeSqlForList("select quantity,bulkflag,overmark from uf_lo_purchase where runningno = '" + runningno + "'");
          if (list003.size() > 0) {
            Map map003 = (Map)list003.get(0);
            String quantity1 = StringHelper.null2String(map003.get("quantity"));
            String bulkflag = StringHelper.null2String(map003.get("bulkflag"));
            String overmark = StringHelper.null2String(map003.get("overmark"));
            if ((!"".equals(bulkflag)) && ("".equals(overmark))) {
              sl = NumberHelper.string2Double(quantity1, 0.0D) + NumberHelper.string2Double(quantity1, 0.0D) * NumberHelper.string2Double(overmark, 0.0D);

              weights = NumberHelper.string2Double(weight, 0.0D);
              if (weights > sl + tare) {
                ret = false;
              }
            }
          }
        }
      }
    }
    return ret;
  }

  public double getJzJhyzl(String ladingno, String weight)
  {
    double ret = 0.0D;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String totalnum = "";
    String shipout = "";
    String requestid = "";

    double tare = 0.0D;
    List list0 = baseJdbc.executeSqlForList("select c.tare from uf_lo_pondrecord c where c.ladingno = '" + ladingno + "'");
    if (list0.size() > 0) {
      Map map0 = (Map)list0.get(0);
      tare = NumberHelper.string2Double(map0.get("tare"), 0.0D);
    }
    System.out.println("----------------------------------- tare = " + tare);

    List list = baseJdbc.executeSqlForList("select totalnum,shipout,requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "'");
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      totalnum = StringHelper.null2String(map.get("totalnum"));
      shipout = StringHelper.null2String(map.get("shipout"));
      requestid = StringHelper.null2String(map.get("requestid"));
    }

    List list002 = baseJdbc.executeSqlForList("select runningno,sum(deliverdnum) deliverdnum from uf_lo_ladingdetail where requestid = '" + requestid + "' group by runningno");
    String runningno = "";
    String packagecode = "";
    String bzrqid = "";
    double deliverdnum = 0.0D;
    double pmnum = 0.0D;
    double nw = 0.0D;
    double hezl = 0.0D;
    double llmz = 0.0D;
    if (list002.size() > 0) {
      Map map_detail = (Map)list002.get(0);

      runningno = StringHelper.null2String(map_detail.get("runningno"));
      deliverdnum = NumberHelper.string2Double(map_detail.get("deliverdnum"), 0.0D);
      System.out.println("----------------------------------- deliverdnum ：" + deliverdnum);

      List list_detail = baseJdbc.executeSqlForList("select packagecode from uf_lo_delivery where runningno = '" + runningno + "'");
      if (list_detail.size() > 0) {
        Map map_detail1 = (Map)list_detail.get(0);
        packagecode = StringHelper.null2String(map_detail1.get("packagecode"));
      }
      System.out.println("----------------------------------- packagecode = " + packagecode);
      if (!"".equals(packagecode))
      {
        List list_detail2 = baseJdbc.executeSqlForList("select requestid from uf_lo_packmain where packcode = '" + packagecode + "'");
        if (list_detail2.size() > 0) {
          Map map_detail2 = (Map)list_detail2.get(0);
          bzrqid = StringHelper.null2String(map_detail2.get("requestid"));
        }

        List list_detail3 = baseJdbc.executeSqlForList("select pmnum,nw from uf_lo_packdetail where requestid = '" + bzrqid + "'");
        for (int j = 0; j < list_detail3.size(); j++) {
          Map map_detail3 = (Map)list_detail3.get(j);
          pmnum = NumberHelper.string2Double(map_detail3.get("pmnum"), 0.0D);
          nw = NumberHelper.string2Double(map_detail3.get("nw"), 0.0D);
          hezl += pmnum * nw;
        }

        llmz = deliverdnum + hezl;
        double cz = NumberHelper.string2Double(weight, 0.0D) - tare - llmz;
        if (NumberHelper.string2Double(weight, 0.0D) - tare > llmz) {
          ret = cz;
        }
      }
    }
    return ret;
  }

  public boolean getslbj(String ladingno, String weight)
  {
    boolean ret = true;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    double deliverdnum = 0.0D;
    String requestid = "";
    String shipout = "";

    double tare = 0.0D;
    List list0 = baseJdbc.executeSqlForList("select c.tare from uf_lo_pondrecord c where c.ladingno = '" + ladingno + "'");
    if (list0.size() > 0) {
      Map map0 = (Map)list0.get(0);
      tare = NumberHelper.string2Double(map0.get("tare"), 0.0D);
    }

    List list = baseJdbc.executeSqlForList("select requestid,shipout from uf_lo_ladingmain where ladingno = '" + ladingno + "'");
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      requestid = StringHelper.null2String(map.get("requestid"));
      shipout = StringHelper.null2String(map.get("shipout"));
      List listdetail = baseJdbc.executeSqlForList("select sum(deliverdnum) deliverdnum from uf_lo_ladingdetail where requestid = '" + requestid + "'");
      if (listdetail.size() > 0) {
        Map mapdetail = (Map)listdetail.get(0);
        deliverdnum = NumberHelper.string2Double(mapdetail.get("deliverdnum"), 0.0D);
      }

      if ("40285a904a17fd75014a18e6bd85267b".equals(shipout)) {
        if (NumberHelper.string2Double(weight, 0.0D) < tare)
          ret = false;
      }
      else if (("40285a904a17fd75014a18e6bd85267c".equals(shipout)) && 
        (NumberHelper.string2Double(weight, 0.0D) > tare)) {
        ret = false;
      }
    }

    return ret;
  }

  public String getbzbshx(String ladingno) {
    String ret = "";
    BaseJdbcDao daseDB = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    List list001 = daseDB.executeSqlForList("select requestid from uf_lo_ladingmain where ladingno = '" + ladingno + "'");
    String requetsid = "";
    if (list001.size() > 0) {
      Map map001 = (Map)list001.get(0);
      requetsid = StringHelper.null2String(map001.get("requestid"));
    }
    List list002 = daseDB.executeSqlForList("select yetloadnum,runningno from uf_lo_ladingdetail where requestid = '" + requetsid + "'");
    String yetloadnum = "";
    String runningno = "";
    String salestype = "";
    String nw = "";
    for (int i = 0; i < list002.size(); i++) {
      Map map002 = (Map)list002.get(i);
      yetloadnum = StringHelper.null2String(map002.get("yetloadnum"));
      runningno = StringHelper.null2String(map002.get("runningno"));

      List list004 = daseDB.executeSqlForList("select nw from uf_lo_pondrecord c where c.ladingno = '" + ladingno + "'");
      if (list004.size() > 0) {
        Map map004 = (Map)list004.get(0);
        nw = StringHelper.null2String(map004.get("nw"));
      }

      double bangnum = 0.0D;
      double quantity = 0.0D;
      List list003 = daseDB.executeSqlForList("select materialtype from uf_lo_delivery where runningno = '" + runningno + "'");
      if (list003.size() > 0) {
        Map map003 = (Map)list003.get(0);
        salestype = StringHelper.null2String(map003.get("materialtype"));

        if ("Z01".equals(salestype)) {
          daseDB.update("update uf_lo_delivery set bangnum =nvl(bangnum,0) +  " + NumberHelper.string2Double(nw, 0.0D) + "  where runningno = '" + runningno + "'");

          List sqlgblist = daseDB.executeSqlForList("select bangnum,quantity from uf_lo_delivery where runningno = '" + runningno + "'");
          if (sqlgblist.size() > 0) {
            Map mapgblist = (Map)sqlgblist.get(0);
            bangnum = NumberHelper.string2Double(mapgblist.get("bangnum"), 0.0D);
            quantity = NumberHelper.string2Double(mapgblist.get("quantity"), 0.0D);
            if (bangnum + NumberHelper.string2Double(nw, 0.0D) >= quantity)
              daseDB.update("update uf_lo_delivery set bangmark = '0'  where runningno = '" + runningno + "'");
            else
              daseDB.update("update uf_lo_delivery set bangmark = '1'  where runningno = '" + runningno + "'");
          }
        }
        else {
          daseDB.update("update uf_lo_delivery set bangnum =nvl(bangnum,0) +  " + NumberHelper.string2Double(yetloadnum, 0.0D) + "  where runningno = '" + runningno + "'");

          List sqlgblist = daseDB.executeSqlForList("select bangnum,quantity from uf_lo_delivery where runningno = '" + runningno + "'");
          if (sqlgblist.size() > 0) {
            Map mapgblist = (Map)sqlgblist.get(0);
            bangnum = NumberHelper.string2Double(mapgblist.get("bangnum"), 0.0D);
            quantity = NumberHelper.string2Double(mapgblist.get("quantity"), 0.0D);
            if (bangnum + NumberHelper.string2Double(yetloadnum, 0.0D) >= quantity)
              daseDB.update("update uf_lo_delivery set bangmark = '0'  where runningno = '" + runningno + "'");
            else
              daseDB.update("update uf_lo_delivery set bangmark = '1'  where runningno = '" + runningno + "'");
          }
        }
      }
      else {
        String bulkflag = "";
        List list005 = daseDB.executeSqlForList("select bulkflag from uf_lo_purchase where runningno = '" + runningno + "'");
        if (list005.size() > 0) {
          Map map005 = (Map)list005.get(0);
          bulkflag = StringHelper.null2String(map005.get("bulkflag"));
          if (!"".equals(bulkflag)) {
            daseDB.update("update uf_lo_purchase set bangnum =nvl(bangnum,0) +  " + NumberHelper.string2Double(nw, 0.0D) + "  where runningno = '" + runningno + "'");

            List sqlgblist = daseDB.executeSqlForList("select bangnum,quantity from uf_lo_purchase where runningno = '" + runningno + "'");
            if (sqlgblist.size() > 0) {
              Map mapgblist = (Map)sqlgblist.get(0);
              bangnum = NumberHelper.string2Double(mapgblist.get("bangnum"), 0.0D);
              quantity = NumberHelper.string2Double(mapgblist.get("quantity"), 0.0D);
              if (bangnum + NumberHelper.string2Double(nw, 0.0D) >= quantity)
                daseDB.update("update uf_lo_purchase set bangmark = '0'  where runningno = '" + runningno + "'");
              else
                daseDB.update("update uf_lo_purchase set bangmark = '1'  where runningno = '" + runningno + "'");
            }
          }
          else {
            daseDB.update("update uf_lo_purchase set bangnum =nvl(bangnum,0) +  " + NumberHelper.string2Double(yetloadnum, 0.0D) + "  where runningno = '" + runningno + "'");

            List sqlgblist = daseDB.executeSqlForList("select bangnum,quantity from uf_lo_purchase where runningno = '" + runningno + "'");
            if (sqlgblist.size() > 0) {
              Map mapgblist = (Map)sqlgblist.get(0);
              bangnum = NumberHelper.string2Double(mapgblist.get("bangnum"), 0.0D);
              quantity = NumberHelper.string2Double(mapgblist.get("quantity"), 0.0D);
              if (bangnum + NumberHelper.string2Double(yetloadnum, 0.0D) >= quantity)
                daseDB.update("update uf_lo_purchase set bangmark = '0'  where runningno = '" + runningno + "'");
              else {
                daseDB.update("update uf_lo_purchase set bangmark = '1'  where runningno = '" + runningno + "'");
              }
            }
          }
        }
      }
    }
    return ret;
  }

  public String getLoadingThePrice(String plate)
  {
    String ret = "";
    BaseJdbcDao jdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    Uf_lo_budgetService bs = new Uf_lo_budgetService();
    String shiptoaddress = "";
    String pricetype = "";
    String needtype = "";
    String tablename = "";

    double nw = 0.0D;
    double mainprice = 0.0D;
    double distance = 0.0D;
    double zfy = 0.0D;
    double fyft = 0.0D;
    double mxlj = 0.0D;
    double deliverdnum = 0.0D;
    double sjnwc = 0.0D;
    double jsyzl = 0.0D;
    List list = jdbcDao.executeSqlForList("select nw from uf_lo_pondrecord c where c.ladingno = '" + plate + "'");
    if (list.size() > 0) {
      System.out.println("***********************装卸运载量回写及相关价格计算开始*********************");
      Map map = (Map)list.get(0);
      nw = NumberHelper.string2Double(map.get("nw"), 0.0D);
      String requestid = bs.getRequestidByLadingno(plate);

      List list001 = jdbcDao.executeSqlForList("select mainprice,pricetype,needtype from uf_lo_loadplan where requestid = '" + requestid + "'");
      if (list001.size() > 0) {
        Map map001 = (Map)list001.get(0);
        mainprice = NumberHelper.string2Double(map001.get("mainprice"), 0.0D);
        pricetype = StringHelper.null2String(map001.get("pricetype"));
        needtype = StringHelper.null2String(map001.get("needtype"));

        zfy = nw * mainprice;
        System.out.println("----------------------- mainprice :" + mainprice);
        System.out.println("----------------------- nw :" + nw);
        System.out.println("----------------------- zfy :" + zfy);

        jdbcDao.update("update uf_lo_loadplan set fare = '" + zfy + "' where where requestid = '" + requestid + "'");
      }

      System.out.println("----------------------- sjnwc :" + sjnwc);
      List list006 = jdbcDao.executeSqlForList("select shiptoaddress,deliverdnum from  uf_lo_loaddetail where requestid = '" + requestid + "'");
      for (int i = 0; i < list006.size(); i++) {
        Map mapdetail06 = (Map)list006.get(i);
        if ((i >= 1) && (i == list006.size() - 1))
          jdbcDao.update(" update uf_lo_loaddetail set deliverdnum = ((select sum(deliverdnum) deliverdnum from  uf_lo_loaddetail where requestid = '" + requestid + "')-" + nw + ") where requestid = '" + requestid + "'");
        else if (i == 0) {
          jdbcDao.update("update uf_lo_loaddetail set deliverdnum = '" + nw + "' where requestid = '" + requestid + "'");
        }
      }

      List list002 = jdbcDao.executeSqlForList("select shiptoaddress,deliverdnum from  uf_lo_loaddetail where requestid = '" + requestid + "'");
      for (int i = 0; i < list002.size(); i++) {
        Map mapdetail = (Map)list002.get(i);
        shiptoaddress = StringHelper.null2String(mapdetail.get("shiptoaddress"));
        deliverdnum = NumberHelper.string2Double(mapdetail.get("deliverdnum"), 0.0D);

        List list003 = jdbcDao.executeSqlForList("select distance from uf_lo_city where postcode = '" + shiptoaddress + "'");
        for (int j = 0; j < list003.size(); j++) {
          Map map003 = (Map)list003.get(0);
          distance = NumberHelper.string2Double(map003.get("distance"), 0.0D);
        }
        System.out.println("----------------------- distance :" + distance);

        mxlj += distance * deliverdnum;
        System.out.println("----------------------- mxlj :" + mxlj);
      }

      System.out.println("----------------------- mxlj :" + mxlj);
      List list004 = jdbcDao.executeSqlForList(" select shiptoaddress,deliverdnum from  uf_lo_loaddetail where requestid = '" + requestid + "'");
      for (int i = 0; i < list004.size(); i++) {
        Map mapdetail2 = (Map)list004.get(i);
        shiptoaddress = StringHelper.null2String(mapdetail2.get("shiptoaddress"));
        deliverdnum = NumberHelper.string2Double(mapdetail2.get("deliverdnum"), 0.0D);

        List list005 = jdbcDao.executeSqlForList("select distance from uf_lo_city where postcode = '" + shiptoaddress + "'");
        for (int j = 0; j < list005.size(); j++) {
          Map map005 = (Map)list005.get(0);
          distance = NumberHelper.string2Double(map005.get("distance"), 0.0D);
        }

        fyft = zfy / mxlj * (distance * deliverdnum);
        System.out.println("----------------------- fyft :" + fyft);
        jdbcDao.update("update uf_lo_loaddetail set divvyfee = '" + fyft + "' where requestid = '" + requestid + "'");
      }
      System.out.println("***********************装卸运载量回写及相关价格计算结束*********************");
    }
    return ret;
  }

  public String getLoadingNumber(String plate)
  {
    BaseJdbcDao jdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String ret = "";
    double nw = 0.0D;
    double grosswt = 0.0D;
    Uf_lo_budgetService bs = new Uf_lo_budgetService();
    String requestid = bs.getRequestidByLadingno(plate);

    List list = jdbcDao.executeSqlForList("select nw,grosswt from uf_lo_pondrecord c where c.ladingno = '" + plate + "'");
    if (list.size() > 0) {
      Map map = (Map)list.get(0);
      nw = NumberHelper.string2Double(map.get("nw"), 0.0D);
      grosswt = NumberHelper.string2Double(map.get("grosswt"), 0.0D);
    }
    System.out.println("------------------------装卸 过磅后数量回写 开始----------------------------");
    System.out.println("---------------------------------------- nw = " + nw);
    System.out.println("---------------------------------------- requestid = " + requestid);
    List list001 = jdbcDao.executeSqlForList("select id,shiptoaddress,deliverdnum,runningno,leftloadnum from  uf_lo_loaddetail where requestid = '" + requestid + "'" + 
      " and runningno in(select a.runningno from uf_lo_ladingdetail a left join uf_lo_ladingmain b on a.requestid=b.requestid where b.ladingno='" + plate + "')");

    List ls01 = jdbcDao.executeSqlForList("select sum(deliverdnum) deliverdnum from  uf_lo_loaddetail where requestid = '" + requestid + "'" + 
      " and runningno in(select a.runningno from uf_lo_ladingdetail a left join uf_lo_ladingmain b on a.requestid=b.requestid where b.ladingno='" + plate + "')");
    double deliverdnumz = 0.0D;
    if (ls01.size() > 0) {
      Map m01 = (Map)ls01.get(0);
      deliverdnumz = NumberHelper.string2Double(m01.get("deliverdnum"), 0.0D);
    }
    int leftnum = (int)nw;
    for (int i = 0; i < list001.size(); i++) {
      Map mapdetail = (Map)list001.get(i);
      String id = StringHelper.null2String(mapdetail.get("id"));
      String runningno = StringHelper.null2String(mapdetail.get("runningno"));
      double deliverdnum = NumberHelper.string2Double(mapdetail.get("deliverdnum"), 0.0D);
      double leftloadnum = NumberHelper.string2Double(mapdetail.get("leftloadnum"), 0.0D);

      System.out.println("---------------------------------------- id = " + id);
      System.out.println("---------------------------------------- 计划运载量 = " + deliverdnum);
      String materialtype = "";
      String bulkflag = "";
      List list003 = jdbcDao.executeSqlForList("select materialtype from uf_lo_delivery where runningno = '" + runningno + "'");
      if (list003.size() > 0) {
        Map m01 = (Map)list003.get(0);
        materialtype = StringHelper.null2String(m01.get("materialtype"));
      }
      List list002 = jdbcDao.executeSqlForList("select bulkflag from uf_lo_purchase  where runningno = '" + runningno + "'");
      if (list002.size() > 0) {
        Map m02 = (Map)list002.get(0);
        bulkflag = StringHelper.null2String(m02.get("bulkflag"));
      }
      System.out.println("---------------------------------------- materialtype = " + materialtype);
      System.out.println("---------------------------------------- bulkflag = " + bulkflag);
      double bl = 0.0D;
      if (("Z01".equals(materialtype)) || (!"".equals(bulkflag))) {
        bl = deliverdnum / deliverdnumz;
        System.out.println("---------------------------------------- 总运载量 = " + deliverdnumz);
        System.out.println("---------------------------------------- 计划运载量 /总运载量 = " + bl);
        int zl = (int)(nw * bl);
        System.out.println("---------------------------------------- zl = " + (int)(nw * bl));
        if (i == list001.size() - 1) {
          zl = leftnum;
        }

        jdbcDao.update("update uf_lo_loaddetail set deliverdnum = " + zl + " where id = '" + id + "'");
        leftnum -= zl;

        if (nw * bl > leftloadnum) {
          jdbcDao.update("update uf_lo_loaddetail set leftloadnum =deliverdnum-leftloadnum where id = '" + id + "'");
        }
      }

      if (!"".equals(Double.valueOf(nw))) {
        bl = deliverdnum / deliverdnumz;
        int cz = (int)(nw * bl);
        jdbcDao.update("update uf_lo_loaddetail set pointsize = " + cz + " where id = '" + id + "'");
      }

      System.out.println("------------------------装卸 过磅后数量回写 结束----------------------------");
    }
    return ret;
  }

  public boolean getFranchiseScope(String plate, String weight)
  {
    System.out.println("------------------------ 过磅允差范围判断 开始 ------------------------");
    boolean ret = true;
    BaseJdbcDao jdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    String runningno = "";
    String materialtype = "";
    String overmark = "";
    double deliverylimit = 0.0D;
    double quantity = 0.0D;
    double xienum = 0.0D;

    double ycsxz = 0.0D;
    double sxzsl = 0.0D;
    double zxzsl = 0.0D;
    String sql = "select runningno from uf_lo_ladingdetail  where requestid = (select requestid from uf_lo_ladingmain where ladingno = '" + plate + "')";
    List list = jdbcDao.executeSqlForList(sql);
    for (int i = 0; i < list.size(); i++) {
      Map map = (Map)list.get(i);
      runningno = StringHelper.null2String(map.get("runningno"));

      List list001 = jdbcDao.executeSqlForList("select deliverylimit,overmark,materialtype,quantity,xienum from uf_lo_delivery where runningno = '" + runningno + "'");
      if (list001.size() > 0) {
        Map map001 = (Map)list001.get(0);
        materialtype = StringHelper.null2String(map001.get("materialtype"));
        overmark = StringHelper.null2String(map001.get("overmark"));
        deliverylimit = NumberHelper.string2Double(map001.get("deliverylimit"), 0.0D);
        quantity = NumberHelper.string2Double(map001.get("quantity"), 0.0D);
        xienum = NumberHelper.string2Double(map001.get("xienum"), 0.0D);
        System.out.println("--------------------------- 包装类别 :" + materialtype);
        System.out.println("--------------------------- 允许未限制的过量交货 :" + overmark);
        System.out.println("--------------------------- 过量交货限度 :" + deliverylimit);
        System.out.println("--------------------------- 实际交货数量 :" + quantity);
        System.out.println("--------------------------- 已装卸数 :" + xienum);
        System.out.println("------------------------------------------------------");
        if (("Z01".equals(materialtype)) && ("".equals(overmark))) {
          ycsxz = quantity + quantity * deliverylimit / 100.0D;
          sxzsl += ycsxz;
          zxzsl += xienum;
        }
      } else {
        List list002 = jdbcDao.executeSqlForList("select deliverylimit,overmark,bulkflag,quantity,xienum from uf_lo_purchase where runningno = '" + runningno + "'");
        if (list002.size() > 0) {
          Map map002 = (Map)list002.get(0);
          materialtype = StringHelper.null2String(map002.get("bulkflag"));
          overmark = StringHelper.null2String(map002.get("overmark"));
          deliverylimit = NumberHelper.string2Double(map002.get("deliverylimit"), 0.0D);
          quantity = NumberHelper.string2Double(map002.get("quantity"), 0.0D);
          xienum = NumberHelper.string2Double(map002.get("xienum"), 0.0D);
          System.out.println("--------------------------- 包装类别 :" + materialtype);
          System.out.println("--------------------------- 允许未限制的过量交货 :" + overmark);
          System.out.println("--------------------------- 过量交货限度 :" + deliverylimit);
          System.out.println("--------------------------- 实际交货数量 :" + quantity);
          System.out.println("--------------------------- 已装卸数 :" + xienum);
          System.out.println("------------------------------------------------------");
          if ((!"".equals(materialtype)) && ("".equals(overmark))) {
            ycsxz = quantity + quantity * deliverylimit / 100.0D;
            sxzsl += ycsxz;
            zxzsl += xienum;
          }
        }
      }
    }
    double nw = 0.0D;
    double tare = 0.0D;

    if (sxzsl > 0.0D)
    {
      Uf_lo_budgetService bs = new Uf_lo_budgetService();
      String planrequestid = bs.getRequestidByLadingno(plate);
      double deliverdnum = 0.0D;
      List lis = jdbcDao.executeSqlForList("select sum(deliverdnum) deliverdnum  from uf_lo_loaddetail where requestid = '" + planrequestid + "'" + 
        " and runningno in(select a.runningno from uf_lo_ladingdetail a left join uf_lo_ladingmain b on a.requestid=b.requestid where b.ladingno = '" + plate + "')");
      if (lis.size() > 0) {
        Map map = (Map)lis.get(0);
        deliverdnum = NumberHelper.string2Double(map.get("deliverdnum"), 0.0D);
      }

      List list003 = jdbcDao.executeSqlForList("select nw,tare from uf_lo_pondrecord where ladingno = '" + plate + "'");
      if (list003.size() > 0) {
        Map map003 = (Map)list003.get(0);

        tare = NumberHelper.string2Double(map003.get("tare"), 0.0D);
      }
      nw = NumberHelper.string2Double(weight, 0.0D) - tare;
      System.out.println("------------------------- sxzsl = " + sxzsl);
      System.out.println("------------------------- zxzsl = " + zxzsl);
      System.out.println("------------------------- nw = " + nw);
      System.out.println("------------------------- tare = " + tare);
      nw = Math.abs(nw);
      double zxzsls = 0.0D;

      zxzsls = zxzsl + nw - deliverdnum;
      if (zxzsls < 0.0D) {
        zxzsls = Math.abs(zxzsls);
      }
      System.out.println("------------------------- zxzsls = " + zxzsls);
      if (zxzsls > sxzsl) {
        ret = false;
      }
    }
    System.out.println("------------------------ 过磅允差范围判断 结束 ------------------------");
    return ret;
  }
  public String comweight(String weight,String plate,String year)
  {
	  boolean flag = true;
	  System.out.println("--------------相同公司代码、相同固废名称的年度固废【剩余可出货数量】开始---------------");
	  String sqlString="";
	  String comcode="";
	  String gfname="";
	  Double surplusnum=0.00d;
	  String msg="";
	  BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	  sqlString="select a.gfname,(select solidname from uf_oa_solidwaste  where requestid=a.gfname) as solidname,(select requestid from getcompanyview where objno=c.company)as comid,c.company from uf_lo_passdetail a inner join uf_lo_loaddetail b on a.runningno=b.runningno left join uf_lo_loadplan c on b.requestid=c.requestid  where b.pondno='"+plate+"' and 0=(select isdelete from requestbase where id=b.requestid) and 0=(select isdelete from requestbase where id=a.requestid)";
	  List lists=baseJdbcDao.executeSqlForList(sqlString);
	  if(lists.size()>0)
	  {
		  for (int i = 0; i < lists.size(); i++) {
			Map map = (Map)lists.get(i);
			  comcode = StringHelper.null2String(map.get("comid"));
			  gfname = StringHelper.null2String(map.get("gfname"));
			  String solidname = StringHelper.null2String(map.get("solidname"));
			  String company = StringHelper.null2String(map.get("company"));
			  sqlString="select surplusnum from uf_oa_gfshipbyyear where comcode='"+comcode+"' and gfname='"+gfname+"' and shipyear='"+year+"' and 0=(select isdelete from formbase where id=requestid)";

			  surplusnum=0.00d;
			  List list = baseJdbcDao.executeSqlForList(sqlString);
			  if(list.size()>0)
			  {
				  Map zMap = (Map)list.get(0);
				  surplusnum = NumberHelper.string2Double(zMap.get("surplusnum"), 0.0D);
				  System.out.println("过磅数量："+weight);
				  System.out.println("剩余可出货数量："+surplusnum);
			  }
			  Double weightd=NumberHelper.string2Double(weight, 0.0D);
			  if(weightd>surplusnum)
			  {
				  flag=false;

				  msg=msg+"公司代码"+company+"固废名称"+solidname;
				  break;
			  }
		}
	  }

	  System.out.println("--------------相同公司代码、相同固废名称的年度固废【剩余可出货数量】结束---------------");
	  return msg;
  }
  public boolean getyzd(String plate, String weight)
  {
    boolean ret = true;
    System.out.println("------------------------ 易制毒日期范围判断 开始 ------------------------");
    BaseJdbcDao jdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    List zlt = jdbcDao.executeSqlForList("select c.tare from uf_lo_pondrecord c where c.ladingno = '" + plate + "'");
    double tare = 0.0D;
    if (zlt.size() > 0) {
      Map zMap = (Map)zlt.get(0);
      tare = NumberHelper.string2Double(zMap.get("tare"), 0.0D);
    }

    double nw = NumberHelper.string2Double(weight, 0.0D) - tare;

    Date currentTime = new Date();
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String dateString = formatter.format(currentTime);
    dateString = StringHelper.replaceString(dateString, "-", "");
    System.out.println("--------------------- dateString : " + dateString);

    List ls = jdbcDao.executeSqlForList("select requestid,shipout from uf_lo_ladingmain where ladingno = '" + plate + "'");
    String requestid = "";
    String shipout = "";
    if (ls.size() > 0) {
      Map m = (Map)ls.get(0);
      requestid = StringHelper.null2String(m.get("requestid"));
      shipout = StringHelper.null2String(m.get("shipout"));
    }
    List list = jdbcDao.executeSqlForList("select runningno from uf_lo_ladingdetail where requestid ='" + requestid + "'");
    for (int i = 0; i < list.size(); i++) {
      Map map = (Map)list.get(i);
      String runningno = StringHelper.null2String(map.get("runningno"));
      String purchcode = "";
      String transportno = "";
      String transexpiry = "";
      String transdeadline = "";
      String purchexpiry = "";
      String purchdeadline = "";
      double bangnum = 0.0D;
      double purchasenum = 0.0D;
      double transportnum = 0.0D;

      double bangnums = 0.0D;

      List list01 = jdbcDao.executeSqlForList("select purchcode,transportno,transexpiry,transdeadline,purchexpiry,purchdeadline,bangnum,purchasenum,transportnum from uf_lo_delivery where runningno ='" + runningno + "'");
      if (list01.size() > 0) {
        Map map01 = (Map)list01.get(0);
        purchcode = StringHelper.null2String(map01.get("purchcode"));
        transportno = StringHelper.null2String(map01.get("transportno"));
        transexpiry = StringHelper.null2String(map01.get("transexpiry"));
        transdeadline = StringHelper.null2String(map01.get("transdeadline"));
        purchexpiry = StringHelper.null2String(map01.get("purchexpiry"));
        purchdeadline = StringHelper.null2String(map01.get("purchdeadline"));
        bangnum = NumberHelper.string2Double(map01.get("bangnum"), 0.0D);
        purchasenum = NumberHelper.string2Double(map01.get("purchasenum"), 0.0D);
        transportnum = NumberHelper.string2Double(map01.get("transportnum"), 0.0D);

        List list002 = jdbcDao.executeSqlForList("select sum(bangnum) bangnum from uf_lo_delivery where purchcode = '" + purchcode + "'");
        if (list002.size() > 0) {
          Map m002 = (Map)list002.get(0);
          bangnums = NumberHelper.string2Double(m002.get("bangnum"), 0.0D);
        }

        purchexpiry = StringHelper.replaceString(purchexpiry, "-", "");
        purchdeadline = StringHelper.replaceString(purchdeadline, "-", "");
        transexpiry = StringHelper.replaceString(transexpiry, "-", "");
        transdeadline = StringHelper.replaceString(transdeadline, "-", "");
        System.out.println("--------------------- purchexpiry : " + purchexpiry);
        System.out.println("--------------------- purchdeadline : " + purchdeadline);
        System.out.println("--------------------- transexpiry : " + transexpiry);
        System.out.println("--------------------- transdeadline : " + transdeadline);
        if (!"".equals(purchcode)) {
          if ("40285a904a17fd75014a18e6bd85267c".equals(shipout)) {
            if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(purchexpiry)) && 
              (NumberHelper.string2Int(purchdeadline) >= NumberHelper.string2Int(dateString))) {
              if (nw > purchasenum - bangnums)
                ret = false;
              else
                ret = true;
            }
            else
              ret = false;
          }
          else if ("40285a904a17fd75014a18e6bd85267b".equals(shipout)) {
            if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(purchexpiry)) && 
              (NumberHelper.string2Int(purchdeadline) >= NumberHelper.string2Int(dateString))) {
              if (!"".equals(transportno)) {
                if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(transexpiry)) && 
                  (NumberHelper.string2Int(transdeadline) >= NumberHelper.string2Int(dateString))) {
                  if (nw > transportnum - bangnum)
                    ret = false;
                  else
                    ret = true;
                }
                else
                  ret = false;
              }
              else
                ret = true;
            }
            else
              ret = false;
          }
        }
        else
          ret = true;
      }
      else
      {
        List list02 = jdbcDao.executeSqlForList("select permitcode,transportno,transexpiry,transdeadline,purchexpiry,purchdeadline,bangnum,purchasenum,transportnum from uf_lo_purchase where runningno ='" + runningno + "'");
        if (list02.size() > 0) {
          Map map02 = (Map)list02.get(0);
          purchcode = StringHelper.null2String(map02.get("permitcode"));
          transportno = StringHelper.null2String(map02.get("transportno"));
          transexpiry = StringHelper.null2String(map02.get("transexpiry"));
          transdeadline = StringHelper.null2String(map02.get("transdeadline"));
          purchexpiry = StringHelper.null2String(map02.get("purchexpiry"));
          purchdeadline = StringHelper.null2String(map02.get("purchdeadline"));
          bangnum = NumberHelper.string2Double(map02.get("bangnum"), 0.0D);
          purchasenum = NumberHelper.string2Double(map02.get("purchasenum"), 0.0D);
          transportnum = NumberHelper.string2Double(map02.get("transportnum"), 0.0D);

          List list003 = jdbcDao.executeSqlForList("select sum(bangnum) bangnum from uf_lo_purchase where permitcode = '" + purchcode + "'");
          if (list003.size() > 0) {
            Map m003 = (Map)list003.get(0);
            bangnums = NumberHelper.string2Double(m003.get("bangnum"), 0.0D);
          }

          purchexpiry = StringHelper.replaceString(purchexpiry, "-", "");
          purchdeadline = StringHelper.replaceString(purchdeadline, "-", "");
          transexpiry = StringHelper.replaceString(transexpiry, "-", "");
          transdeadline = StringHelper.replaceString(transdeadline, "-", "");
          if (!"".equals(purchcode)) {
            if ("40285a904a17fd75014a18e6bd85267c".equals(shipout)) {
              if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(purchexpiry)) && 
                (NumberHelper.string2Int(purchdeadline) >= NumberHelper.string2Int(dateString))) {
                if (nw > purchasenum - bangnums)
                  ret = false;
                else
                  ret = true;
              }
              else
                ret = false;
            }
            else if ("40285a904a17fd75014a18e6bd85267b".equals(shipout)) {
              if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(purchexpiry)) && 
                (NumberHelper.string2Int(purchdeadline) >= NumberHelper.string2Int(dateString))) {
                if (!"".equals(transportno)) {
                  if ((NumberHelper.string2Int(dateString) >= NumberHelper.string2Int(transexpiry)) && 
                    (NumberHelper.string2Int(transdeadline) >= NumberHelper.string2Int(dateString))) {
                    if (nw > transportnum - bangnum)
                      ret = false;
                    else
                      ret = true;
                  }
                  else
                    ret = false;
                }
                else
                  ret = true;
              }
              else
                ret = false;
            }
          }
          else {
            ret = true;
          }
        }
      }
    }

    System.out.println("------------------------ 易制毒日期范围判断 结束 ------------------------");
    return ret;
  }
}