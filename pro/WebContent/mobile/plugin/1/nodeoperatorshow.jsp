<%@ page contentType="text/html; charset=UTF-8"%>
<%
    String requestid = request.getParameter("requestid");
    String nodeid = request.getParameter("nodeid");
    String action=request.getContextPath()+"/mobile/plugin/showoperators.jsp?requestid=" + requestid + "&nodeid=" + nodeid;
%>

<html>
  <head>
  <style type="text/css">
  
		.prompt {
			color:#777878;
		}
		
		/* 列表区域 */
		.listArea {
			width:100%;
			background:#FAFBFD;
		}
		/* 列表项*/
		.listitem {
			width:100%;
			height:46px;
			background-color:#EFF2F6;
			border-bottom:1px solid #D8DDE4;
		}
		/* 列表项后置导航 */
		.itemnavpoint {
			float:right;height:100%;width:26px;text-align:center;
		}
		/* 列表项后置导航图  */
		.itemnavpoint img {
			width:10px;
			heigth:14px;
			margin-top:16px;
		}
		/* 流程创建人头像区域  */
		.itempreview {
			float:left;height:100%;width:40px;text-align:center;
		}
		/* 流程创建人头像  */
		.itempreview img {
			width:32px;height:32px;margin-top:7px;
		}
		
		/* 列表项内容区域 */
		.itemcontent {
			float:left;
			height:100%;
			font-size:14px;
		}
		
		/* 列表项内容名称 */
		.itemcontenttitle {
			height:23px;
			overflow-y:hidden;
			line-height:23px;
			font-weight:bold;
			word-break:keep-all;
			text-overflow:ellipsis;
			white-space:nowrap;
			overflow:hidden;
			font-size:14px;
		}
		
		/* 列表项内容简介 */
		.itemcontentitdt {
			height:23px;overflow-y:hidden;line-height:23px;font-size:12px;color:#777878;
			word-break:keep-all;
			text-overflow:ellipsis;
			white-space:nowrap;
			overflow:hidden;
		}
		/* 更多 */
		.listitemmore {
			text-align:center;line-height:46px;font-weight:bold;color:#777878;
		}
		/* 列表更新时间 */
		.lastupdatedate {
			width:100%;
			height:20px;
			text-align:right;
			font-size:12px;
			line-height:20px;
			background:#E1E8EC;
			background: -moz-linear-gradient(0, white, #E1E8EC);
			background:-webkit-gradient(linear, 0 0, 0 100%, from(white), to(#E1E8EC));
		}
		/* 间隔 */
		.blankLines {
			width:100%;
			height:1px;
			overflow:hidden;
		}
		
		/* 列表项标题 */
		.ictwz {
			float:left;
			word-break:keep-all;
			text-overflow:ellipsis;
			white-space:nowrap;
			overflow:hidden;
		}
		/* new */
		.ictnew {
			float:left;width:20px;
		}
  
  </style>
  	<script type="text/javascript" src="/js/jquery/1.6.2/jquery.min.js"></script>
    <script type="text/javascript" src="/mobile/plugin/1/js/script.js"></script>
    <script type="text/javascript">
    		var requestid = '<%=requestid%>';
    		var nodeid = '<%=nodeid%>';
    		$(document).ready(function () {
				//加载数据
				getDataList();
		});
		
		   function getDataList(){
    	    util.getDataByAction({
	    	"loadingTarget" : document.body,	    	
    		"paras" : "requestid=" + requestid + "&nodeid=" + nodeid,//得数据的URL,
    		"action":"/mobile/plugin/showoperators.jsp",
    		"callback" : function (data){
				if(data.error){
		    		$("#listArea").html("<div class=\"listitem listitemmore\">"+data.error+"</div><div class=\"blankLines\"></div>");		    		
				} else if(data.errormsg) {
				    $("#listArea").html("<div class=\"listitem listitemmore\">"+data.errormsg+"</div><div class=\"blankLines\"></div>");
				} else {				    									
					var length = data.datas.length;
					var listItemString = "<div id=\"pagecontent\">";
				for(var i = 0 ; i < length ; i ++) {
					var item = data.datas[i]
					var operaortype = item.operatortype;
					var operator= item.value;
					listItemString += " <div class=\"listitem\" >" +
									  " <div class=\"itemcontent\" >" +
									  " <div class=\"itemcontenttitle\">&nbsp;" + operaortype + "</div>" +
									  " <div class=\"itemcontentitdt\">&nbsp;&nbsp;" +operator+ "&nbsp;</div>" +
									  " </div>" +								
									  " </div>" +
							"<div class=\"blankLines\"></div>";
				}
				listItemString += "</div>";
				$("#listArea").html(listItemString);
					
					//设置列表宽度
					$(".itemcontenttitle").css("width", window.innerWidth - 85);
					$(".itemcontentitdt").css("width", window.innerWidth - 85);
				}
			}
	    });
	    }
    </script>
  </head>
  <body>
  <div class="listArea" id="listArea"></div>
  </body>
</html>
