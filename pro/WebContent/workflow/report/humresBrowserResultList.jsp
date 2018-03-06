<%@ page contentType="text/html; charset=UTF-8"%>
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
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService" %>
<%@ page import="com.eweaver.humres.base.service.StationinfoService" %>
<%
String reportid = request.getParameter("reportid");
Page pageObject = (Page) request.getAttribute("pageObject");
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
OrgunitService orgunitService = (OrgunitService) BaseContext.getBean("orgunitService");
StationinfoService  stationinfoService = (StationinfoService) BaseContext.getBean("stationinfoService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getBrowserReportfieldList(reportid);
}
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

%>
<html>
  <head>
  <script language="javascript">
function changestype(val,cond){
if(eval(cond)){
document.all(val).style.background="red";
}
}                                                                                                   
</script>
  <Style>
 	UL    { margin-left:22pt; margin-top:0em; margin-bottom: 0 }
   	UL LI {list-style-image: url('<%=request.getContextPath()%>/images/book.gif'); margin-bottom: 4}
</Style>

  </head> 
  <body>
   
     
<!--页面菜单开始-->     
<%
String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browser=1&from=list&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browser=1&reportid=" + reportid;
paravaluehm.put("{reportid}",reportid);
//pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2()}";

//PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
//pagemenustr += _pagemenuService2.getPagemenuStr(reportid,paravaluehm);

if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&from=list&browser=1&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browser=1&reportid=" + reportid;
}

pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>

<!--页面菜单结束-->
 	<form action="<%=action%>" name="EweaverForm" method="post">
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




DataService	dataService = new DataService();
String[] checkcons = request.getParameterValues("check_con");

//得到初使查询条件：

Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
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
 %>

  <table width=100% class=viewform>
    <%
int linecolor=0;

int tmpcount = 0;


 if(linecolor==0) linecolor=1;
          else linecolor=0;
    tmpcount += 1;

%>
  </table>
<!--  ***************************************************************************************************************************-->  

  <TABLE ID=BrowserTable class=BrowserStyle>
<!--表头开始-->		  
          <tr class=Title> 
          <%
		
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        
        Map reporttitleMap = new HashMap();
        Map widthMap=new HashMap();
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
			%>
					<TH style="display:none"></TH> <!--表头 字段-->
			        <th nowrap  <%=widths%> ><a href="javascript:listorder('<%=formfields.getFieldname() %>');"><B><%=reportfield.getShowname()%></B></a></td>
			<%	
            widthMap.put(""+k,widths);
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %> 
          </tr>
     <tr>
         <td colspan="<%=k%>">
              <div style="overflow-y:scroll;width:100%;height:195px">
             <table>
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
          <td style="display:none"><%=reportMap.get("id")%></td>
       <%   
       int j=0;
		Iterator it2 = reportfieldList.iterator();
		while(it2.hasNext()){
			
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
			String href = reportfield.getHreflink();
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
					isalign = true;
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
								sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(fieldvalue)+ ")";
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
										sql = "select a." + _keyfield + " as objid,b."+ _refviewfield +" as objname " 
											 + "from " + _reftable + " a,"+ _refreftable +" b where a." + _keyfield + " ='" + fieldvalue + "'"
											 + " and a." + reffieldname + " like '%' + b.id + '%'";
											
								}else{
									sql = "select " + _keyfield + " as objid," + reffieldname + " as objname from " + _reftable + " where " + _keyfield + " ='" + fieldvalue + "'";
									_viewurl = "";
								}
							}
//							*******************************************************************************************************	

//							System.out.println("--------sql:" + sql);
							String _objid = "";
							String _objname = "";
                            if (_refid.equals("402881e60bfee880010bff17101a000c")) { //组织单选
                                            showname += "&nbsp;&nbsp;<a href=\"" + _viewurl + orgunitService.getOrgunit(fieldvalue).getId() + "\" target=\"_blank\" >";
                                            showname += orgunitService.getOrgunit(fieldvalue).getObjname();
                                            showname += "</a>";
                                        }else if(_refid.equals("402881e510efab3d0110efba0e820008")){//岗位单选
                                            showname += "&nbsp;&nbsp;<a href=\"" + _viewurl + stationinfoService.getStationinfoByObjid(fieldvalue).getId() + "\" target=\"_blank\" >";
                                            showname += stationinfoService.getStationinfoByObjid(fieldvalue).getObjname();
                                            showname += "</a>";
                                        }
                            else {
                                List reflist = dataService.getValues(sql);
                                Map tmprefmap = null;
                                String tmpobjname = "";

                                for(int n=0; n< reflist.size(); n++){
                                    tmprefmap = (Map)reflist.get(n);

                                    try{
                                        tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                                    }catch(Exception e){
                                        tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
                                    }

                                    if(n==reflist.size()-1){
                                        showname += tmpobjname;
                                    }else{
                                        showname += tmpobjname + ", ";
                                    }
                                }
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
				

		%>	
            <td id="<%=i%>_<%=j%>" <%if(isalign){%>  align="right" <%} %> wrap <%=(String)widthMap.get(""+j)%>>
            	<%
            		if(htmltype.equals("7")){
            	%>
            	<%=StringHelper.null2String(fieldvalue7.toString())%>
            	<%
            		}else{
            	%>
            	<%=StringHelper.null2String(fieldvalue)%>
            	<%}%>
            </td>
         <%				
				
         }
         j++;
         
         }
         reportdatalist.add(reportdataMap);
         %>   
          </tr>			

		<%
					}  }
		  %>

	   </table>
       </div>
              </td>
         </tr>
</table>
       <br>
		
  
   <div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
    </form>
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
   	document.EweaverForm.action="<%=action2%>";
	document.EweaverForm.submit();
}

function onSearch3(){
   	document.EweaverForm.action="<%=request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
	document.EweaverForm.submit();
}

//点击按列排序
function listorder(input){
   	document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
	document.EweaverForm.submit();
}
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    param = parserRefParam(inputname,param);
	idsin = document.all(inputname).value;
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id="+refid+"&"+param+"&idsin="+idsin);
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
</script>

  <script>
    function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    try{
    id=openDialog('<%= request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=<%= request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
        if (viewurl == "/base/orgunit/orgunitbrowser.jsp") {
        onSubmit();
        }
 }
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
    }
</script>
  </body>
</html>

