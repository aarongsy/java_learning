<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.*"%>
<%@ page import="com.eweaver.workflow.form.dao.FormfieldDao" %>
<%@ page import="com.eweaver.workflow.workflow.model.*"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%
    Forminfo forminfo = null;
    Formfield formfield = null;
    FormfieldDao formfieldDao  =(FormfieldDao)BaseContext.getBean("formfieldDao");
    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
	Selectitem selectitem = null;
	List selectitemlist = selectitemService.getSelectitemList("4028819d0e521bf9010e5237454d000a",null);
    String moduleid=StringHelper.trimToNull(request.getParameter("moduleid"));
%>
<html>
	<head>
  	  <script src='<%=request.getContextPath()%>/dwr/interface/DataService.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
      <script src='<%=request.getContextPath()%>/dwr/util.js'></script>
      <script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
      <script type="text/javascript">
      //附件生成文档目录
	  function changeDocType(){
			   var fid = document.getElementsByName("formid")[0].value;
				if(fid && fid.length==32){
				  DataService.getValues(createList_doc,"select id,labelname from formfield where formid=\'"+fid+"\' and isdelete = 0 and htmltype=6 and fieldtype=\'402883ee3205018e0132056968450005\'");
				}else{
				 DWRUtil.removeAllOptions("createDocField");
				}
			}
			
	 function createList_doc(data) //第一个必须添加空进去
		{
		    DWRUtil.removeAllOptions("createDocField");
		    DWRUtil.addOptions("createDocField",["  "]); 
	        DWRUtil.addOptions("createDocField", data,"id","labelname");
		}
