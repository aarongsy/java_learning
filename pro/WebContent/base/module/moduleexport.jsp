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
  <head><title>Simple jsp page</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
    <script src='<%= request.getContextPath()%>/dwr/interface/JaxbOptService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>

  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
  <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
   <script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>


      <%
        String rootid="r00t";
        String roottext="模块选择";
        pagemenustr +="addBtn(tb,'导出','E','save',function(){toExport()});";
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      var categoryTree;
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
        var refresstimer;
        var pbar1;
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
         menuTree = new Ext.tree.TreePanel({
                animate:true,
                useArrows :true,
                containerScroll: true,
                autoScroll:true,
                checkModel: 'cascade',
                //lines:true,
                region:'west',
                width:200,
                split:true,
                collapsible: true,
                collapsed : false,
                rootVisible:true,
                root:new Ext.tree.AsyncTreeNode({
                    text: '<%=roottext%>',
                    id:'<%=rootid%>',
                    expanded:true,
                    allowDrag:false,
                    allowDrop:true
                }),
            loader:new Ext.tree.TreeLoader({
                dataUrl: "<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=getmoduleconfig&isonlytree=1",
                baseAttrs: { uiProvider: Ext.ux.TreeCheckNodeUI },
                preloadChildren:false
            }
                    )

        });

         menuTree.on('check',function(n,c){
            if(c){
                document.getElementById("workflowids").value+=n.id+",";
            }else{
                var ids=document.getElementById("workflowids").value;
                var index=ids.indexOf(n.id+",");
                if(index!=-1){
                    document.getElementById("workflowids").value=ids.substring(0,index)+ids.substring(index+n.id.length+1,ids.length);
                }
            }

        })
          //Viewport
        var viewport = new Ext.Viewport({
            layout: 'border',
            items: [{region:'center',autoScroll:true,contentEl:'mydiv',split:true,collapseMode:'mini'},menuTree]
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
<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.workflow.servlet.WorkflowactingAction?action=create" name="EweaverForm" id="EweaverForm" method="post">
	    <input type="hidden" name="workflowids" id="workflowids">
        <table style="border:0">
				<colgroup>
					<col width="1%">
					<col width="20%">
					<col width="79%">
				</colgroup>

            <TR><TD class=Spacing colspan=3></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center">请在左边页面选择需要导出的模块</TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <tr><td colspan=3 align="center">
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                </div>
                </div>
                <br/>
                <a href="javascript:showMyResult()" id="showResult"></a>
        </td></tr>
	    </table>
        </form>
      </div>
  </body>
<script language="javascript">
                                                         
    function showMyResult(){
    document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.base.module.servlet.ModuleAction?action=download";
    document.forms[0].submit();
    }

    function toExport(){
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

       Ext.fly('p1text').update('请等待先前的任务完成').show();
    return;
    }
    if(total==0){
    pbar1.reset(true);

       var progressBarhome=document.getElementById("progressBarhome");
       var progressBar=document.getElementById("progressBar");
    progressBarhome.appendChild(progressBar);
       var bgObj=document.getElementById("bgDiv");
    document.body.removeChild(bgObj);
       var title=document.getElementById("msgTitle");
       document.getElementById("msgDiv").removeChild(title);
       var msgObj=document.getElementById("msgDiv");
    document.body.removeChild(msgObj);

       Ext.fly('p1text').update('没有记录导出').show();
    return;
    }
    Runner.run(pbar1, total, function(){
    pbar1.reset(true);
           Ext.fly('p1text').update('操作完成!<br><br><a href="javascript:void(0)">成功导出模块数: '+total+'</a><br><br>').show();
           var progressBarhome=document.getElementById("progressBarhome");
           var progressBar=document.getElementById("progressBar");
    progressBarhome.appendChild(progressBar);
           var bgObj=document.getElementById("bgDiv");
    document.body.removeChild(bgObj);
           var title=document.getElementById("msgTitle");
           document.getElementById("msgDiv").removeChild(title);
           var msgObj=document.getElementById("msgDiv");
    document.body.removeChild(msgObj);
           document.getElementById("showResult").innerText="查看导出结果";
    });
    }

    function doExportOpt(){
        var workflowids="";

        workflowids = document.all("workflowids").value;

    DWREngine.setAsync(false);
    JaxbOptService.moduleExport(workflowids,returnTotal);
    DWREngine.setAsync(true);
    }
    function returnTotal(o){
    total=o;
    }
    function returnCurrentCount(o){
    currentCount=o
    }
    function doRefresh(){
    JaxbOptService.getOutPutCurrentCount(returnCurrentCount);
    }

    function getrefobj(inputname,inputspan,refid,param,viewurl,isneed){
    var idsin = document.all(inputname).value;
           var url='<%=request.getContextPath()%>/base/popupmain.jsp?url=/oa/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param+'&idsin='+idsin;
        if(idsin.length>900){   //当idsin过长时，ie的url不支持过长的地址
           url='<%=request.getContextPath()%>/base/popupmain.jsp?url=/oa/base/refobj/baseobjbrowser.jsp?id='+refid+'&'+param;
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
            msgh=68;//提示窗口的高度
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
//            var progressBarhome=document.getElementById("progressBarhome");
//            var progressBar=document.getElementById("progressBar");
//            progressBarhome.appendChild(progressBar);
//            document.body.removeChild(bgObj);
//            document.getElementById("msgDiv").removeChild(title);
//            document.body.removeChild(msgObj);
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var progressBar=document.getElementById("progressBar");
          progressBar.style.display="block";
	      document.getElementById("msgDiv").appendChild(progressBar);
          doExportOpt();
      }
//*********************************模式对话框特效(end)*********************************//
</script>
</html>
