<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.eweaver.base.BaseJdbcDao"%>
<%@page import="com.eweaver.base.BaseContext"%>
<%@page import="com.eweaver.base.security.service.acegi.EweaverUser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="org.springframework.dao.DataAccessException"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate"%>
<%@ page import="org.springframework.jdbc.datasource.DataSourceTransactionManager"%>
<%@ page import="org.springframework.transaction.*"%>
<%@ page import="org.springframework.transaction.PlatformTransactionManager"%>
<%@ page import="org.springframework.transaction.support.DefaultTransactionDefinition"%>
<%@ page import="org.springframework.transaction.TransactionStatus"%>
<%@page import="com.eweaver.base.orgunit.service.OrgunitService"%>
<%@page import="com.eweaver.base.orgunit.model.Orgunit"%>
<%
	BaseJdbcDao baseJdbcDao = (BaseJdbcDao)BaseContext.getBean("baseJdbcDao");
    EweaverUser eUser = BaseContext.getRemoteUser();
    HumresService humresService = (HumresService)BaseContext.getBean("humresService");
    OrgunitService orgunitService = (OrgunitService)BaseContext.getBean("orgunitService");
	String type = request.getParameter("type");

	
	String requestids = StringHelper.null2String(request.getParameter("requestids"));//私塾id
	
	Map basicinfo = null;
	List titleList = new ArrayList(); 
	List answerList = new ArrayList();
	String isnewadd = request.getParameter("isnewadd");
	String requestid ="";
	if(type==null){
		type="";
	}
	requestid = request.getParameter("requestid");
	if(type.equals("submit")){
		List<String> sqlList = new ArrayList();
		String tempSubjective=request.getParameter("tempSubjective");//是否主观题
		String tempAnwserWidth=StringHelper.null2String(request.getParameter("tempAnwserWidth"));//主观题文字长度
		String tempObjective=request.getParameter("tempObjective");//客观题
		if(tempObjective==null)
			tempObjective="0";
		else
			tempObjective="1";
		if(tempSubjective==null)
			tempSubjective="0";
		else
			tempSubjective="1";
		String tempIsmulti=request.getParameter("tempIsmulti");//是否多选
		if(tempIsmulti==null)
			tempIsmulti="0";
		else
			tempIsmulti="1";
		String tempRemark=StringHelper.null2String(request.getParameter("tempRemark"));//题干
		String isOtherRemark=request.getParameter("isOtherRemark");//补充选项说明
		if(isOtherRemark==null)
			isOtherRemark="0";
		else
			isOtherRemark="1";
		String otherRemark=StringHelper.null2String(request.getParameter("otherRemark"));//其他（请填写）
		String[] answser_Data=request.getParameterValues("answser");//客观选项
		List templist = baseJdbcDao.executeSqlForList("select nvl(max(seq),1)+1 seq from uf_qst_designertopic where requestid='"+requestid+"'");
		String seq="1";
		if(templist.size()>0)
			seq = StringHelper.null2String(((Map)templist.get(0)).get("seq"));
		
		String qstname = request.getParameter("questionairename");
		String bookman = request.getParameter("getnowuser");
		String bookdept = request.getParameter("getnowdept");
		String bookdate = request.getParameter("bookDate");
		if(requestid==null||requestid.length()<1){
			
			requestid = IDGernerator.getUnquieID();
			//插入formbase表
			String formbasesql = "insert into formbase(id,creator,createdate,createtime,modifier,modifydate,modifytime,isdelete,categoryid,col1,col2,col3) "+
			"values('"+requestid+"','"+eUser.getId()+"','"+DateHelper.getCurrentDate()+"','"+DateHelper.getCurrentTime()+"','','','',0,'','','','')";
			sqlList.add(formbasesql);
			
			//插入问卷设计主表
			String desimainsql = "insert into uf_qst_designermain(id,requestid,nodeid,rowindex,qstname,bookman,bookdept,orgid,qsttype,bookdate,isdelete) "+
			"values('"+IDGernerator.getUnquieID()+"','"+requestid+"','','','"+qstname+"','"+bookman+"','"+bookdept+"','"+bookdept+"','','"+bookdate+"',0)";
			sqlList.add(desimainsql);
		}else{
			
			String updatedesimainsql = "update uf_qst_designermain set qstname='"+qstname+"',bookman='"+bookman+"',bookdept='"+bookdept+"',orgid='"+bookdept+"',bookdate='"+bookdate+"' where requestid='"+requestid+"'";
			sqlList.add(updatedesimainsql);
		}
		
		if(isnewadd.equals("1")){
			
			//插入题目
			String topicid=IDGernerator.getUnquieID();
			sqlList.add("insert into uf_qst_designertopic(id,requestid,seq,anwserwidth,subjective,objective,ismulti,title) values" +
						"('"+topicid+"','"+requestid+"','"+seq+"',"+tempAnwserWidth+",'"+tempSubjective+"','"+tempObjective+"','"+tempIsmulti+"','"+StringHelper.filterSqlChar(tempRemark)+"')");
			//插入选项
			if(answser_Data!=null)
			{
				for(int i=0;i<answser_Data.length;i++)
				{
					sqlList.add("insert into uf_qst_designeritem(id,requestid,topicid,isother,anwserno,answser) values " +
						"('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+topicid+"',0,"+(i+1)+",'"+StringHelper.filterSqlChar(StringHelper.null2String(answser_Data[i]))+"')");
				}
				if(isOtherRemark.equals("1"))
				{
					sqlList.add("insert into uf_qst_designeritem(id,requestid,topicid,isother,anwserremark,anwserno) values " +
						"('"+IDGernerator.getUnquieID()+"','"+requestid+"','"+topicid+"',1,'"+StringHelper.filterSqlChar(otherRemark)+"',"+(answser_Data.length+1)+")");
				
				}
				
			}
		}
		if(sqlList.size()>0)
		{
			JdbcTemplate jdbcTemp=baseJdbcDao.getJdbcTemplate();
			PlatformTransactionManager tm = new DataSourceTransactionManager(jdbcTemp.getDataSource());  
			DefaultTransactionDefinition def =new DefaultTransactionDefinition(); 
			TransactionStatus status=tm.getTransaction(def); 
			try{ 
				jdbcTemp.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
				tm.commit(status);
			}catch(DataAccessException ex){
				tm.rollback(status);
				throw ex;
			}
		}
	}
	
	String className = "";
	String paperName = "";
	String questionameid = "";
	String questioname ="";
	String questionunitid ="";
	String questionunit ="";
	String nowDate ="";
	List qstlist = baseJdbcDao.executeSqlForList("select qstname,(select objname from selectitem where id=t.qsttype) qsttype,bookman,bookdept,bookdate from uf_qst_designermain t where requestid='"+requestid+"'");
	Map m =new HashMap();
	if(qstlist!=null && qstlist.size()>0){
		m = (Map)qstlist.get(0);
	}
	paperName=StringHelper.null2String(m.get("qstname"));
	String qsttype=StringHelper.null2String(m.get("qsttype"));

	nowDate=StringHelper.null2String(m.get("bookdate"));

	Humres huString = humresService.getHumresById(StringHelper.null2String(m.get("bookman")));
	questioname = StringHelper.null2String(huString.getObjname());
	Orgunit orgunit = orgunitService.getOrgunit(StringHelper.null2String(huString.getOrgid()));
    questionunit = StringHelper.null2String(orgunit.getObjname());
    
    String nowusername = eUser.getUsername();
    Humres humres = eUser.getHumres();
    String humresname = humres.getObjname();
    
    String nowuserdept = StringHelper.null2String(orgunitService.getOrgunitName(eUser.getOrgid()));
%>
<%@ include file="/base/init.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>调查问卷</title>
<script language="javascript" type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="../../culture/js/scroll.js"></script>
<link rel="stylesheet" href="../../culture/css/culture_association.css" type="text/css"></link>
<link rel="stylesheet" href="/culture/css/base.css" type="text/css"></link>
<script type="text/javascript" src="../../datapicker/WdatePicker.js"></script>
<script type="text/javascript" src="../../js/orgsubjectbudget.js"></script>
<script type="text/javascript" src="../../schedule/js/schedule.js"></script>
<script language="javascript">
var newQuestionIndex = 0;
function Chinese(num)  
{   
    if(!/^\d*(\.\d*)?$/.test(num))
 	{
  	alert("你输入的不是数字，请重新输入!");   
  	return false;
 	}    
    var AA= new Array("零","一","二","三","四","五","六","七","八","九"); 
    var BB = new Array("","十","百","千","万","亿","点","");               
    var a =(""+num).replace(/(^0*)/g,"").split("."), k=0, re = ""; 
    for(var i=a[0].length-1;i>=0;i--){   
    switch(k){ 
      case 0 :   
           re = BB[7] + re;break;   
      case 4 :   
           if(!new RegExp("0{4}\\d{"+ (a[0].length-i-1) +"}$").test(a[0]))   
             re = BB[4] + re;  
           break;   
      case 8 :  
           re = BB[5] + re;  
           BB[7] = BB[5];  
     	   k = 0;  
    	   break;   
      }   
      if(k%4 == 2 && a[0].charAt(i)=="0" && a[0].charAt(i+2) != "0") re = AA[0] + re;   
               if(a[0].charAt(i) != 0) re = AA[a[0].charAt(i)] + BB[k%4] + re;   
   k++;   
       }    
       if(a.length>1) {   
            re += BB[6];   
            for(var i=0; i<a[1].length; i++) re += AA[a[1].charAt(i)];   
       }   
     return re;   
}
function intToLetter(id){
    var k = (--id)%26//26代表A~Z 26个英文字母个数.
    var str = "";
    while(Math.floor((id=id/26))!=0){
        str = String.fromCharCode(k+65)+str;//65 代表'A'的ASCII值.
        k=(--id)%26;
    }
    //String.fromCharCode(num):求出num数值对应的字母.num应该为ASCII中的值.
    str = String.fromCharCode(k+65)+str;
    return str;
} 

function setCheckedByVlaue(obj){
	
	if($(obj).val()==1){
		$(obj).attr("checked",true);
	}else{
		$(obj).attr("checked",false);
	}
}
    
 function updateQuestionFun(obj){
	var currentTbody = $(obj).parent().parent().parent();
	var tbodyid = $(currentTbody).attr("id");
	//alert(tbodyid);
	//alert($("#"+tbodyid ).html());
	$("#tempRemark").val($("#"+tbodyid+" [name='remark']" ).val());
	$("#tempSubjectiveElemId").val($("#"+tbodyid+" [name='subjective']" ).val());
	$("#objectiveElemId").val($("#"+tbodyid+" [name='objective']" ).val());
	$("#tempAnwserWidthElemId").val($("#"+tbodyid+" [name='anwserWidth']" ).val());
	$("#tempIsmultiElemId").val($("#"+tbodyid+" [name='ismulti']" ).val());
	
	setCheckedByVlaue($("#tempSubjectiveElemId"));
	setCheckedByVlaue($("#objectiveElemId"));
	setCheckedByVlaue($("#tempIsmultiElemId"));
	
	
	var answserList = new Array();
	$("#"+tbodyid+" #answerSelectTd [name='answser']").each(function(i){
		answserList.push($(this).val());
	});
	var isOtherList = new Array();
	$("#"+tbodyid+" #answerSelectTd [name='isOther']").each(function(i){
		isOtherList.push($(this).val());
	});
	$("#selectItemTable tr").remove();
	//alert($("#selectItemTable tr").html());
	var nowSelectItemCount = 0 ;
	var hasOtherRemark = false;
	for(var i=0;i<answserList.length;i++){
	    if(isOtherList[i]=='1'){
	    	if(!$("#isOtherRemarkElemId").attr("checked"))
	        	document.getElementById("isOtherRemarkElemId").click();
	    	$("#otherRemarkElemId").val(answserList[i]);
	    	hasOtherRemark = true;
	    }else{
		   	nowSelectItemCount = $("#selectItemTable tr").length;
			$("#selectItemTable_Data #itemIndexTdElemId_Data").html(intToLetter(nowSelectItemCount+1)+":");
			$("#selectItemTable_Data [name='answser_Data']").val(answserList[i]);
			var table_data = $("#selectItemTable_Data tbody").html();
			//alert($("#selectItemTable_Data tbody").html());
			var tableHtml = table_data.replace(/_Data/g, "");
	    	$("#selectItemTable tbody").append(tableHtml);
    	}
	}
	if($("#isOtherRemarkElemId").attr("checked")&&!hasOtherRemark){
		//$("#isOtherRemarkElemId").val(0);
		document.getElementById("isOtherRemarkElemId").click();
	}
	
    $("#newQuestionElemId").val("确认修改");
    $("#newQuestionElemId").attr("updateIndex",tbodyid);
 }
function deleteQuestionFun(obj){
	var currentTbody = $(obj).parent().parent().parent();
	currentTbody.remove();
	var questionCount = parseInt($("#questionCountsSpanId").html());
	$("#questionCountsSpanId").html(questionCount-1);
	
	$("#selectViewTable [name='questionNo']").each(function(k){
			$(this).html(Chinese(k+1));
	});
}
function upLineFun(obj){
	var currentTbody = $(obj).parent().parent().parent();
	var prevTbody = $(obj).parent().parent().parent().prev();	
	$(prevTbody).before(currentTbody);
	$("#selectViewTable [name='questionNo']").each(function(k){
			$(this).html(Chinese(k+1));
	});
}
	
function downLineFun(obj){
	var currentTbody = $(obj).parent().parent().parent();
	var nextTbody = $(obj).parent().parent().parent().next();	
	$(nextTbody).after(currentTbody);
	$("#selectViewTable [name='questionNo']").each(function(k){
			$(this).html(Chinese(k+1));
	});
}
	


function setClassName(str){
	$("#tempTrainClassNameElemId").val(str);
}

function setQuesName(str){
	$("#tempQuestionairenameElemId").val(str);
}


function showOtherRemark(obj,trid){
	if($(obj).attr("checked")){
		$(obj).val(1);
		$("#otherRemarkElemId").val("其他（请填写）");
		$("#"+trid).show();
	}else{
		$(obj).val(0);
		$("#"+trid).hide();
	}
}

function addSelectItemFun(){
    var nowSelectItemCount = 0 ;
    nowSelectItemCount = $("#selectItemTable tr").length;
	$("#selectItemTable_Data #itemIndexTdElemId_Data").html(intToLetter(nowSelectItemCount+1)+":");
	$("#selectItemTable_Data [name='answser_Data']").val('');
	var table_data = $("#selectItemTable_Data tbody").html();
	var tableHtml = table_data.replace(/_Data/g, "");
    $("#selectItemTable tbody").append(tableHtml);
    //alert($("#selectItemTable").html());
}

function deleteItemFun(obj){
	var currentElement = $(obj).parent().parent();
	currentElement.remove()
	
	$("#selectItemTable [name='itemIndexTdElem']").each(function(i){
		$(this).html(intToLetter(i+1)+":");
	});
}
$(document).ready(function(){
 	$("#selectViewTable [name='questionNo']").each(function(k){
			$(this).html(Chinese(k+1));
	});
});

function addNewQuestion(obj){
	newQuestionIndex++;
    //题干
	var tempSubjective = $("#tempSubjectiveElemId").val();
	var tempAnwserWidth = $("#tempAnwserWidthElemId").val();
	var tempObjective =$("#objectiveElemId").val();
	var tempIsmulti =$("#tempIsmultiElemId").val();
	var tempRemark = $("#tempRemark").val();
	var isOtherRemark =$("#isOtherRemarkElemId").val();
	var otherRemark = $("#otherRemarkElemId").val();
	var questionCount=0;
	if($("#questionCountsSpanId").html()!=null){
		questionCount = parseInt($("#questionCountsSpanId").html());
	}
	$("#questionCountsSpanId").html(questionCount+1);
	var selectTitle_Data ="第<span name='questionNo'>"+Chinese(questionCount+1)+"</span>题：（";
	//客观主观题
	if(tempObjective==1&&tempSubjective==1){
		selectTitle_Data+="客观+主观题";
	}else if(tempObjective==1){
		selectTitle_Data+="客观题";
	}else if(tempSubjective==1){
		selectTitle_Data+="主观题";
	}
	selectTitle_Data+="，";
	//多选单选
	if(tempIsmulti==1){
		selectTitle_Data+="多选";
	}else{
		selectTitle_Data+="单选";
	}
	//selectTitle_Data+="，";
	if(tempSubjective==1){
		selectTitle_Data+="，答案限定在"+tempAnwserWidth+"个字以内";
	}
	selectTitle_Data+="）";
	//设置题干信息
	$("#selectTitle_Data").html(selectTitle_Data);
	$("#selectViewTable_Data [name='subjective_Data']").val(tempSubjective);
	$("#selectViewTable_Data [name='objective_Data']").val(tempObjective);
	$("#selectViewTable_Data [name='anwserWidth_Data']").val(tempAnwserWidth);
	$("#selectViewTable_Data [name='ismulti_Data']").val(tempIsmulti);
	$("#selectViewTable_Data [name='remark_Data']").val(tempRemark);
	
	
	//答案选项
	var nowSelectItemCount = 0 ;
    nowSelectItemCount = $("#selectItemTable tr").length;
    var allAnswerCount =nowSelectItemCount;
	var answerSelectTitleValue ="答案选项（共"+nowSelectItemCount+"个";
	if(isOtherRemark==1){
    	answerSelectTitleValue +="，有补充选项";
    	allAnswerCount+=1;
    }else{
    	answerSelectTitleValue +="，无补充选项";
    }
    answerSelectTitleValue +="）";
    //alert("allAnswerCount:"+allAnswerCount);
    $("#selectViewTable_Data [name='selectCount_Data']").val(allAnswerCount);
	$("#answerSelectTitleTd").html(answerSelectTitleValue);
	var answserObject = $("#selectItemTable [name='answser']");
	$("#answerSelectTd").html("");
	$("#selectItemTable [name='answser']").each(function(i){
		if(tempIsmulti==1){
			$("#selectTypeSpanId_Data [type='radio']").hide();
			$("#selectTypeSpanId_Data [type='checkbox']").show();
		}else{
			$("#selectTypeSpanId_Data [type='radio']").show();
			$("#selectTypeSpanId_Data [type='checkbox']").hide();
		}
		$("#answerGroupId_Data [name='answser_Data']").val($(this).val());
		$("#answerGroupId_Data [name='isOther_Data']").val(0);
		$("#answerGroupId_Data [name='otherWidth_Data']").val(0);
		$("#answerGroupId_Data #selectDisplayNameId_Data").html(intToLetter(i+1)+":"+$(this).val()+"&nbsp;");
		
		var group_data = $("#answerGroupId_Data").html()
		var groupHtml = group_data.replace(/_Data/g, "");
		$("#answerSelectTd").append(groupHtml);
	});
	if(isOtherRemark==1){
		$("#selectTypeSpanId_Data [type='radio']").hide();
		$("#selectTypeSpanId_Data [type='checkbox']").hide();
		$("#answerGroupId_Data [name='answser_Data']").val(otherRemark);
		$("#answerGroupId_Data [name='isOther_Data']").val(1);
		$("#answerGroupId_Data [name='otherWidth_Data']").val(tempAnwserWidth);
		$("#answerGroupId_Data #selectDisplayNameId_Data").html("补充选项:"+otherRemark);
		var group_data = $("#answerGroupId_Data").html()
		var groupHtml = group_data.replace(/_Data/g, "");
		$("#answerSelectTd").append(groupHtml);
	}
	var selectViewTable_data = $("#selectViewTable_Data").html();
	var selectViewTableHtml = selectViewTable_data.replace(/_Data/g, "");
	selectViewTableHtml = selectViewTableHtml.replace(/selectViewTbody/g, "selectViewTbody"+newQuestionIndex);
	var newQuestionValue = $("#newQuestionElemId").val();
	if(newQuestionValue=="确认修改"){
		updateIndex = $("#newQuestionElemId").attr("updateIndex");
		$("#selectViewTable #"+updateIndex).after(selectViewTableHtml);
		$("#"+updateIndex).remove(); 
	}else{
		$("#selectViewTable").append(selectViewTableHtml);
	}
	$("#selectViewTable [name='questionNo']").each(function(k){
			$(this).html(Chinese(k+1));
	});
	//重置
	$("#selectItemTable tr").remove();
	$("#tempRemark").val('');
	if($("#isOtherRemarkElemId").attr("checked")){
		document.getElementById("isOtherRemarkElemId").click();
	}
	if(newQuestionValue=="确认修改"){
		$("#newQuestionElemId").val("新增");
	}
	//alert($("#selectViewTable_Data").html());
}
  
function save(getobjval){
	if(getobjval==1){
		document.getElementById('isnewadd').value="1";
	}
	document.getElementById('type').value='submit';
	var tempSubjectiveobj=document.getElementById('tempSubjective');
	var tempAnwserWidthobj=document.getElementById('tempAnwserWidth');
	var tempObjectiveobj=document.getElementById('tempObjective');
	var tempRemarkobj=document.getElementById('tempRemark');
	var isOtherRemarkObj=document.getElementById('isOtherRemark');
	var otherRemarkobj=document.getElementById('otherRemark');
	var answser_DataObj=document.getElementsByName('answser');
	if(tempSubjectiveobj.checked&&tempAnwserWidthobj.value.length<1)
	{
		alert('主观题答案长度限制不能为空!');
		return;
	}
	if($('#questionaireNameElemId').val().length<1){
		alert("问卷名称不能够为空!");
		return;
	}
	if($('#fbper').val().length<1){
		alert("问卷设计人不能够为空!");
		return;
	}
	if($('#desigenerdpet').val().length<1){
		alert("设计人部门不能为空!");
		return;
	}
	if(getobjval==1){
	  if(tempRemarkobj.value.length<1) 
	  {
		alert('题干不能为空!');
		return;
	  }
	  if(tempSubjectiveobj.checked==false&!tempSubjectiveobj.checked==false){
		 alert("请选择题型!!!");
		return;
	  }
	}
	
	if(isOtherRemarkObj.checked&&otherRemarkobj.value.length<1)
	{
		alert('补充选项说明 内容不能为空!');
		return;
	}
	if(tempObjectiveobj.checked&&(answser_DataObj==null||answser_DataObj.length<1))
	{
		alert('客观题选择项目不能为空!');
		return;
	}
	if(tempObjectiveobj.checked)
	{
		for(var i=0; i<answser_DataObj.length;i++)
		{
			if(answser_DataObj[i].value.length<1){
				alert('客观题选择项目内容不能为空!');
				return;
			}
		}
	}
 	fm.submit();
}
function saveques(){
	$.ajax({
		type : "POST",
		url  : '/app/question/handQuestionDesigner.jsp',
		data : {
			 quesname : $('#questionaireNameElemId').val(),
			 quesperson : $('#fbper').val(),
			 quesdept : $('#desigenerdpet').val(),
			 quesdate : $('#bookDateElemId').val()
		},
	    success:function(message){}
	});
}
$(function(){
	$("#tempRemark").change(function(){
		 if($("#tempSubjectiveElemId").attr("checked")==false&$("#objectiveElemId").attr("checked")==false){
			 alert("请选择题型!是主观题还是客观题!");
			 return;
		 }
	});
});
function setCheckBoxVal(obj){
	if($(obj).attr("checked")){
		$(obj).val(1);
	}else{
		$(obj).val(0);
	}
}
function setCheckBoxValue(obj,obj2){
	if($(obj).attr("checked")==false){
		$(obj).attr("checked","true").val(1);
		$(obj2).val(0);
		return;
	}
	if($(obj).attr("checked")&&$(obj2).attr("checked")){
		$(obj).val(1);
		$(obj2).attr("checked","").val(0);
	}
}
</script>
</head>
<body>
<div>
<center>
<div id="header" align="center">
	<div class="ptextbox">
		<h2>问卷设计器</h2>
	</div>
</div>
<form action="" name="fm" method="post">
	<table style="width:750px;border-collapse: collapse;overflow: hidden;" border="1" cellspacing="1" bordercolor="#efefde">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr style="display: none">
						<td colspan="6">
							<input type="hidden" id="editTypeId" name="type" value="<%=type %>">
							<input type="hidden" id="requestid" name="requestid"
								value="<%=requestid %>">
							<input type="hidden" id="isnewadd" name="isnewadd" value="0"/>
						</td>
					</tr>
					<tr>
						<td width="8%" nowrap class="FieldName">
							问卷名称：
						</td>
						<td width="54%" colspan="5" class="FieldValue">
							<input type="text" class="InputStyle2" id="questionaireNameElemId" value="<%=paperName %>" onblur="setQuesName(this.value)"
								name="questionairename" style="width:80%" />
						<a href="javascript:void(0);" class="btn_attachBtns" onClick="save(0)" id="newasso"  style="text-decoration: none;"><span id="spanid">保 存</span></a>
						</td>
					</tr>
					<tr>
						<td width="10%" nowrap class="FieldName">
							问卷设计人：
						</td>
						<td width="20%" class="FieldValue">
		      				<input type="text" name="getnowuser" value="<%=humresname%>" id="fbper" style="border:0px;">
						</td>
						<td width="8%" nowrap class="FieldName" >
							问卷人单位：
						</td>
						<td width="20%" class="FieldValue">
		      				<input type="text" name="getnowdept" value="<%=nowuserdept%>"  id="desigenerdpet" style="border:0px;">
						</td>
						<td width="8%" nowrap class="FieldName">
							设计日期：
						</td>
						<td width="20%" class="FieldValue">
						   <%if("".equals(StringHelper.null2String(requestid))){ 
						   	  String gettodaydate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
						   %>
							 <input type="text" id="bookDateElemId" name="bookDate" 
								value="<%=gettodaydate %>" size="20" style="border:0px;" onclick="WdatePicker()"/>
							<%}else{%>
							  <input type="text" id="bookDateElemId" name="bookDate" 
								value="<%=nowDate %>" size="20"  style="border:0px;" onclick="WdatePicker()"/>
							<%} %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" bgcolor="">
					<tr>
						<td width="12%" nowrap class="Fieldvalue">
							<input type="checkbox" id="tempSubjectiveElemId" onclick="setCheckBoxValue(this,'#objectiveElemId')"
								name="tempSubjective" value="1" checked="checked"/>
							主观题：
						</td>
						<td width="22%" nowrap class="Fieldvalue">
							答案长度限制（字数）
						</td>
						<td width="30%" class="Fieldvalue">
							<input name="tempAnwserWidth" id="tempAnwserWidthElemId"
								value="200" type="text" class="InputStyle2"/>
						</td>
						<td width="35%" align="right" nowrap>
						<a href="javascript:void(0);" class="btn_attachBtns" onClick="save(1)" id="newasso"  style="text-decoration: none;"><span>保 存</span></a>
						</td>
					</tr>
					<tr>
						<td colspan="4" nowrap class="FieldValue">
							<input type="checkbox" id="objectiveElemId" name="tempObjective" onclick="setCheckBoxValue(this,'#tempSubjectiveElemId')"
								value="0"/>
							客观题 &nbsp;&nbsp;
							<input type="checkbox" id="tempIsmultiElemId" onclick="setCheckBoxVal(this)"
								name="tempIsmulti" value="0" />
							是否多选
						</td>
					</tr>
					<tr>
						<td colspan="4" class="FieldName" style="text-align: left;">
							题干
						</td>
					</tr>
					<tr>
						<td height="85" colspan="4" align="left" class="FieldValue">
							<textarea cols="120" id="tempRemark" rows="10" name="tempRemark" class="textarea"></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<a href="javascript:void(0);" class="btn_attachBtns" onClick="addSelectItemFun()" id="newasso" style="text-decoration: none;"><span>增 加</span></a>
						</td>
					</tr>
					<tr>
						<td colspan="4" class="FieldValue2">
							<table width="100%" border="0" cellspacing="2"
								id="selectItemTable_Data" style="display: none">
								<tbody>
									<tr>
										<td width="6%" id="itemIndexTdElemId_Data" name="itemIndexTdElem_Data">
											A：
										</td>
										<td width="24%">
											<input type="text" name="answser_Data" size="30" value=""
												width="100" />
										</td>
										<td width="52%">
										<a href="javascript:void(0);" class="btn_attachBtns" onClick="deleteItemFun(this)" id="newasso"  style="text-decoration: none;"><span>删 除</span></a>
										</td>
									</tr>
								</tbody>
							</table>
							<table width="100%" border="0" cellspacing="2"
								id="selectItemTable">
								<tbody></tbody>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="4" style="border-collapse:" class="FieldValue">
							<input type="checkbox" id="isOtherRemarkElemId" onclick="showOtherRemark(this,'otherRemarkTrElemId')"
								name="isOtherRemark" value="0" />
							补充选项说明
						</td>
					</tr>
					<tr id="otherRemarkTrElemId" style="display: none" class="FieldValue">
						<td colspan="4">
							<input id="otherRemarkElemId" name="otherRemark" type="text"
								value="其他（请填写）" size="50" width="50"  class="InputStyle2"/>
						</td>
					</tr>
					<tr id="otherRemarkTrElemId"  class="FieldValue" style="text-align: center;">
						<td colspan="4">
							<iframe style="width:100%;" src="/app/question/QuestionPreview.jsp?qstid=<%=requestid%>&sishuid=<%=requestids %>" scrolling="no" onload="Javascript:SetWinHeight(this)" frameborder="0"></iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</center>
</div>
</body>
</html>

