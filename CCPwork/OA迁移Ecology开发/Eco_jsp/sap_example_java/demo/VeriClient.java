/**
 * VeriClient.java
 */
import com.sap.mw.jco.*;
import java.io.*;
import java.util.*;

/**
 * @version     1.0
 * @author      Bernd Follmeg
 */

//******************************************************************************
public class VeriClient implements JCO.PoolChangedListener {
//******************************************************************************

    public void poolChanged(JCO.Pool pool)
    {
        //StringBuffer sb = new StringBuffer("poolChanged: ").append(pool.getName())
        //                  .append("#allocated connections: ").append(pool.getNumUsed()).append(", ")
        //                  .append("#connections in pool: ").append(pool.getCurrentPoolSize() - pool.getNumUsed());
        //System.out.println(sb.toString());
    }

    protected static String properties_filename = "./vericlient.properties";
    protected static Properties login_properties = null;
    protected static Test[] tests = null;

    static {
        tests = new Test[4];
        tests[0] = new TestConnections();
        tests[1] = new TestContainers();
        tests[2] = new TestRepository();
        tests[3] = new TestFunctionCalls();
    }

    public static void setLoginProperties(Properties props)
    {
        login_properties = props;
    }

    /**
     *  Returns the login properties
     */
    public static Properties getLoginProperties()
    {
        if (login_properties == null) {
            login_properties = new Properties();
            try {
                login_properties.load(new FileInputStream(properties_filename));
            }
            catch (IOException ex) {
                System.out.println(ex);
                System.exit(1);
            }//try
        }
        return login_properties;
    }

    public static void printMethod(String method)
    {
        System.out.print(" " + method);
        int istart = 60 - method.length();
        for (int i = istart; i > 0; i--) System.out.print('.');
    }

    public static void printStatus(Exception ex)
    {
        String status = (ex == null ? "ok" : "failed");
        System.out.println(status);
        if (ex != null) {
            System.out.println();
            System.out.println();
            ex.printStackTrace();
            System.exit(1);
        }//if
    }

    public static void printProlog()
    {
        String [] localArgs = {"-stdout"};
        new com.sap.mw.jco.About().show(localArgs);
        // this code was replaced by info from About.java
    /*
        String libjrfc_version = JCO.getMiddlewareProperty("jco.middleware.libjrfc_version");
        String libjrfc_path    = JCO.getMiddlewareProperty("jco.middleware.libjrfc_path");
        String librfc_version  = JCO.getMiddlewareProperty("jco.middleware.librfc_numversion");

        String jversion = System.getProperty("java.version");
        String jvendor  = System.getProperty("java.vendor");
        String osname   = System.getProperty("os.name") + " " + System.getProperty("os.version") + " for "
                        + System.getProperty("os.arch");
      */
        System.out.println("--------------------------------------------------------------------------------------");
        System.out.println("----------------------------- Jayco TestSuite ----------------------------------------");
        System.out.println("--------------------------------------------------------------------------------------");
      /*
        System.out.println(" Java Version:           " + jversion + " " + jvendor);
        System.out.println(" Operating System:       " + osname);
        System.out.println(" JCo API Version:        " + JCO.getVersion());
        System.out.println(" JCo Middleware Version: " + JCO.getMiddlewareVersion());

        if (librfc_version != null) {
            System.out.println(" JCo librfc  Version:    " + librfc_version);
        }//if
        if (libjrfc_version != null) {
            System.out.println(" JCo libjRFC Version:    " + libjrfc_version);
        }//if
        if (libjrfc_path != null) {
            System.out.println(" JCo libjRFC Path:       " + libjrfc_path);
        }//if

        try {
            String remote = "???";
            JCO.Client client = JCO.createClient(getLoginProperties());
            client.connect();
            JCO.Attributes a = client.getAttributes();
            if (a.getPartnerType() == '2' || a.getPartnerType() == '3') {
                remote = "R/" + a.getPartnerType() + " " + a.getPartnerRelease();
            }
            else {
                remote = a.getPartnerType() + " " + a.getPartnerRelease();
            }//if
            System.out.println(" Remote System:          " + remote);
            System.out.println(" Own    codepage:        " + a.getOwnCodepage());
            System.out.println(" Remote codepage:        " + a.getPartnerCodepage());
            client.disconnect();
        }
        catch (Exception ex) {}
     */
        System.out.println(" Date:                   " + new Date());
        System.out.println("--------------------------------------------------------------------------------------");
        System.out.println("------------------------- Connection Parameters --------------------------------------");
        System.out.println("--------------------------------------------------------------------------------------");
        Properties p = getLoginProperties();
        for (Enumeration e = p.keys(); e.hasMoreElements(); ) {
            String key = (String)e.nextElement();
            String val = (String)p.get(key);
            System.out.print(" " + key + ": ");
            int istart = 22 - key.length();
            for (int i = istart; i > 0; i--) System.out.print(' ');
            System.out.println(val);
        }//for

        System.out.println("--------------------------------------------------------------------------------------");
        System.out.println(" Test ------------------------------------------------------ Status ------------------");
        System.out.println("--------------------------------------------------------------------------------------");
    }

