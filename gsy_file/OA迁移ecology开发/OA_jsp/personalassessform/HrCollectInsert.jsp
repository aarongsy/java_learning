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
String effectday=StringHelper.null2String(request.getParameter("effectday"));//生效日期
String comtype=StringHelper.null2String(request.getParameter("comtype"));//厂区别
BaseJdbcDao baseJdbc = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

//清空历史数据(职位晋升汇总子表)
String sql1="delete from uf_hr_promochild where requestid='"+requestid+"'";
baseJdbc.update(sql1);
//查询部门职位晋升表中的数据
//String sql2="select * from uf_hr_departpromotapp where takeeffectdate='"+effectday+"'";
//String sql2="select a.*,( select max(jcdedept)  from uf_hr_pundept where dept =(select orgid from humres where id=a.employname)) as  jcdedept from uf_hr_departpromotapp a left join requestbase re on a.requestid=re.id where a.takeeffectdate='"+effectday+"' and 1=re.isfinished and 0=re.isdelete and not exists(select b.employno from uf_hr_promochild b left join uf_hr_departpromotapp c on b.employno=c.employno where  0=(select isdelete from requestbase where id=b.requestid) and c.takeeffectdate='"+effectday+"' and b.employno=a.employno ) and instr('"+comtype+"',(select extrefobjfield5 from humres where id=a.employname))>0 order by a.employno";
//String sql2="select b.extmrefobjfield8 firstdepartid,b.objno employno,b.id employname,b.extdatefield0 intofactorydate,b.extselectitemfield4 education,a.currecttitle,a.currectrank,a.currecttitledate,a.yearscore,a.recommtitle,a.recommrank,a.addrank,(select objname from orgunittype where id=b.extrefobjfield5) factorytype,a.manageorbusiness,d.checkyear,b.extrefobjfield4,(select zjlevel from uf_profe where requestid=b.extrefobjfield4) zjlevel,(select max(currectdate) from uf_hr_curemploydate t where  t.employno=b.id) as currectdate,(select classify from uf_profe  where requestid=b.extrefobjfield4) as classify,( select max(jcdedept)  from uf_hr_pundept where dept =(select orgid from humres where id=b.id)) as  jcdedept from uf_hr_checkperformance d left join  humres b on b.id=d.employname left join requestbase req1 on req1.id=d.requestid left join uf_hr_departpromotapp a on b.id =a.employname and 1=(select re.isfinished from requestbase re where a.requestid=re.id ) and 0=(select re.isdelete from requestbase re where a.requestid=re.id ) and a.takeeffectdate='"+effectday+"' where  0=b.isdelete and not exists(select c.employname from uf_hr_promochild c where  0=(select isdelete from requestbase where id=c.requestid) and c.effectdate='"+effectday+"' and c.employname=b.id) and instr('"+comtype+"',(select extrefobjfield5 from humres where id=b.id))>0 and b.hrstatus='4028804c16acfbc00116ccba13802935' and (b.extselectitemfield14 is null or b.extselectitemfield14='40288098276fc2120127704884290211') and 1=req1.isfinished and 0=req1.isdelete order by a.employno";


