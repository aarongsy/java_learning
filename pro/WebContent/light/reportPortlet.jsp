<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef"%>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="java.util.*,com.eweaver.base.util.*"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.security.cache.SysTableNameCache"%>
<%@ page import="com.eweaver.base.security.util.PermissionUtil"%>
<%@ page import="com.eweaver.base.Page,com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.label.service.LabelService"%>
<%!
private Map fieldsearchMap0=null;
private String[] getSql(){
		String[] sqls = new String[2];
		Reportdef reportdef = reportdefService.getReportdef2(reportid);
		
		ReportfieldService reportfieldService=(ReportfieldService)BaseContext.getBean("reportfieldService");
		Forminfo forminfo = forminfoService.getForminfoById(reportdef.getFormid());
		Map paravaluehm = new HashMap();
		String searchtb = forminfo.getObjtablename();//所要搜索的表

		if(StringHelper.isEmpty(searchtb)){
			System.out.print(labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20008"));//你还没有为系统表定义相应的报表...
			return null;
		}
		fieldsearchMap0 = new HashMap();
		
		StringBuffer sql = new StringBuffer("select ");//查询语句
		String sumsql = ""; //统计的sql语句
		StringBuffer sumby = new StringBuffer("");//要进行统计的字段
		StringBuffer colsql = new StringBuffer("id,");//要搜索的字段
		StringBuffer orderby = new StringBuffer("");//要排序的字段
		
		this.reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			Reportfield reportfield = (Reportfield) it2.next();
			
			String formfieldid = reportfield.getFormfieldid();
			Formfield formfield = formfieldService.getFormfieldById(formfieldid);
			
			if(formfield != null){
				colsql.append(formfield.getFieldname()).append(",");
				if(reportfield.getIssum() == 1){
					sumby.append(",sum(").append(formfield.getFieldname()).append(") as sum_").append(formfield.getFieldname());
					sumsql = "select sum(" + formfield.getFieldname() + ") from " + searchtb;
				}
				String hreflink = StringHelper.null2String(reportfield.getHreflink());
				if(!hreflink.equals("") && hreflink.indexOf("?")!= -1){
					hreflink = hreflink.substring(hreflink.indexOf("?")+1);
					String[] hrefparas = hreflink.split("&&");
					for(int i=0; i<hrefparas.length; i++){
						String[] hrefparas2 = hrefparas[i].split("=");
						if(hrefparas.length == 2){
							paravaluehm.put("{" + hrefparas2[0].trim() + "}",hrefparas2[1]);
						}else{
							paravaluehm.put("{" + hrefparas2[0].trim() + "}","");
						}
					}
				}
				
				if(reportfield.getIsorderfield()==1){
					orderby.append(formfield.getFieldname()).append(" asc,");
				}
				if(reportfield.getIsorderfield()==2){
					orderby.append(formfield.getFieldname()).append(" desc,");
				}				
			}
		}
		
		if(!sumby.toString().equals("")){
			sumsql = "select " + sumby.toString().substring(1) + " from " + searchtb;
		}
		
		/**
		 * 获得查询条件
		 */
		List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid(reportid);
		Reportsearchfield reportsearchfield = null;
		Iterator it = reportSearchfieldList.iterator();
		StringBuffer sqlwhere = new StringBuffer("");
		while(it.hasNext()){
			
			reportsearchfield = (Reportsearchfield) it.next();
			String formfieldid = reportsearchfield.getFormfieldid();
			Formfield formfield = formfieldService.getFormfieldById(formfieldid);
		
			String id = formfield.getId();
			String _htmltype = StringHelper.null2String(formfield.getHtmltype());
			String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
			String _fieldname = StringHelper.null2String(formfield.getFieldname());

			String tmpvalue = StringHelper.null2String(request.getParameter("con" + id + "_value")).trim();
			String tmpvalue1 = StringHelper.null2String(request.getParameter("con" + id + "_value1")).trim();
			//获取browser传入报表头条件
			if("".equals(tmpvalue)){
				tmpvalue = StringHelper.null2String(request.getAttribute("con" + id + "_value")).trim();
			}
			if("".equals(tmpvalue1)){
				tmpvalue1 = StringHelper.null2String(request.getAttribute("con" + id + "_value1")).trim();
			}
			String tmpisshow = StringHelper.null2String(request.getParameter("con" + id + "_isshow"));
			
			fieldsearchMap0.put("con" + formfieldid + "_value",tmpvalue);
			fieldsearchMap0.put("con" + formfieldid + "_value1",tmpvalue1);
			fieldsearchMap0.put("con" + formfieldid + "_isshow",tmpisshow);
			
			paravaluehm.put("{" + _fieldname.trim() + "}",tmpvalue);//页面菜单上面有用
			request.setAttribute("paravaluehm",paravaluehm);
			
			if(_htmltype.equals("1")){//单行文本
				if(_fieldtype.equals("1")){//文本

					if(!tmpvalue.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" like '%").append(tmpvalue).append("%' ");
					}
				}else if(_fieldtype.equals("2")){//整数
					if(!tmpvalue.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" >=").append(tmpvalue).append(" ");
					}
					if(!tmpvalue1.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" <=").append(tmpvalue1).append(" ");
					}
				
				}else if(_fieldtype.equals("3")){//浮点数




					if(!tmpvalue.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" >=").append(tmpvalue).append(" ");
					}
					if(!tmpvalue1.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" <=").append(tmpvalue1).append(" ");
					}
					
				}else if(_fieldtype.equals("4")){//日期	
					if(!tmpvalue.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" >='").append(tmpvalue).append("' ");
					}
					if(!tmpvalue1.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" <='").append(tmpvalue1).append("' ");
					}
					
				}else if(_fieldtype.equals("5")){//时间
					if(!tmpvalue.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" >='").append(tmpvalue).append("' ");	
					}
					if(!tmpvalue1.equals("")){
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" <='").append(tmpvalue1).append("' ");
					}
				
				}			
			}else if(_htmltype.equals("2")){//多行文本
				if(!tmpvalue.equals("")){
					sqlwhere.append(" and ").append(_fieldname);
					sqlwhere.append(" like '%").append(tmpvalue).append("%' ");
				}
				
			}else if(_htmltype.equals("3")){//带格式文本




				
			}else if(_htmltype.equals("4")){//CHECK框


				if(tmpvalue.equals("1")){
					sqlwhere.append(" and ").append(_fieldname);
					sqlwhere.append("='1' ");
				} else{
					sqlwhere.append(" and ").append(_fieldname);
					sqlwhere.append(" is null ");		
				}

			}else if(_htmltype.equals("5")){//选择项

				if(!tmpvalue.equals("")){
					sqlwhere.append(" and ").append(_fieldname);
					sqlwhere.append(" ='").append(tmpvalue).append("' ");
				}
			}else if(_htmltype.equals("6")){//关联选择
				
				if(!tmpvalue.equals("")){
					//判断关联选择项的类型（）
					
					Refobj refobj = refobjService.getRefobj(_fieldtype);
					String morgcheckbox = request.getParameter("con" + formfieldid + "_checkbox");
					if(morgcheckbox==null ||morgcheckbox.equals("")){
						morgcheckbox = StringHelper.null2String(request.getAttribute("con" + formfieldid + "_checkbox"));
					}
					fieldsearchMap0.put("con" + formfieldid + "_checkbox",morgcheckbox);
					if(refobj!=null && "orgunit".equalsIgnoreCase(refobj.getReftable()) && "1".equals(morgcheckbox)){//如果选择项为组织且包括其下级组织时

						 String humresidslimited4sql = " exists (select h.oid from Orgunitlink h where tbalias."+ _fieldname +" like '%' + h.oid '%'|| and h.col1 like '%"+tmpvalue+"%')";
						if("humres".equalsIgnoreCase(searchtb)){//人事模块比较变态，要考虑兼岗问题
							humresidslimited4sql = " exists (select h.oid from Orgunitlink h where h.oid is not null and tbalias.orgids like '%'|| h.oid||'%'  and h.col1 like '%"+tmpvalue+"%')";
						}
						 sqlwhere.append(" and " + humresidslimited4sql);
					}else{
						sqlwhere.append(" and ").append(_fieldname);
						sqlwhere.append(" like '%").append(tmpvalue).append("%' ");
					}
				}
			}else if(_htmltype.equals("7")){//附件
				if(!tmpvalue.equals("")){
					sqlwhere.append("and ','+convert(varchar(8000),").append(_fieldname).append(")+',' ");
					sqlwhere.append(" like '%,").append(_fieldname).append(",%' ");
				}
			}			
		}
		
		//添加要查询的列

		if(colsql.toString().equals("")){
			sql.append(" * from ").append(searchtb).append(" tbalias ");
		}else{
			colsql.deleteCharAt(colsql.length()-1);
			sql.append(colsql).append(" from ").append(searchtb).append(" tbalias ");
		}
		
		//添加查询条件
		String initsqlwhere = "";
		initsqlwhere = StringHelper.getDecodeStr(initsqlwhere);
		if(!sqlwhere.toString().equals("")){
			sqlwhere.delete(sqlwhere.indexOf(" and"),4);
			//logger.info("sqlwhere:" + sqlwhere);
			sql.append(" where ").append(sqlwhere);
			
			if(!sumsql.equals("")){
				sumsql += " where " + sqlwhere;
			}
			if(!initsqlwhere.equals("")){
				sql.append(" and ").append(initsqlwhere);
			}
		}else{
			if(!initsqlwhere.equals("")){
				sql.append(" where 1=1 and ").append(initsqlwhere);
			}
		}

		//添加categorylink条件
		if(!categoryid.equals("")){
			if(sql.indexOf("where")>0)
				sql.append(" and requestid in(select objid from categorylink where categoryid='").append(categoryid).append("')");
			else
				sql.append(" where requestid in(select objid from categorylink where categoryid='").append(categoryid).append("')");
		}

		//添加排序条件
		if(!orderfield.equals("")){//如果用户点了按列排序，刚在后台定义的排序列不起作用

			sql.append(" order by ").append(orderfield).append(" ").append(descorasc);
		}else{
			if(!orderby.toString().equals("")){
				orderby.deleteCharAt(orderby.length()-1);
				sql.append(" order by ").append(orderby).append(",id desc");
			}else{
				sql.append(" order by id desc");
			}
		}
		//logger.info("sql:" + sql.toString());
		String tempsql = sql.toString();
		//添加权限限制
		
