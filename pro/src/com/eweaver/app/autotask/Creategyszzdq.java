/*    */ package com.eweaver.app.autotask;
/*    */ 
/*    */ import com.eweaver.base.BaseContext;
/*    */ import com.eweaver.base.BaseJdbcDao;
/*    */ import com.eweaver.base.util.NumberHelper;
/*    */ import com.eweaver.base.util.StringHelper;
/*    */ import com.eweaver.interfaces.model.Cell;
/*    */ import com.eweaver.interfaces.model.Dataset;
/*    */ import com.eweaver.interfaces.workflow.RequestInfo;
/*    */ import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
/*    */ import java.io.PrintStream;
/*    */ import java.text.SimpleDateFormat;
/*    */ import java.util.ArrayList;
/*    */ import java.util.Date;
/*    */ import java.util.List;
/*    */ import java.util.Map;
/*    */ 
/*    */ public class Creategyszzdq
/*    */ {
/*    */   public void doAction()
/*    */   {
/* 22 */     BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
/* 23 */     String sql = "select requestid  from uf_oa_gyszz where pdjg = '40285a8d4fbaabf8014fbf02d88515c8' and 1<>(select isdelete from formbase where id = requestid)";
/* 24 */     sql = sql + " and (select to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd')  as sysdates from dual) = add_months(to_date(zzyxrq,'yyyy-mm-dd'),-2)";
/* 25 */     System.out.println("供应给商资质到期" + sql);
/*    */ 
/* 27 */     List list = baseJdbc.executeSqlForList(sql);
/* 28 */     if (list.size() > 0)
/* 29 */       for (int i = 0; i < list.size(); i++) {
/* 30 */         Map map = (Map)list.get(i);
/* 31 */         String onlyid = StringHelper.null2String(map.get("requestid"));
/* 32 */         WorkflowServiceImpl workflowServiceImpl = new WorkflowServiceImpl();
/* 33 */         RequestInfo request = new RequestInfo();
/* 34 */         request.setCreator("40285a9049ade1710149adea1fc90b07");
/* 35 */         request.setTypeid("40285a8d51b3178b0151c83be6a61adc");
				 request.setIssave("1"); 
/* 36 */         Dataset data = new Dataset();
/* 37 */         List list1 = new ArrayList();
/* 38 */         Cell cell1 = new Cell();
/* 39 */         cell1.setName("title");
/* 40 */         cell1.setValue("采购类供应商资质到期提醒");
/* 41 */         list1.add(cell1);
				 cell1 = new Cell();
/* 43 */         cell1.setName("sqdh");
/* 44 */         cell1.setValue(onlyid);
/* 45 */         list1.add(cell1);
/*    */ 
/* 47 */         data.setMaintable(list1);
/* 48 */         request.setData(data);
/* 49 */         String str1 = workflowServiceImpl.createRequest(request);
/*    */       }
/*    */   }
/*    */ 
/*    */   private String getNo(String formula, String id, int len)
/*    */   {
/* 55 */     Date newdate = new Date();
/* 56 */     SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
/* 57 */     SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
/* 58 */     SimpleDateFormat sdf2 = new SimpleDateFormat("dd");
/*    */ 
/* 60 */     formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
/* 61 */     formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
/* 62 */     formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
/* 63 */     formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));
/*    */ 
/* 65 */     String o = NumberHelper.getSequenceNo(id, len);
/*    */ 
/* 67 */     return formula + o;
/*    */   }
/*    */ }

/* Location:           C:\Documents and Settings\dsf\桌面\
 * Qualified Name:     com.eweaver.app.autotask.Creategyszzdq
 * JD-Core Version:    0.6.2
 */