    public static void printEpilog()
    {
        System.out.println("--------------------------------------------------------------------------------------");
        System.out.println("---------------------------------- Done ----------------------------------------------");
        System.out.println("--------------------------------------------------------------------------------------");
    }

    /**
     *  Base class for all test classes
     */
    protected static abstract class Test {
        public abstract void run();
    }


    /**
     *  Test the opening, closing of connections
     */
    public static class TestConnections extends Test {

        /**
         *  Test opening, closing, attributes of a
         *  simple non-pooled connection
         */
        public void testSimpleConnection()
        {
            JCO.Client client = null;

            try {
                printMethod("JCO.createClient()");
                client = JCO.createClient(getLoginProperties());
                printStatus(null);

                printMethod("client.connect()");
                client.connect();
                printStatus(null);

                printMethod("client.getAttributes()");
                client.getAttributes();
                printStatus(null);

                printMethod("client.disconnect()");
                client.disconnect();
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try

        }

        /**
         *  Test creating, deletion of a client pool.
         */
        public void testPooledConnection()
        {
            JCO.Client client1, client2;

            try {
                printMethod("JCO.addClientPool() single-threaded");
                JCO.addClientPool("BF",10,getLoginProperties());
                printStatus(null);

                printMethod("JCO.getClient() single-threaded");
                client1 = JCO.getClient("BF");
                //client2 = JCO.getClient("BF");
                printStatus(null);

                printMethod("JCO.releaseClient() single-threaded");
                JCO.releaseClient(client1);
                //JCO.releaseClient(client2);
                printStatus(null);

                printMethod("JCO.removeClientPool() single-threaded");
                JCO.removeClientPool("BF");
                printStatus(null);
            }
            catch (JCO.Exception ex) {
                printStatus(ex);
                JCO.removeClientPool("BF");
            }//try

            try {
                printMethod("JCO.addClientPool() multi-threaded");
                JCO.addClientPool("BF",1,getLoginProperties());
                printStatus(null);

                //System.out.println("Main.Thread: " + Thread.currentThread().getName());

                ClientProcess p1 = new ClientProcess("T1"), p2 = new ClientProcess("T2"), p3 = new ClientProcess("T3");
                p1.start();
                try { Thread.currentThread().sleep(200); } catch (InterruptedException ex) {}
                p2.start();
                try { Thread.currentThread().sleep(500); } catch (InterruptedException ex) {}
                p3.start();

                try { p1.join(); p2.join(); p3.join();} catch (InterruptedException ex) {}

                printMethod("JCO.removeClientPool() multi-threaded");

                JCO.removeClientPool("BF");
                printStatus(null);

            }
            catch (JCO.Exception ex) {
                printStatus(ex);
                JCO.removeClientPool("BF");
            }//try

            try {
                printMethod("JCO.addClientPool() limit = 50");
                JCO.addClientPool("BF",50,getLoginProperties());
                printStatus(null);

                printMethod("JCO.getClient() limit = 50");

                JCO.Client[] clients = new JCO.Client[50];
                for (int i = 0; i < clients.length; i++) clients[i] = JCO.getClient("BF");
                printStatus(null);

                printMethod("JCO.releaseClient() limit = 50");
                for (int i = 0; i < clients.length; i++) JCO.releaseClient(clients[i]);
                printStatus(null);

                printMethod("JCO.removeClientPool() limit = 100");
                JCO.removeClientPool("BF");
                printStatus(null);
            }
            catch (JCO.Exception ex) {
                printStatus(ex);
                JCO.removeClientPool("BF");
            }//try
        }

        protected static class ClientProcess extends Thread {

            public ClientProcess(String name)
            {
                super(name);
            }

            public void run()
            {
                //System.out.println("Starting thread " + this.getName());
                try {
                    //printMethod("JCO.getClient("+ getName() +") multi-threaded");
                    //System.out.println("Thread " + this.getName() + " calls getClient()");
                    JCO.Client client = JCO.getClient("BF");
                    //printStatus(null);
                    try { sleep(2000); } catch (InterruptedException ex) {}
                    //printMethod("JCO.releaseClient("+ getName() +") multi-threaded");

                    //System.out.println("Thread " + this.getName() + " calls releaseClient()");
                    JCO.releaseClient(client);
                    //printStatus(null);
                }
                catch (JCO.Exception ex) {
                    printStatus(ex);
                }//try
            }
        }

        /**
         *  Run the tests
         */
        public void run()
        {
            testSimpleConnection();
            testPooledConnection();
        }
    }