//		PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
//		int righttype = permissiondetailService.getOpttype(reportid, "reportdef");
//		if(righttype%15==0){
//			tempsql = sql.toString();
//		}else{
//			if(SysTableNameCache.getSystablenames().contains(searchtb)){
//				tempsql = PermissionUtil.getPermissionAndNotDelSql(sql.toString(),searchtb); 
//					
//				if(!sumsql.equals("")){
//					sumsql = PermissionUtil.getPermissionAndNotDelSql(sumsql,searchtb); 
//				}
//			}
//		}
		
		if(StringHelper.null2String(SysTableNameCache.getSystablenames()).toLowerCase().contains(searchtb.toLowerCase())){
			String istitleshaw = PermissionUtil.getSetitemValue(searchtb);
			istitleshaw = "1";

			if("1".equals(istitleshaw)){
				tempsql = PermissionUtil.getPermissionAndNotDelSql(sql.toString(),searchtb); 
				
				if(!sumsql.equals("")){
					sumsql = PermissionUtil.getPermissionAndNotDelSql(sumsql,searchtb); 
				}	
			}else{
				tempsql = PermissionUtil.getNotinDelobjSql(sql.toString(),searchtb); 
				
				if(!sumsql.equals("")){
					sumsql = PermissionUtil.getNotinDelobjSql(sumsql,searchtb); 
				}
			}

		}
		
		sqls[0] = tempsql;
		sqls[1] = sumsql;
		return sqls;
	}

	private Page getReportPage(String sql, int pageNo, int pageSize){
		Page reportpage = dataService.pagedQuery(sql,pageNo, pageSize);
		return reportpage;
	}
	
