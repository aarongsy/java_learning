<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@ page import="com.eweaver.base.BaseContext"%>
<%@ page import="com.eweaver.base.security.service.logic.*"%>
<%@ page import="com.eweaver.base.security.model.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.eweaver.workflow.form.model.Forminfo"%>
<%@ page import="com.eweaver.workflow.form.service.ForminfoService"%>
<%@ page import="com.eweaver.workflow.form.model.Formfield"%>
<%@ page import="com.eweaver.workflow.form.service.FormfieldService"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemtypeService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportsearchfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportSearchfieldService"%>
<%@ page import="com.eweaver.base.util.NumberHelper"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.report.model.Reportfield"%>
<%@ page import="com.eweaver.workflow.report.service.ReportfieldService"%>
<%@ page import="com.eweaver.base.menu.service.PagemenuService"%>
<%@ page import="com.eweaver.base.menu.model.Pagemenu"%>
<%@ page import="com.eweaver.base.refobj.model.Refobj"%>
<%@ page import="com.eweaver.base.refobj.service.RefobjService"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="com.eweaver.document.base.model.Attach"%>
<%@ page import="com.eweaver.document.base.service.AttachService"%>
<%@ page import="com.eweaver.base.security.service.logic.PermissiondetailService"%>
<%@ page import="org.json.simple.JSONObject"%>
<%
String actionId=StringHelper.null2String(request.getParameter("id"));
String hiddenValue=StringHelper.null2String(request.getParameter("hiddenValue"));
String from=StringHelper.null2String(request.getParameter("from"));
String fromspan=StringHelper.null2String(request.getParameter("fromspan"));
String to=StringHelper.null2String(request.getParameter("to"));
String tospan=StringHelper.null2String(request.getParameter("tospan"));
if(actionId.equals(""))
return;
PermissionBatchActionService permissionBatchActionService = (PermissionBatchActionService) BaseContext.getBean("permissionBatchActionService");
PermissionBatchActionGroupService permissionBatchActionGroupService = (PermissionBatchActionGroupService) BaseContext.getBean("permissionBatchActionGroupService");

    PermissionBatchAction permissionBatchAction=permissionBatchActionService.getPermissionBatchAction(actionId) ;

Integer objType=1;
if(permissionBatchAction.getType()==2){
    objType=2;
}else{
    for (PermissionBatchActionDetail actDetail : permissionBatchAction.getActionDetails()){
        if(actDetail.getType()==2){
            objType=2;
            break;
        }
    }
}
if(permissionBatchAction==null)
return;
titlename=permissionBatchAction.getObjname();

int pageSize=20;
int gridWidth=700;
int gridHeight=330;
String reportid = permissionBatchAction.getReportId();
String isformbase="";
int cardtype=NumberHelper.getIntegerValue(permissionBatchAction.getCardtype(),0);

if(cardtype==1){
    isformbase = "1";
}else if(cardtype==0){
    isformbase = "0";
}
String sqlwhere= StringHelper.null2String(request.getParameter("sqlwhere"));
String showCheckbox= "true";
Page pageObject = (Page) request.getAttribute("pageObject");
Map summap = (Map)request.getAttribute("sum");
paravaluehm = (HashMap)request.getAttribute("paravaluehm");
if(paravaluehm==null){
	paravaluehm = new HashMap();
}
FormfieldService formfieldService = (FormfieldService) BaseContext.getBean("formfieldService");
ReportfieldService reportfieldService = (ReportfieldService)BaseContext.getBean("reportfieldService");
PermissiondetailService permissiondetailService = (PermissiondetailService) BaseContext.getBean("permissiondetailService");
SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
RefobjService refobjService = (RefobjService) BaseContext.getBean("refobjService");
AttachService attachService = (AttachService) BaseContext.getBean("attachService");
ForminfoService forminfoService = (ForminfoService)BaseContext.getBean("forminfoService");
HumresService humresService=(HumresService)BaseContext.getBean("humresService");
List reportfieldList = reportfieldService.getReportfieldListForUser(reportid,eweaveruser.getId());
if(reportfieldList.size()==0){
	reportfieldList = reportfieldService.getReportfieldListByReportID(reportid);
}
int rows=0;
int cols=0;
List reportdatalist = new ArrayList();//用于保存转换后的查询数据

String jsonStr=null;
Map fieldsearchMap = (Map)request.getAttribute("fieldsearchMap");
if(fieldsearchMap != null){
        JSONObject jsonObject=new JSONObject();
        Set keySet=fieldsearchMap.keySet();
        for(Object key:keySet){
            String value=(String)fieldsearchMap.get(key);
            if(!StringHelper.isEmpty(value))
            jsonObject.put(key,value);
        }
        if(!"".equals(sqlwhere.trim())){
        jsonObject.put("sqlwhere",sqlwhere);
        }
        jsonStr=jsonObject.toString();
    }