    /**
     *  Test the data containers
     */
    public static class TestContainers extends Test {

        private static JCO.MetaData tmeta;
        private static JCO.MetaData smeta;

        private static String[] data  = {"Chars","12","34","56","7890","123.45", "678.90", "2000-10-20", "10:11:12",
                                        "0123456789ABCDEF", "String", "01234567890ABCDEF"};

        private static String[] check = {"Chars","12","34","56","007890","123.45", "678.9", "2000-10-20", "10:11:12",
                                        "0123456789ABCDEF00000000000000", "String", "01234567890ABCDEF0", "TEST", "TEST"};

        /**
         *  Check field value of a record
         */
        private void checkFields(JCO.Record rec) throws Exception
        {
            if (rec instanceof JCO.Table && ((JCO.Table)rec).getNumRows() == 0) return;

            //------------------------------------------------------------
            // Loop over all fields
            //------------------------------------------------------------
            int i;
            for (i = 0; i < rec.getFieldCount(); i++) {
                if (rec.getType(i) == JCO.TYPE_STRUCTURE) {
                    JCO.Structure s = rec.getStructure(i);
                    checkFields(s);
                }
                else if (rec.getType(i) == JCO.TYPE_TABLE) {
                    JCO.Table t = rec.getTable(i);
                    if (t.getNumRows() > 0) {
                        t.firstRow();
                        do {
                            checkFields(t);
                        }
                        while (t.nextRow());
                        t.firstRow();
                    }//for
                }
                else if (rec.isInitialized(i)) {
                    String value = rec.getString(i);
                    if (!check[i].equals(value)) {
                        printStatus(new Exception(rec.getName(i) + ": " + value + " != " + check[i]));
                    }//if
                }//if
            }//for

            //------------------------------------------------------------
            // Same as above but now with enumerator
            //------------------------------------------------------------
            i = 0;
            for (JCO.FieldIterator e = rec.fields(); e.hasMoreElements();) {
                JCO.Field f = e.nextField();

                if (f.getType() == JCO.TYPE_STRUCTURE) {
                    JCO.Structure s = f.getStructure();
                    checkFields(s);
                }
                else if (f.getType() == JCO.TYPE_TABLE) {
                    JCO.Table t = f.getTable();
                    if (t.getNumRows() > 0) {
                        t.firstRow();
                        do {
                            checkFields(t);
                        }
                        while (t.nextRow());
                        t.firstRow();
                    }//for
                }
                else if (f.isInitialized()) {
                    String value = f.getString();
                    if (!check[i].equals(value)) {
                        printStatus(new Exception(rec.getName(i) + ": " + value + " != " + check[i]));
                    }//if
                }//if
                i++;
            }//for
        }

