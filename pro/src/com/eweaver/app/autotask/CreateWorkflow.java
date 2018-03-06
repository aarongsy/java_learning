package com.eweaver.app.autotask;

import com.eweaver.app.configsap.SapConnector;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.DataService;
import com.eweaver.base.util.NumberHelper;
import com.eweaver.base.util.StringHelper;
import com.eweaver.interfaces.model.Cell;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class CreateWorkflow
{
  public void doAction()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

    String sql = "select * from uf_lo_inquiry where requestid =''";
    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() == 0)
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);
        String str1 = StringHelper.null2String(map.get("str1"));
        String str2 = StringHelper.null2String(map.get("str2"));

        String strn = StringHelper.null2String(map.get("strn"));

        WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
        RequestInfo request = new RequestInfo();
        request.setCreator("创建人ID");
        request.setTypeid("流程类型ID");
        Dataset data = new Dataset();
        List list1 = new ArrayList();
        Cell cell1 = new Cell();
        cell1.setName("title");
        cell1.setValue("测试测试");
        list1.add(cell1);
        cell1 = new Cell();
        cell1.setName("reqMan");
        cell1.setValue("402881e70be6d209010be75668750014");
        list1.add(cell1);

        cell1 = new Cell();
        cell1.setName("content");
        cell1.setValue("OK 测试成功自动流程");
        list1.add(cell1);

        cell1 = new Cell();
        cell1.setName("toMan");
        cell1.setValue("402881e70be6d209010be75668750014");
        list1.add(cell1);

        data.setMaintable(list1);
        request.setData(data);
        workflowServiceImpl.createRequest(request);
      }
  }

  public void CreHRprobation()
  {
    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();

    String sql = "select to_char(vf.today,'yyyy-mm-dd') today,to_char(vf.today-29,'yyyy-mm-dd') phks, to_char(vf.today+15,'yyyy-mm-dd') phjs,vf.objno,vf.objname staff,vf.dt1,vf.dt2,vf.dt3,hrs.id,hrs.objname,hrs.orgid from ( select b.today today,b.objno objno,b.objname objname, b.dt1 dt1,b.dt2 dt2,b.dt3 dt3,b.nums nums,b.hadnum hadnum, b.twodept twodept,og.objname twodeptname,og.mstationid mstationid,case when b.today=b.dt1 then to_date(b.SYKS,'yyyy-mm-dd') when b.today=b.dt2 then to_date(b.today,'yyyy-mm-dd')-29 when b.today=b.dt3 then to_date(b.today,'yyyy-mm-dd')-29 end phks from (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') today,  a.OBJNO,a.OBJNAME,a.SYKS,a.FIRST,a.SECOND ,a.THIRD,a.Nums, a.hadnum,to_date(a.FIRST,'yyyy-mm-dd')-15 dt1,  to_date(a.SECOND,'yyyy-mm-dd')-15 dt2,to_date(a.THIRD,'yyyy-mm-dd')-15 dt3,  a.TWODEPT twodept from v_uf_hr_probation a where a.hadnum is null or a.hadnum < a.nums) b ,orgunit og where b.twodept=og.id and (b.today=b.dt1 or b.today = b.dt2 or b.today = b.dt3 ) ) vf left join humres hrs on ( InStr(hrs.station,vf.mstationid)>0 or InStr(hrs.mainstation,vf.mstationid)>0 ) and hrs.hrstatus='4028804c16acfbc00116ccba13802935' and (hrs.extselectitemfield14 is null or hrs.extselectitemfield14!='40288098276fc2120127704884290210') ";

    String err = "";
    String passpsn = "";
    String failpsn = "";

    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      System.out.println("auto start SYPH......");
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);

        String objno = StringHelper.null2String(map.get("objno"));

        String staff = StringHelper.null2String(map.get("staff"));

        String leaderid = StringHelper.null2String(map.get("id"));

        String phks = StringHelper.null2String(map.get("phks"));
        String phjs = StringHelper.null2String(map.get("phjs"));
        String orgid=StringHelper.null2String(map.get("orgid"));
        int procount = Integer.parseInt(ds.getValue("select count(a.jobname) from uf_hr_probation a, requestbase b where a.requestid=b.id and b.isdelete=0 and a.jobname='" + staff + "' and a.phstartdate='" + phks + "' and a.phenddate='" + phjs + "'"));
        if (procount == 0)
          if (leaderid.equals("")) {
            err = "1";
            failpsn = failpsn + ";" + objno;
          } else if (leaderid.equals("null")) {
            err = "1";
            failpsn = failpsn + ";" + objno;
          } else {
        	  if(orgid.equals("40285a9049ade1710149ade3bf8900fd"))
        	  {
        		  leaderid=ds.getValue("select max(id) as leaderid from humres where  instr(station,((select b.mstationid from orgunit b where b.id='40285a9049ade1710149ade3bf8900fd')))>0 and hrstatus='4028804c16acfbc00116ccba13802935'");
        	  }
            WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
            RequestInfo rs = new RequestInfo();
            rs.setCreator(leaderid);
            rs.setTypeid("40285a9049d58e9e0149da332f610a3b");
            rs.setIssave("1");
            Dataset data = new Dataset();
            List list1 = new ArrayList();
            Cell cell1 = new Cell();
            cell1.setName("reqman");
            cell1.setValue(leaderid);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("jobname");
            cell1.setValue(staff);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("jobno");
            cell1.setValue(staff);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("phstartdate");
            cell1.setValue(phks);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("phenddate");
            cell1.setValue(phjs);
            list1.add(cell1);

            String sql1 = "select a.objname name,a.objno gh,a.orgid bm,a.extselectitemfield11 ygz,b.objdesc ygzm,a.extselectitemfield12 ygzz,c.objdesc ygzzm,a.extselectitemfield4 xl,a.mainstation gw,a.extrefobjfield5 cqb,a.extrefobjfield5 yjbm,a.extmrefobjfield7 ejbm,a.extrefobjfield4 zc,a.extdatefield8 syks,a.extdatefield9 syjs,extmrefobjfield9 gs,d.objname deptname from humres a  left join (select objdesc,id from selectitem) b on b.id=a.extselectitemfield11 left join (select objdesc,id from selectitem) c on c.id=a.extselectitemfield12 left join (select objname,id from orgunit) d on a.orgid=d.id where a.id='" + staff + "'";
            List listpsn = baseJdbc.executeSqlForList(sql1);
            if (listpsn.size() > 0) {
              Map m = (Map)listpsn.get(0);
              String dept = StringHelper.null2String(m.get("bm"));
              String ygz = StringHelper.null2String(m.get("ygz"));
              String ygzm = StringHelper.null2String(m.get("ygzm"));
              String ygzz = StringHelper.null2String(m.get("ygzz"));
              String ygzzm = StringHelper.null2String(m.get("ygzzm"));
              String xl = StringHelper.null2String(m.get("xl"));
              String gw = StringHelper.null2String(m.get("gw"));
              String cqb = StringHelper.null2String(m.get("cqb"));
              String yjbm = StringHelper.null2String(m.get("yjbm"));
              String ejbm = StringHelper.null2String(m.get("ejbm"));
              String zc = StringHelper.null2String(m.get("zc"));
              String syks = StringHelper.null2String(m.get("syks"));
              String syjs = StringHelper.null2String(m.get("syjs"));
              String gs = StringHelper.null2String(m.get("gs"));
              String name = StringHelper.null2String(m.get("name"));
              String deptname = StringHelper.null2String(m.get("deptname"));
              String gh = StringHelper.null2String(m.get("gh"));

              String flowno = getNo("SYPHYYYYMM", "40285a9049d58e9e0149da2202a40a3a", 5);

              cell1 = new Cell();
              cell1.setName("title");

              cell1.setValue("试用期评核：" + name + "-" + deptname + "-" + flowno);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("flowno");
              cell1.setValue(flowno);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("dept");
              cell1.setValue(dept);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("nunit");
              cell1.setValue(ygz);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("field1");
              cell1.setValue(ygzm);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("nunitsub");
              cell1.setValue(ygzz);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("field2");
              cell1.setValue(ygzzm);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("education");
              cell1.setValue(xl);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("orgunit");
              cell1.setValue(gw);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("oldzc");
              cell1.setValue(zc);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("systartdate");
              cell1.setValue(syks);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("syenddate");
              cell1.setValue(syjs);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("comtype");
              cell1.setValue(cqb);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("onedept");
              cell1.setValue(yjbm);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("twodept");
              cell1.setValue(ejbm);
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("openmode");
              cell1.setValue("1");
              list1.add(cell1);

              cell1 = new Cell();
              cell1.setName("reqcom");
              cell1.setValue(gs);
              list1.add(cell1);

              data.setMaintable(list1);
              rs.setData(data);
              String requestid = workflowServiceImpl.createRequest(rs);

              System.out.println("auto end SYPH......" + requestid);
              passpsn = passpsn + ";" + name + "/" + gh;
            } else {
              err = "1";
              failpsn = failpsn + ";" + objno;
            }
          }
      }
    }
    else {
      err = "0";
    }
    if (err.equals(""))
      System.out.println("auto end SYPH successfully");
    else
      System.out.println("auto end SYPH passpsn=" + passpsn + "   failpsn=" + failpsn);
  }

  private String getNo(String formula, String id, int len)
  {
    Date newdate = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
    SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd");

    formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
    formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
    formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
    formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));

    String o = NumberHelper.getSequenceNo(id, len);

    return formula + o;
  }

  public void CreStaffPayNotice()
  {
    String userid = "402881e70be6d209010be75668750014";

    BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    DataService ds = new DataService();

    String sql = "select v.formname,v.requestid,v.flowno,v.objanme,v.jobno,v.inorder,v.dept,v.onedept,v.twodept,v.company,v.comtype,v.acdocno,v.comcode,v.fiscalyear,v.currency,v.mon,v.paydate,v.titletext,v.itemtext from v_uf_fn_paynotice v";

    String err = "";
    String passpsn = "";
    String failpsn = "";

    List list = baseJdbc.executeSqlForList(sql);
    if (list.size() > 0) {
      System.out.println("auto start PayNotice.....");
      for (int i = 0; i < list.size(); i++) {
        Map map = (Map)list.get(i);
        String formname = StringHelper.null2String(map.get("formname"));
        String requestid = StringHelper.null2String(map.get("requestid"));
        String flowno = StringHelper.null2String(map.get("flowno"));
        String objanme = StringHelper.null2String(map.get("objanme"));
        String jobno = StringHelper.null2String(map.get("jobno"));
        String inorder = StringHelper.null2String(map.get("inorder"));
        String dept = StringHelper.null2String(map.get("dept"));
        String onedept = StringHelper.null2String(map.get("onedept"));
        String twodept = StringHelper.null2String(map.get("twodept"));
        String company = StringHelper.null2String(map.get("company"));
        String comtype = StringHelper.null2String(map.get("comtype"));
        String acdocno = StringHelper.null2String(map.get("acdocno"));
        String comcode = StringHelper.null2String(map.get("comcode"));
        String fiscalyear = StringHelper.null2String(map.get("fiscalyear"));
        String currenc = StringHelper.null2String(map.get("currency"));
        String mon = StringHelper.null2String(map.get("mon"));
        String paydate = StringHelper.null2String(map.get("paydate"));
        String titletext = StringHelper.null2String(map.get("titletext"));
        String itemtext = StringHelper.null2String(map.get("itemtext"));
        String paydatetmp = paydate.replace("-", "");
        paydatetmp = paydate.replace("-", "");

        SapConnector sapConnector = new SapConnector();
        String functionName = "ZOA_FI_INORDER_PAY";
        JCoFunction function = null;
        try {
          function = SapConnector.getRfcFunction(functionName);
        }
        catch (Exception e) {
          e.printStackTrace();
        }

        function.getImportParameterList().setValue("BUKRS", comcode);
        function.getImportParameterList().setValue("AUFNR", inorder);
        function.getImportParameterList().setValue("BELNR", acdocno);
        function.getImportParameterList().setValue("GJAHR", fiscalyear);
        function.getImportParameterList().setValue("LAUFD", paydatetmp);
        System.out.println("input comcode=" + comcode + " inorder=" + inorder + " acdocno=" + acdocno + " fiscalyear=" + fiscalyear + " paydatetmp=" + paydatetmp);
        try
        {
          function.execute(SapConnector.getDestination("sanpowersap"));

          JCoTable tab = function.getTableParameterList().getTable("FI_INORDER_PAY");
          System.out.println(" tab.getNumRows()=" + tab.getNumRows());
          if ((tab != null) && (tab.getNumRows() > 0))
          {
            String paycurrency = StringHelper.null2String(tab.getValue("WAERS"));

            String paymon = StringHelper.null2String(tab.getString("PYAMT"));

            String comcode2 = StringHelper.null2String(tab.getString("BUKRS"));

            String mon2 = StringHelper.null2String(tab.getString("WRBTR"));

            String inorder2 = StringHelper.null2String(tab.getString("AUFNR"));

            String itemtext2 = StringHelper.null2String(tab.getString("SGTXT"));

            String acdocno2 = StringHelper.null2String(tab.getString("BELNR"));

            String titletext2 = StringHelper.null2String(tab.getString("BKTXT"));

            String paycreditno = StringHelper.null2String(tab.getString("VBLNR"));

            String hs = StringHelper.null2String(tab.getString("BUZEI"));

            String fiscalyear2 = StringHelper.null2String(tab.getString("GJAHR"));

            String paydate2 = StringHelper.null2String(tab.getString("LAUFD"));

            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String Dtime = format.format(new Date());
            String reqdate = Dtime;

            WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
            RequestInfo rs = new RequestInfo();
            rs.setCreator(userid);
            rs.setTypeid("40285a8d4aaea6d9014aaf03638e039b");

            Dataset data = new Dataset();
            List list1 = new ArrayList();
            Cell cell1 = new Cell();
            cell1.setName("reqman");
            cell1.setValue("");
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("reqdate");
            cell1.setValue(reqdate);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("reqflowno");
            cell1.setValue(requestid);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("flowno");
            cell1.setValue(flowno);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("jobname");
            cell1.setValue(objanme);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("jobno");
            cell1.setValue(jobno);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("inorder");
            cell1.setValue(inorder);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("dept");
            cell1.setValue(dept);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("onedept");
            cell1.setValue(onedept);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("twodept");
            cell1.setValue(twodept);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("company");
            cell1.setValue(company);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("comtype");
            cell1.setValue(comtype);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("creditno");
            cell1.setValue(acdocno);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("comcode");
            cell1.setValue(comcode);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("fiscalyear");
            cell1.setValue(fiscalyear);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("currency");
            cell1.setValue(currenc);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("money");
            cell1.setValue(mon);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("paycreditno");
            cell1.setValue(paycreditno);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("paydate");
            cell1.setValue(paydate2);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("paycurrency");
            cell1.setValue(paycurrency);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("paymon");
            cell1.setValue(paymon);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("headtext");
            cell1.setValue(titletext);
            list1.add(cell1);

            cell1 = new Cell();
            cell1.setName("itemtext");
            cell1.setValue(itemtext);
            list1.add(cell1);

            data.setMaintable(list1);
            rs.setData(data);
            String paynorequestid = workflowServiceImpl.createRequest(rs);

            passpsn = passpsn + ";" + jobno;
            System.out.println("获取到付款凭证号，创建流程--" + paynorequestid);

            baseJdbc.update("update " + formname + " set payno=" + paycreditno + " where requestid='" + requestid + "'");
          }
          else
          {
            failpsn = failpsn + ";" + jobno;
            err = "没有获取到付款凭证号，不创建流程";
            System.out.println("没有获取到付款凭证号，不创建流程");
          }
        }
        catch (Exception e) {
          e.printStackTrace();
        }
      }
      System.out.println("auto end PayNotice.....");
    }
    else {
      err = "0";
    }
    if (err.equals("")) {
      System.out.println("auto end PayNotice successfully");
    }
    else
      System.out.println("auto end PayNotice passpsn=" + passpsn + "   failpsn=" + failpsn);
  }
}