%>
<html>
<head>
<script  type='text/javascript' src='<%= request.getContextPath()%>/js/workflow.js'></script>
<script src='<%= request.getContextPath()%>/dwr/interface/RightTransferService.js'></script>
<script src='<%= request.getContextPath()%>/dwr/engine.js'></script>
<script src='<%= request.getContextPath()%>/dwr/util.js'></script>

<script src='<%= request.getContextPath()%>/dwr/interface/DataService.js'></script>

<script language="JScript.Encode" src="<%= request.getContextPath()%>/js/rtxint.js"></script>
<script language="JScript.Encode" src="<%= request.getContextPath()%>/js/browinfo.js"></script>


<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-latest.pack.js"></script>
<style type="text/css">
    TABLE {
	    width:0;
    }
    /*TD{*/
        /*width:16%;*/
    /*}*/
</style>
  <script language="javascript">

var btn1;
var total=0;
var currentCount=0;
var refresstimer;
var pbar1;


var Runner = function(){
    var f = function(pbar,count, cb){

        return function(){
            doRefresh();
            if(currentCount >= count){
                btn1.dom.disabled = false;
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
              refresstimer=setInterval(f(pbar, count, cb),1000);
              }catch(e){}
        }
    }
}();
</script>

<script type="text/javascript">
    Ext.LoadMask.prototype.msg='加载...';
    var store;
    var selected=new Array();
    <%
        String sysmodel = request.getParameter("sysmodel");
String action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&from=list&reportid=" + reportid;
String action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=search&reportid=" + reportid+"&permissionbatchaction=1";
if(!StringHelper.isEmpty(sysmodel)){
	action = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&from=list&reportid=" + reportid;
	action2 = request.getContextPath()+"/ServiceAction/com.eweaver.workflow.report.servlet.SysModelReportAction?action=search&reportid=" + reportid;
}else{
	//pagemenustr += "{C,"+ "生成EXCEL文件" +",javascript:createexcel()}";
}
        String cmstr="";
        String fieldstr="";
        Iterator it = reportfieldList.iterator();
        cols = reportfieldList.size();
        fieldstr+="'requestid'";
        Map reporttitleMap = new HashMap();
       int k=0;
		while(it.hasNext()){
			Reportfield reportfield = (Reportfield) it.next();
			reporttitleMap.put(reportfield.getShowname(),reportfield.getShowname());
			Integer showwidth = reportfield.getShowwidth();
			String widths = "";
			if(showwidth!=null && showwidth.intValue()!=-1){
				widths = "width=" + showwidth + "%";
			}
			Formfield formfields = formfieldService.getFormfieldById(reportfield.getFormfieldid());
			String thtmptype = "";
			if(formfields.getHtmltype() != null){
				thtmptype = formfields.getHtmltype().toString();
			}
			String tfieldtype = "";
			if(formfields.getFieldtype()!=null){
				tfieldtype = formfields.getFieldtype().toString();
			}

			String styler = "";
			if("1".equals(thtmptype) && ("2".equals(tfieldtype) || "3".equals(tfieldtype))){
				styler = "style='text-align :right'";
			}

         	String fieldname=formfields.getFieldname() ;
         	String showname=reportfield.getShowname();
         	int sortable=NumberHelper.getIntegerValue(reportfield.getIsorderfield(),0);
         	if(cmstr.equals(""))
            cmstr+="{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            else
            cmstr+=",{header:'"+showname+"',dataIndex:'"+fieldname+"',width:"+showwidth*gridWidth/100+",sortable:true}";
            if(fieldstr.equals(""))
            fieldstr+="'"+fieldname+"'";
            else
            fieldstr+=",'"+fieldname+"'";
      	k++;
      }
      	reportdatalist.add(reporttitleMap);//生成excel报表时用到

      %>
    Ext.onReady(function(){
    store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: '<%=action2+"&isjson=1&pagesize="+pageSize+"&isformbase="+isformbase%>'
        }),
        reader: new Ext.data.JsonReader({
            root: 'result',
            totalProperty: 'totalCount',
            fields: [<%=fieldstr%>]
        }),
        remoteSort: true
    });
    //store.setDefaultSort('id', 'desc');
    <%if(showCheckbox.equals("true")){%>
    var sm=new Ext.grid.CheckboxSelectionModel();
    var cm = new Ext.grid.ColumnModel([sm,<%=cmstr%>]);
    <%}else{%>
    var sm=new Ext.grid.RowSelectionModel({selectRow:Ext.emptyFn});
    var cm = new Ext.grid.ColumnModel([<%=cmstr%>]);
    <%}%>
    cm.defaultSortable = true;

                   var grid = new Ext.grid.GridPanel({
                       region: 'center',
                       store: store,
                       cm: cm,
                       trackMouseOver:false,
                       sm:sm ,
                       loadMask: true,
                       viewConfig: {
                           forceFit:true,
                           enableRowBody:true,
                           sortAscText:'升序',
                           sortDescText:'降序',
                           columnsText:'列定义',
                           getRowClass : function(record, rowIndex, p, store){
                               return 'x-grid3-row-collapsed';
                           }
                       },
                       tbar: [Ext.get('divSearch').dom.innerHTML],
                       bbar: new Ext.PagingToolbar({
                           pageSize: <%=pageSize%>,
            store: store,
            displayInfo: true,
            beforePageText:"第",
            afterPageText:"页/{0}",
            firstText:"第一页",
            prevText:"上页",
            nextText:"下页",
            lastText:"最后页",
            refreshText:"刷新",
            displayMsg: '显示 {0} - {1}条记录 / {2}',
            emptyMsg: "没有结果返回"
        })
    });

    /*store.on('beforeload',function(){
        alert(selected.length);
    });*/
    store.baseParams=<%=(jsonStr==null?"{}":jsonStr)%>
