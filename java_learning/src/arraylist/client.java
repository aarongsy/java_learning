package arraylist;

import java.util.ArrayList;

public class client {
	public static void main (String[] args){
		ArrayList<Egg> mylist =new ArrayList<Egg>();
		Egg s= new Egg();
		mylist.add(s);
		Egg b = new Egg();
		mylist.add(b);
		int thesize= mylist.size();
		boolean isIn=mylist.contains(s);
		int index=mylist.indexOf(b);
		boolean empty= mylist.isEmpty();
		
		
		
		
	}
}
