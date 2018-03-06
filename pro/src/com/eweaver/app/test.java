package com.eweaver.app;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;






import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.eweaver.base.DataService;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.eweaver.document.base.model.Attach;
import com.eweaver.document.file.FileUpload;
import com.eweaver.excel.util.ReadExcel;
import jxl.read.biff.BiffException;




public class test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*String execelFile="";
		  try {  

	            // 构造 Workbook 对象，execelFile 是传入文件路径(获得Excel工作区)  

			  HSSFWorkbook workbook = new HSSFWorkbook(new FileInputStream(execelFile));
	            //book=Workbook.getWorkbook(saveFile);// 
	            // 读取表格的第一个sheet页  
	            HSSFSheet sheet = workbook.getSheetAt(0);

	            //Sheet sheet = book.getSheetAt(0);  

	            // 定义 row、cell  

	            HSSFRow row;  

	            String cell;  

	            // 总共有多少行,从0开始  

	            int totalRows = sheet.getLastRowNum() ;  

	            // 循环输出表格中的内容,首先循环取出行,再根据行循环取出列  

	            for (int i = 1; i <= totalRows; i++) {  

	                row = sheet.getRow(i);  

	                // 处理空行  

	                if(row == null){  

	                    continue ;  

	                }  

	                // 总共有多少列,从0开始  

	                int totalCells = row.getLastCellNum() ;  

	                for (int j = row.getFirstCellNum(); j < totalCells; j++) {  

	                    // 处理空列  

	                    if(row.getCell(j) == null){  

	                        continue ;  

	                    }  

	                    // 通过 row.getCell(j).toString() 获取单元格内容  

	                    cell = row.getCell(j).toString();  

	                    System.out.print(cell + "\t");  

	                }  

	                System.out.println("");  

	            }  

	        } catch (FileNotFoundException e) {  

	            e.printStackTrace();  

	        } catch (IOException e) {  

	            e.printStackTrace();  

	        }  */
		HttpServletRequest request=null;
		   HttpServletResponse response=null;

		   FileUpload fileUpload;

			    fileUpload = new FileUpload(request);

			    try {
					fileUpload.resolveMultipart(0);
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				} catch (ServletException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			    ReadExcel inb = new ReadExcel();
			    List[] dataArray = null;

			    List aList = fileUpload.getAttachList();
			    Attach attach = null;
			    if ((aList != null) || (aList.isEmpty())) attach = (Attach)aList.get(0);
			    System.out.println("attach :" + attach);
			    File file2 = new File(attach.getFiledir());

			    InputStream is = null;
				try {
					is = new FileInputStream(file2);
				} catch (FileNotFoundException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			    if (is != null) {
			      try {
			        try {
						dataArray = inb.readXls(is);
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			      }
			      catch (BiffException e) {
			        e.printStackTrace();
			      }
			    }

			    try {
					is.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			    //ImportDataFromExcelService importData = new ImportDataFromExcelService();
			    String throwstr = "ERROR";
			    try {
			      throwstr = "";//importData.dealData(dataArray);
			    } catch (Exception e) {
			      e.printStackTrace();
			      request.setAttribute("errorMsg", e.toString());
			    }
			    if (file2.isFile())
			      file2.delete();


	    }  
}
