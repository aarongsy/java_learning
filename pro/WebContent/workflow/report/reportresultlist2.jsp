<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@page import="com.eweaver.workflow.version.service.WorkflowVersionService"%>
<%@page import="com.eweaver.workflow.version.model.WorkflowVersion"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="com.eweaver.workflow.report.model.*" %>
<%@ page import="com.eweaver.workflow.report.service.*" %>
<%@ page import="com.eweaver.base.label.service.LabelCustomService"%>
<%@ include file="/humres/base/openhrm.jsp"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
int pageSize=20;
int gridWidth=700;
int gridHeight=330;
 String isshow=StringHelper.null2String(request.getParameter("isshow")) ; //isshow=0表示默认不加载出数据
String reportid = request.getParameter("reportid");
String sqlstr1= StringHelper.null2String(request.getAttribute("sqlstr1"));
String sqlstr2= StringHelper.null2String(request.getAttribute("sqlstr2"));
String isformbase = StringHelper.null2String(request.getParameter("isformbase"));
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String groupby=StringHelper.null2String(request.getParameter("groupby"));
String groupby1="";
String groupby2="";
String contemplateid = StringHelper.null2String(request.getAttribute("contemplateid"));
Page pageObject = (Page) request.getAttribute("pageObject");
if(!StringHelper.isEmpty(isshow)&&isshow.equals("0"))
 pageObject=null;
Map summap = (Map)request.getAttribute("sum");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
ReportdefService reportdefService = (ReportdefService)BaseContext.getBean("reportdefService");
CombinefieldService combinefieldService = (CombinefieldService)BaseContext.getBean("combinefieldService");
LabelCustomService labelCustomService = (LabelCustomService)BaseContext.getBean("labelCustomService");
DataService dataService=new DataService();
Reportdef reportdef = reportdefService.getReportdef(reportid);
ContemplateService contemplateService = (ContemplateService)BaseContext.getBean("contemplateService");
if(StringHelper.isEmpty(contemplateid)){
    List contemplateList = dataService.getValues("select cp.* from contemplate cp,contemplatestate cs" +
							" where cp.id=cs.contemplateid and cp.reportid='"+reportid+"' and cp.userid='"+currentuser.getId()+"'" +
							" and cp.ispublic='False' and cs.isdefault=1 order by objdesc ");
    if(contemplateList.size()!=0){
        contemplateid = StringHelper.null2String(((Map)contemplateList.get(0)).get("id"));
        contemplateList = dataService.getValues("select cp.* from contemplate cp,contemplatestate cs " +
				    			" where cp.id=cs.contemplateid and cp.reportid='"+reportid+"' and cp.ispublic='True' " +
				    			" and cs.isdefault=1 and cs.userid='"+currentuser.getId()+"' order by objdesc  ");
        if(contemplateList.size()!=0){
        	 contemplateid = StringHelper.null2String(((Map)contemplateList.get(0)).get("id"));
        }
    }
}
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,contemplateid);
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}else{
    boolean fatg=true;
    for(int i=0;i<reportfieldList.size();i++){
        Reportfield reportfield = (Reportfield)reportfieldList.get(i);
        if(reportfield.getFormfieldid().equals(reportdef.getGroupby())){
            fatg=false;
            break;
        }
    }
    if(fatg){
        Reportfield reportfieldObj = reportfieldService.getReportfieldByFormFieldId(reportid,reportdef.getGroupby());
        reportfieldList.add(reportfieldObj);
    }
    reportdef.getGroupby();
}
String formid=reportdef.getFormid();
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=fieldsearchMap.keySet();
        for(Object key:keySet){
            String value=(String)fieldsearchMap.get(key);
            if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
        }
        jsonStr=jsonObject.toString();
    }

String workflowversionid=StringHelper.null2String(request.getParameter("workflowversionid"));
%>

<!--页面菜单开始-->
<%

paravaluehm.put("{id}",reportid);
//pagemenustr +="addBtn(tb,'"+labelService.getLabelName("快捷搜索")+"','S','zoom',function(){onSearch2()});";
pagemenustr+=" tb.add(querybtn);";
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("清空条件")+"','R','erase',function(){reset()});";
pagemenustr +="addBtn(tb,'"+labelService.getLabelName("高级搜索")+"','G','zoom',function(){onSearch3()});";
PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
pagemenustr += _pagemenuService2.getPagemenuStrExt(reportid,paravaluehm).get(0);



if(pagemenuorder.equals("0")) {
	pagemenustr =_pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService2.getPagemenuStrExt(theuri,paravaluehm).get(0);
}

    //pagemenustr += "addBtn(tb,'"+labelService.getLabelName("模板管理")+"','M','page_copy',function(){showtemplate()});";

%>
<html>
<head>
<style type="text/css">
    .x-toolbar table {width:0}
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
       .ux-maximgb-treegrid-breadcrumbs{
         display:none;
     }
     a { color:blue; cursor:pointer; }
</style>
<script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%=request.getContextPath()%>/js/browinfo.js"></script>
<script src='<%=request.getContextPath()%>/dwr/interface/FormbaseService.js'></script>  
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='<%=request.getContextPath()%>/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/MultiGrouping.js"></script>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/tx/jquery.autocomplete.css"/>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/js/ext/ux/css/multigrid.css"/>
  <script language="javascript">
  var queryMenu = new Ext.menu.Menu({
				shadow :false,
				items :[
					<%
                         List contemplateList= (List) request.getAttribute("contemplateList");
                         if(contemplateList!=null){
                         for(int i=0;i<contemplateList.size();i++){
                            Contemplate contemplate= (Contemplate) contemplateList.get(i);
                     %>
                     {
						id:'<%=contemplate.getId()%>',
				       	text:'<%=contemplate.getObjname()%>', 	
						icon:<%if("True".equals(contemplate.getIspublic()))out.print("'/images/silk/zoom.gif'");else out.print("'/images/silk/zoom_in.gif'");%>,
						handler:function(){onSearchByTemplate('<%=contemplate.getId()%>');}
					},
                     <%
                         }
                         }
                     %>
                     new Ext.menu.Separator(),//分隔线 
                     {
						id:'macontemplate',
				       	text:'<%=labelService.getLabelName("模板管理")%>',
				       	key:'M',
				       	alt:true,
						icon:'/images/silk/page_copy.gif',
						handler:function(){showtemplate();}
					},
					{
						id:'savecontemplate',
				       	text:'<%=labelService.getLabelName("保存查询条件至模板")%>',
				       	key:'S',
				       	alt:true,
						icon:'/images/silk/disk.gif',
						handler:function(){sAlert();}
					}
				]}
			
			);	
var querybtn = new Ext.Toolbar.SplitButton({
					   	id:'querybtn',
					   	text:'<%=labelService.getLabelName("快捷搜索")%>(S)',
					   	key:'S',
					   	alt:true,
						iconCls:Ext.ux.iconMgr.getIcon('zoom'),
						handler:function(){onSearch2()},
						menu :queryMenu
					});
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}
</script>

<script type="text/javascript">
 var dlg0;
 var viewport=null;
 var selected=new Array();
   var store;
    <%
        String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=" + reportid;
String tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=searchtemplate&reportid="+reportid;
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=" + reportid;
    tmpaction = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=searchtemplate&reportid="+reportid;
	
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}
int viewtype=reportdef.getViewType();
if(isformbase!=null && !isformbase.equals("")){
    tmpaction +="&isformbase="+isformbase;
}
        String cmstr="";
        String  readerStr="";
        if(reportdef.getIsbatchupdate().intValue()==1){
            readerStr="{name:'requestid'}";
        }
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        groupby=StringHelper.null2String(reportdef.getGroupby());
        groupby1=StringHelper.null2String(reportdef.getGroupby1());
        groupby2=StringHelper.null2String(reportdef.getGroupby2());
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
            int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	String fieldname=labelService.getLabelName(formfields.getFieldname()) ;
         	if(!groupby.equals("")&&groupby.equals(reportfield.getFormfieldid()))
         	groupby=fieldname;
         	if(!groupby1.equals("")&&groupby1.equals(reportfield.getFormfieldid()))
         	groupby1=fieldname;
         	if(!groupby2.equals("")&&groupby2.equals(reportfield.getFormfieldid()))
         	groupby2=fieldname;
         	String showname=labelService.getLabelName(reportfield.getShowname());
         	if(groupby.equals("")&&k==0)
         	groupby=fieldname;
         	if(cmstr.equals("")){
         	if(reportdef.getIsbatchupdate().intValue()==1){
         	readerStr+=",{name:'"+fieldname+"'}";
         	}else{
         	readerStr+="{name:'"+fieldname+"'}";
         	}
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            }else{
            readerStr+=",{name:'"+fieldname+"'}";
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            }
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到
       //grid data
	   JSONArray jsonData = new JSONArray();
	   if(pageObject!=null){
       int total = pageObject.getTotalSize();
                //List reportfieldList = reportfieldService.getReportfieldListForUser(reportid, BaseContext.getRemoteUser().getId());
                if (reportfieldList.size() == 0) {
                    reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
                }
                List result=new ArrayList();
                if(total>0)
                result = (List) pageObject.getResult();
                for (Object o : result) {
                    HashMap reportdataMap = new HashMap();
                    JSONArray jsonArray = new JSONArray();
                    if(reportdef.getIsbatchupdate().intValue()==1){
                    jsonArray.add(((Map) o).get("requestid"));                    
                    }
                    Iterator it2 = reportfieldList.iterator();
                    while (it2.hasNext()) {
                        String rtxstr = "";
                        Reportfield reportfield = (Reportfield) it2.next();
                        String alertcon = StringHelper.null2String(reportfield.getAlertcond());

                        if (!StringHelper.isEmpty(alertcon)) {
                            Iterator pagemenuparakeyit3 = ((Map) o).keySet().iterator();
                            while (pagemenuparakeyit3.hasNext()) {
                                String pagemenuparakey = (String) pagemenuparakeyit3.next();
                                String pagemenuparakey2 = "{" + pagemenuparakey + "}";
                                alertcon = StringHelper.replaceString(alertcon, pagemenuparakey2.toLowerCase(), StringHelper.null2String(((Map) o).get(pagemenuparakey.toLowerCase())));
                            }
                        }

                        String formfieldid = reportfield.getFormfieldid();
                        String href = reportfield.getHreflink();//报表中配置的链接，如果报表关联字段browser中已配置了链接，刚此处的链接不起作用
                        Formfield formfield = formfieldService.getFormfieldById(formfieldid);
                        boolean isalign = false;//数字是否右对齐
                        String realvalue = "";
                        if (formfield != null && !StringHelper.isEmpty(formfield.getId())) {
                        String fieldvalue="";
                            String formfieldname = formfield.getFieldname();
                            /****************start*修改分组报表中字段名称为subject连接不起作用  xrj*******************/
                            String formidbydoc=formfield.getFormid();
                             Forminfo finfo=forminfoService.getForminfoById(formidbydoc);
                             /****************end*修改分组报表中字段名称为subject连接不起作用  xrj*******************/
                             if(formfieldname.equals("subject")&&finfo.getObjtablename().equals("docbase")){
                                String subject="";
                                 subject = "<a href=\"javascript:onUrl('"+request.getContextPath()+"/document/base/docbaseview.jsp?id=" + ((Map) o).get("id") +"','"+((Map) o).get(formfieldname)+ "','tab"+((Map) o).get("id")+"')\" ext:qtip='"+((Map) o).get(formfieldname)+"'>"+ ((Map) o).get(formfieldname) + "</a>";
                              fieldvalue =subject;
                           }else if(formfieldname.equals("docabstract")&&finfo.getObjtablename().equals("docbase"))
                           {
                               String contentvalue = "<a onclick=\"openchild('/document/base/basechild.jsp?objid="+ ((Map) o).get("id")+"')\">"+labelService.getLabelNameByKeyId("402881eb0bcd354e010bcdaaae37001e")+"</a>";//摘要
                               fieldvalue=contentvalue;
                           }
                           else
                           {
                                 fieldvalue = StringHelper.null2String(((Map) o).get(formfieldname));
                           }
                           //对象对应的ID
                            String fieldtype = formfield.getFieldtype();//字段对应类型（通过此类型得到相应对象是selectitem还是browser，从而得到对应ID的显示名）


                            String formfieldvalue = "";//生成excel报表时用到


                            String htmltype = "";
                            if (formfield.getHtmltype() != null) {
                                htmltype = formfield.getHtmltype().toString();
                            }

                            if (htmltype.equals("1") && (fieldtype.equals("2") || fieldtype.equals("3"))) {
                                if (StringHelper.isEmpty(fieldvalue)) {
                                    fieldvalue = "0";
                                }
                                if (reportfield.getShowmethod() != null && "4".equals(reportfield.getShowmethod()))
                                {


                                    if (Double.valueOf(fieldvalue).doubleValue() < 100.00) {
                                              fieldvalue = "<div id=\"p2\" >\n" +
                                                " <div style=\"width: auto; height: 15px;\" id=\"pbar2\" class=\"x-progress-wrap left-align\">\n" +
                                                "          <div class=\"x-progress-inner\">\n" +
                                                "              <div style=\"width: " +fieldvalue+ "%; height: 15px;\" id=\"ext-gen9\" class=\"x-progress-bar\">\n" +
                                                "              <div style=\"z-index: 99; width: 100px;\" id=\"ext-gen10\" class=\"x-progress-text x-progress-text-back\">" +
                                                "           <div style=\"width: 100px; height: 15px;\" id=\"ext-gen12\">" + fieldvalue + "%" + "</div>" +
                                                "             </div>\n" +
                                                "           </div>\n" +
                                                "          </div>\n" +
                                                "      </div>\n" +
                                                "  </div>";



                                    } else {

                                            fieldvalue = "<div id=\"p2\" >\n" +
                                                " <div style=\"width: auto; height: 15px;\" id=\"pbar2\" class=\"x-progress-wrap left-align\">\n" +
                                                "          <div class=\"x-progress-inner\">\n" +
                                                "              <div style=\"width:"+100+"%; height: 15px;\" id=\"ext-gen9\" class=\"x-progress-bar\">\n" +
                                                "              <div style=\"z-index: 99; width: 100px;\" id=\"ext-gen10\" class=\"x-progress-text x-progress-text-back\">" +
                                                "           <div style=\"width: 100px; height: 15px;\" id=\"ext-gen12\">" + 100 + "%" + "</div>" +
                                                "             </div>\n" +
                                                "           </div>\n" +
                                                "          </div>\n" +
                                                "      </div>\n" +
                                                "  </div>";



                                    }

                                } else {

                                }

                                isalign = true;
                            }

                            if (htmltype.equals("4")) {
                                if ("1".equals(fieldvalue)) {
                                    fieldvalue = "<IMG SRC='"+request.getContextPath()+"/images/base/bacocheck.gif' >";
                                } else {
                                    fieldvalue = "<IMG SRC='"+request.getContextPath()+"/images/base/bacocross.gif' >";
                                }
                            }
//				System.out.println("--------isalign:" + isalign);
//				System.out.println("--------fieldvalue:" + fieldvalue + "-------htmltype:" + htmltype);
                            if (htmltype.equals("5") && !StringHelper.isEmpty(fieldvalue)) {

                                Selectitem selectitem = selectitemService.getSelectitemById(fieldvalue);
                                if("0".equals(reportfield.getShowmethod()))
                                {
                                     if (selectitem != null) {
                                    fieldvalue = selectitem.getObjname();
                                    formfieldvalue = fieldvalue;
                                     }

                                } else if ("1".equals(reportfield.getShowmethod())) {
                                    if (selectitem != null) {
                                        String imagfield = "<IMG SRC='" + request.getContextPath()+selectitem.getImagefield() + "' width=12px height=10px title='" + selectitem.getObjname() + "'/>";
                                        fieldvalue = imagfield;
                                        if (selectitem.getImagefield() == null)
                                            fieldvalue = selectitem.getObjname();
                                        formfieldvalue = fieldvalue;
                                    }

                                } else if ("2".equals(reportfield.getShowmethod())) {
                                    if (selectitem != null) {
                                        String imagfield = "<IMG SRC='" + request.getContextPath()+selectitem.getImagefield() + "' width=12px height=10px />";
                                        fieldvalue = imagfield + selectitem.getObjname();
                                        if (selectitem.getImagefield() == null)
                                            fieldvalue = selectitem.getObjname();
                                        formfieldvalue = fieldvalue;
                                    }

                                }
                                else
                                {
                                    if (selectitem != null) {
                                        fieldvalue = selectitem.getObjname();
                                        formfieldvalue = fieldvalue;
                                    }
                                }

                                 }

                            if (htmltype.equals("6") && !StringHelper.isEmpty(fieldvalue)) {
                                Refobj refobj = refobjService.getRefobj(fieldtype);
                                if (refobj != null) {
                                    String _refid = StringHelper.null2String(refobj.getId());
                                    String _refurl = StringHelper.null2String(refobj.getRefurl());
                                    String _viewurl = StringHelper.null2String(refobj.getViewurl());
                                    String _reftable = StringHelper.null2String(refobj.getReftable());
                                    String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                                    String _viewfield = StringHelper.null2String(refobj.getViewfield());

                                    String showname = "";
                                    if (!StringHelper.isEmpty(formfieldname)) {
                                        String reffieldid = StringHelper.null2String(reportfield.getCol1());
                                        String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
                                        //得到对象ID对应的objname

                                        if (fieldvalue.contains(",")) {//如果关联字段是多值的(比如多选browser)
                                            sql = "select distinct " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(fieldvalue) + ")";
                                        }

//							*******************************************************************************************************
//							如果存在关联字段
                                        if (!reffieldid.equals("")) {
                                            Formfield refformfield = formfieldService.getFormfieldById(reffieldid);
                                            String refhtmltype = "";
                                            if (refformfield.getHtmltype() != null) {
                                                refhtmltype = refformfield.getHtmltype().toString();
                                            }

                                            String reffieldname = StringHelper.null2String(refformfield.getFieldname());
                                            String reffieldtype = StringHelper.null2String(refformfield.getFieldtype());
                                            if (refhtmltype.equals("5")) {
                                                sql = "select a." + _keyfield + " as objid,b.objname as objname "
                                                        + "from " + _reftable + " a,Selectitem b where a." + _keyfield + " ='" + fieldvalue + "'"
                                                        + " and a." + reffieldname + "=b.id";

                                                _viewurl = "";
                                            } else if (refhtmltype.equals("6")) {
                                                Refobj refrefobj = refobjService.getRefobj(reffieldtype);

                                                String _refviewurl = StringHelper.null2String(refrefobj.getViewurl());
                                                String _refreftable = StringHelper.null2String(refrefobj.getReftable());
                                                String _refkeyfield = StringHelper.null2String(refrefobj.getKeyfield());
                                                String _refviewfield = StringHelper.null2String(refrefobj.getViewfield());

                                                _viewurl = _refviewurl;

                                                //存在一个字段对应多个值的情况，所以用 like
                                                sql = "select distinct a." + _keyfield + " as objid,b." + _refviewfield + " as objname "
                                                        + "from " + _reftable + " a," + _refreftable + " b where a." + _keyfield + " ='" + fieldvalue + "'"
                                                        + " and a." + reffieldname + " like '%' + b.id + '%'";

                                            } else {
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
                                        for (int n = 0; n < reflist.size(); n++) {
                                            tmprefmap = (Map) reflist.get(n);
                                            tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                                            try {
                                                tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                                            } catch (Exception e) {
                                                tmpobjname = ((java.math.BigDecimal) tmprefmap.get("objname")).toString();
                                            }

                                            if (StringHelper.isEmpty(href) && !StringHelper.isEmpty(_viewurl)) {//以里面定义为主
                                              if (_refid.equals("402881e70bc70ed1010bc75e0361000f")) {     //员工
                                                showname +="&nbsp;&nbsp;<a  onclick=openhrm('" + tmpobjid + "',this,'"+tmpobjname+"')>" ;
                                                showname += tmpobjname;
                                                showname += "</a>";
                                                }else{
                                                 showname +="&nbsp;&nbsp;<a href=\"javascript:onUrl('" + _viewurl + tmpobjid +"','"+tmpobjname+ "','tab"+tmpobjid+"')\" >" ;
                                                showname += tmpobjname;
                                                showname += "</a>";
                                                       }


                                            } else {
                                                if (n == reflist.size() - 1) {
                                                    showname += tmpobjname;
                                                } else {
                                                    showname += tmpobjname + ", ";
                                                }
                                            }

                                        }

                                        if ("humres".equals(_reftable)) {//添加RTX在线感知
                                            rtxstr = humresService.getRTXHtml(tmpobjid);
                                        }
                                    }
                                    fieldvalue = showname;
                                }
                            }
                            StringBuffer fieldvalue7 = new StringBuffer("");
                            if (htmltype.equals("7") && !StringHelper.isEmpty(fieldvalue)) {
                                Forminfo forminfo = forminfoService.getForminfoById(formfield.getFormid());
                                List<Attach> attachList = attachService.getAttachs(fieldvalue);
                                formfieldvalue = fieldvalue;
                                if (attachList != null && !attachList.isEmpty()) {
                                    //int righttype = permissiondetailService.getAttachOpttype((String)reportMap.get("id"),forminfo.getObjtablename());
                                    for(Attach attach:attachList){
                                    	fieldvalue7.append("<a href=\"javascript:if(top.frames[1])onUrl('" 
												+ request.getContextPath()+ "/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" 
												+attach.getId()+"&download=1"+"','"
												+ StringHelper.null2String(attach.getObjname())
												+ "','tab" + attach.getId() + "')\" >").append(StringHelper.null2String(attach.getObjname())).append("</a>&nbsp;&nbsp;");
	                                }//end.if
                                }
                            }
                            reportdataMap.put(formfieldname, formfieldvalue);

                            if (StringHelper.isEmpty(href)) {
                                if (htmltype.equals("7")) {
                                    realvalue = StringHelper.null2String(fieldvalue7.toString());
                                } else {
                                    realvalue = StringHelper.null2String(fieldvalue) + rtxstr;
                                }
                            } else {
                            	Map map=reportdefService.getReportMap(reportid,(Map)o);
                                Iterator pagemenuparakeyit = map.keySet().iterator();
                                String tabkey="";
                                while (pagemenuparakeyit.hasNext()) {
                                    String pagemenuparakey = (String) pagemenuparakeyit.next();
                                    String pagemenuparakey2 = "{" + pagemenuparakey + "}";
                                    href = StringHelper.replaceString(href, pagemenuparakey2.toLowerCase(), StringHelper.null2String(map.get(pagemenuparakey.toLowerCase())));
                                    if(tabkey.equals(""))
                                    tabkey+=StringHelper.null2String(map.get(pagemenuparakey.toLowerCase()));
                                    if((pagemenuparakey.equalsIgnoreCase("id")||pagemenuparakey.equalsIgnoreCase("requestid")))
                                    tabkey=StringHelper.null2String(map.get(pagemenuparakey.toLowerCase()));
                                }
                                if (htmltype.equals("7")) {
                                    realvalue = StringHelper.null2String(fieldvalue7.toString());
                                } else {
                                    realvalue ="<a href=\"javascript:onUrl('" + href +"','"+StringHelper.convertToUnicode(StringHelper.null2String(fieldvalue))+ "','tab"+tabkey+"')\" >"+ StringHelper.null2String(fieldvalue)+"</a>" + rtxstr;
                                }
                            }

                            jsonArray.add(realvalue);

                        } else {
                            if (StringHelper.isEmpty(href)) {

                                realvalue = "";

                            } else {
                                Iterator pagemenuparakeyit = ((Map) o).keySet().iterator();
                                String tabkey="";
                                while (pagemenuparakeyit.hasNext()) {
                                    String pagemenuparakey = (String) pagemenuparakeyit.next();
                                    String pagemenuparakey2 = "{" + pagemenuparakey + "}";
                                    href = StringHelper.replaceString(href, pagemenuparakey2.toLowerCase(), StringHelper.null2String(((Map) o).get(pagemenuparakey.toLowerCase())));
                                    if(tabkey.equals(""))
                                    tabkey+=StringHelper.null2String(((Map) o).get(pagemenuparakey.toLowerCase()));
                                    if((pagemenuparakey.equalsIgnoreCase("id")||pagemenuparakey.equalsIgnoreCase("requestid")))
                                    tabkey=StringHelper.null2String(((Map) o).get(pagemenuparakey.toLowerCase()));
                                }


                                realvalue ="<a href=\"javascript:onUrl('" + href +"','"+reportfield.getShowname()+ "','tab"+tabkey+"')\" >" + reportfield.getShowname() + "</a>";
                            }
                            //todo
                            //jsonObject.put(name, realvalue);
                        }
                    }
                    jsonData.add(jsonArray);
                    //reportdatalist.add(reportdataMap);
                }
	   }
      %>
    <%
    	if(isSysAdmin){
    		pagemenustr +="tb.add('->');";
    		pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220035")+"','T','page_white_gear',function(){toSet('"+reportid+"','report')});";//报表设置
    %>
    		function toSet(soureid,souretype){
				var url='/base/toSet.jsp?soureid='+soureid+'&souretype='+souretype
				onUrl(url,'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a001b")%>',soureid);//设置
			}
    <%}%>
    Ext.onReady(function(){
    var xg = Ext.grid;
                       <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
       <%=pagemenustr%>
       tb.add('->');
        tb.add(pagemenutable);
       <%}%>
                       // shared reader
                       var reader = new Ext.data.ArrayReader({}, [
                          <%=readerStr%>
                       ]);
                store=new <%if(viewtype==1){%>Ext.data.GroupingStore<%}else if(viewtype==3){%>Ext.ux.MultiGroupingStore<%}%>({
                               reader: reader,
                               data: xg.dummyData,
                               sortInfo:{field: '<%=groupby%>', direction: "ASC"},
                               <%if(viewtype==1){%>
                               groupField: '<%=groupby%>'
                               <%}else if(viewtype==3){%>
                               groupField: ['<%=groupby%>'<%=(groupby1==""?groupby1:",'"+groupby1+"'")%><%=(groupby2==""?groupby2:",'"+groupby2+"'")%>]
                               <%}%>
                           })
               <%
                if(reportdef.getIsbatchupdate().intValue()==1){
                %>
             var sm=new Ext.grid.CheckboxSelectionModel();
             <%}%>
                   var grid = new <%if(viewtype==1){%>Ext.grid.GridPanel<%}else if(viewtype==3){%>Ext.ux.MultiGroupingPanel<%}%>({
                	   autoScroll:true,
                       region: 'center',
                       store:store ,
                       <%
                        if(reportdef.getIsbatchupdate().intValue()==1){
                       %>
                       columns: [sm,
                               <%=cmstr%>
                           ],
                       sm:sm,
                       <%}else{%>
                         columns: [
                               <%=cmstr%>
                           ],
                       <%}%>
                       view: new <%if(viewtype==1){%>Ext.grid.GroupingView<%}else if(viewtype==3){%>Ext.ux.MultiGroupingView<%}%>({
                               //forceFit:true,
                               startCollapsed:<%if(viewtype==1){%>true<%}else if(viewtype==3){%>false<%}%>,
                               displayEmptyFields: true,
                               groupedbyText:'<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d8522003a")%>:',//拖动列分组
							   sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000")%>',//升序
                               sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000")%>',//降序
							   groupByText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0064")%>',//按此列分组
							   showGroupsText:'<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0065")%>',//分组显示
                               columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000")%>',//列定义
                               groupTextTpl: '{text}<%if(viewtype==3){%>:{gvalue}<%}%> ({[values.rs.length]})'
                                //-------------给报表grid添加左右滚动条start-----------
	                           ,scrollOffset: -3 //去掉右侧空白区域  
							   /*,layout : function() {
								  var obj = this; 	
								  //此处延迟执行是因为在grid layout的时候会出现一次列宽极大值的现象，导致计算列宽总和不准确，给根据列宽动态增加滚动条带来了影响。
								  //延迟执行可避免这种情况发生
								  setTimeout(function(){	
	                        	 	if (!obj.mainBody) {
						       			return; // not rendered
									}
									var g = obj.grid;
									var c = g.getGridEl();
									var csize = c.getSize(true);
									var vw = csize.width;
									var vh=csize.height;
									if (!g.hideHeaders && (vw < 20 || csize.height < 20)) { // display:
									 return;
									}
									//计算列的宽度总和
									var colTotalWidth = 0;
									var clModel = g.getColumnModel();
									for(var i = 0; i < clModel.getColumnCount(); i++){
									 colTotalWidth = colTotalWidth + clModel.getColumnWidth(i);
									}
									if(colTotalWidth > 0){
										colTotalWidth = colTotalWidth - 5;
									}
									obj.el.dom.style.width = "100%";
									if(colTotalWidth > obj.el.dom.clientWidth){	//当列的宽度总和大于表格可视宽度时，才添加横向滚动条
						      			if (g.autoHeight) {
											//计算grid高度
											var girdcount = store.getCount();
											var gridHeight=0;
											for(var i=0;i<girdcount;i++){
											    gridHeight=gridHeight+grid.getView().getRow(i).clientHeight;
											}
											obj.el.dom.style.height =gridHeight+250;//75是菜单栏和分页栏高度和
											obj.el.dom.style.overflowX = "auto"; //只显示横向滚动条
										}else{
											obj.el.dom.style.height = g.getInnerHeight();
											obj.el.dom.style.overflowX = "auto"; //只显示横向滚动条
										}
									}
									if (obj.forceFit) {
										if (obj.lastViewWidth != vw) {
											obj.fitColumns(false, false);
											obj.lastViewWidth = vw;
										}
									} else {
										obj.autoExpand();
										obj.syncHeaderScroll();
									}
	                             }, 1000);
						      
						       }*/
                           
                          	   //-------------给报表grid添加左右滚动条end-----------
                           }),
                       frame:true,
                           collapsible: false,
                           animCollapse: true,
                           //title: '列表',
                           iconCls: 'icon-grid'

    });
 <%
    if(reportdef.getIsbatchupdate().intValue()==1){
 %>
        store.on('load',function(st,recs){
                            for(var i=0;i<recs.length;i++){
                                var reqid=recs[i].get('requestid');
                                for(var j=0;j<selected.length;j++){
                                            if(reqid ==selected[j]){
                                                 sm.selectRecords([recs[i]],true);
                                             }
                                         }
                                    }
                                }
                            );

                            sm.on('rowselect',function(selMdl,rowIndex,rec ){
                                var reqid=rec.get('requestid');
                                for(var i=0;i<selected.length;i++){
                                            if(reqid ==selected[i]){
                                                 return;
                                             }
                                         }
                                selected.push(reqid)
                            }
                                    );
                            sm.on('rowdeselect',function(selMdl,rowIndex,rec){
                                var reqid=rec.get('requestid');
                                for(var i=0;i<selected.length;i++){
                                            if(reqid ==selected[i]){
                                                selected.remove(reqid)
                                                 return;
                                             }
                                         }

                            }
                                    );
        <%}%>

    //Viewport
    //ie6 bug
    Ext.get('divSearch').setVisible(true);
	 viewport = new Ext.Viewport({
        layout: 'border',
        items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
	});
	//-------------给报表grid添加左右滚动条start-----------
	//grid.getView().mainBody.dom.style.width = grid.getView().getTotalWidth();
	//-------------给报表grid添加左右滚动条end-------------
          dlg0 = new Ext.Window({
                layout:'border',
                closeAction:'hide',
                plain: true,
                modal :true,
                width:viewport.getSize().width*0.8,
                height:viewport.getSize().height*0.8,
                buttons: [{
                    text     : '<%=labelService.getLabelName("关闭")%>',
                    handler  : function(){
                        dlg0.hide();
                    }

                }],
                items:[{
                id:'dlgpanel',
                region:'center',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{id:'dlgframe', name:'dlgframe', frameborder:0} ,
                    eventsFollowFrameLinks : false
                },
                autoScroll:true
            }]
            });
});
// Array data for the grids
                   Ext.grid.dummyData = <%=jsonData.toString()%>;


