

package com.eweaver.sysinterface.extclass; 
 
 import com.eweaver.base.*; 
 import com.eweaver.base.security.service.acegi.EweaverUser; 
 import com.eweaver.sysinterface.base.Param; 
 import com.eweaver.sysinterface.javacode.EweaverExecutorBase; 
import java.util.List;
import java.util.Map;
import com.eweaver.base.BaseContext;
import com.eweaver.base.BaseJdbcDao;
import com.eweaver.base.util.StringHelper;

//import com.eweaver.base.*;
import com.eweaver.base.util.*;
import java.util.*;
import com.eweaver.interfaces.model.Dataset;
import com.eweaver.interfaces.workflow.RequestInfo;
import com.eweaver.interfaces.workflow.WorkflowServiceImpl;
import com.eweaver.interfaces.model.Cell;

//import com.eweaver.app.autotask.CreateWorkflow;
 public class Ewv20141125130804 extends EweaverExecutorBase{ 

 
 @Override 
 public void doExecute (Param params) {
  
     String requestid = this.requestid;//当前流程requestid 
     BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
     String sql="select a.jobname from uf_hr_probation a where a.requestid ='"+requestid+"'";

     List list = baseJdbc.executeSqlForList(sql);
	 if(list.size()>0){
        Map map = (Map)list.get(0);
		String jobname = StringHelper.null2String(map.get("jobname"));//员工ID
		//应评核次数Nums、已评核次数hadnum、已完成评核次数finishnum
		sql="select case when r.Nums>r.hadnum then 0 when r.Nums=r.hadnum and r.finishnum<r.Nums then 0 when r.Nums=r.hadnum and r.finishnum=r.Nums then 1 else 0 end phfinished,hrs.id,hrs.objname,hrs.objno,hrs.orgid,e.isuploaded from (select a.OBJNAME,a.OBJNO,a.Nums ,a.hadnum,( select count(b.flowno) finishnum from uf_hr_probation b,requestbase c where b.requestid=c.id and c.isfinished='1' and  b.jobname='"+jobname+"'  ) finishnum,a.TWODEPT,og.mstationid from v_uf_hr_probation a,orgunit og where a.twodept=og.id and a.OBJNAME='"+jobname+"' ) r left join humres hrs on ( InStr(hrs.station,r.mstationid)>0 or InStr(hrs.mainstation,r.mstationid)>0 ) left join (select isuploaded,id from  v_uf_hr_expreport) e on e.id=r.OBJNAME";
		
    	List list1 = baseJdbc.executeSqlForList(sql);
	 	if(list1.size()>0){
      	  	Map m = (Map)list1.get(0);
			String phfinished = StringHelper.null2String(m.get("phfinished"));//评核结束标记	1：可触发转正 0：不可触发
			System.out.println("SYQPH phfinished="+phfinished);
        	if(phfinished.equals("1")){
				//调用方法，自动创建试用期转正流程。。。
            	System.out.println("auto start ......Creatr SYQZH APPLY");
				String leaderid = StringHelper.null2String(m.get("id")); //部门主管
				String xdbg = StringHelper.null2String(m.get("isuploaded")); //心得份数
				//自动触发流程代码 start    			
    			WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
    			RequestInfo request=new RequestInfo();
    			request.setCreator(leaderid);//人员ID可以通过上面的流程取到
    			request.setTypeid("40285a8f489c17ce0148f3a93abb6cf7");//指定的流程类型id
				//request.setIssave("1"); //1 保存 0 提交
    			Dataset data=new Dataset();
    			List<Cell> listApp=new ArrayList<Cell>();
			
				String sql1 = "select (select to_char(sysdate,'yyyy-mm-dd hh:mm:ss') from dual) curtime,a.objname staff,a.objno gh,a.orgid bm,a.extselectitemfield11 ygz,b.objdesc ygzm,a.extselectitemfield12 ygzz,c.objdesc ygzzm,a.extselectitemfield4 xl,a.mainstation gw,a.extrefobjfield5 cqb,a.extrefobjfield5 yjbm,a.extmrefobjfield7 ejbm,a.extrefobjfield4 zc,a.extdatefield8 syks,a.extdatefield9 syjs,extmrefobjfield9 gs,to_char(to_date(a.extdatefield9,'yyyy-mm-dd')+1,'yyyy-mm-dd') zzrq,d.objname deptname from humres a  left join (select objdesc,id from selectitem) b on b.id=a.extselectitemfield11 left join (select objdesc,id from selectitem) c on c.id=a.extselectitemfield12 left join (select objname,id from orgunit) d on a.orgid=d.id  where a.id='"+jobname+"'";
				List listpsn = baseJdbc.executeSqlForList(sql1);
				if(listpsn.size()>0){ 
					Map mpsn = (Map)listpsn.get(0);
					String staff = StringHelper.null2String(mpsn.get("staff")); 
					String gh =  StringHelper.null2String(mpsn.get("gh")); 
					String dept = StringHelper.null2String(mpsn.get("bm"));  
					String ygz = StringHelper.null2String(mpsn.get("ygz")); 
					String ygzm = StringHelper.null2String(mpsn.get("ygzm")); 
					String ygzz = StringHelper.null2String(mpsn.get("ygzz")); 
					String ygzzm = StringHelper.null2String(mpsn.get("ygzzm")); 
					String xl = StringHelper.null2String(mpsn.get("xl"));
					String gw = StringHelper.null2String(mpsn.get("gw")); 	
					String cqb = StringHelper.null2String(mpsn.get("cqb"));
					String yjbm = StringHelper.null2String(mpsn.get("yjbm")); 	
					String ejbm = StringHelper.null2String(mpsn.get("ejbm"));
					String gs = StringHelper.null2String(mpsn.get("gs"));
					String zc = StringHelper.null2String(mpsn.get("zc")); 
					String syks = StringHelper.null2String(mpsn.get("syks")); //systartdate
					String syjs = StringHelper.null2String(mpsn.get("syjs")); //syenddate
					String zzrq = StringHelper.null2String(mpsn.get("zzrq")); //zzdate
					String curtime = StringHelper.null2String(mpsn.get("curtime")); 
					String deptname = StringHelper.null2String(mpsn.get("deptname")); 
					

					Cell cell1=new Cell();		
					cell1.setName("title");//标题
					cell1.setValue("试用期转正:"+staff+"-"+deptname);
					listApp.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("reqman");//填单人
					cell1.setValue(leaderid);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("reqdate");//填单时间
					cell1.setValue(curtime);
					listApp.add(cell1);						
					
					cell1=new Cell();		
					cell1.setName("jobno");//工号
					cell1.setValue(gh);
					listApp.add(cell1);			
			
					cell1=new Cell();		
					cell1.setName("objname");//姓名
					cell1.setValue(jobname);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("objdept");//所属部门
					cell1.setValue(dept);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("education");//学历
					cell1.setValue(xl);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("orgunit");//岗位
					cell1.setValue(gw);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("turntype");//转正类型
					cell1.setValue("40285a8f489c17ce0148f375d9d96775"); 
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("nunit");//员工组
					cell1.setValue(ygz);
					listApp.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("field1");//员工组名
					cell1.setValue(ygzm);
					listApp.add(cell1);	 					

					cell1=new Cell();		
					cell1.setName("nunitsub");//员工子组
					cell1.setValue(ygzz);
					listApp.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("field3");//员工子组名
					cell1.setValue(ygzzm);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("lnunit");//转正后员工组
					cell1.setValue("40285a8f489c17ce0148f371f989673d");
					listApp.add(cell1);	
					
					cell1=new Cell();		
					cell1.setName("field2");//转正后员工组名
					cell1.setValue("正式员工");
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("systartdate");//试用开始
					cell1.setValue(syks);
					listApp.add(cell1);						

					cell1=new Cell();		
					cell1.setName("syenddate");//试用结束
					cell1.setValue(syjs);
					listApp.add(cell1);	 

					cell1=new Cell();		
					cell1.setName("zzdate");//转正日期
					cell1.setValue(zzrq);
					listApp.add(cell1);	 

					cell1=new Cell();		
					cell1.setName("report");//心得份数
					cell1.setValue(xdbg);
					listApp.add(cell1);	 	

					cell1=new Cell();		
					cell1.setName("oldzc");//职称
					cell1.setValue(zc);
					listApp.add(cell1);	

					cell1=new Cell();		
					cell1.setName("comtype");//厂区别
					cell1.setValue(cqb);
					listApp.add(cell1);

					cell1=new Cell();		
					cell1.setName("onedept");//一级部门
					cell1.setValue(yjbm);
					listApp.add(cell1);	 	

					cell1=new Cell();		
					cell1.setName("twodept");//二级部门
					cell1.setValue(ejbm);
					listApp.add(cell1);	 	

					cell1=new Cell();		
					cell1.setName("reqcom");//所属公司
					cell1.setValue(gs);
					listApp.add(cell1);	 
					
					cell1=new Cell();		
					cell1.setName("openmode");//自动创建
					cell1.setValue("1");
					listApp.add(cell1);	 					
					
				}
				data.setMaintable(listApp);
    			request.setData(data);
    			requestid = workflowServiceImpl.createRequest(request);//生成流程    			
    			//生成流程END
    			System.out.println("auto END ZZAPP......"+requestid);
        	}
     	}
   	} 
 } 
 }