String sql2="select b.extmrefobjfield8 firstdepartid,b.objno employno,b.id employname,b.extdatefield0 intofactorydate,b.extselectitemfield4 education,a.currecttitle,a.currectrank,a.currecttitledate,a.yearscore,a.recommtitle,a.recommrank,a.addrank,(select objname from orgunittype where id=b.extrefobjfield5) factorytype,a.manageorbusiness,d.checkyear,b.extrefobjfield4,(select zjlevel from uf_profe where requestid=b.extrefobjfield4) zjlevel,(select max(currectdate) from uf_hr_curemploydate t where  t.employno=b.id) as currectdate,(select classify from uf_profe  where requestid=b.extrefobjfield4) as classify,( select max(jcdedept)  from uf_hr_pundept where dept =(select orgid from humres where id=b.id)) as  jcdedept from uf_hr_checkperformance d left join  humres b on b.id=d.employname left join requestbase req1 on req1.id=d.requestid left join uf_hr_departpromotapp a on b.id =a.employname and 1=(select re.isfinished from requestbase re where a.requestid=re.id ) and 0=(select re.isdelete from requestbase re where a.requestid=re.id ) and a.takeeffectdate='"+effectday+"' where  0=b.isdelete and not exists(select c.employname from uf_hr_promochild c where  0=(select isdelete from requestbase where id=c.requestid) and c.effectdate='"+effectday+"' and c.employname=b.id) and instr('"+comtype+"',(select extrefobjfield5 from humres where id=b.id))>0 and ((b.hrstatus='4028804c16acfbc00116ccba13802935' and (b.extselectitemfield14 is null or b.extselectitemfield14='40288098276fc2120127704884290211')) or (b.objno='C1128' or b.objno='C2272' or b.objno='C2276' or b.objno='C2295' or b.objno='C2966' or b.objno='C3308' or b.objno='C3375'or b.objno='C3874' or b.objno='C3926' or b.objno='C3943' or b.objno='C3966' or b.objno='C3974' or b.objno='C3980' or b.objno='C1233' or b.objno='U1088')) and 1=req1.isfinished and 0=req1.isdelete order by a.employno";
System.out.println("啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊："+sql2);

 List sublist = baseJdbc.executeSqlForList(sql2);
 if(sublist.size()>0)
 {
	 for(int i=0;i<sublist.size();i++)
	 {
		 Map map=(Map)sublist.get(i);
		 String Employdepart=StringHelper.null2String(map.get("firstdepartid"));//所属部门
		 String Employno=StringHelper.null2String(map.get("employno"));//员工工号
		 String Employname=StringHelper.null2String(map.get("employname"));//员工姓名
		 String Intofactorydate=StringHelper.null2String(map.get("intofactorydate"));//入厂日期
		 String Education=StringHelper.null2String(map.get("education"));//学历
		 String Currecttitle=StringHelper.null2String(map.get("currecttitle"));//现任职称
		 String Currectrank=StringHelper.null2String(map.get("currectrank"));//现任职级数
		 String Currecttitledate=StringHelper.null2String(map.get("currecttitledate"));//现任职日期
		 String Yearscore=StringHelper.null2String(map.get("yearscore"));//年度评分
		 String Recommtitle=StringHelper.null2String(map.get("recommtitle"));//建议升调职称
		 String Recommrank=StringHelper.null2String(map.get("recommrank"));//建议升调职级数
		 String Addrank=StringHelper.null2String(map.get("addrank"));//增加级数
		 String Factorytype=StringHelper.null2String(map.get("factorytype"));//厂区别
		 String Manageorbusiness=StringHelper.null2String(map.get("manageorbusiness"));//职称分类
		 //String Firstdepartid=StringHelper.null2String(map.get("firstdepartid"));//一级部门32位序列号
		 String Firstdepartid=StringHelper.null2String(map.get("jcdedept"));//一级部门32位序列号
		 String Checkyear=StringHelper.null2String(map.get("checkyear"));//当前考核年度
		 if(Currecttitle.equals("")||Currecttitle.equals("null"))
		 {
			Currecttitle=StringHelper.null2String(map.get("extrefobjfield4"));//职称
			Currectrank=StringHelper.null2String(map.get("zjlevel"));//职级
			Currecttitledate=StringHelper.null2String(map.get("currectdate"));//现任职日期
			Manageorbusiness=StringHelper.null2String(map.get("classify"));//职称分类

			Recommtitle=StringHelper.null2String(map.get("extrefobjfield4"));//建议升调职称
			Recommrank=StringHelper.null2String(map.get("zjlevel"));//建议升调职级数
			Addrank="0";//增加级数

		 }
		 System.out.println(Yearscore);
		 if(Yearscore.equals("")||Yearscore.equals("null"))
		 {
			String sql4="select a.lastscore as totalscore from uf_checkcollectchild a left join uf_checkcollectmain b on a.requestid=b.requestid left join requestbase res on res.id=b.requestid where 1=res.isfinished and 0=res.isdelete and b.checkyear=(select id from selectitem where objname='"+Checkyear+"' and typeid='40285a8d4e677bb5014e6b38ea783c68') and a.employno=(select objno from humres where id='"+Employname+"')";
			System.out.println(sql4);
			List list = baseJdbc.executeSqlForList(sql4);
			 if(list.size()>0)
			 {
					 Map map1=(Map)list.get(0);
					 Yearscore=StringHelper.null2String(map1.get("totalscore"));//年度评分
			 }
		 }

		 //将从部门职位晋升表中取得的数据插入职位晋升汇总子表
		 String sql3="insert into uf_hr_promochild(id,requestid,employno,currectrank,currectdate,yearscore,recommrank,addrank,hrmodifyrank,addrankaftermod,hrleadmodadvice,managermodadvice,ordernum,department,employname,education,currecttitle,recommtitle,intofactorydate,hrmodifytitle,factype,effectdate,ranktype,firstdepart,checkyear)values((select sys_guid() from dual),'"+requestid+"','"+Employno+"','"+Currectrank+"','"+Currecttitledate+"','"+Yearscore+"','"+Recommrank+"','"+Addrank+"','"+Recommrank+"','"+Addrank+"','','',"+(i+1)+",'"+Employdepart+"','"+Employname+"','"+Education+"','"+Currecttitle+"','"+Recommtitle+"','"+Intofactorydate+"','"+Recommtitle+"','"+Factorytype+"','"+effectday+"','"+Manageorbusiness+"','"+Firstdepartid+"','"+Checkyear+"')";
		 baseJdbc.update(sql3);
	 }
 }
 %>