</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px" >


<div id="divSearch" style="display:none;" >
 <div id="pagemenubar"></div>
 <%
 	String language=StringHelper.isEmpty(eweaveruser.getSysuser().getLanguage())?"zh_CN":StringHelper.null2String(eweaveruser.getSysuser().getLanguage());
 %>
 <table <%if(language.equals("zh_CN")){ %> style="width:300px" <%}else{ %> style="width:360px" <%} %> id="pagemenutable">
         <tr>
             <td align="right">
                 <%-- <a href="javascript:sAlert();"><%=labelService.getLabelName("保存该查询条件至模板")%></a>&nbsp;
                 <select id="contemplate" onchange="onSearch4('<%=reportid%>')" style="width:150">
                     <option value="0"><%=labelService.getLabelName("请选择查询模板")%></option>
                     <%
                         List contemplateList= (List) request.getAttribute("contemplateList");
                         if(contemplateList!=null){
                         Iterator itObj=contemplateList.iterator();
                         while(itObj.hasNext()){
                            Contemplate contemplate= (Contemplate) itObj.next();
                     %>
                         <option value="<%=contemplate.getId()%>" <%if(contemplate.getId().equals(contemplateid)){%>selected="selected"<%}%>><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff679c1026e")%><%}else{%><%=labelService.getLabelNameByKeyId("40288035248fd7a801248ff7c9720270")%><%}%>)</option><!-- 私人   公共 -->
                     <%
                         }
                         }
                     %>
                 </select>--%>
             </td>
         </tr>
     </table>
 <!--页面菜单结束-->
     <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post">
     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
     <input type="hidden" name="objnamehidden" id="objnamehidden"/>
     <input type="hidden" name="sqlstr1" value="<%=sqlstr1%>"/>
     <input type="hidden" name="sqlstr2" value="<%=sqlstr2%>"/>
 <!--条件>
 <%
 //隐藏初使查询条件
 String initsqlwhere = StringHelper.null2String(request.getAttribute("initsqlwhere"));
 String initquerystr = StringHelper.null2String(request.getAttribute("initquerystr"));
 String[] convalue = initquerystr.split("&");
 for(int i=0; i < convalue.length; i++){
     String tempcon = convalue[i];
     if(!StringHelper.isEmpty(tempcon)){
         String[] conv = tempcon.split("=");
         String con = conv[0];
         String vle = "";
         if(conv.length==2){
             vle = conv[1];
         }
         %>
         <input type='hidden' name="<%=con %>" value="<%=vle %>">
         <%
     }
 }
 %>
 <input type='hidden' name="sqlwhere" id="sqlwhere" value="<%=initsqlwhere %>">
 <input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">

 <!--  ***************************************************************************************************************************-->
 <%
 //得到初使查询条件：

 Map hiddenMap = (Map)request.getAttribute("hiddenMap");
 String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
 if(descorasc.equals("desc")){
     descorasc = "asc";
 }else{
     descorasc = "desc";
 }
 String fieldopt = "";
 String fieldopt1 = "";
 String fieldvalue = "";
 String fieldvalue1 = "";

 ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");

 List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
 List formfieldlist = new ArrayList();
 it = reportSearchfieldList.iterator();
 while(it.hasNext()){

     Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
     String formfieldid = reportsearchfield.getFormfieldid();
     Formfield formfield = formfieldService.getFormfieldById(formfieldid);
     formfieldlist.add(formfield);
 }


 String[] checkcons = request.getParameterValues("check_con");


  %>
 <%if(hiddenMap != null){
   for(Object o:hiddenMap.keySet()){
       String value=(String)hiddenMap.get(o);
 %>
       <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
 <%
   }
 }%>
   <table class=viewform id="myTable">
   <%
	int tmpcount= 0;
	
	String isformbase2=StringHelper.null2String(reportdef.getIsformbase());
	String isshowversionquery=StringHelper.null2String(reportdef.getIsshowversionquery());
	WorkflowVersionService workflowVersionService=(WorkflowVersionService)BaseContext.getBean("workflowVersionService");
	boolean isWorkflowVersionEnable=workflowVersionService.isWorkflowVersionEnable();
	
	if("2".equals(isformbase2)&&"1".equals(isshowversionquery)&&isWorkflowVersionEnable){
		tmpcount=1;
	%>
		<tr class=title >
			<td class="FieldName" width=10% nowrap>流程版本</td>
			<td class='FieldValue' width=15% >
			<select class="inputstyle2" style="width:90%" id="workflowversionid"  name="workflowversionid">
			    <option value=""  selected  ></option>
			    <%
			    WorkflowinfoService workflowinfoService=(WorkflowinfoService)BaseContext.getBean("workflowinfoService");
			    String hql="select a from Workflowinfo a,WorkflowVersion b where a.formid='"+formid+"' and a.isdelete=0 and a.id=b.workflowid order by b.groupid,b.version";
			    List<Workflowinfo> workflowinfos=workflowinfoService.getWorkflowinfos(hql);
			    if(workflowinfos!=null&&workflowinfos.size()>0){
			    	for(Workflowinfo workflowinfo:workflowinfos){
			    		WorkflowVersion workflowVersion=workflowVersionService.getWorkflowVersionByWorkflowid(workflowinfo.getId());
			    		if(workflowVersion!=null){
			    			String selected="";
			    			if(workflowversionid.equals(workflowVersion.getId())){
			    				selected="selected";
			    			}
			    		%>
			    		<option value="<%=workflowVersion.getId()%>"  <%=selected%>><%=workflowinfo.getObjname()%></option>
			    		<%
			    		}
			    	}
			    }
			 	%>
			</select>
			</td>
	<%}
 int linecolor=0;

 boolean showsep = true;

 Iterator fieldit = formfieldlist.iterator();