</script>
	</head>
	<body>
		<!--页面菜单开始-->
		<%pagemenustr += "{S," + labelService.getLabelName("402881e60aabb6f6010aabbda07e0009") + ",javascript:onSubmit()}";%>
		<div id="pagemenubar" style="z-index:100;"></div>
		<%@ include file="/base/pagemenu.jsp"%>
		<!--页面菜单结束-->
		<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowinfoAction?action=create" name="EweaverForm" method="post">
        <input type="hidden" value="<%=moduleid%>" name="moduleid">
            <table class=noborder>
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>
				<tr class=Title>
					<th colspan=2 nowrap>                                                
						<%=labelService.getLabelName("402881ec0bdc2afd010bdd32351a0021")%><!-- 流程信息-->
					</th>
					<!-- 流程信息 -->
				</tr>
				<tr>
					<td class="Line" colspan=2 nowrap></td>
				</tr>
				<tr><!--  流程名称 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72411ed60060")%><!-- 流程名称-->
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" id="objname" name="objname" onChange="checkInput('objname','objnamespan')"/>
						<span id="objnamespan"><img src=<%=request.getContextPath()%>/images/base/checkinput.gif></span>
					</td>
				</tr>
				
				<tr><!--  流程表单 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7243a5fa0069")%><!-- 流程表单-->
					</td>
					<td class="FieldValue">
					   <input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/workflow/form/forminfobrowser.jsp?moduleid=<%=moduleid%>','formid','formidspan','0');addFormField();" />
					   <input type="hidden" id="formid"  name="formid" onChange="javascript:addFormField();checkInput('formid','formidspan');"/>
					   <span id="formidspan"><img src=<%=request.getContextPath()%>/images/base/checkinput.gif></span>
					</td>
				</tr>		
				<tr><!-- 是否有效 -->
					<td class="FieldName" nowrap>
                      <%=labelService.getLabelNameByKeyId("402881e70c864b41010c867b2eb40010")%>  <!-- 流程状态--><!-- 是否有效-->
					</td>
					<td class="FieldValue">
                        <select name='isactive'>
                            <option value="1" selected><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd67f5e310002")%></option><!-- 显示 -->
                            <option value="2"><%=labelService.getLabelNameByKeyId("402881eb0bd66c95010bd68004400003")%></option><!-- 隐藏 -->
                            <option value="0"><%=labelService.getLabelNameByKeyId("4028831534f3b1080134f3b1119a0003")%></option><!-- 禁用 -->
                        </select>
					</td>
				</tr>
				<tr><!-- 是否公文 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028803221c7e69f0121c81e6d830002")%>
					</td>
					<td class="FieldValue">
                        <input  type='checkbox' name='isdocument' value='1' onclick="onCheckDocument(this)"/>
					</td>
				</tr>
				<tr id="docTemplateRow" style="display:none;">
					<td class="FieldName" nowrap><!-- 公文模板-->
                         <%=labelService.getLabelName("4028803221c7e69f0121c821a58c0003")%>
					</td>
					<td class="FieldValue">
                       <input type="button" class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/document/base/wordmodulebrowser.jsp','docTemplate','docTemplatespan','0');" />
					   <input type="hidden" id="docTemplate" name="docTemplate"/><span id="docTemplatespan"></span>
					</td>
				</tr>
				<tr style="display:none"><!-- 是否审批流程 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72581f1c0087")%><!-- 是否审批流程-->
					</td>
					<td class="FieldValue">
                        <input  type='checkbox' name='isapprovable' value='0' onClick="javascript:onCheck('isapprovable')"/>
					</td>
				</tr>	
				<tr id="approveobjtr" style="display:none"><!-- 审批对象 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7258808e008a")%><!-- 审批对象-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="approveobj" id="approveobj"> 
                         
                       </select>
					</td>
				</tr>	
				<tr id="approveobjtr1" style="display:none"><!-- 审批对象类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881e70cc93649010cca10a7d40008")%><!-- 审批对象类型-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="approveobjtype" id="approveobjtype"> 
                         
                       </select>
					</td>
				</tr>				
				<tr><!-- 提醒类型 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028819d0e521bf9010e525d08b70010")%><!-- 提醒类型-->
					</td>
					<td  class="FieldValue">
                       <select  class="inputstyle"  name="remindtype" id="remindtype"  onChange="javascript:changeType()">
                       <%for(int i=0;i<selectitemlist.size();i++){
                       selectitem=(Selectitem)selectitemlist.get(i);
                       %>
					   <option value="<%=selectitem.getId()%>" >
						<%=selectitem.getObjname()%>
					   </option>
					   <%}%>
                       </select>
					</td>
				</tr>
				<!-- begin 选择提醒方式 -->
				</tr>
					<tr id="selmail" style="display:none"><!--  选择邮件提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028832f3242eec9013242eed3fd0000")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='selemail' value="1" onClick="javascript:onCheck('selemail')"/>
					</td>
				</tr>
				<tr id="selims" style="display:none"><!--  选择短消息提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028832f3242eec9013242eed3fd0001")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='selsms' value="1" onClick="javascript:onCheck('selsms')"/>
					</td>
				</tr>
                <tr id="selpopup" style="display:none"><!--  选择弹出式提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028832f3242eec9013242eed3fd0003")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='selpopup' value="1" onClick="javascript:onCheck('selpopup')"/>
					</td>
				</tr>
				<tr id="selrtx" style="display:none"><!--  选择rtx提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028832f3242eec9013242eed3fd0002")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='selrtx' value="1" onClick="javascript:onCheck('selrtx')"/>
					</td>
                </tr>
				<!-- end 选择提醒方式 -->
				<tr id="ismail" style="display:none"><!--  是否邮件提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7274e72000cf")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isemail' value='0' onClick="javascript:onCheck('isemail') "/><!-- onClick="javascript:onCheck('isemail')" -->
					</td>
				</tr>				
				<tr id="emailmodeltr"  style="display:none"><!--  邮件模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c727606f600d2")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="emailmodel" />
					</td>
				</tr>											
				<tr id="isims" style="display:none"><!--  是否短消息提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72766b6b00d5")%>

					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='issms' value='0' onClick="javascript:onCheck('issms')" /><!-- onClick="javascript:onCheck('issms')" -->
					</td>
				</tr>							
				<tr id="msgmodeltr"  style="display:none"><!--  消息模板 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c7276cf0e00d8")%>
					</td>
					<td class="FieldValue">
						<input type="text" class="InputStyle2" style="width:50%" name="msgmodel" />
					</td>
				</tr>	
				<tr id="isrpopup" style="display:none"><!--  是否弹出式提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028832f3242eec9013242eed3fd0004")%>
					</td>
					<td class="FieldValue">
					    <input type='checkbox' name='ispopup' value="0" onClick="javascript:onCheck('ispopup')" />
					</td>
				</tr>			
				<tr id="istrtx" style="display:none"><!--  是否rtx提醒 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c727750bb00db")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isrtx' value='0' onClick="javascript:onCheck('isrtx')" />
					</td>
				 </tr>		
				 <!-- begin 是否在手机版中显示此流程-->
				 <tr style="display: none;">
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402882443551562e0135515639a20000")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' name='isShowInMobile' value='1'  onClick="javascript:onCheck('isShowInMobile');" />
					</td>
				  </tr>		
				<!-- begin 是否流程附件生成文档 -->
				 <tr style="display: none;">
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd013213405bef0003")%>
					</td>
					<td class="FieldValue">
					   <input type='checkbox' id="iscreateDoc" name='iscreateDoc' value='1'  onClick="javascript:onCheck('iscreateDoc');" />
					</td>
				  </tr>				  				
				  <tr id="iscreateDocTR1" style="display:none"><!-- 流程附件生成文档目录 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd01321340b4f10004")%><!-- 流程附件生成文档目录-->
					</td>
					<td  class="FieldValue" >
		                       <!-- 设置目录 -->
		                       <script type="text/javascript">
		                             /**
									 选择附件生成文档目录
									 */
										function add_dir(data){
											 document.all("defaultDocDirspan").innerHTML = data[0].objname;
										 }
										     
										function getBrowserNew(viewurl,inputname,inputspan,isneed){
											var id;
										    try{
										    id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
										    }catch(e){}
											if (id!=null) {
												if (id[0] != '0') {
													document.all(inputname).value = id[0];
													DWREngine.setAsync(false);//同步 
													DataService.getValues(add_dir,"select objname from category where id=\'"+id[0]+"\' and isdelete =0");
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
		                       <span id="createDocDir3span" >
						          <input type="hidden" name="defaultDocDir" id="defaultDocDir" onchange="javascript:checkInput('defaultDocDir','defaultDocDirspan')" />
								  <input type="button" class=Browser onclick="javascript:getBrowserNew('/base/refobj/treeviewerBrowser.jsp?id=402881182b0b5c99012b0bb445f1010c&rootID=40288148117d0ddc01117d8c36e00dd4','defaultDocDir','defaultDocDirspan','0');" />
								  <span id="defaultDocDirspan" /></span>
		                       </span>
					</td>
				 </tr>
				 <tr id="iscreateDocTR2"><!-- 流程附件生成文档目录 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("4028835d32130dfd0132134109d50005")%><!-- 流程附件生成文档目录-->
					</td>
					<td  class="FieldValue" >
						<span id="createDocDir2span"><%=labelService.getLabelName("4028835d32130dfd0132134168a00006")%>
		                   <!-- 相关字段 -->
		                   <select  class="inputstyle"  name="createDocField" id="createDocField" >
		                   </select>
		               </span>
					</td>
				 </tr>
				<!-- end 是否流程附件生成文档 -->
				<tr><!-- 是否触发 -->
					<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402881ee0c715de3010c7258e5df008d")%><!-- 是否触发-->
					</td>
					<td class="FieldValue">
                        <input  type='checkbox' name='istrigger' value='0' onClick="javascript:onCheck('istrigger')"/>
					</td>
				</tr>
				<tr id="triggercycletr" style="display:none"><!-- 触发周期 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c72596ebf0090")%><!-- 触发周期-->
					</td>
					<td class="FieldValue">
                       <select class="inputstyle"  name="triggercycle" id="triggercycle" onChange="javascript:cycleChange()"> 
                         <option value="1"><%=labelService.getLabelName("402881ee0c715de3010c7259da670093")%><!-- 每日--></option>
                         <option value="2"><%=labelService.getLabelName("402881ee0c715de3010c725a3d910096")%><!-- 每周--></option>
                         <option value="3"><%=labelService.getLabelName("402881ee0c715de3010c725aa0f80099")%><!-- 每月--></option>
                         <option value="4"><%=labelService.getLabelName("402881ee0c715de3010c725b0621009c")%><!-- 每年--></option> 
                       </select>
					</td>
				</tr>						
				<tr id="triggerdatetr" style="display:none"><!-- 触发日期 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c725b7327009f")%><!-- 触发日期-->
					</td>
					<td class="FieldValue">
   				    	<input type=text class=inputstyle size=10 name="triggerdate" value="" onclick="WdatePicker()">
					</td>
				</tr>	
				<tr id="triggerdatetr2" style="display:none"><!-- 触发日期2 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c725c5dde00a2")%><!-- 触发日期2-->
					</td>
					<td class="FieldValue">
                       <select class="inputstyle" style="display:none" name="triggerdate2" id="triggerdate2"> 
                          
                       </select> 
					</td>
				</tr>				
							
				<tr id="triggertimetr" style="display:none"><!-- 触发时间 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("402881ee0c715de3010c725d619d00a5")%><!-- 触发时间-->
					</td>
					<td class="FieldValue">
    				  <input type=text class=inputstyle size=10 name="triggertime" value="" onclick="WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})">
						
					</td>
				</tr>
				<tr><!-- 是否允许代理 -->
					<td class="FieldName" nowrap>
							<%=labelService.getLabelName("402883fa3bda3e74013bda3e7a6e0000")%><!-- 是否允许代理-->
					</td>
					<td class="FieldValue">
                        <input  type='checkbox' name='isPermitActing' value='1' checked/>
					</td>
				</tr>
				<tr><!--  帮助文档 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c725dd26f00a8")%><!-- 帮助文档-->
					</td>
					<td class="FieldValue">
					   <input type="button"  class=Browser onclick="javascript:getBrowser('<%=request.getContextPath()%>/document/base/docbasebrowser.jsp','helpdoc','helpdocspan','0');" />
					   <input type="hidden"  name="helpdoc" />
					   <span id="helpdocspan"></span>
					</td>
				</tr>	
				<tr><!--  默认标题 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ec0bdc2afd010bdc44cf81000a")%><!-- 默认标题-->
					</td>
					<td class="FieldValue">
                       <input type="text" class="InputStyle2" style="width:50%" id="deftitle" name="deftitle" onChange="checkInput('deftitle','deftitlespan')"/>
					   <span id="deftitlespan"><img src=<%=request.getContextPath()%>/images/base/checkinput.gif></span>
					</td>
				</tr>
 				<tr><!--  排序参数 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402880371b9ff70f011b9ffffed70004")%><!-- 排序参数-->
					</td>
					<td class="FieldValue">
                       <input type="text" class="InputStyle2" style="width:50%" name="dsporder" />
					</td>
				</tr>
				<tr>
                   <td class="FieldName" nowrap><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220021")%></td><!-- 数据删除类型 -->
                   <td class="FieldValue">
                        <select class="inputstyle" style="width:120px" id="deleteType" name="deleteType">
                        	<option value="0"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220022")%></option><!-- 逻辑删除 -->
                        	<option value="1"><%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220023")%></option><!-- 物理删除 -->
                        </select>
                        &nbsp;<label style="font-size:12px;">(<%=labelService.getLabelNameByKeyId("4028831534ee5d830134ee5d85220024")%>)</label><!-- 逻辑删除为假删除,物理删除会直接删除数据 -->
                   </td>
                </tr>
                <tr><!--  流程描述 -->
					<td class="FieldName" nowrap>
                          <%=labelService.getLabelName("402881ee0c715de3010c725e939000ab")%><!-- 流程描述-->
					</td>
					<td class="FieldValue">
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=5 name="objdesc"></TEXTAREA>					
					</td>
				</tr>								

			</table>
		</form>
<script language="javascript">
var win;
 function getBrowser(viewurl, inputname, inputspan, isneed) {
        var id;
        if(!Ext.isSafari){
	        try {
	            id = openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=' + viewurl);
	        } catch(e) {
	        }
	        if (id != null) {
	            if (id[0] != '0') {
	                document.all(inputname).value = id[0];
	                document.all(inputspan).innerHTML = id[1];
	            } else {
	                document.all(inputname).value = '';
	                if (isneed == '0')
	                    document.all(inputspan).innerHTML = '';
	                else
	                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
	
	            }
	        }
        }else{
        	//----
    	    var callback = function() {
    	            try {
    	                id = dialog.getFrameWindow().dialogValue;
    	            } catch(e) {
    	            }
    	            if (id != null) {
    		            if (id[0] != '0') {
    		                document.all(inputname).value = id[0];
    		                document.all(inputspan).innerHTML = id[1];
    		            } else {
    		                document.all(inputname).value = '';
    		                if (isneed == '0')
    		                    document.all(inputspan).innerHTML = '';
    		                else
    		                    document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';
    		
    		            }
    		        }
    	        }
    	        if (!win) {
    	             win = new Ext.Window({
    	                layout:'border',
    	                width:window.parent.dlg0.width*0.8,
    	                height:window.parent.dlg0.height*0.8,
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
    		
		//----
    }
 
function onCheckDocument(obj){
	document.getElementById('docTemplateRow').style.display=obj.checked?'':'none';
}
function onCheck(checkName) {
 //是否附件生成文档
			           if(checkName=="iscreateDoc"){
			              if (document.all("iscreateDoc").checked){
					         document.all("iscreateDoc").value='1';
					         document.getElementById("iscreateDocTR1").style.display='block';
					         document.getElementById("iscreateDocTR2").style.display='block';
					      }else{
					         document.all("iscreateDoc").value='0';
					         document.getElementById("iscreateDocTR1").style.display='none';
					         document.getElementById("iscreateDocTR2").style.display='none';
					      }
			           }
//是否有效
    if (checkName=="isactive") {
       if (document.all("isactive").checked){
         document.all("isactive").value='1';
       }else{
         document.all("isactive").value='0';
       }
    }
//是否审批流程 
    if (checkName=="isapprovable") {
      var approveobjTr = document.getElementById("approveobjtr");
      var approveobjTr1 = document.getElementById("approveobjtr1");
      var approveobjSelect = document.getElementById("approveobj");
      var approveobjtypeSelect = document.getElementById("approveobjtype");
      if (document.all("isapprovable").checked){
        approveobjTr.style.display='';
        approveobjTr1.style.display='';
        approveobjSelect.style.display='';
        approveobjtypeSelect.style.display='';
        document.all("isapprovable").value='1';
      }else{
         approveobjTr.style.display='none';
         approveobjTr1.style.display='none';
         approveobjSelect.style.display='none';
         approveobjtypeSelect.style.display='none';
         document.all("isapprovable").value='0';
      }
    }
//是否触发  
    if (checkName=="istrigger"){
      var triggercycletr = document.getElementById("triggercycletr");
      var triggercycleselect = document.getElementById("triggercycle");  
      var triggertimetr = document.getElementById("triggertimetr");
      var triggerdate2select = document.getElementById("triggerdate2");
      var triggerdatetr2 = document.getElementById("triggerdatetr2");
      if (document.all("istrigger").checked) {
         triggercycletr.style.display ='';
         triggercycleselect.style.display ='';
         triggercycleselect.options[0].selected=true;
         triggertimetr.style.display ='';
         document.all("istrigger").value='1';
      }else{
         triggercycletr.style.display ='none';
         triggercycleselect.style.display ='none';
         triggertimetr.style.display ='none';  
         triggerdate2select.style.display ='none';  
         triggerdatetr2.style.display ='none'; 
         document.all("istrigger").value='0';   
      }
    }
//是否邮件
     if (checkName=="isemail") {
     if (document.all("isemail").checked){
       document.all("isemail").value='1';
     }else{
       document.all("isemail").value='0';    
     } 
  }
//是否消息
  if (checkName=="issms"){
    if (document.all("issms").checked) {
       document.all("issms").value='1';
    }else{
       document.all("issms").value='0';   
    }
    }
  //是否弹出式
  if (checkName=="ispopup") {
     if (document.all("ispopup").checked){
       document.all("ispopup").value='1';
     }else{
       document.all("ispopup").value='0';    
     } 
  }
//是否rtx
  if (checkName=="isrtx"){
    if (document.all("isrtx").checked) {
       document.all("isrtx").value='1';
    }else{
       document.all("isrtx").value='0';   
    }
  }
 //////begin 选择提醒////////
        //选择邮件
  if (checkName=="selemail") {
     if (document.all("selemail").checked){
       document.all("selemail").value='1';
     }else{
       document.all("selemail").value='0';
     }
  }
//选择消息
  if (checkName=="selsms"){
    if (document.all("selsms").checked) {
       document.all("selsms").value='1';
    }else{
       document.all("selsms").value='0';
    }
  }
//选择否弹出式
  if (checkName=="selpopup") {
     if (document.all("selpopup").checked){
       document.all("selpopup").value='1';
     }else{
       document.all("selpopup").value='0';    
     } 
  }
//选择rtx
  if (checkName=="selrtx"){
    if (document.all("selrtx").checked) {
       document.all("selrtx").value='1';
    }else{
       document.all("selrtx").value='0';   
    }
  }
    
   //////end 选择提醒//////////
  
}
//提醒类型
function changeType(){
	//var remindType = document.all("remindtype").value;
	//alert(remindType);
	var remindObj=document.getElementById("remindtype");
	//强制提醒
	var mailObj=document.getElementById("ismail");
	var imsObj=document.getElementById("isims");
	var rtxObj=document.getElementById("istrtx");
	var ispopup = document.getElementById("isrpopup");
	mailObj.style.display ='none';
    imsObj.style.display ='none';
    rtxObj.style.display='none';
    ispopup.style.display='none';
    //选择提醒
    var sel_mailObj=document.getElementById("selmail");
	var sel_imsObj=document.getElementById("selims");
	var sel_rtxObj=document.getElementById("selrtx");
	var sel_ispopup = document.getElementById("selpopup");
	sel_mailObj.style.display ='none';
    sel_imsObj.style.display ='none';
    sel_rtxObj.style.display='none';
    sel_ispopup.style.display='none';
	if (remindObj.value=='4028819d0e521bf9010e5238bec2000e'){//强制提醒
    	mailObj.style.display ='';
    	imsObj.style.display ='';
    	rtxObj.style.display='';
    	ispopup.style.display='';
    	document.all("selemail").checked = false;
    	document.all("selsms").checked = false;
    	document.all("selrtx").checked = false;
        document.all("selpopup").checked = false;
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000d'){// 选择提醒
  	    sel_mailObj.style.display ='';
    	sel_imsObj.style.display ='';
    	sel_rtxObj.style.display='';
    	sel_ispopup.style.display='';
    	document.all("isemail").checked = false;
    	document.all("issms").checked = false;
    	document.all("isrtx").checked = false;
        document.all("ispopup").checked = false;
  	}else if(remindObj.value=='4028819d0e521bf9010e5238bec2000c'){//不提醒
  	    document.all("selemail").checked = false;
    	document.all("selsms").checked = false;
    	document.all("selrtx").checked = false;
        document.all("selpopup").checked = false;
        document.all("isemail").checked = false;
    	document.all("issms").checked = false;
    	document.all("isrtx").checked = false;
        document.all("ispopup").checked = false;
  	}
  	 onCheck('isemail');
	 onCheck('issms');
	 onCheck('ispopup');
	 onCheck('isrtx');
	 onCheck('selemail');
	 onCheck('selsms');
	 onCheck('selpopup');
	 onCheck('selrtx');
}
function cycleChange(){
     var triggerdatetr = document.getElementById("triggerdatetr");
     var triggerdatetr2 = document.getElementById("triggerdatetr2");
     var triggerdate2select = document.getElementById("triggerdate2");

  if (document.all("triggercycle").value=='1'){
     triggerdatetr.style.display ='none';
     triggerdatetr2.style.display ='none';
     triggerdate2select.style.display='none';
  }
  if (document.all("triggercycle").value=='2'){
    triggerdatetr2.style.display ='';
    triggerdate2select.style.display='';
    triggerdatetr.style.display='none'
    addSelect(7);
  }
  if (document.all("triggercycle").value=='3'){
    triggerdatetr2.style.display ='';
    triggerdate2select.style.display='';
    triggerdatetr.style.display='none'
    addSelect(31);
  }  
  if (document.all("triggercycle").value=='4'){
    triggerdatetr2.style.display ='none';
    triggerdate2select.style.display='none';
    triggerdatetr.style.display='';
  } 
}

function addSelect(num){
 	var destList  = document.all("triggerdate2");
	var len = destList.options.length;
	if  (len>0){
	 for(var i = (len-1); i >= 0; i--) {
	  if ((destList.options[i] != null)) {
	    destList.options[i] = null;
	   }
  	 } 
  	}
  for (var j=1;j<=num;j++){
    var oOption = document.createElement("OPTION");
 	destList.options.add(oOption);
	oOption.value = j;
	oOption.innerText = j;  
 }
}
onCheck("iscreateDoc");	//验证是否附件生成文档
function onSubmit(){
   	checkfields="objname,formid,deftitle";
   	// 如果选择默认目录时 必填此项
   	if(document.getElementById("iscreateDoc").value=="1" && false){  //添加faslse 使defaultDocDir 不必填
   	    checkfields = checkfields+",defaultDocDir";
   	}
   	checkmessage="<%=labelService.getLabelName("402881e40aae0af9010aaeb4b38d0002")%>";
   	if(checkForm(EweaverForm,checkfields,checkmessage)){
   		document.EweaverForm.submit();
   	}
}

function addFormField(){
  if (document.all("formid").value!=null) {
    getformfield(document.all("formid").value) ; 
    }
  changeDocType();  // 加载 文档字段相关 字段
}

    function getformfield(formid){
       	DataService.getValues(createList,"select distinct id,labelname from formfield where (formid='"+formid+"' or formid in (select pid from formlink where oid='"+formid+"'  and typeid=1 ))  and isdelete<1");
    }
    
    
    function createList(data)
	{ 
	    DWRUtil.removeAllOptions("approveobj");
	    DWRUtil.addOptions("approveobj", data,"id","labelname");
	    DWRUtil.removeAllOptions("approveobjtype");
	    DWRUtil.addOptions("approveobjtype", data,"id","labelname");
	}
</script>
  <script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
	</body>
</html>
