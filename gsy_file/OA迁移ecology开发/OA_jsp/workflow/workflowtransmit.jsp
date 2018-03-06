<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ include file="/app/base/init.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.eweaver.utility.*" %>
<%@ page import="com.eweaver.base.*" %>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.request.service.WorkflowService"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%
//EweaverUser eweaveruser = BaseContext.getRemoteUser();
//Humres currentuser = eweaveruser.getHumres();
String userid=currentuser.getId();//当前用户
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
String submitaction = StringHelper.null2String(request.getParameter("submitaction"));
String throwstr = StringHelper.null2String(request.getParameter("throwstr"));
String ouserid = StringHelper.null2String(request.getParameter("ouserid"));//402881e70be6d209010be75668750014
String nuserid = StringHelper.null2String(request.getParameter("nuserid"));//4028803b21587ae9012158a2a128007c
String workflowids = StringHelper.null2String(request.getParameter("workflowids"));
WorkflowService workflowService = (WorkflowService) BaseContext.getBean("workflowService");
if(submitaction!=null&&submitaction.equals("submit"))
{
	List<String> sqlList =new ArrayList<String>();
	ouserid=StringHelper.null2String(request.getParameter("ouserid"));
	nuserid=StringHelper.null2String(request.getParameter("nuserid"));
	workflowids=StringHelper.null2String(request.getParameter("workflowids"));
	List requestlist= baseJdbc.executeSqlForList("select rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.flowno,rb.updatetime,rt.nodeid from Requestbase rb, Requestoperators wo,Requeststatus wi,Requeststep rt where rb.id = wo.requestid and wi.curstepid=wo.stepid and wo.stepid = rt.id and rb.workflowid in(select id from workflowinfo) and rb.isdelete<>1 and wo.userid='"+ouserid+"' and (wi.ispaused=0 and wo.operatetype!=1 and rb.isfinished=0 or wo.operatetype=1 and wo.issubmit!=1)   and rb.isdelete = 0    group by rb.id,rb.workflowid,rb.requestname,rb.requestlevel,rb.createtype,rb.creater,rb.createdate,rb.createtime,rb.isfinished,rb.isdelete,rb.objno,rb.flowno,rb.updatetime,rt.nodeid order by rb.updatetime desc");
	int nums=0;
	//取出用户所有待办
	for(int i=0,sizei=requestlist.size();i<sizei;i++){
		Map rstmap = (Map)requestlist.get(i); 
		String workflowid = StringHelper.null2String(rstmap.get("workflowid"));
		String requestid = StringHelper.null2String(rstmap.get("id"));
		//执行移交处理
		if(workflowids.indexOf(workflowid)>-1){
			workflowService.replaceOperator(requestid,ouserid,nuserid);
			nums=nums+1;
		}
		throwstr="工作移交成功! 共&nbsp;"+requestlist.size()+"&nbsp;个待办事项，本次移交"+nums+"项!";
	}
	
}
submitaction="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script type="text/javascript" src="/js/workflow.js"></script>
<script type="text/javascript" src="/js/formbase.js"></script>

