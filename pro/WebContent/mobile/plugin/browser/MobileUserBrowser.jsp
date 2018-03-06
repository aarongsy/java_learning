<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="MobileInit.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<LINK href="/mobile/plugin/browser/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery/1.6.2/jquery.min.js'></script>
</head>

<script type="text/javascript">

	function doClear() {
	 	document.getElementById("seclevel").value = "0";
	 	document.getElementById("relatedshareid").value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	}

	function onChangeSharetype(){
		var thisvalue=document.getElementById("sharetype").value;
		document.getElementById("relatedshareid").value=thisvalue;
		document.getElementById("showseclevel").style.display='';
		document.getElementById("showsecleveltr").style.display='';
		if(thisvalue==2){
			document.getElementById("showresource").style.display='';
			document.getElementById("showseclevel").style.display='none';
			document.getElementById("showsecleveltr").style.display='none';
		} else {
			document.getElementById("showresource").style.display='none';
		}		
		if(thisvalue==1){
		 	document.getElementById("showdepartment").style.display='';
		} else {
			document.getElementById("showdepartment").style.display='none';
		}
		doClear();
	}

	function onShowResource(input,span) {
		var result = window.showModalDialog("/mobile/plugin/browser/MutiResourceBrowser.jsp?browserType=resourceMulti&resourceids=2","","dialogWidth:550px;dialogHeight:550px;");		
		if (result != null) {
			if (result.id!= ""&&result.name!= "") {				
				document.getElementById(input).value=result.id;
				document.getElementById(span).innerHTML=result.name;				
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
		
		
	}

	function onShowDepartment(input,span) {
	    //组织架构树页面  page=HrmOrgTreeBrowser
	    var result = window.showModalDialog("/mobile/plugin/browser/MutiResourceBrowser.jsp?browserType=departmentMulti&resourceids=1","","dialogWidth:550px;dialogHeight:550px;");
	    if (result != null) {
			if (result.id!= ""&&result.name!= "") {					  		
			  document.getElementById(input).value=result.id;
			  document.getElementById(span).innerHTML=result.name;
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowRole(input,span) {
	    var result = window.showModalDialog("/mobile/plugin/browser/MutiResourceBrowser.jsp","","dialogWidth:550px;dialogHeight:550px;");
		if (result != null) {
			if (result.id!= ""&&result.name!= "") {
				document.getElementById(input).value=result.id.split(",");
				document.getElementById(span).innerHTML=result.name.split(",");
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="all";
		}
	}
	
	function dosave(){
	   var sharetype=jQuery("#sharetype").val();
	   var shareTypeName=jQuery("#sharetype").find("option:selected").text();
	   var relatedshareid=jQuery("#relatedshareid").val();
	   var shareName=jQuery("#showrelatedsharename").html();
	   var seclevel=jQuery("#seclevel").val();
	   var rolelevel=jQuery("#rolelevel").val();
	   var conditionStr=""
	   if(sharetype<3){
	      var shareValues=relatedshareid.split(",");
	      var shareValueNames=shareName.split(",");
	      if(shareValues.length < 1 || relatedshareid == '' ) {
	          alert('共享内容为空');
	          return;
	      }
	      for(var i=0;i<shareValues.length;i++){
	          var shareValue=shareValues[i];
	          var shareValueName=shareValueNames[i];
	          if(shareValue == '') {
	              continue;
	          }
	          conditionStr=conditionStr+",{authType:\'"+sharetype+"\',authTypeName:\'"+shareTypeName+"\',authValue:\'"+shareValue+"\',authValueName:\'"+shareValueName+"\',authSeclevel:\'"+seclevel+"\'}"
	      }
	      if(conditionStr.length>0) {
	          conditionStr=conditionStr.substr(1);
	      }	          
	   }else if(sharetype=3) {
	       shareName = '所有人';
	       shareValue=shareValue+rolelevel;
	       conditionStr=conditionStr+"{authType:\'"+sharetype+"\',authTypeName:\'"+shareTypeName+"\',authValue:\'"+relatedshareid+"\',authValueName:\'"+shareName+"\',authSeclevel:\'"+seclevel+"\'}"	   	
	   }
	   conditionStr="["+conditionStr+"]"
	   window.returnValue=conditionStr;
	   window.close();
	   
	}
	
	function checksecinput(id,span) {
		var val = jQuery('#'+id).val();
		if(isNaN(val)){
			jQuery('#'+span).html("请输入正确的安全级别");
			jQuery('#'+id).val(0);
		}
	}
</script>

<body style="overflow-y:hidden;padding: 0px;margin: 0px;">
  <div style="height:455px;overflow: auto;">
           <TABLE class=ViewForm  style="width: 100%">
              <COLGROUP>
              <COL width="30%">
              <COL width="70%">
              <TBODY>            
                  <TR>
                      <TD>共享类型</TD>
                      <TD class="Field">
                          <SELECT class=InputStyle name="sharetype" id="sharetype" onChange="onChangeSharetype()" >   
                              <option value="2" selected>人员</option> 
                              <option value="1">部门</option> 
                              <option value="3">所有人</option>    
                          </SELECT>
                      </TD>
                  </TR>
                  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
                  <TR>
                      <TD>共享内容</TD>
                      <TD class="Field">
                          <BUTTON type="button" class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource></BUTTON> 
                          <BUTTON type="button" class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment></BUTTON> 
                          <BUTTON type="button" class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole></BUTTON>
                          <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                          <span id=showrelatedsharename name=showrelatedsharename></span>                                            
                      </TD>
                  </TR>
                  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
                  <TR id="showroleleveltr" style="height:1px;display:none"><TD class=Line colspan=2></TD></TR>
                    <TR id=showseclevel style="display:none">
                      <TD>安全级别</TD>
                      <td class="field">
                           <INPUT type=text name="seclevel" id="seclevel" class=InputStyle size=6 value="0" onchange='checksecinput("seclevel","seclevelimage")'>
                           <span id=seclevelimage></span>
                      </td>
                  </TR>
                  <TR id="showsecleveltr" style="height:1px;display:none"><TD class=Line colspan=2></TD></TR>
              </TBODY>
          </TABLE>
     </div>     
     <div align="center" style="background:rgb(246, 246, 246);height: 40px;line-height: 40px;vertical-align: middle;padding-top: 8px;border-top:#dadee5 solid 1px;">
            <input type="button" value="确定" id="okBtn" onclick="dosave()">&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" value="取消" id="cancelBtn" onclick="window.close();">
     </div>
</body>
</html>