<%
    if(objType==1){
%>
    store.load({params:{start:0, limit:<%=pageSize%>}});
<%
    }
%>

    <%if(showCheckbox.equals("true")){%>
    store.on('load',function(st,recs){

        for(var i=0;i<recs.length;i++){
            var reqid=recs[i].get('requestid');
        for(var j=0;j<selected.length;j++){
                    if(reqid ==selected[j]){
                         sm.selectRecords([recs[i]],true);
                     }
                 }
    }
    }
            );
    sm.on('rowselect',function(selMdl,rowIndex,rec ){
        var reqid=rec.get('requestid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                         return;
                     }
                 }
        selected.push(reqid)
    }
            );
    sm.on('rowdeselect',function(selMdl,rowIndex,rec){
        var reqid=rec.get('requestid');
        for(var i=0;i<selected.length;i++){
                    if(reqid ==selected[i]){
                        selected.remove(reqid)
                         return;
                     }
                 }

    }
            );
     <%}%>
    //Viewport
	var viewport = new Ext.Viewport({
        layout: 'border',
        items: [grid]
	});

    //==== Progress bar1  ====
    pbar1 = new Ext.ProgressBar({
       text:'0%'
    });
    btn1 = Ext.get('btn1');

    btn1.on('click', function(){
<%
    String operationObj = permissionBatchAction.getOperationObj();
    String targetObj=permissionBatchAction.getTargetObj();

    if(objType==2){
%>
        if(document.all("from")(0).value==""){
        alert("请选择<%=operationObj%>");
        return;
        }
<%
    }
%>
        if(document.all("to")(0).value==""){
            alert("请选择<%=targetObj%>");
            return;
        }
        if(document.all("from")(0).value==document.all("to")(0).value){
            alert("<%=operationObj%>和<%=targetObj%>不能相同");
            return;
        }
        if(selected.length==0){
            alert("您还没有选择卡片,若没有供选择的卡片请重新搜索或返回.");
            return;
        }
        total=0;
        currentCount=0;
        btn1.dom.disabled = true;
        Ext.fly('p1').setDisplayed(true);
        Ext.fly('p1text').update('');
        if (!pbar1.rendered){
            pbar1.render('p1');
        }else{
            pbar1.text = '0%';
            pbar1.show();
        }
        doTransfer('<%=actionId%>');
        if(total==-1){
        pbar1.reset(true);
        btn1.dom.disabled = false;
        Ext.fly('p1text').update('请等待先前的任务完成').show();
        return;
        }
        if(total==0){
        pbar1.reset(true);
        btn1.dom.disabled = false;
        Ext.fly('p1text').update('操作完成').show();
        return;
        }
        Runner.run(pbar1, total, function(){
            pbar1.reset(true);
            Ext.fly('p1text').update('').show();
            alert("操作完成!");
            window.location="permissionBatchActionInterim.jsp?id=<%=actionId%>&from="+document.all("from")(0).value+"&fromspan="+document.all("fromspan")(0).innerText+"&to="+document.all("to")(0).value+"&tospan="+document.all("tospan")(0).innerText;
        });
    });
});
function myLoad(){
     var myTable=document.getElementById("myTable");
     myTable.style.width=document.body.clientWidth-10;
	 if(myTable.rows(0).cells(0)!=null){
		 myTable.rows(0).cells(0).width=(document.body.clientWidth-10)*3.5/30;
		 myTable.rows(0).cells(1).width=(document.body.clientWidth-10)*6.5/30;
	 }
	 if(myTable.rows(0).cells(2)!=null){
		 myTable.rows(0).cells(2).width=(document.body.clientWidth-10)*3.5/30;
		 myTable.rows(0).cells(3).width=(document.body.clientWidth-10)*6.5/30;
	 }
	 if(myTable.rows(0).cells(4)!=null){
		 myTable.rows(0).cells(4).width=(document.body.clientWidth-10)*3.5/30;
		 myTable.rows(0).cells(5).width=(document.body.clientWidth-10)*6.5/30;
	 }
}
</script>
</head>
<body style="margin:10px,10px,10px,0px;padding:0px" onload="myLoad()">

