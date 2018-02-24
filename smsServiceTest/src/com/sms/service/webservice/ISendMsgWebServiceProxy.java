package com.sms.service.webservice;

public class ISendMsgWebServiceProxy implements com.sms.service.webservice.ISendMsgWebService {
  private String _endpoint = null;
  private com.sms.service.webservice.ISendMsgWebService iSendMsgWebService = null;
  
  public ISendMsgWebServiceProxy() {
    _initISendMsgWebServiceProxy();
  }
  
  public ISendMsgWebServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initISendMsgWebServiceProxy();
  }
  
  private void _initISendMsgWebServiceProxy() {
    try {
      iSendMsgWebService = (new com.sms.service.webservice.ISendMsgWebServiceServiceLocator()).getISendMsgWebServicePort();
      if (iSendMsgWebService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)iSendMsgWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)iSendMsgWebService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (iSendMsgWebService != null)
      ((javax.xml.rpc.Stub)iSendMsgWebService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public com.sms.service.webservice.ISendMsgWebService getISendMsgWebService() {
    if (iSendMsgWebService == null)
      _initISendMsgWebServiceProxy();
    return iSendMsgWebService;
  }
  
  public java.lang.String sendMsg(java.lang.String arg0, java.lang.String arg1, java.lang.String arg2, java.lang.String arg3) throws java.rmi.RemoteException{
    if (iSendMsgWebService == null)
      _initISendMsgWebServiceProxy();
    return iSendMsgWebService.sendMsg(arg0, arg1, arg2, arg3);
  }
  
  
}