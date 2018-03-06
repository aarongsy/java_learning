<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.humres.base.service.HumresService" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>
<%@ page import="com.eweaver.webservice.model.*"%>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.webservice.MpluginServiceImpl" %>
<%@ page import="com.eweaver.mobile.plugin.mode.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%

	
	

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	String cfdate=StringHelper.null2String(request.getParameter("date"));

	System.out.println("pureshare  action="+action+" cfdate="+cfdate);	
	
	//test：2014-08-13 //sysdate代替 评核日期提前15天创建评核申请单
	String sql = "select to_char(vf.today,'yyyy-mm-dd') today,to_char(vf.phks,'yyyy-mm-dd') phks, to_char(vf.today+15,'yyyy-mm-dd') phjs,vf.objno,vf.objname staff,vf.dt1,vf.dt2,vf.dt3,hrs.id,hrs.objname,hrs.orgid from ( select b.today today,b.objno objno,b.objname objname, b.dt1 dt1,b.dt2 dt2,b.dt3 dt3,b.nums nums,b.hadnum hadnum, b.twodept twodept,og.objname twodeptname,og.mstationid mstationid,case when b.today=b.dt1 then to_date(b.SYKS,'yyyy-mm-dd') when b.today=b.dt2 then to_date(b.FIRST,'yyyy-mm-dd')+1 when b.today=b.dt3 then to_date(b.SECOND,'yyyy-mm-dd')+1 end phks from (select to_date('"+cfdate+"' ,'yyyy-mm-dd') today,  a.OBJNO,a.OBJNAME,a.SYKS,a.FIRST,a.SECOND ,a.THIRD,a.Nums,  a.hadnum,to_date(a.FIRST,'yyyy-mm-dd')-15 dt1,  to_date(a.SECOND,'yyyy-mm-dd')-15 dt2,to_date(a.THIRD,'yyyy-mm-dd')-15 dt3,  a.TWODEPT twodept from v_uf_hr_probation a where a.hadnum is null or a.hadnum < a.nums) b ,orgunit og where b.twodept=og.id and (b.today=b.dt1 or b.today = b.dt2 or b.today = b.dt3 ) ) vf left join humres hrs on ( InStr(hrs.station,vf.mstationid)>0 or InStr(hrs.mainstation,vf.mstationid)>0 )";	
	
	
	/*当天取值 to_date(to_char(sysdate,'yyyy-mm-dd') ,'yyyy-mm-dd') 或 sysdate
	String sql = "select to_char(vf.today,'yyyy-mm-dd') today,to_char(vf.phks,'yyyy-mm-dd') phks, to_char(vf.today+15,'yyyy-mm-dd') phjs,vf.objno,vf.objname staff,vf.dt1,vf.dt2,vf.dt3,hrs.id,hrs.objname,hrs.orgid from ( select b.today today,b.objno objno,b.objname objname, b.dt1 dt1,b.dt2 dt2,b.dt3 dt3,b.nums nums,b.hadnum hadnum, b.twodept twodept,og.objname twodeptname,og.mstationid mstationid,case when b.today=b.dt1 then to_date(b.SYKS,'yyyy-mm-dd') when b.today=b.dt2 then to_date(b.FIRST,'yyyy-mm-dd')+1 when b.today=b.dt3 then to_date(b.SECOND,'yyyy-mm-dd')+1 end phks from (select to_date(to_char(sysdate,'yyyy-mm-dd') ,'yyyy-mm-dd') today, a.OBJNO,a.OBJNAME,a.SYKS,a.FIRST,a.SECOND ,a.THIRD,a.Nums,  a.hadnum,to_date(a.FIRST,'yyyy-mm-dd')-15 dt1,  to_date(a.SECOND,'yyyy-mm-dd')-15 dt2,to_date(a.THIRD,'yyyy-mm-dd')-15 dt3,  a.TWODEPT twodept from v_uf_hr_probation a where a.hadnum is null or a.hadnum < a.nums) b ,orgunit og where b.twodept=og.id and (b.today=b.dt1 or b.today = b.dt2 or b.today = b.dt3 ) ) vf left join humres hrs on ( InStr(hrs.station,vf.mstationid)>0 or InStr(hrs.mainstation,vf.mstationid)>0 )";		
	*/
	
	String err="";	
    String passpsn="";
	String failpsn="";
 	
	JSONObject jo = new JSONObject();
	
	List list = baseJdbc.executeSqlForList(sql);
	if(list.size()>0){ 
		System.out.println("auto start SYPH......");
		for(int i = 0; i < list.size(); i++){
			if(i==1){
				//break; //测试时使用
			}
			Map map = (Map)list.get(i);
			//String today = StringHelper.null2String(map.get("today"));
			String objno = StringHelper.null2String(map.get("objno"));
			if(objno.equals("C3745")){
			
			
			String staff = StringHelper.null2String(map.get("staff"));   
			//String dt1 = StringHelper.null2String(map.get("dt1")); 
			//String dt2 = StringHelper.null2String(map.get("dt2")); 
			//String dt3 = StringHelper.null2String(map.get("dt3")); 
			String leaderid = StringHelper.null2String(map.get("id")); 
			//String leadername = StringHelper.null2String(map.get("objname")); 
			//String leaderdeptid = StringHelper.null2String(map.get("orgid")); 
			String phks = StringHelper.null2String(map.get("phks")); 
			String phjs = StringHelper.null2String(map.get("phjs")); 
			// start    
			if(leaderid.equals("")){
				err ="1";
				failpsn = failpsn + ";"+objno;
			}else if(leaderid.equals("null")){
				err ="1";
				failpsn = failpsn + ";"+objno;
			}else{
				WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
				RequestInfo rs=new RequestInfo();
				rs.setCreator(leaderid); 
				rs.setTypeid("40285a9049d58e9e0149da332f610a3b");
				rs.setIssave("1"); 
				Dataset data=new Dataset();
				List<Cell> list1=new ArrayList<Cell>();
				Cell cell1=new Cell();
				cell1.setName("reqman");
				cell1.setValue(leaderid);
				list1.add(cell1);				
				
				cell1=new Cell();		
				cell1.setName("jobname");
				cell1.setValue(staff);
				list1.add(cell1);
				
				cell1=new Cell();		
				cell1.setName("jobno");
				cell1.setValue(staff);
				list1.add(cell1);
				
				cell1=new Cell();		
				cell1.setName("phstartdate");
				cell1.setValue(phks);
				list1.add(cell1);	

				cell1=new Cell();		
				cell1.setName("phenddate");
				cell1.setValue(phjs);
				list1.add(cell1);					
				
				String sql1 = "select a.objname name,a.objno gh,a.orgid bm,a.extselectitemfield11 ygz,b.objdesc ygzm,a.extselectitemfield12 ygzz,c.objdesc ygzzm,a.extselectitemfield4 xl,a.mainstation gw,a.extrefobjfield5 cqb,a.extrefobjfield5 yjbm,a.extmrefobjfield7 ejbm,a.extrefobjfield4 zc,a.extdatefield8 syks,a.extdatefield9 syjs,extmrefobjfield9 gs,d.objname deptname from humres a  left join (select objdesc,id from selectitem) b on b.id=a.extselectitemfield11 left join (select objdesc,id from selectitem) c on c.id=a.extselectitemfield12 left join (select objname,id from orgunit) d on a.orgid=d.id where a.id='"+staff+"'";
				List listpsn = baseJdbc.executeSqlForList(sql1);
				if(listpsn.size()>0){ 
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
					
				
					cell1=new Cell();		
					cell1.setName("title");
					cell1.setValue("试用期评核："+name+"-"+deptname);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("dept");
					cell1.setValue(dept);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("nunit");
					cell1.setValue(ygz);
					list1.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("field1");
					cell1.setValue(ygzm);
					list1.add(cell1);						
					
					cell1=new Cell();		
					cell1.setName("nunitsub");
					cell1.setValue(ygzz);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("field2");
					cell1.setValue(ygzzm);
					list1.add(cell1);					

					cell1=new Cell();		
					cell1.setName("education");
					cell1.setValue(xl);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("orgunit");
					cell1.setValue(gw);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("oldzc");
					cell1.setValue(zc);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("systartdate");
					cell1.setValue(syks);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("syenddate");
					cell1.setValue(syjs);
					list1.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("comtype");
					cell1.setValue(cqb);//cqb
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("onedept");
					cell1.setValue(yjbm);//yjbm
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("twodept");
					cell1.setValue(ejbm);//yjbm
					list1.add(cell1);					

					cell1=new Cell();		
					cell1.setName("openmode");
					cell1.setValue("1");//
					list1.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("reqcom");
					cell1.setValue(gs);//
					list1.add(cell1);

					data.setMaintable(list1);
					rs.setData(data);
					String requestid = workflowServiceImpl.createRequest(rs);			
					
					System.out.println("auto end SYPH......"+requestid);					
					passpsn = passpsn + ";"+name+"/"+gh;	
				}else{
					err ="1";
					failpsn = failpsn + ";"+objno;	
				}
			}
		  }else{ //指定人员
				
		  }
		}
	}else{
		err="0";
	}
	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passpsn",passpsn);
		jo.put("failpsn",failpsn);		
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("passpsn",passpsn);
		jo.put("failpsn",failpsn);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
