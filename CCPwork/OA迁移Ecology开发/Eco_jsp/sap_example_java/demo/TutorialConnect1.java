import com.sap.mw.jco.*;
/**
 * @author Thomas G. Schuessler, ARAsoft GmbH
 * http://www.arasoft.de
 */
public class TutorialConnect1 extends Object {
  JCO.Client mConnection;
  public TutorialConnect1() {
    try {
      // Change the logon information to your own system/user
      mConnection =
        JCO.createClient("001", // SAP client
          "<userid>",           // userid
          "****",               // password
          null,                 // language
          "<hostname>",         // application server host name
          "00");                // system number
      mConnection.connect();
      System.out.println(mConnection.getAttributes());
      mConnection.disconnect();
    }
    catch (Exception ex) {
      ex.printStackTrace();
      System.exit(1);
    }
  }
  public static void main (String args[]) {
    TutorialConnect1 app = new TutorialConnect1();
  }
}
