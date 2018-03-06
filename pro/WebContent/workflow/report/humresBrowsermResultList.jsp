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
<%@ page import="com.eweaver.humres.base.service.*"%>
<%@ page import="com.eweaver.humres.base.model.*"%>
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

List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getBrowserReportfieldList(reportid);
}
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String userid = currentuser.getId();
int maxselected = 100;

String idslimited = StringHelper.null2String(request.getParameter("idslimited"));	//限定选择范围(?,?,?)　调用browser时传入


String idsin = StringHelper.null2String(request.getParameter("idsin"));	//已选中id(?,?,?)　调用browser时传入


String idsselected = StringHelper.null2String(request.getAttribute("idsselected"));	//已选中id(?,?,?)　搜索后传回


if(!idsin.equals("")){
	idsselected = idsin;
}

if(idsselected.equals("0"))
	idsselected = "";

String namesselected = "";	//已选中名称(?,?,?)
DataService	dataService = new DataService();
String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
if(descorasc.equals("desc")){
	descorasc = "asc";
}else{
	descorasc = "desc";
}
%>
<html>
  <head>
    <script src='<%=request.getContextPath()%>/dwr/interface/HumrescustomizeService.js'></script>
  	<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
  </head>
  
  <body onunload="cache()">
          
<!--页面菜单开始-->     
<%
String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browserm=1&from=list&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&browserm=1&reportid=" + reportid;
paravaluehm.put("{reportid}",reportid);
pagemenustr += "{O,"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+",javascript:btnok_onclick()}";
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&browserm=1&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&browserm=1&reportid=" + reportid;
}

pagemenustr += "{R,"+labelService.getLabelName("402881e60aabb6f6010aabe32990000f")+",javascript:window.close()}";
pagemenustr += "{D,"+labelService.getLabelName("402881e50ada3c4b010adab3b0940005")+",javascript:btnclear_onclick()}";
%>


  
<!--  ***************************************************************************************************************************-->  
<TABLE>
<tr>
<td width="60%" valign=top>
	<div style="overflow:scroll;width:100%;height:220px">
	
 	<table ID=BrowserTable class=BroswerStyle cellspacing=1 border="0">

<!--表头开始-->		  
          <tr class=Header> 
          <%
		
        Iterator it = reportfieldList.iterator();
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
			%>
			         	<th nowrap  <%=widths%> ><a href="javascript:listorder('<%=formfields.getFieldname() %>');"><B><%=reportfield.getShowname()%></B></a></td>
			<%
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %> 
          </tr>
<!--表头结束-->
				<%		
				
				Map initreportmap = new HashMap();
				if(pageObject.getTotalSize()!=0){
					List list = (List) pageObject.getResult();	
					
					Map reportdataMap = null;
					Map reportMap = null;
					rows = list.size();	
					for (int i = 0; i < list.size(); i++) {
						reportdataMap = new HashMap();
						reportMap = (Map)list.get(i);
						
						//搜索出来的记录的ID
						String rid = StringHelper.null2String(reportMap.get("id"));

				%>		

          <tr  class=datadark  > 
          <td style="display:none"><%=rid%></td>
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
				String fieldvalue = StringHelper.null2String(reportMap.get(formfieldname));//对象对应的ID
				
				if(idsin.contains(rid)&&j==0){
					initreportmap.put(rid,fieldvalue);
				}
				
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
            <td id="<%=i%>_<%=j%>" <%if(isalign){%>  align="right" <%} %>>
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

<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%" class=noborder>
		<tr>
			<td align="center" valign="top" width="10%">
                <br>
                <img src="<%=request.getContextPath()%>/images/arrow_u.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd696920f0004")%>" onclick="javascript:upFromList();">
				<br>
					<img src="<%=request.getContextPath()%>/images/arrow_all.gif" style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69932470005")%>" onClick="javascript:addAllToList()">
				<br>
				<img src="<%=request.getContextPath()%>/images/arrow_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881e60aa85b6e010aa8624c070003")%>" onclick="javascript:deleteFromList();">
				<br>
				<img src="<%=request.getContextPath()%>/images/arrow_all_out.gif"  style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69a97a00006")%>"onclick="javascript:deleteAllFromList();">
				<br>
				<img src="<%=request.getContextPath()%>/images/arrow_d.gif"   style="cursor:hand" title="<%=labelService.getLabelName("402881eb0bd66c95010bd69b730b0007")%>" onclick="javascript:downFromList();">
				<br>
				

			</td>
			<td align="center" valign="top" width="30%">
                <br>
                <div style="width:50;">
				<select size="13" name="srcList" multiple="true" style="width:200" class="inputstyle2" ondblclick="deleteFromList()">
				<!--载入已选中值 -->
					<%
					
					//上一次带进来的选中项

					String idsin2 = (String)request.getAttribute("idsin");
					String idsnamein2 = (String)request.getAttribute("idsnamein");
					if(!StringHelper.isEmpty(idsin2)){
						idsin = idsin2;
					}
					String[] initids = idsin.split(",");
					String[] idsnamein = idsnamein2.split(",");
					String tmpid= "";
					String tmpname = "";
					for(int i=0; i< initids.length; i++){
						tmpid = initids[i].trim();

						if(!tmpid.equals("")){
							tmpname = StringHelper.null2String(initreportmap.get(tmpid));
							if(idsnamein.length > i && !idsnamein[i].trim().equals("")){
								tmpname = idsnamein[i].trim();
							}
							%>
							<option value="<%=tmpid %>" ><%=tmpname %></option>
							<%
						}
					}
					%>
					  <!-- option value="1"></option-->

				</select>
				</div>
				<input class=inputstyle2 type="hidden" id="idsin" name="idsin">
				<input class=inputstyle2 type="hidden" id="idsnamein" name="idsnamein">

			</td>
		</tr>

      </table>

