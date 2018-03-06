<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.util.FormLayoutTranslate"%>
<%@ page import="com.eweaver.base.Page"%>
<%@ page import="com.eweaver.workflow.workflow.service.NodeinfoService"%>
<%@ page import="com.eweaver.workflow.workflow.model.Nodeinfo"%>
<%@ page import="com.eweaver.workflow.workflow.model.Workflowinfo"%>
<%@ page
	import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%
WorkflowinfoService workflowinfoService = (WorkflowinfoService) BaseContext.getBean("workflowinfoService");
NodeinfoService nodeinfoService = (NodeinfoService) BaseContext.getBean("nodeinfoService");
//String workflowid = StringHelper.null2String(request.getParameter("workflowid"));
String id=request.getParameter("forminfoid");
String action = request.getContextPath() + "/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=getformlayoutlist";
    pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881ec0bdbcad1010bdbdf82470003") + "','E','application_edit',function(){oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=2&forminfoid="+id+"','"+labelService.getLabelName("402881ec0bdbcad1010bdbdf82470003")+"')});";  //默认编辑布局
    pagemenustr += "addBtn(tb,'" + labelService.getLabelName("402881ec0bdbcad1010bdbe004450004") + "','V','application',function(){oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=1&forminfoid="+id+"','"+labelService.getLabelName("402881ec0bdbcad1010bdbe004450004")+"')});";//默认显示布局
    pagemenustr += "addBtn(tb,'" +labelService.getLabelName("402880371cdbc14a011cdbcd56200051") + "','T','printer',function(){oncreateformlayout('/workflow/form/formlayoutinfo.jsp?layouttype=3&forminfoid="+id+"','"+labelService.getLabelName("402880371cdbc14a011cdbcd56200051")+"')});";//默认打印布局

%>

<html>
	<head>

		<style type="text/css">
.x-toolbar table {
	width: 0
}

#pagemenubar table {
	width: 0
}

.x-panel-btns-ct {
	padding: 0px;
}

