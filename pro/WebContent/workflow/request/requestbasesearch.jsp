<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>
<%
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
String clear="";
clear=StringHelper.null2String(request.getParameter("clear"));
String requestname="";
String objno="";
String workflowid="";
String isfinished="";
String isdelete="";
String creator="";
String createdatefrom="";
String createdateto="";
String requestlevel="";
String isForceFinish="";
if(clear.equals("true")){
     request.getSession().setAttribute("requestbaseFilter",null);
}
Map requestbaseFilter = (Map)request.getSession().getAttribute("requestbaseFilter");
if(requestbaseFilter!=null){
	if (requestbaseFilter.get("requestname")!=null) requestname = (String)requestbaseFilter.get("requestname");
    if (requestbaseFilter.get("objno")!=null) objno = (String)requestbaseFilter.get("objno"); 
    if (requestbaseFilter.get("workflowid")!=null) workflowid = (String)requestbaseFilter.get("workflowid");
	if (requestbaseFilter.get("isfinished")!=null) isfinished = ""+requestbaseFilter.get("isfinished");
	if (requestbaseFilter.get("isdelete")!=null) isdelete = ""+requestbaseFilter.get("isdelete");
	if (requestbaseFilter.get("creater")!=null) creator = (String)requestbaseFilter.get("creater");
	if (requestbaseFilter.get("createdatefrom")!=null) createdatefrom = (String)requestbaseFilter.get("createdatefrom");
	if (requestbaseFilter.get("createdateto")!=null) createdateto = (String)requestbaseFilter.get("createdateto");
	if (requestbaseFilter.get("requestlevel")!=null) requestlevel = (String)requestbaseFilter.get("requestlevel");
	if (requestbaseFilter.get("isForceFinish")!=null) isForceFinish = ""+requestbaseFilter.get("isForceFinish");
}
isdelete = StringHelper.null2String(request.getParameter("isdelete"));
%>

<!--页面菜单开始-->
<%
PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");

if(pagemenuorder.equals("0")) {
	pagemenustr = _pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0);
}

pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("40288035248eb3e801248f6fb6da0042")+"','R','erase',function(){reset()});";//清空条件
%> 
<html>
  <head>
       <style type="text/css">
     #pagemenubar table {width:0}   
</style>

    <script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript">
        Ext.onReady(function() {

            Ext.QuickTips.init();
        <%if(!pagemenustr.equals("")){%>
            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>
        <%}%>
        });
    </script>
  </head>
  <body>
  
  

<div id="pagemenubar"></div>
<!--页面菜单结束-->
<%
	EweaverUser curuser = BaseContext.getRemoteUser();
	String username = curuser.getUsername();
	String userid = curuser.getId();
%>
	<form action="/ServiceAction/com.eweaver.workflow.request.servlet.RequestbaseAction?action=search" id="EweaverForm" name="EweaverForm" method="post">
	<input name="opttype" type="hidden" value="3,13">
<table>
	<colgroup> 
     <col width="15%">
     <col width="35%">
     <col width="15%">
     <col width="35%">
	</colgroup>	
        <tr class=Title>
			<th colspan=4 nowrap><%=labelService.getLabelName("402881e70b7728ca010b772e24f50009")%><!-- 基本信息--></th>		        	  
        </tr>
        <tr>
			<td class="Line" colspan=4 nowrap>
			</td>		        	  
        </tr>
     <tr>
       <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45f005f") %><!-- 流程编号 --></td>
       <td class="FieldValue"><input name="objno" value="<%=objno%>" class="InputStyle2" style="width:95%" ></td>
        <td class="FieldName" nowrap><%=labelService.getLabelName("402881e50c6d5390010c6d5d5d220007")%></td><!--流程类型 -->
