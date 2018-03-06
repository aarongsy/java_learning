<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/app/base/init.jsp"%>
<%@ include file="/base/init.jsp"%>
<%
	String year = request.getParameter("year");
	year = StringHelper.isEmpty(year)? DateHelper.getCurrentYear():year;
	String baseline = request.getParameter("baseline");
	BaseJdbcDao baseJdbc = (BaseJdbcDao) BaseContext.getBean("baseJdbcDao");
	if(!StringHelper.isEmpty(year) && !StringHelper.isEmpty(baseline)){
		baseJdbc.update("delete from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+year+"'");
		baseJdbc.update("insert into selectitem(id,objname,objdesc,typeid,isdelete) values('"+IDGernerator.getUnquieID()+
				"','"+year+"','"+baseline+"','2c91a0302f016469012f53f14d0a28f7',0)");
		out.println(labelService.getLabelNameByKeyId("402883d934ca4ec50134ca4ec70a0000")+"!");//设置成功!
	}
	if(StringHelper.isEmpty(baseline)){
		List<Map<String,Object>> value = baseJdbc.executeSqlForList("select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+year+"'");
		if(value!=null && !value.isEmpty())
			baseline = value.get(0).get("objdesc").toString();
	}
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0050") %><!-- 高新项目合同金额基准线设定 --></title>
		<script src='/dwr/interface/DataService.js'></script>
		<script src='/dwr/engine.js'></script>
		<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
		<style>
		ul li ol {
			margin-left: 10px;
		}
		
		table {
			width: auto;
		}
		
		.x-window-footer table,.x-toolbar table {
			width: auto;
		}
		</style>
	</head>

	<body>
		<div id="banner" style="width: 100%"></div>
		<form action="" name="BaselineForm" method="post">
			<div align="center" style="margin-top: 50px;">
				<table>
					<tr>
						<td><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0051") %><!-- 设定年份 -->:
						<input type="text" name="year" id="year" value="<%=year %>"/>
						<button type="button" onclick="chaxun()"><%=labelService.getLabelNameByKeyId("402883d934c173030134c17304630000") %><!-- 查询 --></button>
						</td>&nbsp;&nbsp;&nbsp;
						<td><%=labelService.getLabelNameByKeyId("402883d934c2275b0134c2275c7f0052") %><!-- 统计基准线 -->：
						<input type="text" name="baseline" id="baseline" value="<%=baseline %>"/>
						</td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>
<script type="text/javascript">
var tb = new Ext.Toolbar();
tb.render('banner');
addBtn(tb,'<%=labelService.getLabelNameByKeyId("402881e60aabb6f6010aabbda07e0009") %>','S','accept',function(){BaselineForm.submit()});//提交
addBtn(tb,'<%=labelService.getLabelNameByKeyId("297eb4b8126b334801126b906528001d") %>','C','erase',function(){window.parent.dlg0.hide();});//关闭
function chaxun(){
	var year = document.getElementById("year").value;
	DataService.getValue("select objdesc from selectitem where typeid='2c91a0302f016469012f53f14d0a28f7' and objname='"+year+"'",function(value){
		document.getElementById("baseline").value=value;
	})
}
</script>
