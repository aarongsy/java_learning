package com.eweaver.app.dccm.dmlo.weigh.service;


import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_provecastlog;
import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_provedoc;
import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_shipprove;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;

import com.eweaver.base.security.util.PermissionTool;
import com.eweaver.base.util.DateHelper;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.workflow.form.model.FormBase;
import com.eweaver.workflow.form.service.FormBaseService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Uf_dmlo_proveService
{
	  public int createProveByPlan(String ladingno, String nw)
	  {
	    int ret = 0;
	    Uf_dmlo_provedoc provedoc = new Uf_dmlo_provedoc();
	    List shiplist = new ArrayList();

	    DataService ds = new DataService();
	    String sql1 = "select m.*, (select uf_lo_consolidator.conname from uf_lo_consolidator where uf_lo_consolidator.requestid = m.conname) mconname  from uf_lo_ladingmain m where m.ladingno = '" + 
	      ladingno + "'";
	    List list1 = ds.getValues(sql1);
	    if ((list1 != null) && (list1.size() > 0)) {
	      Map pMap = (Map)list1.get(0);

	      String remark = "";
	      List list005 = ds.getValues("select u.remark from uf_lo_dgcardetail t inner join uf_lo_dgcar u on t.requestid=u.requestid  where t.id in(select cardetailid from uf_lo_loaddetail  where pondno='" + ladingno + "')");
	      for (int i = 0; i < list005.size(); i++) {
	        Map mp = (Map)list005.get(i);

	        String _remark = StringHelper.null2String(mp.get("remark"));
	        if (!StringHelper.isEmpty(_remark)) {
	          if (StringHelper.isEmpty(remark)) {
	            remark = _remark;
	          }
	          else if (remark.indexOf(_remark) <= -1)
	          {
	            remark = remark + "," + _remark;
	          }
	        }
	      }

	      provedoc.setRemarks(remark);

	      provedoc.setCompanyname(StringHelper.null2String(pMap.get("comname")));

	      provedoc.setBillno("123");

	      provedoc.setLoadno(StringHelper.null2String(pMap.get("loadingno")));

	      provedoc.setMatchno(StringHelper.null2String(pMap.get("ladingno")));

	      if ("40285a904a17fd75014a18e6bd85267b".equals(StringHelper.null2String(pMap.get("shipout")))) {
	        provedoc.setBilltype("402864d14955f9990149560956f50005");
	        provedoc.setBillno(StringHelper.null2String(pMap.get("company")) + "C" + NumberHelper.getSequenceNo(
	          "40285a8d4b1102a3014b1552114c0ff3", 8));
	      } else if ("40285a904a17fd75014a18e6bd85267c".equals(StringHelper.null2String(pMap.get("shipout")))) {
	        provedoc.setBilltype("402864d14955f9990149560956f60006");
	        provedoc.setBillno(StringHelper.null2String(pMap.get("company")) + "Z" + NumberHelper.getSequenceNo(
	          "40285a8d4b1102a3014b1552114c0ff3", 8));
	      }

	      provedoc.setState("402864d14955f9990149560a733d000a");

	      provedoc.setCompany(StringHelper.null2String(pMap.get("company")));

	      provedoc.setFactory(StringHelper.null2String(pMap.get("factory")));

	      provedoc.setSendreqtime("");

	      provedoc.setNw(nw);

	      provedoc.setTotalnum(StringHelper.null2String(pMap.get("totalnum")));

	      provedoc.setCustsign("");

	      provedoc.setSigndate("");

	      provedoc.setOntime(StringHelper.null2String(pMap.get("isontime")));

	      List ls01 = ds.getValues("select createtime from uf_lo_pandlog where ladingno = '" + StringHelper.null2String(pMap.get("ladingno")) + "' and inweight >0");
	      String intime = "";
	      if (ls01.size() > 0) {
	        Map m1 = (Map)ls01.get(0);
	        intime = StringHelper.null2String(m1.get("createtime"));
	      }
	      List ls02 = ds.getValues("select createtime from uf_lo_pandlog where ladingno = '" + StringHelper.null2String(pMap.get("ladingno")) + "' and outweight >0");
	      String outtime = "";
	      if (ls02.size() > 0) {
	        Map m2 = (Map)ls02.get(0);
	        outtime = StringHelper.null2String(m2.get("createtime"));
	      }

	      provedoc.setFistin(intime);

	      provedoc.setLastout(outtime);

	      provedoc.setSupplyname(StringHelper.null2String(pMap.get("vendorname")));

	      provedoc.setConcode(StringHelper.null2String(pMap.get("concode")));

	      provedoc.setConname(StringHelper.null2String(pMap.get("mconname")));

	      provedoc.setCarno(StringHelper.null2String(pMap.get("carno")));

	      provedoc.setDrivername(StringHelper.null2String(pMap.get("drivername")));

	      provedoc.setTrailerno(StringHelper.null2String(pMap.get("trailerno")));

	      provedoc.setToteno(StringHelper.null2String(pMap.get("loanno")));

	      provedoc.setSignno(StringHelper.null2String(pMap.get("signno")));

	      provedoc.setTelephone(StringHelper.null2String(pMap.get("cellphone")));

	      provedoc.setSoldto(StringHelper.null2String(pMap.get("soldtoname")));

	      provedoc.setMainloc(StringHelper.null2String(pMap.get("descofloc")));

	      provedoc.setAddress(StringHelper.null2String(pMap.get("addressdesc")));

	      provedoc.setSendto(StringHelper.null2String(pMap.get("shiptoname")));

	      String shipout = StringHelper.null2String(pMap.get("shipout"));

	      String sql2 = "select d.*  from uf_lo_ladingdetail d where d.requestid = '" + 
	        StringHelper.null2String(pMap.get("requestid")) + "' order by runningno";

	      List list2 = ds.getValues(sql2);
	      for (int i = 0; i < list2.size(); i++) {
	        Map dMap = (Map)list2.get(i);
	        Uf_dmlo_shipprove ship = new Uf_dmlo_shipprove();

	        ship.setRowindex(StringHelper.specifiedLengthForInt(i, 3));

	        ship.setItemno(StringHelper.null2String(dMap.get("itemno")));

	        ship.setSuppliername(StringHelper.null2String(dMap.get("vendorname")));

	        ship.setPid(StringHelper.null2String(Integer.valueOf(i + 1)));

	        ship.setRunningno(StringHelper.null2String(dMap.get("runningno")));
	        System.out.println("-----------------------------Runningno : " + StringHelper.null2String(dMap.get("runningno")));
	        ship.setOrdertype(StringHelper.null2String(dMap.get("ordertype")));

	        ship.setGoodsgroup(StringHelper.null2String(dMap.get("goodsgroup")));

	        ship.setIsself(StringHelper.null2String(dMap.get("isself")));

	        ship.setMaterialno(StringHelper.null2String(dMap.get("materialno")));

	        ship.setMaterialdesc(StringHelper.null2String(dMap.get("materialdesc")));

	        ship.setDeliverdnum(StringHelper.null2String(dMap.get("deliverdnum")));

	        ship.setYetloadnum(StringHelper.null2String(dMap.get("yetloadnum")));

	        ship.setLeftloadnum(StringHelper.null2String(dMap.get("leftloadnum")));

	        ship.setNotdelinum(StringHelper.null2String(dMap.get("notdelinum")));

	        ship.setNotloadnum(StringHelper.null2String(dMap.get("notloadnum")));

	        ship.setSalesunit(StringHelper.null2String(dMap.get("salesunit")));

	        ship.setDivvyfee(StringHelper.null2String(dMap.get("divvyfee")));

	        ship.setDivvyexpfee(StringHelper.null2String(dMap.get("divvyexpfee")));

	        ship.setExcept(StringHelper.null2String(dMap.get("except")));

	        ship.setOrderno(StringHelper.null2String(dMap.get("orderno")));

	        ship.setCustname(StringHelper.null2String(dMap.get("shiptoname")));

	        ship.setPackcode(StringHelper.null2String(dMap.get("packcode")));

	        ship.setPacktype(StringHelper.null2String(dMap.get("packtype")));

	        ship.setRemark(StringHelper.null2String(dMap.get("remark")));
	        shiplist.add(ship);
	      }

	      String requestid = StringHelper.null2String(pMap.get("requestid"));

	      ret += createProve(provedoc, shiplist, shipout, requestid);
	    }
	    if ((ret > 0) && (nw.length() > 0)) {
	      try {
	        upProve(ladingno);
	      } catch (Exception e) {
	        System.out.println(" 上抛重量证明单错误提示E： " + e);
	      }
	    }
	    return ret;
	  }
	  public int createProve(Uf_dmlo_provedoc provedoc, List<Uf_dmlo_shipprove> shiplist, String shipout, String requestid)
	  {
	    int ret = 0;
	    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

	    String userId = BaseContext.getRemoteUser().getId();

	    StringBuffer buffer = new StringBuffer(4096);

	    buffer.append("insert into uf_dmlo_provedoc");
	    buffer.append("(id,requestid,billno,loadno,matchno,billtype,state,printman,printnum,factory,inweight,outweight,inweight2,outweight2,nw,totalnum,custsign,ontime,fistin,lastout,supplyname,concode,conname,carno,drivername,trailerno,toteno,signno,telephone,soldto,mainloc,address,sendto,printtime,reqdate,lotnum,remarks,company,companyname,sendreqtime,signdate) values");

	    buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
	    buffer.append("'").append("$ewrequestid$").append("',");

	    buffer.append("'").append(StringHelper.null2String(provedoc.getBillno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getLoadno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getMatchno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getBilltype())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getState())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getPrintman())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getPrintnum())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getFactory())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getInweight())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getOutweight())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getInweight2())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getOutweight2())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getNw())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getTotalnum())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getCustsign())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getOntime())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getFistin())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getLastout())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSupplyname())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getConcode())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getConname())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getCarno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getDrivername())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getTrailerno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getToteno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSignno())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getTelephone())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSoldto())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getMainloc())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getAddress())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSendto())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getPrinttime())).append("',");
	    buffer.append("to_char(sysdate,'yyyy-mm-dd'),");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getLotnum())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getRemarks())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getCompany())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getCompanyname())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSendreqtime())).append("',");
	    buffer.append("'").append(StringHelper.null2String(provedoc.getSigndate())).append("')");

	    FormBase formBase = new FormBase();
	    String categoryid = "40285a8d57f51b170157fe78f88064dc";

	    formBase.setCreatedate(DateHelper.getCurrentDate());
	    formBase.setCreatetime(DateHelper.getCurrentTime());
	    formBase.setCreator(StringHelper.null2String(userId));
	    formBase.setCategoryid(categoryid);
	    formBase.setIsdelete(Integer.valueOf(0));
	    FormBaseService formBaseService = (FormBaseService)
	      BaseContext.getBean("formbaseService");
	    formBaseService.createFormBase(formBase);
	    String insertSql = buffer.toString();
	    insertSql = insertSql.replace("$ewrequestid$", formBase.getId());
	    ret += baseJdbc.update(insertSql);
	    PermissionTool permissionTool = new PermissionTool();
	    permissionTool.addPermission(categoryid, formBase.getId(), "uf_dmlo_provedoc");

	    String lsh = "";
	    for (int i = 0; i < shiplist.size(); i++)
	    {
	      String ddbh = "";
	      String khddh1 = "";
	      List lis = baseJdbc.executeSqlForList("select saleorder,customerno from uf_dmlo_delivery where runningno = '" + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()) + "'");
	      if (lis.size() > 0) {
	        Map m = (Map)lis.get(0);
	        ddbh = StringHelper.null2String(m.get("saleorder"));
	        khddh1 = StringHelper.null2String(m.get("customerno"));//客户订单
	      } else {
	        lis = baseJdbc.executeSqlForList("select purchaseorder from uf_lo_purchase where runningno = '" + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()) + "'");
	        if (lis.size() > 0) {
	          Map m = (Map)lis.get(0);
	          ddbh = StringHelper.null2String(m.get("purchaseorder"));
	        }
	      }
	      lsh = StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(0)).getRunningno());

	      System.out.println("-----------------------------Runningno : " + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()));
	      buffer = new StringBuffer(4096);

	      buffer.append("insert into uf_lo_shipprove");
	      buffer.append("(id,requestid,rowindex,itemno,suppliername,pid,runningno,ordertype,goodsgroup,isself,materialno,materialdesc,deliverdnum,yetloadnum,leftloadnum,notdelinum,notloadnum,salesunit,divvyfee,divvyexpfee,except,orderno,custname,packcode,packtype,remark,jydxsddh,jydkhddh) values");

	      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
	      buffer.append("'").append(formBase.getId()).append("',");
	      buffer.append("'").append(((Uf_dmlo_shipprove)shiplist.get(i)).getRowindex())
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getItemno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getSuppliername()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPid())).append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getOrdertype()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getGoodsgroup()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getIsself())).append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getMaterialno()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getMaterialdesc()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDeliverdnum()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getYetloadnum()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getLeftloadnum()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getNotdelinum()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getNotloadnum()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getSalesunit()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDivvyfee()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDivvyexpfee()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getExcept())).append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getOrderno()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getCustname()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPackcode()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPacktype()))
	        .append("',");
	      buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRemark())).append("',");
	      buffer.append("'").append(StringHelper.null2String(ddbh)).append("','" + khddh1 + "')");
	      ret += baseJdbc.update(buffer.toString());
	    }

	    String telephone = "";
	    List xuqiuList = baseJdbc.executeSqlForList("select cardetailid from uf_lo_loaddetail where runningno='" + lsh + "' and requestid in(select b.requestid from uf_lo_ladingmain a,uf_lo_loadplan b where a.requestid='" + requestid + "' and a.loadingno=b.reqno)");
	    if ((xuqiuList != null) && (xuqiuList.size() > 0)) {
	      Map xuqiuMap = (Map)xuqiuList.get(0);
	      String xuqiuid = StringHelper.null2String(xuqiuMap.get("cardetailid"));
	      List dgcardetaillist = baseJdbc.executeSqlForList("select telephone from uf_lo_dgcar where requestid in(select requestid from uf_lo_dgcardetail where id='" + xuqiuid + "')");
	      if ((dgcardetaillist != null) && (dgcardetaillist.size() > 0)) {
	        telephone = StringHelper.null2String(((Map)dgcardetaillist.get(0)).get("telephone"));
	      }
	    }
	    if (StringHelper.isEmpty(telephone)) {
	      List lis3 = baseJdbc.executeSqlForList("select telephone from uf_lo_delivery where runningno = '" + lsh + "'");
	      if (lis3.size() > 0) {
	        Map map = (Map)lis3.get(0);
	        telephone = StringHelper.null2String(map.get("telephone"));
	      }
	    }
	    baseJdbc.update("update uf_lo_provedoc set telephone = '" + telephone + "' where requestid = '" + formBase.getId() + "'");

	    List ps = baseJdbc.executeSqlForList("select * from  uf_lo_shipprove where packcode is null and requestid = '" + formBase.getId() + "'");
	    if ((ps.size() > 0) && (NumberHelper.string2Float(provedoc.getNw()) > 0.0F)) {
	      weightApportion(formBase.getId());
	    }

	    System.out.println("----------------------- shipout = " + shipout);

	    if ("40285a904a17fd75014a18e6bd85267b".equals(shipout)) {
	      BaseJdbcDao jdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	      IDGernerator idGernerator = new IDGernerator();

	      System.out.println("---------------------重量证明单生成开始----------------------");
	      buffer = new StringBuffer(4096);
	      buffer.append("insert into uf_dmlo_provedoc");
	      buffer.append("(id,requestid,billno,loadno,matchno,billtype,state,printman,printnum,factory,inweight,outweight,inweight2,outweight2,nw,totalnum,custsign,ontime,fistin,lastout,supplyname,concode,conname,carno,drivername,trailerno,toteno,signno,telephone,soldto,mainloc,address,sendto,printtime,reqdate,lotnum,remarks,company,companyname,sendreqtime,signdate) values");

	      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
	      buffer.append("'").append("$ewrequestid$").append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getBillno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getLoadno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getMatchno())).append("',");
	      buffer.append("'").append(StringHelper.null2String("402864d14955f9990149560956f60006")).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getState())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getPrintman())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getPrintnum())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getFactory())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getInweight())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getOutweight())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getInweight2())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getOutweight2())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getNw())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getTotalnum())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getCustsign())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getOntime())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getFistin())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getLastout())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSupplyname())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getConcode())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getConname())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getCarno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getDrivername())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getTrailerno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getToteno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSignno())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getTelephone())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSoldto())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getMainloc())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getAddress())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSendto())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getPrinttime())).append("',");
	      buffer.append("to_char(sysdate,'yyyy-mm-dd'),");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getLotnum())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getRemarks())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getCompany())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getCompanyname())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSendreqtime())).append("',");
	      buffer.append("'").append(StringHelper.null2String(provedoc.getSigndate())).append("')");

	      String userIds = BaseContext.getRemoteUser().getId();

	      FormBase formBase1 = new FormBase();
	      String categoryid1 = "402864d14955f99901495670edda00b8";

	      formBase1.setCreatedate(DateHelper.getCurrentDate());
	      formBase1.setCreatetime(DateHelper.getCurrentTime());
	      formBase1.setCreator(StringHelper.null2String(userIds));
	      formBase1.setCategoryid(categoryid1);
	      formBase1.setIsdelete(Integer.valueOf(0));
	      FormBaseService formBaseService1 = (FormBaseService)
	        BaseContext.getBean("formbaseService");
	      formBaseService1.createFormBase(formBase1);
	      String insertSql1 = buffer.toString();
	      insertSql1 = insertSql1.replace("$ewrequestid$", formBase1.getId());
	      ret += jdbcDao.update(insertSql1);
	      PermissionTool permissionTool1 = new PermissionTool();
	      permissionTool1.addPermission(categoryid1, formBase1.getId(), 
	        "uf_dmlo_provedoc");

	      for (int i = 0; i < shiplist.size(); i++)
	      {
	        String ddbh = "";
	        String khddh = "";
	        List lis = jdbcDao.executeSqlForList("select salesdocno,customerno from uf_lo_delivery where runningno = '" + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()) + "'");
	        if (lis.size() > 0) {
	          Map m = (Map)lis.get(0);
	          ddbh = StringHelper.null2String(m.get("salesdocno"));
	          khddh = StringHelper.null2String(m.get("customerno"));
	        } else {
	          lis = baseJdbc.executeSqlForList("select purchaseorder from uf_lo_purchase where runningno = '" + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()) + "'");
	          if (lis.size() > 0) {
	            Map m = (Map)lis.get(0);
	            ddbh = StringHelper.null2String(m.get("purchaseorder"));
	          }
	        }

	        System.out.println("-----------------------------Runningno : " + StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno()));
	        buffer = new StringBuffer(4096);
	        buffer.append("insert into uf_lo_shipprove");
	        buffer.append("(id,requestid,rowindex,itemno,suppliername,pid,runningno,ordertype,goodsgroup,isself,materialno,materialdesc,deliverdnum,yetloadnum,leftloadnum,notdelinum,notloadnum,salesunit,divvyfee,divvyexpfee,except,orderno,custname,packcode,packtype,remark,jydkhddh,jydxsddh) values");

	        buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
	        buffer.append("'").append(formBase1.getId()).append("',");
	        buffer.append("'").append(((Uf_dmlo_shipprove)shiplist.get(i)).getRowindex()).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getItemno())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getSuppliername())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPid())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRunningno())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getOrdertype())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getGoodsgroup())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getIsself())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getMaterialno())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getMaterialdesc())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDeliverdnum())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getYetloadnum())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getLeftloadnum())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getNotdelinum())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getNotloadnum())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getSalesunit())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDivvyfee())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getDivvyexpfee())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getExcept())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getOrderno())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getCustname())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPackcode())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getPacktype())).append("',");
	        buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_shipprove)shiplist.get(i)).getRemark())).append("','" + khddh + "','" + ddbh + "')");
	        ret += jdbcDao.update(buffer.toString());
	      }

	      List pss = jdbcDao.executeSqlForList("select * from uf_lo_shipprove where packcode is null and requestid = '" + formBase1.getId() + "'");
	      if ((pss.size() > 0) && (NumberHelper.string2Float(provedoc.getNw()) > 0.0F)) {
	        weightApportion(formBase1.getId());
	      }
	      System.out.println("---------------------重量证明单生成结束----------------------");
	    }

	    return ret;
	  }

	  public int weightApportion(String requestid)
	  {
	    int ret = 0;
	    DataService ds = new DataService();
	    String id = ds.getValue("select max(id) from uf_lo_shipprove where requestid = '" + requestid + "'");
	    String sql1 = "select d.nw from uf_lo_provedoc d where d.requestid = '" + requestid + "'";
	    double total = NumberHelper.string2Double(ds.getValue(sql1), 0.0D);
	    String sql2 = "select nvl(sum(yetloadnum),0) from uf_lo_shipprove where requestid = '" + 
	      requestid + "' and id != '" + id + "'";
	    double total2 = NumberHelper.string2Double(ds.getValue(sql2), 0.0D);

	    ret = ds.executeSql("update uf_lo_shipprove set yetloadnum = '" + String.format("%.2f", new Object[] { Double.valueOf(total - total2) }) + "' where id = '" + id + "'");

	    return ret;
	  }

	  public Map<String, String> upProve(String ladingno)
	  {
	    System.out.println("------------------------- 上抛重量证明单生成开始  -------------------------");
	    System.out.println("------------------------- ladingno : " + ladingno);
	    Map retMap = new HashMap();
	    DataService ds = new DataService();

	    String sql1 = "select sp.* from v_lo_shipproveup sp  where sp.loadno = (select max(loadingno) from uf_lo_ladingmain where uf_lo_ladingmain.ladingno = '" + 
	      ladingno + "') and billtype='402864d14955f9990149560956f60006'" + 
	      " and runningno in (select runningno from uf_lo_ladingdetail where requestid in(select requestid from uf_lo_ladingmain where ladingno='" + ladingno + "'))";
	    System.out.println("------------------------- sql1 : " + sql1);
	    List list1 = ds.getValues(sql1);
	    if ((list1 != null) && (list1.size() > 0)) {
	      for (int i = 0; i < list1.size(); i++) {
	        Map map = (Map)list1.get(i);
	        Map inMap = new HashMap();

	        String jhyzl = "";
	        String zxjhsql = "select a.deliverdnum from uf_lo_loaddetail a,uf_lo_loadplan b where a.orderno='" + StringHelper.null2String(map.get("orderno")) + 
	          "' and a.orderitem='" + StringHelper.null2String(map.get("items")) + "' and a.requestid=b.requestid and b.reqno='" + StringHelper.null2String(map.get("loadno")) + "'";
	        List zxjhlist = ds.getValues(zxjhsql);
	        if ((zxjhlist != null) && (zxjhlist.size() > 0)) {
	          Map map01 = (Map)zxjhlist.get(0);
	          jhyzl = StringHelper.null2String(map01.get("deliverdnum"));
	        }
	        if ("cg".equals(StringHelper.null2String(map.get("marked"))))
	        {
	          Uf_dmlo_provecastlogService pcls = new Uf_dmlo_provecastlogService();
	          Uf_dmlo_provecastlogzService pclsz = new Uf_dmlo_provecastlogzService();
	          Uf_dmlo_provecastlog pcl = new Uf_dmlo_provecastlog();

	          pcl.setBillno(StringHelper.null2String(map.get("billno")));
	          pcl.setLoadno(StringHelper.null2String(map.get("loadno")));
	          pcl.setMarked("采购订单");
	          pcl.setOrderno(StringHelper.null2String(map.get("orderno")));
	          pcl.setItems(StringHelper.null2String(map.get("items")));
	          pcl.setStorageloc(StringHelper.null2String(map.get("storageloc")));
	          pcl.setPlant(StringHelper.null2String(map.get("plant")));

	          pcl.setYetloadnum(jhyzl);
	          pcl.setCarno(StringHelper.null2String(map.get("carno")));
	          pcl.setDeliveydate(StringHelper.null2String(map.get("deliverydate")));
	          pcl.setUnit(StringHelper.null2String(map.get("unit")));
	          pcl.setPack(StringHelper.null2String(map.get("pack")));
	          pcl.setRealnum(StringHelper.null2String(map.get("sjnum")));
	          pcl.setNw(StringHelper.null2String(map.get("nw")));

	          String factoryname = "";
	          List list01 = ds.getValues("select objname from orgunittype where id =(select factory from uf_lo_loadplan where reqno='" + StringHelper.null2String(map.get("loadno")) + "')");
	          if (list01.size() > 0) {
	            Map map01 = (Map)list01.get(0);
	            factoryname = StringHelper.null2String(map01.get("objname"));
	          }
	          pcl.setFactoryname(factoryname);

	          pcls.createLog(pcl);
	          pclsz.createLog(pcl);
	        }
	        else if ("jy".equals(StringHelper.null2String(map.get("marked"))))
	        {
	          Uf_dmlo_provecastlogService pcls = new Uf_dmlo_provecastlogService();
	          Uf_dmlo_provecastlogzService pclsz = new Uf_dmlo_provecastlogzService();
	          Uf_dmlo_provecastlog pcl = new Uf_dmlo_provecastlog();

	          pcl.setBillno(StringHelper.null2String(map.get("billno")));
	          pcl.setLoadno(StringHelper.null2String(map.get("loadno")));
	          pcl.setMarked("交运单");
	          pcl.setOrderno(StringHelper.null2String(map.get("orderno")));
	          pcl.setItems(StringHelper.null2String(map.get("items")));
	          pcl.setCarname(StringHelper.null2String(map.get("carname")));
	          pcl.setCarno(StringHelper.null2String(map.get("carno")));
	          pcl.setRealnum(StringHelper.null2String(map.get("sjnum")));
	          pcl.setDeliveydate(StringHelper.null2String(map.get("deliverydate")));
	          pcl.setUnit(StringHelper.null2String(map.get("unit")));

	          pcl.setYetloadnum(jhyzl);
	          pcl.setPack(StringHelper.null2String(map.get("pack")));
	          pcl.setNw(StringHelper.null2String(map.get("nw")));

	          String factoryname = "";
	          List list01 = ds.getValues("select objname from orgunittype where id =(select factory from uf_lo_loadplan where reqno='" + StringHelper.null2String(map.get("loadno")) + "')");
	          if (list01.size() > 0) {
	            Map map01 = (Map)list01.get(0);
	            factoryname = StringHelper.null2String(map01.get("objname"));
	          }
	          pcl.setFactoryname(factoryname);

	          pcls.createLog(pcl);
	          pclsz.createLog(pcl);
	        }
	      }
	    }

	    System.out.println("------------------------- 上抛重量证明单生成结束  -------------------------");
	    return retMap;
	  }

}