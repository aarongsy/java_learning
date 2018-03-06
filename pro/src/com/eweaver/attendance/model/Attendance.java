package com.eweaver.attendance.model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import org.hibernate.annotations.GenericGenerator;

@Entity
public class Attendance
  implements Serializable
{
  public static final int ATTENDANCE_IN = 1;
  public static final int ATTENDANCE_OUT = 2;
  private static final long serialVersionUID = -2669656653480230345L;
  private String id;
  private String date1;
  private String hrmid;
  private String ip;
  private String time1;
  private int attendance;
  private String memo;

  @Id
  @GenericGenerator(name="generator", strategy="uuid")
  @GeneratedValue(generator="generator")
  public String getId()
  {
    return this.id;
  }

  public void setId(String paramString)
  {
    this.id = paramString;
  }

  public void setIp(String paramString)
  {
    this.ip = paramString;
  }

  public String getIp()
  {
    return this.ip;
  }

  public void setTime1(String paramString)
  {
    this.time1 = paramString;
  }

  public String getTime1()
  {
    return this.time1;
  }

  public String getDate1()
  {
    return this.date1;
  }

  public void setDate1(String paramString)
  {
    this.date1 = paramString;
  }

  public String getHrmid()
  {
    return this.hrmid;
  }

  public void setHrmid(String paramString)
  {
    this.hrmid = paramString;
  }

  public String getMemo()
  {
    return this.memo;
  }

  public void setMemo(String paramString)
  {
    this.memo = paramString;
  }

  public int getAttendance()
  {
    return this.attendance;
  }

  public void setAttendance(int paramInt)
  {
    this.attendance = paramInt;
  }
}