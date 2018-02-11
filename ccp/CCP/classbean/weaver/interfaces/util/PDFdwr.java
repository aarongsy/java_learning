package weaver.interfaces.util;

import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.workflow.request.RequestComInfo;
import weaver.workflow.workflow.WorkflowComInfo;

public class PDFdwr extends BaseBean{
	public String insertCanvasimg(String data,String requestid){  
			String requestname = "";
			try {
				RequestComInfo comInfo = new RequestComInfo();
				requestname = comInfo.getRequestname(requestid);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			System.out.println("data========="+data);
			System.out.println("requestname==="+requestname);
			System.out.println("requestid==="+requestid);
			String path = Util.null2String(getPropValue("pdf", "pdfpath"));
			String pdfname = path+requestname+".pdf";
			CanvasToPDF canvasToPDF = new CanvasToPDF();
			canvasToPDF.toPdf(data, pdfname);
		return "1";
	}
}
