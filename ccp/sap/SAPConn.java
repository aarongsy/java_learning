package weaver.interfaces.tw.xiyf.sap;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Properties;

import weaver.general.BaseBean;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import com.sap.conn.jco.ext.DestinationDataProvider;

public class SAPConn{
    
    static String ABAP_AS = "ABAP_AS_WITHOUT_POOL";
    static String ABAP_AS_POOLED = "ABAP_AS_WITH_POOL";
    static String ABAP_MS = "ABAP_MS_WITHOUT_POOL";
    static
    {
        Properties connectProperties = new Properties();
        BaseBean bb = new BaseBean();
        connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, "20.20.32.128"); //221.238.225.169
        connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR,  "00");
        connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, "501");
        connectProperties.setProperty(DestinationDataProvider.JCO_USER,   "OA_YT");
        connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, "12345678");
        connectProperties.setProperty(DestinationDataProvider.JCO_LANG,   "ZH");

//      connectProperties.setProperty(DestinationDataProvider.JCO_ASHOST, bb.getPropValue("SAPConn_TJWC", "HostName"));
//      connectProperties.setProperty(DestinationDataProvider.JCO_SYSNR, bb.getPropValue("SAPConn_TJWC", "SystemNumber"));
//      connectProperties.setProperty(DestinationDataProvider.JCO_CLIENT, bb.getPropValue("SAPConn_TJWC", "SAPClient"));
//      connectProperties.setProperty(DestinationDataProvider.JCO_USER, bb.getPropValue("SAPConn_TJWC", "Userid"));
//      connectProperties.setProperty(DestinationDataProvider.JCO_PASSWD, bb.getPropValue("SAPConn_TJWC", "Password"));
//      connectProperties.setProperty(DestinationDataProvider.JCO_LANG, bb.getPropValue("SAPConn_TJWC", "Language"));
        
        createDataFile(ABAP_AS, "jcoDestination", connectProperties);

