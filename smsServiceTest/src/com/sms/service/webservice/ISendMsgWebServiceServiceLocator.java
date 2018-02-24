/**
 * ISendMsgWebServiceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.sms.service.webservice;

public class ISendMsgWebServiceServiceLocator extends org.apache.axis.client.Service implements com.sms.service.webservice.ISendMsgWebServiceService {

    public ISendMsgWebServiceServiceLocator() {
    }


    public ISendMsgWebServiceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ISendMsgWebServiceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ISendMsgWebServicePort
    private java.lang.String ISendMsgWebServicePort_address = "http://localhost:8080/sms/services/sendMsg";

    public java.lang.String getISendMsgWebServicePortAddress() {
        return ISendMsgWebServicePort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ISendMsgWebServicePortWSDDServiceName = "ISendMsgWebServicePort";

    public java.lang.String getISendMsgWebServicePortWSDDServiceName() {
        return ISendMsgWebServicePortWSDDServiceName;
    }

    public void setISendMsgWebServicePortWSDDServiceName(java.lang.String name) {
        ISendMsgWebServicePortWSDDServiceName = name;
    }

    public com.sms.service.webservice.ISendMsgWebService getISendMsgWebServicePort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ISendMsgWebServicePort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getISendMsgWebServicePort(endpoint);
    }

    public com.sms.service.webservice.ISendMsgWebService getISendMsgWebServicePort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.sms.service.webservice.ISendMsgWebServiceServiceSoapBindingStub _stub = new com.sms.service.webservice.ISendMsgWebServiceServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getISendMsgWebServicePortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setISendMsgWebServicePortEndpointAddress(java.lang.String address) {
        ISendMsgWebServicePort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.sms.service.webservice.ISendMsgWebService.class.isAssignableFrom(serviceEndpointInterface)) {
                com.sms.service.webservice.ISendMsgWebServiceServiceSoapBindingStub _stub = new com.sms.service.webservice.ISendMsgWebServiceServiceSoapBindingStub(new java.net.URL(ISendMsgWebServicePort_address), this);
                _stub.setPortName(getISendMsgWebServicePortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("ISendMsgWebServicePort".equals(inputPortName)) {
            return getISendMsgWebServicePort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://webservice.service.sms.com/", "ISendMsgWebServiceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://webservice.service.sms.com/", "ISendMsgWebServicePort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ISendMsgWebServicePort".equals(portName)) {
            setISendMsgWebServicePortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
