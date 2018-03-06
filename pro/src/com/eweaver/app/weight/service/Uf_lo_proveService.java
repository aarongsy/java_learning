package com.eweaver.app.weight.service;

import com.eweaver.app.sap.product.Product_Z_CCP_DELIVERY_DG;
import com.eweaver.app.sap.product.Purchase_Z_CCP_PO_DG;
import com.eweaver.app.weight.model.Uf_lo_provecastlog;
import com.eweaver.app.weight.model.Uf_lo_provedoc;
import com.eweaver.app.weight.model.Uf_lo_shipprove;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.IDGernerator;
import com.eweaver.base.security.service.acegi.EweaverUser;
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

public class Uf_lo_proveService
{
  public int createProve(Uf_lo_provedoc provedoc, List<Uf_lo_shipprove> shiplist)
  {
    int ret = 0;
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String userId = BaseContext.getRemoteUser().getId();

    StringBuffer buffer = new StringBuffer(4096);

    buffer.append("insert into uf_lo_provedoc");
    buffer.append("(id,requestid,billno,loadno,matchno,billtype,state,printman,printnum,factory,inweight,outweight,inweight2,outweight2,nw,totalnum,custsign,\tontime,fistin,lastout,supplyname,concode,conname,carno,drivername,trailerno,toteno,signno,telephone,soldto,mainloc,address,sendto,printtime,reqdate,lotnum,remarks,company,companyname,sendreqtime,signdate) values");

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
    String categoryid = "402864d14955f99901495670edda00b8";

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
    permissionTool.addPermission(categoryid, formBase.getId(), 
      "uf_lo_provedoc");

    for (int i = 0; i < shiplist.size(); i++) {
      buffer = new StringBuffer(4096);

      buffer.append("insert into uf_lo_shipprove");
      buffer.append("(id,requestid,rowindex,itemno,suppliername,pid,runningno,ordertype,goodsgroup,isself,materialno,materialdesc,deliverdnum,yetloadnum,leftloadnum,notdelinum,notloadnum,salesunit,divvyfee,divvyexpfee,except,orderno,custname,packcode,packtype,remark) values");

      buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
      buffer.append("'").append(formBase.getId()).append("',");
      buffer.append("'").append(((Uf_lo_shipprove)shiplist.get(i)).getRowindex())
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getItemno())).append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getSuppliername()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getPid())).append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getRunningno()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getOrdertype()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getGoodsgroup()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getIsself())).append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getMaterialno()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getMaterialdesc()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getDeliverdnum()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getYetloadnum()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getLeftloadnum()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getNotdelinum()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getNotloadnum()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getSalesunit()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getDivvyfee()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getDivvyexpfee()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getExcept())).append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getOrderno()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getCustname()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getPackcode()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getPacktype()))
        .append("',");
      buffer.append("'").append(StringHelper.null2String(((Uf_lo_shipprove)shiplist.get(i)).getRemark())).append("')");
      ret += baseJdbc.update(buffer.toString());
    }

    List ps = baseJdbc.executeSqlForList("select * from  uf_lo_shipprove where packcode is null and requestid = '" + formBase.getId() + "'");
    if ((ps.size() > 0) && (NumberHelper.string2Float(provedoc.getNw()) > 0.0F)) {
      weightApportion(formBase.getId());
    }
    return ret;
  }

  public int createProveByPlan(String ladingno, String nw)
  {
    int ret = 0;
    Uf_lo_provedoc provedoc = new Uf_lo_provedoc();
    List shiplist = new ArrayList();

    DataService ds = new DataService();
    String sql1 = "select m.*, (select uf_lo_consolidator.conname from uf_lo_consolidator where uf_lo_consolidator.requestid = m.conname) mconname  from uf_lo_ladingmain m where m.ladingno = '" + 
      ladingno + "'";
    List list1 = ds.getValues(sql1);
    if ((list1 != null) && (list1.size() > 0)) {
      Map pMap = (Map)list1.get(0);

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

      provedoc.setFistin("");

      provedoc.setLastout("");

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

      String sql2 = "select d.*  from uf_lo_ladingdetail d where d.requestid = '" + 
        StringHelper.null2String(pMap.get("requestid")) + "' order by runningno";

      List list2 = ds.getValues(sql2);
      for (int i = 0; i < list2.size(); i++) {
        Map dMap = (Map)list2.get(i);
        Uf_lo_shipprove ship = new Uf_lo_shipprove();

        ship.setRowindex(StringHelper.specifiedLengthForInt(i, 3));

        ship.setItemno(StringHelper.null2String(dMap.get("itemno")));

        ship.setSuppliername(StringHelper.null2String(dMap.get("vendorname")));

        ship.setPid(StringHelper.null2String(Integer.valueOf(i + 1)));

        ship.setRunningno(StringHelper.null2String(dMap.get("runningno")));

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

      ret += createProve(provedoc, shiplist);
    }
    if ((ret > 0) && (nw.length() > 0)) {
      upProve(ladingno);
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
    Map retMap = new HashMap();
    DataService ds = new DataService();

    String sql1 = "select sp.* from v_lo_shipproveup sp where sp.loadno = (select max(loadingno) from uf_lo_ladingmain where uf_lo_ladingmain.ladingno = '" + 
      ladingno + "')";

    List list1 = ds.getValues(sql1);
    if ((list1 != null) && (list1.size() > 0)) {
      for (int i = 0; i < list1.size(); i++) {
        Map map = (Map)list1.get(i);
        Map inMap = new HashMap();
        if ("cg".equals(StringHelper.null2String(map.get("marked")))) {
          Purchase_Z_CCP_PO_DG app = new Purchase_Z_CCP_PO_DG("Z_CCP_PO_DG");
          Uf_lo_provecastlogService pcls = new Uf_lo_provecastlogService();
          Uf_lo_provecastlog pcl = new Uf_lo_provecastlog();

          inMap.put("EBELN", StringHelper.null2String(map.get("orderno")));
          inMap.put("EBELP", StringHelper.null2String(map.get("items")));
          inMap.put("LGORT", StringHelper.null2String(map.get("storageloc")));
          inMap.put("WERKS", StringHelper.null2String(map.get("plant")));
          inMap.put("LFIMG", StringHelper.null2String(map.get("yetloadnum")));
          inMap.put("CAR_NO", StringHelper.null2String(map.get("carno")));
          inMap.put("BUDAT", StringHelper.null2String(map.get("deliverydate")));
          inMap.put("GEWEI", StringHelper.null2String(map.get("unit")));
          inMap.put("PACK", StringHelper.null2String(map.get("pack")));

          pcl.setBillno(StringHelper.null2String(map.get("billno")));
          pcl.setLoadno(StringHelper.null2String(map.get("loadno")));
          pcl.setMarked("采购订单");
          pcl.setOrderno(StringHelper.null2String(map.get("orderno")));
          pcl.setItems(StringHelper.null2String(map.get("items")));
          pcl.setStorageloc(StringHelper.null2String(map.get("storageloc")));
          pcl.setPlant(StringHelper.null2String(map.get("plant")));
          pcl.setYetloadnum(StringHelper.null2String(map.get("yetloadnum")));
          pcl.setCarno(StringHelper.null2String(map.get("carno")));
          pcl.setDeliveydate(StringHelper.null2String(map.get("deliverydate")));
          pcl.setUnit(StringHelper.null2String(map.get("unit")));
          pcl.setPack(StringHelper.null2String(map.get("pack")));

          pcls.createLog(pcl);
        }
        else if ("jy".equals(StringHelper.null2String(map.get("marked")))) {
          Product_Z_CCP_DELIVERY_DG app = new Product_Z_CCP_DELIVERY_DG("Z_CCP_DELIVERY_DG");
          Uf_lo_provecastlogService pcls = new Uf_lo_provecastlogService();
          Uf_lo_provecastlog pcl = new Uf_lo_provecastlog();

          inMap.put("VBELN_VL", StringHelper.null2String(map.get("orderno")));
          inMap.put("POSNR_VL", StringHelper.null2String(map.get("items")));
          inMap.put("GARAGE_N", StringHelper.null2String(map.get("carname")));
          inMap.put("CAR_NO", StringHelper.null2String(map.get("carno")));
          inMap.put("LFIMG", StringHelper.null2String(map.get("sjnum")));
          inMap.put("GEWEI", StringHelper.null2String(map.get("unit")));
          inMap.put("NETWEI", StringHelper.null2String(map.get("yetloadnum")));
          inMap.put("PACK", StringHelper.null2String(map.get("pack")));

          pcl.setBillno(StringHelper.null2String(map.get("billno")));
          pcl.setLoadno(StringHelper.null2String(map.get("loadno")));
          pcl.setMarked("交运单");
          pcl.setOrderno(StringHelper.null2String(map.get("orderno")));
          pcl.setItems(StringHelper.null2String(map.get("items")));
          pcl.setCarname(StringHelper.null2String(map.get("carname")));
          pcl.setCarno(StringHelper.null2String(map.get("carno")));
          pcl.setRealnum(StringHelper.null2String(map.get("sjnum")));
          pcl.setUnit(StringHelper.null2String(map.get("unit")));
          pcl.setYetloadnum(StringHelper.null2String(map.get("yetloadnum")));
          pcl.setPack(StringHelper.null2String(map.get("pack")));

          pcls.createLog(pcl);
        }

      }

    }

    return retMap;
  }
}