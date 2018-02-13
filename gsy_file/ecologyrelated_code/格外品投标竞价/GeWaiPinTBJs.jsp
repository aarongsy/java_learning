<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*, weaver.systeminfo.SystemEnv" %> 
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bs" class="weaver.general.BaseBean"/>
<%@ page import="java.text.SimpleDateFormat,java.util.Date" %>
<!-- 静态引入jsp -->
<!-- %@ include file="/interface/dccm/getCurrExRate.jsp" % -->
<!-- 动态引入jsp -->
<!--  jsp:include page="/interface/dccm/getCurrExRate.jsp"/-->
<%@page import="org.json.*"%>
<%
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	int userid=user.getUID();                   //当前用户id
	int userid1 = Util.getIntValue(request.getParameter("userid"), -1);
	

	int requestid = Util.getIntValue(request.getParameter("requestid"));//请求id
	int workflowid = Util.getIntValue(request.getParameter("workflowid"));//流程id
	int formid = Util.getIntValue(request.getParameter("formid"));//表单id
	int isbill = Util.getIntValue(request.getParameter("isbill"));//表单类型，1单据，0表单
	int nodeid = Util.getIntValue(request.getParameter("nodeid"));//流程的节点id
	
	//String name = SystemEnv.getHtmlLabelName(197,user.getLanguage());//获取语言文字
	rs.execute("select nownodeid from workflow_nownode where requestid="+requestid); 
	rs.next();
	int nownodeid = Util.getIntValue(rs.getString("nownodeid"),nodeid);
	rs.execute("select nodeid from workflow_flownode where nodetype=0 and workflowid="+workflowid);
	rs.next();
	int onodeid = Util.getIntValue(rs.getString("nodeid"),0);
     
%>

<script type="text/javascript"> 

jQuery(document).ready(function() {

	alert("<%=nownodeid %>");
	if ( "<%=nownodeid %>"=="361"){  //
	
		document.getElementById("field7790browser").style.display="none";	
		jQuery("#field7787").bindPropertyChange(function(){
			document.getElementById("field7790").value=document.getElementById("field7787").value;
			document.getElementById("field7790span").innerHTML=document.getElementById("field7787").value;
		});
		
		xianshitime();
		
	}
	
});

function xianshitime()  //蓝色字体时间显示
{
	
	/*
	<%
  		String sql1 = "select to_char(sysdate,'yyyy-MM-dd HH24:mi:ss') as sys from dual";
  		rs.execute(sql1);   		
		rs.next();
		String sysdate = Util.null2String(rs.getString("sys"));
  	%>
	var sysdate="<%=sysdate%>";
	*/
	var sysdate;
	jQuery.ajax({ 
        async:false,
        type:'get',                 
        url:'/interface/trade/GeWaiPin/SysTimeJs.jsp',                
        cache:false,    
        dataType:'json',        
        success: function(res) {  
            sysdate=res.sysdate;      
        }    
    });  
	
    var strday1=sysdate.split("-");
	var strday11=strday1[2].split(" ");
    var date1=new Date();
    date1.setFullYear(strday1[0],strday1[1]-1,strday11[0]);
    var time1=date1.getTime();

    var date22=document.getElementById("field7786").value;
    var strday2=date22.split("-");
    var date2=new Date();
    date2.setFullYear(strday2[0],strday2[1]-1,strday2[2]);
    var time2=date2.getTime();

    var chazhi1=time2-time1;

    document.getElementById("field7791").value=strday11[1];
    document.getElementById("field7791span").innerHTML=strday11[1];

    var starttime=document.getElementById("field7787").value;
    var nowtime=document.getElementById("field7791").value; 

    if(starttime!="")
    {
        var nstr=nowtime.split(":");  
        var strnowtime=parseInt(nstr[0]*60*60)+parseInt(nstr[1]*60)+parseInt(nstr[2]);  

        var str=starttime.split(":"); 
        var strstarttime=parseInt(str[0]*60*60)+parseInt(str[1]*60); 
        var yue=parseInt(chazhi1/1000)+strstarttime-strnowtime;

        if(yue>0)
        {
            var fen=parseInt(yue/60);
            var miao=parseInt(yue-fen*60);
        }
        else
        {
            var fen=0;
            var miao=0;
        }
        var current1=fen+" 分 "+miao+"秒";

        document.getElementById("field7792").value=current1;
        document.getElementById("field7792span").innerHTML=current1;
    }

    var checkboxes=document.getElementsByName("check_node_0");
    for(var i=0;i<checkboxes.length;i++)
    {
        var idx=checkboxes[i].value;
        document.getElementById("field8043_"+idx).readOnly=true;
        document.getElementById("field8043_"+idx).style.display="none";
        document.getElementById("field8043_"+idx).value=i+1;
        document.getElementById("field8043_"+idx+"span").innerHTML=i+1;
    }
    document.getElementById("field7785").readOnly=true;
    document.getElementById("field7785").style.display="none";
    document.getElementById("field7785").value=checkboxes.length; 
    document.getElementById("field7785span").innerHTML=checkboxes.length;

    var checkboxes2=document.getElementsByName("check_node_1");
    for(var j=0;j<checkboxes2.length;j++)
    {
        var idx2=checkboxes2[j].value;
        document.getElementById("field8044_"+idx2).readOnly=true;
        document.getElementById("field8044_"+idx2).style.display="none";
        document.getElementById("field8044_"+idx2).value=j+1;
        document.getElementById("field8044_"+idx2+"span").innerHTML=j+1;
    }

	setTimeout("xianshitime()",1000); 

}




//提交前判断
checkCustomize = function() {

}

       

</script>
