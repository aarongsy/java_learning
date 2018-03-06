package com.eweaver.app.dccm.dmlo.weigh.service;


import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_budget;
import com.eweaver.app.dccm.dmlo.weigh.model.Uf_dmlo_budgetdetail;
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
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Uf_dmlo_budgetService
{
  public String getRequestidByLadingno(String ladingno)
  {
    String ret = "";
    DataService ds = new DataService();
    ret = StringHelper.null2String(ds.getValue("select p.requestid from uf_dmlo_loadplan p left join uf_dmlo_ladingmain l on p.reqno = l.loadingno where l.ladingno = '" + ladingno + "'"));
    return ret;
  }

 
  //2016-10-02 传入提单号 ，校验该提单号已生成暂估明细 不在生成
	public int createBudget(Uf_dmlo_budget budget, List<Uf_dmlo_budgetdetail> details, String merges, String lx, String p50, String reqman,String plate)
{
  int ret = 0;
  BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

  String userId = BaseContext.getRemoteUser().getId();
  String reqno = budget.getLoadplanno();
  System.out.println("-------------merges : " + merges);
  System.out.println("-------------details : " + details);
  System.out.println("-------------lx : " + lx);
  System.out.println("-------------budget : " + budget);
  System.out.println("-------------生成暂估费用凭证 createBudget() 开始-------------");

  String pRequestid = "";
	String sfyzg="";//是否已暂估
  if ("zc".equals(lx))
	{
		List ls003 = baseJdbc.executeSqlForList("select requestid from uf_lo_budget where loadplanno = '" + reqno + "' and principle='" + merges + "'");
		if ((ls003 != null) && (ls003.size() > 0)) {
			Map m = (Map)ls003.get(0);
			pRequestid = StringHelper.null2String(m.get("requestid"));
			ls003 = baseJdbc.executeSqlForList("select requestid from uf_lo_budget where requestid = '" + pRequestid + "' and instr(tdno,'"+plate+"')>0");
			if ((ls003 != null) && (ls003.size() > 0))
			{
				sfyzg="y";//已暂估
			}
		}
  }

  StringBuffer buffer = new StringBuffer(4096);
  if (StringHelper.isEmpty(pRequestid))
  {
    buffer.append("insert into uf_lo_budget");
    buffer.append("(id,requestid,invoiceno,loadplanno,companyno,concode,carno,voucherno,createtype,monat,tonnage,createdate,voucherdate,postdate,principle,budmoney,etaxmoney,creator,modifier,modifieddate,remark,conname,title,invoicestatue,vouchertype,companyname,zmark,zmess,currency,feetype,tdno,isremark) values");

    buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
    buffer.append("'").append("$ewrequestid$").append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getInvoiceno())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getLoadplanno())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getCompanyno())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getConcode())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getCarno())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getVoucherno())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getCreatetype())).append("',");
    buffer.append("to_char(sysdate,'mm'),");
    buffer.append("'").append(StringHelper.null2String(budget.getTonnage())).append("',");
    buffer.append("to_char(sysdate,'yyyy-mm-dd'),");
    buffer.append("to_char(sysdate,'yyyy-mm-dd'),");
    buffer.append("to_char(sysdate,'yyyy-mm-dd'),");
    buffer.append("'").append(merges).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getBudmoney())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getEtaxmoney())).append("',");

    buffer.append("'").append(StringHelper.null2String(reqman)).append("',");
    buffer.append("'").append(StringHelper.null2String(userId)).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getModifieddate())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getRemark())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getConname())).append("',");
    buffer.append("to_char(sysdate,'yyyymm')||'运费',");
    buffer.append("'").append(StringHelper.null2String(budget.getInvoicestatue())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getVouchertype())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getCompanyname())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getZmark())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getZmess())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getCurrency())).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getFeetype())).append("',");
	buffer.append("'").append(plate).append("',");
    buffer.append("'").append(StringHelper.null2String(budget.getIsremark())).append("')");

    FormBase formBase = new FormBase();
    String categoryid = "402864d149e039b10149e06925dd0089";

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
      "uf_lo_budget");
    pRequestid = formBase.getId();
  }
	if(!sfyzg.equals("y"))
	{
		System.out.println("-------------------- details.size() : " + details.size());
		for (int i = 0; i < details.size(); i++) {
		  buffer = new StringBuffer(4096);

		  buffer.append("insert into uf_lo_budgetdetail");
		  buffer.append("(id,requestid,rowindex,chargecode,subject,amount,notaxamount,saletax,costcentre,purchorder,saleorder,itemno,projecttext,isflag,detailid,wlh) values");

		  buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
		  buffer.append("'").append(pRequestid).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getRowindex())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getChargecode())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getSubject())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getAmount())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getNotaxamount())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getSaletax())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getCostcentre())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getPurchorder())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getSaleorder())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getItemno())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getProjecttext())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getIsflag())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getDetailid())).append("',");
		  buffer.append("'").append(StringHelper.null2String(((Uf_dmlo_budgetdetail)details.get(i)).getWlh())).append("')");
		  ret += baseJdbc.update(buffer.toString());
		}
		String sqltd="update uf_lo_budget set tdno=tdno||',"+plate+"' where requestid='"+pRequestid+"'";
		baseJdbc.update(sqltd);
	}
  System.out.println("-------------50 插入 add-------------");
  double amount = 0.0D;
  double notaxamount = 0.0D;
  List list40 = baseJdbc.executeSqlForList("select sum(amount) a,sum(notaxamount) b from uf_lo_budgetdetail where requestid = '" + pRequestid + "' and chargecode='40'");
  if ((list40 != null) && (list40.size() > 0)) {
    Map map40 = (Map)list40.get(0);
    amount = NumberHelper.string2Double(map40.get("a"), 0.0D);
    notaxamount = NumberHelper.string2Double(map40.get("b"), 0.0D);
  }
  StringBuffer sbf = new StringBuffer(4096);
  List list50 = baseJdbc.executeSqlForList("select amount,notaxamount,costcentre from uf_lo_budgetdetail where requestid = '" + pRequestid + "' and chargecode='50'");
  if ((list50 != null) && (list50.size() > 0)) {
    sbf.append("update uf_lo_budgetdetail set amount='" + amount + "',notaxamount='" + notaxamount + "' where requestid='" + pRequestid + "' and chargecode='50'");
    ret += baseJdbc.update(sbf.toString());
  } else {
    List lis = baseJdbc.executeSqlForList("select amount,notaxamount,costcentre from uf_lo_budgetdetail where requestid = '" + pRequestid + "'");
    String costcentre = "";
    for (int j = 0; j < lis.size(); j++) {
      Map maplis = (Map)lis.get(j);

      costcentre = StringHelper.null2String(maplis.get("costcentre"));
    }

    sbf.append("insert into uf_lo_budgetdetail");
    sbf.append("(id,requestid,rowindex,chargecode,subject,amount,notaxamount,saletax,costcentre,purchorder,saleorder,itemno,projecttext,isflag) values");

    sbf.append("('").append(IDGernerator.getUnquieID()).append("',");
    sbf.append("'").append(pRequestid).append("',");
    sbf.append("'").append("999").append("',");
    sbf.append("'").append("50").append("',");
    sbf.append("'").append(p50).append("',");

    sbf.append("'").append(amount).append("',");
    sbf.append("'").append(notaxamount).append("',");
    sbf.append("'").append("").append("',");
    sbf.append("'").append(costcentre).append("',");
    sbf.append("'").append("").append("',");

    sbf.append("'").append("").append("',");
    sbf.append("'").append("0").append("',");
    sbf.append("'").append("").append("',");
    sbf.append("'").append("40288098276fc2120127704884290211").append("')");
    ret += baseJdbc.update(sbf.toString());
  }

  System.out.println("------------------------------ amount = " + amount);
  System.out.println("------------------------------ notaxamount = " + notaxamount);

  baseJdbc.update("update uf_lo_budget set budmoney = '" + amount + "',etaxmoney = '" + notaxamount + "' where requestid = '" + pRequestid + "'");
  System.out.println("------------------------------ formBase.getId() =  " + pRequestid);

  String objname = "";
  List ls = baseJdbc.executeSqlForList("select concode,principle from uf_lo_budget  where requestid = '" + pRequestid + "'");
  if (ls.size() > 0) {
    Map m = (Map)ls.get(0);
    String concode = StringHelper.null2String(m.get("concode"));
    String principle = StringHelper.null2String(m.get("principle"));
    System.out.println("------------------------------ concode = " + concode);
    System.out.println("------------------------------ principle = " + principle);
    if ((!"".equals(concode)) && (!"".equals(principle))) {
      List lss = baseJdbc.executeSqlForList("select objname from selectitem where id in (select ratecode from uf_lo_faxrate where invoicetype = '" + principle + "' and requestid in (select requestid from uf_lo_consolidator where concode = '" + concode + "'))");
      for (int i = 0; i < lss.size(); i++) {
        Map ms = (Map)lss.get(0);
        objname = StringHelper.null2String(ms.get("objname"));
      }
      System.out.println("------------------------------ objname = " + objname);
      baseJdbc.update("update uf_lo_budgetdetail set saletax = '" + objname + "' where chargecode = '40' and requestid= '" + pRequestid + "'");
    }
  }
  System.out.println("-------------50 插入 end-------------");

  System.out.println("-------------生成暂估费用凭证 createBudget() 结束-------------");

  return ret;
}
//2016-10-02 传人提单号
  public int createBudgetByPlan(String requestid,String plate)
  {
    int ret = 0;
    Uf_dmlo_budget budget = new Uf_dmlo_budget();
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();
    String sql1 = "select p.*,(select max(objname) from orgunit where isdelete = 0 and objno = p.company) pcompanyname,(select objname from orgunittype where id = p.factory) pfactory,(select max(ratecode) from uf_lo_faxrate where uf_lo_faxrate.requestid = p.actname) pratecode,(select conname from uf_lo_consolidator where uf_lo_consolidator.requestid = p.actname) pconnname,(select max(get_namebyid(ratecode,0)) from uf_lo_faxrate where uf_lo_faxrate.requestid = p.actname) pratecode,(select paramvalue from uf_lo_parameter where uf_lo_parameter.paramcode = '40' and p.company = uf_lo_parameter.company) p40,(select paramvalue from uf_lo_parameter where uf_lo_parameter.paramcode = '50' and p.company = uf_lo_parameter.company) p50,(select max(ratenum) from uf_lo_faxrate where uf_lo_faxrate.requestid = p.actname) pratenum from uf_lo_loadplan p where p.requestid = '" + 
      requestid + "'";
    List list1 = ds.getValues(sql1);
    System.out.println("-------------- requestid : " + requestid);
    System.out.println("-------------- list1 : " + list1);
    if ((list1 != null) && (list1.size() > 0)) {
      Map pMap = (Map)list1.get(0);

      String needtype = StringHelper.null2String(pMap.get("needtype"));
      String reqman = StringHelper.null2String(pMap.get("reqman"));

      budget.setCreatetype(StringHelper.null2String(pMap.get("createtype")));

      budget.setLoadplanno(StringHelper.null2String(pMap.get("reqno")));
      budget.setInvoicestatue(StringHelper.null2String("402864d149e039b10149e080b01600c0"));

      budget.setVouchertype(StringHelper.null2String("SA"));
      budget.setConcode(StringHelper.null2String(pMap.get("actcode")));
      budget.setCarno(StringHelper.null2String(pMap.get("carno")));

      if ("40285a9048f924a70148fd11093d052b".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("01"));
      else if ("40285a904a9639b6014a98df9c760871".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("02"));
      else if ("40285a9048f924a70148fd11093d052c".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("03"));
      else if ("40285a904a9639b6014a98eda1760ae0".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("04"));
      else if ("40285a9048f924a70148fd11093d052d".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("05"));
      else if ("40285a9048f924a70148fd11093d052e".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("08"));
      else if ("40285a9048f924a70148fd11093d052f".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("10"));
      else if ("40285a904a9639b6014a98ed0f2a0ada".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("20"));
      else if ("402864d149df48ff0149df96016301b3".equals(
        StringHelper.null2String(pMap.get("transitton"))))
        budget.setTonnage(StringHelper.null2String("30"));
      else if ("40285a904a9639b6014a98ed6e690ade".equals(
        StringHelper.null2String(pMap.get("transitton")))) {
        budget.setTonnage(StringHelper.null2String("35"));
      }

      budget.setConname(StringHelper.null2String(pMap.get("pconnname")));

      budget.setCurrency("RMB");

      budget.setFeetype("40285a8d4d6fab42014d742812381730");

      String sqlmxids = "select wm_concat(p.id) ids,get_merge(p.id) merge,materialno,ordertype,costenter from uf_lo_loaddetail p where requestid = '" + requestid + "' group by get_merge(p.id),materialno,ordertype,costenter";
      List mxids = ds.getValues(sqlmxids);
      String merge = "";

      for (int j = 0; j < mxids.size(); j++)
      {
        String company = ""; String companyname = "";
        List details = new ArrayList();
        Map idsMap = (Map)mxids.get(j);
        double prnum = 100.0D + NumberHelper.string2Double(pMap.get("pratenum"), 0.0D);
        System.out.println("----------------------------- prnum : " + prnum);
        String sqlsum = "select nvl(sum(uf_lo_loaddetail.divvyfee), 0) fare,decode(nvl(sum(uf_lo_loaddetail.divvyfee) * 100 / (" + 
          prnum + "),0)," + 
          "0," + 
          "'0.00'," + 
          "to_char(nvl(sum(uf_lo_loaddetail.divvyfee) * 100 / (" + prnum + "),0)," + 
          "'9999999999.99')) axfare " + 
          "from uf_lo_loaddetail " + 
          "where instr('" + StringHelper.null2String(idsMap.get("ids")) + "', uf_lo_loaddetail.id) > 0";
        Map sumMap = (Map)ds.getValues(sqlsum).get(0);

        String costcenter = StringHelper.null2String(idsMap.get("costenter"));
        List list001 = ds.getValues("select costcentre from uf_lo_costcentre where requestid = '" + costcenter + "'");
        if (list001.size() > 0) {
          Map map001 = (Map)list001.get(0);
          costcenter = StringHelper.null2String(map001.get("costcentre"));
        }
        String materialno = StringHelper.null2String(idsMap.get("materialno"));
        String ordertype = StringHelper.null2String(idsMap.get("ordertype"));
        System.out.println("----------------------------- materialno : " + materialno);
        System.out.println("----------------------------- ordertype : " + ordertype);
        System.out.println("--------------------------- costcenter : " + costcenter);
        try
        {
          List list002 = ds.getValues("select merge from uf_tr_import where costcenter = '" + costcenter + "' and ddlx = (select id from selectitem where objname = '" + ordertype + "' and typeid = '40285a8d4db6e16b014db871954017d0')");
          if (list002.size() == 1) {
            Map map002 = (Map)list002.get(0);
            merge = StringHelper.null2String(map002.get("merge"));
          } else {
            List lists007 = ds.getValues("select merge from uf_tr_import where costcenter = '" + costcenter + "' and material = '" + materialno + "' and ddlx = (select id from selectitem where objname = '" + ordertype + "' and typeid = '40285a8d4db6e16b014db871954017d0')");
            if (lists007.size() > 0) {
              Map listsmap = (Map)lists007.get(0);
              merge = StringHelper.null2String(listsmap.get("merge"));
            }
          }
        } catch (Exception e) {
          System.out.println("合并开票原则 查询错误 E: " + e);
        }
        System.out.println("----------------------------- merge : " + merge);

        budget.setBudmoney(StringHelper.null2String(sumMap.get("fare")));

        budget.setEtaxmoney(StringHelper.null2String(sumMap.get("axfare")));

        String sql2 = "select d.*,nvl(d.divvyfee,0) dtax,decode(nvl(d.divvyfee * 100/(" + 
          prnum + "), 0),0,'0.00',to_char(nvl(d.divvyfee * 100/(" + prnum + "),0),'9999999999.99')) dfee," + 
          "(select max(orderno) from v_lo_order where v_lo_order.runningno = d.runningno) orderno," + 
          "(select max(items) from v_lo_order where v_lo_order.runningno = d.runningno) items," + 
          "(select max(saleno) from v_lo_order where v_lo_order.runningno = d.runningno) saleno," + 
          "(select max(salesitem) from v_lo_order where v_lo_order.runningno = d.runningno) salesitem," + 
          "(select max(center) from v_lo_order where v_lo_order.runningno = d.runningno) center," + 
          "(select max(marked) from v_lo_order where v_lo_order.runningno = d.runningno) marked " + 
          " from uf_lo_loaddetail d " + 
          "where instr('" + StringHelper.null2String(idsMap.get("ids")) + "', d.id) > 0";

        List list2 = ds.getValues(sql2);

        for (int i = 0; i < list2.size(); i++) {
          Map dMap = (Map)list2.get(i);
          String _runningno = StringHelper.null2String(dMap.get("runningno"));
          String detailid = StringHelper.null2String(dMap.get("id"));
          String sql0 = ""; String _company = ""; String wlh = "";
          List list0 = null;

          Uf_dmlo_budgetdetail detail = new Uf_dmlo_budgetdetail();
          detail.setDetailid(detailid);
          if (StringHelper.isEmpty(_company)) {
            sql0 = "select plant from uf_lo_delivery where runningno='" + _runningno + "'";
            list0 = baseJdbc.executeSqlForList(sql0);
            if ((list0 != null) && (list0.size() > 0)) {
              _company = StringHelper.null2String(((Map)list0.get(0)).get("plant"));
              detail.setPurchorder("");
              detail.setSaleorder(StringHelper.null2String(dMap.get("saleno")));
            } else {
              sql0 = "select buyer,materialno from uf_lo_purchase where runningno='" + _runningno + "'";
              list0 = baseJdbc.executeSqlForList(sql0);
              if ((list0 != null) && (list0.size() > 0)) {
                _company = StringHelper.null2String(((Map)list0.get(0)).get("buyer"));
                wlh = StringHelper.null2String(((Map)list0.get(0)).get("materialno"));
                detail.setPurchorder(StringHelper.null2String(dMap.get("orderno")));
                detail.setSaleorder("");
              } else {
                sql0 = "select plant from uf_lo_salesorder where runningno='" + _runningno + "'";
                list0 = baseJdbc.executeSqlForList(sql0);
                if ((list0 != null) && (list0.size() > 0)) {
                  _company = StringHelper.null2String(((Map)list0.get(0)).get("plant"));
                } else {
                  sql0 = "select b.comcode from v_uf_lo_passdetail a,uf_lo_passfactory b where a.runningno='" + _runningno + "' and a.requestid=b.requestid";
                  list0 = baseJdbc.executeSqlForList(sql0);
                  if ((list0 != null) && (list0.size() > 0)) {
                    _company = StringHelper.null2String(((Map)list0.get(0)).get("comcode"));
                  }
                }
              }
            }
          }
          if (StringHelper.isEmpty(company)) {
            company = _company;
            sql0 = "select max(objname) companyname from orgunit where isdelete = 0 and objno = '" + _company + "'";
            list0 = baseJdbc.executeSqlForList(sql0);
            if ((list0 != null) && (list0.size() > 0)) {
              companyname = StringHelper.null2String(((Map)list0.get(0)).get("companyname"));
            }
          }

          if ("40285a904b3902dd014b61db2acb27cf".equals(merge)) {
            detail.setSubject("12470000");
          } else {
            sql0 = "select paramvalue from uf_lo_parameter where uf_lo_parameter.paramcode = '40' and uf_lo_parameter.company='" + _company + "'";
            list0 = baseJdbc.executeSqlForList(sql0);
            if ((list0 != null) && (list0.size() > 0)) {
              detail.setSubject(StringHelper.null2String(((Map)list0.get(0)).get("paramvalue")));
            }
          }

          detail.setRowindex(StringHelper.specifiedLengthForInt(i, 3));

          detail.setChargecode("40");

          detail.setWlh(wlh);

          detail.setAmount(StringHelper.null2String(dMap.get("dtax")));

          detail.setNotaxamount(StringHelper.null2String(dMap.get("dfee")));

          detail.setSaletax(StringHelper.null2String(pMap.get("pratecode")));

          detail.setCostcentre(StringHelper.null2String(dMap.get("center")));

          System.out.println("----------------StringHelper.null2String(dMap.get(center)) ：" + StringHelper.null2String(dMap.get("center")));

          if ("jy".equals(StringHelper.null2String(dMap.get("marked"))))
            detail.setItemno(StringHelper.null2String(dMap.get("salesitem")));
          else {
            detail.setItemno("0");
          }

          detail.setIsflag("40288098276fc2120127704884290211");

          details.add(detail);
        }
        if (StringHelper.isEmpty(company)) {
          company = StringHelper.null2String(pMap.get("company"));
        }
        if (StringHelper.isEmpty(companyname)) {
          companyname = StringHelper.null2String(pMap.get("pcompanyname"));
        }
        budget.setCompanyno(company);
        budget.setCompanyname(companyname);
        budget.setInvoiceno(StringHelper.null2String(company) + 
          "F" + 
          NumberHelper.getSequenceNo("40285a8d4ae66bd9014ae71f8b385672", 8));

        String sql0 = "select paramvalue from uf_lo_parameter where uf_lo_parameter.paramcode = '50' and uf_lo_parameter.company='" + company + "'";
        List list0 = baseJdbc.executeSqlForList(sql0);
        String p50 = StringHelper.null2String(pMap.get("p50"));
        if ((list0 != null) && (list0.size() > 0)) {
          String _p50 = StringHelper.null2String(((Map)list0.get(0)).get("paramvalue"));
          if (!StringHelper.isEmpty(_p50)) {
            p50 = _p50;
          }

        }

        String lx = "zc";
        ret += createBudget(budget, details, merge, lx, p50, reqman,plate);
      }
    }
    return ret;
  }
  
}