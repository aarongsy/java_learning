package com.aurora.json;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import net.sf.json.JsonConfig;
import net.sf.json.processors.JsonValueProcessor;

public class JsonDateProcessor
  implements JsonValueProcessor
{
  public Object processArrayValue(Object paramObject, JsonConfig paramJsonConfig)
  {
    return null;
  }

  public Object processObjectValue(String paramString, Object paramObject, JsonConfig paramJsonConfig)
  {
    String str = null;
    SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
    if ((paramObject instanceof java.sql.Date))
      paramObject = new java.util.Date(((java.sql.Date)paramObject).getTime());
    if ((paramObject instanceof Timestamp))
      paramObject = new java.util.Date(((Timestamp)paramObject).getTime());
    if ((paramObject instanceof java.util.Date))
      str = localSimpleDateFormat.format(paramObject);
    return str;
  }
}