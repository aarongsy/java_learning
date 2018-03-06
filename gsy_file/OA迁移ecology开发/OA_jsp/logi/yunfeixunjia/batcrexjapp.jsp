<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="com.eweaver.app.configsap.SapConnector" %>
<%@ page import="com.sap.conn.jco.JCoException" %>
<%@ page import="com.sap.conn.jco.JCoFunction" %>
<%@ page import="com.sap.conn.jco.JCoTable" %>
<%@ page import="com.sap.conn.jco.JCoStructure" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>

<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>


<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
	DataService ds = new DataService();

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	String srctable =StringHelper.null2String(request.getParameter("srctable"));
	String destable =StringHelper.null2String(request.getParameter("destable"));
	
	String err="";	
    String passpsn="";
	String failpsn="";
	JSONObject jo = new JSONObject();	
	
	if ( "batcreatexj".equals(action) ) {
		String sql = "select biaoti,xjno,isvalid,xjtype,ysxjno,gzxj,xjperson,xjdate,dept,company,xjstart,bjend,state,cocode,leixing,bjtype,bjdate,yxstart,yxend,xjmx,beizhu,onedept,twodept,companyy from uf_lo_xunjia a,formbase b where a.requestid=b.id and b.isdelete=0 and a.requestid='"+requestid+"'";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){ 
			System.out.println("start create gys xunjia.....");
			Map map = (Map)list.get(0);
			String biaoti = StringHelper.null2String(map.get("biaoti"));
			String xjno = StringHelper.null2String(map.get("xjno"));
			String isvalid = StringHelper.null2String(map.get("isvalid"));
			if(!"40288098276fc2120127704884290210".equals(isvalid)) {
				err= "1";
			} else {
				String xjtype = StringHelper.null2String(map.get("xjtype"));
				String ysxjno = StringHelper.null2String(map.get("ysxjno"));
				String gzxj = StringHelper.null2String(map.get("gzxj"));
				String xjperson = StringHelper.null2String(map.get("xjperson"));
				String xjdate = StringHelper.null2String(map.get("xjdate"));
				String dept = StringHelper.null2String(map.get("dept"));
				String company = StringHelper.null2String(map.get("company")); //厂区别
				String xjstart = StringHelper.null2String(map.get("xjstart"));
				String bjend = StringHelper.null2String(map.get("bjend"));
				String state = StringHelper.null2String(map.get("state"));
				String cocode = StringHelper.null2String(map.get("cocode"));
				String leixing = StringHelper.null2String(map.get("leixing"));
				String bjtype = StringHelper.null2String(map.get("bjtype"));
				String bjdate = StringHelper.null2String(map.get("bjdate"));
				String yxstart = StringHelper.null2String(map.get("yxstart"));
				String yxend = StringHelper.null2String(map.get("yxend"));		
				String xjmx = StringHelper.null2String(map.get("xjmx"));
				String beizhu = StringHelper.null2String(map.get("beizhu"));	
				String onedept = StringHelper.null2String(map.get("onedept"));		
				String twodept = StringHelper.null2String(map.get("twodept"));
				String companyy = StringHelper.null2String(map.get("companyy")); //所属公司		
				
				
				String gyssql = "select xuhao,jianma ,(select concode from uf_lo_loginmatch where requestid=jianma) supcode,mingc,(select conname from uf_lo_consolidator where requestid=jianma) supname,zhangh,(select objname from humres where id=zhangh) ygname from uf_lo_xjgys where requestid='"+requestid+"' order by xuhao asc";
				
				List gyslist = baseJdbc.executeSqlForList(gyssql);
				if(gyslist.size()>0){ 		
					for (int i=0; i < gyslist.size(); i++) {
						Map gysmap = (Map)gyslist.get(i);
						String jianma = StringHelper.null2String(gysmap.get("jianma"));
						String mingc = StringHelper.null2String(gysmap.get("mingc"));
						String zhangh = StringHelper.null2String(gysmap.get("zhangh"));
						String supcode = StringHelper.null2String(gysmap.get("supcode"));
						String supname = StringHelper.null2String(gysmap.get("supname"));
						String ygname = StringHelper.null2String(gysmap.get("ygname"));						
						
						if ( !"".equals(zhangh) ) {
							int existflag = Integer.parseInt(ds.getValue("select count(*) num from uf_lo_xunjia a, requestbase b where a.requestid=b.id and b.isdelete=0 and a.xjno = '"+xjno+"' and a.gyszh = '"+zhangh+"'"));
							
							if( existflag==0 ) {
								//创建流程
								WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
								RequestInfo rs=new RequestInfo();
								rs.setCreator(userid); 
								rs.setTypeid("40285a8d57037256015708aba33f71f6");
								//rs.setIssave("1"); //1 保存 0 提交
								rs.setIssave("0"); //1 保存 0 提交
								Dataset data=new Dataset();
								List<Cell> list1=new ArrayList<Cell>();

								Cell cell1=new Cell(); 
								cell1.setName("biaoti");
								cell1.setValue(biaoti);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("gyszh");
								cell1.setValue(zhangh);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("xjno");
								cell1.setValue(xjno);
								list1.add(cell1);
								
								cell1=new Cell();		
								cell1.setName("isvalid");
								cell1.setValue(isvalid);
								list1.add(cell1);
								
								cell1=new Cell();		
								cell1.setName("xjtype");
								cell1.setValue(xjtype);
								list1.add(cell1);
								
								cell1=new Cell();		
								cell1.setName("ysxjno");
								cell1.setValue(ysxjno);
								list1.add(cell1);
								
								cell1=new Cell();		
								cell1.setName("gzxj");
								cell1.setValue(gzxj);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("xjperson");
								cell1.setValue(xjperson);
								list1.add(cell1);	
								
								cell1=new Cell();		
								cell1.setName("xjdate");
								cell1.setValue(xjdate);
								list1.add(cell1);

								cell1=new Cell();		
								cell1.setName("dept");
								cell1.setValue(dept);
								list1.add(cell1);

								cell1=new Cell();		
								cell1.setName("company");
								cell1.setValue(company);
								list1.add(cell1);

								cell1=new Cell();		
								cell1.setName("xjstart");
								cell1.setValue(xjstart);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("bjend");
								cell1.setValue(bjend);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("state");
								cell1.setValue(state);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("cocode");
								cell1.setValue(cocode);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("leixing");
								cell1.setValue(leixing);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("bjtype");
								cell1.setValue(bjtype);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("bjdate");
								cell1.setValue(bjdate);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("yxstart");
								cell1.setValue(yxstart);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("yxend");
								cell1.setValue(yxend);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("xjmx");
								cell1.setValue(xjmx);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("beizhu");
								cell1.setValue(beizhu);
								list1.add(cell1);	
								
								cell1=new Cell();		
								cell1.setName("onedept");
								cell1.setValue(onedept);
								list1.add(cell1);	

								cell1=new Cell();		
								cell1.setName("twodept");
								cell1.setValue(twodept);
								list1.add(cell1);	
								
								cell1=new Cell();		
								cell1.setName("companyy");
								cell1.setValue(companyy);
								list1.add(cell1);	


								data.setMaintable(list1);
								rs.setData(data);
								String xjapprequestid = workflowServiceImpl.createRequest(rs);	

								String delsql = "delete from  uf_lo_xjgys where requestid='"+xjapprequestid+"'";
								//System.out.println("delsql:"+delsql);
								baseJdbc.update(delsql);		
								
								String insql = "insert into uf_lo_xjgys (ID, REQUESTID, ROWINDEX,xuhao,jianma,mingc,zhangh) values ((select sys_guid() from dual),'"+xjapprequestid+"',substr('00' ||to_char(0),-3,3),'1','"+jianma+"','"+mingc+"','"+zhangh+"')";
								//System.out.println("insql:"+insql);
								baseJdbc.update(insql);						
								
								passpsn =passpsn+ ";"+supcode+"/"+supname+"/"+ygname;
								//System.out.println("获取到供应商员工id，创建运费询价流程 成功"+xjapprequestid 	+ "  "+jianma+"/"+mingc+"/"+zhangh);						
													
							}else{
								err = "4";
								failpsn = failpsn+ ";"+supcode+"/"+supname+"/"+ygname;
								//System.out.println("批量创建运费询价流程 失败 batcrexjapp.jsp requestid="+requestid+" xjno="+xjno+" jianma="+jianma+" mingc="+mingc+" has exists");
							}
						}else{
							err = "3";
							failpsn = failpsn+ ";"+supcode+"/"+supname+"/"+ygname;
							//System.out.println("批量创建运费询价流程 失败 batcrexjapp.jsp requestid="+requestid+" jianma="+jianma+" mingc="+mingc+" no zhangh");
						}
					}
				}else{
					err = "2";
				}
				System.out.println("start end gys xunjia.....");
			}
		}
	}else{
		err="0";
	}
	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passpsn",passpsn);
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