.x-panel-btns-ct table {
	width: 0
}
</style>
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.css" />
		<script type="text/javascript"
			src="<%=request.getContextPath()%>/plugin/ajaxtabs/ajaxtabs.js">
      </script>
		<script
			src='<%=request.getContextPath()%>/dwr/interface/FormlayoutService.js'></script>
		<script
			src='<%=request.getContextPath()%>/dwr/interface/FormfieldService.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/engine.js'></script>
		<script src='<%=request.getContextPath()%>/dwr/util.js'></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/ext/adapter/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/ext/ux/toolbar.js"></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/ext/ux/iconMgr.js"></script>
		<script type="text/javascript"
			src="<%= request.getContextPath()%>/js/ext/ux/miframe.js"></script>
		<script language="javascript">
      Ext.SSL_SECURE_URL='about:blank';
      Ext.LoadMask.prototype.msg='<%=labelService.getLabelNameByKeyId("402883d934c0e39a0134c0e39afa0000") %>';//加载...
      var store;
      var selected = new Array();
      var dlg0;
        var myMask ;
      Ext.onReady(function() {
          Ext.QuickTips.init();
      <%if(!pagemenustr.equals("")){%>
          var tb = new Ext.Toolbar();
          tb.render('pagemenubar');
      <%=pagemenustr%>
      <%}%>
          store = new Ext.data.Store({
              proxy: new Ext.data.HttpProxy({
                  url: '<%=action%>'
              }),
              reader: new Ext.data.JsonReader({
                  root: 'result',
                  totalProperty: 'totalcount',
                  fields: ['layoutname','formlayouttype','modify','del','clone','id','attr']
              })
          });

          var cm = new Ext.grid.ColumnModel([ {header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf3138d0002") %>",  sortable: false,  dataIndex: 'layoutname'},//应用对象
              {header: "<%=labelService.getLabelNameByKeyId("402881ec0bdbf198010bdbf3ae300003") %>", sortable: false,   dataIndex: 'formlayouttype'},//布局类型
              {header: "<%=labelService.getLabelNameByKeyId("402881eb0c9fadb1010c9fd1a069000e") %>",width:20,  sortable: false, dataIndex: 'modify'},//操作
              {header: "",width:20,  sortable: false ,dataIndex: 'del'},
              {header: "",width:20,  sortable: false ,dataIndex: 'clone'},
              {header: "<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0010") %>",align:'center',  sortable: false ,dataIndex: 'attr'}//字段属性设置
          ]);
          cm.defaultSortable = true;
          var grid = new Ext.grid.GridPanel({
              region: 'center',
              store: store,
              cm: cm,
              trackMouseOver:false,
              loadMask: true,
               viewConfig: {
                                       forceFit:true,
                                       enableRowBody:true,
                                       sortAscText:'<%=labelService.getLabelNameByKeyId("402883d934c0f44b0134c0f44c780000") %>',//升序
			                           sortDescText:'<%=labelService.getLabelNameByKeyId("402883d934c0f59f0134c0f5a0140000") %>',//降序
			                           columnsText:'<%=labelService.getLabelNameByKeyId("402883d934c0f6b10134c0f6b1eb0000") %>',//列定义
                                       getRowClass : function(record, rowIndex, p, store){
                                           return 'x-grid3-row-collapsed';
                                       }
                                   }

          });
           myMask = new Ext.LoadMask(Ext.getBody());

          var viewport = new Ext.Viewport({
              layout: 'border',
              items: [{region:'north',autoScroll:true,contentEl:'divSearch',split:true,collapseMode:'mini'},grid]
          });
          store.baseParams.id='<%=id%>';
          store.load({params:{start:0, limit:20}});

      });
      </script>

	</head>
	<body>
		<div id="divSearch">
			<div id="pagemenubar"></div>
		</div>
		<div id="divObj" style="display: none">
			<table id="displayTable">
				<thead>
					<tr>
						<th colspan="8" style="background-color: #f7f7f7; height: 22">
							<b><span style="color: green"><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0011") %><!-- 无法删除 --></span>,<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0012") %><!-- 您选择的布局正被以下权限设置所引用,请先删除以下权限 -->:</b>
						</th>
					</tr>
					<tr style="background-color: #f7f7f7; height: 22">
						<!--<th align="center"><b>ObjId</b></th>-->
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402881eb0bcbfd19010bcc7cb27c0029") %><!-- 权限类型 --></b>
						</th>
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402883d934cbbb380134cbbb39340039") %><!-- 所属分类 --></b>
						</th>
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0013") %><!-- 所属节点 --></b>
						</th>
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402881f00c7690cf010c76a942a9002b") %><!-- 流程名称 --></b>
						</th>
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402881ea0bfa7679010bfa8999a3001b") %><!-- 操作类型 --></b>
						</th>
						<th align="center">
							<b><%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0014") %><!-- 限制对象 --></b>
						</th>
						<th align="center" width="40"></th>
						<th align="center">
							<a href="javascript:goDelete()"><%=labelService.getLabelNameByKeyId("402881e60aa85b6e010aa8624c070003") %><!-- 删除 --></a>
						</th>
					</tr>
				</thead>

				<tbody id="refreshBody">
					<!-- 在这刷新 -->
				</tbody>
			</table>
		</div>
		<div id="showDivObj"
			style="position: absolute; width: 0px; height: 22px; z-index: 100; visibility: visible; left: 0px; top: 200px; display: none; background-color: #666666">
			<table>
				<thead>
					<tr>
						<th colspan="5" style="background-color: #f7f7f7; height: 20">
							<a id="msg" href="javascript:void(0)"></a>
						</th>
					</tr>
				</thead>
			</table>
		</div>
		<input type="hidden" id="checkLayoutId" />
		<script type="text/javascript">
  	function onsetfieldstyle(url){
         window.open(url);
	}
	function onClone(url){
		oncreateformlayout(url,"<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0015") %>");//复制表单布局
	}
    function oncreateformlayout(url,layoutName){
        url = contextPath + url;
        var getLayoutId = function() {
            var layoutid = url.substring(url.indexOf('&layoutid=') + '&layoutid='.length, url.indexOf('&nodeid='));
            if (layoutid.length != 32 && layoutid.indexOf('/') > -1) {
                if (url.indexOf('layouttype=2') > -1) { //编辑
                    return '<%=id%>2';
                } else if (url.indexOf('layouttype=1') > -1) {  //显示
                    return '<%=id%>1';
                } else if (url.indexOf('layouttype=3') > -1) { //打印
                    return '<%=id%>3';
                }
            } else {
                return layoutid;
            }

        };
        layoutName = '<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a000e") %>' + (Ext.isEmpty(layoutName) ? '' : '[' + layoutName + ']');//修改布局
        //	top.onUrl(contextPath+url,layoutName,'modifyLayout_'+getLayoutId());
        window.open(url, 'modifyLayout_' + getLayoutId());
   }
 function onDeleteFormlayout(id) {
     document.getElementById("checkLayoutId").value = id;
     FormlayoutService.checkOptLayout(id, callback);
     myMask.show();
 }

   	function callback(data){
        if(data!=null&&data!=""){
            alert(data);
        }else{
            var id=document.getElementById("checkLayoutId").value;
            FormlayoutService.getPermissionObj(id,showTable);
   	    }
   	}

    function showTable(data){
      if(data!="" && data!=null){
          sAlert(data);
      }else{
          var id=document.getElementById("checkLayoutId").value;
          showAlert(id);
      }
    }
     function showAlert(id){
        myMask.hide();
	    if( confirm('<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0002") %>')){//确定要删除您选择的布局吗?

		var param=new Object();
		param.action="<%=request.getContextPath()%>/ServiceAction/com.eweaver.workflow.form.servlet.FormlayoutAction?action=delete&layoutid="+id;
		param.updatestring=id;
		param.sourceurl=window.location.pathname;
		var result=showModalDialog("<%=request.getContextPath()%>/base/updatedialog.html", param,
			"dialogHeight: 80px; dialogWidth: 220px; center: Yes; help: No; resizable: yes; status: No");
         store.baseParams.id='<%=id%>';
          store.load({params:{start:0, limit:20}});
	   	}
   	}
    function addTable(data){
          var refreshBody=$("#refreshBody");
          refreshBody.find("tr").remove();
          $(data).each(function(i){
        	  	var row=$("<tr style='color:#999999,height:20px;'></tr>");
        	  	var td1=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td1.append(data[i]["permissiontype"]);
        	  	row.append(td1);
        	  	var td2=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td2.append(data[i]["categoryName"]);
        	  	row.append(td2);
        	  	var td3=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td3.append(data[i]["nodeinfoName"]);
        	  	row.append(td3);
        	  	var td4=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td4.append(data[i]["workflowName"]);
        	  	row.append(td4);
        	  	var td5=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td5.append(data[i]["opttype"]);
        	  	row.append(td5);
        	  	var td6=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td6.append(data[i]["operateObj"]);
        	  	row.append(td6);
        	  	var td7=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	row.append(td7);
        	  	var td8=$("<td style='background-color:#f7f7f7;font-weight:bold;'></td>");
        	  	td8.append("<input type='checkbox' name='unitCheck' value='"+data[i]["id"]+"'>");
        	  	row.append(td8);
        	  	refreshBody.append(row);
          })
          myMask.hide();
    }
