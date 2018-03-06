package com.eweaver.app.exceltest;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class ReadExcel
{
  public List[] readXls(InputStream input)
    throws IOException, BiffException
  {
    Workbook workbook = null;
    List[] dataArr = null;

    workbook = Workbook.getWorkbook(input);
    Sheet[] sheets = workbook.getSheets();
    int i = 0; int m = sheets.length; if (i < m)
    {
      int cols = sheets[i].getColumns();
      if (cols > 0)
      {
        int rows = sheets[i].getColumn(0).length;
        dataArr = new List[cols];
        for (int j = 0; j < cols; j++) {
          dataArr[j] = new ArrayList();
          Cell[] cell_domain = sheets[i].getColumn(j);
          int cellrows = cell_domain.length;
          for (int k = 0; k < rows; k++)
          {
            if (k >= cellrows) {
              dataArr[j].add("");
            }
            else if (cell_domain[k] == null) {
              dataArr[j].add("");
            }
            else if (cell_domain[k].getContents() == null)
            {
              dataArr[j].add("");
            }
            else {
              dataArr[j].add(cell_domain[k].getContents().trim());
            }
          }
        }

      }

    }

    workbook.close();
    for (int ii = 0; ii < dataArr.length; ii++)
    {
      String header = dataArr[ii].get(0).toString().trim();
      if ((header.equals("")) || (header != null));
    }
    return dataArr;
  }
}