<div id="divSearch" style="display:none" style="width:100%">
<div id="pagemenubar" style="z-index:100;">
<button type="button" id='btn1'class='btn' accessKey='C'><U>C</U>--处理</button>
        <div class="status" id="p1text" style="display:inline;"></div>
        <div id="p1" style="width:300px;display:inline"></div>
</div>


<!--页面菜单结束-->

    <form action="<%=action%>" id="EweaverForm" name="EweaverForm" method="post">
<%
    if(objType==2){
%>
    <input type="hidden" name="con<%=permissionBatchAction.getFieldid()%>_value" id="con<%=permissionBatchAction.getFieldid()%>_value" value="<%=hiddenValue%>">
<%
    }
%>
<TABLE ID=searchTable width="100%" height="100%" class="noborder">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
<tr class=Title>
</tr>
<tr>
    <td colspan="2">
    </td>
</tr>

				<tr <%if(objType==1){%>style='display:none'<%}%>>
					<td class="FieldName" nowrap>
					    <%=permissionBatchAction.getOperationObj()%>:
					</td>
					<td class="FieldValue">
                        <button type="button" class=Browser  onclick="javascript:getrefobj('from','fromspan','402881e70bc70ed1010bc75e0361000f','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
                        <input type="hidden" name="from"  id="from" value="<%=from%>"><span name="fromspan" id="fromspan"><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=from%>','<%=fromspan%>','tab<%=from%>')"><%=fromspan%></a><%if("".equals(from)){%><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle><%}%></span>
					</td>
				</tr>

				<tr>
					<td class="FieldName" nowrap>
					    <%=permissionBatchAction.getTargetObj()%>:
					</td>
					<td class="FieldValue">
                        <button type="button" class=Browser  onclick="javascript:getrefobj('to','tospan','402881e70bc70ed1010bc75e0361000f','<%= request.getContextPath()%>/humres/base/humresview.jsp?id=','1')"></button>
                        <input type="hidden" name="to"  id="to" value="<%=to%>"><span name="tospan" id="tospan"><a href="javascript:onUrl('/humres/base/humresview.jsp?id=<%=to%>','<%=tospan%>','tab<%=to%>')"><%=tospan%></a><%if("".equals(to)){%><img src="<%= request.getContextPath()%>/images/base/checkinput.gif" align=absMiddle><%}%></span>
					</td>
				</tr>
		        <tr>
                    <td class="FieldName" nowrap>
					    所属任务组中包含的其它任务:
					</td>
					<td class="FieldValue">
                    <%
                        List<PermissionBatchActionGroup> groupList = permissionBatchActionGroupService.find("from PermissionBatchActionGroup where permissionBatchActionIds like '%"+permissionBatchAction.getId()+"%' order by objorder");

                        if(groupList.size()>0){
                            PermissionBatchActionGroup permissionBatchActionGroup = groupList.get(0);
                            String permissionBatchActionids = permissionBatchActionGroup.getPermissionBatchActionIds();
                            List<String> list = StringHelper.string2ArrayList(permissionBatchActionids,",");
                            for(String aid : list){
                                if(!aid.equals(permissionBatchAction.getId())){
                                    PermissionBatchAction peraction = permissionBatchActionService.getPermissionBatchAction(aid);
                    %>
												<input type="checkbox" name="hasChoose"
													value="<%=peraction.getId()%>"/><%=peraction.getObjname()%>
                    <%
                                }
                            }
                        }
                    %>
                    </td>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
		        <tr class=Title>
					<th colspan=2 nowrap><b>操作说明</b></th>
		        </tr>
		        <tr>
					<td class="Line" colspan=2 nowrap>
					</td>
		        </tr>
				<tr>
					<td class="FieldValue" colspan=2>
					<TEXTAREA STYLE="width:100%" class=InputStyle rows=4 readonly="readonly"><%=permissionBatchAction.getObjdesc()%></TEXTAREA>
					</td>
				</tr>
</table>


     <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>"/>
<!--页面菜单开始-->
<%

paravaluehm.put("{reportid}",reportid);
pagemenustr += "{T,"+labelService.getLabelName("402881e60aa85b6e010aa862c2ed0004")+",javascript:onSearch2(),id='aaaaa'}";

PagemenuService _pagemenuService2 =(PagemenuService)BaseContext.getBean("pagemenuService");
pagemenustr += _pagemenuService2.getPagemenuStr(reportid,paravaluehm);



if(pagemenuorder.equals("0")) {
	pagemenustr =_pagemenuService2.getPagemenuStr(theuri,paravaluehm) + pagemenustr;
}else{
	pagemenustr = pagemenustr + _pagemenuService2.getPagemenuStr(theuri,paravaluehm);
}

