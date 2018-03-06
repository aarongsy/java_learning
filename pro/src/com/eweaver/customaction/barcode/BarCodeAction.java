package com.eweaver.customaction.barcode;

import com.eweaver.base.AbstractAction;
import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGEncodeParam;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.StringTokenizer;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class BarCodeAction
  implements AbstractAction
{
  public BarCode barcode;
  private HttpServletRequest request;
  private HttpServletResponse response;

  public BarCodeAction(HttpServletRequest request, HttpServletResponse response)
  {
    this.request = request;
    this.response = response;
  }
  public void execute() throws IOException, ServletException {
    this.response.setContentType("image/jpeg");
    ServletOutputStream servletoutputstream = this.response.getOutputStream();
    this.response.setHeader("Pragma", "no-cache");
    this.response.setHeader("Cache-Control", "no-cache");
    this.response.setDateHeader("Expires", 0L);
    try
    {
      BarCode barcode1 = getChart();
      barcode1.setSize(barcode1.width, barcode1.height);
      if (barcode1.autoSize)
      {
        BufferedImage bufferedimage = new BufferedImage(barcode1.getSize().width, barcode1.getSize().height, 13);
        Graphics2D graphics2d = bufferedimage.createGraphics();
        barcode1.paint(graphics2d);
        barcode1.invalidate();
        graphics2d.dispose();
      }
      BufferedImage bufferedimage1 = new BufferedImage(barcode1.getSize().width, barcode1.getSize().height, 1);
      Graphics2D graphics2d1 = bufferedimage1.createGraphics();
      barcode1.paint(graphics2d1);
      JPEGImageEncoder jpegimageencoder = JPEGCodec.createJPEGEncoder(servletoutputstream);
      JPEGEncodeParam jpegencodeparam = jpegimageencoder.getDefaultJPEGEncodeParam(bufferedimage1);
      jpegencodeparam.setQuality(1.0F, true);
      jpegimageencoder.setJPEGEncodeParam(jpegencodeparam);
      jpegimageencoder.encode(bufferedimage1, jpegencodeparam);
    }
    catch (Exception exception)
    {
      exception.printStackTrace();
      this.barcode.code = "Parameter Error";
    }

    servletoutputstream.flush();
    servletoutputstream.close();
  }

  private BarCode getChart() {
    if (this.barcode == null)
      this.barcode = new BarCode();
    try
    {
      setParameter("barType", this.request.getParameter("barType"));
      if ((this.request.getParameter("width") != null) && (this.request.getParameter("height") != null))
      {
        setParameter("width", this.request.getParameter("width"));
        setParameter("height", this.request.getParameter("height"));
        setParameter("autoSize", "n");
      }
      setParameter("code", this.request.getParameter("code"));
      setParameter("st", this.request.getParameter("st"));
      setParameter("textFont", this.request.getParameter("textFont"));
      setParameter("fontColor", this.request.getParameter("fontColor"));
      setParameter("barColor", this.request.getParameter("barColor"));
      setParameter("backColor", this.request.getParameter("backColor"));
      setParameter("rotate", this.request.getParameter("rotate"));
      setParameter("barHeightCM", this.request.getParameter("barHeightCM"));
      setParameter("x", this.request.getParameter("x"));
      setParameter("n", this.request.getParameter("n"));
      setParameter("leftMarginCM", this.request.getParameter("leftMarginCM"));
      setParameter("topMarginCM", this.request.getParameter("topMarginCM"));
      setParameter("checkCharacter", this.request.getParameter("checkCharacter"));
      setParameter("checkCharacterInText", this.request.getParameter("checkCharacterInText"));
      setParameter("Code128Set", this.request.getParameter("Code128Set"));
      setParameter("UPCESytem", this.request.getParameter("UPCESytem"));
    }
    catch (Exception exception)
    {
      exception.printStackTrace();
      this.barcode.code = "Parameter Error";
    }
    return this.barcode;
  }

  public void setParameter(String s, String s1)
  {
    if (s1 != null)
      if (s.equals("code")) {
        this.barcode.code = s1;
      }
      else if (s.equals("width")) {
        this.barcode.width = new Integer(s1).intValue();
      }
      else if (s.equals("height")) {
        this.barcode.height = new Integer(s1).intValue();
      }
      else if (s.equals("autoSize")) {
        this.barcode.autoSize = s1.equalsIgnoreCase("y");
      }
      else if (s.equals("st")) {
        this.barcode.showText = s1.equalsIgnoreCase("y");
      }
      else if (s.equals("textFont")) {
        this.barcode.textFont = convertFont(s1);
      }
      else if (s.equals("fontColor")) {
        this.barcode.fontColor = convertColor(s1);
      }
      else if (s.equals("barColor")) {
        this.barcode.barColor = convertColor(s1);
      }
      else if (s.equals("backColor")) {
        this.barcode.backColor = convertColor(s1);
      }
      else if (s.equals("rotate")) {
        this.barcode.rotate = new Integer(s1).intValue();
      }
      else if (s.equals("barHeightCM")) {
        this.barcode.barHeightCM = new Double(s1).doubleValue();
      }
      else if (s.equals("x")) {
        this.barcode.X = new Double(s1).doubleValue();
      }
      else if (s.equals("n")) {
        this.barcode.N = new Double(s1).doubleValue();
      }
      else if (s.equals("leftMarginCM")) {
        this.barcode.leftMarginCM = new Double(s1).doubleValue();
      }
      else if (s.equals("topMarginCM")) {
        this.barcode.topMarginCM = new Double(s1).doubleValue();
      }
      else if (s.equals("checkCharacter")) {
        this.barcode.checkCharacter = s1.equalsIgnoreCase("y");
      }
      else if (s.equals("checkCharacterInText")) {
        this.barcode.checkCharacterInText = s1.equalsIgnoreCase("y");
      }
      else if (s.equals("Code128Set")) {
        this.barcode.Code128Set = s1.charAt(0);
      }
      else if (s.equals("UPCESytem")) {
        this.barcode.UPCESytem = s1.charAt(0);
      }
      else if (s.equals("barType"))
        if (s1.equalsIgnoreCase("CODE39")) {
          this.barcode.barType = 0;
        }
        else if (s1.equalsIgnoreCase("CODE39EXT")) {
          this.barcode.barType = 1;
        }
        else if (s1.equalsIgnoreCase("INTERLEAVED25")) {
          this.barcode.barType = 2;
        }
        else if (s1.equalsIgnoreCase("CODE11")) {
          this.barcode.barType = 3;
        }
        else if (s1.equalsIgnoreCase("CODABAR")) {
          this.barcode.barType = 4;
        }
        else if (s1.equalsIgnoreCase("MSI")) {
          this.barcode.barType = 5;
        }
        else if (s1.equalsIgnoreCase("UPCA")) {
          this.barcode.barType = 6;
        }
        else if (s1.equalsIgnoreCase("IND25")) {
          this.barcode.barType = 7;
        }
        else if (s1.equalsIgnoreCase("MAT25")) {
          this.barcode.barType = 8;
        }
        else if (s1.equalsIgnoreCase("CODE93")) {
          this.barcode.barType = 9;
        }
        else if (s1.equalsIgnoreCase("EAN13")) {
          this.barcode.barType = 10;
        }
        else if (s1.equalsIgnoreCase("EAN8")) {
          this.barcode.barType = 11;
        }
        else if (s1.equalsIgnoreCase("UPCE")) {
          this.barcode.barType = 12;
        }
        else if (s1.equalsIgnoreCase("CODE128")) {
          this.barcode.barType = 13;
        }
        else if (s1.equalsIgnoreCase("CODE93EXT")) {
          this.barcode.barType = 14;
        }
        else if (s1.equalsIgnoreCase("POSTNET")) {
          this.barcode.barType = 15;
        }
        else if (s1.equalsIgnoreCase("PLANET")) {
          this.barcode.barType = 16;
        }
        else if (s1.equalsIgnoreCase("UCC128"))
          this.barcode.barType = 17;
  }

  private Font convertFont(String s) {
    StringTokenizer stringtokenizer = new StringTokenizer(s, "|");
    String s1 = stringtokenizer.nextToken();
    String s2 = stringtokenizer.nextToken();
    String s3 = stringtokenizer.nextToken();
    byte byte0 = -1;
    if (s2.trim().toUpperCase().equals("PLAIN")) {
      byte0 = 0;
    }
    else if (s2.trim().toUpperCase().equals("BOLD")) {
      byte0 = 1;
    }
    else if (s2.trim().toUpperCase().equals("ITALIC"))
      byte0 = 2;
    return new Font(s1, byte0, new Integer(s3).intValue());
  }

  private Color convertColor(String s)
  {
    Color color = null;
    if (s.trim().toUpperCase().equals("RED")) {
      color = Color.red;
    }
    else if (s.trim().toUpperCase().equals("BLACK")) {
      color = Color.black;
    }
    else if (s.trim().toUpperCase().equals("BLUE")) {
      color = Color.blue;
    }
    else if (s.trim().toUpperCase().equals("CYAN")) {
      color = Color.cyan;
    }
    else if (s.trim().toUpperCase().equals("DARKGRAY")) {
      color = Color.darkGray;
    }
    else if (s.trim().toUpperCase().equals("GRAY")) {
      color = Color.gray;
    }
    else if (s.trim().toUpperCase().equals("GREEN")) {
      color = Color.green;
    }
    else if (s.trim().toUpperCase().equals("LIGHTGRAY")) {
      color = Color.lightGray;
    }
    else if (s.trim().toUpperCase().equals("MAGENTA")) {
      color = Color.magenta;
    }
    else if (s.trim().toUpperCase().equals("ORANGE")) {
      color = Color.orange;
    }
    else if (s.trim().toUpperCase().equals("PINK")) {
      color = Color.pink;
    }
    else if (s.trim().toUpperCase().equals("WHITE")) {
      color = Color.white;
    }
    else if (s.trim().toUpperCase().equals("YELLOW"))
      color = Color.yellow;
    return color;
  }
}