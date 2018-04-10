import com.sap.mw.jco.*;
/**
 * @author Thomas G. Schuessler, ARAsoft GmbH
 * http://www.arasoft.de
 */
public class TutorialConnect2 extends Object {
  static final String POOL_NAME = "Pool";
  JCO.Client mConnection;
  public TutorialConnect2() {
    try {
      JCO.Pool pool = JCO.getClientPoolManager().getPool(POOL_NAME);
      if (pool == null) {
        OrderedProperties logonProperties =
          OrderedProperties.load("/logon.properties");
        JCO.addClientPool(POOL_NAME,  // pool name
                          5,          // maximum number of connections
                          logonProperties);	// properties
      }
      mConnection = JCO.getClient(POOL_NAME);
      System.out.println(mConnection.getAttributes());
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    finally {
      JCO.releaseClient(mConnection);
    }
  }
  public static void main (String args[]) {
    TutorialConnect2 app = new TutorialConnect2();
  }
}