//*********************************模式对话框特效(start)*********************************//
       function sAlert(data){
       var msgw,msgh,bordercolor;
       msgw=780;//提示窗口的宽度
       msgh=320;//提示窗口的高度
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
       var mychoose=document.getElementById("divObj");
       var mytable=document.getElementById("displayTable");
       mychoose.appendChild(mytable);
       document.body.removeChild(bgObj);
       document.getElementById("msgDiv").removeChild(title);
       document.body.removeChild(msgObj);
   }
     document.body.appendChild(msgObj);
     document.getElementById("msgDiv").appendChild(title);
     var mytable=document.getElementById("displayTable");
     document.getElementById("msgDiv").appendChild(mytable);
     addTable(data);
 }
//*********************************模式对话框特效(end)*********************************//
function goDelete(){
	var ruleids="";
	var allCheckBox = document.getElementsByName("unitCheck");
	for(i=0;i<allCheckBox.length;i++){
	    if(allCheckBox[i].type=="checkbox"&&allCheckBox[i].checked==true){
	        ruleids+=allCheckBox[i].value+",";
	    }
	}
	if(ruleids==""||ruleids==null){
	    alert("<%=labelService.getLabelNameByKeyId("402883d934cfcad30134cfcad45a0003") %>");//请选择需要删除的项!
	}else{
		if(confirm('确认删除！')){
	    	FormlayoutService.deletepermissionrule(ruleids,deleteCallBack);
		}
	}
}
function deleteCallBack(data){
	if(data=="ok"){
		window.location.reload();
	}else{
		alert("删除失败！");
	}
}
</script>
	</body>
</html>