String pagemenubarstr = _pagemenuService2.getPagemenuBarstr(pagemenustr);
pagemenubarstr=pagemenubarstr.replace("\\\"","\"") ;
%>
 <div id="pagemenubar2" style="z-index:100;">
 <%=pagemenubarstr%>
 </div>
 <!--页面菜单结束-->
 <!--条件>
 <%
 //隐藏初使查询条件
 String initsqlwhere = StringHelper.null2String(request.getAttribute("initsqlwhere"));
 String initquerystr = StringHelper.null2String(request.getAttribute("initquerystr"));
 String[] convalue = initquerystr.split("&");
 for(int i=0; i < convalue.length; i++){
     String tempcon = convalue[i];
     if(!StringHelper.isEmpty(tempcon)){
         String[] conv = tempcon.split("=");
         String con = conv[0];
         String vle = "";
         if(conv.length==2){
             vle = conv[1];
         }
         %>
         <input type='hidden' name="<%=con %>" value="<%=vle %>">
         <%
     }
 }
 %>
 <input type='hidden' name="sqlwhere" id="sqlwhere" value="<%=initsqlwhere %>">
 <input type='hidden' name="initquerystr" id="initquerystr" value="<%=initquerystr %>">

 <!--  ***************************************************************************************************************************-->
 <%
 //得到初使查询条件：

 Map hiddenMap = (Map)request.getAttribute("hiddenMap");
 String descorasc = StringHelper.null2String(request.getParameter("descorasc"));//表明前一次是升序还是降序？？
 if(descorasc.equals("desc")){
     descorasc = "asc";
 }else{
     descorasc = "desc";
 }
 String fieldopt = "";
 String fieldopt1 = "";
 String fieldvalue = "";
 String fieldvalue1 = "";

 ReportSearchfieldService reportsearchfieldService=(ReportSearchfieldService)BaseContext.getBean("reportSearchfieldService");

 List reportSearchfieldList = reportsearchfieldService.getReportsearchfieldByReportid2(reportid);
 List formfieldlist = new ArrayList();
 it = reportSearchfieldList.iterator();
 while(it.hasNext()){

     Reportsearchfield reportsearchfield = (Reportsearchfield) it.next();
     String formfieldid = reportsearchfield.getFormfieldid();
     Formfield formfield = formfieldService.getFormfieldById(formfieldid);
     if(formfieldid.equals(permissionBatchAction.getFieldid())&&objType==2){

     }
     else{
         formfieldlist.add(formfield);
     }
 }


 DataService	dataService = new DataService();
 String[] checkcons = request.getParameterValues("check_con");


  %>
 <%if(hiddenMap != null){
   for(Object o:hiddenMap.keySet()){
       String value=(String)hiddenMap.get(o);
 %>
       <input type='hidden' name="<%=o.toString() %>" id="initquerystr" value="<%=value %>">
 <%
   }
 }%>
   <table id="myTable" class=viewform>
     <%
 int linecolor=0;

 int tmpcount = 0;
 boolean showsep = true;

 Iterator fieldit = formfieldlist.iterator();
