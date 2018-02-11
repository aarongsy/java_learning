package test;
import java.io.File;
import java.io.FileOutputStream;

public class test {
 public void DOWriteTxt(String file, String txt) {
  try {
   FileOutputStream os = new FileOutputStream(new File(file), true);
   os.write((txt + "\n").getBytes());
  } catch (Exception e) {
   e.printStackTrace();
  }
 }
 public static void main(String[] args) {
	 System.out.print("asd");
	 
  new test().DOWriteTxt("D:\\hello.txt", "helloworld2!"+"\n"+"/n");//\n 没有读取并写入S
 }
}