package com.eweaver.app.bbs.discuz.interfaces;

import com.eweaver.app.bbs.discuz.client.Client;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UC extends HttpServlet
{
  private static final long serialVersionUID = -7377364931916922413L;
  public static boolean IN_DISCUZ = true;
  public static String UC_CLIENT_VERSION = "1.5.0";
  public static String UC_CLIENT_RELEASE = "20081031";

  public static boolean API_DELETEUSER = true;
  public static boolean API_RENAMEUSER = true;
  public static boolean API_GETTAG = true;
  public static boolean API_SYNLOGIN = true;
  public static boolean API_SYNLOGOUT = true;
  public static boolean API_UPDATEPW = true;
  public static boolean API_UPDATEBADWORDS = true;
  public static boolean API_UPDATEHOSTS = true;
  public static boolean API_UPDATEAPPS = true;
  public static boolean API_UPDATECLIENT = true;
  public static boolean API_UPDATECREDIT = true;
  public static boolean API_GETCREDITSETTINGS = true;
  public static boolean API_GETCREDIT = true;
  public static boolean API_UPDATECREDITSETTINGS = true;

  public static String API_RETURN_SUCCEED = "1";
  public static String API_RETURN_FAILED = "-1";
  public static String API_RETURN_FORBIDDEN = "-2";

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    String result = doAnswer(request, response);
    response.getWriter().print(result);
  }

  private String doAnswer(HttpServletRequest request, HttpServletResponse response)
  {
    String $code = request.getParameter("code");
    if ($code == null) return API_RETURN_FAILED;

    Map $get = new HashMap();
    $code = new Client().uc_authcode($code, "DECODE");
    parse_str($code, $get);

    if ($get.isEmpty()) {
      return "Invalid Request";
    }
    if (time() - tolong($get.get("time")) > 3600L) {
      return "Authracation has expiried";
    }

    String $action = (String)$get.get("action");
    if ($action == null) return API_RETURN_FAILED;

    if ($action.equals("test"))
    {
      return API_RETURN_SUCCEED;
    }
    if ($action.equals("deleteuser"))
    {
      return API_RETURN_SUCCEED;
    }
    if ($action.equals("renameuser"))
    {
      return API_RETURN_SUCCEED;
    }
    if ($action.equals("gettag"))
    {
      if (!API_GETTAG) return API_RETURN_FORBIDDEN;

      return API_RETURN_SUCCEED;
    }

    if ($action.equals("synlogin"))
    {
      if (!API_SYNLOGIN) return API_RETURN_FORBIDDEN;

      response.addHeader("P3P", "CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");

      int $cookietime = 31536000;
      Client uc = new Client();
      Cookie user = new Cookie("loginuser", (String)$get.get("username"));
      user.setMaxAge($cookietime);
      response.addCookie(user);
      Cookie auth = new Cookie("auth", uc.uc_authcode((String)$get.get("password") + "\t" + (String)$get.get("uid"), "ENCODE"));
      auth.setMaxAge($cookietime);

      response.addCookie(auth);
    }
    else if ($action.equals("synlogout"))
    {
      if (!API_SYNLOGOUT) return API_RETURN_FORBIDDEN;

      response.addHeader("P3P", " CP=\"CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR\"");

      Cookie user = new Cookie("loginuser", "");
      user.setMaxAge(0);
      response.addCookie(user);

      Cookie auth = new Cookie("auth", "");
      auth.setMaxAge(0);

      response.addCookie(auth);
    }
    else {
      if ($action.equals("updateclient"))
      {
        if (!API_UPDATECLIENT) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }
      if ($action.equals("updatepw"))
      {
        if (!API_UPDATEPW) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }
      if ($action.equals("updatebadwords"))
      {
        if (!API_UPDATEBADWORDS) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }
      if ($action.equals("updatehosts"))
      {
        if (!API_UPDATEHOSTS) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }
      if ($action.equals("updateapps"))
      {
        if (!API_UPDATEAPPS) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }
      if ($action.equals("updatecredit"))
      {
        return API_RETURN_SUCCEED;
      }
      if ($action.equals("getcreditsettings"))
      {
        return "";
      }
      if ($action.equals("updatecreditsettings"))
      {
        if (!API_UPDATECREDITSETTINGS) return API_RETURN_FORBIDDEN;

        return API_RETURN_SUCCEED;
      }

      return API_RETURN_FORBIDDEN;
    }

    return "";
  }

  private void parse_str(String str, Map<String, String> sets) {
    if ((str == null) || (str.length() < 1))
      return;
    String[] ps = str.split("&");
    for (int i = 0; i < ps.length; i++) {
      String[] items = ps[i].split("=");
      if (items.length == 2)
        sets.put(items[0], items[1]);
      else if (items.length == 1)
        sets.put(items[0], "");
    }
  }

  protected long time()
  {
    return System.currentTimeMillis() / 1000L;
  }

  private static long tolong(Object s) {
    if (s != null) {
      String ss = s.toString().trim();
      if (ss.length() == 0) {
        return 0L;
      }
      return Long.parseLong(ss);
    }

    return 0L;
  }
}