Map _fieldcheckMap=new HashMap();
StringBuffer directscript=new StringBuffer();
while(fieldit.hasNext()){
  Formfield formfield = (Formfield)fieldit.next();
  String _htmltype = StringHelper.null2String(formfield.getHtmltype());
  String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
  String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
//系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
  if("402881e80c33c761010c33c8594e0005".equals(formid) || "402881e50bff706e010bff7fd5640006".equals(formid)){
 	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
 	 if(_field!=null){
 	 	_fieldcheck = _field.getId();
 	 }
  }
  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
  if(!_fieldcheck.equals("")&&fieldvalue!=null&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue); 
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 while(fieldit1.hasNext()){
     String msg="";
     Formfield formfield = (Formfield)fieldit1.next();
     String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
     if(formfield.getFillin()!=null && formfield.getFillin().equals("1"))
         {
             if(StringHelper.isEmpty(fieldvalue))
               msg="<img src=\""+request.getContextPath()+"/images/base/checkinput.gif\" align=absMiddle>";
             else
             msg="";
         }
     if(tmpcount%3==0){
 %>
 <tr class=title >
     <%
     }
 String htmltype = String.valueOf(formfield.getHtmltype());
 String type = formfield.getFieldtype();

 String _fieldid = StringHelper.null2String(formfield.getId());
 String _formid = StringHelper.null2String(formfield.getFormid());
 String _fieldname = StringHelper.null2String(formfield.getFieldname());
 String _htmltype = StringHelper.null2String(formfield.getHtmltype());
 String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
 String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
 String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
 String _style ="";
 String _value="";
    boolean combinefieldflag=false;
 String combineobjname="";
  if(id.equals("40288035249e012493f200077c7d3901")){
   List list=combinefieldService.getCombinefieldByReportid(reportid);
   if(list.size()>0){
    Combinefield combinefield=(Combinefield)list.get(0);
    if(!StringHelper.isEmpty(combinefield.getObjname())){
    combineobjname=combinefield.getObjname();
      combinefieldflag=true;
    }
   }
  }
 String htmlobjname = _fieldid;
 %>
     <td  class="FieldName" width=10% nowrap>
 <%
 String name = formfield.getFieldname();
 name = "d."+name;
 %>
  	 <% if(combinefieldflag){%>
     	<%=StringHelper.null2String(combineobjname)%>
     <% }else{ 
    	 Reportfield reportfield = reportfieldService.getReportfieldByFormFieldId(reportid, formfield.getId());
    	 String label;
    	 if(reportfield != null && reportfield.getId() != null){
    		 label = labelCustomService.getLabelNameByReportfieldForCurrentLanguage(reportfield);
    	 }else{
    		 label = labelCustomService.getLabelNameByFormFieldForCurrentLanguage(formfield);
    	 }
     %>
         <%=label%>
     <%}%>     <%
 if(htmltype.equals("1")){
     if(type.equals("1")){//文本
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle2 size=12 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
     </td>
    <%
    }else if(type.equals("2")){//整数
 %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle2 size=5 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle2 size=5 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
     </td>
     <%
    }
    else if(type.equals("3")){//浮点数



    %>
     <td  class="FieldValue" width=15% nowrap>
       <input type=text class=inputstyle2 size=5 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>--<%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050009")%>--<!-- 到 -->
       <input type=text class=inputstyle2 size=5 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
     </td>
     <%

    }
    else if(type.equals("4")||type.equals("6")){//日期
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
    %>
             <td  class="FieldValue" width=15% nowrap>
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin()!=null && formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value','con<%=id%>_valuespan')"<%}%>>
                    <span id="con<%=id%>_valuespan" <%if(formfield.getFillin()!=null && formfield.getFillin().equals("1")){%>fillin="1"<%}%>  ><%=msg%></span>-
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker(<%=fieldcheck %>)" <%if(formfield.getFillin()!=null && formfield.getFillin().equals("1")){%>onchange="checkInput('con<%=id%>_value1','con<%=id%>_value1span')"<%}%>>
                    <span id="con<%=id%>_value1span" <%if(formfield.getFillin()!=null && formfield.getFillin().equals("1")){%>fillin="1"<%}%> >
                        <%=msg%>
                    </span>
                 </td>

     <%
    }
    else if(type.equals("5")){//时间
    	String fieldcheck = "";
    	fieldcheck = formfield.getFieldcheck();
            StringBuffer sb = new StringBuffer("");
         sb.append("<td width=15% class='FieldValue' nowrap>");
         sb.append("<input type=\"text\" class=inputstyle size=10 name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\" onclick=\"WdatePicker("+fieldcheck+")\" ");

          if(formfield.getFillin()!=null && formfield.getFillin().equals("1")){
         sb.append(" onchange=\"checkInput('con"+_fieldid+"_value','con"+_fieldid+"_valuespan')\"><span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\" fillin=1 >");
         }else{
         sb.append("><span id=\"con"+_fieldid+"_valuespan\" name=\"con"+_fieldid+"_valuespan\"  >");
         }
         sb.append(msg);
         sb.append("</span></td>");
            out.print(sb.toString());
    }
      %>
 <%}
 else if(htmltype.equals("2")){//多行文本
 %>
     <td colspan=3  class="FieldValue" width=15% nowrap>
       <TEXTAREA ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
     <%
 }
 else if(htmltype.equals("3")){//带格式文本


         //StringBuffer sb = new StringBuffer("");
         //sb.append("<td class='FieldValue'><input type=\"hidden\" name=\"field_"+_fieldid+"\"  value=\""+_value.replaceAll("\"","'")+"\" >");
         //sb.append("<IFRAME ID=\"eWebEditor"+_fieldid+"\" src=\"/plugin/ewe/ewebeditor.htm?id=field_"+_fieldid+"&style=eweaver\" frameborder=\"0\" scrolling=\"no\" "+_style+"></IFRAME></td>");
         //out.print(sb.toString());
 }

 else if(htmltype.equals("4")){//check框


 %>

     <td   class="FieldValue" width=15% nowrap>
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldvalue).equals("1")){%> checked <%}%> flag=0 onclick="gray(this)">
     </td>

     <%}

 else if(htmltype.equals("5")){//选择项
             
             List list ;
             if(_fieldcheckMap.get(_fieldid)!=null){
             list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
             
           //系统表Humres,Docbase下拉框联动字段验证保存的是字段名称，需要转换为ID。
             if("402881e80c33c761010c33c8594e0005".equals(formid) || "402881e50bff706e010bff7fd5640006".equals(formid)){
            	 Formfield _field = formfieldService.getFormfieldByName(formid, _fieldcheck);
            	 if(_field!=null){
            	 	_fieldcheck = _field.getId();
            	 }
             }
           
             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
             sb.append("<td width=15% class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\"  >");
             String _isempty = "";
             if(StringHelper.isEmpty(fieldvalue))
                 _isempty = " selected ";
             sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
             for(int i=0;i<list.size();i++){
                 Selectitem _selectitem = (Selectitem)list.get(i);
                 String _selectvalue = StringHelper.null2String(_selectitem.getId());
                 String _selectname = StringHelper.null2String(_selectitem.getObjname());
                 String selected = "";
                 if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
                     selected = " selected ";
                 sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
             }
             sb.append("</select>\n\r</td> ");
             out.print(sb.toString());

 }
 else if(htmltype.equals("6")){ // 关联选择

             Refobj refobj = refobjService.getRefobj(type);
             if(refobj != null){
                 String _refid = StringHelper.null2String(refobj.getId());
                 String _refurl = StringHelper.null2String(refobj.getRefurl());
                 String _viewurl = StringHelper.null2String(refobj.getViewurl());
                 String _reftable = StringHelper.null2String(refobj.getReftable());
                 String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                 String _viewfield = StringHelper.null2String(refobj.getViewfield());
                  int isdirect=NumberHelper.getIntegerValue(refobj.getIsdirectinput(),0).intValue();
                 String _selfield=StringHelper.null2String(refobj.getSelfield());          
                 _selfield=StringHelper.getEncodeStr(_selfield);
                 String showname = "";
                 String shortshowname = "";
                 int valCount = 0;
                 if(!StringHelper.isEmpty(fieldvalue)){
                     String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
                     List valuelist = dataService.getValues(sql);
                     valCount = valuelist.size();
                     Map tmprefmap = null;
                     String tmpobjname = "";
                     String tmpobjid = "";

                     for(int i=0;i<valuelist.size();i++){
                         tmprefmap = (Map)valuelist.get(i);
                         tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                         try{
                             tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                         }catch(Exception e){
                             tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
                         }

                         if(!StringHelper.isEmpty(_viewurl)){//以里面定义为主

                             showname +="&nbsp;&nbsp;<a href=\"javascript:onUrl('" + _viewurl + tmpobjid +"','"+tmpobjname+ "','tab"+tmpobjid+"')\" >";
                             showname += tmpobjname;
                             showname += "</a>";
                             if(valCount>10){
                            	 if(i<10){
                           			  shortshowname +="&nbsp;&nbsp;<a href=\"javascript:onUrl('" + _viewurl + tmpobjid +"','"+tmpobjname+ "','tab"+tmpobjid+"')\" >";
                                      shortshowname += tmpobjname;
                                      shortshowname += "</a>";
                            	 }
                             }
                         }else{
                             if(i==valuelist.size()-1){
                                 showname += tmpobjname;
                                 if(valCount>10){
                                	 if(i<10){
                               			 shortshowname += tmpobjname;
                                	 }
                                 }
                             }else{
                                 showname += tmpobjname + ", ";
                                 if(valCount>10){
                                	 if(i<10){
                               			 shortshowname  += tmpobjname + ", ";
                                	 }
                                 }
                             }
                         }
                     }
                 }


                 String checkboxstr = "";
                 if("orgunit".equals(_reftable)){

                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
					if(StringHelper.null2String(fieldvalue1).equals("1")){
						checked = "checked";
					}
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td width=15% class='FieldValue'>");
                  if(isdirect==1)
                {
                  //加一个用于提示的文本框
                    if (!StringHelper.isEmpty(_selfield)) {
                	    _selfield = _selfield.replaceAll("\r\n"," ");
					}
                    sb.append("<input type=text class=\"InputStyle2\" name="+_fieldid+" id="+_fieldid+" onfocus=\"checkdirect(this)\">");
                    directscript.append(" $(\"#"+_fieldid+"\").autocomplete(\""+request.getContextPath()+"/ServiceAction/com.eweaver.base.refobj.servlet.RefobjAction?action=getdemo&reftable="+_reftable+"&viewfield="+_viewfield+"&selfield="+_selfield+"&keyfield="+_keyfield+"\", {\n" +
                                         "\t\twidth: 260,\n" +
                                                    "        max:15,\n" +
                                                    "        matchCase:true,\n" +
                                                    "        scroll: true,\n" +
                                                    "        scrollHeight: 300,          \n" +
                                                    "        selectFirst: false});");


                                 directscript.append("\n" +
                                     "                             $(\"#"+_fieldid+"\").result(function(event, data, formatted) {\n" +
                                     "                                     if (data)\n" +
                                     "                                         document.getElementById('con"+_fieldid+"_value').value=data[1];\n" +
                                     "                                 });");

                }
                 sb.append("\n\r<button  class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
                   if(isdirect==1)
                 sb.append("\n\r<input type=\"hidden\" id=\"con"+_fieldid+"_value\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 else
                  sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
                 if(!StringHelper.isEmpty(showname)&&valCount>10){
	                 sb.append("<span style='display:none'  id='"+_fieldid+"_allspan'>"+showname+"<a style='color:#72B7F7' title='收缩' onclick=\"closeSpan('"+_fieldid+"')\">  【收缩】</a></span>");
	                 sb.append("<span id='"+_fieldid+"_simplespan'>"+shortshowname+"<a style='color:#72B7F7' title='更多' onclick=\"expandSpan('"+_fieldid+"')\">...更多("+valCount+")</a></span>");
                 }else{
                 	sb.append(showname);
                 }

                 sb.append("</span>\n\r").append(checkboxstr).append("</td> ");
                 out.print(sb.toString());

             }
 }
 else if(htmltype.equals("7")){ //附件
             StringBuffer sb = new StringBuffer("");
             sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
             if(!StringHelper.isEmpty(_value)){
                 Attach attach = attachService.getAttach(_value);
                 String attachname = StringHelper.null2String(attach.getObjname());
                 sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
             }
             sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" >\n\r</td> ");
             out.print(sb.toString());

 }

  if(linecolor==0) linecolor=1;
           else linecolor=0;
     tmpcount += 1;
 }%>
   </table>
         <div id="divObj" style="display:none">
            <table id="displayTable">
                <tr style="background-color:#f7f7f7;height:22">
                    <th align="left" width="160">
                         <b><span style="color:green"><%=labelService.getLabelName("请选择")%>:</span></b>
                         <select name="searchOperate" id="searchOperate" onchange="searchOperate()">
                             <option value="0"><%=labelService.getLabelName("新建模板")%></option>
                             <option value="1"><%=labelService.getLabelName("原有模板")%></option>
                         </select>
                    </th>
                    <th align="left" width="300">
                         <select name="mycontemplate" id="mycontemplate" style="width:150;display:none">
                             <option value="0"><%=labelService.getLabelName("请选择报表模板")%></option>
                             <%
                                 if(contemplateList!=null){
                                 Iterator iteratorObj=contemplateList.iterator();
                                 while(iteratorObj.hasNext()){
                                    Contemplate contemplate= (Contemplate) iteratorObj.next();
                                    if(contemplate.getUserid().trim().equals(eweaveruser.getId().trim())){
                             %>
                                 <option value="<%=contemplate.getId()%>" <%if(contemplate.getId().equals(contemplateid)){%>selected="selected"<%}%>><%=contemplate.getObjname()%>(<%if("False".equals(contemplate.getIspublic())){%><%=labelService.getLabelName("私人")%><%}else{%><%=labelService.getLabelName("公共")%><%}%>)</option>
                             <%
                                    }
                                 }
                                 }
                             %>
                         </select>
                    </th>
                </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr id="objnametr">
                        <td align="right"><%=labelService.getLabelName("模板名称")%></td>
                        <td align="center"><input type="text" size="30" maxlength="60" name="objname" id="objname" style="width:180px"></td>
                    </tr>
                    <tr id="publictr">
                        <td align="right"><%=labelService.getLabelName("模板类型")%></td>
                        <td align="center">
                            <select name="myPublic" id="myPublic" style="width:180px">
                                <option value="False"><%=labelService.getLabelName("私人模板")%></option>
                                 <%
                            		if("402881e70be6d209010be75668750014".equals(eweaveruser.getId())){
                            	 %>
                                <option value="True"><%=labelService.getLabelName("公共模板")%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr id="objdesctr">
                        <td align="right"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd6cd1b580008")%></td><!-- 排序 -->
                        <td align="center"><input type="text" size="30" maxlength="60" name="objdesc" id="objdesc" style="width:180px"></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                                    <button  type="button" accessKey="S" onclick="tosubmit()">
                                        <U>S</U>--<%=labelService.getLabelName("确定")%>
                                    </button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button  type="button" accessKey="C" onclick="Cancel_onclick()">
                                        <U>C</U>--<%=labelService.getLabelName("取消")%>
                                    </button>
                        </td>
                    </tr>
            </table>
        </div>
 </form>
 </div>
<!-- 条件结束-->

   <script type="text/javascript">
function onSearchByTemplate(contemplateid){
        location.href="<%=action2%>&isformbase=<%=isformbase%>&contemplateid="+contemplateid;
   }
       var inputid;
       var spanid;
       var temp;
      function checkdirect(obj)
   {
       inputid=obj.id;
       spanid=obj.name;
       temp=0;
   }
       var $j = jQuery.noConflict();
       $j(document).ready(function($){
               <%=directscript%>
          $.Autocompleter.Selection = function(field, start, end) {
              if( field.createTextRange ){
               var selRange = field.createTextRange();
               selRange.collapse(true);
               selRange.moveStart("character", start);
               selRange.moveEnd("character", end);
               selRange.select();
               if(inputid==undefined||spanid==undefined)
                  return;
                var len=field.value.indexOf("  ");
                  var lenspance=field.value.indexOf(" ");

                    if(temp==0&&len>0){
                    temp=1;
                var  length=field.value.length;

                var data=field.value;

               document.getElementById(inputid).value=field.value.substring(0,field.value.indexOf("  "));
              document.getElementById('con'+spanid+'span').innerHTML= data.substring(len,length);
                    }else if(temp==0&&lenspance>0){

                  var data=field.value;

               document.getElementById(inputid).value=data;
              document.getElementById('con'+spanid+'span').innerHTML= data;

                    }else{
                        document.getElementById(inputid).value="";
                    }
        } else if( field.setSelectionRange ){
               field.setSelectionRange(start, end);
           } else {
                  if( field.selectionStart ){
                   field.selectionStart = start;
                   field.selectionEnd = end;
               }
           }
           field.focus();
       };

        });


   </script>
  <script language="javascript" type="text/javascript">
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }

   function onSearch2(){
       document.all('EweaverForm').action="<%=action2+"&isjson=1"%>";
	   document.all('EweaverForm').submit();
   }

   function onSearch3(){
          document.all('EweaverForm').action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
       document.all('EweaverForm').submit();
   }
   function reset(){
         //$j('#EweaverForm')[0].reset();
         //$j('#EweaverForm span').text('');
         $j('#EweaverForm span').text('');
         $j('#EweaverForm input[type=text]').val('');
         $j('#EweaverForm textarea').val('');
         $j('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $j('#EweaverForm input[type=hidden]').each(function(){
             if(this.name.indexOf('con')==0)
             this.value='';
         });
         $j('#EweaverForm select').val('');
         $j('#EweaverForm span[fillin=1]').each(function(){
             this.innerHTML='<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
         });
         resetSelect();
   }
   
   function resetSelect(){//重置select项，报表清空条件时，前一级select未选择，后一级select的options为空
	   var selectArray = document.EweaverForm.getElementsByTagName('select');
       DWREngine.setAsync(false);
       for(var i=0;i<selectArray.length;i++){
           var selectObj = selectArray[i];
           var reg = /^con.{32}_value$/;
			if(reg.test(selectObj.id)){
				var fieldId = selectObj.id.substring(3,35);
				var sql = "select fieldtype from formfield where id='"+fieldId+"'";
				DataService.getValue(sql,{                                               
						callback: function(data){ 
			              if(data){
				              //该select为根select
			              } else{
			            	  removeAllOptions(selectObj);
			            	  selectObj.options.add(new Option("","" ));
			              }
			        }                 
			     });
			}
       }
       DWREngine.setAsync(true);
   }
   
   //***********************模板切换后的页面动作(start)*************************//
   function onSearch4(reportid){
       var contemplateid=document.getElementById("contemplate").value;
          location.href="<%=action2%>&isformbase=1&contemplateid="+contemplateid;
   }
   //***********************模板切换后的页面动作(end)*************************//

   //点击按列排序
   function listorder(input){
          document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
       document.EweaverForm.submit();
   }
   function fillotherselect(elementobj,fieldid,rowindex){
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";

	var fieldcheck = Trim(getValidStr(document.all(objname).value));//用于保存选择项子项的值(formfieldid)

	if(fieldcheck=="")
		return;

//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");
	var sql ="<%=SQLMap.getSQLString("workflow/report/reportresultlist2.jsp")%>";
	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);

}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;

			if(document.all(objname)== null){
				return;
			}
            removeAllOptions(document.all(objname));
            addOptions(document.all(objname), data);
		    fillotherselect(document.all(objname),select_array[loop],rowindex);
		}
	}
   function removeAllOptions(obj) {
       var len = obj.options.length;
       for (var i = len; i >= 0; i--) {
           obj.options[i] = null
       }
   }

   function addOptions(obj, data) {

       var len = data.length;
       for (var i=0; i<len; i++) {

           if(data[i].id==null){
             data[i].id="";
           }
           obj.options.add(new Option(data[i].objname,data[i].id ));
       }
   }
  function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var id;
    try{
    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }

   function searchOperate(){
       var searchOperate=document.getElementById("searchOperate");
       if(searchOperate.value=="0"){
           document.getElementById("objnametr").style.display="block";
           document.getElementById("publictr").style.display="block";
           document.getElementById("objdesctr").style.display="block";
           document.getElementById("mycontemplate").style.display="none";
       }else{
           document.getElementById("objnametr").style.display="none";
           document.getElementById("publictr").style.display="none";
           document.getElementById("objdesctr").style.display="none";
           document.getElementById("mycontemplate").style.display="block";
       }
   }
     function openchild(url)
  {
    this.dlg0.getComponent('dlgpanel').setSrc("<%=request.getContextPath()%>"+url);
    this.dlg0.show();
  }
   function tosubmit(){
	  if(document.getElementById('searchOperate').value ==1 && document.getElementById("mycontemplate").value == 0){
		   alert("请选择原有的报表模版！");
		   return;
	  }
      document.getElementById("objnamehidden").value=document.getElementById("objname").value; 
      document.all('EweaverForm').action="<%=action2%>&saveSearchToC=true&searchOperate="+document.getElementById("searchOperate").value
              +"&mycontemplate="+document.getElementById("mycontemplate").value
              +"&objname="+encodeURIComponent(document.getElementById("objname").value)
              +"&myPublic="+document.getElementById("myPublic").value
              +"&objdesc="+document.getElementById("objdesc").value;
      document.all('EweaverForm').submit();
   }

   function Cancel_onclick(){
       var mychoose=document.getElementById("divObj");
       var mytable=document.getElementById("displayTable");
       var bgObj=document.getElementById("bgDiv");
       var msgObj=document.getElementById("msgDiv");
       var title=document.getElementById("msgTitle");
       mychoose.appendChild(mytable);
       document.body.removeChild(bgObj);
       document.getElementById("msgDiv").removeChild(title);
       document.body.removeChild(msgObj);
   }
  //*********************************模式对话框特效(start)*********************************//
   function sAlert(){
   var msgw,msgh,bordercolor;
   msgw=460;//提示窗口的宽度
   msgh=280;//提示窗口的高度
   bordercolor="#336699";//提示窗口的边框颜色

   var sWidth,sHeight;
   sWidth=document.body.offsetWidth;
   sHeight=document.body.offsetHeight;

   var bgObj=document.createElement("div");
   bgObj.setAttribute('id','bgDiv');
   bgObj.style.position="absolute";
   bgObj.style.top="0";
   bgObj.style.background="#777";
   bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
   bgObj.style.opacity="0.6";
   bgObj.style.left="0";
   bgObj.style.width=sWidth + "px";
   bgObj.style.height=sHeight + "px";
   document.body.appendChild(bgObj);
   var msgObj=document.createElement("div")
   msgObj.setAttribute("id","msgDiv");
   msgObj.setAttribute("align","center");
   msgObj.style.position="absolute";
   msgObj.style.background="white";
   msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
   msgObj.style.border="1px solid " + bordercolor;
   msgObj.style.width=msgw + "px";
   msgObj.style.height=msgh + "px";
 msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
 msgObj.style.left=(sWidth-msgw)/2 + "px";

 var title=document.createElement("h4");
 title.setAttribute("id","msgTitle");
 title.setAttribute("align","right");
 title.style.margin="0";
 title.style.padding="3px";
 title.style.background=bordercolor;
 title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
 title.style.opacity="0.75";
 title.style.border="1px solid " + bordercolor;
 title.style.height="18px";
 title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
 title.style.color="white";
 title.style.cursor="pointer";
 title.innerHTML="关闭";
 title.onclick=function(){
   var mychoose=document.getElementById("divObj");
   var mytable=document.getElementById("displayTable");
   mychoose.appendChild(mytable);
   document.body.removeChild(bgObj);
   document.getElementById("msgDiv").removeChild(title);
   document.body.removeChild(msgObj);
 }
 document.body.appendChild(msgObj);
 document.getElementById("msgDiv").appendChild(title);
 var mytable=document.getElementById("displayTable");
 document.getElementById("msgDiv").appendChild(mytable);
 }