Map _fieldcheckMap=new HashMap();
while(fieldit.hasNext()){
  Formfield formfield = (Formfield)fieldit.next();
  String _htmltype = StringHelper.null2String(formfield.getHtmltype());
  String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
  String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
  String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }
  if(!_fieldcheck.equals("")&&!fieldvalue.equals("")){
     _fieldcheckMap.put(_fieldcheck,fieldvalue);
  }
}
 Iterator fieldit1 = formfieldlist.iterator();
 while(fieldit1.hasNext()){
     Formfield formfield = (Formfield)fieldit1.next();
     String id = formfield.getId();
     if(fieldsearchMap != null){
         fieldopt = (String)fieldsearchMap.get("con"+ id + "_opt");
         fieldopt1 = (String)fieldsearchMap.get("con"+ id + "_opt1");
         fieldvalue = (String)fieldsearchMap.get("con"+ id + "_value");
         fieldvalue1 = (String)fieldsearchMap.get("con"+ id + "_value1");

     }

     if(tmpcount%3==0){
 %>
 <tr class=title >
     <%
     }
 String htmltype = String.valueOf(formfield.getHtmltype());
 String type = formfield.getFieldtype();

 String _fieldid = StringHelper.null2String(formfield.getId());
 String _formid = StringHelper.null2String(formfield.getFormid());
 String _fieldname = StringHelper.null2String(formfield.getFieldname());
 String _htmltype = StringHelper.null2String(formfield.getHtmltype());
 String _fieldtype = StringHelper.null2String(formfield.getFieldtype());
 String _fieldattr = StringHelper.null2String(formfield.getFieldattr());
 String _fieldcheck = StringHelper.null2String(formfield.getFieldcheck());
 String _style ="";
 String _value="";

 String htmlobjname = _fieldid;
 %>
     <td  class="FieldName" nowrap>
 <%
 String name = formfield.getFieldname();
 name = "d."+name;
 String label = formfield.getLabelname();
 %>
       <%=StringHelper.null2String(label)%>
     <%
 if(htmltype.equals("1")){
     if(type.equals("1")){//文本
 %>
     <td  class="FieldValue" nowrap>
       <input type=text class=inputstyle size=30 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"/>
     </td>
    <%
    }else if(type.equals("2")){//整数
 %>
     <td  class="FieldValue" nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkInt_KeyPress()' >--到--
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1"   value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkInt_KeyPress()' >
     </td>
     <%
    }
    else if(type.equals("3")){//浮点数



    %>
     <td  class="FieldValue" nowrap>
       <input type=text class=inputstyle size=5 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onKeyPress='checkFloat_KeyPress()'>--到--
       <input type=text class=inputstyle size=5 name="con<%=id%>_value1" value="<%=StringHelper.null2String(fieldvalue1)%>" onKeyPress='checkFloat_KeyPress()'>
     </td>
     <%

    }
    else if(type.equals("4")){//日期

    %>
             <td  class="FieldValue" nowrap>
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value"  value="<%=StringHelper.null2String(fieldvalue)%>" onclick="WdatePicker()" >
                    -
                    <input type=text class=inputstyle size=10 name="con<%=id%>_value1"  value="<%=StringHelper.null2String(fieldvalue1)%>" onclick="WdatePicker()" >
                 </td>

     <%
    }
    else if(type.equals("5")){//时间
            StringBuffer sb = new StringBuffer("");
         sb.append("<td class='FieldValue' nowrap>");
         sb.append("<input type=\"text\" class=inputstyle size=10 name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\" onclick=\"WdatePicker({startDate:'%H:00:00',dateFmt:'H:mm:ss'})\" ");
         sb.append("</td>");
            out.print(sb.toString());
    }
      %>
 <%}
 else if(htmltype.equals("2")){//多行文本

 if(tmpcount%3==2){
 %>
     <td colspan=3  class="FieldValue" nowrap>
         <TEXTAREA style="width:200" ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
  <%}else{%>
     <td colspan=3  class="FieldValue" nowrap>
       <TEXTAREA style="width:100%"  ROWS="" COLS="50" name="con<%=id%>_value" value="<%=StringHelper.null2String(fieldvalue)%>"><%=StringHelper.null2String(fieldvalue)%></TEXTAREA>
     </td>
     <%}
 }
 else if(htmltype.equals("3")){//带格式文本


         //StringBuffer sb = new StringBuffer("");
         //sb.append("<td class='FieldValue'><input type=\"hidden\" name=\"field_"+_fieldid+"\"  value=\""+_value.replaceAll("\"","'")+"\" >");
         //sb.append("<IFRAME ID=\"eWebEditor"+_fieldid+"\" src=\"/plugin/ewe/ewebeditor.htm?id=field_"+_fieldid+"&style=eweaver\" frameborder=\"0\" scrolling=\"no\" "+_style+"></IFRAME></td>");
         //out.print(sb.toString());
 }

 else if(htmltype.equals("4")){//check框


 %>

     <td   class="FieldValue" nowrap>
             <INPUT TYPE="checkbox" NAME="con<%=id%>_value" value="1" <%if(StringHelper.null2String(fieldopt).equals("1")){%> checked <%}%> flag=0 onclick="gray(this)" >
     </td>

     <%}

 else if(htmltype.equals("5")){//选择项

             List list ;
             if(_fieldcheckMap.get(_fieldid)!=null){
             list = selectitemService.getSelectitemList(type,(String)_fieldcheckMap.get(_fieldid));
             }
             else
             list = selectitemService.getSelectitemList(type,null);
             StringBuffer sb = new StringBuffer("");
             sb.append("<input type=\"hidden\" name=\"field_"
                             + _fieldid + "_fieldcheck\" value=\"" + _fieldcheck + "\" >");
             sb.append("<td class='FieldValue'>\n\r <select class=\"inputstyle2\" id=\"con"+_fieldid+"_value\"  name=\"con"+_fieldid+"_value\" "+_style+" onchange=\"fillotherselect(this,'" + _fieldid
							+ "',"+ "-1" +")\"  >");
             String _isempty = "";
             if(StringHelper.isEmpty(fieldvalue))
                 _isempty = " selected ";
             sb.append("\n\r<option value=\"\" "+_isempty +" ></option>");
             for(int i=0;i<list.size();i++){
                 Selectitem _selectitem = (Selectitem)list.get(i);
                 String _selectvalue = StringHelper.null2String(_selectitem.getId());
                 String _selectname = StringHelper.null2String(_selectitem.getObjname());
                 String selected = "";
                 if(_selectvalue.equalsIgnoreCase(StringHelper.null2String(fieldvalue)))
                     selected = " selected ";
                 sb.append("\n\r<option value=\""+_selectvalue+"\" "+selected +" >"+_selectname+"</option>");
             }
             sb.append("</select>\n\r</td> ");
             out.print(sb.toString());

 }
 else if(htmltype.equals("6")){ // 关联选择

             Refobj refobj = refobjService.getRefobj(type);
             if(refobj != null){
                 String _refid = StringHelper.null2String(refobj.getId());
                 String _refurl = StringHelper.null2String(refobj.getRefurl());
                 String _viewurl = StringHelper.null2String(refobj.getViewurl());
                 String _reftable = StringHelper.null2String(refobj.getReftable());
                 String _keyfield = StringHelper.null2String(refobj.getKeyfield());
                 String _viewfield = StringHelper.null2String(refobj.getViewfield());

                 String showname = "";
                 if(!StringHelper.isEmpty(fieldvalue)){
                     String sql = "select " + _keyfield + " as objid," + _viewfield + " as objname from " + _reftable + " where " + _keyfield + " in(" + StringHelper.formatMutiIDs(StringHelper.null2String(fieldvalue)) + ")";
                     List valuelist = dataService.getValues(sql);

                     Map tmprefmap = null;
                     String tmpobjname = "";
                     String tmpobjid = "";

                     for(int i=0;i<valuelist.size();i++){
                         tmprefmap = (Map)valuelist.get(i);
                         tmpobjid = StringHelper.null2String((String) tmprefmap.get("objid"));
                         try{
                             tmpobjname = StringHelper.null2String((String) tmprefmap.get("objname"));
                         }catch(Exception e){
                             tmpobjname= ((java.math.BigDecimal)tmprefmap.get("objname")).toString();
                         }

                         if(!StringHelper.isEmpty(_viewurl)){//以里面定义为主

                             showname += "&nbsp;&nbsp;<a href=\""+ _viewurl + tmpobjid +"\" target=\"_blank\" >";
                             showname += tmpobjname;
                             showname += "</a>";

                         }else{
                             if(i==valuelist.size()-1){
                                 showname += tmpobjname;
                             }else{
                                 showname += tmpobjname + ", ";
                             }
                         }
                     }
                 }


                 String checkboxstr = "";
                 if("orgunit".equals(_reftable)){

                     String checked = "";
                     if(fieldsearchMap!=null&&StringHelper.null2String(fieldsearchMap.get("con" + id + "_checkbox")).equals("1")){
                         checked = "checked";
                     }
                     checkboxstr = "<input  type=\"checkbox\" name=\"con" + _fieldid+ "_checkbox\" value=\"1\" "+ checked +">";
                 }
                 StringBuffer sb = new StringBuffer("");
                 sb.append("<td class='FieldValue'> \n\r<button  type=button class=Browser onclick=\"javascript:getrefobj('con"+_fieldid+"_value','con"+_fieldid+"span','"+_refid+"','"+_viewurl+"','0');\"></button>");
                 sb.append("\n\r<input type=\"hidden\" name=\"con"+_fieldid+"_value\" value=\""+StringHelper.null2String(fieldvalue)+"\"  "+_style+"  >");
                 sb.append("\n\r<span id=\"con"+_fieldid+"span\" name=\"con"+_fieldid+"span\" >");
                 sb.append(showname);

                 sb.append("</span>\n\r").append(checkboxstr).append("</td> ");
                 out.print(sb.toString());

             }
 }
 else if(htmltype.equals("7")){ //附件
             StringBuffer sb = new StringBuffer("");
             sb.append("<td> \n\r<input type=\"hidden\" name=\"field_"+_fieldid+"\" value=\""+_value+"\" >");
             if(!StringHelper.isEmpty(_value)){
                 Attach attach = attachService.getAttach(_value);
                 String attachname = StringHelper.null2String(attach.getObjname());
                 sb.append("\n\r<a href=\""+request.getContextPath()+"/ServiceAction/com.eweaver.document.file.FileDownload?attachid="+_value+"\">"+attachname+"</a>");
             }
             sb.append("\n\r<input type=\"file\" class=\"inputstyle2\" name=\"con"+_fieldid+"file\" "+_style+" >\n\r</td> ");
             out.print(sb.toString());

 }

  if(linecolor==0) linecolor=1;
           else linecolor=0;

   if(htmltype.equals("2")){
     tmpcount += 2 ;
   }
   else{
     tmpcount += 1;
   }
 }%>
   </table>
 </form>
 </div>
