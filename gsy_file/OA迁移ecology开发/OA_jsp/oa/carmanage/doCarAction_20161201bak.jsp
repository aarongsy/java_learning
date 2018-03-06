<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser" %>
<%@ page import="com.eweaver.humres.base.model.Humres" %>

<%@ page import="com.eweaver.interfaces.model.Dataset" %>
<%@ page import="com.eweaver.interfaces.workflow.WorkflowServiceImpl" %>
<%@ page import="com.eweaver.interfaces.workflow.RequestInfo" %>
<%@ page import="com.eweaver.interfaces.model.Cell" %>

<%@ page import="com.eweaver.base.util.DateHelper" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page import="com.eweaver.base.security.util.PermissionTool" %>
<%@ page import="com.eweaver.sysinterface.base.Param" %>
<%@ page import="com.eweaver.sysinterface.javacode.EweaverExecutorBase" %>
<%@ page import="com.eweaver.workflow.form.model.FormBase" %>
<%@ page import="com.eweaver.workflow.form.service.FormBaseService" %>
<%!
	/**
 * 取得字段自动编号
 * @param formula
 * @param id
 * @param len
 * @return
 */
	private String  getNo(String formula,String id,int len)
	{
        //if(fieldvalue!=null&&!fieldvalue.equals("")&&!fieldvalue.equals(formula))
        //return;
		Date newdate = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		SimpleDateFormat sdf1 = new SimpleDateFormat("MM");
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd");

		formula = formula.replaceAll("YYYY", new SimpleDateFormat("yyyy").format(newdate));
		formula = formula.replaceAll("MM", new SimpleDateFormat("MM").format(newdate));
		formula = formula.replaceAll("DD", new SimpleDateFormat("dd").format(newdate));
		formula = formula.replaceAll("YY", new SimpleDateFormat("yy").format(newdate));

	    String o = NumberHelper.getSequenceNo(id, len);
        return formula+o;
	}
%> 

