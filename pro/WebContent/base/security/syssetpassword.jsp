<%@ page contentType="text/html; charset=UTF-8"%>
<%
  response.setHeader("cache-control", "no-cache");
  response.setHeader("pragma", "no-cache");
  response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");    
  %>
<html>
    <link rel="stylesheet" type="text/css" href="/css/global.css">
    <link rel="stylesheet" type="text/css" href="/js/ext/resources/css/ext-all.css" />
    <link rel="stylesheet" type="text/css" href="/css/eweaver-default.css">
    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
        var style='olive';
    </script>
    <script type="text/javascript" language="javascript" src="/js/ext/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" language="javascript" src="/js/ext/ext-all.js"></script>
	<script type='text/javascript' language="javascript" src='/js/main.js'></script>
	<script type="text/javascript" language="javascript" src="/fck/FCKEditorExt.js"></script>
	<script type="text/javascript" language="javascript" src="/fck/fckeditor.js"></script>
	<script type="text/javascript" language="javascript" src="/js/weaverUtil.js?v=1504"></script>
	<script type="text/javascript" language="javascript" src="/app/js/pubUtil.js"></script>
<script src='/dwr/interface/DataService.js'></script>
<script src='/dwr/interface/WorkflowService.js'></script>
<script src='/dwr/interface/WordModuleService.js'></script>
<script src='/dwr/interface/RequestlogService.js'></script>
<script src='/dwr/engine.js'></script>
<script src='/dwr/util.js'></script>
<script language="JScript.Encode" src="/js/browinfo.js"></script>
<script  type='text/javascript' src='/js/workflow.js'></script>
<script type="text/javascript" src="/js/ext/examples/grid/RowExpander.js"></script>
<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="/js/chooser/chooser.js"></script>
<script language="JavaScript" src="/chart/fusionchart/FusionCharts.js"></script>
<link rel="stylesheet" type="text/css" href="/js/chooser/chooser.css"/>
<script type="text/javascript" src="/js/ext/ux/ajax.js"></script>
<script type="text/javascript" src="/js/jquery-latest.pack.js"></script>
<script type='text/javascript' src='/js/tx/jquery.autocomplete.pack.js'></script>
<script type="text/javascript" src="/js/aop.pack.js"></script>
<link rel="stylesheet" type="text/css" href="/js/tx/jquery.autocomplete.css" />
<script type="text/javascript" src="/js/table.js"></script>
<style>
	.x-panel-btns-ct {
	  padding: 0px;
	}
	.x-panel-btns-ct table {width:0}
	#pagemenubar table {width:0}
	.x-toolbar table {width:0}
	.x-grid3-row-body{white-space:normal;}
	.x-layout-collapsed{
	z-index:20;
	border-bottom:#98c0f4 0px solid  ;
	position:absolute;
	border-left:#98c0f4 0px solid;
	overflow:hidden;
	border-top:#98c0f4 0px solid;
	border-right:#98c0f4 0px solid
}
</style>
    <script type="text/javascript">
        var iconBase = '/images';
        var fckBasePath= '/fck/';
        var contextPath='';
function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
        if(document.getElementById(inputname.replace("field","input"))!=null)
		document.getElementById(inputname.replace("field","input")).value="";
		var fck=param.indexOf("function:");
		if(fck>-1){}else{
			var param = parserRefParam(inputname,param);
		}
		var idsin = document.getElementsByName(inputname)[0].value;
        var url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
        }
		var id;
    if(Ext.isIE){
    try{

   // id=openDialog(url,idsin);
    id=window.showModalDialog('/base/popupmain.jsp?url=/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param,idsin,'dialogHeight:500px;dialogWidth:800px;status:no;center:yes;resizable:yes');
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
                    WeaverUtil.fire(document.all(inputname));
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
			}
			win.render(Ext.getBody());
			var dialog = win.getComponent('dialog');
			dialog.setSrc(url);
			win.show();
		}
    }

 function onSubmit(){
   			document.EweaverForm.submit();
            event.srcElement.disabled = false;
   }
    </script>
  <body>
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"><input type="button" value="提交" id="subbutton" onclick="onSubmit();" />
<font color="red">请选择强制修改密码的用户后提交！</font>
</div>
<!--页面菜单结束-->

 	 <form action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.base.security.servlet.SysuserAction?action=setloginpass" name="EweaverForm" id="EweaverForm"  method="post">
		<table> 
            <colgroup> 
				<col width="20%">
				<col width="80%">
			</colgroup>	
			    <tr><td class=FieldName noWrap colspan="4">
			    <font color="red"><%=request.getAttribute("msg")==null?"&nbsp;":request.getAttribute("msg").toString() %>
			    </font></td></tr>
				<TR>
				<TD class=FieldName noWrap>用户信息(多选)</TD>
				<TD class=FieldValue><button type=button  class=Browser name="button_user" onclick="javascript:getrefobj('field_user','field_userspan','402881eb0bd30911010bd321d8600015','','/humres/base/humresinfo.jsp?id=','0');"></button>
				<input type="hidden" name="field_user" value=""  style='width: 80%'  >
				<span id="field_userspan" name="field_userspan" ></span></TD></TR>
				<TR>
        </table>
     </form>
  </body>
</html>
