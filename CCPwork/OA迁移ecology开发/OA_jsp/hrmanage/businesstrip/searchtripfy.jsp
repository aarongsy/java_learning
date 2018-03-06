<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.fr.third.org.apache.poi.hssf.record.formula.functions.Int"%>
<%@ page import="jxl.biff.IntegerHelper"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.label.service.LabelService" %>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
		System.out.println("出差费用查询开始！");
		//sdate:sdate,edate:edate,objname:objname,objno:objno,sapno:sapno,area:area,ctype:ctype,btype:btype
		BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
		String sdate1=StringHelper.null2String(request.getParameter("sdate"));//开始日期
		String edate1=StringHelper.null2String(request.getParameter("edate"));//结束日期
		String objno=StringHelper.null2String(request.getParameter("objno"));//工号
		String appno=StringHelper.null2String(request.getParameter("appno"));//所属部门
		String dept=StringHelper.null2String(request.getParameter("dept"));
		String delsql="delete from uf_hr_tirpfyf ";
		baseJdbc.update(delsql);
		DataService otherdataservices = new DataService();
		String where="";
		if(!sdate1.equals(""))
		{
			where=where+" and c.sdate>='"+sdate1+"'";
		}
		if(!edate1.equals(""))
		{
			where=where+" and c.edate<='"+edate1+"'";
		}
		if(!objno.equals(""))
		{
			where=where+" and c.psnno='"+objno+"'";
		}
		if(!appno.equals(""))
		{
			where=where+" and c.flowno like '%"+appno+"%'";
		}
		if(!dept.equals(""))
		{
			where=where+" and c.objdept='"+dept+"'";
		}
		int no=0;
		//String sql="select c.requestid tripid,c.flowno tripnum,c.psnno,c.psnname,c.objdept,c.sdate,c.stime,c.edate,c.etime,a.requestid  bxid,a.TRIPNO,a.TRIPNO2,a.TRIPNO3,a.flowno bxnum,a.allmoney,a.staffno,a.staffname,a.deptname,a.acdocnum,a.allzsf,a.allbreak breakfast,a.alllunch lunch,a.alldinner dinner,a.allhsf,a.allczc czcmon,a.alljtf jtfmon,a.alljjf jjfmon,a.allother othermon,(select flowno from uf_oa_cararrange  where  requestid=f.cararrno) pc,(SELECT  flowno from uf_oa_carapp   where requestid=f.carappno) yc,f.bcf,f.jbf,f.dbf,f.glf,f.tcf,f.yf,f.fjf,f.zcf,f.amount,f.notax,f.tax,b.fee,b.tax tax1 ,b.tax2 from uf_hr_businesstrip  c left join  uf_hr_tripexpense a  on c.reqno=a.requestid and 0=(select isdelete from requestbase where id=a.requestid) left join  uf_oa_caruserdetail e on e.files2=c.requestid and 0=(select isdelete from requestbase where id=e.requestid) left join  uf_oa_carreconsub  f on e.id=f.detailno and 0=(select isdelete from requestbase where id=f.requestid) left join v_tripticfy b on b.travelno=c.requestid where 0=(select isdelete from requestbase where id=c.requestid)";
		String sql="select c.requestid tripid,c.flowno tripnum,c.psnno,c.psnname,c.objdept,c.sdate,c.stime,c.edate,c.etime,a.requestid  bxid,a.TRIPNO,a.TRIPNO2,a.TRIPNO3,a.flowno bxnum,a.allmoney,a.staffno,a.staffname,a.deptname,a.acdocnum,a.allzsf,a.allbreak breakfast,a.alllunch lunch,a.alldinner dinner,a.allhsf,a.allczc czcmon,a.alljtf jtfmon,a.alljjf jjfmon,a.allother othermon,wm_concat(f.cararrno) pc,wm_concat(f.carappno) yc,sum(f.bcf) bcf,sum(f.jbf) jbf,sum(f.dbf) dbf,sum(f.glf) glf,sum(f.tcf) tcf,sum(f.yf) yf,sum(f.fjf) fjf,sum(f.zcf) zcf,sum(f.amount) amount,sum(f.notax) notax,sum(f.tax) tax,b.fee,b.tax tax1 ,b.tax2 from uf_hr_businesstrip  c left join  uf_hr_tripexpense a  on c.requestid=a.tripno and 0=(select isdelete from requestbase where id=a.requestid) and 1=(select isfinished from requestbase where id=a.requestid) left join  uf_oa_caruserdetail e on e.files2=c.requestid and 0=(select isdelete from requestbase where id=e.requestid) left join  uf_oa_carreconsub  f on e.id=f.detailno and 0=(select isdelete from requestbase where id=f.requestid) left join v_tripticfy b on b.travelno=c.requestid where 0=(select isdelete from requestbase where id=c.requestid)";
		sql=sql+where;
		sql=sql+"  group by c.requestid,c.flowno,c.psnno,c.psnname,c.objdept,c.sdate,c.stime,c.edate,c.etime,a.requestid,a.TRIPNO,a.TRIPNO2,a.TRIPNO3,a.flowno,a.allmoney,a.staffno,a.staffname,a.deptname,a.acdocnum,a.allzsf,a.allbreak ,a.alllunch ,a.alldinner ,a.allhsf,a.allczc ,a.alljtf ,a.alljjf ,a.allother ,b.fee,b.tax ,b.tax2";
		System.out.println(sql);
		List list = baseJdbc.executeSqlForList(sql);
		Map map=null;
		System.out.println("-----------------"+list.size());
		if(list.size()>0){
			for(int k=0;k<list.size();k++)
			{
				map = (Map)list.get(k);
				String tripid=StringHelper.null2String(map.get("tripid"));
				String tripnum=StringHelper.null2String(map.get("tripnum"));
				String psnno=StringHelper.null2String(map.get("psnno"));
				String psnname=StringHelper.null2String(map.get("psnname"));
				String objdept=StringHelper.null2String(map.get("objdept"));
				String sdate=StringHelper.null2String(map.get("sdate"));
				String stime=StringHelper.null2String(map.get("stime"));
				String edate=StringHelper.null2String(map.get("edate"));
				String etime=StringHelper.null2String(map.get("etime"));
				String bxid=StringHelper.null2String(map.get("bxid"));
				String TRIPNO=StringHelper.null2String(map.get("TRIPNO"));
				String TRIPNO2=StringHelper.null2String(map.get("TRIPNO2"));
				String TRIPNO3=StringHelper.null2String(map.get("TRIPNO3"));
				String bxnum=StringHelper.null2String(map.get("bxnum"));
				String allmoney=StringHelper.null2String(map.get("allmoney"));
				if(allmoney.equals(""))
				{
					allmoney="null";
				}
				String staffno=StringHelper.null2String(map.get("staffno"));
				String staffname=StringHelper.null2String(map.get("staffname"));
				String deptname=StringHelper.null2String(map.get("deptname"));
				String acdocnum=StringHelper.null2String(map.get("acdocnum"));
				String allzsf=StringHelper.null2String(map.get("allzsf"));
				if(allzsf.equals(""))
				{
					allzsf="null";
				}
				String breakfast=StringHelper.null2String(map.get("breakfast"));
				if(breakfast.equals(""))
				{
					breakfast="null";
				}
				String lunch=StringHelper.null2String(map.get("lunch"));
				if(lunch.equals(""))
				{
					lunch="null";
				}
				String dinner=StringHelper.null2String(map.get("dinner"));
				if(dinner.equals(""))
				{
					dinner="null";
				}
				String allhsf=StringHelper.null2String(map.get("allhsf"));
				if(allhsf.equals(""))
				{
					allhsf="null";
				}
				String czcmon=StringHelper.null2String(map.get("czcmon"));
				if(czcmon.equals(""))
				{
					czcmon="null";
				}
				String jtfmon=StringHelper.null2String(map.get("jtfmon"));
				if(jtfmon.equals(""))
				{
					jtfmon="null";
				}
				String jjfmon=StringHelper.null2String(map.get("jjfmon"));
				if(jjfmon.equals(""))
				{
					jjfmon="null";
				}
				String othermon=StringHelper.null2String(map.get("othermon"));
				if(othermon.equals(""))
				{
					othermon="null";
				}
				String pc=StringHelper.null2String(map.get("pc"));
				String yc=StringHelper.null2String(map.get("yc"));
				String bcf=StringHelper.null2String(map.get("bcf"));
				if(bcf.equals(""))
				{
					bcf="null";
				}
				String jbf=StringHelper.null2String(map.get("jbf"));
				if(jbf.equals(""))
				{
					jbf="null";
				}
				String dbf=StringHelper.null2String(map.get("dbf"));
				if(dbf.equals(""))
				{
					dbf="null";
				}
				String glf=StringHelper.null2String(map.get("glf"));
				if(glf.equals(""))
				{
					glf="null";
				}
				String tcf=StringHelper.null2String(map.get("tcf"));
				if(tcf.equals(""))
				{
					tcf="null";
				}
				String yf=StringHelper.null2String(map.get("yf"));
				if(yf.equals(""))
				{
					yf="null";
				}
				String fjf=StringHelper.null2String(map.get("fjf"));
				if(fjf.equals(""))
				{
					fjf="null";
				}
				String zcf=StringHelper.null2String(map.get("zcf"));
				if(zcf.equals(""))
				{
					zcf="null";
				}
				String amount=StringHelper.null2String(map.get("amount"));
				if(amount.equals(""))
				{
					amount="null";
				}
				String notax=StringHelper.null2String(map.get("notax"));
				if(notax.equals(""))
				{
					notax="null";
				}
				String tax=StringHelper.null2String(map.get("tax"));
				if(tax.equals(""))
				{
					tax="null";
				}
				String fee=StringHelper.null2String(map.get("fee"));
				if(fee.equals(""))
				{
					fee="null";
				}
				String tax1=StringHelper.null2String(map.get("tax1"));
				if(tax1.equals(""))
				{
					tax1="null";
				}
				String tax2=StringHelper.null2String(map.get("tax2"));
				if(tax2.equals(""))
				{
					tax2="null";
				}
				no++;
				String insql="insert into uf_hr_tirpfyf   (id,requestid,tripid,tripnum,psnno,psnname,objdept,sdate,stime,edate,etime,bxid,TRIPNO,TRIPNO2,TRIPNO3,bxnum,allmoney,staffno,staffname,deptname,acdocnum,allzsf,breakfast,lunch,dinner,allhsf,czcmon,jtfmon,jjfmon,othermon,pc,yc,bcf,jbf,dbf,glf,tcf,yf,fjf,zcf,amount,notax,tax,fee,tax1,tax2)values((select sys_guid() from dual),'40285a90539c9d2d01539d6ff87467c5','"+tripid+"','"+tripnum+"','"+psnno+"','"+psnname+"','"+objdept+"','"+sdate+"','"+stime+"','"+edate+"','"+etime+"','"+bxid+"','"+TRIPNO+"','"+TRIPNO2+"','"+TRIPNO3+"','"+bxnum+"',"+allmoney+",'"+staffno+"','"+staffname+"','"+deptname+"','"+acdocnum+"',"+allzsf+","+breakfast+","+lunch+","+dinner+","+allhsf+","+czcmon+","+jtfmon+","+jjfmon+","+othermon+",'"+pc+"','"+yc+"',"+bcf+","+jbf+","+dbf+","+glf+","+tcf+","+yf+","+fjf+","+zcf+","+amount+","+notax+","+tax+","+fee+","+tax1+","+tax2+")";
				if(no<=50)
				{
				System.out.println(insql);
				}
				baseJdbc.update(insql);
				
			}
			System.out.println("出差费用查询结束！");
		}
%>
