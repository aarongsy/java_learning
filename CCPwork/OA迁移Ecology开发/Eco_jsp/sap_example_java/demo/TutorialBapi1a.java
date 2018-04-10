import com.sap.mw.jco.*;
import de.arasoft.sap.jco.*;
import de.arasoft.sap.interfacing.*;
/**
 * Uses the ARAsoft JCo Extension Library which adds many
 * features useful for BAPI programming.
 * @author Thomas G. Schuessler, ARAsoft GmbH
 * http://www.arasoft.de
 */
public class TutorialBapi1a extends Object {
  JCO.Client mConnection;
// This is the ARAsoft extension of JCO.Repository
  JCoRepository mRepository;
  public TutorialBapi1a() {
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
      mRepository = new JCoRepository(mConnection);
    }
    catch (Exception ex) {
      ex.printStackTrace();
      System.exit(1);
    }
    JCO.Function function = null;
    JCO.Table codes = null;
    try {
      function = mRepository.createFunction("BAPI_COMPANYCODE_GETLIST");
      if (function == null) {
        System.out.println("BAPI_COMPANYCODE_GETLIST" +
                           " not found in SAP.");
        System.exit(1);
      }
// Using this, the code needs not to be changed for connection pools.
      mRepository.executeStateless(function);
// Check the BAPI return message
      JCO.Structure returnStructure =
        function.getExportParameterList().getStructure("RETURN");
// BapiMessageInfo hides all the differences between the various structures
// that SAP uses for the RETURN parameter of the BAPIs.
      BapiMessageInfo bapiMessage = new BapiMessageInfo(returnStructure);
      if ( ! bapiMessage.isBapiReturnCodeOkay() ) {
        System.out.println(bapiMessage.getFormattedMessage());
        System.out.println("--- Documentation for error message: ---");
// One line of code retrieves the documentation.
        String[] documentation = mRepository.getMessageDocumentation(bapiMessage);
        for (int i = 0; i < documentation.length; i++) {
          System.out.println(documentation[i]);
        }
        System.exit(1);
      }
      codes =
        function.getTableParameterList().getTable("COMPANYCODE_LIST");
      for (int i = 0; i < codes.getNumRows(); i++) {
        codes.setRow(i);
        System.out.println(codes.getString("COMP_CODE") + '\t' +
                           codes.getString("COMP_NAME"));
      }
    }
    catch (Exception ex) {
      ex.printStackTrace();
      System.exit(1);
    }
    try {
      codes.firstRow();
      for (int i = 0; i < codes.getNumRows(); i++, codes.nextRow()) {
        function = mRepository.createFunction("BAPI_COMPANYCODE_GETDETAIL");
        if (function == null) {
          System.out.println("BAPI_COMPANYCODE_GETDETAIL" +
                             " not found in SAP.");
          System.exit(1);
        }
        function.getImportParameterList().
          setValue(codes.getString("COMP_CODE"), "COMPANYCODEID");
        mConnection.execute(function);
// Check the BAPI return message
        JCO.Structure returnStructure =
          function.getExportParameterList().getStructure("RETURN");
        BapiMessageInfo bapiMessage = new BapiMessageInfo(returnStructure);
// Warning FN021 can be ignored in our case
        if ( ! bapiMessage.isBapiReturnCodeOkay(false, false, null, "FN021") ) {
          System.out.println(bapiMessage.getFormattedMessage());
          System.out.println("--- Documentation for error message: ---");
// One line of code retrieves the documentation.
          String[] documentation = mRepository.getMessageDocumentation(bapiMessage);
          for (int j = 0; j < documentation.length; j++) {
            System.out.println(documentation[j]);
          }
        }
        JCO.Structure detail =
          function.getExportParameterList().
          getStructure("COMPANYCODE_DETAIL");
        JCO.Field countryCode = detail.getField("COUNTRY");
// One line of code to retrieve the description text (in this case: the country name)
        String countryName = mRepository.getDescriptionForValue(countryCode);
        System.out.println(detail.getString("COMP_CODE") + '\t' +
                           countryCode.getString() + " (" +
                           countryName
                           + ")" + '\t' +
                           detail.getString("CITY"));
      }
    }
    catch (Exception ex) {
      ex.printStackTrace();
      System.exit(1);
    }
    mConnection.disconnect();
  }
  public static void main (String args[]) {
    TutorialBapi1a app = new TutorialBapi1a();
  }
}