private ReportdefService reportdefService = null;
private String reportid="4028801111bdd00d0111bdd73e060006";
private FormfieldService formfieldService = null;
private ReportSearchfieldService reportsearchfieldService = null;
private HttpServletRequest request=null;
private String categoryid = "";
private String orderfield = "";
private String descorasc = "";
private SelectitemService selectitemService=null;
private RefobjService refobjService = null;
private DataService dataService = null;
private AttachService attachService = null;
private List reportfieldList=null;
private HumresService humresService=null;
private ForminfoService forminfoService = null;
private LabelService labelService = null;

private void main(){
	this.reportdefService=(ReportdefService)BaseContext.getBean("reportdefService");
	this.formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
	this.reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");
	this.selectitemService = (SelectitemService)BaseContext.getBean("selectitemService");
	this.refobjService = (RefobjService) BaseContext.getBean("refobjService");
	this.dataService= new DataService();
	this.attachService= (AttachService)BaseContext.getBean("attachService");
	this.humresService = (HumresService)BaseContext.getBean("humresService");
	this.forminfoService=(ForminfoService)BaseContext.getBean("forminfoService");
	this.labelService =(LabelService)BaseContext.getBean("labelService");
	
	categoryid = StringHelper.null2String(request.getParameter("categoryid"));
	String initquerystr = "";
	String initsqlwhere = "";
	String[] sqls = this.getSql();
	request.getSession().setAttribute("sqls",sqls);
	request.setAttribute("fieldsearchMap",fieldsearchMap0);
    Reportdef reportdef=reportdefService.getReportdef(reportid);
	int pageNo=1;
	int pageSize=10;
    Page pageObject = this.getReportPage(sqls[0].toString(),pageNo,pageSize);
	request.setAttribute("pageObject", pageObject);
	request.setAttribute("initquerystr", initquerystr);
	request.setAttribute("initsqlwhere", initsqlwhere);
	String url=request.getContextPath()+"/workflow/report/reportresultlist.jsp?sysmodel=1&reportid=" + reportid+ "&descorasc="+descorasc;
	//request.getRequestDispatcher(url).forward(request, response);
}			

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be20009") %><!-- 无标题文档 --></title>
</head>

