package weaver.interfaces.util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import sun.misc.BASE64Decoder;


public class CanvasToPDF {
	
	public void toPdf(String data,String filePath){ 
		GetPDF(data.substring("data:image/png;base64,".length()), filePath);
	}
	
	public static boolean GetPDF(String data,String filePath){
		BASE64Decoder base64 = new BASE64Decoder();
		try {
			byte[] bytes = base64.decodeBuffer(data);
			for(int i=0;i<bytes.length;i++){
				if(bytes[i]<0){
					bytes[i]+=256;
				}
			}
			OutputStream outputStream = new FileOutputStream(filePath);
			outputStream.write(bytes);
			outputStream.flush();
			outputStream.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}

}
