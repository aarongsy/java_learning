<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*, weaver.systeminfo.SystemEnv" %> 
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%@ page import="java.text.SimpleDateFormat,java.util.Date" %>


<%
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	User user = HrmUserVarify.getUser(request, response) ;//需要增加的代码
	int userid=user.getUID();                   //当前用户id
	int userid1= (HrmUserVarify.checkUser(request, response)).getUID();
	
	

	int requestid = Util.getIntValue(request.getParameter("requestid"));//请求id
	//int workflowid = Util.getIntValue(request.getParameter("workflowid"));//流程id
	int formid = Util.getIntValue(request.getParameter("formid"));//表单id
	formid = 0-formid;
	int isbill = Util.getIntValue(request.getParameter("isbill"));//表单类型，1单据，0表单
	//int nodeid = Util.getIntValue(request.getParameter("nodeid"));//流程的节点id
	
	rs.execute("select lastname from hrmresource where id='"+userid+"'"); 	
	rs.next();
	String curusername = Util.null2String(rs.getString("lastname"));
	

	 Date dt=new Date();
     SimpleDateFormat matter1=new SimpleDateFormat("yyyyMMdd");
     String today = matter1.format(dt);	
  
%>

<!-- Normal Fee Cash Requirement流程 301 -->
<script type="text/javascript"> 

   var userid = "<%=userid %>";
   var comtype = jQuery("#field10011").val();
jQuery(document).ready(function() {
	jQuery("#credetails").html("<input id='createid' type=\"button\" value=\"批量生成员工订餐明细\" />") ;
	jQuery("#createid").click(function(){
		alert("开始执行批量生成员工订餐明细");
		credetails(userid);
	});
	jQuery("#getid").html("<input id='getufdetailid' type=\"button\" value=\"获取员工订餐明细\" />") ;
	jQuery("#getufdetailid").click(function(){
		alert("开始执行获取员工订餐明细");
		getDetails(userid);
	});		
	
	if ( comtype!="101" ){ 
		jQuery("#boxid").html("<select id=\"selfoodid\">"+
			"<option value=1>早餐订餐</option>"+		
			"<option value=2>早餐送餐</option>"+
			"<option value=3>午餐订餐</option>"+
			"<option value=4>午餐送餐</option>"+
			"<option value=5>晚餐订餐</option>"+
			"<option value=6>晚餐送餐</option>"+
			"</select>"+
			"<input id='batchupid' type=\"button\" value=\"批量更新\" />"+
			"<input id='saveid' type=\"button\" value=\"保存订餐明细\" />"
		);
	} else { //常熟厂 无早餐送餐
		jQuery("#boxid").html("<select id=\"selfoodid\">"+
			"<option value=1>早餐订餐</option>"+				
			"<option value=3>午餐订餐</option>"+
			"<option value=4>午餐送餐</option>"+
			"<option value=5>晚餐订餐</option>"+
			"<option value=6>晚餐送餐</option>"+
			"</select>"+
			"<input id='batchupid' type=\"button\" value=\"批量更新\" />"+
			"<input id='saveid' type=\"button\" value=\"保存订餐明细\" />"
		);	
	}
	jQuery("#batchupid").click(function(){
		alert("开始执行批量更新");
		batchup();
	});		
	jQuery("#saveid").click(function(){
		alert("开始保存订餐明细到数据库");
		batchsave();
	});			
});