<body>

    <%
this.request=request;
this.main();
/***************************************************************/
List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
List formfieldlist = new ArrayList();
Iterator it = reportSearchfieldList.iterator();
while(it.hasNext()){
	
	Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
	String formfieldid = reportsearchfield.getFormfieldid();
	Formfield formfield = formfieldService.getFormfieldById(formfieldid);
	formfieldlist.add(formfield);
}
Page pageObject = (Page) request.getAttribute("pageObject");
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据
String fieldopt = "";
String fieldopt1 = "";
String fieldvalue = "";
String fieldvalue1 = "";
Map summap = new HashMap();
%>
        <table class=liststyle cellspacing=1   id="vTable">
<!--表头开始-->		  
          <tr class=Header> 
          <%
		
        it = reportfieldList.iterator();
        cols = reportfieldList.size();
        
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();  
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}
			
			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}
%>
         	<td nowrap  <%=widths%> <%=styler %>><a href="javascript:listorder('<%=formfields.getFieldname() %>');"><B><%=reportfield.getShowname()%></B></a></td>
<%
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %> 
          </tr>
<!--表头结束-->
				<%		
				
				
				if(pageObject.getTotalSize()!=0){
					List list = (List) pageObject.getResult();	
					
					Map reportdataMap = null;
					Map reportMap = null;
					rows = list.size();	
					
					
					for (int i = 0; i < list.size(); i++) {
						
						reportdataMap = new HashMap();
						reportMap = (Map)list.get(i);
				%>		

          <tr  class=datadark  > 
       <%   
       int j=0;
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			String rtxstr = "";
			Reportfield reportfield = (Reportfield) it2.next();
			String alertcon = StringHelper.null2String(reportfield.getAlertcond());

			if(!StringHelper.isEmpty(alertcon)){
				Iterator pagemenuparakeyit3 = reportMap.keySet().iterator();
				while (pagemenuparakeyit3.hasNext()) {
					String pagemenuparakey = (String)pagemenuparakeyit3.next();
					String pagemenuparakey2 = "{" + pagemenuparakey + "}";
					alertcon = StringHelper.replaceString(alertcon,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
				}
			}
			
			String formfieldid = reportfield.getFormfieldid();
			String href = reportfield.getHreflink();//报表中配置的链接，如果报表关联字段browser中已配置了链接，刚此处的链接不起作用
			Formfield formfield = formfieldService.getFormfieldById(formfieldid);

			boolean isalign = false;//数字是否右对齐

			if(formfield != null&&!StringHelper.isEmpty(formfield.getId())){
				String formfieldname = formfield.getFieldname();
				fieldvalue = StringHelper.null2String(reportMap.get(formfieldname));//对象对应的ID
				String fieldtype = formfield.getFieldtype();//字段对应类型（通过此类型得到相应对象是selectitem还是browser，从而得到对应ID的显示名）

				
				String formfieldvalue = "";//生成excel报表时用到

				
				String htmltype = "";
				if(formfield.getHtmltype()!=null){
					htmltype = formfield.getHtmltype().toString();
				}
				
				if(htmltype.equals("1")&&(fieldtype.equals("2")||fieldtype.equals("3"))){
					if(StringHelper.isEmpty(fieldvalue)){
						fieldvalue = "0";
					}
					fieldvalue = new java.text.DecimalFormat("#,##0.00").format(Double.valueOf(fieldvalue));
					isalign = true;
				}
				
				if(htmltype.equals("4")){
					if("1".equals(fieldvalue)){
						fieldvalue = "<IMG SRC='"+request.getContextPath()+"/images/bacocheck.gif' >";
					}else{
						fieldvalue = "<IMG SRC='"+request.getContextPath()+"/images/bacocross.gif' >";
					}
				}
//				System.out.println("--------isalign:" + isalign);
//				System.out.println("--------fieldvalue:" + fieldvalue + "-------htmltype:" + htmltype);
				if(htmltype.equals("5")&&!StringHelper.isEmpty(fieldvalue)){
					
					Selectitem selectitem = selectitemService.getSelectitemById(fieldvalue);
					if(selectitem!=null){
						fieldvalue = selectitem.getObjname();
						formfieldvalue = fieldvalue;
					}
				}
				
				if(htmltype.equals("6")&&!StringHelper.isEmpty(fieldvalue)){
					Refobj refobj = refobjService.getRefobj(fieldtype);
					if(refobj != null){
						String _refid = StringHelper.null2String(refobj.getId());
						String _refurl = StringHelper.null2String(refobj.getRefurl());
						String _viewurl = StringHelper.null2String(refobj.getViewurl());
						String _reftable = StringHelper.null2String(refobj.getReftable());
						String _keyfield = StringHelper.null2String(refobj.getKeyfield());
						String _viewfield = StringHelper.null2String(refobj.getViewfield());

						String showname = "";
						if(!StringHelper.isEmpty(formfieldname)){
							String reffieldid = StringHelper.null2String(reportfield.getCol1());
							String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
							//得到对象ID对应的objname
							
							if(fieldvalue.contains(",")){//如果关联字段是多值的(比如多选browser)
								sql = "select distinct " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(fieldvalue)+ ")";
							}
							

//							*******************************************************************************************************
//							如果存在关联字段
							if(!reffieldid.equals("")){
								Formfield refformfield = formfieldService.getFormfieldById(reffieldid);
								String refhtmltype = "";
								if(refformfield.getHtmltype()!=null){
									refhtmltype = refformfield.getHtmltype().toString();
								}

								String reffieldname = StringHelper.null2String(refformfield.getFieldname());
								String reffieldtype = StringHelper.null2String(refformfield.getFieldtype());
								if(refhtmltype.equals("5")){
									sql = "select a." + _keyfield + " as objid,b.objname as objname " 
									 	+ "from " + _reftable + " a,Selectitem b where a." + _keyfield + " ='" + fieldvalue + "'"
										 + " and a." + reffieldname + "=b.id";
									
									_viewurl = "";
								}else if(refhtmltype.equals("6")){
									Refobj refrefobj = refobjService.getRefobj(reffieldtype);

									String _refviewurl = StringHelper.null2String(refrefobj.getViewurl());
									String _refreftable = StringHelper.null2String(refrefobj.getReftable());
									String _refkeyfield = StringHelper.null2String(refrefobj.getKeyfield());
									String _refviewfield = StringHelper.null2String(refrefobj.getViewfield());
									
									_viewurl = _refviewurl;
								
									//存在一个字段对应多个值的情况，所以用 like 
										sql = "select distinct a." + _keyfield + " as objid,b."+ _refviewfield +" as objname " 
											 + "from " + _reftable + " a,"+ _refreftable +" b where a." + _keyfield + " ='" + fieldvalue + "'"
											 + " and a." + reffieldname + " like '%' + b.id + '%'";
											
								}else{
									sql = "select " + _keyfield + " as objid," + reffieldname + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
									_viewurl = "";
								}
							}
//							*******************************************************************************************************	

//							System.out.println("--------sql:" + sql);

							List reflist = dataService.getValues(sql);
							Map tmprefmap = null;
							String tmpobjname = "";
							String tmpobjid = "";
							for(int n=0; n< reflist.size(); n++){
								tmprefmap = (Map)reflist.get(n);
								tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
								try{
									tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
								}catch(Exception e){
									tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
								}
								
								if(StringHelper.isEmpty(href)&&!StringHelper.isEmpty(_viewurl)){//以里面定义为主

									showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
									showname += tmpobjname;
									showname += "</a>";

								}else{
									if(n==reflist.size()-1){
										showname += tmpobjname;
									}else{
										showname += tmpobjname + ", ";
									}
								}

							}
							
							if("humres".equals(_reftable)){//添加RTX在线感知
								rtxstr = humresService.getRTXHtml(tmpobjid);
							}
						}

						fieldvalue = showname;
					}			
				}
				StringBuffer fieldvalue7 = new StringBuffer("");
				if(htmltype.equals("7")&&!StringHelper.isEmpty(fieldvalue)){
					Forminfo forminfo = forminfoService.getForminfoById(formfield.getFormid());
					Attach attach = attachService.getAttach(fieldvalue);
					if(attach!=null){
						//int righttype = permissiondetailService.getAttachOpttype((String)reportMap.get("id"),forminfo.getObjtablename());
						fieldvalue = attach.getObjname();
						formfieldvalue = fieldvalue;
		
						fieldvalue7.append("<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid=")
							.append(attach.getId()).append("&download=1").append("\">").append(fieldvalue).append("</a>");
	
					}
				}
				
				reportdataMap.put(formfieldname,formfieldvalue);
				
				if(StringHelper.isEmpty(href)){
		%>	
            <td id="<%=i%>_<%=j%>" <%if(isalign){%>  align="right" <%} %>>
            	<%
            		if(htmltype.equals("7")){
            	%>
            	<%=StringHelper.null2String(fieldvalue7.toString())%>
            	<%
            		}else{
            	%>
            	<%=StringHelper.null2String(fieldvalue)%><%=rtxstr%>
            	<%}%>
            </td>
            
            
<script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>
         <%				
				
				}else{
					Iterator pagemenuparakeyit = reportMap.keySet().iterator();
					while (pagemenuparakeyit.hasNext()) {
						String pagemenuparakey = (String)pagemenuparakeyit.next();
						String pagemenuparakey2 = "{" + pagemenuparakey + "}";
						href = StringHelper.replaceString(href,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
					}

		%>	
            <td id="<%=i%>_<%=j%>" >
            
            	<%
            		if(htmltype.equals("7")){
            	%>
            	<%=StringHelper.null2String(fieldvalue7.toString())%>
            	<%
            		}else{
            	%>
            	<a href="<%=href%>" target="_bank"><%=StringHelper.null2String(fieldvalue)%></a><%=rtxstr%>
            	<%}%>
            </td>
          <script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>
         <%
         }
         }else{
         if(StringHelper.isEmpty(href)){
			%>	
	            <td></td>
	            
	         <%         
         }else{
					Iterator pagemenuparakeyit = reportMap.keySet().iterator();
					while (pagemenuparakeyit.hasNext()) {
						String pagemenuparakey = (String)pagemenuparakeyit.next();
						String pagemenuparakey2 = "{" + pagemenuparakey + "}";
						href = StringHelper.replaceString(href,pagemenuparakey2.toLowerCase(),StringHelper.null2String(reportMap.get(pagemenuparakey.toLowerCase())));
					}
      
		%>	
            <td id="<%=i%>_<%=j%>"><a href="<%=href%>" target="_bank"><%=reportfield.getShowname() %></a></td>
<script language="javascript">
changestype("<%=i%>_<%=j%>","<%=alertcon%>");
</script>           
         <%         
         }
         }
         j++;
         
         }
         reportdatalist.add(reportdataMap);
         %>   
          </tr>			

		<%
		  }
		  %>
		  <tr>
		  <% 
		 request.getSession().setAttribute("reportdatalist",reportdatalist);
		 
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			Reportfield reportfield = (Reportfield) it2.next(); 
			String formfieldid = "";
			Formfield formfield = null;
			
			if(reportfield.getIssum().toString().equals("1") && summap != null){
				formfieldid = reportfield.getFormfieldid();
				formfield = formfieldService.getFormfieldById(formfieldid);
				String allmoney = "0";
				if(summap.get("sum_"+formfield.getFieldname())!=null){
					allmoney = StringHelper.null2String(summap.get("sum_"+formfield.getFieldname()));
				}
				
		%>	
            <td  align="right"><%=new java.text.DecimalFormat("#,##0.00").format(Double.valueOf(allmoney))%></td>
            
         <%			
			
			}else{
		%>	
            <td></td>
            
         <%			
			}
		}
	}
	
	
		%>	

	   		</tr>
	   </table>
       <br>
			<table border="0">
				<tr>
					<td>&nbsp;</td>
					<td nowrap align=center>						
						<%=labelService.getLabelName("402881e60aabb6f6010aabba742d0001")%>[<%=pageObject.getTotalPageCount()%>]
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbb07a30002")%>[<%=pageObject.getTotalSize()%>]
						&nbsp;
					</td>

					<td nowrap align=center>
						<button  type="button" accessKey="F" onclick="onSearch(1)">
					     <U>F</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbb63210003")%>
				        </button>&nbsp;
						<button  type="button" accessKey="P" onclick="onSearch(<%=pageObject.getCurrentPageNo()==1?1:pageObject.getCurrentPageNo()-1%>)">
					     <U>P</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbba5b80004")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="N" onclick="onSearch(<%=pageObject.getCurrentPageNo()==pageObject.getTotalPageCount()? pageObject.getTotalPageCount():pageObject.getCurrentPageNo()+1%>)">
					     <U>N</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbbdc0a0005")%>
				        </button>&nbsp;
				        <button  type="button" accessKey="L" onclick="onSearch(<%=pageObject.getTotalPageCount()%>)">
					     <U>L</U>--<%=labelService.getLabelName("402881e60aabb6f6010aabbc0c900006")%>
				        </button>
					</td>
					<td nowrap align=center>
						<%=labelService.getLabelName("402881e60aabb6f6010aabbc75d90007")%>
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:document.EweaverForm.submit();">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:document.EweaverForm.submit();">
					</td>
					<td>&nbsp;</td>
				</tr>
			</table>    
</body>
</html>
