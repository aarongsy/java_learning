<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="com.eweaver.base.setitem.model.Setitemtype" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eweaver.base.setitem.model.Setitem" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.base.setitem.service.SetitemtypeService" %>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService" %>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem" %>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService" %>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo" %>
<%@ include file="/base/init.jsp"%>


<html>
  <head><title><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140033") %><!-- usbkey信息导入 --></title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
      #pagemenubar table {width:0}
       .x-toolbar table {width:0}
    .x-grid3-row-body{white-space:normal;}
  </style>
    <script src='<%= request.getContextPath()%>/dwr/interface/UserKeyService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>


      <%
          pagemenustr +="addBtn(tb,'导入','I','accept',function(){importRecords()});";
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.override(Ext.tree.TreeLoader, {
        createNode : function(attr){
            // apply baseAttrs, nice idea Corey!
            if(this.baseAttrs){
                Ext.applyIf(attr, this.baseAttrs);
            }
            if(this.applyLoader !== false){
                attr.loader = this;
            }
            if(typeof attr.uiProvider == 'string'){
               attr.uiProvider = this.uiProviders[attr.uiProvider] || eval(attr.uiProvider);
            }

            var n = (attr.leaf ?
                            new Ext.tree.TreeNode(attr) :
                            new Ext.tree.AsyncTreeNode(attr));

        if (attr.expanded) {
                n.expanded = true;
            }

            return n;
        }
    });
        var outBtn;
        var total=0;
        var currentCount=0;
        var lostnum=0;
        var refresstimer;
        var pbar1;
        var isfinish = "0";
      Ext.onReady(function(){
            //==== Progress bar1  ====
            pbar1 = new Ext.ProgressBar({
               text:'0%'
            });

           <%if(!pagemenustr.equals("")){%>
              var tb = new Ext.Toolbar();
              tb.render('pagemenubar');
          <%=pagemenustr%>
          <%}%>

          //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'north',autoScroll:true,contentEl:'mydiv',split:true,collapseMode:'mini'},{region:'center',autoScroll:true,contentEl:'messagePage',split:true,collapseMode:'mini'}]
        });

      })
      var Runner = function(){
          var f = function(pbar,count, cb){

              return function(){
                  doRefresh();
                  if(currentCount >= count){
                      clearInterval(refresstimer);
                      cb();
                  }else{
                          var i = currentCount/count;
                          pbar.updateProgress(i, Math.round(100*i)+'%');
                  }
             };
          };
          return {
              run : function(pbar, count, cb){
                  var ms = 5000/count;
                    try{
                    refresstimer=setInterval(f(pbar, count, cb),2);
                    }catch(e){}
              }
          }
      }();

      </script>
  <script>Ext.BLANK_IMAGE_URL = '<%=request.getContextPath()%>/js/ext/resources/images/default/s.gif';</script>
  </head>
  <body>
  <div id="mydiv">
<!--页面菜单开始-->
<div id="pagemenubar" style="z-index:100;"></div>
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=create" name="EweaverForm" id="EweaverForm" method="post" target="upload_faceico" enctype="multipart/form-data">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140034") %><!-- 请在下面选择需要导入的userkey信息文件 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center"><input type="file" name="path" />
            &nbsp;&nbsp;
            <a id="aHTActX" href='<%=request.getContextPath()%>/plugin/HTActxFormat.exe'><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67140035") %><!-- 初始化工具下载 --></a>
            </TD><TR>
            <tr><td colspan=3 align="center">
                <br/>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                <div id="importMessage" style="display:none;">
                    <a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67150036") %><!-- 此次导入的userkey信息数 -->：</a>&nbsp;&nbsp;<a href="javascript:void(0)" id="totalnum">0</a><br/>
                    <a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("4028834035424d660135424d67150037") %><!-- 当前正在处理第 --> <span id="curnum">0
                    </span> <%=labelService.getLabelNameByKeyId("4028834035424d660135424d67150038") %><!-- 个userkey信息 --></a>
                </div>
                </div>
                </div>
                <br/>
        </td></tr>
	    </table>
        </form>
      <iframe id="upload_faceico" name="upload_faceico" src="<%=request.getContextPath()%>/base/module/upload_faceico.jsp" width="0" height="0" style="top:-100px;">
      </iframe>
      </div>
    <div id="messagePage">
        <table style="border:0">
            <TR><TD align="center"><span id="message" name="message" style="font-size:12"></span></TD></TR>
            </table>
      </div>
  </body>
