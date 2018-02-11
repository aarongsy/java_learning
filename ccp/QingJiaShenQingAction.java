

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.TimeUtil;
import weaver.general.Util;
import weaver.interfaces.workflow.action.Action;
import weaver.soa.workflow.request.Property;
import weaver.soa.workflow.request.RequestInfo;
import weaver.soa.workflow.request.Cell;
import weaver.soa.workflow.request.DetailTable;
import weaver.soa.workflow.request.Row;

public class QingJiaShenQingAction {
	
	
    private Log log = LogFactory.getLog(QingJiaShenQingAction.class.getName());

    public Log getLog() {
        return log;
    } 
    public void setLog(Log log) {
        this.log = log;
    } 
    public String execute() {
    	
    
		
		try {
		//	LeaveApplyFormWS (GH,QJLB,beginDateTime,endDateTime,QJSS);
			String endPoint = "http://weaversz01.vicp.net:8088/demo/ws/fwOrder?wsdl";
		 	String soapaction="http://speclify.service.hengli.com/";   
		    Service service = new Service();
		    Call call1 = (Call)service.createCall();
		  
		    call1.setTargetEndpointAddress(new java.net.URL(endPoint));
		    call1.setOperationName(new QName(soapaction,"getOrderInfo"));
		    call1.addParameter(new QName(soapaction,"arg0"), org.apache.axis.encoding.XMLType.XSD_INT,
		    		javax.xml.rpc.ParameterMode.INOUT);
		    call1.setReturnType(new QName(soapaction,"getOrderInfo"),String.class); 
		    call1.setUseSOAPAction(true);
		    call1.setSOAPActionURI(soapaction + "getOrderInfo");    
		 
			String str=(String)call1.invoke( new Object[]{1}); 
			
			log.info("str:"+str);
			System.out.println("str:"+str);
	 
		}catch (Exception e) {
			System.err.println(e.toString());
		}
		
        return "";
    }
    public static void main(String[] args) {
		new QingJiaShenQingAction().execute();
	}
}
