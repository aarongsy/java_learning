<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-5
  Time: 14:06:07
  To change this template use File | Settings | File Templates.
--%>
<html>
  <head><title>导出Excel</title>

<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/HumresExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersWorkflowExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ext-all.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/ext/ux/miframe.js"></script>
<script type="text/javascript">
<%
    pagemenustr +="addBtn(tb,'导出','E','accept',function(){exportRecords()});";

    String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
    String categoryid = StringHelper.null2String(request.getParameter("categoryid"));

%>
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;
    Ext.onReady(function(){
        var cp = new Ext.state.CookieProvider({
       expires: new Date(new Date().getTime()+(1000*60*60*24*30))
   });

            var tb = new Ext.Toolbar();
            tb.render('pagemenubar');
        <%=pagemenustr%>

     var c = new Ext.Panel({
               title:'导出操作',iconCls:Ext.ux.iconMgr.getIcon('config'),
               layout: 'border',
               items: [{region:'center',autoScroll:true,contentEl:'divSum'}]
           });

     var exceltab=cp.get('exceltab');
     if(exceltab==undefined)
     exceltab=0;

     var contentPanel = new Ext.TabPanel({
            region:'center',
            id:'tabPanel',
            deferredRender:false,
            enableTabScroll:true,
            autoScroll:true,
            activeTab:exceltab,
            items:[c]
        });

     addTab(contentPanel,'<%=request.getContextPath()%>/workflow/form/importrecordbyexcel.jsp?workflowid=<%=workflowid%>&categoryid=<%=categoryid%>','导入操作','page_portrait');
        contentPanel.items.each(function(it,index,length){
         it.on('activate',function(p){
             if(length==8)
             cp.set('exceltab',index+1);
             else
             cp.set('exceltab',index);

        })
     });

      //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [contentPanel]
	});

    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });

});


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

  <style type="text/css">
    .x-toolbar table {width:0}
      a { color:blue; cursor:pointer; }
    #pagemenubar table {width:0}
    /*TD{*/
        /*width:16%;*/
    /*}*/
     .x-panel-btns-ct {
          padding: 0px;
      }
      .x-panel-btns-ct table {width:0}
  </style>
  <script type="text/javascript">
    function exportRecords(){
        document.getElementById("showResult").style.display="none";
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

        Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330034") %>').show();//没有记录导出
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %>').show();//操作完成!
//            var progressBarhome=document.getElementById("progressBarhome");
//            var progressBar=document.getElementById("progressBar");
//            progressBarhome.appendChild(progressBar);
//            var bgObj=document.getElementById("bgDiv");
//            document.body.removeChild(bgObj);
//            var title=document.getElementById("msgTitle");
//            document.getElementById("msgDiv").removeChild(title);
//            var msgObj=document.getElementById("msgDiv");
//            document.body.removeChild(msgObj);
            document.getElementById("showResult").innerText="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330036") %>";//查看导出结果
            document.getElementById("showResult").style.display="block";
            <%--document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download";--%>
            <%--document.forms[0].submit();--%>
        });
    }

    function myshow(data){
        for(var i=1;i<=2;i++){
            if(i==data){
                document.getElementById("Layer"+i).style.display="block";
                document.getElementById("Submit"+i).className="mysubmit2";
            }
            else{
                document.getElementById("Layer"+i).style.display="none";
                document.getElementById("Submit"+i).className="mysubmit";
            }
        }
    }

      function showMyResult(){
            document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download";
            document.forms[0].submit();
      }

      function importExcel(){
          document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=excelUpLoad&sysmodel=sysmodel";
          document.forms[0].submit();
      }

    function doOutPutHumresExcel(){
        requestid=document.all("requestid").value;
        DWREngine.setAsync(false);
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.outputExcel('<%=workflowid%>',requestid,returnTotal);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.outputExcel('<%=categoryid%>',requestid,returnTotal);
        <%
            }else{
        %>
        HumresExcelService.outputExcel(requestid,returnTotal);
        <%
            }
        %>
        DWREngine.setAsync(true);
    }
    function returnTotal(o){
        total=o;
    }
    function returnCurrentCount(o){
        currentCount=o
    }
    function doRefresh(){
        <%
            if(workflowid!=null&&!workflowid.equals("")){
        %>
        UsersWorkflowExcelService.getOutPutCurrentCount(returnCurrentCount);
        <%
            }else if(categoryid!=null&&!categoryid.equals("")){
        %>
        UsersCategoryExcelService.getOutPutCurrentCount(returnCurrentCount);
        <%
            }else{
        %>
        HumresExcelService.getOutPutCurrentCount(returnCurrentCount);
        <%
            }
        %>
    }
      function getBrowser(viewurl,inputname,inputspan,isneed){
          var id;
          try{
          id=openDialog('<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>'+viewurl);
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
              document.all(inputspan).innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

                  }
               }
       }

  </script>
  <%
      ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
      Forminfo forminfo = forminfoService.getForminfoById("402881e80c33c761010c33c8594e0005");
      RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
      List list= refobjService.getAllRefobj();
      Iterator it=list.iterator();
      Refobj refobj = new Refobj();

      while (it.hasNext()){
          Refobj refObj = (Refobj) it.next();
          String ismulti = refObj.getIsmulti()==null?"":refObj.getIsmulti().toString();
          String reftable = refObj.getReftable()==null?"":refObj.getReftable().toString();
          if(ismulti.equals("1")&&reftable.equals(forminfo.getObjtablename())){
              refobj=refObj;
              break;
          }
      }
      String url="";
      if(refobj.getId()!=null){
          url= refobj.getRefurl();
      }
  %>
  </head>
  <body>
<div id="divSum">
 <div id="pagemenubar"></div>
  <%--<form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download" enctype="multipart/form-data" method="post">--%>
  <%--</form>--%>
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
            <TR><TD class=Spacing colspan=3 align="center"><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39340038") %><!-- 请在下面选择需要导出的记录,默认为导出所有相关记录 --></TD><TR>
            <TR><TD class=Line colspan=3></TD><TR>
            <TR><TD colspan=3>&nbsp;</TD><TR>
        <%
             if(url!=""){
        %>
        <tr>
            <td align="center" colspan="3">
            <button class="Browser" type="button" onclick="getBrowser('<%=url%>','requestid','requestidSpan','1')"></button>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="3">
            <input type="hidden" name="requestid"/>
			<span id = "requestidSpan" ></span>
            </td>
        </tr>
        <tr>
            <td align="center" colspan="3">
            &nbsp;
            </td>
        </tr>
        <%
            }
        %>
            <tr><td colspan=3 align="center">
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div><br>
                <a href="javascript:showMyResult()" id="showResult" style="display:none"></a>
                <div id="p1" style="width:300px;display:inline"></div>
                </div>
                </div>
                <br/>
        </td></tr>
	    </table>
        </form>
 </div>
</body>
<script type="text/javascript">
    //*********************************模式对话框特效(start)*********************************//
            function sAlert(){
            var msgw,msgh,bordercolor;
            msgw=420;//提示窗口的宽度
            msgh=80;//提示窗口的高度
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
            document.body.removeChild(bgObj);
            document.getElementById("msgDiv").removeChild(title);
            document.body.removeChild(msgObj);
        }
          document.body.appendChild(msgObj);
          document.getElementById("msgDiv").appendChild(title);
		  var progressBar=document.getElementById("progressBar");
          progressBar.style.display="block";
	      document.getElementById("msgDiv").appendChild(progressBar);
          doOutPutHumresExcel();
      }
//*********************************模式对话框特效(end)*********************************//
</script>
</html>