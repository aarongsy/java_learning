<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="com.eweaver.workflow.form.model.Formlayout" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService" %>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.notify.service.NotifyDefineService" %>
<%@ page import="com.eweaver.workflow.report.model.Reportdef" %>
<%@ page import="com.eweaver.workflow.report.service.ReportdefService" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ include file="/base/init.jsp"%>
<%
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName("402881eb0bcbfd19010bcc6e71870022")+"','S','accept',function(){onSubmit()});";
    pagemenustr += "addBtn(tb,'"+labelService.getLabelName(labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc6f1e6e0023"))+"','C','cancel',function(){onCancel()});";//取消
    SetitemService setitemService = (SetitemService)BaseContext.getBean("setitemService");
    Setitem setitem70 = setitemService.getSetitem("402883053c2242e0013c2242e6f3025d");	//是否允许转发时邮件提醒
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
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
      <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
      <script type="text/javascript">
          var dialogValue;          
             Ext.onReady(function() {
       Ext.QuickTips.init();
   <%if(!pagemenustr.equals("")){%>
       var tb = new Ext.Toolbar();
       tb.render('pagemenubar');
   <%=pagemenustr%>
   <%}%>
             });
      </script>
      <script type='text/javascript' language="javascript" src='/dwr/interface/DataService.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/engine.js'></script>
<script type='text/javascript' language="javascript" src='/dwr/util.js'></script>
<script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" language="javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
<script type='text/javascript' language="javascript" src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type='text/javascript' language="javascript" src='/js/workflow.js'></script>
<script type='text/javascript' language="javascript" src='/js/document.js'></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery/1.6.2/jq.eweaver.js"  charset="utf-8"/></script>
<LINK media=screen href="/js/src/widget/templates/HtmlTabSet.css" type="text/css">
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/plugins/uploadify/jquery.uploadify-3.1.min.js"></script>
  </head>
  <body>
<div id="pagemenubar" style="z-index:100;"></div>
<input type="hidden" id="fileuploadCheck" name="fileuploadCheck" value="0"/>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.CardBinationAction?action=create" name="EweaverForm" method="post">

	<input type="hidden" id="docstatus" name="docstatus" value="">
	<input type="hidden" value="" id="attachid" name="attachid">
	<input type="hidden" value="" id="delattachid" name="delattachid">
	<input type="hidden" value="<%=StringHelper.null2String(setitem70.getItemvalue(),"0") %>" id="isforwordEmailhid" name="isforwordEmailhid">
    <table width="100%">
        
        <tr>
            <td valign=top>
                <table >
                    <colgroup>
                        <col width="20%">
                        <col width="80%">
                    </colgroup>
                    <tr class=Title>

                        <th colspan=2 nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280026") %><!-- 流程转发 --></th>
                        <th/>
                    </tr>
                    <tr>
                        <td class="Line" colspan=2 nowrap>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldName" nowrap>
                            <%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280027") %><!-- 转发接收人 -->
                        </td>
                        <td class="FieldValue">
                            <button  type="button" class=Browser
                                    onclick="javascript:getBrowser('/humres/base/humresbrowserm.jsp?sqlwhere=hrstatus not in(\'4028804c16acfbc00116ccba13802936\',\'402881ea0b1c751a010b1cd0a73e0004\',\'4028804c16acfbc00116ccba13802937\')','humresid','humresidspan','1');"></button>
                            <input type="hidden" name="humresid" id="humresid" value=""/>
                            <span id="humresidspan"><img src=/images/base/checkinput.gif></span>
                        </td>
                    </tr>
                    <tr>
                    	<td class="FieldName" nowrap>
                    		<%=labelService.getLabelNameByKeyId("402883153fcd6300013fcd63014e01ae")%><!-- 相关文档 -->
                    	</td>
                    	<td class="FieldValue">
                    		<button  type="button" class=Browser 
                    				 onclick="javascript:getBrowser('/document/base/docbasebrowserm.jsp','refdocbaseid','refdocbaseidspan','0');"></button>
                    		<input type="hidden" name="refdocbaseid" id="refdocbaseid" value=""/>
                    		<span id="refdocbaseidspan"></span>
                    	</td>
                    </tr>
                    <tr>
                    	<td class="FieldName" nowrap>
                    		<%=labelService.getLabelNameByKeyId("402883153fcd6300013fcd63014e01b0")%><!-- 相关流程 -->
                    	</td>
                    	<td class="FieldValue">
                    		<button  type="button" class=Browser 
                    				 onclick="javascript:getBrowser('/workflow/request/workflowbrowserm.jsp','refworkflowid','refworkflowidspan','0');"></button>
						    <input type="hidden" id="refworkflowid"  name="refworkflowid"  value=""/>
						    <span id="refworkflowidspan"></span>	
                    	</td>
                    </tr>
          <!----EWV2012010600 添加附件字段  mengzhe.sun ----->  
           <TR>
			<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%></TD><!-- 附件 -->
			<TD class=FieldValue colspan="5">
				<!-- 
				<div id="fileUploadDIV" ></div>
				<iframe width="100%" height="20" name="uploadIframe" id="uploadIframe" frameborder=0 scrolling=auto src="/base/fileupload.jsp"></iframe>
				 -->
				<a href="#" class="addfile">
					<input type="file" class="addfile" name="addattachid" id="addattachid">
				</a>
				<div id="filelist_addattachid" style="padding: 3px 0px;">
				</div>
				<script type="text/javascript">
					var multi_selector = new MultiSelector( document.getElementById('filelist_addattachid'), 100,-1);
					multi_selector.addElement(document.getElementById('addattachid'));
				</script>
			</TD>
		</TR>
                   	<tr><!--  流转意见 -->
					<td class="FieldName" nowrap>
                         <%=labelService.getLabelName("签字意见")%>(<input type=checkbox onclick="changeremarktype(this)"><%=labelService.getLabelName("超文本")%>)
					</td>
					<td class="FieldValue">
						<textarea class="InputStyle2" style="width:100%; height:165px;display:none" name="remark" id="remark">&nbsp;</textarea>
						<script>
							WeaverUtil.load(function(){
								CKEditorExt.initEditor_Form('remark', {
									config : {width : '100%', height : '165px'}, 
									instanceReadyFun : function(e){
										CKEditorExt.switchTextMode("remark");
									}
								});
							});
						</script>
						<div><!-- #attachList -->
                      </div>
					</td>
				</tr>
				<%
				if("1".equals(StringHelper.null2String(setitem70.getItemvalue()))){
					%>
				<TR>
				<TD class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883053c17d623013c17d625f70202")%></TD><!--是否允许转发时邮件提醒 -->
					<TD class=FieldValue colspan="1">
						<input type="checkbox" name = "isforwordEmail" id="isforwordEmail" checked="checked"  value="1" onClick="javascript:onCheck('isforwordEmailhid');" />
					</TD>
				</TR>
					<%
				}
				 %>
                </table>


                <br>

            </td>
        </tr>
    </table>
</form>
<script type="text/javascript">
    var humresname;
    var win;
     function getBrowser(viewurl,inputname,inputspan,isneed){
    var id;
    if(!Ext.isSafari){
    try{
    id=openDialog('/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.getElementById(inputname).value = id[0];
		document.getElementById(inputspan).innerHTML = id[1];
        if('humresidspan' == inputspan) humresname=id[1];
    }else{
		document.getElementById(inputname).value = '';
		if (isneed=='0')
		document.getElementById(inputspan).innerHTML = '';
		else
		document.getElementById(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
            }
         }
    }else{
    	//----
	    var callback = function() {
	            try {
	                id = dialog.getFrameWindow().dialogValue;
	            } catch(e) {
	            }
	            if (id!=null) {
	            	if (id[0] != '0') {
	            		document.getElementById(inputname).value = id[0];
	            		document.getElementById(inputspan).innerHTML = id[1];
	                    humresname=id[1];
	                }else{
	            		document.getElementById(inputname).value = '';
	            		if (isneed=='0')
	            		document.getElementById(inputspan).innerHTML = '';
	            		else
	            		document.getElementById(inputspan).innerHTML = '<img src=/images/base/checkinput.gif>';
	                 }
	            }
	        }
	        if (!win) {
	             win = new Ext.Window({
	                layout:'border',
	                width:jQuery(document).width()*0.95,
	                height:jQuery(document).height()*0.95,
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
 //  初始化时给多行文本框赋初值 
      function changeremarktype(obj){
        if(obj.checked){
            document.getElementById("remark_mappingText").innerHTML="&nbsp;";
            CKEditorExt.switchEditMode('remark');
           	var targetEditor = CKEditorExt.getEditor("remark");
			targetEditor.focus();
			var editorEleObj = document.getElementById("cke_remark");
	    	var iframeObj=jQuery(editorEleObj).find("iframe")[0];
	    	iframeObj.onload=function(){
	    		var ckDoc=null;
		    	if(iframeObj.contentDocument){
		    		ckDoc= iframeObj.contentDocument;
		    	}else if(iframeObj.document){
		    		ckDoc= iframeObj.document;
		    	}
	    		var ckHtmlEle = ckDoc.body.parentNode;
				jQuery(ckDoc).bind("click", function(){
					var targetEditor = CKEditorExt.getEditor("remark");
					targetEditor.focus();
				});
	    	}
        }else{
             document.getElementById("remark_mappingText").innerHTML="&nbsp;";
             CKEditorExt.switchTextMode('remark');
             document.getElementById("remark_mappingText").innerHTML="&nbsp;";
        }
     }
     
	 function isFireFox2()
     {
       var i2=navigator.userAgent.toLowerCase().indexOf("firefox");
       return i2>=0;
	 }  
     function onSubmit(){
        var humresid=document.getElementById('humresid').value;
        var isforwordEmail=document.getElementById('isforwordEmailhid').value;
        var attachid = jQuery("input[type='hidden'][name='addattachid']").val();//获取附件id
        var refdocbaseid = document.getElementById('refdocbaseid').value;
        var refworkflowid = document.getElementById('refworkflowid').value;
        if(humresid==''){
             Ext.MessageBox.alert('', '<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf280028") %>');//转发接收人不能为空！
             return;
        }
        var remark=encode(CKEditorExt.getHtml("remark"));
        
        if(!Ext.isSafari){
     		getArray(humresid,humresname,remark,attachid,isforwordEmail,refdocbaseid,refworkflowid);
        }else{
     		dialogValue=[humresid,humresname,remark,attachid,isforwordEmail,refdocbaseid,refworkflowid];
       		parent.win.close();
       	}    
     }
     function getArray(humresid,humresname,remark,attachid,isforwordEmail,refdocbaseid,refworkflowid){
        window.parent.returnValue = [humresid,humresname,remark,attachid,isforwordEmail,refdocbaseid,refworkflowid];
        window.parent.close();
    }
     
    function onCancel(){
    	if(!Ext.isSafari){
	       this.close();    
        }else{
        	parent.win.close();
        }
    }
    function onCheck(checkName){ 
    	//是否允许转发时邮件提醒
		  if (checkName =="isforwordEmailhid") {
			  if (document.getElementById("isforwordEmailhid").checked){
				 document.getElementById("isforwordEmailhid").value='1';
		      }else{
				 document.getElementById("isforwordEmailhid").value='0';    
			  } 
		  }
    }
</script>
  </body>
</html>
