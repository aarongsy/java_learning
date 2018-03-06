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

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	String action=StringHelper.null2String(request.getParameter("action"));
	String requestid=StringHelper.null2String(request.getParameter("requestid"));
	
	String err="";	
    String passpsn="";
	String failpsn="";
	JSONObject jo = new JSONObject();	
	
	if ( "createshsd".equals(action) ) 
	{
		String sql="select a.*,a.state state1,b.*,b.state state2,b.isvalid isvalid2 from uf_hr_bmpxjh a,uf_hr_bmpxjhdetail b where a.requestid='"+requestid+"' and b.requestid=a.requestid order by b.no asc";
		System.out.println("创建部门培训实施申请单:"+sql);
   		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0)
		{ 
			for (int i=0; i < list.size(); i++) 
			{
				Map map = (Map)list.get(i);
				String isdelete="0";
				String year = StringHelper.null2String(map.get("year")); //年度
				String dept = StringHelper.null2String(map.get("dept")); //培训部门
				String comtype = StringHelper.null2String(map.get("comtype")); //厂区别
				String company = StringHelper.null2String(map.get("company")); //所属公司
				String cocode = StringHelper.null2String(map.get("cocode")); //公司代码
				String flowno2 = StringHelper.null2String(map.get("flowno2")); //培训部门申请单号
				String leixing = StringHelper.null2String(map.get("leixing")); //培训类型
				String duixiang = StringHelper.null2String(map.get("duixiang")); //培训对象
				String keti = StringHelper.null2String(map.get("keti")); //培训课题
				String jiangshi = StringHelper.null2String(map.get("jiangshi")); //培训讲师
				String jsno = StringHelper.null2String(map.get("jsno")); //培训讲师工号
				String keshi = StringHelper.null2String(map.get("keshi")); //预计课时
				String jhtime = StringHelper.null2String(map.get("shijian")); //计划培训日期
				String renshu = StringHelper.null2String(map.get("renshu")); //计划参加人数
				String fankui = StringHelper.null2String(map.get("fankui")); //反馈（实施单）
				String reqman = StringHelper.null2String(map.get("reqman"));
				String state = StringHelper.null2String(map.get("state1")); //新增/修改
				String isvalid = StringHelper.null2String(map.get("isvalid2")); //是否有效
				String state2 = StringHelper.null2String(map.get("state2")); //原始/新增/作废
				String no = StringHelper.null2String(map.get("no")); 
				
				String sql2="select isdelete from requestbase where id='"+fankui+"'";
				List list2 = baseJdbc.executeSqlForList(sql2);
				if(list2.size()>0)
				{
					Map map2 = (Map)list2.get(0);
					isdelete = StringHelper.null2String(map2.get("isdelete"));
				}
				
				if (isvalid.equals("40288098276fc2120127704884290210")&&(fankui.equals("")||isdelete.equals("1")))   //有效
				{
					String formula = "BMSSYYYYMMDD";
					String id = "40285a90490d16a301491cb543092c45";
					int len = 5;
					Date newdate = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
					SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
					SimpleDateFormat sdf2 = new SimpleDateFormat("dd");
					formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
					formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
					formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
					formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));
					String o = NumberHelper.getSequenceNo(id, len);
					String flowno=formula + o;
				  System.out.println("单号:"+flowno);
					
					WorkflowServiceImpl workflowServiceImpl=new WorkflowServiceImpl();
					RequestInfo rs=new RequestInfo();
					rs.setCreator(reqman);
					rs.setTypeid("40285a90490d16a301491cb185532bb2");   //流程id
					rs.setIssave("1"); //1 保存 0 提交
					//rs.setIssave("0"); //1 保存 0 提交
					Dataset data=new Dataset();
					List<Cell> list1=new ArrayList<Cell>();
					 
					Cell cell1=new Cell(); 
					cell1.setName("flowno1");
					cell1.setValue(flowno);
					list1.add(cell1);
					
					cell1=new Cell(); 
					cell1.setName("year1");
					cell1.setValue(year);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("dept1");
					cell1.setValue(dept);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("comtype1");
					cell1.setValue(comtype);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("company1");
					cell1.setValue(company);
					list1.add(cell1);
                      
					cell1=new Cell();		
					cell1.setName("cocode1");
					cell1.setValue(cocode);
					list1.add(cell1);


					cell1=new Cell();		
					cell1.setName("flowno21");
					cell1.setValue(requestid);
					list1.add(cell1);
							
					cell1=new Cell();		
					cell1.setName("leixing1");
					cell1.setValue(leixing);
					list1.add(cell1);
					
					cell1=new Cell();		
					cell1.setName("duixiang1");
					cell1.setValue(duixiang);
					list1.add(cell1);
							
					cell1=new Cell();		
					cell1.setName("keti1");
					cell1.setValue(keti);
					list1.add(cell1);
							
					cell1=new Cell();		
					cell1.setName("jiangshi1");
					cell1.setValue(jiangshi);
					list1.add(cell1);
							
					cell1=new Cell();		
					cell1.setName("jsno1");
					cell1.setValue(jsno);
					list1.add(cell1);	

					cell1=new Cell();		
					cell1.setName("keshi1");
					cell1.setValue(keshi);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("jhtime1");
					cell1.setValue(jhtime);
					list1.add(cell1);

					cell1=new Cell();		
					cell1.setName("renshu1");
					cell1.setValue(renshu);
					list1.add(cell1);


					data.setMaintable(list1);
					rs.setData(data);
                    String str1 = workflowServiceImpl.createRequest(rs);

					String upsql1 = "update uf_hr_bmpxjhdetail set fankui='"+str1+"' where requestid='"+requestid+"' and no='"+no+"'";	
				  System.out.println(upsql1);
                    baseJdbc.update(upsql1);
					
					passpsn =passpsn+ ";"+keti;
				}
				else if (isvalid.equals("40288098276fc2120127704884290211")&&(!fankui.equals(""))&&(!isdelete.equals("1")))   //无效
				{
					  System.out.println("状态为修改并为无效：");
						String delsql = "update requestbase set isdelete=1 where id='"+fankui+"'";
						baseJdbc.update(delsql);
				}
				else if (isvalid.equals("40288098276fc2120127704884290210")&&(!fankui.equals("")&&!isdelete.equals("1")))   //有效
				{
					String upsql33 = "update uf_hr_deptimple set flowno21='"+requestid+"' where requestid='"+fankui+"'";	
					baseJdbc.update(upsql33);
					err = "3";
					failpsn = failpsn+ ";"+keti;
				}
				else
				{
					err = "3";
					failpsn = failpsn+ ";"+keti;
				}
			}
		}
		else
		{
			err = "2";
		}
	

	}else{
		err="1";
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
