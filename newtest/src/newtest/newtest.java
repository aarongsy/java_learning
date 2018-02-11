package newtest;
//final version!!!
//show first line in sysout terminal and then delete it and save rest file 
import java.io.File;  
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.BufferedReader;  
import java.io.BufferedWriter;  
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;  

public class newtest {  
	public static void deleterow(int row, String filedic) throws Exception{
		int   lineDel=row;
		String file=filedic;//file directory
		InputStreamReader isr;
		isr = new InputStreamReader(new FileInputStream(file),"utf-8");
		BufferedReader   br=new   BufferedReader(isr);
		StringBuffer   sb=new  StringBuffer(4096);
		String  temp=null;
		int line=0;
		
		while((temp = br.readLine())!=null){
		        
			    line++;
		        
		        if(line==lineDel) {
		        	//temp.replace(" ", "");
		        	System.out.print(temp.replace(" ", ""));
		        	//System.out.print("string"+10);
		        	continue;
		        	}
		        sb.append(temp).append( "\r\n ");
		}
		br.close();
		OutputStreamWriter osr = new OutputStreamWriter(new FileOutputStream(file),"utf-8");
		BufferedWriter  bw=new   BufferedWriter(osr);
		bw.write(sb.toString());
		bw.close();
	}
	
	public static void main(String args[]) throws Exception {
		
		String filedirectory="D://123//1239.txt";
		deleterow(1,filedirectory);
    	
    }  
} 