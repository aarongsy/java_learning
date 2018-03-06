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
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.workflow.form.dao.ForminfoDao" %>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutfieldService" %>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService" %>
<%@ page import="com.eweaver.workflow.form.model.Formlayoutfield" %>
<%@ include file="/base/init.jsp"%>


<html>
  <head><title>Simple jsp page</title>
  <style type="text/css">
      .x-panel-btns-ct {
          padding: 0px;
      }
  </style>
    <script src='<%= request.getContextPath()%>/dwr/interface/HumresExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/interface/UsersWorkflowExcelService.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
    <script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TreeCheckNodeUI.js" ></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/TabCloseMenu.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/notification.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/MessageBus.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/popup.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/DDTabPanel.js"></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/ux/css/DDTabPanel.css" />
      <%
        pagemenustr +="addBtn(tb,'导入','I','accept',function(){importRecords()});";


        String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
        String categoryid = StringHelper.null2String(request.getParameter("categoryid"));
        String requestid = StringHelper.null2String(request.getParameter("requestid"));

        String layoutid = StringHelper.null2String(request.getParameter("layoutid"));
      %>

      <script type="text/javascript">
      Ext.SSL_SECURE_URL='about:blank';
      var contentPanel;
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


        contentPanel =new Ext.ux.panel.DDTabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            plugins: new Ext.ux.TabCloseMenu(),
            activeTab:0,
            items:[{
                title: "Portal",
                iconCls:'portalIcon',
                xtype     :'iframepanel',
                frameConfig: {
                    autoCreate:{ id:'portalframe', name:'portalframe', frameborder:0 },
                    eventsFollowFrameLinks : false
                },
                defaultSrc:'<%=request.getContextPath()%>/portal.jsp',
                closable:false,
                autoScroll:true,
                listeners:{'activate':function(p){
                  if(p.getFrameWindow().Light) {
                      try {
                          portalobj = p.getFrameWindow().Light;
                          var tabId = portalobj.portal.GetFocusedTabId();
                          if (typeof(tabId) == 'undefined') return;
                          var index = tabId.substring(8, tabId.length);//tab id perfix tab_page
                          portalobj.portal.tabs[index].rePositionAll();
                      } catch(e) {p.getFrameWindow().location='<%=request.getContextPath()%>/portal.jsp';
                      }
                  }
                }}
            }]
        });

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
                  if(isfinish=="1"){
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
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330033") %><!-- 请选择需要导入的从表 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center">
            <select id="form" name="form">
                <%
                    CategoryService categoryService = (CategoryService)BaseContext.getBean("categoryService");
                    WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
                    ForminfoDao forminfoDao = (ForminfoDao)BaseContext.getBean("forminfoDao");
                    BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");

                    Forminfo forminfo = new Forminfo();
                    if(workflowid!=null&&!workflowid.equals("")){
                        Workflowinfo workflowinfo = workflowinfoService.get(workflowid);
                        forminfo=forminfoDao.getForminfoById(workflowinfo.getFormid());
                    }else if(categoryid!=null&&!categoryid.equals("")){
                        Category category = categoryService.getCategoryById(categoryid);
                        while ((category.getFormid()==null||"".equals(category.getFormid()))&&category.getPid()!=null){
                            category = categoryService.getCategoryById(category.getPid());
                        }
                        forminfo=forminfoDao.getForminfoById(category.getFormid());
                    }

                    FormlayoutfieldService formlayoutfieldService=(FormlayoutfieldService)BaseContext.getBean("formlayoutfieldService");
                    FormfieldService formfieldService=(FormfieldService)BaseContext.getBean("formfieldService");
                    List<Formlayoutfield> formlayoutfieldlist = formlayoutfieldService.getFormlayoutField(layoutid);
                    Set layoutformlist=new HashSet();
                    String fieldid;
                    for(Formlayoutfield flf:formlayoutfieldlist){
                        fieldid= StringHelper.null2String(flf.getFieldname()) ;
                        if(StringHelper.isID(fieldid))
                        layoutformlist.add(formfieldService.getFormfieldById(fieldid).getFormid());
                    }

                    Iterator itObj=layoutformlist.iterator();
                    while(itObj.hasNext()){
                        String value= StringHelper.null2String(itObj.next());
                        Forminfo form = forminfoDao.getForminfoById(value);
                        if(StringHelper.null2String(forminfo.getObjtablename()).equals(form.getObjtablename())){
                            continue;
                        }

                %>
                <option value="<%=form.getId()%>"><%=form.getObjname()%></option>
                <%
                    }
                %>
            </select>
            <TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002d") %><!-- 请选择需要导入的excel文档 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
            <TR><TD colspan=3 align="center"><input type="file" name="path" /></TD><TR>
            <tr><td colspan=3 align="center">
                <br/>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                <div id="importMessage" style="display:none;">
                    <a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002e") %><!-- 导入的记录总数 -->：</a>&nbsp;&nbsp;<a href="javascript:void(0)" id="totalnum">0</a><br/>
                    <a id="curra" href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002f") %><!-- 当前正导入第 --> <span id="curnum">0
                    </span> <%=labelService.getLabelNameByKeyId("402883d934c0fe860134c0fe868d0000") %><!-- 条记录 --></a><span id="finishmessage" style="display:none"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %><!-- 操作完成! --></span><br/>
                    <a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0030") %><!-- 成功记录数 -->: <span id="succesNum">0</span></a>&nbsp;&nbsp;<a id="succesRecord" href="javascript:downloadLostRecord()"></a><br/>
                    <a href="javascript:void(0)"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0031") %><!-- 失败记录数 -->: <span id="lostNum">0</span></a>&nbsp;&nbsp;<a id="lostRecord" href="javascript:downloadLostRecord()"></a>
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
            <TR><TD><span id="message" name="message" style="font-size:12"></span></TD></TR>
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
           document.getElementById("curra").style.display="block";
           document.getElementById("finishmessage").style.display="none";
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
       document.getElementById("importMessage").style.display="none";
       Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0032") %>').show();//没有记录导入
    return;
    }
    Runner.run(pbar1, total, function(){
    pbar1.reset(true);
//           Ext.fly('p1text').update('操作完成!\n导入的记录总数: '+total+',失败数: '+lostnum+'.').show();
//           var progressBarhome=document.getElementById("progressBarhome");
//           var progressBar=document.getElementById("progressBar");
//    progressBarhome.appendChild(progressBar);
//           var bgObj=document.getElementById("bgDiv");
//    document.body.removeChild(bgObj);
//           var title=document.getElementById("msgTitle");
//           document.getElementById("msgDiv").removeChild(title);
//           var msgObj=document.getElementById("msgDiv");
//    document.body.removeChild(msgObj);
            document.getElementById("lostRecord").innerText = "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0033") %>";//点击查看
            document.getElementById("succesRecord").innerText = "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0033") %>";//点击查看
            document.getElementById("finishmessage").innerText ="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %>";//操作完成!
    });
    }
    }
    function doImportOpt(){
    DWREngine.setAsync(false);
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.inputExcelDetail('<%=requestid%>',path,document.getElementById("form").value,returnTotal);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.inputExcelDetail('<%=requestid%>',path,document.getElementById("form").value,returnTotal);
        <%
            }
        %>
    DWREngine.setAsync(true);
    }

    function returnTotal(o){
        total=o;
        document.getElementById("totalNum").innerText=total;
    }
    function returnCurrentCount(o){
        var obj=eval('(' + o + ')'); ;

        var succesNum=obj.succesNum;
        lostnum=parseInt(obj.lostNum);

        var curNum = parseInt(succesNum)+lostnum
        document.getElementById("curnum").innerText=curNum;

        document.getElementById("succesNum").innerText=parseInt(succesNum);
        document.getElementById("lostNum").innerText=lostnum;

        currentCount=curNum;
        isfinish = obj.isfinish;
        if(curNum==total){
           document.getElementById("curra").style.display="none";
           document.getElementById("finishmessage").style.display="block";
           if(isfinish!="1"){
               document.getElementById("finishmessage").innerText ="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0034") %>";//数据导入操作已完成,正在生成错误信息文件,请稍候...
           }
        }
    }
    function doRefresh(){
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }else{
        %>
        HumresExcelService.getInPutCurrentCount(returnCurrentCount);
        <%
            }
        %>
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
          title.innerHTML="<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0035") %>";//刷新表单
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

        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
//              alert(contentPanel);
//            contentPanel.getActiveTab().getFrameWindow().location.reload(true);
              top.frames[1].doRefresh();
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
//              contentPanel.getActiveTab().getFrameWindow().location.reload(true);
//			var tabpanel=top.frames[1].contentPanel;
            <%--tabpanel.remove(tabpanel.getActiveTab());--%>
<%--              tabpanel.add();--%>
        <%--top.frames[1].contentPanel.getActiveTab().location="<%=request.getContextPath()%>/workflow/request/formbase.jsp?editmode=1&categoryid=<%=categoryid%>&requestid=<%=requestid%>";--%>
        <%
            }
        %>
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
