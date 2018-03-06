<%@ page import="com.eweaver.workflow.form.service.ForminfoService" %>
<%@ page import="com.eweaver.base.BaseContext" %>
<%@ page import="com.eweaver.workflow.form.model.Forminfo" %>
<%@ page import="com.eweaver.base.refobj.model.Refobj" %>
<%@ page import="com.eweaver.base.refobj.service.RefobjService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.eweaver.base.category.service.CategoryService" %>
<%@ page import="com.eweaver.base.category.model.Category" %>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-5
  Time: 14:06:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330031") %><!-- 导出Excel --></title>

<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
  <%
      String categoryid = request.getParameter("categoryid");
      ForminfoService forminfoService = (ForminfoService) BaseContext.getBean("forminfoService");
      CategoryService categoryService = (CategoryService) BaseContext.getBean("categoryService");
      Category category = categoryService.getCategoryById(categoryid);
      while ((category.getFormid()==null||"".equals(category.getFormid()))&&category.getPid()!=null){
          category = categoryService.getCategoryById(category.getPid());
      }
      Forminfo forminfo = forminfoService.getForminfoById(category.getFormid());
      if(forminfo.getId()==null){
          response.sendRedirect(request.getContextPath()+"/nopermit.jsp");
          return;
      }
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
<script type="text/javascript">
var outPutExcelBtn;
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;
Ext.onReady(function(){
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });
    outPutExcelBtn = Ext.get('outPutExcelBtn');
    outPutExcelBtn.on('click', function(){
        total=0;
        currentCount=0;
        outPutExcelBtn.dom.disabled = true;
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
        outPutExcelBtn.dom.disabled = false;
        Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("40288035247afa9601247b1859d30019") %>').show();//请等待先前的任务完成
        return;
        }
        if(total==0){
        pbar1.reset(true);
        outPutExcelBtn.dom.disabled = false;

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
            var progressBarhome=document.getElementById("progressBarhome");
            var progressBar=document.getElementById("progressBar");
            progressBarhome.appendChild(progressBar);
            var bgObj=document.getElementById("bgDiv");
            document.body.removeChild(bgObj);
            var title=document.getElementById("msgTitle");
            document.getElementById("msgDiv").removeChild(title);
            var msgObj=document.getElementById("msgDiv");
            document.body.removeChild(msgObj);
            document.getElementById("showResult").innerText="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330036") %>";//查看导出结果
            <%--document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download";--%>
            <%--document.forms[0].submit();--%>
        });
    });
});