</td>
</tr>
</TABLE>
<br>
   <div id="pagemenubar" style="z-index:100;"></div>
<%@ include file="/base/pagemenu.jsp"%>
			
    </form>
<script language=vbs>

Sub BrowserTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub

Sub BrowserTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

Sub btnclear_onclick()
     getArray "0",""
End Sub

Sub btnok_onclick()
	 
	 reloadResourceArray()
	 setResourceStr()
	tmp = idsselected
	curnum = 0
	while InStr(tmp,",") <> 0
		curid = Mid(tmp,1,InStr(tmp,",")-1)
		tmp = Mid(tmp,InStr(tmp,",")+1,Len(tmp))
		curnum = curnum+1
	wend
	if curnum><%=maxselected%> then 
		msgbox "人数超过限制<%=maxselected%>" 
	else
		getArray idsselected,namesselected
	end if
End Sub

</script>
<script>
    function getArray(id,value){
        window.parent.returnValue = [id,value];
        window.parent.close();
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
<script language="javascript">
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
  var resourceArray = new Array();
  function reload(){
    obj=document.all("srcList");   
    ids=parent.document.all("ids").value.split(",");
    names=parent.document.all("names").value.split(",");
    for(i=0;i<ids.length;i++){
        if(ids[i]=='')
        continue;
        oOption = document.createElement("OPTION");
	    obj.options.add(oOption);
        oOption.value = ids[i];
        oOption.innerText =names[i];
    }
    reloadResourceArray();   
  }
  reload();
  //alert(parent.document.all("humreslist"));
 function cache(){
	 var destList = document.all("srcList");
	var len = destList.options.length;
	var idsin = "";
	var idsnamein ="";
	for(var i = (len-1); i >= 0; i--) {
		if (destList.options[i] != null) {
			idsin += destList.options[i].value+",";
			idsnamein += destList.options[i].text + ",";
		 }
	} 

	parent.document.all("ids").value= idsin;
	parent.document.all("names").value= idsnamein;

 }    
 
 function onSearch2(){
   	document.EweaverForm.action="<%=action2%>";
	document.EweaverForm.submit();
}

  function onSubmit(){
  	document.EweaverForm.action="<%=action2%>";
    document.EweaverForm.submit();
  }    
  
  function addAllToList(){
	var table =document.all("BrowserTable");
	//alert(table.rows.length);
	for(var i=1;i<table.rows.length;i++){
		var str = table.rows(i).cells(0).innerText+"~"+table.rows(i).cells(1).innerText ;
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect(document.all("srcList"),str);
	}
	reloadResourceArray();
}
function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(Trim(entry) == Trim(arrayObj[i].toString())){
			return true;
		}
	}
	return false;
} 

function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
    obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	oOption.innerText = str.split("~")[1];
}


function deleteAllFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}

//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
    j = -1;
    for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
    j = i;
          }
	}
    if (j == -1)
		return;

	// move focus to the next item
	if (destList.length <= 0)
		return;

	if ((j < 0) || (j > destList.length))
		return;

	if (j == 0)
		destList.options[j].selected = true;
	else if (j == destList.length)
		destList.options[j-1].selected = true
	else
		destList.options[j].selected = true;
    reloadResourceArray();
}
function deleteAllist(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}


function upFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}

function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}

function setResourceStr(){
	idsselected ="";
	namesselected = "";
	for(var i=0;i<resourceArray.length;i++){
		idsselected += ","+resourceArray[i].split("~")[0] ;
		namesselected += ","+resourceArray[i].split("~")[1] ;
	}
	idsselected = idsselected.substring(1,idsselected.length);
	namesselected = namesselected.substring(1,namesselected.length);
}


function addGroup(){
	var resourcegroup = "";
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourcegroup += "," + destList.options[i].value+"~"+destList.options[i].text ;
	}
	if(resourcegroup == "") return;
	resourcegroup = resourcegroup.substring(1);
	var vDetail = prompt("<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e1446000b")%>","");//请输入自定义组名称
	if(vDetail!=null){
		document.EweaverForm.customizegroupname.value = vDetail;
		document.EweaverForm.resourcegroup.value = resourcegroup;
		document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=savegroup"
		document.EweaverForm.submit();
	}
}
function deleteGroup(){
 if (document.all("groupid").value != "" && document.all("groupid").value != null){
 document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.humres.base.servlet.HumresAction?action=browser&from=deletegroup"
 document.EweaverForm.submit(); 
 }
}

function doSearch()
{ 
         
  HumrescustomizeService.getHumrescustomizeById(getHumrescustomize,document.all("groupid").value);
}

function getHumrescustomize(Humrescustomize){
  if (Humrescustomize==null) return;
  var humresList = Humrescustomize.includevalues;
  var humresArray = new Array();
  humresArray = humresList.split(",");
  deleteAllist(); 
  for (i=0;i<humresArray.length;i++){
  addObjectToSelect(document.all("srcList"),humresArray[i]);  
  }
  
}


//点击按列排序
function listorder(input){
   	document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
	document.EweaverForm.submit();
}
</script> 
<script language="javascript" for="BrowserTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.all("srcList"),newEntry);
			reloadResourceArray();
		}
	}
</script>

  </body>
</html>







