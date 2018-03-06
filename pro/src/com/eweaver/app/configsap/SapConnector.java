package com.eweaver.app.configsap;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoFunctionTemplate;
import com.sap.conn.jco.JCoRepository;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Hashtable;
import java.util.Properties;

public class SapConnector
{
  public static Hashtable<String, JCoDestination> destinations = new Hashtable();
  public static final String fdPoolName = "sanpowersap";

  static
  {
    try
    {
      doInitialize();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public static synchronized void doInitialize()
    throws Exception
  {
    Properties sapConfig = new Properties();

    InputStream is = SapConnector.class
      .getResourceAsStream("/sap-config.properties");
    sapConfig.load(is);

    createDataFile("sanpowersap", "jcoDestination", sapConfig);
  }

  private static void createDataFile(String name, String suffix, Properties properties)
  {
    File cfg = new File(name + "." + suffix);
    try {
      FileOutputStream fos = new FileOutputStream(cfg, false);
      properties.store(fos, "for connection");
      fos.close();
    } catch (Exception e) {
      throw new RuntimeException("Unable to create the destination file " + 
        cfg.getName(), e);
    }
  }

  public static JCoDestination getDestination(String fdPoolName)
    throws Exception
  {
    JCoDestination destination = null;
    if (destinations.containsKey(fdPoolName)) {
      destination = (JCoDestination)destinations.get(fdPoolName);
    } else {
      destination = JCoDestinationManager.getDestination(fdPoolName);
      destinations.put(fdPoolName, destination);
    }
    return destination;
  }

  public static JCoFunctionTemplate getRfcTemplate(String rfcName, String fdPoolName)
    throws Exception
  {
    JCoDestination destination = getDestination(fdPoolName);
    JCoRepository repository = null;
    try {
      repository = destination.getRepository();
    } catch (Exception e) {
      destination = JCoDestinationManager.getDestination(fdPoolName);
      destinations.remove(fdPoolName);
      destinations.put(fdPoolName, destination);
      repository = destination.getRepository();
    }
    JCoFunctionTemplate template = repository.getFunctionTemplate(rfcName);
    return template;
  }

  public static JCoFunction getRfcFunction(String rfcName)
    throws Exception
  {
    JCoFunction function = null;
    JCoFunctionTemplate template = getRfcTemplate(rfcName, "sanpowersap");
    if (template != null) {
      function = template.getFunction();
    }
    return function;
  }
}