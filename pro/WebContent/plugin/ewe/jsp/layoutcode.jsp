<%@page import="com.eweaver.base.util.NumberHelper"%>
<!doctype html>
<%
	int contentTableHeight = NumberHelper.string2Int(request.getParameter("contentTableHeight"));
	if(contentTableHeight == -1){
		contentTableHeight = 472;
	}else{
		contentTableHeight = contentTableHeight - 4;
	}
%>
<html>
<head>
	<script src="/js/CodeMirror/lib/codemirror.js"></script>
	<link rel="stylesheet" href="/js/CodeMirror/lib/codemirror.css">
	<script src="/js/CodeMirror/mode/xml/xml.js"></script>
	<script src="/js/CodeMirror/mode/javascript/javascript.js"></script>
	<script src="/js/CodeMirror/mode/css/css.js"></script>
	<script src="/js/CodeMirror/mode/htmlmixed/htmlmixed.js"></script>
	<!-- 
	<link rel="stylesheet" href="/css/global.css"> -->
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<style type="text/css">
		/**override CodeMirror style**/
		.CodeMirror-scroll {
		  height: <%=contentTableHeight%>px;
		}
		
		.CodeMirror-scrollbar {
		  SCROLLBAR-BASE-COLOR:#D3E5FA
		}
		
		/**修改高亮元素的属性颜色**/
		.cm-s-default span.cm-comment {color: #170;}	/*注释*/
		
		.cm-s-default span.cm-variable-2 {color: #00f;}	/*变量被引用时的样式*/
		
		html{
			overflow: hidden;
		}
	</style>
	<script>
	var myCodeMirror = null;
	function doCodeMirror(){
		var codeVal = document.body.innerText;
		document.body.innerText = "";
		myCodeMirror = CodeMirror(document.body, {
		  value: codeVal,
		  lineNumbers: true,
		  mode: "text/html",
		  tabMode: "indent",
		  lineWrapping: true
		});
		myCodeMirror.refresh();
	}
	</script>
</head>

<body style="overflow-x: hidden;overflow-y: hidden;">
</body>
<html>