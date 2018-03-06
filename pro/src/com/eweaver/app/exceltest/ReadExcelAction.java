package com.eweaver.app.exceltest;

//import com.eweaver.app.exceltest.service.ImportDataFromExcelService;
import com.eweaver.base.AbstractAction;
import com.eweaver.base.DataService;
import com.eweaver.base.util.StringFilter;
import com.eweaver.base.util.StringHelper;
import com.eweaver.document.base.model.Attach;
import com.eweaver.document.file.FileUpload;
import com.eweaver.app.exceltest.ReadExcel;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jxl.read.biff.BiffException;

public class ReadExcelAction
  implements AbstractAction
{
  private HttpServletRequest request;
  private HttpServletResponse response;
  private HttpSession session;
  private DataService dataService;
  private FileUpload fileUpload;

  public ReadExcelAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
    this.session = request.getSession();
    this.dataService = new DataService();
  }

  public void execute()
    throws IOException, ServletException
  {
    String action = StringHelper.null2String(StringFilter.filterAll(this.request
      .getParameter("action")));

    this.fileUpload = new FileUpload(this.request);

    this.fileUpload.resolveMultipart(0);

    ReadExcel inb = new ReadExcel();
    List[] dataArray = null;

    List aList = this.fileUpload.getAttachList();
    Attach attach = null;
    if ((aList != null) || (aList.isEmpty())) attach = (Attach)aList.get(0);
    System.out.println("attach :" + attach);
    File file2 = new File(attach.getFiledir());

    InputStream is = new FileInputStream(file2);

    if (is != null) {
      try {
        dataArray = inb.readXls(is);
      }
      catch (BiffException e) {
        e.printStackTrace();
      }
    }

    is.close();
    //ImportDataFromExcelService importData = new ImportDataFromExcelService();
    String throwstr = "ERROR";
    try {
      throwstr = "";//importData.dealData(dataArray);
    } catch (Exception e) {
      e.printStackTrace();
      this.request.setAttribute("errorMsg", e.toString());
    }
    throwstr = URLEncoder.encode(throwstr, "UTF-8");
    if (file2.isFile())
      file2.delete();
    String url = this.request.getContextPath() + "/app/trade/yfxbj/importDataFromExcel.jsp?throwstr=" + throwstr;
    if ("xmlupload".equals(action)) {
      this.request.getRequestDispatcher(url).forward(this.request, this.response);
    }
    if ("read".equals(action))
      this.response.getWriter().print(throwstr);
  }
}