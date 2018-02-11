package weaver.interfaces.tw.xiyf.sap.twytzch.action;
 

import java.util.ArrayList;
import java.util.List;
 
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
 * @ClassName: YTFKExecuteBapi 
 * @Description: 盈通费用报销调用sap类
 * @author xiyufei
 * @date 2014-6-18 上午11:23:51 
 *
 */
public class YTZCHExecuteBapi {

	
	private JCoRecordFieldIterator JCoRecordFieldIterator = null;
	private JCoField JCoField = null;
	private static JCoDestination destination = SAPConn.getJCoDestination();

/**
 * 
 * @Title: YtzchReturnSap 
 * @Description:  盈通资产 返回sap
 * @param @param workflowId
 * @param @param requestId
 * @param @param status
 * @param @return    设定文件 
 * @return String    返回类型 
 * @throws
 */
	public static String YtzchReturnSap(List list,String status){
		String messages = "";
		String result = "";
		try {
			JCoFunction function = destination.getRepository().getFunction("ZFI_OA2SAP_ZCKP_YT");
 
			
				//if(SAPConstant.S_STATU_L.equals(status)){//status为L时返回合同信息
					JCoTable  JCoTable  = null;
//					RecordSet rs = new RecordSet();
//					rs.execute("select tablename from workflow_base a,workflow_bill b where a.formid=b.id and a.id="+workflowId);
//					rs.next();
//					String maintable = Util.null2String(rs.getString("tablename"));
//					rs.execute("select a.* from "+ maintable+" a,workflow_requestbase b where a.requestid=b.requestid and b.workflowid="+workflowId+" and a.requestid="+requestId+"");
//					rs.next();IT_OA_BXD  ZSOA_EXP_TRANSFER
	
					JCoTable  = function.getTableParameterList().getTable("IT_OA_ZCKP");
					for (int i = 0; i < list.size(); i++) {
						ZCHBean ZCHBean = (ZCHBean) list.get(i);
						JCoTable.appendRow();
						JCoTable.setRow(i);     
						JCoTable.setValue("ANLKL",  Util.null2String(ZCHBean.getZclbdm()));
						JCoTable.setValue("BUKRS",  Util.null2String(ZCHBean.getSsgsdm()));
						JCoTable.setValue("KOSTL",  Util.null2String(ZCHBean.getSsbmdm()));
						JCoTable.setValue("INVNR",  Util.null2String(ZCHBean.getDjbh()));
						JCoTable.setValue("ZSBLX",  Util.null2String(ZCHBean.getSblx()));
						JCoTable.setValue("ZSBLX",  Util.null2String(ZCHBean.getSblx()));
						JCoTable.setValue("ZSBMCJXH",  Util.null2String(ZCHBean.getSbmcjxh()));
						JCoTable.setValue("ZPZYT",  Util.null2String(ZCHBean.getPzyt())); 
					}
				 
					function.execute(destination);
					result =  function.getExportParameterList().getValue("EV_STATUS").toString();

					if("F".equals(result)){
						JCoTable  JCoTable2  = null;
						JCoTable2  = function.getTableParameterList().getTable("ET_MSG");
						for (int j = 0; j < JCoTable2.getNumRows(); j++) {
							String zresult =Util.null2String((String) JCoTable2.getValue("ZRESULT").toString());
							String message =Util.null2String((String) JCoTable2.getValue("MESSAGE").toString());
							if("".equals(messages)){
								messages = message;
							}else{
								messages = messages+"<br>"+message;
							}
						}
					}
					System.out.println("messages="+messages);
		} catch (JCoException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // ZRFC_GET_CUSTDATA
		return messages;
		
	}

	 

	public static void main(String[] a) {
		try{
			List  List = new ArrayList();
			List.add(new ZCHBean());
			YtzchReturnSap(List, "");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
