package weaver.interfaces.tw.xiyf.sap;

import java.util.List;
import java.util.Map;

import weaver.interfaces.tw.xwd.webservice.twytht.TwYtHtBean;
 

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoStructure;

public class ExecuteBapi {

	
	private JCoRecordFieldIterator JCoRecordFieldIterator = null;
	private JCoField JCoField = null;
	private static JCoDestination destination = SAPConn.getJCoDestination();


	/**
	 * init
	 */
	public void ExecuteBapi() {
		
	}
	/**
	 * 
	 * @Title: YthtReturnSap 
	 * @Description: 盈通合同(ht) 返回sap
	 * @param     设定文件 
	 * @return void    返回类型 
	 * @throws
	 */
	public static void YthtReturnSap(){
		JCoFunction function;
		try {
			function = destination.getRepository().getFunction("ZFI_OA2SAP_BXD_YT");
//			function.getImportParameterList().setValue("S_STATU",status); 
//			if(SAPConstant.S_STATU_L.equals(status)){//status为L时返回合同信息
//				JCoStructure JCoStructure = null;
//				
//				function.getImportParameterList().setValue("S_TKONN",TwYtHtBean.getTKONN());
//				JCoStructure = function.getImportParameterList().getStructure("S_ZWBHK"); 
//				JCoStructure.setValue("ZYTFD01", TwYtHtBean.getZYTFD01());
//				JCoStructure.setValue("ZYTFD02", TwYtHtBean.getZYTFD02());
//				JCoStructure.setValue("ZYTFD03", TwYtHtBean.getZYTFD03());
//				JCoStructure.setValue("ZYTFD04", TwYtHtBean.getZYTFD04());
//				JCoStructure.setValue("ZYTFD05", TwYtHtBean.getZYTFD05());
//				JCoStructure.setValue("ZYTFD06", TwYtHtBean.getZYTFD06());
//				JCoStructure.setValue("ZYTFD07", TwYtHtBean.getZYTFD07());
//				JCoStructure.setValue("ZYTFD08", TwYtHtBean.getZYTFD08());
//				JCoStructure.setValue("ZYTFD09", TwYtHtBean.getZYTFD09());
//				JCoStructure.setValue("ZYTFD10", TwYtHtBean.getZYTFD10());
//				JCoStructure.setValue("ZYTFD11", TwYtHtBean.getZYTFD11());
//				JCoStructure.setValue("ZYTFD12", TwYtHtBean.getZYTFD12());
//				JCoStructure.setValue("ZYTFD13", TwYtHtBean.getZYTFD13());
//				JCoStructure.setValue("ZYTFD14", TwYtHtBean.getZYTFD14());
//				
//			//	function.getImportParameterList().setValue("S_ZWBHK", JCoStructure);
//			}
//
//			
//			function.execute(destination);
//			System.out.println(function.getExportParameterList().getValue("S_RESULT"));

		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ZRFC_GET_CUSTDATA
		
	}

	 

	public static void main(String[] a) {
		try{
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