var Runner = function(){
    var f = function(pbar,count, cb){

        return function(){
            doRefresh();
            if(currentCount >= count){
                outPutExcelBtn.dom.disabled = false;
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
      a{
          text-decoration: none;
      }
      tr{
          align:center;
      }
    .mysubmit {
        font-size: 14px;
        font-weight: normal;
        color: #666666;
        background-color: #FFFFFF;
        height: 22px;
        width: 100px;
        border: thin solid #999999;
    }
    .mysubmit2 {
        font-size: 14px;
        font-weight: normal;
        color: #333333;
        background-color: #CCCCCC;
        height: 22px;
        width: 100px;
        border: thin solid #999999;
    }
  </style>
  <script type="text/javascript">

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
          document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=excelUpLoad&categoryid=<%=categoryid%>";
          document.forms[0].submit();
      }

    function doOutPutHumresExcel(){
        var requestid="";
        if(document.all("requestid")!=null){
            requestid=document.all("requestid").value;
        }
        DWREngine.setAsync(false);
        UsersCategoryExcelService.outputExcel('<%=categoryid%>',requestid,returnTotal);
        DWREngine.setAsync(true);

    }
    function returnTotal(o){
        total=o;
    }
    function returnCurrentCount(o){
        currentCount=o
    }
    function doRefresh(){
        UsersCategoryExcelService.getOutPutCurrentCount(returnCurrentCount);
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
  </head>
  <body>
  <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download&sysmodel=sysmodel" enctype="multipart/form-data" method="post">
  <br/>
  <table width="750" height="660" border="1" align="center" style="font-size:14" cellspacing="0" bordercolor="#CCCCCC">
    <tr>
        <td align="center" colspan="3" height="28" align="center"><%=labelService.getLabelNameByKeyId("402883d934cf81d90134cf81da050004") %><!-- 您选择的表单是 -->:<%=forminfo.getObjname()%></td>
    </tr>
  <tr>
    <td width="550" height="18" align="right">
    </td>
    <td width="104" align="center"><input name="button" type="button" class="mysubmit2" id="Submit1" onclick="myshow('1')" value="<%=labelService.getLabelNameByKeyId("导出操作") %>"/><!-- 导出操作 -->
    </td>
    <td width="105" align="center"><input name="button" type="button" class="mysubmit" id="Submit2" onclick="myshow('2')" value="<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330037") %>"/><!-- 导入操作 -->
    </td>
  </tr>
  <tr>
    <td height="12" colspan="3" align="center"></td>
  </tr>
  <tr>
    <td colspan="3" >
      <table width="750" border="0" bordercolor="#CCCCCC" id="Layer1" style="font-size:14">
        <tr>
            <td align="center"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0023") %><!-- 导出excel的相关注意事项 -->:</td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0024") %><!-- 1.需要导出的列,可以在被导出分类表单的EXCEL导入导出列的设置中设置; --></td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0025") %><!-- 2.请注意,被导出的数据仅仅属于您所选择的分类,而相同表单下的其它分类或流程数据将不会被导出; --></td>
        </tr>
        <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
        <tr>
            <td align="center">
            <a id="outPutExcelBtn" href="javascript:void(0)" style="font-size:14"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0026") %><!-- 导出表单数据 --></a>&nbsp;&nbsp;&nbsp;<a id="showResult" href="javascript:showMyResult()"></a>
                <div id="progressBarhome" style="display:block;">
                <div id="progressBar" style="display:block;">
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
                </div>
                </div>
            </td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <%
             if(url!=""){
        %>
        <tr>
            <td align="center">
            <a href="javascript:getBrowser('<%=url%>','requestid','requestidSpan','1')" style="font-size:13"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0027") %><!-- 点击选择需要导出的具体表单记录 --></a>
            </td>
        </tr>
        <tr>
            <td>
            <input type="hidden" name="requestid"/>
			<span id = "requestidSpan" ></span>
            </td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <%
            }
        %>
        <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
      </table>
          <table width="750" border="0" bordercolor="#CCCCCC" id="Layer2" style="display:none" style="font-size:14">
       <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td align="center"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0028") %><!-- 导入excel的相关注意事项 -->:</td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0029") %><!-- 1.导入模板的格式是固定的,在没有导入模板的情况下,可以试着先导出数据,然后根据导出的模板去修改; --></td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002a") %><!-- 2.在修改导入模板的时候需要注意按照原有的格式去修改; --></td>
        </tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
        <tr>
            <td>&nbsp;&nbsp;<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002b") %><!-- 3.在导入操作完成后,可以点击查看连接来查看导入成功和失败的结果集; --></td>
        </tr>
        <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>

        <tr>
            <td align="center">
                <a href="javascript:importExcel()" style="font-size:14"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a002c") %><!-- 将选择的Excel文件导入到数据库 --></a>&nbsp;&nbsp;<input type="file" name="path" />
            </td>
        </tr>
        <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
        <tr>
            <td>
            &nbsp;
            </td>
        </tr>
          </table>
      </td>
  </tr>
</table>
  </form>

  </body>
<script type="text/javascript">
    //*********************************模式对话框特效(start)*********************************//
            function sAlert(){
            var msgw,msgh,bordercolor;
            msgw=420;//提示窗口的宽度
            msgh=68;//提示窗口的高度
            bordercolor="#ffffff";//提示窗口的边框颜色

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
          title.innerHTML="<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>";//关闭
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
          doOutPutHumresExcel();
      }
//*********************************模式对话框特效(end)*********************************//
</script>
</html>
