<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.util.*" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.BaseJdbcDao"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.util.DateHelper"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<!--%@ page import="com.eweaver.app.dccm.dmhr.payroll.DMHR_PayrollAction"%-->

<%@ page import="com.eweaver.app.configsap.SapConnector_EN"%>
<%@ page import="com.sap.conn.jco.JCoFunction"%>
<%@ page import="com.sap.conn.jco.JCoException"%>
<%@ page import="com.sap.conn.jco.JCoTable"%>
<%@ page import="com.sap.conn.jco.JCoStructure"%>
<%@ page import="com.eweaver.base.IDGernerator"%>
<%
	String action=StringHelper.null2String(request.getParameter("action"));
	response.setContentType("application/json; charset=utf-8");
	JSONObject jo = new JSONObject();		
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
	DataService dataService = new DataService();
	DataService ds = new DataService();	

	if ( action.equals("getPayRoll") ) {	//工资单查询
		JSONObject jsonObject = new JSONObject();		
		String empsapid=StringHelper.null2String(request.getParameter("empsapid"));		
		String salarymon=StringHelper.null2String(request.getParameter("salarymon"));	
		String requestid=StringHelper.null2String(request.getParameter("requestid"));
		if ( !"".equals(empsapid) && !"".equals(salarymon) ) {
			//DMHR_PayrollAction app = new DMHR_PayrollAction();
			String flag = "";
			try {
				//flag = app.GetPayroll(empsapid,salarymon,requestid);
				//flag = GetPayroll(empsapid,salarymon,requestid);
				String str="";	  
				if( "".equals(empsapid) || "".equals(salarymon) ){
					str = "error@@Parameters is null";
				}else{
					String functionName = "";
					JCoFunction function = null;
					String errorMessage = "";

					functionName = "ZHR_PAYROLL_LIST_MY"; //PY001	工资单
					function = null;
					try {
						function = SapConnector_EN.getRfcFunction(functionName);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

					if (function == null) {
						System.out.println(functionName + " not found in SAP.");
						System.out.println("SAP_RFC中没有此函数!");
						errorMessage = functionName + " not found in SAP.";
					}
					function.getImportParameterList().setValue("PERNR", empsapid);
					function.getImportParameterList().setValue("INPER", salarymon);
					//System.out.println("=GetPayroll() PERNR="+empsapid +" INPER="+salarymon);

					try {
						function.execute(SapConnector_EN.getDestination("sanpowersapen"));
						//function.execute(sapConnector.getDestination(sapConnector.fdPoolName));				
					} catch (JCoException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}	

					//返回值
					String sapmsg = function.getExportParameterList().getValue("MESSAGE").toString();
					String sapmsgtype = function.getExportParameterList().getValue("MSGTY").toString();
					//str = sapmsg +"@@"+sapmsgtype;
					JCoStructure jcostru =  function.getExportParameterList().getStructure("PAYROLL_RESULT");
					if( "I".equals(sapmsgtype) && jcostru != null ) {
						String R_SALARY = "";
						String R_OT_ONCALL = "";
						String R_OT_WKDAY = "";
						String R_OT_RESTDAY = "";
						String R_OT_HOLIDAY = "";
						String R_LEAVEPAY = "";
						String R_FIXALLOW = "";
						String R_NFIXALLOW = "";
						String R_OTHREARN = "";
						String R_ADVANCE = "";
						String R_BOUNDS = "";
						String R_TOTRM = "";
						String R_NETPY1ST = "";
						String R_EPF = "";
						String R_SOCSO = "";
						String R_ADVANCERY = "";
						String R_UNPYLEAVE = "";
						String R_TAXCP39 = "";
						String R_TAXCP38 = "";
						String R_OTHRDDCT = "";
						String R_HOUSDDCT = "";
						String R_MEALDDCT = "";
						String R_TOTDEDRM = "";
						String R_NETPYRM = "";
						String R_TAXNO = "";
						String R_BANKCODE = "";
						String R_ACNO = "";
						String R_DUTY = "";
						String R_ATTND = "";
						String R_SHIFTALLOW = "";
						String R_TRANSALLOW = "";
						String R_ONCALALLOW = "";
						String R_OT4HOUR = "";
						String R_PATRLALLOW = "";
						String R_SECRYALLOW = "";
						String R_MEALALLOW = "";
						String R_HOUSALLOW = "";
						String R_EPFEE = "";
						String R_EPFER = "";
						String R_EPFTOTCM = "";
						String R_SOCSOEE = "";
						String R_SOCSOER = "";
						String R_SOCSOTOTCM = "";
						String R_EPFEEYD = "";
						String R_EPFERYD = "";
						String R_EPFTOTYD = "";
						String R_SOCSOEEYD = "";
						String R_SOCSOERYD = "";
						String R_SOCSOTOTYD = "";
						String R_TAXYD = "";
						String R_TAXTOTYD = "";		
						for (int i = 0; i < jcostru.getMetaData().getFieldCount(); i++){
							//System.out.println(String.format("%s\\t%s", 
							//		jcostru.getMetaData().getName(i),
							//		jcostru.getString(i)));
							if ( "R_SALARY".equals(jcostru.getMetaData().getName(i)) ) {
								R_SALARY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OT_ONCALL".equals(jcostru.getMetaData().getName(i)) ) {
								R_OT_ONCALL = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OT_WKDAY".equals(jcostru.getMetaData().getName(i)) ) {
								R_OT_WKDAY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OT_RESTDAY".equals(jcostru.getMetaData().getName(i)) ) {
								R_OT_RESTDAY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OT_HOLIDAY".equals(jcostru.getMetaData().getName(i)) ) {
								R_OT_HOLIDAY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_LEAVEPAY".equals(jcostru.getMetaData().getName(i)) ) {
								R_LEAVEPAY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_FIXALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_FIXALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_NFIXALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_NFIXALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OTHREARN".equals(jcostru.getMetaData().getName(i)) ) {
								R_OTHREARN = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_ADVANCE".equals(jcostru.getMetaData().getName(i)) ) {
								R_ADVANCE = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_BOUNDS".equals(jcostru.getMetaData().getName(i)) ) {
								R_BOUNDS = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_TOTRM".equals(jcostru.getMetaData().getName(i)) ) {
								R_TOTRM = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_NETPY1ST".equals(jcostru.getMetaData().getName(i)) ) {
								R_NETPY1ST = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_EPF".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPF = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_SOCSO".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSO = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_ADVANCERY".equals(jcostru.getMetaData().getName(i)) ) {
								R_ADVANCERY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_UNPYLEAVE".equals(jcostru.getMetaData().getName(i)) ) {
								R_UNPYLEAVE = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_TAXCP39".equals(jcostru.getMetaData().getName(i)) ) {
								R_TAXCP39 = StringHelper.null2String(jcostru.getString(i));
							}					
							if ( "R_TAXCP38".equals(jcostru.getMetaData().getName(i)) ) {
								R_TAXCP38 = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OTHRDDCT".equals(jcostru.getMetaData().getName(i)) ) {
								R_OTHRDDCT = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_HOUSDDCT".equals(jcostru.getMetaData().getName(i)) ) {
								R_HOUSDDCT = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_MEALDDCT".equals(jcostru.getMetaData().getName(i)) ) {
								R_MEALDDCT = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_TOTDEDRM".equals(jcostru.getMetaData().getName(i)) ) {
								R_TOTDEDRM = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_NETPYRM".equals(jcostru.getMetaData().getName(i)) ) {
								R_NETPYRM = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_TAXNO".equals(jcostru.getMetaData().getName(i)) ) {
								R_TAXNO = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_BANKCODE".equals(jcostru.getMetaData().getName(i)) ) {
								R_BANKCODE = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_ACNO".equals(jcostru.getMetaData().getName(i)) ) {
								R_ACNO = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_DUTY".equals(jcostru.getMetaData().getName(i)) ) {
								R_DUTY = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_ATTND".equals(jcostru.getMetaData().getName(i)) ) {
								R_ATTND = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_SHIFTALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_SHIFTALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_TRANSALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_TRANSALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_ONCALALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_ONCALALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_OT4HOUR".equals(jcostru.getMetaData().getName(i)) ) {
								R_OT4HOUR = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_PATRLALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_PATRLALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_SECRYALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_SECRYALLOW = StringHelper.null2String(jcostru.getString(i));
							}
							if ( "R_MEALALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_MEALALLOW = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_HOUSALLOW".equals(jcostru.getMetaData().getName(i)) ) {
								R_HOUSALLOW = StringHelper.null2String(jcostru.getString(i));
							}		
							if ( "R_EPFEE".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFEE = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_EPFER".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFER = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_EPFTOTCM".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFTOTCM = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOEE".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOEE = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOER".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOER = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOTOTCM".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOTOTCM = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_EPFEEYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFEEYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_EPFERYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFERYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_EPFTOTYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_EPFTOTYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOEEYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOEEYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOERYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOERYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_SOCSOTOTYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_SOCSOTOTYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_TAXYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_TAXYD = StringHelper.null2String(jcostru.getString(i));
							}	
							if ( "R_TAXTOTYD".equals(jcostru.getMetaData().getName(i)) ) {
								R_TAXTOTYD = StringHelper.null2String(jcostru.getString(i));
							}
						}
						str = R_SALARY +"@@"+R_OT_ONCALL+"@@"+R_OT_WKDAY+"@@"+R_OT_RESTDAY+"@@"+R_OT_HOLIDAY
						+"@@"+R_LEAVEPAY +"@@"+R_FIXALLOW+"@@"+R_NFIXALLOW+"@@"+R_OTHREARN+"@@"+R_ADVANCE
						+"@@"+R_BOUNDS +"@@"+R_TOTRM+"@@"+R_NETPY1ST+"@@"+R_EPF+"@@"+R_SOCSO+"@@"+R_ADVANCERY
						+"@@"+R_UNPYLEAVE +"@@"+R_TAXCP39+"@@"+R_TAXCP38+"@@"+R_OTHRDDCT+"@@"+R_HOUSDDCT+"@@"+R_MEALDDCT
						+"@@"+R_TOTDEDRM +"@@"+R_NETPYRM+"@@"+R_TAXNO+"@@"+R_BANKCODE+"@@"+R_ACNO+"@@"+R_DUTY
						+"@@"+R_ATTND +"@@"+R_SHIFTALLOW+"@@"+R_TRANSALLOW+"@@"+R_ONCALALLOW+"@@"+R_OT4HOUR+"@@"+R_PATRLALLOW
						+"@@"+R_SECRYALLOW +"@@"+R_MEALALLOW+"@@"+R_HOUSALLOW+"@@"+R_EPFEE+"@@"+R_EPFER+"@@"+R_EPFTOTCM
						+"@@"+R_SOCSOEE +"@@"+R_SOCSOER+"@@"+R_SOCSOTOTCM+"@@"+R_EPFEEYD+"@@"+R_EPFERYD+"@@"+R_EPFTOTYD
						+"@@"+R_SOCSOEEYD +"@@"+R_SOCSOERYD+"@@"+R_SOCSOTOTYD+"@@"+R_TAXYD+"@@"+R_TAXTOTYD;
						//System.out.println("str="+str);

						if ( !"".equals(requestid) ) {
							Integer subexists = 0;
							StringBuffer buffer = new StringBuffer(512);
							String upsubsql = "";

							subexists = Integer.valueOf(ds.getSQLValue("select count(1) from uf_dmhr_payrolldetail where requestid='"+requestid+"'")); 
							if (subexists==0){
								buffer = new StringBuffer(512);
								buffer.append("insert into uf_dmhr_payrolldetail ");
								buffer.append("(id,requestid,rowindex,salary,otoncall,otwkday,otrestday,otholiday,leaveday,fixallow,nfixallow,othrearn,");
								buffer.append("advance,bounds,totrm,nerpay1st,epf,socso,advancery,unpayleave,taxcp39,taxcp38,othrddct,housddct,mealddct,");
								buffer.append("totdedrm,netpyrm,taxno,bankcode,acno,duty,attnd,shiftallow,transallow,oncallallow,ot4hour,patrlallow,secryallow,");
								buffer.append("mealallow,housallow,epfee,epfer,epftotcm,socsoee,socsoer,socsototcm,epfeeyd,epferyd,epftotyd,socsoeeyd,socsoeryd,");
								buffer.append("socsototyd,taxyd,taxtotyd) values ");	
								buffer.append("('").append(IDGernerator.getUnquieID()).append("',");
								buffer.append("'").append(requestid).append("',");
								buffer.append("'000',");
								buffer.append("'").append(R_SALARY).append("',");
								buffer.append("'").append(R_OT_ONCALL).append("',");
								buffer.append("'").append(R_OT_WKDAY).append("',");
								buffer.append("'").append(R_OT_RESTDAY).append("',");
								buffer.append("'").append(R_OT_HOLIDAY).append("',");
								buffer.append("'").append(R_LEAVEPAY).append("',");
								buffer.append("'").append(R_FIXALLOW).append("',");
								buffer.append("'").append(R_NFIXALLOW).append("',");
								buffer.append("'").append(R_OTHREARN).append("',");
								buffer.append("'").append(R_ADVANCE).append("',");
								buffer.append("'").append(R_BOUNDS).append("',");
								buffer.append("'").append(R_TOTRM).append("',");
								buffer.append("'").append(R_NETPY1ST).append("',");
								buffer.append("'").append(R_EPF).append("',");
								buffer.append("'").append(R_SOCSO).append("',");
								buffer.append("'").append(R_ADVANCERY).append("',");
								buffer.append("'").append(R_UNPYLEAVE).append("',");
								buffer.append("'").append(R_TAXCP39).append("',");
								buffer.append("'").append(R_TAXCP38).append("',");
								buffer.append("'").append(R_OTHRDDCT).append("',");
								buffer.append("'").append(R_HOUSDDCT).append("',");
								buffer.append("'").append(R_MEALDDCT).append("',");
								buffer.append("'").append(R_TOTDEDRM).append("',");
								buffer.append("'").append(R_NETPYRM).append("',");
								buffer.append("'").append(R_TAXNO).append("',");
								buffer.append("'").append(R_BANKCODE).append("',");
								buffer.append("'").append(R_ACNO).append("',");
								buffer.append("'").append(R_DUTY).append("',");
								buffer.append("'").append(R_ATTND).append("',");
								buffer.append("'").append(R_SHIFTALLOW).append("',");
								buffer.append("'").append(R_TRANSALLOW).append("',");
								buffer.append("'").append(R_ONCALALLOW).append("',");
								buffer.append("'").append(R_OT4HOUR).append("',");
								buffer.append("'").append(R_PATRLALLOW).append("',");
								buffer.append("'").append(R_SECRYALLOW).append("',");
								buffer.append("'").append(R_MEALALLOW).append("',");
								buffer.append("'").append(R_HOUSALLOW).append("',");
								buffer.append("'").append(R_EPFEE).append("',");
								buffer.append("'").append(R_EPFER).append("',");
								buffer.append("'").append(R_EPFTOTCM).append("',");
								buffer.append("'").append(R_SOCSOEE).append("',");
								buffer.append("'").append(R_SOCSOER).append("',");
								buffer.append("'").append(R_SOCSOTOTCM).append("',");
								buffer.append("'").append(R_EPFEEYD).append("',");
								buffer.append("'").append(R_EPFERYD).append("',");
								buffer.append("'").append(R_EPFTOTYD).append("',");
								buffer.append("'").append(R_SOCSOEEYD).append("',");
								buffer.append("'").append(R_SOCSOERYD).append("',");
								buffer.append("'").append(R_SOCSOTOTYD).append("',");
								buffer.append("'").append(R_TAXYD).append("',");
								buffer.append("'").append(R_TAXTOTYD).append("')");
								upsubsql = buffer.toString();
								//System.out.println(upsubsql);
								baseJdbcDao.update(upsubsql);	
								upsubsql = "update uf_dmhr_payroll set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"'";
								baseJdbcDao.update(upsubsql);	
							}else{
								upsubsql = "update uf_dmhr_payrolldetail set salary='"+R_SALARY+"',otoncall='"+R_OT_ONCALL
										+"',otwkday='"+R_OT_WKDAY+"',otrestday='"+R_OT_RESTDAY+"',otholiday='"+R_OT_HOLIDAY
										+"',leaveday='"+R_LEAVEPAY+"',fixallow='"+R_FIXALLOW+"',nfixallow='"+R_NFIXALLOW
										+"',othrearn='"+R_OTHREARN+"',advance='"+R_ADVANCE+"',bounds='"+R_BOUNDS
										+"',totrm='"+R_TOTRM+"',nerpay1st='"+R_NETPY1ST+"',epf='"+R_EPF
										+"',socso='"+R_SOCSO+"',advancery='"+R_ADVANCERY+"',unpayleave='"+R_UNPYLEAVE
										+"',taxcp39='"+R_TAXCP39+"',taxcp38='"+R_TAXCP38+"',othrddct='"+R_OTHRDDCT
										+"',housddct='"+R_HOUSDDCT+"',mealddct='"+R_MEALDDCT+"',totdedrm='"+R_TOTDEDRM
										+"',netpyrm='"+R_NETPYRM+"',taxno='"+R_TAXNO+"',bankcode='"+R_BANKCODE
										+"',acno='"+R_ACNO+"',duty='"+R_DUTY+"',attnd='"+R_ATTND
										+"',shiftallow='"+R_SHIFTALLOW+"',transallow='"+R_TRANSALLOW+"',oncallallow='"+R_ONCALALLOW
										+"',ot4hour='"+R_OT4HOUR+"',patrlallow='"+R_PATRLALLOW+"',secryallow='"+R_SECRYALLOW
										+"',mealallow='"+R_MEALALLOW+"',housallow='"+R_HOUSALLOW+"',epfee='"+R_EPFEE
										+"',epfer='"+R_EPFER+"',epftotcm='"+R_EPFTOTCM+"',socsoee='"+R_SOCSOEE
										+"',socsoer='"+R_SOCSOER+"',socsototcm='"+R_SOCSOTOTCM+"',epfeeyd='"+R_EPFEEYD
										+"',epferyd='"+R_EPFERYD+"',epftotyd='"+R_EPFTOTYD+"',socsoeeyd='"+R_SOCSOEEYD
										+"',socsoeryd='"+R_SOCSOERYD+"',socsototyd='"+R_SOCSOTOTYD+"',taxyd='"+R_TAXYD
										+"',taxtotyd='"+R_TAXTOTYD	+"' where requestid='"+requestid+"'";
								//System.out.println(upsubsql);
								baseJdbcDao.update(upsubsql);
								upsubsql = "update uf_dmhr_payroll set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"'";
								baseJdbcDao.update(upsubsql);
							}

						}
					}else{
						str = "error@@SAP Search fail:"+sapmsg;
						String upsubsql = "update uf_dmhr_payroll set msgty='"+sapmsgtype+"',message='"+sapmsg+"' where requestid='"+requestid+"'";
						baseJdbcDao.update(upsubsql);
					}
					flag =  str;
					String[] a = flag.split("@@");
					if( "error".equals(a[0]) ){
						jsonObject.put("info",a[1]);	
						jsonObject.put("msg","false");	
					}else{				
						jsonObject.put("info",flag);	
						jsonObject.put("msg","true");	
					}
		
				}
			} catch (Exception e) {
				e.printStackTrace();
				jsonObject.put("info",e.getMessage());	
				jsonObject.put("msg","false");				
			}

		}
		response.getWriter().write(jsonObject.toString());
		response.getWriter().flush();
		response.getWriter().close();		
	}
	
%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   