<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css"/>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
    .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
         .x-panel-body {
        border-bottom:#99bbe8 0px solid;
         position:  relative;
         border-left:#99bbe8 0px solid;
        border-right:#99bbe8 0px solid
     }
    .x-panel-body-noheader{
        border-top:#99bbe8 0px solid
    }
	input{ border-left:0px;border-top:0px;border-right:0px;border-bottom:1px solid #0D0000 } span{ vertical-align:top; }
</style>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="" name="EweaverForm" id="EweaverForm" method="post">
<input type="hidden" name="submitaction"  id="submitaction" value="search"/>
<center>
<br><br><br>
		<fieldset style="width:600">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR height="60"><TD class=Spacing colspan=3 align="center">			
			<span style="color:#8a8a8a;font-size:15pt;padding:10px">
			<b>待办工作流程交接处理</b>
			</span>
			<br>
			</TD>
			</TR><TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
			<TR >
			<TD class=FieldName noWrap>工作移交人</TD>
			<TD class=FieldValue colspan=2><button type=button  class=Browser name="button_nuserid" onclick="javascript:getrefobj('ouserid','ouseridspan','402881e70bc70ed1010bc75e0361000f','','/workflow/request/formbase.jsp?requestid=','0');"></button><input type="hidden" name="ouserid" id="ouserid" value="<%=ouserid%>"  style='width: 80%'  ><span id="ouseridspan" name="ouseridspan" ><%=getBrowserDicValue("humres","id","objname",ouserid)%><%if(ouserid.length()<1){%><img src="/images/base/checkinput.gif" align=absMiddle><%}%></span>
			</TR>	
			<TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
			<TR >
			<TD class=FieldName noWrap>工作接管人</TD>
			<TD class=FieldValue colspan=2 ><button type=button  class=Browser name="button_nuserid" onclick="javascript:getrefobj('nuserid','nuseridspan','402881e70bc70ed1010bc75e0361000f','','/workflow/request/formbase.jsp?requestid=','0');"></button><input type="hidden" name="nuserid"   id="nuserid" value="<%=nuserid%>"  style='width: 80%'  ><span id="nuseridspan" name="nuseridspan" ><%=getBrowserDicValues("humres","id","objname",nuserid)%><%if(nuserid.length()<1){%><img src="/images/base/checkinput.gif" align=absMiddle><%}%></span>
			</TR>
            <TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
            <TR height="30"><TD class=Spacing colspan=3 align="center">
			<span style="color:red;font-size:11pt;padding:10px">
			<b>请选待办工作流程</b>
			</span>
			
			</TD><TR>
			<TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
			<TR >
			<TD class=FieldName noWrap>工作流程</TD>
			<TD class=FieldValue colspan=2 style="height:100px" >
			<button type=button  class=Browser name="button_workflowids" onclick="javascript:getrefobj('workflowids','workflowidsspan','40288032239dd0ca0123a2273d270006','','/workflow/request/formbase.jsp?requestid=','0');"></button><input type="hidden" id="workflowids" name="workflowids" value="<%=workflowids%>"  style='width: 80%'  ><span id="workflowidsspan" name="workflowidsspan" ><%=getBrowserDicValue("workflowinfo","id","objname",workflowids)%><%if(workflowids.length()<1){%><img src="/images/base/checkinput.gif" align=absMiddle><%}%></span>
			</tr>
		</TR>
		<TR><TD class=Line colspan=3 style="	height: 1px;	background-color: #C2D5FC;"></TD><TR>
		<tr><td colspan=3 align="center"  ><br><button onclick="onSubmit()" class="btn" >提交处理</button>&nbsp;&nbsp;&nbsp;<button onclick="document.forms[0].reset();" class="btn">取消处理</button></td></tr>
            <tr><td colspan=3 align="center">
                <br/>
				<div id="finishmessage"  style='color:red;font-weight:bold;' <%if(throwstr.length()<1)out.println("style=\"display:none;\"");%>>
                <span href="javascript:void(0)"><%=throwstr%></span>
				<%
				if(request.getAttribute("errorMsg")!=null){
					out.println("<span style='color:red;font-weight:bold;'>ERROR:</span><br/>");
					out.println(request.getAttribute("errorMsg"));
				}
				%>
				</div>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
 
                </div>
                </div>
              
                <br/>
				
        </td></tr>
	    </table>
		</fieldset>
        </form>
      </div>
    <div id="messagePage">
        <table style="border:0">
            <TR><TD><span id="message" name="message" style="font-size:12"></span></TD></TR>
            </table>
      </div>
  </body>
<script language="javascript">
function reset(){
   document.all('EweaverForm').reset();
}
function checkIsNull()
{
	return true;
}
var checkfields='';
var checkmessage='';
var needchecklists='';
needchecklists=',nuserid,workflowids';
function onSubmit(){
	checkfields="ouserid,"+needchecklists;//填写必须输入的input name，逗号分隔
	 checkmessage="必填项不能为空";//必输项不能为空
	 if(confirm('是否确定操作？')){
		  if(checkForm(EweaverForm,checkfields,checkmessage)){
				document.getElementById('submitaction').value="submit";
				document.EweaverForm.submit();
		  }
	 }
			
}
    var win;
    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";
    var fck=param.indexOf("function:");
        if(fck>-1){}else{
            var param = parserRefParam(inputname,param);
        }
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
             id=window.showModalDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param,idsin,'dialogWidth=800px');
    	//id=openDialog(url);
    }catch(e){return}
    if (id!=null) {
    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
          if(fck>-1){
          funcname=param.substring(9);
      scripts="valid="+funcname+"('"+id[0]+"');";
        eval(scripts) ;
        if(!valid){  //valid默认的返回true;
         document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
          }
          }
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }else{
    url='/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;

    var callback = function() {
            try {
                id = dialog.getFrameWindow().dialogValue;
            } catch(e) {
            }
            if (id != null) {
                if (id[0] != '0') {
                    document.all(inputname).value = id[0];
                    document.all(inputspan).innerHTML = id[1];
                    if (fck > -1) {
                        funcname = param.substring(9);
                        scripts = "valid=" + funcname + "('" + id[0] + "');";
                        eval(scripts);
                        if (!valid) {  //valid默认的返回true;
                            document.all(inputname).value = '';
                            if (isneed == '0')
                                document.all(inputspan).innerHTML = '';
                            else
                                document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
                        }
                    }
                } else {
                    document.all(inputname).value = '';
                    if (isneed == '0')
                        document.all(inputspan).innerHTML = '';
                    else
                        document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

                }
            }
        }
        if (!win) {
             win = new Ext.Window({
                layout:'border',
                width:Ext.getBody().getWidth()*0.8,
                height:Ext.getBody().getHeight()*0.8,
                plain: true,
                modal:true,
                items: {
                    id:'dialog',
                    region:'center',
                    iconCls:'portalIcon',
                    xtype     :'iframepanel',
                    frameConfig: {
                        autoCreate:{ id:'portal', name:'portal', frameborder:0 },
                        eventsFollowFrameLinks : false
                    },
                    closable:false,
                    autoScroll:true
                }
            });
        }
        win.close=function(){
                    this.hide();
                    win.getComponent('dialog').setSrc('about:blank');
                    callback();
                } ;
        win.render(Ext.getBody());
        var dialog = win.getComponent('dialog');
        dialog.setSrc(url);
        win.show();
    }
    }
    function  newrefobj(inputname,inputspan,doctype,viewurl,isneed,docdir){
        params = ""
        targeturl = encodeURIComponent(targeturlfordoc);
        var url = "/base/popupmain.jsp?url=/document/base/docbasecreate.jsp?categoryid="+docdir+"&doctypeid="+doctype+params+"&targetUrl="+targeturl;
        var id;
        try{
            id = openDialog(url);

        }catch(e){return}
          if (id!=null) {

    if (id[0] != '0') {
		document.all(inputname).value = id[0];
		document.all(inputspan).innerHTML = id[1];
    }else{
		document.all(inputname).value = '';
		if (isneed=='0')
		document.all(inputspan).innerHTML = '';
		else
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
    }

function closeandrefresh(){

	pwin=self.parent;
	if(pwin){
		pwin.store.reload();
		pwin.ClosePop();
	}
}
</script>
</html>
