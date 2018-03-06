<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="java.util.List"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.base.log.model.Log"%>
<%@ page import="com.eweaver.base.log.service.LogService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.menu.service.MenuService"%>
<%@ page import="org.hibernate.criterion.DetachedCriteria"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserService"%>
<%@ page import="com.eweaver.base.security.model.Sysuser"%>
<%@ page import="com.eweaver.base.security.service.logic.SysuserrolelinkService"%>
<%@ page import="com.eweaver.base.security.model.Sysuserrolelink"%>
<%@ page import="com.eweaver.base.log.model.ChangeLog" %>
<%@ page import="com.eweaver.base.log.model.ChangeLogDetail" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formfield" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.document.base.model.Attach" %>
<%@ page import="com.eweaver.document.base.service.AttachService" %>


<%
ChangeLog log = new ChangeLog();
Map queryFilter = (Map)request.getAttribute("queryFilter");
Page pageObject = (Page) request.getAttribute("pageObject");
if (pageObject == null) {
	response.sendRedirect(request.getContextPath()+"/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=searchChange");
}

HumresService humresService = (HumresService) BaseContext.getBean("humresService");
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
SelectitemService selectitemService= (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService= (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService= (AttachService) BaseContext.getBean("attachService");
DataService	dataService = new DataService();
String objid=StringHelper.null2String(queryFilter.get("objid"));

String submitor=StringHelper.null2String(queryFilter.get("submitor"));
String submitorname=submitor==""?"":humresService.getHumresById(submitor).getObjname();
String submitdate=StringHelper.null2String(queryFilter.get("submitdate"));
String submitdate2=StringHelper.null2String(queryFilter.get("submitdate2"));


   TreeSet changeFieldList=new TreeSet();
   if(pageObject.getTotalSize()!=0){
			List list = (List) pageObject.getResult();
            for(Object o:list){
                Set<ChangeLogDetail> set=((ChangeLog) o).getLogDetails();
                for(ChangeLogDetail clogdetail:set){
                    String fieldid=clogdetail.getFieldid();
                    if(!changeFieldList.contains(fieldid))
                        changeFieldList.add(fieldid);
                }
            }
   }
%>

<html>
  <head>
  	
  </head>
  <body>
 	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.log.servlet.LogAction?action=searchChange" name="EweaverForm" method="post">
 		<input type=hidden name="objid" value="<%=objid%>">

		<table>
				<tr class="Header">
                     <%for(Object fieldid:changeFieldList){
                    Formfield field=formfieldService.getFormfieldById((String)fieldid) ;
                %>
                <td nowrap>
					<%=field.getLabelname()%>
				</td>
                <%}%>
					<td nowrap>
						&nbsp<%=labelService.getLabelName("402881e70b65e2b3010b65e58e950005")%>&nbsp
					</td>
					<td nowrap>
						&nbsp<%=labelService.getLabelName("402881e70b65e2b3010b65e5e5fc0006")%>&nbsp
					</td>
					<td nowrap>
						&nbsp<%=labelService.getLabelName("402881e70b65e2b3010b65e779000008")%>&nbsp
					</td>

				</tr>
<%

			boolean isLight=false;
			String trclassname="";
            int count=0;
            if(pageObject.getTotalSize()!=0){
			List list = (List) pageObject.getResult();

					String _logtype="";
					String _logtypename="";
					String _submitor="";
					String _submitorname="";

				for (int i = 0; i < list.size(); i++) {
					log = (ChangeLog) list.get(i);
					isLight=!isLight;
					if(isLight) trclassname="DataLight";
					else trclassname="DataDark";
                    ChangeLog oldlog =null;
                    if(count<list.size()-1)
                           oldlog= (ChangeLog) list.get((count++)+1);
                    Set<ChangeLogDetail> oldset=null;
                    if(oldlog!=null)
                        oldset=oldlog.getLogDetails();

					_submitor=StringHelper.null2String(log.getSubmitor());
					if(!_submitor.equals(""))
						_submitorname=humresService.getHumresById(_submitor).getObjname();
%>
				<tr id="<%=log.getId()%>" class="DataDark">

                    <%for(Object fieldid:changeFieldList){
                    Formfield field=formfieldService.getFormfieldById((String)fieldid) ;
                    String htmltype = String.valueOf(field.getHtmltype());
                    String type = field.getFieldtype();
                    Set<ChangeLogDetail> set=log.getLogDetails();
                    String value="";
                    boolean changed=false;
                    for(ChangeLogDetail cld:set){
                        if(cld.getFieldid().equals(fieldid)){
                            value=cld.getNewvalue();
                            if(oldset!=null){
                            for(ChangeLogDetail oldcld:oldset){
                               if(oldcld.getFieldid().equals(fieldid)){
                                   String oldvalue=oldcld.getNewvalue();
                                   if((oldvalue==null && value!=null)||(oldvalue!=null && !oldvalue.equals(value)))
                                   changed=true;
                               }
                            }
                            }
                            if(htmltype.equals("1")||htmltype.equals("2")||htmltype.equals("3")){  //show text
                                if(changed)
                                value="<font color=red>"+cld.getNewvalue()+"</font>";
                                else
                                value=StringHelper.null2String(cld.getNewvalue());
                            }else if(htmltype.equals("4")){//checkbox
                                if(value!=null && value.equals("1"))
                                 value="<img  width=14px height=14px src="+request.getContextPath()+"/images/bacocheck.gif>";
                                 else
                                 value="<img  width=14px height=14px src="+request.getContextPath()+"/images/bacocross.gif>";
                            }else if(htmltype.equals("5")){//选择项
                                 Selectitem si= selectitemService.getSelectitemById(value);
                                 if(si!=null){
                                  if(changed)
                                       value="<font color=red>"+si.getObjname()+"</font>";
                                     else
                                       value=si.getObjname();
                                 }
                            }else if(htmltype.equals("6")) {//关联选择
                                Refobj refobj = refobjService.getRefobj(type);
                                if (refobj != null) {
                                    String _refid = StringHelper.null2String(refobj.getId());
                                    String _refurl = StringHelper.null2String(refobj.getRefurl());
                                    String _viewurl = StringHelper.null2String(refobj.getViewurl());
                                    String _reftable = StringHelper.null2String(refobj.getReftable());
                                    String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                                    String _viewfield = StringHelper.null2String(refobj.getViewfield());

                                    String showname = "";
                                    if (!StringHelper.isEmpty(value)) {
                                        String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(value)) + ")";
                                        List valuelist = dataService.getValues(sql);

                                        Map tmprefmap = null;
                                        String tmpobjname = "";
                                        String tmpobjid = "";

                                        for (Object o : valuelist) {
                                            tmprefmap = (Map) o;
                                            tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                                            try {
                                                tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                                            } catch (Exception e) {
                                                tmpobjname = ((java.math.BigDecimal) tmprefmap.get("objname")).toString();
                                            }

                                            if (!StringHelper.isEmpty(_viewurl)) {//以里面定义为主
                                                if(changed)
                                                  tmpobjname="<font color=red>"+tmpobjname+"</font>";
                                                showname += "&nbsp;&nbsp;<a href=\"" + _viewurl + tmpobjid + "\" target=\"_blank\" >";
                                                showname += tmpobjname;
                                                showname += "</a>";

                                            } else {
                                                if (i == valuelist.size() - 1) {
                                                    showname += tmpobjname;
                                                } else {
                                                    showname += tmpobjname + ", ";
                                                }
                                                if(changed)
                                                  tmpobjname="<font color=red>"+tmpobjname+"</font>";
                                            }
                                        }
                                    }
                                    value = showname;
                                }
                            }else if(htmltype.equals("7")) {//附件
                                if (!StringHelper.isEmpty(value)) {
                                    Attach attach = attachService.getAttach(value);
                                    String attachname = StringHelper.null2String(attach.getObjname());
                                    if(changed)
                                         attachname="<font color=red>"+attachname+"</font>";
                                    value = "<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid=" + value + "\">" + attachname + "</a>";
                                }
                            }
                            break;
                        }
                    }
                %>
                <td nowrap>
					<%=value%>
				</td>
                <%}%>
					<td>
						<%=_submitorname%>
					</td>
					<td>
						<%=log.getSubmitdate()%>&nbsp<%=log.getSubmittime()%>
					</td>

					<td>
						<%=log.getSubmitip()%>
					</td>


				</tr>
				<tr class="DataLight"  style="display:none" id="<%=log.getId()%>1">
					<td>
					</td>
					<td colspan=4>
						<%=log.getLogdesc()%>
					</td>
				</tr>

<%
				} 		//end for
			}			//end if
%>
		</table>
		<br>
		<table border="0" id="logTable">
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
						<input type="text" name="pageno" size="2" value="<%=pageObject.getCurrentPageNo()%>" onChange="javascript:onSearch(0);">
						&nbsp;
						<%=labelService.getLabelName("402881e60aabb6f6010aabbcb3110008")%>
						<input type="text" name="pagesize" size="2" value="<%=pageObject.getPageSize()%>" onChange="javascript:onSearch(0);">
					</td>
					<td>&nbsp;</td>
				</tr>
		</table>
		<input type=hidden id="totalsize" value="<%=pageObject.getTotalSize()%>">
    </form>
 <script language="javascript" type="text/javascript">
    function onSearch(pageno){
	    if(pageno != 0) document.EweaverForm.pageno.value=pageno;
		document.EweaverForm.submit();
    }
</script>

  </body>
</html>