//*********************************模式对话框特效(end)*********************************//
      function exportExcel(){
          document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?reportid=<%=reportid%>&action=reportExport&contemplateid=<%=contemplateid%>";
          document.forms[0].submit();
      }
           function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}
    function showtemplate(){
      openchild('<%=tmpaction%>','<%=labelService.getLabelName("模板管理")%>');
	//document.EweaverForm.action="<%=tmpaction %>";
      //document.EweaverForm.target="";
   //document.EweaverForm.submit();
}

       function doAction(customid){
        if(selected.length==0){
            Ext.MessageBox.alert('','<%=labelService.getLabelName("请选择勾选CheckBox，如果列表前面没有CheckBox请在报表定义中设置")%>') ;
            return;
        }
        Ext.Ajax.request({
                     url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormbaseAction?action=doaction',
                     params:{requestid:selected.toString(),customid:customid},
                     success: function(res) {
                         if(res.responseText == 'noright')
                         {
                              Ext.Msg.buttonText={ok:'<%=labelService.getLabelName("确定")%>'};
                           Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f0056")%>') ;//编辑权限的人才可以变更卡片数据！
                         }else{
                              Ext.MessageBox.alert('','<%=labelService.getLabelNameByKeyId("402883d934c11ccb0134c11ccbb80000")%>',function(){//变更卡片数据成功！
                                   document.location.reload();
                             });

                         }
                     }
                 });

    }
	
       //展开搜索条件中的span  
function expandSpan(id){
	var $ = jQuery;
	var span1 = $('#'+id+'_simplespan');
	var span2 = $('#'+id+'_allspan');
	span1.hide();
	span2.show();
}

//收缩搜索条件中的span
function closeSpan(id){
	var $ = jQuery;
	var span1 = $('#'+id+'_simplespan');
	var span2 = $('#'+id+'_allspan');
	span2.hide();
	span1.show();
}
   </script>
    <%=StringHelper.null2String(reportdef.getJscontent())%>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
  </body>
</html>