function batchsave(){
	var objNo = jQuery("input[name='node']");
	var objDataId = jQuery("input[name='dataid']");
	var objBreakfast = jQuery("input[name='breakfast']");
	var objBreakfastsend = jQuery("input[name='breakfastsend']");
	var objnoon = jQuery("input[name='noon']");
	var objnoonsend = jQuery("input[name='noonsend']");
	var objdinner = jQuery("input[name='dinner']");
	var objdinnersend = jQuery("input[name='dinnersend']");
	
	var arrNo = [];
	var arrDataId = [];
	var arrBreakfast = [];
	var arrBreakfastsend = [];
	var arrnoon = [];
	var arrnoonsend = [];
	var arrdinner = [];
	var arrdinnersend = [];
	var comtype = jQuery("#field10011").val();
	
	var list = [];
	
	for( var i=0;i<objNo.length;i++ ) {
		//alert(arrNo.eq(i).val() +"  "+arrDataId.eq(i).val()+" "+arrBreakfast.eq(i).attr("checked") +" "+arrnoon.eq(i).attr("checked") 
		//+" "+arrnoonsend.eq(i).attr("checked")  +" "+arrdinner.eq(i).attr("checked") 
		//+" "+arrdinnersend.eq(i).attr("checked") );
		arrNo.push(objNo.eq(i).val());
		arrDataId.push(objDataId.eq(i).val());
		
		arrBreakfast.push(objBreakfast.eq(i).attr("checked")?"1":"0");
		arrBreakfastsend.push(objBreakfastsend.eq(i).attr("checked")?"1":"0");
		arrnoon.push(objnoon.eq(i).attr("checked")?"1":"0");
		arrnoonsend.push(objnoonsend.eq(i).attr("checked")?"1":"0");
		arrdinner.push(objdinner.eq(i).attr("checked")?"1":"0");
		arrdinnersend.push(objdinnersend.eq(i).attr("checked")?"1":"0");
		var map={"No":arrNo[i],"Id":arrDataId[i],"Breakfast":arrBreakfast[i],"Breakfastsend":arrBreakfastsend[i],
				"noon":arrnoon[i],"noonsend":arrnoonsend[i],"dinner":arrdinner[i],"dinnersend":arrdinnersend[i]};
		 list.push(map);
	}
	//var strNo = arrNo.join(",");	
	//var strDataId = arrDataId.join(",");
	//var strBreakfast = arrBreakfast.join(",");
	//var strBreakfastsend = arrBreakfastsend.join(",");
	//var strnoon = arrnoon.join(",");
	//var strnoonsend = arrnoonsend.join(",");
	//var strdinner = arrdinner.join(",");
	//var strdinnersend = arrdinnersend.join(",");
	
	try {
		console.log("开始执行");
		
		//var js={"arrNo":arrNo,"arrDataId":arrDataId,"arrBreakfast":arrBreakfast,"arrBreakfastsend":arrBreakfastsend,
		//		"arrnoon":arrnoon,"arrnoonsend":arrnoonsend,"arrdinner":arrdinner,"arrdinnersend":arrdinnersend,"comtype":comtype}
		console.log(list);
        alert(list);
		jQuery.ajax({
			 url:"/interface/gd/unitfood/upUnitfoodDetails.jsp",
			 data: { "action":3,"list":JSON.stringify(list),"comtype":comtype,"userid":userid },
             type: "POST",
             dataType: "json",
             success: function(ret) {
               alert(ret);
				if(ret && ret.msg=="true"){
					alert("保存订餐明细ok");				 				
				}else{
					alert("执行保存订餐明细失败"+ret.errmsg + "成功明细序号："+ret.successNo+" 失败明细序号："+ret.errNo);		
				}
				//window.location.reload();
				getDetails(userid);

             }           
		
		})	
	
	
		/*jQuery Ajax方法
		
		var urls = "/interface/gd/unitfood/upUnitfoodDetails.jsp?action=3&strNo="+strNo
			+"&strDataId="+strDataId+"&strBreakfast="+strBreakfast+"&strBreakfastsend="+strBreakfastsend
			+"&strnoon="+strnoon+"&strnoonsend="+strnoonsend+"&strdinner="+strdinner+"&strdinnersend="
			+strdinnersend+"&userid="+userid+"&comtype="+comtype;
		alert(urls);
		jQuery.getJSON(urls,{
		   },function(ret){	
			//alert(ret);	
			if(ret && ret.msg=="true"){
				alert("保存订餐明细ok");				 				
			}else{
				alert("执行保存订餐明细失败"+ret.errmsg + "成功明细序号："+ret.successNo+" 失败明细序号："+ret.errNo);		
			}
			//window.location.reload();
			getDetails(userid);
		});
		*/
    } catch(e) {
   		alert("error");     
    }	
}

