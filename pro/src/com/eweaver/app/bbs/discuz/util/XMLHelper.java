package com.eweaver.app.bbs.discuz.util;

import com.eweaver.base.util.StringHelper;
import com.sun.org.apache.xerces.internal.parsers.DOMParser;
import java.io.IOException;
import java.io.StringReader;
import java.util.LinkedList;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class XMLHelper
{
  public static LinkedList<String> uc_unserialize(String input)
  {
    LinkedList result = new LinkedList();
    if (StringHelper.isEmpty(input)) {
      return result;
    }
    DOMParser parser = new DOMParser();
    try {
      parser.parse(new InputSource(new StringReader(input)));
      Document doc = parser.getDocument();
      NodeList nl = doc.getChildNodes().item(0).getChildNodes();
      int length = nl.getLength();
      for (int i = 0; i < length; i++)
        if (nl.item(i).getNodeType() == 1)
          result.add(nl.item(i).getTextContent());
    } catch (SAXException e) {
    }
    catch (IOException e) {
    }
    return result;
  }
}