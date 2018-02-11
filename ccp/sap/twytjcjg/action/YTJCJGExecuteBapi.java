package weaver.interfaces.tw.xiyf.sap.twytjcjg.action;
 

import java.util.ArrayList;
import java.util.List;
 
import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.Util; 
import weaver.interfaces.tw.xiyf.sap.SAPConn;  
 

import com.sap.conn.jco.JCoDestination; 
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoField;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRecordFieldIterator; 
import com.sap.conn.jco.JCoTable;

/**
 * 
 * @ClassName: YTJGBDExecuteBapi 
 * @Description: TODO
 * @author xiyufei
 * @date 2014-12-4 上午9:46:30 
 *
 */
public class YTJCJGExecuteBapi {

	
	private JCoRecordFieldIterator JCoRecordFieldIterator = null;
	private JCoField JCoField = null;
	private static JCoDestination destination = SAPConn.getJCoDestination();

/**
 * 
 * @Title: YtjcjgReturnSap 
 * @Description: TODO(这里用一句话描述这个方法的作用) 
 * @param @param list
 * @param @param creator
 * @param @param status
 * @param @return    设定文件 
 * @return String    返回类型 
 * @throws
 */
	public static String YtjcjgReturnSap(List list,String creator,String status){
		BaseBean bb = new BaseBean();
		String result = "";
		try {
			JCoFunction function = destination.getRepository().getFunction("ZYW_CREATE_PRICE_FOR_VA00");
 
			
				//if(SAPConstant.S_STATU_L.equals(status)){//status为L时返回合同信息
					JCoTable  JCoTable  = null;
//					RecordSet rs = new RecordSet();
//					rs.execute("select tablename from workflow_base a,workflow_bill b where a.formid=b.id and a.id="+workflowId);
//					rs.next();
//					String maintable = Util.null2String(rs.getString("tablename"));
//					rs.execute("select a.* from "+ maintable+" a,workflow_requestbase b where a.requestid=b.requestid and b.workflowid="+workflowId+" and a.requestid="+requestId+"");
//					rs.next(); 
	
					function.getImportParameterList().setValue("S_FLAG","F");
					function.getImportParameterList().setValue("S_UNAME",creator);
					JCoTable  = function.getTableParameterList().getTable("T_ZSVA00");
					for (int i = 0; i < list.size(); i++) {
						JCJGBean JCJGBean = (JCJGBean) list.get(i);
						JCoTable.appendRow();
						JCoTable.setRow(i);     
						JCoTable.setValue("VKORG",  Util.null2String(JCJGBean.getVKORG()));
						JCoTable.setValue("MATNR",  Util.null2String(JCJGBean.getMATNR()));
						//JCoTable.setValue("VARCOND",  Util.null2String(JCJGBean.getVARCOND()));
						JCoTable.setValue("KBETR",  Util.null2String(JCJGBean.getKBETR()));
						JCoTable.setValue("KONWA",  Util.null2String(JCJGBean.getKONWA()));
						JCoTable.setValue("KPEIN",  Util.null2String(JCJGBean.getKPEIN()));
						JCoTable.setValue("KMEIN",  Util.null2String(JCJGBean.getKMEIN()));
						JCoTable.setValue("DATAB",  Util.null2String(JCJGBean.getDATAB()));
						JCoTable.setValue("DATBI",  Util.null2String(JCJGBean.getDATBI()));
//						JCoTable.setValue("S_FLAG","F");
//						JCoTable.setValue("S_UNAME",creator);
						bb.writeLog("创建人:"+creator); 
						bb.writeLog("销售组织:"+Util.null2String(JCJGBean.getVKORG())); 
						bb.writeLog("物料号:"+Util.null2String(JCJGBean.getMATNR())); 
						//bb.writeLog("变式条件:"+Util.null2String(JCJGBean.getVARCOND())); 
						bb.writeLog("价格:"+Util.null2String(JCJGBean.getKBETR())); 
						bb.writeLog("比率单位:"+Util.null2String(JCJGBean.getKONWA())); 
						bb.writeLog("条件定价单位:"+Util.null2String(JCJGBean.getKPEIN())); 
						bb.writeLog("条件单位:"+Util.null2String(JCJGBean.getKMEIN())); 
						bb.writeLog("开始生效日期:"+Util.null2String(JCJGBean.getDATAB())); 
						bb.writeLog("有效截至日期:"+Util.null2String(JCJGBean.getDATBI())); 
					}
					
					function.execute(destination);
					result =  function.getExportParameterList().getValue("S_RETURN").toString(); 
					System.out.println("result="+result);
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ZRFC_GET_CUSTDATA
		return result;
		
	}

	 

	public static void main(String[] a) {
		try{
			List  List = new ArrayList(); 
			YTJCJGExecuteBapi.YtjcjgReturnSap(List, "","");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
