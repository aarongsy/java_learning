package com.eweaver.app.bbs.dao;

import com.eweaver.base.util.PropertiesHelper;
import com.eweaver.base.util.StringHelper;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class BBSConnection
{
  public static Connection getConnection()
    throws SQLException, ClassNotFoundException
  {
    PropertiesHelper prop = new PropertiesHelper();
    String url = PropertiesHelper.getBbsProps().getProperty("db.url");
    Class.forName(PropertiesHelper.getBbsProps().getProperty("db.driver"));
    String username = PropertiesHelper.getBbsProps().getProperty("db.username");
    String password = PropertiesHelper.getBbsProps().getProperty("db.password");
    Connection conn = DriverManager.getConnection(url, username, password);
    return conn;
  }

  public static int executeUpdate(String sql) throws SQLException, ClassNotFoundException {
    return getConnection().createStatement().executeUpdate(sql);
  }

  public static int execute(String sql, List list) throws SQLException, ClassNotFoundException {
    Connection conn = getConnection();
    conn.setAutoCommit(false);
    PreparedStatement pst = conn.prepareStatement(sql);
    for (int i = 0; (list != null) && (i < list.size()); i++) {
      Map map = (Map)list.get(i);
      Set keys = map.keySet();
      int k = 1;
      for (Iterator it = keys.iterator(); it.hasNext(); ) {
        String key = (String)it.next();
        String s = StringHelper.null2String(map.get(key));
        pst.setObject(k, s);
      }
      pst.addBatch();
    }
    int[] rval = pst.executeBatch();
    conn.commit();
    pst.close();
    conn.close();
    if (rval.length == 0) return 0;
    return 1;
  }

  public static List executeQuery(String sql) throws SQLException, ClassNotFoundException {
    ResultSet rs = getConnection().createStatement().executeQuery(sql);
    ResultSetMetaData md = rs.getMetaData();
    int columnCount = md.getColumnCount();
    List list = new ArrayList();
    while (rs.next()) {
      Map map = new HashMap();
      for (int i = 1; i <= columnCount; i++) {
        map.put(md.getColumnName(i), rs.getObject(i));
      }
      list.add(map);
    }
    return list;
  }

  public static String executeQueryMaxId(String sql, String columnname) throws SQLException, ClassNotFoundException {
    ResultSet rs = getConnection().createStatement().executeQuery(sql);
    String maxId = "";
    if (rs.next()) {
      maxId = StringHelper.null2String(rs.getObject(columnname));
    }
    return maxId;
  }

  public static void main(String[] args) throws ClassNotFoundException, SQLException {
    List list = executeQuery("select t.author,FROM_UNIXTIME(t.dateline),t.subject,t.lastposter,t.lastpost,f.name from pre_forum_thread t,pre_forum_forum f where t.fid=f.fid");
    System.out.println(list.size());
  }
}