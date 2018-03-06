package simpleversion;

public class testdriver {
	public static void main(String args[]){
		SimpleDotCom dot = new SimpleDotCom();
		int[] locations = {2,3,4};
		dot.setLocationCells(locations);
		String userGuess="1";
		String result =dot.checkYourself(userGuess);
		
		
	}
}
