<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.eweaver.base.DataService"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="jxl.Workbook"%>
<%@ page import="jxl.write.Label"%>
<%@ page import="jxl.write.WritableSheet"%>
<%@ page import="jxl.write.WritableWorkbook"%>
<%@ page import="com.eweaver.base.util.StringHelper"%>
<%
	try{
		String sql=(String)request.getParameter("reportsql");
		DataService dataService = new DataService();
		List list = dataService.getValues(sql);
		OutputStream os = response.getOutputStream();// 取得输出流   
		response.reset();// 清空输出流   
		String filename = URLEncoder.encode("通讯录", "UTF-8");
		response.setHeader("Content-disposition", "attachment; filename=" + filename + ".xls");// 设定输出文件头   
		response.setContentType("application/msexcel");// 定义输出类型 		
		WritableWorkbook wbook = Workbook.createWorkbook(os); // 建立excel文件   
		WritableSheet wsheet = wbook.createSheet("sheet1", 0); // sheet名称  
		//开始生成主体内容  
		wsheet.addCell(new Label(0, 0, "部门"));
		wsheet.addCell(new Label(1, 0, "姓名"));
		wsheet.addCell(new Label(2, 0, "职务"));
		wsheet.addCell(new Label(3, 0, "电话"));
		wsheet.addCell(new Label(4, 0, "手机"));
		wsheet.addCell(new Label(5, 0, "EMAIL"));
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				wsheet.addCell(new Label(0, i + 1, StringHelper.null2String(map.get("dept_name"))));
				wsheet.addCell(new Label(1, i + 1, StringHelper.null2String(map.get("name"))));
				wsheet.addCell(new Label(2, i + 1, StringHelper.null2String(map.get("sta_name"))));
				wsheet.addCell(new Label(3, i + 1, StringHelper.null2String(map.get("tel1"))));
				wsheet.addCell(new Label(4, i + 1, StringHelper.null2String(map.get("tel2"))));
				wsheet.addCell(new Label(5, i + 1, StringHelper.null2String(map.get("email"))));
			}
		}
		wbook.write(); //写入文件   
		wbook.close();
		os.close(); //关闭流
	}catch(Exception e){
		System.out.println(e);
	}
%>