<%
String workflowname="";
if(!StringHelper.isEmpty("workflowid")){
List list=StringHelper.string2ArrayList(workflowid,",");

if(list.size()>0){
for(int i=0;i<list.size();i++){
String wid=StringHelper.null2String(list.get(i));
if(i==0){
workflowname=StringHelper.null2String(workflowinfoService.get(wid).getObjname());
}else{
workflowname+=","+StringHelper.null2String(workflowinfoService.get(wid).getObjname());
}

}
}

}
%>
       <td class="FieldValue">
       		<input type="hidden" name="workflowid" value="<%=workflowid%>"/>			
          	<button type="button" class=Browser onclick="javascript:getBrowser('/base/refobj/baseobjbrowser.jsp?id=40288032239dd0ca0123a2273d270006','workflowid','workflowidspan','0');"></button>
            <span id="workflowidspan"><%=workflowname%></span>
       </td>
     </tr>
     <tr>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881f00c7690cf010c76a942a9002b")%></td>
            <td class="FieldValue"><input name="requestname" value="<%=requestname%>" class="InputStyle2" style="width:95%" ></td>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c7692e5360009")%></td>
       		<td class="FieldValue">
       			<select name=isdelete>
       				<option value="-1" <%if(isdelete.equals("-1")){%> selected <%}%> ></option> 
       				<option value=0 <%if(isdelete.equals("0")||StringHelper.isEmpty(isdelete)){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option> 
       				<option value=1 <%if(isdelete.equals("1")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
       			</select> 
       		</td>	
     </tr>
     <tr>
<% 
			Humres humres=null;
			String humresname="";
			if(!StringHelper.isEmpty(creator)){
				humres=humresService.getHumresById(creator);
			}
			if(humres!=null){
				humresname=StringHelper.null2String(humres.getObjname());
			}
%>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd7215e7b000a")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','creator','creatorspan','0');"></button>
	       	<span id=creatorspan><%=humresname%></span>
	       	<input type=hidden name=creator value="<%=creator%>"> 
	    </td>
	       	<td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd72253df000c")%></td>
       		<td class="FieldValue" align=left>
       			<input type=text class=inputstyle size=10 name="createdatefrom" value="<%=createdatefrom%>" onclick="WdatePicker()">-
                <input type=text class=inputstyle size=10 name="createdateto" value="<%=createdateto%>" onclick="WdatePicker()">
       		</td>
	   </tr>
     <tr>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("40288194108f9f7701108faa84db0004")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','curoperator','curoperatorspan','0');"></button>
	       	<span id=curoperatorspan></span>
	       	<input type=hidden name="curoperator" value=""> 
	    </td>
       	<td class="FieldName" nowrap><%=labelService.getLabelName("40288194108f9f7701108fab08430005")%></td>
      	<td class="FieldValue">
       		<button type="button" class=Browser onclick="javascript:getBrowser('/humres/base/humresbrowser.jsp','hisoperator','hisoperatorspan','0');"></button>
	       	<span id="hisoperatorspan"></span>
	       	<input type=hidden name="hisoperator" value=""> 
	    </td>
	   </tr>
       <tr>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881eb0bd712c6010bd71e4c130007")%></td>
       		<td class="FieldValue">
       			<select name=isfinished><!-- isfinished-->
       				<option value="-1" <%if(isfinished.equals("-1")){%> selected <%}%> ></option>
       				<option value="1" <%if(isfinished.equals("1")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a2fc5a000b")%></option>
       				<option value="0" <%if(isfinished.equals("0")||StringHelper.isEmpty(isfinished)){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76a47202000e")%></option>
       			</select>
       		</td>
            <td class="FieldName" nowrap><%=labelService.getLabelName("402881ef0c768f6b010c76926bcf0007")%></td>
       		<td class="FieldValue">

       			<select name=requestlevel>
       				<option value="" <%if(StringHelper.isEmpty(isdelete)){%> selected <%}%> ></option>
       				<option value="402881eb0c42cba0010c42ff38860008" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860008")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd74dcf010bd751b7610004")%></option>
       				<option value="402881eb0c42cba0010c42ff38860009" <%if(requestlevel.equals("402881eb0c42cba0010c42ff38860009")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76ac26f80014")%></option>
       				<option value="402881eb0c42cba0010c42ff3886000a" <%if(requestlevel.equals("402881eb0c42cba0010c42ff3886000a")){%> selected <%}%> ><%=labelService.getLabelName("402881ef0c768f6b010c76abd9740011")%></option>
       			</select>
       		</td>
       </tr>
       <tr>
            <td class="FieldName" nowrap><%=labelService.getLabelName("4028832e3eef1b51013eef1b524c0288")%></td><!-- 是否废止 -->
       		<td class="FieldValue">
       			<select name="isForceFinish" id="isForceFinish"><!-- isForceFinish-->
       				<option value="-1" <%if(isForceFinish.equals("-1")){%> selected <%}%> ></option> 
       				<option value=0 <%if(isForceFinish.equals("0")||StringHelper.isEmpty(isForceFinish)){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d19cf5000d")%></option> 
       				<option value=1 <%if(isForceFinish.equals("1")){%> selected <%}%> ><%=labelService.getLabelName("402881eb0bd66c95010bd6d13003000c")%></option>
       			</select>
       		</td>
            <td class="FieldName" nowrap></td>
       		<td class="FieldValue">
				
       		</td>
       </tr>
    </table>
   </form>
   <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script language="javascript">
    function reset(){
         $('#EweaverForm span').text('');
         $('#EweaverForm input[type=text]').val('');
         $('#EweaverForm textarea').val('');
         $('#EweaverForm input[type=checkbox]').each(function(){
             this.checked=false;
         });
         $('#EweaverForm input[type=hidden]').each(function(){
             this.value='';
         });
         $('#EweaverForm select').val('');
         $('#EweaverForm span[fillin=1]').each(function(){
             this.innerHTML='<img src=/images/base/checkinput.gif>';
         });
   }
function onSubmit(){
  checkfields="";//填写必须输入的input name，逗号分隔
  checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";//必输项不能为空



  if(checkForm(EweaverForm,checkfields,checkmessage)){
   	document.EweaverForm.submit();
  }
}

var win;
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
	if(!Ext.isSafari){
	    try{
	    id=openDialog('/base/popupmain.jsp?url='+viewurl);
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
		document.all(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';

            }
         }
	}else{
		   	 var callback = function() {
         try {
             id = dialog.getFrameWindow().dialogValue;
         } catch(e) {
         }
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
	    var winHeight = Ext.getBody().getHeight() * 0.95;
	    var winWidth = Ext.getBody().getWidth() * 0.95;
	    if(winHeight>500){//最大高度500
	    	winHeight = 500;
	    }
	    if(winWidth>880){//最大宽度800
	    	winWidth = 880;
	    }
     if (!win) {
          win = new Ext.Window({
             layout:'border',
             width:winWidth,
             height:winHeight,
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
     dialog.setSrc(viewurl);
     win.show();
	}
 }

 </script>
<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js"></script>
	</body>
</html>
