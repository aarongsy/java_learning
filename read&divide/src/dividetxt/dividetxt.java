package dividetxt;

import java.io.File;  
import java.io.InputStreamReader;  
import java.io.BufferedReader;  
import java.io.BufferedWriter;  
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;  


public class dividetxt {
	
	public static void dividetxt(int row, String filedic) throws Exception{
		int   lineregion=row;
		String file=filedic;//file directory
		BufferedReader   br=new   BufferedReader(new FileReader( file+".txt"));
		
		StringBuffer   sb=new  StringBuffer(512);
		String  temp=null;
		int line=0;
		int countsx=0;
		int countsy=0;
		String txttail=".txt";
		//BufferedWriter bw=new BufferedWriter(new FileWriter(file+countsy+txttail));
		while((temp = br.readLine())!=null){
		        
			    line++;
		        
		       // if(line==lineregion) {
		       temp.replace(" ", "");
		       // 	System.out.print(temp.replace(" ", ""));
		       // 	continue;
		       // 	}
		        sb.append(temp).append( "\r\n ");
		        //++countsx;
		        if (line>1000){
		        	BufferedWriter bw=new BufferedWriter(new FileWriter(file+countsy+txttail));
		        	sb.append("eof");
		            bw.write(sb.toString());//写入操作
		            bw.close();//关闭
		            countsx=0;
		            line=0;
		            ++countsy;
		            sb=new StringBuffer(512);
		            //temp=null;
		        }     
		}
		BufferedWriter bw= new BufferedWriter(new FileWriter(file+"_last_"+txttail));
		bw.write(sb.toString());
		bw.close();
		br.close();
		//BufferedWriter  bw=new BufferedWriter(new FileWriter( file+txttail));
		//bw.write(sb.toString());
		//bw.close();
		
	}
	  public void matchStringByIndexOf( String parent,String child )
	    {
	        int count = 0;
	        int index = 0;
	        while( ( index = parent.indexOf(child, index) ) != -1 )
	        {
	            index = index+child.length();
	            count++;
	        }
	        System.out.println( "匹配个数为"+count ); //结果输出
	    }
	
	public static void main(String args[]) throws Exception {
		String filedirectory="D://123//new";
		dividetxt(1,filedirectory);
    	
	}
}