<!-- 条件结束-->


  <script language="javascript" type="text/javascript">
   function onSearch(pageno){
          document.EweaverForm.pageno.value=pageno;
       document.EweaverForm.submit();
   }
   function createexcel(){
          document.EweaverForm.action="<%= request.getContextPath()%>/ServiceAction/com.eweaver.workflow.report.servlet.ReportAction?action=createexcel&reportid=<%=reportid%>&exportflag=";
       document.EweaverForm.submit();
   }

   function onSearch2(){
<%
    if(objType==2){
%>
        if(document.all("from")(0).value==""){
        alert("搜索前必须选择<%=operationObj%>!");
        return;
        }
        document.all("con<%=permissionBatchAction.getFieldid()%>_value")(0).value = document.all("from")(0).value;
<%
    }
%>
       var o=$('#EweaverForm').serializeArray();
       var data={};
       for(var i=0;i<o.length;i++) {
           if(o[i].value!=null&&o[i].value!=""){
           data[o[i].name]=o[i].value;
           }
       }

       selected=new Array();
       store.baseParams=data;
       store.load({params:{start:0, limit:<%=pageSize%>}});
   }
     $(document).keydown(function(event) {
       if (event.keyCode == 13) {
          onSearch2();
       }
   });
   function onSearch3(){
          document.all('EweaverForm')[0].action="<%= request.getContextPath()%>/workflow/report/reportsearch.jsp?reportid=<%=reportid%>";
       document.all('EweaverForm')[0].submit();
   }

   //点击按列排序
   function listorder(input){
          document.EweaverForm.action="<%=action2%>&orderfield=" + input + "&descorasc=<%=descorasc%>";
       document.EweaverForm.submit();
   }
   function fillotherselect(elementobj,fieldid,rowindex){
	var elementvalue = Trim(getValidStr(elementobj.value));//选择项的值


	var objname = "field_"+fieldid+"_fieldcheck";

	var fieldcheck = Trim(getValidStr(document.all(objname)[0].value));//用于保存选择项子项的值(formfieldid)

	if(fieldcheck=="")
		return;

//	DataService.getValues(createList(fieldcheck,rowindex),"select id,objname from selectitem where pid = '"+elementvalue+"'");

	var sql ="<%=SQLMap.getSQLString("base/security/permissionBatchActionInterim.jsp")%>";

	DataService.getValues(sql,{
      callback:function(dataFromServer) {
        createList(dataFromServer, fieldcheck,rowindex);
      }
   }
	);

}
    function createList(data,fieldcheck,rowindex)
	{
		var select_array =fieldcheck.split(",");
		for(loop=0;loop<select_array.length;loop++){
			var objname = "con"+select_array[loop]+"_value";
			if(rowindex != -1)
				objname += "_"+rowindex;

			if(document.all(objname)[0] == null){
				return;
			}
            removeAllOptions(document.all(objname)[0]);
            addOptions(document.all(objname)[0], data);
		    fillotherselect(document.all(objname)[0],select_array[loop],rowindex);
		}
	}
   function removeAllOptions(obj) {
       var len = obj.options.length;
       for (var i = len; i >= 0; i--) {
           obj.options[i] = null
       }
   }

   function addOptions(obj, data) {

       var len = data.length;
       for (var i=0; i<len; i++) {

           if(data[i].ID==null){
             data[i].ID="";
           }
           obj.options.add(new Option(data[i].OBJNAME,data[i].ID ));
       }
   }

    function doTransfer(actionId){
        from=document.all("from")[0].value;
        to=document.all("to")[0].value;

        var checkBoxs=document.getElementsByName("hasChoose");
        var checkboxStr = "";
        for(var i=0;i<checkBoxs.length;i++){
            if(checkBoxs[i].type=="checkbox"&&checkBoxs[i].checked){
                checkboxStr += checkBoxs[i].value + ",";
            }
        }
        DWREngine.setAsync(false);
        RightTransferService.permissionBatchAction(actionId,from,to,selected,checkboxStr,returnTotal);
        DWREngine.setAsync(true);

    }
    function returnTotal(o){
        total=o;
    }
    function returnCurrentCount(o){
        currentCount=o
    }
    function doRefresh(){
        RightTransferService.getCurrentCount(returnCurrentCount);
    }
       function gray(obj)
{
switch(obj.flag)
{
//当flag为0时,为未选中状态
case '0':obj.checked=true;obj.indeterminate=true;obj.flag='2';
      obj.value='2';
    break;
//当flag未1时,为白色选中状态
case '2':obj.checked=true;obj.indeterminate=false;obj.flag='1';
        obj.value='1';
    break;
//当flag为2时,为灰色选中状态  (找出所有的数据)
case '1':obj.checked=false;obj.indeterminate=false;obj.flag='0';
    obj.value='0';
    break;
}
}

function getrefobj(inputname,inputspan,refid,viewurl,isneed){
	var id;
    try{
    id=openDialog("<%=request.getContextPath()%>/base/popupmain.jsp?url=<%=request.getContextPath()%>/base/refobj/baseobjbrowser.jsp?id="+refid);
    }catch(e){}
	if (id!=null) {
	if (id[0] != '0') {
		document.all(inputname)[0].value = id[0];
		document.all(inputspan)[0].innerHTML = id[1];
        <%
    if(objType==2){
       %>
        if(inputname=='from'){
           document.all("con<%=permissionBatchAction.getFieldid()%>_value")[0].value = id[0];
           onSearch2();
        }
        <%
    }
      %>
    }else{
		document.all(inputname)[0].value = '';
        document.all("con<%=permissionBatchAction.getFieldid()%>_value")[0].value = "";
         onSearch2();
		if (isneed=='0')
		document.all(inputspan)[0].innerHTML = '';
		else
		document.all(inputspan)[0].innerHTML = '<img src=<%=request.getContextPath()%>/images/base/checkinput.gif>';

            }
         }
 }
</script>
<script type="text/javascript" language="javascript" src="<%= request.getContextPath()%>/datapicker/WdatePicker.js"></script>
</body>
</html>