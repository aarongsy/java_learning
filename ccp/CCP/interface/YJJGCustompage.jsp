<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
 
	int requestid = Util.getIntValue(request.getParameter("requestid"));//请求id
	int workflowid = Util.getIntValue(request.getParameter("workflowid"));//流程id
	int formid = Util.getIntValue(request.getParameter("formid"));//表单id
	int isbill = Util.getIntValue(request.getParameter("isbill"));//表单类型，1单据，0表单
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));//流程的节点id
	String name = SystemEnv.getHtmlLabelName(197,user.getLanguage());//获取语言文字
	rs.execute("select nownodeid from workflow_nownode where requestid="+requestid); 
	rs.next();
	int nownodeid = Util.getIntValue(rs.getString("nownodeid"),nodeid);
	rs.execute("select nodeid from workflow_flownode where nodetype=0 and workflowid="+workflowid);
	rs.next();
	int onodeid = Util.getIntValue(rs.getString("nodeid"),0);
	 
	
%>
<!-- NR-样机加工流程 -->
<script type="text/javascript"> 
var width = document.body.clientWidth*0.9;
jQuery(document).ready(function() {
	//alert("<%=formid%>")
	jQuery("#field9508").bindPropertyChange(function(){
		jQuery("#field7045").val("ceshi");
	});
	
	//遍历明细1
	jQuery("#indexnum0").bind("propertychange",function(){
		bindfee1(1); 
	});
	bindfee1(2);

	
});
function bindfee1(value){
    var indexnum0 = 0; 
    if(document.getElementById("indexnum0")){
    	indexnum0 = document.getElementById("indexnum0").value * 1.0 - 1;
	}    
    if(indexnum0>=0){
		if(value==1){ //当前添加的行   
		 
	    	    jQuery("#field10127_"+indexnum0).bind("propertychange",function(){ 
				  jQuery("#field9007_"+indexnum0).val("1");
				});
	    	    
	    	  
		}else if(value==2){//初始化  
			  jQuery("input[name='check_node_0']").each(function(i) {
					var idl0 = this.value;   
					  jQuery("#field10127_"+idl0).bind("propertychange",function(){ 
						  jQuery("#field9007_"+idl0).val("2");
					});
			});
		}
	} 
}
//提交前判断
checkCustomize = function() {
	var submitdtlidArray= $G("submitdtlid0").value.split(',');
	for(var k=0; k<submitdtlidArray.length; k++){ 
		var idl0 = submitdtlidArray[k];   
		jQuery("#field10127__"+idl0).val(); 
	} 
	alert("<%=name%>");
	return false;
}
</script>