<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.cowork.model.Coworkset" %>
<%@ page import="com.eweaver.app.cooperation.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
Coworkset coworkset = CoworkHelper.getCoworkset();
    String formspan="";
    if(!StringHelper.isEmpty(coworkset.getFormid())){
        formspan=forminfoService.getForminfoById(coworkset.getFormid()).getObjname();
    }
    String replyformidspan="";
    if(!StringHelper.isEmpty(coworkset.getReplyformid())){
    	replyformidspan=forminfoService.getForminfoById(coworkset.getReplyformid()).getObjname();
    }
    String showreadcheck="";
    String replynotifycheck="";
    if(!StringHelper.isEmpty(coworkset.getId())){
         if(coworkset.getShowunread().intValue()==1){
             showreadcheck="checked";
         }
        if(coworkset.getReplynotify().intValue()==1){
             replynotifycheck="checked";
         }
    }
    pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){onSubmit()});";//保存
%>
<html>
<head>
<style type="text/css">
   .x-toolbar table {width:0}
   #pagemenubar table {width:0}
     .x-panel-btns-ct {
       padding: 0px;
   }
   .x-panel-btns-ct table {width:0}
</style>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/FormfieldService.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/interface/DataService.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/engine.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/dwr/util.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
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
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.cowork.servlet.CoworkAction?action=transform" name="EweaverForm" method="post">
		 <table class=layouttable border=1>
				<colgroup> 
					<col width="20%">
					<col width="80%">
				</colgroup>	
                <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("4028831534efec550134efec55fc0003")%><!-- 设置名称 -->
					</td>
					<td class="FieldValue" >
					    <input type="text" name="objname" id="objname" class=inputstyle value="<%=StringHelper.null2String(coworkset.getObjname())%>">
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					协作区表单
					</td>
					<td class="FieldValue" >
					    <button type="button" class=Browser onclick="javascript:getBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?objtype=0','formid','formidspan','1');"></button>
                        <input type="hidden"  name="formid" id="formid" value="<%=StringHelper.null2String(coworkset.getFormid())%>"/>
                        <span id="formidspan"><%=formspan%><%if("".equals(StringHelper.null2String(coworkset.getFormid()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					新建布局
					</td>
					<td class="FieldValue" >
						<select name="createlayout" id="createlayout" onchange="checkEmpty(this,'createlayoutspan')">
                        </select>
                        <span id="createlayoutspan"><%if("".equals(StringHelper.null2String(coworkset.getCreatelayout()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					编辑布局
					</td>
					<td class="FieldValue" >
						<select name="editlayout" id="editlayout" onchange="checkEmpty(this,'editlayoutspan')">
                        </select>
                        <span id="editlayoutspan"><%if("".equals(StringHelper.null2String(coworkset.getEditlayout()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					显示布局
					</td>
					<td class="FieldValue" >
						<select name="viewlayout" id="viewlayout" onchange="checkEmpty(this,'viewlayoutspan')">
                        </select>
                        <span id="viewlayoutspan"><%if("".equals(StringHelper.null2String(coworkset.getViewlayout()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790041")%><!-- 主题字段 -->
					</td>
					<td class="FieldValue" >
						<select name="subject" id="subject" onchange="checkEmpty(this,'subjectspan')">
                       </select>
                       <span id="subjectspan"><%if("".equals(StringHelper.null2String(coworkset.getSubject()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作类别字段
					</td>
					<td class="FieldValue" >
						<select name="coworktype" id="coworktype" onchange="checkEmpty(this,'coworktypespan');getfunctionary(this.value)">
                        </select>
                        <span id="coworktypespan"><%if("".equals(StringHelper.null2String(coworkset.getCoworktype()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作类别负责人字段
					</td>
					<td class="FieldValue" >
						<select name="functionary" id="functionary">
                        </select>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作描述字段
					</td>
					<td class="FieldValue" >
						<select name="coworkremark" id="coworkremark" onchange="checkEmpty(this,'coworkremarkspan')">
                        </select>
                        <span id="coworkremarkspan"><%if("".equals(StringHelper.null2String(coworkset.getCoworkremark()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作回复表单
					</td>
					<td class="FieldValue" >
					    <button type="button" class=Browser onclick="javascript:getReplyBrowser('<%= request.getContextPath()%>/workflow/form/forminfobrowser.jsp?objtype=0','replyformid','replyformidspan','1');"></button>
                        <input type="hidden"  name="replyformid" id="replyformid" value="<%=StringHelper.null2String(coworkset.getReplyformid())%>"/>
                        <span id="replyformidspan"><%=replyformidspan%><%if("".equals(StringHelper.null2String(coworkset.getReplyformid()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					回复内容字段
					</td>
					<td class="FieldValue" >
						<select name="replycontent" id="replycontent" onchange="checkEmpty(this,'replycontentspan')">
                        </select>
                        <span id="replycontentspan"><%if("".equals(StringHelper.null2String(coworkset.getReplycontent()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					回复者字段
					</td>
					<td class="FieldValue" >
						<select name="replymembers" id="replymembers" onchange="checkEmpty(this,'replymembersspan')">
                        </select>
                        <span id="replymembersspan"><%if("".equals(StringHelper.null2String(coworkset.getReplymembers()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					回复日期字段
					</td>
					<td class="FieldValue" >
						<select name="replydate" id="replydate" onchange="checkEmpty(this,'replydatespan')">
                        </select>
                        <span id="replydatespan"><%if("".equals(StringHelper.null2String(coworkset.getReplydate()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					回复时间字段
					</td>
					<td class="FieldValue" >
						<select name="replytime" id="replytime" onchange="checkEmpty(this,'replytimespan')">
                        </select>
                        <span id="replytimespan"><%if("".equals(StringHelper.null2String(coworkset.getReplytime()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr style="display: none;">
					<td class="FieldName" nowrap>
					附件类型限制
					</td>
					<td class="FieldValue" >
					    <input type="text" name="attachtype" id="attachtype" class=inputstyle value="<%=StringHelper.null2String(coworkset.getAttachtype())%>">（说明：默认可以上传所有附件 例如：*.rar,*.doc）
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790043")%><!-- 显示未读人员 -->
					</td>
					<td class="FieldValue" >
						<input type="checkbox" class="InputStyle2"  name="showunread" id="showunread" value=1 onclick="checkvalue()" <%=showreadcheck%>    />
					</td>
				</tr>
		        <tr>
					<td class="FieldName" nowrap>
					<%=labelService.getLabelNameByKeyId("402883d7353baf7101353baf73790044")%><!-- 有新回复时提醒 -->
					</td>
					<td class="FieldValue" >
						<input type="checkbox" class="InputStyle2"  name="replynotify" id="replynotify" value=1 onclick="checkvalue()" <%=replynotifycheck%>/>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作描述默认布局
					</td>
					<td class="FieldValue" >
						<select id="defshow1" name="defshow1"onchange="checkEmpty(this,'defshow1span')">
                        </select>
                        <span id="defshow1span"><%if("".equals(StringHelper.null2String(coworkset.getDefshow1()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
				<tr>
					<td class="FieldName" nowrap>
					协作附加信息默认布局
					</td>
					<td class="FieldValue" >
						<select id="defshow2" name="defshow2"onchange="checkEmpty(this,'defshow2span')">
                        </select>
                        <span id="defshow2span"><%if("".equals(StringHelper.null2String(coworkset.getDefshow2()))){%><img src='<%=request.getContextPath()%>/images/base/checkinput.gif'><%} %></span>
					</td>
				</tr>
                <tr >
                    <td class="FieldName" nowrap>
                        <%=labelService.getLabelNameByKeyId("402881eb0bd712c6010bd725161f000e")%><!-- 说明 -->
                    </td>
                    <td class="FieldValue" >
                        <textarea rows="8" cols="95" id="description" name="description" ><%=StringHelper.null2String(coworkset.getDescription())%></textarea>
                    </td>
                </tr>
		</table>
</form>
<script language="javascript">
/*保存*/
function onSubmit(){
   var objname=document.getElementById('objname').value;
   var formid=document.getElementById('formid').value;
   var createlayout=document.getElementById('createlayout').value;
   var editlayout=document.getElementById('editlayout').value;
   var viewlayout=document.getElementById('viewlayout').value;
   var subject=document.getElementById('subject').value;
   var coworktype=document.getElementById('coworktype').value;
   var coworkremark = document.getElementById('coworkremark').value;
   
   var replyformid=document.getElementById('replyformid').value;
   var replycontent=document.getElementById('replycontent').value;
   var replymembers=document.getElementById('replymembers').value;
   var replydate=document.getElementById('replydate').value;
   var replytime=document.getElementById('replytime').value;
   var attachtype=document.getElementById('attachtype').value;
   
   var showunread=document.getElementById('showunread').value;
   var replynotify=document.getElementById('replynotify').value;
   var description=document.getElementById('description').value;
   
   var defshow1 =document.getElementById('defshow1').value;
   var defshow2 =document.getElementById('defshow2').value;
   var functionary=document.getElementById('functionary').value;
   if(formid=='' || createlayout=='' || editlayout=='' ||viewlayout=='' || subject=='' || coworktype=='' || replyformid==''
		  || replycontent==''|| replymembers=='' || replydate=='' || replytime=='' || coworkremark=='' || defshow1=='' || defshow2==''){
     pop('<%=labelService.getLabelNameByKeyId("402881e40aae0af9010aaeb4b38d0002")%>','<%=labelService.getLabelNameByKeyId("402883cd353c1e6b01353c1e6be2000d")%>',null,'cancel')//必填项不能为空
       return;
   }
   Ext.Ajax.request({
       url: '<%=request.getContextPath()%>/ServiceAction/com.eweaver.app.cooperation.CoworkAction?action=transform',
       params:{id:'<%=coworkset.getId()%>',objname:objname,formid:formid,createlayout:createlayout,editlayout:editlayout,viewlayout:viewlayout,subject:subject,coworktype:coworktype,replyformid:replyformid,replycontent:replycontent,replymembers:replymembers,replydate:replydate,replytime:replytime,showunread:showunread,replynotify:replynotify,description:description,attachtype:attachtype,coworkremark:coworkremark,functionary:functionary,defshow1:defshow1,defshow2:defshow2},
       success: function() {
           pop( '<%=labelService.getLabelNameByKeyId("4028834634e95e120134e95e14460007")%>');//设置成功！
       }
   });
}
    getSubjectOptions(Ext.getDom("formid").value);//主题字段
    getCoworktypeOptions(Ext.getDom("formid").value);//协作类别字段
    getShowLayoutInfo(Ext.getDom("formid").value);//获取布局
	getEditLayoutInfo(Ext.getDom("formid").value);//获取布局
    getCoworkremarkOptions(Ext.getDom("formid").value);//协作区描述字段
    getCoworkDefshow1(Ext.getDom("formid").value);//协作描述默认布局  add by 2012-12-25
    /*回复表*/
    getReplycontentOptions(Ext.getDom("replyformid").value); //回复内容字段
    getReplymembersOptions(Ext.getDom("replyformid").value); //回复者字段
    getReplydateOptions(Ext.getDom("replyformid").value);//回复者日期字段
    getReplytimeOptions(Ext.getDom("replyformid").value);//回复者时间字段 
    getCoworkDefshow2(Ext.getDom("replyformid").value);//附加信息默认布局 add by 2012-12-25
function checkvalue(){
    if(document.all('showunread').checked){
         document.getElementById('showunread').value=1;
    }else{
         document.getElementById('showunread').value=0;
    }
    if(document.all('replynotify').checked){
         document.getElementById('replynotify').value=1;
    }else{
         document.getElementById('replynotify').value=0;
    }
}
function checkEmpty(obj,spanstr){
	var value = obj.value;
	if(value && value!=''){
		document.getElementById(spanstr).innerHTML="";
	}else{
		document.getElementById(spanstr).innerHTML="<img src='<%=request.getContextPath()%>/images/base/checkinput.gif'>";
	}
}

//更改协作类别 带出协作类别负责人
function getfunctionary(value){
	if(value && value!=""){
		var typeformid="";
		var sql1="SELECT reftable FROM refobj WHERE ID IN ( SELECT fieldtype FROM formfield WHERE id='"+value+"' and htmltype=6 and isdelete=0)";  
	    DWREngine.setAsync(false);//同步  
        DataService.getValues(sql1,function(data){
        	if(data && data.length>0){
        		var temptable = data[0].reftable;
        		var sql = "SELECT id,objname FROM forminfo WHERE objtablename='"+temptable+"'";
        		DWREngine.setAsync(false);//同步  
        		DataService.getValues(sql,function(data1){
	        	if(data1 && data1.length>0){
	        		typeformid=data1[0].id;
	        		// alert(typeformid);
	        		//alert(data1[0].objname);
	        	}
	        	});
        	}
        });
	    FormfieldService.getFieldByForm(typeformid,6,'402881eb0bd30911010bd321d8600015',functionarycallback)
    }else{
    	DWRUtil.removeAllOptions("functionary");
    }		
}
function functionarycallback(list){
    DWRUtil.removeAllOptions("functionary");
    var objselect = document.all("functionary");
    objselect.add(new Option());
    DWRUtil.addOptions("functionary",list,"id","labelname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getFunctionary()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}

/*删除*/
function onDelete(id){
   if(confirm('<%=labelService.getLabelName("402881e90aac1cd3010aac1d97730001")%>')){
      document.EweaverForm.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.menu.servlet.PagemenuAction?action=delete&id="+id;//输入你的Action
      document.EweaverForm.submit();
   }
}
//获取布局信息
function getShowLayoutInfo(formid){
	if(formid!=""){
	   var sql1="SELECT id,layoutname FROM formlayout WHERE formid='"+formid+"' and typeid='1' and isdelete=0";  
	   DWREngine.setAsync(false);//同步  
       DataService.getValues(sql1,showlayoutcallback);  
    }		
}
//获取布局信息
function getEditLayoutInfo(formid){
	if(formid!=""){
	   var sql1="SELECT id,layoutname FROM formlayout WHERE formid='"+formid+"' and typeid='2' and isdelete=0";  
	   DWREngine.setAsync(false);//同步  
       DataService.getValues(sql1,editlayoutcallback);  
    }		
}
function editlayoutcallback(list){
    DWRUtil.removeAllOptions("createlayout");
    var objselect = document.all("createlayout");
    objselect.add(new Option());
    DWRUtil.addOptions("createlayout",list,"id","layoutname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getCreatelayout()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    DWRUtil.removeAllOptions("editlayout");
    var objselect = document.all("editlayout");
    objselect.add(new Option());
    DWRUtil.addOptions("editlayout",list,"id","layoutname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getEditlayout()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function showlayoutcallback(list){
    DWRUtil.removeAllOptions("viewlayout");
    var objselect = document.all("viewlayout");
    objselect.add(new Option());
    DWRUtil.addOptions("viewlayout",list,"id","layoutname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getViewlayout()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}

function getReplymembersOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,6,'402881e70bc70ed1010bc75e0361000f',callback)
}
function callback(list){
    DWRUtil.removeAllOptions("replymembers");
    var objselect = document.all("replymembers");
    objselect.add(new Option());
    DWRUtil.addOptions("replymembers",list,"id","labelname");

    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getReplymembers()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}

function getCoworkremarkOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,3,'',callbackremark)
}
function callbackremark(list){
    DWRUtil.removeAllOptions("coworkremark");
    var objselect = document.all("coworkremark");
    objselect.add(new Option());
    DWRUtil.addOptions("coworkremark",list,"id","labelname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getCoworkremark()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
   
}

function getCoworktypeOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,6,'',callback1)
}
function callback1(list){
    DWRUtil.removeAllOptions("coworktype");
    var objselect = document.all("coworktype");
    objselect.add(new Option());
    DWRUtil.addOptions("coworktype",list,"id","labelname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getCoworktype()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
    getfunctionary('<%=coworkset.getCoworktype()%>');
}

function getReplycontentOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,3,'',callbackc)
}
function callbackc(list){
    DWRUtil.removeAllOptions("replycontent");
    var objselect = document.all("replycontent");
    objselect.add(new Option());
    DWRUtil.addOptions("replycontent",list,"id","labelname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getReplycontent()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
   
}
function getReplydateOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'',callbackrd)
}
function callbackrd(list){
    DWRUtil.removeAllOptions("replydate");
    var objselect = document.all("replydate");
    objselect.add(new Option());
    DWRUtil.addOptions("replydate",list,"id","labelname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getReplydate()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function getReplytimeOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'',callbackrt)
}
function callbackrt(list){
    DWRUtil.removeAllOptions("replytime");
    var objselect = document.all("replytime");
    objselect.add(new Option());
    DWRUtil.addOptions("replytime",list,"id","labelname");    
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getReplytime()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }
}
function getSubjectOptions(formid){
    if(formid!="")
    FormfieldService.getFieldByForm(formid,1,'1',callback2);
}
function callback2(list){
    DWRUtil.removeAllOptions("subject");
    var objselect = document.all("subject");
    objselect.add(new Option())
    DWRUtil.addOptions("subject",list,"id","labelname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getSubject()%>') {
            objselect.options[i].selected = true;
            break;
        }
        }

}
/*默认描述布局*/
function getCoworkDefshow1(formid){
    if(formid!=""){
	   var sql1="SELECT id,layoutname FROM formlayout WHERE formid='"+formid+"' and typeid='1' and isdelete=0";  
	   DWREngine.setAsync(false);//同步  
       DataService.getValues(sql1,defshow1layoutcallback);  
    }
}
function defshow1layoutcallback(list){
    DWRUtil.removeAllOptions("defshow1");
    var objselect = document.all("defshow1");
    objselect.add(new Option());
    DWRUtil.addOptions("defshow1",list,"id","layoutname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getDefshow1()%>') {
            objselect.options[i].selected = true;
            break;
        }
    }
}
/*默认附件信息布局*/
function getCoworkDefshow2(replyformid){
    if(replyformid!=""){
	   var sql1="SELECT id,layoutname FROM formlayout WHERE formid='"+replyformid+"' and typeid='2' and isdelete=0";  
	   DWREngine.setAsync(false);//同步  
       DataService.getValues(sql1,defshow2layoutcallback);  
    }
}
function defshow2layoutcallback(list){
    DWRUtil.removeAllOptions("defshow2");
    var objselect = document.all("defshow2");
    objselect.add(new Option());
    DWRUtil.addOptions("defshow2",list,"id","layoutname");
    var selectLen = objselect.length;
    for (i = 0; i < selectLen; i++) {
        if (objselect.options[i].value =='<%=coworkset.getDefshow2()%>') {
            objselect.options[i].selected = true;
            break;
        }
    }
}

/*获取主表单信息*/
function getBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
	        document.all(inputname).value = id[0];
	        document.all(inputspan).innerHTML = id[1];
	        getSubjectOptions(Ext.getDom("formid").value);
	        getCoworktypeOptions(Ext.getDom("formid").value);
	        getShowLayoutInfo(Ext.getDom("formid").value);//获取布局
	        getEditLayoutInfo(Ext.getDom("formid").value);//获取布局
	        getCoworkremarkOptions(Ext.getDom("formid").value);//获取布局
	        getCoworkDefshow1(Ext.getDom("formid").value);//获取默认描述布局
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src='+contextPath+'/images/base/checkinput.gif>';
	    }
    } 
}
/*获取回复表单信息*/
function getReplyBrowser(viewurl,inputname,inputspan,isneed){
	var id;
    try{
    id=openDialog(contextPath+'/base/popupmain.jsp?url='+viewurl);
    }catch(e){}
	if (id!=null) {
		if (id[0] != '0') {
	        document.all(inputname).value = id[0];
	        document.all(inputspan).innerHTML = id[1];
	        /*回复表*/
		    getReplycontentOptions(Ext.getDom("replyformid").value); //回复内容字段
		    getReplymembersOptions(Ext.getDom("replyformid").value); //回复者字段
		    getReplydateOptions(Ext.getDom("replyformid").value);//回复者日期字段
		    getReplytimeOptions(Ext.getDom("replyformid").value);//回复者时间字段
		    getCoworkDefshow2(Ext.getDom("replyformid").value);//附加信息默认布局
	    }else{
			document.all(inputname).value = '';
			if (isneed=='0')
			document.all(inputspan).innerHTML = '';
			else
			document.all(inputspan).innerHTML = '<img src='+contextPath+'/images/base/checkinput.gif>';
	    }
    } 
}
</script> 
</body>
</html>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      