<script language="javascript">
      var path="";

      function downloadLostRecord(){
          document.location.href="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download&path="+path;
      }
    function importRecords(){
            isfinish="0";
        if(document.forms[0].path.value==""||document.forms[0].path.value==null){
            alert("<%=labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec7190072") %>");//你还没有选择需要导入的excel文档
    return;
    }
        frames["upload_faceico"].document.getElementById("pathtext").value="";
        document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=xmlupload";
    document.forms[0].submit();

    getPath();
    }
    function getPath(){
       path = frames["upload_faceico"].document.getElementById("pathtext").value;

       if(path==""||path==null){
           setTimeout("getPath()",1000);
    }else{
    total=0;
    currentCount=0;
       Ext.fly('p1').setDisplayed(true);
       Ext.fly('p1text').update('');
    if (!pbar1.rendered){
           pbar1.render('p1');
    }else{
           pbar1.text = '0%';
    pbar1.show();
    }
    sAlert();
    if(total==-1){
    pbar1.reset(true);

       Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("40288035247afa9601247b1859d30019") %>').show();//请等待先前的任务完成
       document.getElementById("importMessage").style.display="none";
    return;
    }
    if(total==0){
    pbar1.reset(true);

       Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("4028834035424d660135424d67150039") %>').show();//发生错误!导入失败!
       document.getElementById("importMessage").style.display="none";
    return;
    }
    Runner.run(pbar1, total, function(){
    pbar1.reset(true);
        Ext.fly('p1text').update('<span style="color:green"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %></span><br><%=labelService.getLabelNameByKeyId("4028834035424d660135424d6715003a") %>: '+total+',<%=labelService.getLabelNameByKeyId("4028834035424d660135424d6715003b") %>: '+lostnum+'.').show();//操作完成!   处理总数  失败数
//           var progressBarhome=document.getElementById("progressBarhome");
//           var progressBar=document.getElementById("progressBar");
//    progressBarhome.appendChild(progressBar);
//           var bgObj=document.getElementById("bgDiv");
//    document.body.removeChild(bgObj);
//           var title=document.getElementById("msgTitle");
//           document.getElementById("msgDiv").removeChild(title);
//           var msgObj=document.getElementById("msgDiv");
//    document.body.removeChild(msgObj);
           document.getElementById("importMessage").style.display="none";
    });
    }
    }
    function doImportOpt(){
    DWREngine.setAsync(false);
    UserKeyService.inputUserkey(path,returnTotal);
    DWREngine.setAsync(true);
    }

    function returnTotal(o){
        total=o;
        document.getElementById("totalNum").innerText=total;
    }
    function returnCurrentCount(o){
        var obj=eval('(' + o + ')'); ;
        var curNum=obj.curNum;

        document.getElementById("curnum").innerText=parseInt(curNum)+1;
        lostnum=obj.lostNum;
        currentCount=curNum;

        document.getElementById("message").innerHTML = "*******************************userkey导入日志打印如下****************************<br><br>"+obj.message;
    }
    function doRefresh(){
        UserKeyService.getInPutCurrentCount(returnCurrentCount);
    }

    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    var idsin = document.all(inputname).value;
          var url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=/oa/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
            if (idsin.length > 900) {   //当idsin过长时，ie的url不支持过长的地址
                url ='<%=request.getContextPath()%>/base/popupmain.jsp?url=/oa/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
            }
    var id;
    try{
    id=openDialog(url);
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
		document.all(inputspan).innerHTML = '<img src=/oa/images/base/checkinput.gif>';

    }
    }
    }
</script>
<script type="text/javascript">
    //*********************************模式对话框特效(start)*********************************//
            function sAlert(){
            var msgw,msgh,bordercolor;
            msgw=420;//提示窗口的宽度
            msgh=88;//提示窗口的高度
            bordercolor="#336699";//提示窗口的边框颜色

            var sWidth,sHeight;
            sWidth=document.body.offsetWidth;
            sHeight=document.body.offsetHeight;

            var bgObj=document.createElement("div");
            bgObj.setAttribute('id','bgDiv');
            bgObj.style.position="absolute";
            bgObj.style.top="0";
            bgObj.style.background="#777";
            bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";
            bgObj.style.opacity="0.6";
            bgObj.style.left="0";
            bgObj.style.width=sWidth + "px";
            bgObj.style.height=sHeight + "px";
            document.body.appendChild(bgObj);
            var msgObj=document.createElement("div")
            msgObj.setAttribute("id","msgDiv");
            msgObj.setAttribute("align","center");
            msgObj.style.position="absolute";
            msgObj.style.background="white";
            msgObj.style.font="12px/1.6em Verdana, Geneva, Arial, Helvetica, sans-serif";
            msgObj.style.border="1px solid " + bordercolor;
            msgObj.style.width=msgw + "px";
            msgObj.style.height=msgh + "px";
          msgObj.style.top=(document.documentElement.scrollTop + (sHeight-msgh)/2) + "px";
          msgObj.style.left=(sWidth-msgw)/2 + "px";

          var title=document.createElement("h4");
          title.setAttribute("id","msgTitle");
          title.setAttribute("align","right");
          title.style.margin="0";
          title.style.padding="3px";
          title.style.background=bordercolor;
          title.style.filter="progid:DXImageTransform.Microsoft.Alpha(startX=20, startY=20, finishX=100, finishY=100,style=1,opacity=75,finishOpacity=100);";
          title.style.opacity="0.75";
          title.style.border="1px solid " + bordercolor;
          title.style.height="18px";
          title.style.font="12px Verdana, Geneva, Arial, Helvetica, sans-serif";
          title.style.color="white";
          title.style.cursor="pointer";
          title.innerHTML="关闭";
          title.onclick=function(){
               var progressBarhome=document.getElementById("progressBarhome");
               var progressBar=document.getElementById("progressBar");
            progressBarhome.appendChild(progressBar);
               var bgObj=document.getElementById("bgDiv");
            document.body.removeChild(bgObj);
               var title=document.getElementById("msgTitle");
               document.getElementById("msgDiv").removeChild(title);
               var msgObj=document.getElementById("msgDiv");
            document.body.removeChild(msgObj);
               document.getElementById("progressBarhome").style.display="none";
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var progressBar=document.getElementById("progressBar");
          progressBar.style.display="block";
          document.getElementById("importMessage").style.display="block";
	      document.getElementById("msgDiv").appendChild(progressBar);
          doImportOpt();
      }
//*********************************模式对话框特效(end)*********************************//
</script>
</html>
