<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.humres.base.service.HumresService"%>
<%@ page import="com.eweaver.humres.base.model.Humres"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService" %>

<!--页面菜单开始-->
<%
int gridWidth=700;    
PagemenuService _pagemenuService =(PagemenuService)BaseContext.getBean("pagemenuService");

if(pagemenuorder.equals("0")) {
	pagemenustr = _pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService.getPagemenuStrExt(theuri,paravaluehm).get(0);
}

pagemenustr +="addBtn(tb,'"+labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa963f300023")+"','S','accept',function(){toSave()});";//保存
%>
<html>
  <head>
       <style type="text/css">
     #pagemenubar table {width:0}
</style>

    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-latest.pack.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
    <script type="text/javascript" language="javascript" src="/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" language="javascript" src="/ckeditor/CKEditorExt.js"></script>
    <script type="text/javascript">
        var myMask;
        Ext.onReady(function() {
            myMask = new Ext.LoadMask(Ext.getBody(),{msg:'<%=labelService.getLabelNameByKeyId("402883d934d152ce0134d152cf260000")%>'});//请稍候...

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
<br/>

<div id=div align=center>
  <fieldset style="width: 98%"><!-- 模板创建 -->
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.word.servlet.WordModuleAction?action=create"  name="EweaverForm" id="EweaverForm" method="post">
		<input type="hidden" id="attachid" name="attachid"/>
		<table width="100%" class=layouttable>
			<caption><%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980031")%></caption>
			<colgroup>
				<COL width="20%">
				<COL width="80%">
			</colgroup>
			<tbody>
				<tr>
					<td class=FieldName width="8%"><%=labelService.getLabelNameByKeyId("402881b70d19c4c0010d1aca65550015")%></td><!-- 文档格式 -->
					<td class=FieldValue >
						<input type="hidden" name=officeType id="officeType" value="3" />
						<input type="radio" name="docTemplateType" id="html" value="3" onclick="onChangeDocType(3)" checked="checked"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda34a970018")%><!-- HTML文档 -->
						<input type="radio" name="docTemplateType" id="word" value="4" onclick="onChangeDocType(4)"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda450910019")%><!-- WORD文档 -->
						<input type="radio" name="docTemplateType" id="excel" value="5" onclick="onChangeDocType(5)"><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcda4b538001a")%><!-- EXCEL文档 -->
					</td>
				</tr>
				<tr>
					<td class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc16ecb1000b")%></td><!--名称  -->
					<td class=FieldValue>
					    <input type=text style="width:60%" class=inputstyle name="objname"/>
					</td>
				</tr>
				<tr>
					<td class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402883d934c15c570134c15c57f50000")%></td><!-- 描述 -->
					<td class=FieldValue>
					    <input type=text class=inputstyle name="objdesc" style="width:100%"/>
					</td>
				</tr>
				<tr>
					<td class=FieldName noWrap>使用部门</td>
					<td class=FieldValue>
						<button type=button class=Browser name="button_orgids" onclick="javascript:getrefobj('orgids','orgidsspan','40287e8e12066bba0112068b730f0e9c','','','1');"></button>
						<input type="hidden" name="orgids" value=""  style='width: 80%'  ><span id="orgidsspan" name="orgidsspan" ></span>
						<br><span style="color:red">此项为空,表示公用!</span>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="htmlDIV">
			<textarea name="htmlContent" id="htmlContent" style="height: 50px;"></textarea>
		</div>
	</form>
	<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.word.servlet.WordModuleAction?action=upload"  name="UpLoadForm" id="UpLoadForm" target="upload_wordmodule" enctype="multipart/form-data" method="post">
		<table width="100%" class=layouttable style="display: none;">
			<colgroup>
				<col width="20%">
				<col width="80%">
			</colgroup>
			<tbody>
				<tr>
				    <td class=FieldName noWrap><%=labelService.getLabelNameByKeyId("402881eb0bcd354e010bcd9dfe6b0017")%></td><!-- 附件 -->
				    <td class=FieldValue >
				        <input type="file" style="width:60%" name="path" onchange="toUpLoad()"/>&nbsp;&nbsp;
				        <span style="font-size:12" id="myspan"></span>
				    </td>
				</tr>
			</tbody>
		</table>
	 </form>
  </fieldset>
</div>
<iframe id="upload_wordmodule" name="upload_wordmodule" src="upload_wordmodule.jsp" width="0" height="0" style="top:-100px;"></iframe>
<script language="javascript">
    var attachid = "";
    WeaverUtil.load(function() {
		CKEditorExt.whenAllEditorIsReady(function(){
			CKEditorExt.initEditor('htmlContent');
		});
	});
    function onChangeDocType(docTemplateType){
    	if(docTemplateType == 4 || docTemplateType == 5){
    		jQuery("#htmlDIV").hide();
    		jQuery("form[name='UpLoadForm'] > .layouttable").show();
    	}else{
    		jQuery("#htmlDIV").show();
    		jQuery("form[name='UpLoadForm'] > .layouttable").hide();
    	}
    }
    function toUpLoad(){
        myMask.show();
        document.forms[1].submit();
        getAttachid()
    }
    function getAttachid(){
       attachid = frames["upload_wordmodule"].document.getElementById("attachid").value;
       if(attachid==""||attachid==null){
           setTimeout("getAttachid()",1000);
       }else{
           document.getElementById("myspan").innerText="<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980032")%>.";//附件上传成功
           document.getElementById("attachid").value=attachid;
           myMask.hide();
       }
    }
    function toSave(){
        var objname = document.forms[0].objname.value;
        var file = document.forms[1].path.value;
        var attach = document.getElementById("attachid").value;
        if(objname==null||objname==""){
            alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980033")%>");//名称不能为空!
            return;
        }
        var docTemplateType = jQuery("input:radio[name='docTemplateType']:checked").val();
        if(docTemplateType == 4 || docTemplateType == 5){
        	if(file==null||file==""){
	            alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980034")%>");//请选择一个模板附件再保存.
	            return;
        	}
        	if(attach==null||attach==""){
	            alert("<%=labelService.getLabelNameByKeyId("4028831334d4c04c0134d4c04e980035")%>"); // 您所选择的附件未成功上传，请重新选择相关附件.
	            return;
        	}
        }
        document.forms[0].submit();
    }
 </script>
</body>
</html>
<script type="text/javascript">
    var win;
    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
     document.getElementById(inputname.replace("field","input")).value="";
    var fck=param.indexOf("function:");
        if(fck>-1){}else{
            //var param = parserRefParam(inputname,param);
        }
	var idsin = document.getElementsByName(inputname)[0].value;
	var id;
    if(Ext.isIE){
    try{
         var url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
    	id=openDialog(url);
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
				function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=window.showModalDialog('/base/popupmain.jsp?url='+viewurl);
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
       }
</script>