function batchup(){
	var selfood = jQuery("#selfoodid").val();
	
	var chkboxes = jQuery("input[name='checkbox']:checked");	
	if(selfood==""){
		alert("请选择批量修改方式!");
		return;
	} else if(chkboxes.length==0) {
		alert("请先选中明细");
		return;
	} else {
		var fieldname = "";
		var fieldname2 = "";		
		switch(selfood) {
			case "1": fieldname = "breakfast";  fieldname2="breakfastsend";	break;
			case "2": fieldname = "breakfastsend"; fieldname2="breakfast";	break;
			case "3": fieldname = "noon"; fieldname2="noonsend"; break;
			case "4": fieldname = "noonsend"; fieldname2="noon"; break;
			case "5": fieldname = "dinner"; fieldname2="dinnersend"; break;
			case "6": fieldname = "dinnersend"; fieldname2="dinner"; break;
			default: break;			
		}		
		chkboxes.each(function(i){		
			var idx =  jQuery(this).val();
			var str = jQuery("#"+fieldname+"_"+idx).parent("SPAN").css("display");			
			if (str!="none") {
				//alert("idx="+idx+" "+str+"修改值");
				if(fieldname!=""){
					jQuery("#"+fieldname+"_"+idx).attr("checked", true);
				}
				if(fieldname2!=""){
					jQuery("#"+fieldname2+"_"+idx).attr("checked", false);
				}
			}else{
				//alert("idx="+idx+" "+str+"不修改值");
			}
		});	
		alert("执行完成！");
	}
}

function credetails(userid){
	var empids = jQuery("#field10010").val();
	var sdate = jQuery("#field10008").val();
	var edate = jQuery("#field10009").val();
	var deptcode = jQuery("#field10006").val();
	var floornum = jQuery("#field10007").val();
	var comtype = jQuery("#field10011").val();
	var remark = jQuery("#field10012").val();
	if( deptcode=="" ) {
		alert("请先填写部门编号");
		return;
	}
	if( sdate=="" || edate=="") {
		alert("请先选择开始日期和结束日期");
		return;
	}	
	if( empids=="" || empids=="") {
		alert("请先选择员工");
		return;
	}		
	try {
			//jQuery Ajax方法
			var urls = "/interface/gd/unitfood/creUnitfoodDetails.jsp?action=1&empids="+empids
				+"&sdate="+sdate+"&edate="+edate+"&deptcode="+deptcode+"&floornum="+floornum+"&remark="+remark+"&userid="+userid;
			//alert(urls);
			jQuery.getJSON(urls,function(ret){					
				if(ret && ret.msg=="true"){
					if(ret.flag=="ok") {
						alert("模拟执行--执行ok, 获取明细");
						getDetails(userid);
					} 				
				}else{
					alert("执行ajax jsp失败"+ret.msg);		
				}
				//window.location.reload();
			});
	   } catch(e) {
	   		alert("error");     
	   }      
	
}


function getDetails(userid){
	var empids = jQuery("#field10010").val();
	var sdate = jQuery("#field10008").val();
	var edate = jQuery("#field10009").val();
	var deptcode = jQuery("#field10006").val();
	var floornum = jQuery("#field10007").val();
	var comtype = jQuery("#field10011").val();
	var remark = jQuery("#field10012").val();
	if( deptcode=="" ) {
		alert("请先填写部门编号");
		return;
	}
	if( sdate=="" || edate=="") {
		alert("请先选择开始日期和结束日期");
		return;
	}	
	if( empids=="" || empids=="") {
		alert("请先选择员工");
		return;
	}
	try {
		var url = "/interface/gd/unitfood/getUnitfoodDetails.jsp?action=2&empids="+empids
				+"&sdate="+sdate+"&edate="+edate+"&deptcode="+deptcode+"&floornum="+floornum+"&remark="+remark+"&jobnos=&userid="+userid+"&comtype="+comtype;
		//alert(url);
		jQuery.post(
			url,
			function(data){
           		jQuery("#detailhtml").html(data);
       		},
       	"JSONP"); 
    } catch(e) {
   		alert("error");
    } 
	//jQuery("#detailhtml").html = ;
}
</script>