        private void testMetaData()
        {
            try {
                printMethod("new JCO.MetaData()");
                smeta = new JCO.MetaData("TEST");
                printStatus(null);

                printMethod("meta.addInfo()");
                smeta.addInfo("FIELD_CHAR",     JCO.TYPE_CHAR,    32, -1, 0);
                smeta.addInfo("FIELD_INT" ,     JCO.TYPE_INT,      4, -1, 0);
                smeta.addInfo("FIELD_INT2",     JCO.TYPE_INT2,     2, -1, 0);
                smeta.addInfo("FIELD_INT1",     JCO.TYPE_INT1,     1, -1, 0);
                smeta.addInfo("FIELD_NUM",      JCO.TYPE_NUM,      6, -1, 0);
                smeta.addInfo("FIELD_BCD",      JCO.TYPE_BCD,     10, -1, 2);
                smeta.addInfo("FIELD_FLOAT",    JCO.TYPE_FLOAT,   10, -1, 2);
                smeta.addInfo("FIELD_DATE",     JCO.TYPE_DATE,    10, -1, 0);
                smeta.addInfo("FIELD_TIME",     JCO.TYPE_TIME,    10, -1, 0);
                smeta.addInfo("FIELD_BYTE",     JCO.TYPE_BYTE,    15, -1, 0);
                smeta.addInfo("FIELD_STRING",   JCO.TYPE_STRING,  32, -1, 0);
                smeta.addInfo("FIELD_XSTRING",  JCO.TYPE_XSTRING, 15, -1, 0);
                printStatus(null);

                printMethod("meta.clone()");
                tmeta = (JCO.MetaData)smeta.clone();
                printStatus(null);

                printMethod("meta.addInfo()");
                tmeta.addInfo("FIELD_STRUCTURE",JCO.TYPE_STRUCTURE, 32, -1, 0, 0, smeta);
                tmeta.addInfo("FIELD_TABLE",    JCO.TYPE_TABLE,     32, -1, 0, 0, smeta);
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testParameterList()
        {
            if (smeta == null) testMetaData();
            try {
                printMethod("new JCO.ParameterList()");
                JCO.ParameterList p = new JCO.ParameterList();
                printStatus(null);

                printMethod("param.addInfo()");
                for (int i = 0; i < data.length; i++) {
                     p.addInfo(smeta.getName(i),smeta.getType(i),smeta.getLength(i),-1,smeta.getDecimals(i));
                }//for
                printStatus(null);

                printMethod("param.setValue(\"\")");
                for (int i = 0; i < data.length; i++) {
                     p.setValue("",smeta.getName(i));
                }//for
                printStatus(null);


                printMethod("param.setValue(\"Text\")");
                for (int i = 0; i < data.length; i++) {
                     p.setValue(data[i],smeta.getName(i));
                }//for
                printStatus(null);


                p = new JCO.ParameterList();
                printMethod("param.appendValue()");
                for (int i = 0; i < data.length; i++) {
                     p.appendValue(smeta.getName(i),smeta.getType(i),smeta.getLength(i),smeta.getDecimals(i),data[i]);
                }//for
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testStructure()
        {
            if (smeta == null) testMetaData();
            try {
                printMethod("new JCO.Structure(meta)");
                JCO.Structure s = new JCO.Structure(smeta);
                printStatus(null);

                printMethod("struc.setValue(\"\")");
                for (int i = 0; i < data.length; i++) s.setValue("",s.getName(i));
                printStatus(null);

                printMethod("struc.setValue(\"Text\")");
                for (int i = 0; i < data.length; i++) s.setValue(data[i],s.getName(i));
                printStatus(null);

                printMethod("struc.getString()");
                checkFields(s);
                printStatus(null);

                printMethod("struc.clone()");
                JCO.Structure s2 = (JCO.Structure)s.clone();
                checkFields(s2);
                printStatus(null);

                if (JCO.getVersion().charAt(0) == '2') {
                    printMethod("new JCO.Structure(structure)");
                    s2 = new JCO.Structure(s);
                    checkFields(s2);
                    printStatus(null);
                }//if

            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testTable()
        {
            int NUM_ROWS = 3;

            if (tmeta == null) testMetaData();
            try {
                printMethod("new JCO.Table(meta)");
                JCO.Table t = new JCO.Table(tmeta);
                printStatus(null);

                printMethod("table.appendRow()");
                for (int j = 0; j < NUM_ROWS; j++) {
                    t.appendRow();
                    for (int i = 0; i < data.length; i++) t.setValue(data[i],t.getName(i));

                    JCO.Structure s2 = t.getStructure(data.length);
                    for (int i = 0; i < data.length; i++) s2.setValue(data[i],s2.getName(i));

                    JCO.Table t2 = t.getTable(data.length+1);
                    t2.appendRows(NUM_ROWS);
                    for (int j2 = 0; j2 < NUM_ROWS; j2++) {
                        for (int i = 0; i < data.length; i++) t2.setValue(data[i],t2.getName(i));
                        t2.nextRow();
                    }//for
                    t2.firstRow();
                }//for
                printStatus(null);

                printMethod("new JCO.Table(table.getMetaData())");
                JCO.Table tc = new JCO.Table(t.getMetaData());
                for (int j = 0; j < 1; j++) {
                    tc.appendRow();
                    for (int i = 0; i < data.length; i++) tc.setValue(data[i],t.getName(i));

                    JCO.Structure s2 = tc.getStructure(data.length);
                    for (int i = 0; i < data.length; i++) s2.setValue(data[i],s2.getName(i));

                    JCO.Table t2 = tc.getTable(data.length+1);
                    t2.appendRows(NUM_ROWS);
                    for (int j2 = 0; j2 < NUM_ROWS; j2++) {
                        for (int i = 0; i < data.length; i++) t2.setValue(data[i],t2.getName(i));
                        t2.nextRow();
                    }//for
                    t2.firstRow();
                }//for
                //checkFields(tc);
                printStatus(null);

                printMethod("table.clone()");
                tc = (JCO.Table)t.clone();
                checkFields(tc);
                printStatus(null);

                if (JCO.getVersion().charAt(0) == '2') {
                    printMethod("new JCO.Table(table)");
                    tc = (JCO.Table)new JCO.Table(t);
                    checkFields(tc);
                    printStatus(null);
                }//if

                printMethod("table.insertRow()");
                for (int j = 0; j < NUM_ROWS; j++) {
                    t.insertRow(0);
                    for (int i = 0; i < data.length; i++) t.setValue(data[i],t.getName(i));

                    JCO.Structure s2 = t.getStructure(data.length);
                    for (int i = 0; i < data.length; i++) s2.setValue(data[i],s2.getName(i));

                    JCO.Table t2 = t.getTable(data.length+1);
                    t2.appendRows(NUM_ROWS);
                    for (int j2 = 0; j2 < NUM_ROWS; j2++) {
                        for (int i = 0; i < data.length; i++) t2.setValue(data[i],t2.getName(i));
                        t2.nextRow();
                    }//for
                    t2.firstRow();

                }//for
                printStatus(null);

                printMethod("table.deleteRow() " + t.getNumRows());
                t.setRow(t.getNumRows()-2);


                t.deleteRow(t.getNumRows()-1);
                t.deleteRow(2);
                t.deleteRow(0);

                if (t.getRow() != (NUM_ROWS-1))
                    printStatus(new Exception("getRow() != " + (NUM_ROWS-1) + ", but " + t.getRow()));
                else
                    printStatus(null);

                printMethod("table.getNumColumns()");
                if (t.getNumColumns() != tmeta.getFieldCount())
                    printStatus(new Exception("No. of columns != " + tmeta.getFieldCount()));
                else
                    printStatus(null);

                printMethod("table.getNumRows()");
                if (t.getNumRows() != NUM_ROWS)
                    printStatus(new Exception("No. of rows != " + NUM_ROWS));
                else
                    printStatus(null);

                printMethod("table.firstRow()");
                t.firstRow();
                printStatus(null);

                printMethod("table.getString()");
                checkFields(t);
                printStatus(null);

                printMethod("table.nextRow(), for(;;)");
                t.firstRow();
                for (int j = 0; j < t.getNumRows(); j++) {
                    checkFields(t);
                    t.nextRow();
                }//for
                printStatus(null);

                printMethod("table.nextRow(), while(...)");
                t.firstRow();
                do {
                    checkFields(t);
                } while(t.nextRow());
                printStatus(null);

                printMethod("table.previousRow(), while(...)");
                t.lastRow();
                do {
                    checkFields(t);
                } while(t.previousRow());
                printStatus(null);

                printMethod("ostream.writeObject(table)");
                FileOutputStream fos = new FileOutputStream("jcoveri.dat");
                ObjectOutputStream os = new ObjectOutputStream(fos);
                os.writeObject(t);
                os.flush();
                fos.close();
                printStatus(null);

                printMethod("istream.readObject(table)");
                FileInputStream fis = new FileInputStream("jcoveri.dat");
                ObjectInputStream is = new ObjectInputStream(fis);
                tc = (JCO.Table)is.readObject();
                is.close();
                checkFields(tc);
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testSpecialValues()
        {
            if (smeta == null) testMetaData();
            try {
                JCO.Structure s = new JCO.Structure(smeta);

                printMethod("record.setValue(\"0000-00-00\",\"DATE\")");
                s.setValue("0000-00-00","FIELD_DATE");
                if (s.getDate("FIELD_DATE") != null || !s.getString("FIELD_DATE").equals("0000-00-00")) {
                    printStatus(new Exception("Setting a date of 0000-00-00 does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(\"9999-99-99\",\"DATE\")");
                s.setValue("9999-99-99","FIELD_DATE");
                if (!s.getString("FIELD_DATE").equals("9999-99-99")) {
                    printStatus(new Exception("Setting a date of 9999-99-99 does not return " +
                            " the same value, got " + s.getString("FIELD_DATE") + " instead"));
                }
                else {
                    printStatus(null);
                }//if


                printMethod("record.setValue(\"00:00:00\",\"TIME\")");
                s.setValue("00:00:00","FIELD_TIME");
                if (!s.getString("FIELD_TIME").equals("00:00:00")) {
                    printStatus(new Exception("Setting a time of 00:00:00 does not return the same value "+ s.getString("FIELD_TIME")));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(\"24:00:00\",\"TIME\")");
                s.setValue("24:00:00","FIELD_TIME");
                if (!s.getString("FIELD_TIME").equals("24:00:00")) {
                    printStatus(new Exception("Setting a time of 24:00:00 does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(0,\"FIELD_INT1\")");
                s.setValue(0,"FIELD_INT1");
                if (s.getInt("FIELD_INT1") != 0) {
                    printStatus(new Exception("Setting a short to 0 does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(255,\"FIELD_INT1\")");
                s.setValue(255,"FIELD_INT1");
                if (s.getInt("FIELD_INT1") != 255) {
                    printStatus(new Exception("Setting a short to 255 does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(Short.MIN_VALUE,\"FIELD_INT2\")");
                s.setValue((int)Short.MIN_VALUE,"FIELD_INT2");
                if (s.getInt("FIELD_INT2") != Short.MIN_VALUE) {
                    printStatus(new Exception("Setting a short to " + Short.MIN_VALUE +
                        " does return a wrong value of " + s.getInt("FIELD_INT2")));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(Short.MAX_VALUE,\"FIELD_INT2\")");
                s.setValue((int)Short.MAX_VALUE,"FIELD_INT2");
                if (s.getInt("FIELD_INT2") != Short.MAX_VALUE) {
                    printStatus(new Exception("Setting a short to " + Short.MAX_VALUE + " does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

                printMethod("record.setValue(\"ABCDEF012345678\",\"FIELD_BYTE\")");
                s.setValue("ABCDEF012345678","FIELD_BYTE");
                if (s.getString("FIELD_BYTE").equals("ABCDEFG012345678")) {
                    printStatus(new Exception("Setting a byte[] to does not return the same value"));
                }
                else {
                    printStatus(null);
                }//if

            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        public void run()
        {
            testMetaData();
            testParameterList();
            testStructure();
            testTable();
            testSpecialValues();
        }
    }

    /**
     *  Test the repository
     */
    public static class TestRepository extends Test {

        IRepository repository;
        JCO.Client client = null;

        private void testRepository1()
        {
            if (repository != null) return;
            try {
                client = JCO.createClient(getLoginProperties());
                client.connect();
                printMethod("JCO.createRepository(REPOS,client)");
                repository = JCO.createRepository("BFREPOSITORY1",client);
                printStatus(null);
            }
            catch (JCO.Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testRepository2()
        {
            if (repository != null) return;
            try {
                JCO.addClientPool("BF",10,getLoginProperties());
                printMethod("JCO.createRepository(REPOS,POOL)");
                repository = JCO.createRepository("BFREPOSITORY2","BF");
                printStatus(null);
            }
            catch (JCO.Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testStructureDefinition()
        {
            if (repository == null) testRepository2();
            try {
                printMethod("repository.getStructureDefinition(\"RFCSI\")");
                IMetaData meta = repository.getStructureDefinition("RFCSI");
                if (meta == null) printStatus(new Exception("Could not find structure definition for RFCSI"));
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testFunctionInterface()
        {
            if (repository == null) testRepository2();
            try {
                printMethod("repository.getFunctionTemplate(\"RFC_SYSTEM_INFO\")");
                IFunctionTemplate tmpl = repository.getFunctionTemplate("RFC_SYSTEM_INFO");
                if (tmpl == null) printStatus(new Exception("Could not find function RFC_SYSTEM_INFO"));
                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        public void run()
        {
            testRepository1();
            testStructureDefinition();
            testFunctionInterface();
            if (client != null) {
                client.disconnect();
                repository = null;
            }//if
            testRepository2();
            testStructureDefinition();
            testFunctionInterface();
            JCO.removeClientPool("BF");
            repository = null;
        }
    }

    /**
     *  Test function calls
     */
    public static class TestFunctionCalls extends Test {

        IRepository repository;

        private void testRepository()
        {
            try {
                if (repository != null) return;
                JCO.addClientPool("BF",10,getLoginProperties());
                repository = JCO.createRepository("BFREPOSITORY2","BF");
            }
            catch (JCO.Exception ex) {
                printStatus(ex);
            }//try
        }

        private JCO.Function getFunction(String name)
        {
            if (repository == null) testRepository();

            try {
                IFunctionTemplate tpl = repository.getFunctionTemplate(name);
                return (tpl == null ? null : new JCO.Function(tpl));
            }
            catch (JCO.AbapException ex) {
                return null;
            }
            catch (JCO.Exception ex) {
                return null;
            }
            catch (Exception ex) {
                printStatus(ex);
                return null;
            }//try
        }

        private void testSTFC_CONNECTION()
        {
            JCO.Function function = getFunction("STFC_CONNECTION");
            if (function == null) return;

            try {
                String intext = "JCo 2.0 Test Parameter", outtext;
                printMethod("client.execute(\"STFC_CONNECTION\")");
                function.getImportParameterList().setValue(intext,"REQUTEXT");

                JCO.Client client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);

                outtext = function.getExportParameterList().getString("ECHOTEXT");

                if (!intext.equals(outtext)) {
                    throw new Exception("Inconsistency between input and output parameter detected, "+
                            "expected ECHOTEXT='" + intext + "', got ECHOTEXT='" + outtext + "'");
                }//if

                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testSTFC_CHANGING()
        {
            JCO.Function function = getFunction("STFC_CHANGING");
            if (function == null) return;

            try {
                printMethod("client.execute(\"STFC_CHANGING\")");
                int start_value = 998, counter_in = 1;

                function.getImportParameterList().setValue(start_value,"START_VALUE");
                function.getImportParameterList().setValue(counter_in, "COUNTER");

                JCO.Client client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);

                int result      = function.getExportParameterList().getInt("RESULT");
                int counter_out = function.getExportParameterList().getInt("COUNTER");

                if (counter_out != (counter_in + 1)) {
                    throw new Exception("Inconsistency in changing parameter detected, "+
                            "expected COUNTER='" + (counter_in + 1) + "', got COUNTER='" + counter_out + "'");
                }//if

                if (result != (start_value + counter_in)) {
                    throw new Exception("Inconsistency in changing parameter detected, "+
                            "expected RESULT='" + (start_value + counter_in) + "', got RESULT='" + result + "'");
                }//if

                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testDDIF_FIELDINFO_GET()
        {
            JCO.Function function = getFunction("DDIF_FIELDINFO_GET");
            if (function == null) return;

            try {
                printMethod("client.execute(\"DDIF_FIELDINFO_GET\")");
                function.getImportParameterList().setValue("DFIES","TABNAME");
                JCO.Table dfies_tab = function.getTableParameterList().getTable("DFIES_TAB");

                JCO.Client client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);

                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testSTFC_PERFORMANCE()
        {
            JCO.Function function = getFunction("STFC_PERFORMANCE");
            if (function == null) return;

            try {
                JCO.ParameterList imp = function.getImportParameterList();
                JCO.ParameterList tab = function.getTableParameterList();

                imp.setValue("4","LGIT1000");
                imp.setValue("3","LGET1000");

                JCO.Table itab1000 = tab.getTable("ITAB1000");
                for (int irow = 0; irow < 4; irow++) {
                    String row = "ROW" + Integer.toString(irow) + ",";
                    itab1000.appendRow();
                    itab1000.setValue(row+"COLUMN1","LINE1");
                    itab1000.setValue(row+"OLUMN2","LINE2");
                    itab1000.setValue(row+"LUMN3","LINE3");
                    itab1000.setValue(row+"UMN4","LINE4");
                    itab1000.setValue(row+"MN5","LINE5");
                    itab1000.nextRow();
                }//for

                JCO.Table itab1000_save = (JCO.Table)itab1000.clone();

                printMethod("ostream.writeObject(function)");
                FileOutputStream fos = new FileOutputStream("jcoveri.dat");
                ObjectOutputStream os = new ObjectOutputStream(fos);
                os.writeObject(function);
                os.flush();
                fos.close();
                printStatus(null);

                printMethod("istream.readObject(function)");
                FileInputStream fis = new FileInputStream("jcoveri.dat");
                ObjectInputStream is = new ObjectInputStream(fis);
                JCO.Function function2 = (JCO.Function)is.readObject();
                is.close();
                printStatus(null);


                printMethod("client.execute(\"STFC_PERFORMANCE\")");

                JCO.Client client = JCO.getClient("BF");
                client.execute(function);
                client.execute(function2);
                JCO.releaseClient(client);

                itab1000 = tab.getTable("ITAB1000");
                if (itab1000.getNumRows() != itab1000_save.getNumRows() ||
                    itab1000.getNumColumns() != itab1000_save.getNumColumns()) {
                    throw new Exception("Inconsistency in table ITAB1000");
                }//if

                itab1000.firstRow(); itab1000_save.firstRow();
                for (int irow = 0; irow < itab1000.getNumRows(); irow++) {
                    for (int icol = 0; icol < itab1000.getNumColumns(); icol++) {
                        if (!itab1000.getString(icol).equals(itab1000_save.getString(icol))) {
                            throw new Exception("Inconsistency in table ITAB1000");
                        }//if
                    }//for
                    itab1000.nextRow(); itab1000_save.nextRow();
                }//for

                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testSBC_STRING()
        {
            JCO.Function function = getFunction("SBC_STRING");
            if (function == null) return;

            try {
                byte   xstring_out[], xstring_in[] = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06 };
                String string_out,    string_in = "ABCdghtjuierpoie985()/&%";
                printMethod("client.execute(\"SBC_STRING\")");
                function.getImportParameterList().setValue(string_in, "STRING_IN" );
                function.getImportParameterList().setValue(xstring_in,"XSTRING_IN");

                JCO.Client client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);

                xstring_out = function.getExportParameterList().getByteArray("XSTRING_OUT" );
                string_out  = function.getExportParameterList().getString("STRING_OUT");
                string_out  = string_out.substring(7);

                if (xstring_in.length != xstring_out.length)
                    throw new Exception("Inconsistency in length of XSTRING parameters, got " +
                            xstring_out.length + ", expected " + xstring_in.length);
                for (int i = 0; i < xstring_in.length; i++) {
                    if (xstring_in[i] != xstring_out[i])
                        throw new Exception("Inconsistency in data XSTRING parameters at position " + i);
                }//for

                if (!string_out.equals(string_in))
                    throw new Exception("Inconsistency in STRING parameters");

                printStatus(null);
            }
            catch (Exception ex) {
                printStatus(ex);
            }//try
        }

        private void testRFC_RAISE_ERROR()
        {
            JCO.Client client = null;
            JCO.Function function = null;

            try {
                printMethod("client.execute(\"RFC_RAISE_ERROR(0)\")");
                function = getFunction("RFC_RAISE_ERROR");
                function.getImportParameterList().setValue("0","METHOD");
                client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);
            }
            catch (JCO.Exception ex) {
                if (!ex.getKey().equalsIgnoreCase("RFC_ERROR_SYSTEM_FAILURE")) {
                    printStatus(ex);
                }
                else {
                    printStatus(null);
                }//if
            }
            catch (Exception ex) {
                printStatus(ex);
                ex.printStackTrace();
            }//try

            try {
                printMethod("client.execute(\"RFC_RAISE_ERROR(1)\")");
                function = getFunction("RFC_RAISE_ERROR");
                function.getImportParameterList().setValue("1","METHOD");
                client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);
            }
            catch (JCO.AbapException ex) {
                if (!ex.getKey().equalsIgnoreCase("RAISE_EXCEPTION")) {
                    printStatus(ex);
                }
                else {
                    printStatus(null);
                }//if
            }
            catch (Exception ex) {
                printStatus(ex);
                ex.printStackTrace();
            }//try

            try {
                printMethod("client.execute(\"RFC_RAISE_ERROR(2)\")");
                function = getFunction("RFC_RAISE_ERROR");
                function.getImportParameterList().setValue("2","METHOD");
                client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);
            }
            catch (JCO.AbapException ex) {
                if (!ex.getKey().equalsIgnoreCase("RAISE_EXCEPTION")) {
                    printStatus(ex);
                }
                else {
                    printStatus(null);
                }//if
            }
            catch (Exception ex) {
                printStatus(ex);
                ex.printStackTrace();
            }//try

            try {
                printMethod("client.execute(\"RFC_RAISE_ERROR(3)\")");
                function = getFunction("RFC_RAISE_ERROR");
                function.getImportParameterList().setValue("3","METHOD");
                client = JCO.getClient("BF");
                client.execute(function);
                JCO.releaseClient(client);
            }
            catch (JCO.Exception ex) {
                if (!ex.getKey().equalsIgnoreCase("RFC_ERROR_SYSTEM_FAILURE")) {
                    printStatus(ex);
                }
                else {
                    printStatus(null);
                }//if
            }
            catch (Exception ex) {
                printStatus(ex);
                ex.printStackTrace();
            }//try

        }

        public void run()
        {
            testRepository();
            testSTFC_CONNECTION();
            testSTFC_CHANGING();
            testSTFC_PERFORMANCE();
            testDDIF_FIELDINFO_GET();
            testSBC_STRING();
            testRFC_RAISE_ERROR();
            JCO.removeClientPool("BF");
            repository = null;
        }
    }

    public void run()
    {
        printProlog();
        for (int i = 0; i < tests.length; i++) tests[i].run();
        printEpilog();
    }

    public static void usage()
    {
        System.out.println("");
        System.out.println("");
        System.out.println("Usage: 'java VeriClient <file-with-connection-properties> [<trace-level> (0-4)]'");
        System.out.println("");
        System.out.println("where <file-with-connection-properties> is a file which contains something like");
        System.out.println("");
        System.out.println("#Login parameters for system BF1");
        System.out.println("#Tue Oct 17 12:42:06 GMT+02:00 2000");
        System.out.println("jco.client.user=johndoe");
        System.out.println("jco.client.passwd=secret");
        System.out.println("jco.client.client=000");
        System.out.println("jco.client.lang=EN");
        System.out.println("jco.client.mshost=bf1.doe-inc.com");
        System.out.println("jco.client.r3name=BF1");
        System.out.println("jco.client.group=PUBLIC");
        System.exit(1);
    }

    public VeriClient(String filename)
    {
        if (filename != null) properties_filename = filename;
        JCO.getClientPoolManager().addPoolChangedListener(this);
    }

    public VeriClient()
    {
        JCO.getClientPoolManager().addPoolChangedListener(this);
    }

    public static void main(String[] argv)
    {
        if (argv.length == 0) VeriClient.usage();
        if (argv.length > 1) JCO.setTraceLevel(Integer.parseInt(argv[1]));
        VeriClient suite = new VeriClient(argv[0]);
        suite.run();

    }
}

