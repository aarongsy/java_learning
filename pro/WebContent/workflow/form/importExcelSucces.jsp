<%@ page import="com.eweaver.base.util.StringHelper" %>
<%@ include file="/base/init.jsp"%>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2008-9-9
  Time: 15:01:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title>导入Excel成功</title>
  <%
      String sysmodel = StringHelper.null2String(request.getAttribute("sysmodel"));
      String msg = StringHelper.null2String(request.getAttribute("msg"));
      String succesId = StringHelper.null2String(request.getAttribute("succesId"));
      String lostId = StringHelper.null2String(request.getAttribute("lostId"));
      String categoryid = StringHelper.null2String(request.getAttribute("categoryid"));
      String workflowid = StringHelper.null2String(request.getAttribute("workflowid"));
      String path = StringHelper.null2String(request.getAttribute("path"));
  %>
  <style type="text/css">
      a{
          text-decoration: none;
      }
  </style>
<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/HumresExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersCategoryExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/UsersWorkflowExcelService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>

<script type="text/javascript">
var total=0;
var currentCount="";
var refresstimer;
var pbar1;
var body;
Ext.onReady(function(){
    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });


        total=0;
        currentCount="";
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '0%';
            pbar1.show();
        }
        doInPutExcel();
        if(total==-1){
        pbar1.reset(true);
        Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("40288035247afa9601247b1859d30019") %>').show();//请等待先前的任务完成
        return;
        }
        if(total==0){
        pbar1.reset(true);
        Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %>').show();//操作完成
        document.getElementById('goback').style.display="block";
        return;
        }
        document.getElementById('goback').style.display="none";
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('<%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39330035") %>').show();//操作完成
            document.getElementById('goback').style.display="block";
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
  <script type="text/javascript">


      function downloadLostRecord(){
          document.forms[0].action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?action=download&sysmodel=sysmodel";
          document.forms[0].submit();
      }

    function doInPutExcel(){
        var path = document.getElementById("path").value;
        DWREngine.setAsync(false);
<%
        if(!sysmodel.equals("")){
%>
        HumresExcelService.inputExcel(path,returnTotal);
<%
        }else{
            if(workflowid.equals("")){
%>
            UsersCategoryExcelService.inputExcel(path,'<%=categoryid%>',returnTotal);
<%
            }else{
%>
            UsersWorkflowExcelService.inputExcel(path,'<%=workflowid%>',returnTotal);
<%
            }
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

        document.getElementById("succesNum").innerText=succesNum;
        var lostNum=obj.lostNum;
        document.getElementById("lostNum").innerText=lostNum;
        var allNum=obj.total;
        var iserror = obj.iserror;
        if(iserror==1){
            document.getElementById("iserror").style.color="red";
            document.getElementById("iserror").innerText = "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0036") %>";//程序出现自身无法处理的严重错误，请认真检查操作是否正确，若无法解决请联系系统管理员.
        }
        if(allNum==total){
            document.getElementById("lostRecord").innerText = "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0033") %>";//点击查看
            document.getElementById("succesRecord").innerText = "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0033") %>";//点击查看

        }
        currentCount=allNum;
    }

    function doRefresh(){
<%
        if(!sysmodel.equals("")){
%>
        HumresExcelService.getInPutCurrentCount(returnCurrentCount);
<%
        }else{
            if(workflowid.equals("")){
%>
            UsersCategoryExcelService.getInPutCurrentCount(returnCurrentCount);
<%
            }else{
%>
            UsersWorkflowExcelService.getInPutCurrentCount(returnCurrentCount);
<%
            }
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
  </head>
  <body>
  <form action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.excel.servlet.ExcelUpLoadAction?path=<%=path%>" method="post">
   <input type="hidden" id="path" name="path" value="<%=path%>"/>
  <table align="center" style="font-size:14">
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td colspan="2"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0037") %><!-- 导入的总记录数 -->:&nbsp;&nbsp;<a id="totalNum" href="javascript:void(0)">0</a></td>
      </tr>
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0038") %><!-- 当前的执行进度 -->:</td>
          <td>
                <div class="status" id="p1text" style="display:inline;"></div>
                <div id="p1" style="width:300px;display:inline"></div>
          </td>
      </tr>
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td colspan="2"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0039") %><!-- 导入成功记录数 -->:&nbsp;&nbsp;<a id="succesNum" href="javascript:void(0)">0</a>&nbsp;&nbsp;<a id="succesRecord" href="javascript:downloadLostRecord()"></a></td>
      </tr>
      <tr>
          <td colspan="2"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003a") %><!-- 导入失败记录数 -->:&nbsp;&nbsp;<a id="lostNum" href="javascript:void(0)">0</a>&nbsp;&nbsp;<a id="lostRecord" href="javascript:downloadLostRecord()"></a></td>
      </tr>
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td colspan="2"><a href="javascript:void(0)" id="iserror"></a></td>
      </tr>
      <tr>
          <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
          <td colspan="2">
<%
        if(!sysmodel.equals("")){
%>
        <span id="goback" name="goback"><a href="<%=request.getContextPath()%>/workflow/form/exportrecordbyexcel.jsp"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003b") %><!-- 返回前一页 --></a></span>
<%
        }else{
            if(workflowid.equals("")){
%>
            <span id="goback" name="goback"><a href="<%=request.getContextPath()%>/workflow/form/getrecordbyexcel.jsp?categoryid=<%=categoryid%>"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003b") %><!-- 返回前一页 --></a></span>
<%
            }else{
%>
            <span id="goback" name="goback"><a href="<%=request.getContextPath()%>/workflow/workflow/getrecordbyexcel2.jsp?workflowid=<%=workflowid%>"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a003b") %><!-- 返回前一页 --></a></span>
<%
            }
        }
%>

          </td>
      </tr>
  </table>
  </form>
  </body>
</html>