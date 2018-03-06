<!DOCTYPE HTML>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/base/init.jsp"%>
<%@ page import="com.eweaver.base.selectitem.model.Selectitem"%>
<%@ page import="com.eweaver.workflow.workflow.service.WorkflowinfoService"%>
<%@ page import="com.eweaver.workflow.form.service.FormlayoutService"%>
<%@ page import="com.eweaver.base.setitem.model.Setitem"%>
<%@ page import="com.eweaver.base.selectitem.service.SelectitemService"%>
<%@ page import="com.eweaver.workflow.form.model.Formlayout"%>
<%@ page import="com.eweaver.workflow.request.jqgrid.JQGridConstant"%>
<html>
  <head>
  	<style type="text/css">
	   .x-toolbar table {width:0}
	   #pagemenubar table {width:0}
	   .x-panel-btns-ct {padding: 0px;}
	   .x-panel-btns-ct table {width:0}
	 </style>
	<script type="text/javascript" src="/js/jquery/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/qtip/jquery.qtip.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/form/jquery.form.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/fix.clone/jquery.fix.clone.js"></script>
	<link href="/js/jquery/plugins/qtip/jquery.qtip.min.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="/js/eweaverSwitch.js"></script>
	<script type="text/javascript" src="/js/ext/ux/toolbar.js"></script>
	<script type="text/javascript" src="/js/ext/ux/iconMgr.js"></script>
	<script type="text/javascript" language="javascript" src="/datapicker/WdatePicker.js" ></script>
	<script src='/dwr/interface/HumresService.js'></script>
	<script src='/dwr/engine.js'></script>
	<script src='/dwr/util.js'></script>
	<link type="text/css" rel="stylesheet" href="/base/setitem/css/syssetting.css"/> 
	<script type="text/javascript" src="/base/setitem/js/syssetting.js"></script>
	
	<script type="text/javascript">
		<%!
			private String getOptionHtmlWithLayout(){
				StringBuffer html = new StringBuffer();
				String hql = "from Formlayout where formid='402881e80c33c761010c33c8594e0005'";
				FormlayoutService formlayoutService = (FormlayoutService) BaseContext.getBean("formlayoutService");
				List layoutList = formlayoutService.findFormlayout(hql);
				for(int i = 0; i < layoutList.size(); i++){
					Formlayout formlayout = (Formlayout)layoutList.get(i);
					html.append("<option value=\""+formlayout.getId()+"\">"+formlayout.getLayoutname()+"</option>");
                }
				return html.toString();
			}
		%>
		<%
			SetitemService setitemService = (SetitemService) BaseContext.getBean("setitemService");
		    SelectitemService selectitemService = (SelectitemService) BaseContext.getBean("selectitemService");
		    DataService dataService = new DataService();
		    /*****通讯*****/
			Setitem setitem1 = setitemService.getSetitem("4028819d0e52bb04010e5342dd5a0048");	//是否使用即时通讯
			Setitem setitem2 = setitemService.getSetitem("0f6163a0d13c49b6aba3c9f6c9fb3e37");	//即时通讯类型
			Setitem setitem3 = setitemService.getSetitem("86043639f1484116a3d0cd5718d41ce7");	//Domain Name
			Setitem setitem4 = setitemService.getSetitem("402881a10e5a107c010e5a5e41540039");	//即时通讯服务器地址 
			Setitem setitem5 = setitemService.getSetitem("402881a10e5a107c010e5a5ec0d5003b");	//即时通讯服务器端口
			Setitem setitem6 = setitemService.getSetitem("402881a10e5e787f010e5f1eabeb0011");	//是否使用手机短消息
			Setitem setitem81 = setitemService.getSetitem("402883213fe5804e013fe58054ef0000");	//短信接口类型
			Setitem setitem82 = setitemService.getSetitem("402883213fe5804e013fe58054ef0001");	//短信接口接连IP
			Setitem setitem83 = setitemService.getSetitem("402883213fe5804e013fe58054f00002");	//短信接口访问端口
			Setitem setitem84 = setitemService.getSetitem("402883213fe5804e013fe58054f00003");	//短信接口账号
			Setitem setitem85 = setitemService.getSetitem("402883213fe5804e013fe58054f00004");	//短信接口密码
			
			Setitem setitem7 = setitemService.getSetitem("402881a10e5e787f010e5f1f4a4e0013");	//是否使用邮件
			Setitem setitem8 = setitemService.getSetitem("402881aa0ec16e29010ec1737ce20004");	//邮件服务器地址
			Setitem setitem9 = setitemService.getSetitem("402881aa0ec16e29010ec174315d0007");	//邮件服务器端口号
			Setitem setitem10 = setitemService.getSetitem("4028835a3845652d013845652e3c0023");	//SMTP邮件地址
			Setitem setitemSMTPIsAuth = setitemService.getSetitem("611bb1e35b5d417198616a5c59610c94");	//是否需要认证
			Setitem setitem11 = setitemService.getSetitem("402881aa0ec16e29010ec175e1ad000d");	//SMTP账户
			Setitem setitem12 = setitemService.getSetitem("402881aa0ec16e29010ec1769f8f0011");	//SMTP账户密码
			Setitem setitem13 = setitemService.getSetitem("4028830838b303c00138b303c50b026e");	//url前缀
			/*****文档*****/
			Setitem setitem14 = setitemService.getSetitem("402881e50b14f840010b14fbae82000a");	//文档是否压缩
			Setitem setitem15 = setitemService.getSetitem("402881e80b7544bb010b754c7cd8000a");	//文件保存路径
			Setitem setitem16 = setitemService.getSetitem("402881e50b14f840010b14fbae82000b");	//启用附件大小控件检测
			Setitem setitem17 = setitemService.getSetitem("402881e50b14f840010b153bbc17000b");	//文档附件大小
			Setitem setitema1 = setitemService.getSetitem("402883213f26c03c013f26c03cf40000");	//启用图片附件大小控件检测
			Setitem setitema2 = setitemService.getSetitem("402883213f26c03c013f26c03cf40001");	//图片附件大小
			Setitem setitem18 = setitemService.getSetitem("40288183121d455601121d5c78640053");	//FTP上传文件目录(区分大小)
			Setitem setitem19 = setitemService.getSetitem("82bb8269e5054f449bfd82a68cf85287");	//门户文档元素是否显示总记录数
			Setitem setitem20 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt092");	//是否使用文档借阅
			Setitem setitem22 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt094"); 	//借阅开始时间标识字段
		    Setitem setitem23 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt095");	//借阅结束时间标识字段
		    Setitem setitem24 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt097");	//文档标识字段
		    Setitem setitem25 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt099");	//借阅人标识字段
		    Setitem setitem26 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt100");	//是否永久借阅标识字段
		    Setitem setitem27 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt101");	//审批是否同意标识字段
		    Setitem setitem28 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt096");	//其他后缀标识条件
		    /*****安全(用户登录)*****/
		    Setitem setitem29 = setitemService.getSetitem("402881e40ac0e0b2010ac13ff4ee0003");	//登录是否使用验证码
		    Setitem setitem30 = setitemService.getSetitem("4028836134c18c690134c18c6b680000");	//是否启用内网IP登陆限制
		    
		    Setitem setitem31 = setitemService.getSetitem("402888534deft8d001besxe952edgy15");	//是否使用动态密码
			String sql = "select * from dynamicpassrule where setitemid='402888534deft8d001besxe952edgy15'";
		    List dataList = dataService.getValues(sql);
			Map data = new HashMap();
			if(!dataList.isEmpty()){
				data = (Map)dataList.get(0);
			}
			String passrule = data.get("passrule") == null ? "2" : data.get("passrule").toString(); //规则
			String passcount = data.get("passcount") == null ? "" : data.get("passcount").toString(); //位数
			String ispassmodel = data.get("ispassmodel") == null ? "" : data.get("ispassmodel").toString(); //是否明码输入
			
			Setitem setitem32 = setitemService.getSetitem("297e930d347445a101347445ca4e0000");	//是否首次登录修改密码
			String sql2 = "select * from dynamicpassrule where setitemid='297e930d347445a101347445ca4e0000'";
			List dataList2 = dataService.getValues(sql2);
			Map data2 = new HashMap();
			if(!dataList2.isEmpty()){
				data2 = (Map)dataList2.get(0);
			}
			String updatepassrule = data2.get("passrule") == null ? "2" : data2.get("passrule").toString(); //规则
			String updatepasscount = data2.get("passcount") == null ? "" : data2.get("passcount").toString(); //位数
			
			Setitem setitem33 = setitemService.getSetitem("ff808081349eb5d201349eb5e2890002");	//设置密码有效期
			Setitem setitem34 = setitemService.getSetitem("402880e71284a7ed011284fcf3de0012");	//登录名是否区分大小写
			Setitem setitem35 = setitemService.getSetitem("402888534deft8d001besxe952edgy16");	//是否允许userkey登录
			Setitem setitem65 = setitemService.getSetitem("40288347363855d101363855d2030293");	//是否启用IM
			PropertiesHelper propertiesHelper = new PropertiesHelper();
			boolean isEnabledWeaverim = propertiesHelper.isEnabledWeaverim();	//是否启动IM的配置开关
			/*****日志*****/
			Setitem setitem36 = setitemService.getSetitem("402881e50fab280d010fac26316e003c");	//查看日志记录时间间隔
			/*****工作流*****/
			Setitem setitem74 = setitemService.getSetitem("402883ee3ee8d73a013ee8d73b850000");	//是否显示流转记录
			Setitem setitem38 = setitemService.getSetitem("4089487d23f9e66e0123ffe23303253b");	//是否显示下拉列表个人签字意见
			Setitem setitem39 = setitemService.getSetitem("402880311e723ad0011e72782a0d0005");	//是否图形化设计流程
			Setitem setitem40 = setitemService.getSetitem("402880369e583ad001besxe82a0d0005");	//是否用新的出口条件设计
			Setitem setitem41 = setitemService.getSetitem("402888534deft8d001besxe952edgy17");	//是否允许知会人转发
			Setitem setitem42 = setitemService.getSetitem("402888534deft8d001besxe952edgy18");	//是否允许历史操作者转发
			Setitem setitem43 = setitemService.getSetitem("402888534deft8d001besxe952edgy19");	//是否允许知会的流程没提交一直在待办中
			Setitem setitem70 = setitemService.getSetitem("402883053c2242e0013c2242e6f3025d");	//是否允许转发时邮件提醒
			Setitem setitem44 = setitemService.getSetitem("40288856895ft8d001bece2952edgy17");	//是否允许从邮件中直接查看流程
			Setitem setitem45 = setitemService.getSetitem("40288856895ft8d001beceezxse22952");	//流程保存时是否检查必填
			Setitem setitem46 = setitemService.getSetitem("402883c9369ff2be01369ff2c8a5026f");	//流程是否显示编号
			Setitem setitem47 = setitemService.getSetitem("dd4851f9f7c84bcaa83f3f1273bdf869");	//只显示一次流转记录
			Setitem setitem48 = setitemService.getSetitem("40288183120ddca401120de9f4dc0006");	//新建流程隐藏的流程类型
			Setitem setitem63 = setitemService.getSetitem("4028833039d773910139d7739b370000");	//是否启用新待办
			Setitem setitem   = setitemService.getSetitem("402883bd3d00dd0d013d00dd16690000");  //是否启用流程版本功能
			/*****人力资源*****/
			Setitem setitem49 = setitemService.getSetitem("402880e71284a7ed011284fa24910007");	//人力资源管理员创建布局
			Setitem setitem50 = setitemService.getSetitem("402880e71284a7ed011284fae5ad0010");	//人力资源本身查看布局
			Setitem setitem66 = setitemService.getSetitem("402881e53b07e3ab013b07e3b3e30283");	//人力资源本身自定义查看页面
			Setitem setitem51 = setitemService.getSetitem("402880e71284a7ed011284fae5ad0011");	//人力资源上级查看布局
			Setitem setitem67 = setitemService.getSetitem("402881e53b07e3ab013b07e3b3e40284");	//人力资源上级自定义查看页面
			Setitem setitem52 = setitemService.getSetitem("402880e71284a7ed011284fae5ad0009");	//人力资源通用查看布局
			Setitem setitem68 = setitemService.getSetitem("402881e53b07e3ab013b07e3b3e40285");	//人力资源通用自定义查看页面
			Setitem setitem53 = setitemService.getSetitem("402880e71284a7ed011284fb84a6000b");	//人力资源管理员查看布局
			Setitem setitem69 = setitemService.getSetitem("402881e53b07e3ab013b07e3b3e40286");	//人力资源管理员自定义查看页面
			Setitem setitem54 = setitemService.getSetitem("402880e71284a7ed011284fc1cb3000e");	//人力资源本身编辑布局
			Setitem setitem55 = setitemService.getSetitem("402880e71284a7ed011284fc78fe000f");	//人力资源管理员编辑布局
			Setitem setitem56 = setitemService.getSetitem("402880e71284a7ed011284fcf3de0011");	//人力资源关联对象布局
			Setitem setitem57 = setitemService.getSetitem("402880ca16a408970116a8677d89005e");	//人力资源上级编辑布局
			/*****其它*****/
			Setitem setitem58 = setitemService.getSetitem("402880311baf53bc011bb048b4a90005");	//页面风格
			Setitem setitem59 = setitemService.getSetitem("4028818411b2334e0185ed352670175");	//树形报表是否默认列表显示
			Setitem setitem60 = setitemService.getSetitem("11171015F8BC4599A7A68388C93440FD");	//部门是否显示全名称
			Setitem setitem61 = setitemService.getSetitem("2a6561cd79684e689d6ff1a6e89d8616");	//组织与角色合并
			Setitem setitem72 = setitemService.getSetitem("402883c63c6198ae013c6198baa70293");	//组织门户与角色门户合并
			Setitem setitem62 = setitemService.getSetitem("b50cd5ba74b64893a893fe660aol987h");	//表单布局是否开启语法高亮
			Setitem setitem64 = setitemService.getSetitem("8EA5529F1E014B58A2D2E9E41477273E");	//初始化微博中的人员上级
			Setitem setitem71=setitemService.getSetitem("402883303c289b29013c289b2ff70000");
			Setitem setitem73 = setitemService.getSetitem("402883c33c8f80bf013c8f80c4480293");  //弹出提醒停留间隔
			Setitem setitemEncryptPwdSSO = setitemService.getSetitem("a34f4e1ccf2f478b8b306cd5357da13c");  //集成登录密码加密
			/*****jqGrid子表相关*****/
			Setitem setitem75 = setitemService.getSetitem("402881e43f2cb11b013f2cb120bc0000");	//子表是否启用JQGrid
			Setitem setitem76 = setitemService.getSetitem("402881e43f2cb11b013f2cb120bc0001");	//JQGrid表格宽度
			Setitem setitem77 = setitemService.getSetitem("402881e43f2cb11b013f2cb120bc0002");	//JQGrid表格高度
			Setitem setitem78 = setitemService.getSetitem("402881e43f2cb11b013f2cb120bc0003");	//新建布局时子表是否默认生成启用JQGrid
			Setitem setitem79 = setitemService.getSetitem("4028831c3fa311f1013fa311f4db0000");	//JQGrid表格限定最小列宽度
			Setitem setitem80 = setitemService.getSetitem("402883e23fc257fa013fc25804ca0000");	//JQGrid表格使用tab页合并设置
		%>
		window.onload = function(){
			/*****通讯*****/
			radioChecked('4028819d0e52bb04010e5342dd5a0048','<%=setitem1.getItemvalue()%>');
			radioChecked('0f6163a0d13c49b6aba3c9f6c9fb3e37','<%=setitem2.getItemvalue()%>');
			radioChecked('402881a10e5e787f010e5f1eabeb0011','<%=setitem6.getItemvalue()%>');
			radioChecked('402883213fe5804e013fe58054ef0000','<%=setitem81.getItemvalue()%>');
			radioChange_PhoneType();
			radioChecked('402881a10e5e787f010e5f1f4a4e0013','<%=setitem7.getItemvalue()%>');
			radioChecked('611bb1e35b5d417198616a5c59610c94','<%=setitemSMTPIsAuth.getItemvalue()%>')
			/*****文档*****/
			radioChecked('402881e50b14f840010b14fbae82000a','<%=setitem14.getItemvalue()%>');
			radioChecked('402881e50b14f840010b14fbae82000b','<%=setitem16.getItemvalue()%>');
			radioChecked('402883213f26c03c013f26c03cf40000','<%=setitema1.getItemvalue()%>');
			radioChecked('82bb8269e5054f449bfd82a68cf85287','<%=setitem19.getItemvalue()%>');
			<% 
				String val20 = setitem20.getItemvalue();
				if(val20 == null || val20.trim().length() == 0){
					val20 = "0";
				}
			%>
			radioChecked('292e269b2d530567012d5a31ef5gt092','<%=val20%>');
			loadFormFields(true);
			controlEleShowOrHideWidthRadio('292e269b2d530567012d5a31ef5gt092','docBorrow');
			addTipMsg("tip292e269b2d530567012d5a31ef5gt096","注：此条件将作为sql语句的查询条件放置在sql语句的末尾,例如：and isactive = 1");
			/*****安全(用户登录)*****/
			radioChecked('402881e40ac0e0b2010ac13ff4ee0003','<%=setitem29.getItemvalue()%>');
			radioChecked('4028836134c18c690134c18c6b680000','<%=setitem30.getItemvalue()%>');
			
			radioChecked('402888534deft8d001besxe952edgy15','<%=setitem31.getItemvalue()%>');
			controlEleShowOrHideWidthRadio('402888534deft8d001besxe952edgy15','dynamicpassruleDiv');
			radioChecked('passrule','<%=passrule%>');
			bindSelect('passcount','<%=passcount%>');
			bindSelect('ispassmodel','<%=ispassmodel%>');
			
			radioChecked('297e930d347445a101347445ca4e0000','<%=setitem32.getItemvalue()%>');
			controlEleShowOrHideWidthRadio('297e930d347445a101347445ca4e0000','firstPassChangeDiv');
			radioChecked('updatepassrule','<%=updatepassrule%>');
			bindSelect('updatepasscount','<%=updatepasscount%>');
			
			bindSelect('ff808081349eb5d201349eb5e2890002','<%=setitem33.getItemvalue()%>');
			setpassdate();
			radioChecked('402880e71284a7ed011284fcf3de0012','<%=setitem34.getItemvalue()%>');
			radioChecked('402888534deft8d001besxe952edgy16','<%=setitem35.getItemvalue()%>');
			<% if(isEnabledWeaverim){ %>
				radioChecked('40288347363855d101363855d2030293','<%=setitem65.getItemvalue()%>');
			<% } %>
			/*****日志*****/
			addTipMsg("tip402881e50fab280d010fac26316e003c","注：在设置的时间间隔内同一个用户多次查看一个对象只记录一次日志");
			/*****工作流*****/
			radioChecked('402883ee3ee8d73a013ee8d73b850000','<%=setitem74.getItemvalue()%>');
			radioChecked('4089487d23f9e66e0123ffe23303253b','<%=setitem38.getItemvalue()%>');
			radioChecked('402880311e723ad0011e72782a0d0005','<%=setitem39.getItemvalue()%>');
			radioChecked('402880369e583ad001besxe82a0d0005','<%=setitem40.getItemvalue()%>');
			radioChecked('402888534deft8d001besxe952edgy17','<%=setitem41.getItemvalue()%>');
			radioChecked('402888534deft8d001besxe952edgy18','<%=setitem42.getItemvalue()%>');
			radioChecked('402888534deft8d001besxe952edgy19','<%=setitem43.getItemvalue()%>');
			radioChecked('402883053c2242e0013c2242e6f3025d','<%=setitem70.getItemvalue()%>');
			radioChecked('40288856895ft8d001bece2952edgy17','<%=setitem44.getItemvalue()%>');
			radioChecked('40288856895ft8d001beceezxse22952','<%=setitem45.getItemvalue()%>');
			radioChecked('402883c9369ff2be01369ff2c8a5026f','<%=setitem46.getItemvalue()%>');
			radioChecked('dd4851f9f7c84bcaa83f3f1273bdf869','<%=setitem47.getItemvalue()%>');
			addTipMsg("tip40288183120ddca401120de9f4dc0006","注：多个时用英文字符的逗号分隔");
			radioChecked('4028833039d773910139d7739b370000','<%=setitem63.getItemvalue()%>');
			radioChecked('402883bd3d00dd0d013d00dd16690000','<%=setitem.getItemvalue()%>')
			controlEleShowOrHideWidthRadio('4028833039d773910139d7739b370000','initButton');
			/*****人力资源*****/
			bindSelect('402880e71284a7ed011284fa24910007','<%=setitem49.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fae5ad0010','<%=setitem50.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fae5ad0011','<%=setitem51.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fae5ad0009','<%=setitem52.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fb84a6000b','<%=setitem53.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fc1cb3000e','<%=setitem54.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fc78fe000f','<%=setitem55.getItemvalue()%>');
			bindSelect('402880e71284a7ed011284fcf3de0011','<%=setitem56.getItemvalue()%>');
			bindSelect('402880ca16a408970116a8677d89005e','<%=setitem57.getItemvalue()%>');
			addTipMsg("tip402881e53b07e3ab013b07e3b3e30283","注：如此处未填写，查看人事卡片详细信息时系统将使用/humres/base/humresview.jsp来替代");
			addTipMsg("tip402881e53b07e3ab013b07e3b3e40284","注：如此处未填写，查看人事卡片详细信息时系统将使用/humres/base/humresview.jsp来替代");
			addTipMsg("tip402881e53b07e3ab013b07e3b3e40285","注：如此处未填写，查看人事卡片详细信息时系统将使用/humres/base/humresview.jsp来替代");
			addTipMsg("tip402881e53b07e3ab013b07e3b3e40286","注：如此处未填写，查看人事卡片详细信息时系统将使用/humres/base/humresview.jsp来替代");
			/*****其它*****/
			bindSelect('402880311baf53bc011bb048b4a90005','<%=setitem58.getItemvalue()%>');
			radioChecked('4028818411b2334e0185ed352670175','<%=setitem59.getItemvalue()%>');
			radioChecked('11171015F8BC4599A7A68388C93440FD','<%=setitem60.getItemvalue()%>');
			radioChecked('2a6561cd79684e689d6ff1a6e89d8616','<%=setitem61.getItemvalue()%>');
			radioChecked('402883c63c6198ae013c6198baa70293','<%=setitem72.getItemvalue()%>');
			bindSelect('b50cd5ba74b64893a893fe660aol987h','<%=setitem62.getItemvalue()%>');
			radioChecked('8EA5529F1E014B58A2D2E9E41477273E','<%=setitem64.getItemvalue()%>');
			radioChecked('402883303c289b29013c289b2ff70000','<%=setitem71.getItemvalue()%>');
			radioChecked('a34f4e1ccf2f478b8b306cd5357da13c','<%=setitemEncryptPwdSSO.getItemvalue()%>');
			/*****jqGrid子表相关*****/
			radioChecked('402881e43f2cb11b013f2cb120bc0000','<%=setitem75.getItemvalue()%>');
			controlJqGridStatusTipDisplay('<%=setitem75.getItemvalue()%>');
			radioChecked('402881e43f2cb11b013f2cb120bc0003','<%=setitem78.getItemvalue()%>');
			radioChecked('402883e23fc257fa013fc25804ca0000','<%=setitem80.getItemvalue()%>');
		}
		
		function loadFormFields(doBind){
	     	var workflowId = document.getElementById("292e269b2d530567012d5a31ef5gt093").value;
	     	Ext.Ajax.request({   
				url: '/ServiceAction/com.eweaver.workflow.form.servlet.FormfieldAction?action=getFormfieldByWorkflowidWithJSONData',   
				method : 'post',
				params:{   
					workflowId : workflowId
				}, 
				success: function (response)    
		        {   
		        	function createOption(data){
		        		var option = new Option(data["labelname"] + "-" + data["fieldname"],data["fieldname"]);
		        		return option;
		        	}
					var datas = Ext.decode(response.responseText);
					clearSelect("292e269b2d530567012d5a31ef5gt094");
					clearSelect("292e269b2d530567012d5a31ef5gt095");
					clearSelect("292e269b2d530567012d5a31ef5gt097");
					clearSelect("292e269b2d530567012d5a31ef5gt099");
					clearSelect("292e269b2d530567012d5a31ef5gt100");
					clearSelect("292e269b2d530567012d5a31ef5gt101");
					var startDateFields = document.getElementById("292e269b2d530567012d5a31ef5gt094");
					var endDateFields = document.getElementById("292e269b2d530567012d5a31ef5gt095");
					var docFields = document.getElementById("292e269b2d530567012d5a31ef5gt097");
					var browwerFields = document.getElementById("292e269b2d530567012d5a31ef5gt099");
					var isforeverFields = document.getElementById("292e269b2d530567012d5a31ef5gt100");
					var isactiveFields = document.getElementById("292e269b2d530567012d5a31ef5gt101");
					for(var i = 0; i < datas.length; i++){
						if(datas[i]["htmltype"] == 6){	//选择项
							docFields.options.add(createOption(datas[i]));
							browwerFields.options.add(createOption(datas[i]));
						}else if(datas[i]["htmltype"] == 1 && datas[i]["fieldtype"] == 4){	//日期
							startDateFields.options.add(createOption(datas[i]));
							endDateFields.options.add(createOption(datas[i]));
						}else if(datas[i]["htmltype"] == 4){	//checkbox
							isforeverFields.options.add(createOption(datas[i]));
							isactiveFields.options.add(createOption(datas[i]));
						}
					}
					if(doBind){
						bindSelect("292e269b2d530567012d5a31ef5gt094",'<%=StringHelper.null2String(setitem22.getItemvalue())%>');
		     			bindSelect("292e269b2d530567012d5a31ef5gt095",'<%=StringHelper.null2String(setitem23.getItemvalue())%>');
		     			bindSelect("292e269b2d530567012d5a31ef5gt097",'<%=StringHelper.null2String(setitem24.getItemvalue())%>');
		     			bindSelect("292e269b2d530567012d5a31ef5gt099",'<%=StringHelper.null2String(setitem25.getItemvalue())%>');
		     			bindSelect("292e269b2d530567012d5a31ef5gt100",'<%=StringHelper.null2String(setitem26.getItemvalue())%>');
		     			bindSelect("292e269b2d530567012d5a31ef5gt101",'<%=StringHelper.null2String(setitem27.getItemvalue())%>');
	     			}
		        },
			 	failure: function(response,opts) {    
				 	Ext.Msg.alert('loadFormFields Error', response.responseText);   
				}  
			}); 
     	}
	</script>
  </head>
  <div id="pagemenubar"></div>
  <body>
  	<!-- 此form页面加载之后设定的是一个空form,并非结束标签放错位置了 -->
	<form action="/ServiceAction/com.eweaver.base.setitem.servlet.SetitemAction?action=modifySysSetting" name="EweaverForm" id="EweaverForm" method="post" style="margin: 0px;padding: 0px;display: none;">
	</form> 
	<div id="leftDiv">
  		<div class="title">系统设置</div>
  		<div class="groupName">
  			<ul>
  				<li><div class="tag"></div><a href="#setting1">通讯</a></li>
  				<li><div class="tag"></div><a href="#setting2">文档</a></li>
  				<li><div class="tag"></div><a href="#setting3">安全</a></li>
  				<li><div class="tag"></div><a href="#setting4">日志</a></li>
  				<li><div class="tag"></div><a href="#setting5">工作流</a></li>
  				<li><div class="tag"></div><a href="#setting6">人力资源</a></li>
  				<li><div class="tag"></div><a href="#setting8">子表</a></li>
  				<li><div class="tag"></div><a href="#setting7">其它</a></li>
  			</ul>
  		</div>
  	</div>
  	<div id="rightDiv">
  		<div id="search">
  			<input type="text" id="searchText"/>
  			<span class="tip">在设置中搜索</span>
  			<div id="cancelSearchBtn"></div>
  		</div>
    	<div id="setting1" class="setting">
    		<div class="header">
    			通讯
    		</div>
    		<div class="group firstGroup">
				<div class="name">即时通讯</div>
				<div class="entry">
					<span class="label">是否使用即时通讯：</span>
					<span class="content"><input type="radio" name="4028819d0e52bb04010e5342dd5a0048" value="0"/>否 <input type="radio" name="4028819d0e52bb04010e5342dd5a0048" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<%	
						List selectitemlist = selectitemService.getSelectitemList("402883b530490dcb013049956f330037",null);
					%>
					<span class="label">即时通讯类型：</span>
					<span class="content">
						<%
							for(int i=0;i<selectitemlist.size();i++){
                       			Selectitem selectitem=(Selectitem)selectitemlist.get(i);
                        %>
                       		<input type="radio" name="0f6163a0d13c49b6aba3c9f6c9fb3e37" value="<%=selectitem.getId()%>" <%if(i != 0){%> class="unFirstRadio" <%} %>/><%=selectitem.getObjname()%>
					    <%	} %>
					</span>
				</div>
				<div class="entry">
					<span class="label">Domain Name：</span>
					<span class="content"><input type="text" class="text" id="86043639f1484116a3d0cd5718d41ce7" name="86043639f1484116a3d0cd5718d41ce7" value="<%=StringHelper.null2String(setitem3.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">即时通讯服务器地址 ：</span>
					<span class="content"><input type="text" class="text" id="402881a10e5a107c010e5a5e41540039" name="402881a10e5a107c010e5a5e41540039" value="<%=StringHelper.null2String(setitem4.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">即时通讯服务器端口 ：</span>
					<span class="content"><input type="text" class="text" id="402881a10e5a107c010e5a5ec0d5003b" name="402881a10e5a107c010e5a5ec0d5003b" value="<%=StringHelper.null2String(setitem5.getItemvalue()) %>"/></span>
				</div>
			</div>
			
			<div class="group">
				<div class="name">手机短消息</div>
				<div class="entry">
					<span class="label">是否使用手机短消息：</span>
					<span class="content"><input type="radio" name="402881a10e5e787f010e5f1eabeb0011" value="0"/>否 <input type="radio" name="402881a10e5e787f010e5f1eabeb0011" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<%	
						List selectitemlist4 = selectitemService.getSelectitemList("402883213fe57a6f013fe57a769a0000",null);
					%>
					<span class="label">短信接口类型：</span>
					<span class="content">
						<%
							for(int i=0;i<selectitemlist4.size();i++){
                       			Selectitem selectitem=(Selectitem)selectitemlist4.get(i);
                        %>
                       		<input type="radio" onchange="radioChange_PhoneType()" name="402883213fe5804e013fe58054ef0000" value="<%=selectitem.getId()%>" <%if(i != 0){%> class="unFirstRadio" <%} %>/><%=selectitem.getObjname()%>
					    <%	} %>
					</span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00001_div">
					<span class="label" id="402883213fe5804e013fe58054ef0001_span">短信接口接连IP：</span>
					<span class="content"><input type="text" class="text" id="402883213fe5804e013fe58054ef0001" name="402883213fe5804e013fe58054ef0001" value="<%=StringHelper.null2String(setitem82.getItemvalue()) %>"/></span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00002_div">
					<span class="label" id="402883213fe5804e013fe58054f00002_span">短信接口访问端口：</span>
					<span class="content"><input type="text" class="text" id="402883213fe5804e013fe58054f00002" name="402883213fe5804e013fe58054f00002" value="<%=StringHelper.null2String(setitem83.getItemvalue()) %>"/></span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00003_div">
					<span class="label" id="402883213fe5804e013fe58054f00003_span">短信接口账号：</span>
					<span class="content"><input type="text" class="text" id="402883213fe5804e013fe58054f00003" name="402883213fe5804e013fe58054f00003" value="<%=StringHelper.null2String(setitem84.getItemvalue()) %>"/></span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00004_div">
					<span class="label" id="402883213fe5804e013fe58054f00004_span">短信接口账号密码：</span>
					<span class="content"><input type="text" class="text" id="402883213fe5804e013fe58054f00004" name="402883213fe5804e013fe58054f00004" value="<%=StringHelper.null2String(setitem85.getItemvalue()) %>"/></span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00005_div">
					<span class="label">说明：</span>
					<span class="content" id="402883213fe5804e013fe58054f00005_span"></span>
				</div>
				<div class="entry" id="402883213fe5804e013fe58054f00006_div">
					<span class="label">短信接口连接：</span>
					<span class="content"><input type="button" value="测试连接" onclick="testPhoneConnect();"><span id="phoneconnect_message" style="margin-left: 10px;"></span></span>
				</div>
			</div>
			
			<div class="group">
				<div class="name">邮件</div>
				<div class="entry">
					<span class="label">是否使用邮件：</span>
					<span class="content"><input type="radio" name="402881a10e5e787f010e5f1f4a4e0013" value="0"/>否 <input type="radio" name="402881a10e5e787f010e5f1f4a4e0013" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">邮件服务器地址：</span>
					<span class="content"><input type="text" class="text" id="402881aa0ec16e29010ec1737ce20004" name="402881aa0ec16e29010ec1737ce20004" value="<%=StringHelper.null2String(setitem8.getItemvalue()) %>"></span>
				</div>
				<div class="entry">
					<span class="label">邮件服务器端口号：</span>
					<span class="content"><input type="text" class="text" id="402881aa0ec16e29010ec174315d0007" name="402881aa0ec16e29010ec174315d0007" value="<%=StringHelper.null2String(setitem9.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">SMTP邮件地址：</span>
					<span class="content"><input type="text" class="text" id="4028835a3845652d013845652e3c0023" name="4028835a3845652d013845652e3c0023" value="<%=StringHelper.null2String(setitem10.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">是否需要认证：</span>
					<span class="content"><input type="radio" name="611bb1e35b5d417198616a5c59610c94" value="0"/>否 <input type="radio" name="611bb1e35b5d417198616a5c59610c94" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">SMTP账户：</span>
					<span class="content"><input type="text" class="text" id="402881aa0ec16e29010ec175e1ad000d" name="402881aa0ec16e29010ec175e1ad000d" value="<%=StringHelper.null2String(setitem11.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">SMTP账户密码：</span>
					<span class="content"><input type="text" class="text" id="402881aa0ec16e29010ec1769f8f0011" name="402881aa0ec16e29010ec1769f8f0011" value="<%=StringHelper.null2String(setitem12.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">url前缀：</span>
					<span class="content"><input type="text" class="text" id="4028830838b303c00138b303c50b026e" name="4028830838b303c00138b303c50b026e" value="<%=StringHelper.null2String(setitem13.getItemvalue()) %>"/></span>
				</div>
			</div>
    	</div>
    	<div id="setting2" class="setting">
    		<div class="header">
    			文档
    		</div>
    		<div class="group firstGroup">
				<div class="name">文档</div>
				<div class="entry">
					<span class="label">文档是否压缩：</span>
					<span class="content"><input type="radio" name="402881e50b14f840010b14fbae82000a" value="0"/>否 <input type="radio" name="402881e50b14f840010b14fbae82000a" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">文件保存路径：</span>
					<span class="content"><input type="text" class="text" id="402881e80b7544bb010b754c7cd8000a" name="402881e80b7544bb010b754c7cd8000a" value="<%=StringHelper.null2String(setitem15.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">启用附件大小控件检测：</span>
					<span class="content"><input type="radio" name="402881e50b14f840010b14fbae82000b" value="0"/>否 <input type="radio" name="402881e50b14f840010b14fbae82000b" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">文档附件大小 ：</span>
					<span class="content"><input type="text" class="text" id="402881e50b14f840010b153bbc17000b" name="402881e50b14f840010b153bbc17000b" value="<%=StringHelper.null2String(setitem17.getItemvalue()) %>"/>M</span>
				</div>
				<div class="entry">
					<span class="label">启用图片附件大小控件检测：</span>
					<span class="content"><input type="radio" name="402883213f26c03c013f26c03cf40000" value="0"/>否 <input type="radio" name="402883213f26c03c013f26c03cf40000" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">图片附件大小 ：</span>
					<span class="content"><input type="text" class="text" id="402883213f26c03c013f26c03cf40001" name="402883213f26c03c013f26c03cf40001" value="<%=StringHelper.null2String(setitema2.getItemvalue()) %>"/>M</span>
				</div>
				<div class="entry">
					<span class="label">FTP上传文件目录(区分大小)：</span>
					<span class="content"><input type="text" class="text" id="40288183121d455601121d5c78640053" name="40288183121d455601121d5c78640053" value="<%=StringHelper.null2String(setitem18.getItemvalue()) %>"/></span>
				</div>
				<div class="entry">
					<span class="label">门户文档元素是否显示总记录数：</span>
					<span class="content"><input type="radio" name="82bb8269e5054f449bfd82a68cf85287" value="0"/>否 <input type="radio" name="82bb8269e5054f449bfd82a68cf85287" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否使用文档借阅：</span>
					<span class="content"><input type="radio" name="292e269b2d530567012d5a31ef5gt092" value="0" onclick="javascript:controlEleShowOrHideWidthRadio('292e269b2d530567012d5a31ef5gt092','docBorrow');"/>否 <input type="radio" name="292e269b2d530567012d5a31ef5gt092" class="unFirstRadio" value="1" onclick="javascript:controlEleShowOrHideWidthRadio('292e269b2d530567012d5a31ef5gt092','docBorrow');"/>是</span>
					<div id="docBorrow">
						<div class="entry subEntry">
							<span class="label">文档借阅流程：</span>
							<span class="content">
								<% 
								   Setitem setitem21 = setitemService.getSetitem("292e269b2d530567012d5a31ef5gt093"); 
				        		   WorkflowinfoService workflowinfoService = (WorkflowinfoService)BaseContext.getBean("workflowinfoService");
								   String workflowNames = workflowinfoService.getWorkflowNames(setitem21.getItemvalue());
				        		%>
								<button type=button  class=Browser name="button_292e269b2d530567012d5a31ef5gt093" onclick="javascript:getrefobj('292e269b2d530567012d5a31ef5gt093','292e269b2d530567012d5a31ef5gt093span','402880371d60e90c011d6107be5c0008','','0');"></button>
				        		<input type="hidden" name="292e269b2d530567012d5a31ef5gt093" id="292e269b2d530567012d5a31ef5gt093" value="<%=setitem21.getItemvalue() %>" onpropertychange="javascript:loadFormFields();"/>
				        		<span id="292e269b2d530567012d5a31ef5gt093span" name="292e269b2d530567012d5a31ef5gt093span"><%=workflowNames %></span>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">文档标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt097" name="292e269b2d530567012d5a31ef5gt097"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">借阅人标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt099" name="292e269b2d530567012d5a31ef5gt099"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">借阅开始时间标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt094" name="292e269b2d530567012d5a31ef5gt094"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">借阅结束时间标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt095" name="292e269b2d530567012d5a31ef5gt095"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">是否永久借阅标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt100" name="292e269b2d530567012d5a31ef5gt100"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">审批是否同意标识字段：</span>
							<span class="content">
								<select id="292e269b2d530567012d5a31ef5gt101" name="292e269b2d530567012d5a31ef5gt101"></select>
							</span>
						</div>
						<div class="entry subEntry">
							<span class="label">其他后缀标识条件：</span>
							<span class="content">
								<textarea rows="4" cols="45" name="292e269b2d530567012d5a31ef5gt096" id="292e269b2d530567012d5a31ef5gt096"><%=StringHelper.null2String(setitem28.getItemvalue()) %></textarea>
								<img id="tip292e269b2d530567012d5a31ef5gt096" src="/images/lightbulb.png" align="middle"/>
							</span>
						</div>
					</div>
				</div>
				
			</div>
    	</div>
    	<div id="setting3" class="setting">
    		<div class="header">
    			安全
    		</div>
    		<div class="group firstGroup">
				<div class="name">用户登录</div>
				<div class="entry">
					<span class="label">登录是否使用验证码：</span>
					<span class="content"><input type="radio" name="402881e40ac0e0b2010ac13ff4ee0003" value="0"/>否 <input type="radio" name="402881e40ac0e0b2010ac13ff4ee0003" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否启用内网IP登陆限制：</span>
					<span class="content"><input type="radio" name="4028836134c18c690134c18c6b680000" value="0"/>否 <input type="radio" name="4028836134c18c690134c18c6b680000" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否使用动态密码：</span>
					<span class="content"><input type="radio" name="402888534deft8d001besxe952edgy15" value="0" onclick="controlEleShowOrHideWidthRadio('402888534deft8d001besxe952edgy15','dynamicpassruleDiv');"/>否 <input type="radio" name="402888534deft8d001besxe952edgy15" class="unFirstRadio" value="1" onclick="controlEleShowOrHideWidthRadio('402888534deft8d001besxe952edgy15','dynamicpassruleDiv');"/>是</span>
					<div id="dynamicpassruleDiv">
						规则：<input type="radio" name="passrule" value="5">小写
							 <input type="radio" name="passrule" value="6">数字
							 <input type="radio" name="passrule" value="2">小写数字组合
							 <input type="radio" name="passrule" value="3">大写小写数字组合
						<br/>
						位数：<select id="passcount" name="passcount" style="margin-left: 5px;">
	                              <option value="6">6</option>
	                              <option value="7">7</option>
	                              <option value="8">8</option>
	                              <option value="9">9</option>
	                              <option value="10">10</option>
	                              <option value="11">11</option>
	                              <option value="12">12</option>
	                          </select>
	                    &nbsp;&nbsp;&nbsp; 是否明码输入：
	                          <select id="ispassmodel" name="ispassmodel">
	                              <option value="0">否</option>
	                              <option value="1">是</option>
	                           </select>
					</div>
				</div>
				<div class="entry">
					<span class="label">是否首次登录修改密码：</span>
					<span class="content"><input type="radio" name="297e930d347445a101347445ca4e0000" value="0" onclick="controlEleShowOrHideWidthRadio('297e930d347445a101347445ca4e0000','firstPassChangeDiv');"/>否 <input type="radio" name="297e930d347445a101347445ca4e0000" class="unFirstRadio" value="1" onclick="controlEleShowOrHideWidthRadio('297e930d347445a101347445ca4e0000','firstPassChangeDiv');"/>是</span>
					<div id="firstPassChangeDiv">
						 规则：
	                          <input type="radio" name="updatepassrule" value="5">小写
	                          <input type="radio" name="updatepassrule" value="6">数字
	                          <input type="radio" name="updatepassrule" value="2">小写数字组合
	                          <input type="radio" name="updatepassrule" value="3">大写小写数字组合
	                     <br/>
	                                                        位数：<select id="updatepasscount" name="updatepasscount" style="margin-left: 5px;">
			                    <option value="6">6</option>
			                    <option value="7">7</option>
			                    <option value="8">8</option>
			                    <option value="9">9</option>
			                    <option value="10">10</option>
			                    <option value="11">11</option>
			                    <option value="12">12</option> 
			                  </select>
					</div>
				</div>
				<div class="entry">
					<span class="label">设置密码有效期：</span>
					<span class="content">
						<% 
							List selectitemlist2 =  selectitemService.getSelectitemList("ff808081349e68f001349e7789160002",null);
						%>
						<select id="ff808081349eb5d201349eb5e2890002" name="ff808081349eb5d201349eb5e2890002" style="width: 75px;" onchange="setpassdate();">
							<%
								for(int i=0;i<selectitemlist2.size();i++){
	                       			Selectitem selectitem = (Selectitem)selectitemlist2.get(i);
	                        %>
	                       			<option value="<%=selectitem.getId() %>" ><%=selectitem.getObjname() %></option>
						    <%	} %>
						</select>
					</span>
					 <%
		                 String sql3 = "SELECT * FROM PASSEXPIRYDATE WHERE ID='402881e4349f1a4101349f1a51790002'";
					 	 List dataList3 = dataService.getValues(sql3);
		                 Map data3 = new HashMap();
		                 if(!dataList3.isEmpty()){
		                	 data3 = (Map)dataList3.get(0);
		                 }
		                 String custombegindate = data3.get("custombegindate") == null ? "" : data3.get("custombegindate").toString();
		                 String customdate = data3.get("customdate") == null ? "" : data3.get("customdate").toString();
		                 String custselect = data3.get("custselect") == null ? "" : data3.get("custselect").toString();
		                 String hiddendate = data3.get("hiddendate") == null ? "" : data3.get("hiddendate").toString();
                 	%>
					<span id="customdatediv">
						<span class="label" style="width: 60px;margin-left: 15px;">规定日期：</span>
						<span class="content">
							<input type="text" id="custombegindate" name ="custombegindate" value="<%=custombegindate %>" onclick="WdatePicker()"  size="8" onblur="fieldcheck(this,'(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)','规定日期')"  >
		                	<input type="hidden" id="hiddendate" name="hiddendate" value="<%=custombegindate %>"/>
	                	</span>
                	</span>
                	<span id="custom">
                		<span class="label" style="width: 60px;margin-left: 15px;">规定周期：</span>
						<span class="content">
							<input type="text" style="ime-mode:disabled" id="customdate" name="customdate" value="<%=customdate %>" onkeydown="myKeyDown()" size="4"/> 
		                	<input type="hidden" id="hiddendate" name="hiddendate"/>
		                	<%
			                	List selectitemlist3 =  selectitemService.getSelectitemList("ff808081349e68f001349edbdb420008",null);
			                %>
			               <select id="custselect" name="custselect" style="width: 40px;">
			                <%
								for(int i=0;i<selectitemlist3.size();i++){
	                       			Selectitem selectitem = (Selectitem)selectitemlist3.get(i);
	                        %>
	                       			<option value="<%=selectitem.getId() %>" <%if(selectitem.getId().equals(custselect)){ %> selected="selected" <%} %>>
	                       				<%=selectitem.getObjname() %>
	                       			</option>
						    <%	} %>
			                </select>
	                	</span>
                	</span>
				</div>
				<div class="entry">
					<span class="label">登录名是否区分大小写：</span>
					<span class="content"><input type="radio" name="402880e71284a7ed011284fcf3de0012" value="0"/>否 <input type="radio" name="402880e71284a7ed011284fcf3de0012" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许userkey登录：</span>
					<span class="content"><input type="radio" name="402888534deft8d001besxe952edgy16" value="0"/>否 <input type="radio" name="402888534deft8d001besxe952edgy16" class="unFirstRadio" value="1"/>是</span>
				</div>
				<% if(isEnabledWeaverim){ %>
					<div class="entry">
						<span class="label">是否启用IM：</span>
						<span class="content"><input type="radio" name="40288347363855d101363855d2030293" value="0"/>否 <input type="radio" name="40288347363855d101363855d2030293" class="unFirstRadio" value="1"/>是</span>
					</div>
				<% } %>
			</div>
    	</div>
    	
    	<div id="setting4" class="setting">
    		<div class="header">
    			日志
    		</div>
    		<div class="group firstGroup">
				<div class="name">日志</div>
				<div class="entry">
					<span class="label">查看日志记录时间间隔：</span>
					<span class="content"><input type="text" class="text" id="402881e50fab280d010fac26316e003c" name="402881e50fab280d010fac26316e003c" value="<%=StringHelper.null2String(setitem36.getItemvalue()) %>"/></span>
					<img id="tip402881e50fab280d010fac26316e003c" src="/images/lightbulb.png" align="middle"/>
				</div>
				<div class="entry">
					<span class="label">是否记录操作日志：</span>
					<span class="content">
						<%
							Setitem setitem37 = setitemService.getSetitem("fad398ab07e24a5f92cdff30d6d96499");
			            	List list1=new ArrayList();
							if(!StringHelper.isEmpty(setitem37.getItemvalue())){
								String[] arIds=setitem37.getItemvalue().split(",");
								list1=Arrays.asList(arIds);
							}
							Map<String,String> modMap=new HashMap<String,String>();
							modMap.put("SysroleDao", "角色");
							modMap.put("SyspermsDao", "权限");
							modMap.put("NodeinfoDao", "工作流节点");
							modMap.put("ForminfoDao", "表单");
							modMap.put("WorkflowinfoDao", "工作流");
							modMap.put("ReportdefDao", "报表");
							modMap.put("CategoryDao", "分类");
							Iterator<String> ite=modMap.keySet().iterator();
							String key=null;
							while(ite.hasNext()){
								key=ite.next();
								out.println("<label for=\"chk"+key+"\"><input id=\"chk"+key+"\" type=\"checkbox\" name=\"fad398ab07e24a5f92cdff30d6d96499\" "+(list1.contains(key)?"checked":"")+" value=\""+key+"\"/>"+modMap.get(key)+"</label>&nbsp;&nbsp;");
							}
						%>
					</span>
				</div>
			</div>
    	</div>
    	
    	<div id="setting5" class="setting">
    		<div class="header">
    			工作流
    		</div>
    		<div class="group firstGroup">
				<div class="name">工作流</div>
				<div class="entry">
					<span class="label">是否显示流程流转记录：</span>
					<span class="content"><input type="radio" name="402883ee3ee8d73a013ee8d73b850000" value="0"/>否 <input type="radio" name="402883ee3ee8d73a013ee8d73b850000" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否显示下拉列表个人签字意见：</span>
					<span class="content"><input type="radio" name="4089487d23f9e66e0123ffe23303253b" value="0"/>否 <input type="radio" name="4089487d23f9e66e0123ffe23303253b" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否图形化设计流程：</span>
					<span class="content"><input type="radio" name="402880311e723ad0011e72782a0d0005" value="0"/>否 <input type="radio" name="402880311e723ad0011e72782a0d0005" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否用新的出口条件设计：</span>
					<span class="content"><input type="radio" name="402880369e583ad001besxe82a0d0005" value="0"/>否 <input type="radio" name="402880369e583ad001besxe82a0d0005" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许知会人转发：</span>
					<span class="content"><input type="radio" name="402888534deft8d001besxe952edgy17" value="0"/>否 <input type="radio" name="402888534deft8d001besxe952edgy17" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许历史操作者转发：</span>
					<span class="content"><input type="radio" name="402888534deft8d001besxe952edgy18" value="0"/>否 <input type="radio" name="402888534deft8d001besxe952edgy18" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许知会的流程没提交一直在待办中 ：</span>
					<span class="content"><input type="radio" name="402888534deft8d001besxe952edgy19" value="0"/>否 <input type="radio" name="402888534deft8d001besxe952edgy19" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许转发时邮件提醒 ：</span>
					<span class="content"><input type="radio" name="402883053c2242e0013c2242e6f3025d" value="0"/>否 <input type="radio" name="402883053c2242e0013c2242e6f3025d" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">是否允许从邮件中直接查看流程：</span>
					<span class="content"><input type="radio" name="40288856895ft8d001bece2952edgy17" value="0"/>否 <input type="radio" name="40288856895ft8d001bece2952edgy17" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">流程保存时是否检查必填：</span>
					<span class="content"><input type="radio" name="40288856895ft8d001beceezxse22952" value="0"/>否 <input type="radio" name="40288856895ft8d001beceezxse22952" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">流程是否显示编号：</span>
					<span class="content"><input type="radio" name="402883c9369ff2be01369ff2c8a5026f" value="0"/>否 <input type="radio" name="402883c9369ff2be01369ff2c8a5026f" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">只显示一次流转记录：</span>
					<span class="content"><input type="radio" name="dd4851f9f7c84bcaa83f3f1273bdf869" value="0"/>否 <input type="radio" name="dd4851f9f7c84bcaa83f3f1273bdf869" class="unFirstRadio" value="1"/>是</span>
				</div>
				<div class="entry">
					<span class="label">新建流程隐藏的流程类型：</span>
					<span class="content">
						<input type="text" class="text" id="40288183120ddca401120de9f4dc0006" name="40288183120ddca401120de9f4dc0006" value="<%=StringHelper.null2String(setitem48.getItemvalue()) %>"/>
						<img id="tip40288183120ddca401120de9f4dc0006" src="/images/lightbulb.png" align="middle"/>
					</span>
				</div>
				<div class="entry">
					<span class="label">是否启用新待办：</span>
					<span class="content">
						<input type="radio" name="4028833039d773910139d7739b370000" value="0" onclick="controlEleShowOrHideWidthRadio('4028833039d773910139d7739b370000','initButton');"/>否 
						<input type="radio" name="4028833039d773910139d7739b370000" class="unFirstRadio" value="1" onclick="controlEleShowOrHideWidthRadio('4028833039d773910139d7739b370000','initButton');"/>是
						<input type="button" value="初始化" id="initButton" onclick="initData();" style="margin-left: 30px;">
					</span>
				</div>
				<!-- 
				<div class="entry">
					<span class="label">是否启用流程版本功能：</span>
					<span class="content">
						<input type="radio" name="402883bd3d00dd0d013d00dd16690000" value="0" />否 
						<input type="radio" name="402883bd3d00dd0d013d00dd16690000" class="unFirstRadio" value="1" />是
					</span>
				</div>
				-->
			</div>
    	</div>
    	
    	<div id="setting6" class="setting">
    		<div class="header">
    			人力资源
    		</div>
    		<div class="group firstGroup">
				<div class="name">人力资源</div>
				<% String optionHtmlWithLayout = getOptionHtmlWithLayout(); %>
				<div class="entry">
					<span class="label">人力资源管理员创建布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fa24910007" name="402880e71284a7ed011284fa24910007"><%=optionHtmlWithLayout %></select>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源本身查看布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fae5ad0010" name="402880e71284a7ed011284fae5ad0010"><%=optionHtmlWithLayout %></select>
					</span>
					<span class="label" style="width: 100px;margin-left: 5px;">自定义页面路径：</span>
					<span class="content">
						<input type="text" class="text" id="402881e53b07e3ab013b07e3b3e30283" name="402881e53b07e3ab013b07e3b3e30283" value="<%=StringHelper.null2String(setitem66.getItemvalue()) %>" style="width: 160px;"/>
						<img id="tip402881e53b07e3ab013b07e3b3e30283" src="/images/lightbulb.png" align="middle"/>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源上级查看布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fae5ad0011" name="402880e71284a7ed011284fae5ad0011"><%=optionHtmlWithLayout %></select>
					</span>
					<span class="label" style="width: 100px;margin-left: 5px;">自定义页面路径：</span>
					<span class="content">
						<input type="text" class="text" id="402881e53b07e3ab013b07e3b3e40284" name="402881e53b07e3ab013b07e3b3e40284" value="<%=StringHelper.null2String(setitem67.getItemvalue()) %>" style="width: 160px;"/>
						<img id="tip402881e53b07e3ab013b07e3b3e40284" src="/images/lightbulb.png" align="middle"/>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源通用查看布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fae5ad0009" name="402880e71284a7ed011284fae5ad0009"><%=optionHtmlWithLayout %></select>
					</span>
					<span class="label" style="width: 100px;margin-left: 5px;">自定义页面路径：</span>
					<span class="content">
						<input type="text" class="text" id="402881e53b07e3ab013b07e3b3e40285" name="402881e53b07e3ab013b07e3b3e40285" value="<%=StringHelper.null2String(setitem68.getItemvalue()) %>" style="width: 160px;"/>
						<img id="tip402881e53b07e3ab013b07e3b3e40285" src="/images/lightbulb.png" align="middle"/>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源管理员查看布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fb84a6000b" name="402880e71284a7ed011284fb84a6000b"><%=optionHtmlWithLayout %></select>
					</span>
					<span class="label" style="width: 100px;margin-left: 5px;">自定义页面路径：</span>
					<span class="content">
						<input type="text" class="text" id="402881e53b07e3ab013b07e3b3e40286" name="402881e53b07e3ab013b07e3b3e40286" value="<%=StringHelper.null2String(setitem69.getItemvalue()) %>" style="width: 160px;"/>
						<img id="tip402881e53b07e3ab013b07e3b3e40286" src="/images/lightbulb.png" align="middle"/>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源本身编辑布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fc1cb3000e" name="402880e71284a7ed011284fc1cb3000e"><%=optionHtmlWithLayout %></select>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源管理员编辑布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fc78fe000f" name="402880e71284a7ed011284fc78fe000f"><%=optionHtmlWithLayout %></select>
					</span>
				</div>
				<div class="entry" style="display: none;">
					<span class="label">人力资源关联对象布局：</span>
					<span class="content">
						<select id="402880e71284a7ed011284fcf3de0011" name="402880e71284a7ed011284fcf3de0011"><%=optionHtmlWithLayout %></select>
					</span>
				</div>
				<div class="entry">
					<span class="label">人力资源上级编辑布局：</span>
					<span class="content">
						<select id="402880ca16a408970116a8677d89005e" name="402880ca16a408970116a8677d89005e"><%=optionHtmlWithLayout %></select>
					</span>
				</div>
			</div>
    	</div>
    	
    	<div id="setting7" class="setting">
    		<div class="header">
    			其它
    		</div>
    		<div class="group firstGroup">
				<div class="name">其它</div>
				<div class="entry">
					<span class="label">页面风格：</span>
					<span class="content">
						<select id="402880311baf53bc011bb048b4a90005" name="402880311baf53bc011bb048b4a90005">
							<option value="default">浅蓝色风格(默认)</option>
							<option value="gray">灰色风格</option>
							<option value="purple">紫色风格</option>
							<option value="olive">绿色风格</option>
							<option value="light-orange">橙色风格</option>
						</select>
					</span>
				</div>
				<div class="entry">
					<span class="label">树形报表是否默认列表显示：</span>
					<span class="content">
						<input type="radio" name="4028818411b2334e0185ed352670175" value="0"/>否 
						<input type="radio" name="4028818411b2334e0185ed352670175" class="unFirstRadio" value="1"/>是
					</span>
				</div>
				<div class="entry">
					<span class="label">部门是否显示全名称：</span>
					<span class="content">
						<input type="radio" name="11171015F8BC4599A7A68388C93440FD" value="0"/>否 
						<input type="radio" name="11171015F8BC4599A7A68388C93440FD" class="unFirstRadio" value="1"/>是
					</span>
				</div>
				<div class="entry">
					<span class="label">组织菜单与角色菜单合并：</span>
					<span class="content">
						<input type="radio" name="2a6561cd79684e689d6ff1a6e89d8616" value="0"/>否
						<input type="radio" name="2a6561cd79684e689d6ff1a6e89d8616" class="unFirstRadio" value="1"/>是
					</span>
				</div>
				<div class="entry">
					<span class="label">组织门户与角色门户合并：</span>
					<span class="content">
						<input type="radio" name="402883c63c6198ae013c6198baa70293" value="0"/>否
						<input type="radio" name="402883c63c6198ae013c6198baa70293" class="unFirstRadio" value="1"/>是
					</span>
				</div>
				<div class="entry">
					<span class="label">表单布局是否开启语法高亮：</span>
					<span class="content">
						<select id="b50cd5ba74b64893a893fe660aol987h" name="b50cd5ba74b64893a893fe660aol987h">
		                    <option value="0">关闭</option>
							<option value="1">开启</option>
		                </select>
					</span>
				</div>
				<div class="entry">
					<span class="label">初始化微博中的人员上级：</span>
					<span class="content">
						<input type="radio" name="8EA5529F1E014B58A2D2E9E41477273E" onclick="initButtonSpan.style.display='none'" value="0"/>否 <input type="radio" name="8EA5529F1E014B58A2D2E9E41477273E" onclick="initButtonSpan.style.display=''" class="unFirstRadio" value="1"/>是
		               		<span id="initButtonSpan" style="margin-left: 30px;display: <%=setitem64.getItemvalue().equals("1")?"":"none" %>"><button type="button" onclick="initManagers(this)">初始化所有员工上级</button></span>
		               		<br/><font style="margin-left: 50px;" color="red">注意：当系统中使用到工作微博模块，则必须在此初始化人员上级！</font>
					</span>
				</div>
				<div class="entry">
					<span class="label">是否启用电子签章：</span>
					<span class="content">
						<input type="radio" name="402883303c289b29013c289b2ff70000" value="0"/>否
						<input type="radio" name="402883303c289b29013c289b2ff70000" class="unFirstRadio" value="1"/>是
					</span>
				</div>
				<div class="entry">
					<span class="label">弹出提醒时间间隔：</span>
					<span class="content">
						<input type="text" name="402883c33c8f80bf013c8f80c4480293" id="402883c33c8f80bf013c8f80c4480293" style="width:200;" value="<%=setitem73.getItemvalue()%>">
                        (** 单位为秒，默认时间3s，设置为0则不隐藏)
					</span>
				</div>
				<div class="entry">
					<span class="label">集成登录密码加密：</span>
					<span class="content">
						<input type="radio" name="a34f4e1ccf2f478b8b306cd5357da13c" value="0"/>否
						<input type="radio" name="a34f4e1ccf2f478b8b306cd5357da13c" class="unFirstRadio" value="1"/>是
						<!-- 
						<button type="button" onclick="doSSOAccountHistory(0)">加密历史数据</button>
						<button type="button" onclick="doSSOAccountHistory(1)">解密历史数据</button>
						 -->
					</span>
					
				</div>
			</div>
    	</div>
    	
    	<div id="setting8" class="setting">
    		<div class="header">
    			子表
    		</div>
    		<div class="group firstGroup">
				<div class="name">子表JQGrid相关设置</div>
    			<div class="entry">
					<span class="label">子表是否启用JQGrid：</span>
					<span class="content">
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0000" value="<%=JQGridConstant.GLOBAL_STATUS_ENABLED %>" onclick="controlJqGridStatusTipDisplay(this.value);"/>启用
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0000" value="<%=JQGridConstant.GLOBAL_STATUS_FORCED_ENABLED %>" class="unFirstRadio" onclick="controlJqGridStatusTipDisplay(this.value);"/>强制启用
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0000" value="<%=JQGridConstant.GLOBAL_STATUS_DISABLED %>" class="unFirstRadio" onclick="controlJqGridStatusTipDisplay(this.value);"/>禁用
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0000" value="<%=JQGridConstant.GLOBAL_STATUS_FORCED_DISABLED %>" class="unFirstRadio" onclick="controlJqGridStatusTipDisplay(this.value);"/>强制禁用
						<div class="jqGridTip jqGridStatusTip" id="jqGridStatusTip<%=JQGridConstant.GLOBAL_STATUS_ENABLED %>">
							<b>启用</b>：
							<br/>
							当未明确为布局子表Table设置启用或禁用JQGrid时(通过<%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>属性设置),此项会默认认为是<font color="red">启用</font>。
							<br/>
							当明确为布局子表Table设置启用或禁用JQGrid时,<font color="red">以布局子表Table中的设置为准</font>。
							<br/>
							如：
							<div>
								&lt;table class="detailtable" border="1"&gt;
								此时为<font color="red">启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="true"&gt;
								此时为<font color="red">启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="false"&gt;
								此时为<font color="red">不启用</font>
							</div>
						</div>
						<div class="jqGridTip jqGridStatusTip" id="jqGridStatusTip<%=JQGridConstant.GLOBAL_STATUS_FORCED_ENABLED %>">
							<b>强制启用</b>：
							<br/>
							无论布局子表Table是否设置了启用或禁用JQGrid(通过<%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>属性设置),系统<font color="red">都将强制认为是启用</font>。
							<br/>
							如：
							<div>
								&lt;table class="detailtable" border="1"&gt;
								此时为<font color="red">启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="true"&gt;
								此时为<font color="red">启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="false"&gt;
								此时<font color="red">仍</font>为<font color="red">启用</font>
							</div>
						</div>
						<div class="jqGridTip jqGridStatusTip" id="jqGridStatusTip<%=JQGridConstant.GLOBAL_STATUS_DISABLED %>">
							<b>禁用</b>：
							<br/>
							当未明确为布局子表Table设置启用或禁用JQGrid时(通过<%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>属性设置),此项会默认认为是<font color="red">不启用</font>。
							<br/>
							当明确为布局子表Table设置启用或禁用JQGrid时,<font color="red">以布局子表Table中的设置为准</font>。
							<br/>
							如：
							<div>
								&lt;table class="detailtable" border="1"&gt;
								此时为<font color="red">不启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="true"&gt;
								此时为<font color="red">启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="false"&gt;
								此时为<font color="red">不启用</font>
							</div>
						</div>
						<div class="jqGridTip jqGridStatusTip" id="jqGridStatusTip<%=JQGridConstant.GLOBAL_STATUS_FORCED_DISABLED %>">
							<b>强制禁用</b>：
							<br/>
							无论布局子表Table是否设置了启用或禁用JQGrid(通过<%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>属性设置),系统<font color="red">都将强制认为是不启用</font>。
							<br/>
							如：
							<div>
								&lt;table class="detailtable" border="1"&gt;
								此时为<font color="red">不启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="true"&gt;
								此时<font color="red">仍</font>为<font color="red">不启用</font>
							</div>
							<div>
								&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="false"&gt;
								此时为<font color="red">不启用</font>
							</div>
						</div>
					</span>
				</div>
				<div class="entry">
					<span class="label">表格宽度：</span>
					<span class="content">
						<input type="text" class="text" id="402881e43f2cb11b013f2cb120bc0001" name="402881e43f2cb11b013f2cb120bc0001" value="<%=StringHelper.null2String(setitem76.getItemvalue()) %>"/>
						<a href="javascript:void(0);" class="jqGridTipControl" onclick="controlTipDisplay('jqGridWidthTip');">点击查看此项详细说明</a>
						<div class="jqGridTip" id="jqGridWidthTip">
							如果布局子表未设置表格宽度，则以<b>此处设置</b>的表格宽度值为准。
							<br/>
							如果布局子表设置了表格宽度，则以<b>布局中设置</b>的表格宽度值为准。
							<br/>
							布局中的表格宽度设置示例如下：
							<br/>
							&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_WIDTH %>="<%=JQGridConstant.DEFAULT_ATTRVALUE_GRID_WIDTH %>"&gt;
						</div>
					</span>
				</div>
				<div class="entry">
					<span class="label">表格高度：</span>
					<span class="content">
						<input type="text" class="text" id="402881e43f2cb11b013f2cb120bc0002" name="402881e43f2cb11b013f2cb120bc0002" value="<%=StringHelper.null2String(setitem77.getItemvalue()) %>"/>
						<a href="javascript:void(0);" class="jqGridTipControl" onclick="controlTipDisplay('jqGridHeightTip');">点击查看此项详细说明</a>
						<div class="jqGridTip" id="jqGridHeightTip">
							如果布局子表未设置表格高度，则以<b>此处设置</b>的表格高度值为准。
							<br/>
							如果布局子表设置了表格高度，则以<b>布局中设置</b>的表格高度值为准。
							<br/>
							布局中的表格高度设置示例如下：
							<br/>
							&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_HEIGHT %>="<%=JQGridConstant.DEFAULT_ATTRVALUE_GRID_HEIGHT %>"&gt;
						</div>
					</span>
				</div>
				<div class="entry">
					<span class="label">表格限定最小列宽度：</span>
					<span class="content">
						<input type="text" class="text" id="4028831c3fa311f1013fa311f4db0000" name="4028831c3fa311f1013fa311f4db0000" value="<%=StringHelper.null2String(setitem79.getItemvalue()) %>"/>
						<a href="javascript:void(0);" class="jqGridTipControl" onclick="controlTipDisplay('jqGridMinWidthTip');">点击查看此项详细说明</a>
						<div class="jqGridTip" id="jqGridMinWidthTip">
							当JQGrid在解析子表时，如果解析出的原有列宽小于此处设置的值，则将以此处设置的值替代原有的列宽。<br/>
							假设有一个子表解析后的列宽分别为：<br/>
							第一列：80 <br/>
							第二列：200 <br/>
							第三列：70 <br/>
							第四列：90 <br/>
							第五列：350 <br/>
							此时如果此处(表格限定最小列宽度)设置的值为150,那么该子表的宽度将被重置为：<br/>
							第一列：<font color="red">150</font> <br/>
							第二列：200 <br/>
							第三列：<font color="red">150</font> <br/>
							第四列：<font color="red">150</font> <br/>
							第五列：350 <br/><br/>
							布局中也可以对某个子表进行单独设置(通过<%=JQGridConstant.ATTRNAME_GRIDCOL_MIN_WIDTH %>属性设置),设置示例如下：<br/>
							&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRIDCOL_MIN_WIDTH %>="100"&gt;<br/><br/>
							布局中的限定最小列宽度设置<b><font color="red">优先级高于</font></b>此处的设置。<br/>
							如果将值设置为0(或小于0的负数)，相当于不进行最小列宽的限定，因为没有列的列宽是会小于等于0的。<br/><br/>
							通过以上两种特性可知，假设有这样一种情况，此处设置的限定最小列宽度为150，而有一个子表是不想使用此设置的，而是想以解析的原本列宽为准，则可以在子表布局中加上<%=JQGridConstant.ATTRNAME_GRIDCOL_MIN_WIDTH %>设置覆盖掉此处的全局设置。示例如下：<br/>
							&lt;table class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRIDCOL_MIN_WIDTH %>="0"&gt;<br/>
							反过来也是可行的，此处设置为0，然后针对具体子表在布局中进行最小列宽限定的设置也是有效的。
						</div>
					</span>
				</div>
				<div class="entry">
					<span class="label">多子表时是否默认使用Tab页进行合并：</span>
					<span class="content">
						<input type="radio" name="402883e23fc257fa013fc25804ca0000" value="0"/>否
						<input type="radio" name="402883e23fc257fa013fc25804ca0000" class="unFirstRadio" value="1"/>是
						&nbsp;&nbsp;<font color="red">(此设置仅当多个子表时有意义)</font>
						<a href="javascript:void(0);" class="jqGridTipControl" onclick="controlTipDisplay('jqGridTabTip');">点击查看此项详细说明</a>
						<div class="jqGridTip" id="jqGridTabTip">
							假如布局页面上有多个子表,在没有明确指定子表分组的情况下：<br/>
							如果该设置的选项为否，则在显示时不会将这些子表合并成一个tab页来显示。<br/>
							如果该设置为是，则这些没有明确指定分组的子表将被认为是分成一组，然后使用tab页进行显示。<br/>
							<font color="red">该设置只是针对布局上没有明确指定分组的子表有效。</font><br/>
							为布局子表指定分组可以使用<%=JQGridConstant.ATTRNAME_GRID_GROUP %>来设置。具体设置示例如下：<br/>
							&lt;table id="表1" class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_GROUP %>="group1"&gt;<br/>
							&lt;table id="表2" class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_GROUP %>="group1"&gt;<br/>
							&lt;table id="表3" class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_GROUP %>="group2"&gt;<br/>
							&lt;table id="表4" class="detailtable" border="1" <%=JQGridConstant.ATTRNAME_GRID_GROUP %>="group2"&gt;<br/>
							此时表1和表2会合并成一个tab页,表3和表4会合并成一个tab页。<br/>
							以上示例中group1和group2只是一个名称，可以随意指定，确保不同分组的名称不相同就可以了。
						</div>
					</span>
				</div>
				<div class="entry">
					<span class="label">新建布局时子表是否默认生成启用JQGrid：</span>
					<span class="content">
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0003" value="0"/>否
						<input type="radio" name="402881e43f2cb11b013f2cb120bc0003" class="unFirstRadio" value="1"/>是
						<a href="javascript:void(0);" class="jqGridTipControl" onclick="controlTipDisplay('jqGridLayoutGenAttrTip');">点击查看此项详细说明</a>
						<div class="jqGridTip" id="jqGridLayoutGenAttrTip">
							此项如选择为是，则会在此后的新建布局时，为子表自动加上<%=JQGridConstant.ATTRNAME_GRID_ISENABLED %>="true"的设置。
						</div>
					</span>
				</div>
			</div>
    	</div>
    	
    	<div id="searchResultDiv" class="setting">
    		<div class="header">
    			搜索结果
    		</div>
    		<div class="group firstGroup">
				<div class="name">搜索结果</div>
				
			</div>
    	</div>
  	</div>
  </body>
</html>