//        connectProperties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY,bb.getPropValue("SAPConn_TJWC", "CAPACITY"));
//        connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT,bb.getPropValue("SAPConn_TJWC", "LIMIT"));
        connectProperties.setProperty(DestinationDataProvider.JCO_POOL_CAPACITY, "3");
        connectProperties.setProperty(DestinationDataProvider.JCO_PEAK_LIMIT,    "10");       
        createDataFile(ABAP_AS_POOLED, "jcoDestination", connectProperties);
        
    }
    
    static void createDataFile(String name, String suffix, Properties properties)
    {
        File cfg = new File(name+"."+suffix);
        if(!cfg.exists())
        {
            try
            {
                FileOutputStream fos = new FileOutputStream(cfg, false);
                properties.store(fos, "for tests only !");
                fos.close();
            }
            catch (Exception e)
            {
                throw new RuntimeException("Unable to create the destination file " + cfg.getName(), e);
            }
        }
    }
    
    public static JCoDestination getJCoDestination()
    {
    	JCoDestination destination = null;
    	try{
	        destination = JCoDestinationManager.getDestination(ABAP_AS);
	        destination.ping();
//	        System.out.println("ABAP_AS 	Attributes:");
//	        System.out.println(destination.getAttributes());
//	        System.out.println();
	        
	        destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
	        destination.ping();
//	        System.out.println("ABAP_AS_POOLED	Attributes:");
//	        System.out.println(destination.getAttributes());
//	        System.out.println();
	        
    	}catch(Exception e){
    		e.printStackTrace();
    	}
        return destination;
    }
    
	public static void ZRFC_GET_MAKTX()
	{
		String MATNR = "";//物料编码
		String MAKTX = "";//物料描述
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZRFC_GET_MAKTX");
			
			function.getImportParameterList().setValue("MATNR",MATNR);
			function.getImportParameterList().setValue("MAKTX",MAKTX); 
			
			function.execute(destination);//
			
			JCoTable JCoTable = function.getTableParameterList().getTable("MAKT");
			
			System.out.println("MAKT JCoTable:"+JCoTable.getNumRows());
			for(int i=0;i<JCoTable.getNumRows();i++){
				JCoTable.setRow(i);
				String MATNRb = JCoTable.getString("MATNR");//物料编号
				String MAKTXb = JCoTable.getString("MAKTX");//物料描述
				System.out.println("MATNR:"+MATNRb+"	ARKTX"+MAKTXb);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	public static void ZRFC_GET_LIFNR()
	{
		String LIFNR = "";//物料编码
		String NAME1 = "";//物料描述
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZRFC_GET_LIFNR");
			
			function.getImportParameterList().setValue("LIFNR",LIFNR);
			function.getImportParameterList().setValue("NAME1",NAME1); 
			
			function.execute(destination);//
			
			JCoTable JCoTable = function.getTableParameterList().getTable("LFA1");
			
			System.out.println("LIF1 JCoTable:"+JCoTable.getNumRows());
			for(int i=0;i<JCoTable.getNumRows();i++){
				JCoTable.setRow(i);
				String LIFNRb = JCoTable.getString("LIFNR");//物料编号
				String NAME1b = JCoTable.getString("NAME1");//物料描述
				System.out.println("MATNR:"+LIFNRb+"	ARKTX"+NAME1b);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void ZRFC_GET_LGORT()
	{
		String LGORT = "";//物料编码
		String LGOBE = "";//物料描述
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZRFC_GET_LGORT");
			
			function.getImportParameterList().setValue("LGORT",LGORT);
			function.getImportParameterList().setValue("LGOBE",LGOBE); 
			
			function.execute(destination);//
			
			JCoTable JCoTable = function.getTableParameterList().getTable("T001L");
			
			System.out.println("MAKT JCoTable:"+JCoTable.getNumRows());
			for(int i=0;i<JCoTable.getNumRows();i++){
				JCoTable.setRow(i);
				String LGORTb = JCoTable.getString("LGORT");//物料编号
				String LGOBEb = JCoTable.getString("LGORT");//物料描述
				System.out.println("MATNR:"+LGORTb+"	ARKTX"+LGOBEb);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void ZRFC_GET_KUNNR()
	{
		String KUNNR = "";//物料编码
		String NAME1 = "";//物料描述
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZRFC_GET_KUNNR");
			
			function.getImportParameterList().setValue("KUNNR",KUNNR);
			function.getImportParameterList().setValue("NAME1",NAME1); 
			
			function.execute(destination);//
			
			JCoTable JCoTable = function.getTableParameterList().getTable("KNA1");
			
			System.out.println("MAKT JCoTable:"+JCoTable.getNumRows());
			for(int i=0;i<JCoTable.getNumRows();i++){
				JCoTable.setRow(i);
				String KUNNRb = JCoTable.getString("KUNNR");//物料编号
				String NAME1b = JCoTable.getString("NAME1");//物料描述
				System.out.println("MATNR:"+KUNNRb+"	ARKTX"+NAME1b);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
	public static void ZRFC_GET_SO()
	{
		String VBELN = "0010000416";//物料编码
		String POSNR = "000010";//物料描述
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZRFC_GET_SO");
			
			function.getImportParameterList().setValue("VBELN",VBELN);
			function.getImportParameterList().setValue("POSNR",POSNR); 
			
			function.execute(destination);//
			
			JCoTable JCoTable = function.getTableParameterList().getTable("TLINE");
			
			
			
			
			System.out.println("MAKT JCoTable:"+JCoTable.getNumRows());
			for(int i=0;i<JCoTable.getNumRows();i++){
				JCoTable.setRow(i);
				String KUNNRb = JCoTable.getString("TDFORMAT");//物料编号
				String NAME1b = JCoTable.getString("TDLINE");//物料描述
				System.out.println("MATNR:"+KUNNRb+"	ARKTX"+NAME1b);
			}
			JCoStructure stu = function.getExportParameterList().getStructure("SODETAIL");
			String tempVBELN = stu.getString("VBELN");
			System.out.println("tempVBELN="+tempVBELN);
		}catch(Exception e){
			e.printStackTrace();
		}
	}


	public static void ZF_FKSQ_OA_SAP_YT_ZZT_RETURN()
	{
		String BUKRS = "1400";//物料编码
		String GJAHR = "2014";//物料描述
		String ZSQDH = "1100000058";
		String ZZT = "L";
		 
		try{
			JCoDestination	destination = JCoDestinationManager.getDestination(ABAP_AS_POOLED);
			
			JCoFunction function = destination.getRepository().getFunction("ZF_FKSQ_OA_SAP_YT_ZZT_RETURN");
			
			function.getImportParameterList().setValue("BUKRS",BUKRS);
			function.getImportParameterList().setValue("GJAHR",GJAHR); 
			function.getImportParameterList().setValue("ZSQDH",ZSQDH); 
			function.getImportParameterList().setValue("ZZT",ZZT); 
			
			function.execute(destination);//
			
//			JCoTable JCoTable = function.getTableParameterList().getTable("TLINE");
//			
//			
//			
//			
//			System.out.println("MAKT JCoTable:"+JCoTable.getNumRows());
//			for(int i=0;i<JCoTable.getNumRows();i++){
//				JCoTable.setRow(i);
//				String KUNNRb = JCoTable.getString("TDFORMAT");//物料编号
//				String NAME1b = JCoTable.getString("TDLINE");//物料描述
//				System.out.println("MATNR:"+KUNNRb+"	ARKTX"+NAME1b);
//			}
		//	JCoStructure stu = function.getExportParameterList().getStructure("SODETAIL");
			String tempVBELN = function.getExportParameterList().getString("RETURN");
			System.out.println("tempVBELN="+tempVBELN);
		}catch(Exception e){
			e.printStackTrace();
		}
	}

    public static void main(String[] a)
    {
    	getJCoDestination(); 
    	//ZRFC_GET_MAKTX();
    	//ZF_FKSQ_OA_SAP_YT_ZZT_RETURN();
    //	ZRFC_GET_LGORT();
    	//ZRFC_GET_KUNNR();
    }
	
}
