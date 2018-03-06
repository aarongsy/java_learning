<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>

<%
String requestid=StringHelper.null2String(request.getParameter("requestid"));
String Taxcode=StringHelper.null2String(request.getParameter("Taxcode"));//税码
String Taxrate=StringHelper.null2String(request.getParameter("Taxrate"));//税率
String Taxtype=StringHelper.null2String(request.getParameter("Taxtype"));//税别
//String Totalsubject=StringHelper.null2String(request.getParameter("Totalsubject"));//总账科目
String Startdate=StringHelper.null2String(request.getParameter("Startdate"));//申请日期(起)
String Enddate=StringHelper.null2String(request.getParameter("Enddate"));//申请日期(止)
String Companytype=StringHelper.null2String(request.getParameter("Companytype"));//公司别
String Fruitsupplier=StringHelper.null2String(request.getParameter("Fruitsupplier"));//水果供应商
BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

//清空历史数据(水果对账单子表)
String sql1="delete from uf_oa_fruitaccountchild where requestid='"+requestid+"'";
baseJdbc.update(sql1);
//System.out.println(sql1);
//按条件查询包厢申请单中的数据(公司别,水果供应商,申请起止日期)
/*String sql2="(select a.tradename as ProductName,a.price as UnitPrice,a.weight as Quantum,a.amountmoney as SumMoney,b.creater as CreateMan,b.creatDate as   Createday,b.reqdept as Depart,b.costcenter as MiddleCost,b.flowno as OrderNum from uf_oa_fruitsnacks a left join uf_meeting b  on a.requestid=b.requestid left join requestbase res on b.requestid=res.id  where a.supplyname='"+Fruitsupplier+"' and b.reqcom='"+Companytype+"' and b.creatDate>='"+Startdate+"' and b.creatDate<='"+Enddate+"' and 0=res.isdelete  and (b.isrecon='40288098276fc2120127704884290211' or b.isrecon is null) and not exists(select f.id from uf_oa_fruitaccountchild f left join requestbase h on h.id=f.requestid where 0=h.isdelete and h.appliflow=b.flowno)) union all(select c.tradename as ProductName,c.price as UnitPrice,c.weight as Quantum,c.amountmoney as SumMoney,c.reqman as CreateMan,c.reqdate as Createday,c.expenses as Depart,c.costcenter as MiddleCost,c.flowno as OrderNum from uf_hr_balcony c left join requestbase req on c.requestid=req.id where c.newsuppliers='"+Fruitsupplier+"' and c.factype='"+Companytype+"' and c.reqdate>='"+Startdate+"' and c.reqdate<='"+Enddate+"' and 0=req.isdelete and 1=req.isfinished and not exists(select d.id from uf_oa_fruitaccountchild d left join requestbase r on r.id=d.requestid where 0=r.isdelete and d.appliflow=c.flowno))";
*/

String sql2="(select a.id,a.requestid,a.tradename as ProductName,a.price as UnitPrice,a.weight as Quantum,a.amountmoney as SumMoney,b.creater as CreateMan,b.creatDate as   Createday,b.reqdept as Depart,b.costcenter as MiddleCost,b.flowno as OrderNum,b.beginDate as beginDate from uf_oa_fruitsnacks a left join uf_meeting b  on a.requestid=b.requestid left join requestbase res on b.requestid=res.id  where a.supplyname='"+Fruitsupplier+"' and b.reqcom='"+Companytype+"' and substr(b.beginDate,0,10)>='"+Startdate+"' and substr(b.beginDate,0,10)<='"+Enddate+"' and 0=res.isdelete and 1=res.isfinished and (b.isrecon='40288098276fc2120127704884290211' or b.isrecon is null or(b.isrecon='40288098276fc2120127704884290210' and b.reconno=(select flow from uf_oa_fruitaccountmain  where requestid='"+requestid+"'))) and not exists(select f.id from uf_oa_fruitaccountchild f left join requestbase h on h.id=f.requestid where 0=h.isdelete and f.appliflow=b.flowno and f.requestid<>'"+requestid+"' and f.status='1') )union all(select c.id,c.requestid,c.tradename as ProductName,c.price as UnitPrice,c.weight as Quantum,c.amountmoney as SumMoney,c.reqman as CreateMan,c.reqdate as Createday,c.expenses as Depart,c.costcenter as MiddleCost,c.flowno as OrderNum,c.startdate as beginDate from uf_hr_balcony c left join requestbase req on c.requestid=req.id where (c.isvalid='40288098276fc2120127704884290210' or c.isvalid is null) and c.newsuppliers='"+Fruitsupplier+"' and c.factype='"+Companytype+"' and substr(c.startdate,0,10)>='"+Startdate+"' and substr(c.startdate,0,10)<='"+Enddate+"' and 0=req.isdelete and 1=req.isfinished and not exists(select d.id from uf_oa_fruitaccountchild d left join requestbase r on r.id=d.requestid where 0=r.isdelete and d.appliflow=c.flowno and d.requestid<>'"+requestid+"' and d.status='1') )";


System.out.println(sql2);
 List sublist = baseJdbc.executeSqlForList(sql2);
// System.out.println(sublist.size());
 if(sublist.size()>0)
 {
	 for(int i=0;i<sublist.size();i++)
	 {
		 Map map=(Map)sublist.get(i);
		 String Createday=StringHelper.null2String(map.get("beginDate"));//申请日期
		 String CreateMan=StringHelper.null2String(map.get("CreateMan"));//申请人
		 String Depart=StringHelper.null2String(map.get("Depart"));//部门
		 String MiddleCost=StringHelper.null2String(map.get("MiddleCost"));//成本中心
		 String OrderNum=StringHelper.null2String(map.get("OrderNum"));//申请单号
		 String ProductName=StringHelper.null2String(map.get("ProductName"));//品名
		 String UnitPrice=StringHelper.null2String(map.get("UnitPrice"));//单价
		 String Quantum=StringHelper.null2String(map.get("Quantum"));//数量
		 String SumMoney=StringHelper.null2String(map.get("SumMoney"));//金额
		 String AccountID=StringHelper.null2String(map.get("id"));//关联ID
         String Accountres=StringHelper.null2String(map.get("requestid"));//关联requestid




		 //将从包厢和会议中取得的数据插入水果对账单子表
		 String sql3="insert into uf_oa_fruitaccountchild (id,requestid,ordernum,applidate,applicant,department,costcenter,accountsubject,taxrate,taxtype,appliflow,productname,price,quantity,amountmoney,taxcode,notaxmoney,taxmoney,accountid,status,Accountres)values((select sys_guid() from dual),'"+requestid+"',"+(i+1)+",'"+Createday+"','"+CreateMan+"','"+Depart+"','"+MiddleCost+"','55063900',"+Taxrate+",'"+Taxtype+"','"+OrderNum+"','"+ProductName+"',"+UnitPrice+","+Quantum+","+SumMoney+",'"+Taxcode+"',null,null,'"+AccountID+"','0','"+Accountres+"')";
		 baseJdbc.update(sql3);
	 }
 }
 %>