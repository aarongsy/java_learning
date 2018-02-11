package weaver.interfaces.tw.xiyf.sap.twytfybx.action;
 

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import weaver.conn.RecordSet;
import weaver.general.Util;
import weaver.hrm.resource.ResourceComInfo;
import weaver.interfaces.tw.xiyf.sap.SAPConn; 
 

import com.sap.conn.jco.JCoDestination; 
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFieldIterator;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRecordFieldIterator;
import com.sap.conn.jco.JCoStructure; 
import com.sap.conn.jco.JCoTable;
/**
 * 
 * @ClassName: YTFKExecuteBapi 
 * @Description: 读取预算SAP费用预算
 * @author xiyufei
 * @date 2014-6-18 上午11:23:51 
 *
 */
public class FYYSExecuteBapi {

	
	private JCoRecordFieldIterator JCoRecordFieldIterator = null;
	private JCoField JCoField = null;
	private static JCoDestination destination = SAPConn.getJCoDestination();

/**
 * 
 * @Title: YtfkReturnSap 
 * @Description:  盈通付款(fk) 返回sap
 * @param @param workflowId
 * @param @param requestId
 * @param @param status
 * @param @return    设定文件 
 * @return String    返回类型 
 * @throws
 */
	public static Map YtfkReturnSap(String gsdm,String hjnd,String yf,String jhlx,String ysbm,String fyyskm,String loginid,String status){
		String result_status = "";
		Map map =  new HashMap();
		try {
				JCoFunction function = destination.getRepository().getFunction("ZFI_OA2SAP_YS_YT");
 
					function.getImportParameterList().setValue("IV_BUKRS",gsdm);//1.公司代码
					function.getImportParameterList().setValue("IV_GJAHR",hjnd);//2.会记年度
					//function.getImportParameterList().setValue("IV_MONAT",yf);//3.月份
					function.getImportParameterList().setValue("IV_JHLX",jhlx);	//4.计划类型 （0计划内 针对部门,2电话费 针对人）
					function.getImportParameterList().setValue("IV_ZYSBM",ysbm);//5.预算部门
					function.getImportParameterList().setValue("IV_ZFYYSXM",fyyskm);//6.费用预算项目
					function.getImportParameterList().setValue("IV_ZUSR_CREATE",loginid);//7.人员
					function.execute(destination); 
 
					result_status =  function.getExportParameterList().getValue("EV_STATUS").toString();
					
					JCoStructure JCoStructure = null; 
					//JCoStructure = function.getImportParameterList().getStructure("ES_FYYS");   
					JCoStructure = function.getExportParameterList().getStructure("ES_FYYS");
   
					String zysje_r =  Util.null2String(JCoStructure.getValue("ZYSJE").toString());					//预算金额
					String zysje_yy_r =  Util.null2String((String) JCoStructure.getValue("ZYSJE_YY").toString());		//已用预算金额
					
					String zresult=""; 
					String message=""; 
					JCoTable  JCoTable  = null;
					JCoTable  = function.getTableParameterList().getTable("ET_MSG");
					if(!JCoTable.isEmpty()){
						JCoTable.setRow(1);
						JCoFieldIterator iterator = JCoTable.getFieldIterator();
						while (iterator.hasNextField()) {
			                // System.out.println(parameterField.getName()+"JCoFieldIterator");
			                JCoField recordField = iterator.nextField();
			                 
			                String fieldName=recordField.getName(); 
			                if("ZRESULT".contains(fieldName))
			                {
			                	zresult = recordField.getString(); 
			                	if("S".equals(zresult)){
			                		continue;
			                	}
			                }
			                if("MESSAGE".contains(fieldName))
			                {
			                	message = recordField.getString(); 
			                } 
			            }
					}
					System.out.println("zysje_r--"+zysje_r);
					map.put("ysje", zysje_r);
					map.put("yyysje", zysje_yy_r);
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ZRFC_GET_CUSTDATA
		return map;
		
	}

	 

	public static void main(String[] a) {
		try{
			List  List = new ArrayList();
			List.add(new FYBXBean());
			YtfkReturnSap("","","","","","","", "");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