<%
EweaverUser eweaveruser = BaseContext.getRemoteUser();
Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户

	BaseJdbcDao baseJdbc=(BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService ds = new DataService();
	String action=StringHelper.null2String(request.getParameter("action"));
	
	String err="";
	String failcarapp="";
	String passcarapp="";
	JSONObject jo = new JSONObject();	
	if(action.equals("createPJD")){
		String sql = "select a.requestid,a.carappnos,a.cartype,a.supplyname,a.carno,a.driver,a.drivertel,a.comtype from uf_oa_cararrange a where (a.stateflag is null or a.stateflag>0) and exists(select b.id from formbase b where a.requestid=b.id and b.isdelete=0)";
		List list = baseJdbc.executeSqlForList(sql);
		if(list.size()>0){ 
			for(int i=0; i < list.size(); i++){		
				Map map = (Map)list.get(i);
				String requestid = StringHelper.null2String(map.get("requestid"));
				String carappnos = StringHelper.null2String(map.get("carappnos"));
				String carappsql = "select distinct a.requestid,a.reqman,(select to_char(sysdate,'YYYY-MM-DD hh24:mi:ss') from dual) curtime,a.flowno from uf_oa_carapp a,requestbase b where a.requestid=b.id and b.isdelete=0 and b.isfinished=0 and a.stateflag='3' and instr('"+carappnos+"', a.requestid)>0";
				List carapplist = baseJdbc.executeSqlForList(carappsql);
				if(carapplist.size()>0){ 
				    for(int j=0; j < carapplist.size(); j++){		
					
						Map carappmap = (Map)carapplist.get(j);
						String carappreqid = StringHelper.null2String(carappmap.get("requestid"));
						String carflowno = StringHelper.null2String(carappmap.get("flowno"));
						Integer hascount = Integer.valueOf(ds.getValue("select count(a.carappno) from uf_oa_carevaluate a,formbase b where a.requestid=b.id and b.isdelete=0 and a.carappno='"+carappreqid+"' ")); 
						if(hascount==0){
							//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh24:mi:ss");
							//String Dtime = format.format(new Date());
							String flowno=getNo("YCPJYYYYMM","40285a8d4b7b329a014b8a99d35e4bea",4);//"YCPJ2015010001"
							String reqman = StringHelper.null2String(carappmap.get("reqman"));
							String reqdept = ds.getValue("select orgid from humres where ID ='"+reqman+"'");
							String reqdate = StringHelper.null2String(carappmap.get("curtime"));
							String carappno = StringHelper.null2String(carappmap.get("requestid"));
							
							String cartype = StringHelper.null2String(map.get("cartype"));
							String supplyname = StringHelper.null2String(map.get("supplyname"));
							String carno = StringHelper.null2String(map.get("carno"));
							String driver = StringHelper.null2String(map.get("driver"));
							String phoneno = StringHelper.null2String(map.get("drivertel"));
							String comtype = StringHelper.null2String(map.get("comtype"));
							
							StringBuffer buffer = new StringBuffer(512);
							buffer.append("insert into uf_oa_carevaluate").append("(id,requestid,flowno,reqman,reqdept,reqdate,comtype,carappno,cararrno,cartype,supplyname,carno,driver,phoneno,stateflag) values").append("('").append(IDGernerator.getUnquieID()).append("',").append("'").append("$ewrequestid$").append("',");

							buffer.append("'").append(flowno).append("',");//评价单号
							buffer.append("'").append(reqman).append("',");//评价人
							buffer.append("'").append(reqdept).append("',");//评价部门
							buffer.append("'").append(reqdate).append("',");//评价日期
							buffer.append("'").append(comtype).append("',");//厂区别
							buffer.append("'").append(carappno).append("',");//用车单号
							buffer.append("'").append(requestid).append("',");//排车单号
							buffer.append("'").append(cartype).append("',");//车辆性质
							buffer.append("'").append(supplyname).append("',");//租赁公司
							buffer.append("'").append(carno).append("',");//车牌号
							buffer.append("'").append(driver).append("',");//司机姓名			
							buffer.append("'").append(phoneno).append("',");//司机电话
							buffer.append("'40288098276fc2120127704884290211')");//是否已评价

							FormBase formBase = new FormBase();
							String categoryid = "40285a8d4b7b329a014b8ae9c40353c9";
							//创建formbase
							formBase.setCreatedate(DateHelper.getCurrentDate());
							formBase.setCreatetime(DateHelper.getCurrentTime());
							//formBase.setCreator(StringHelper.null2String(userId));
							formBase.setCreator(StringHelper.null2String(reqman));
							formBase.setCategoryid(categoryid);
							formBase.setIsdelete(0);
							FormBaseService formBaseService = (FormBaseService)BaseContext.getBean("formbaseService");
							formBaseService.createFormBase(formBase);
							String insertSql = buffer.toString();
							insertSql = insertSql.replace("$ewrequestid$",formBase.getId());
							baseJdbc.update(insertSql);
							PermissionTool permissionTool = new PermissionTool();
							permissionTool.addPermission(categoryid,formBase.getId(), "uf_oa_carevaluate");	

							System.out.println(carflowno + " created YCPJD successfully");					
							passcarapp=passcarapp+";"+carflowno;
						}else{
							err = "2"; //用车单已经存在用车评价
							failcarapp=failcarapp+";"+carflowno;
							System.out.println(carflowno + " has existed YCPJD, not create");
							break;					
						}
					}
				}else{
					err = "1"; //排车单没有对应的用车申请
				}
			}
		}else{
			err = "0"; //没有对应的排车单
		}
	}

	if(err.equals("")){			
		jo.put("msg","true");
		jo.put("passcarapp",passcarapp);
	}else{
		jo.put("msg","false");
		jo.put("err",err);
		jo.put("passcarapp",passcarapp);
		jo.put("failcarapp",failcarapp);
	}	
	
	response.setContentType("application/json; charset=utf-8");
	response.getWriter().write(jo.toString());
	response.getWriter().flush();
	response.getWriter().close();	
%>
