package majiang;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class Player {
	 private int id;
	    private String name;
	    private List<Card> handCards = new ArrayList<Card>();

	    public Player(int id, String name){
	        this.id = id;
	        this.name = name;
	    }

	    public List<Card> getHandCards() {
	        return handCards;
	    }

	    public void setHandCards(Card card) {
	        handCards.add(card);
	    }
	    public int getId() {
	        return id;
	    }

	    public void setId(int id) {
	        this.id = id;
	    }

	    public String getName() {
	        return name;
	    }

	    public void setName(String name) {
	        this.name = name;
	    }
	    public void cardCollator(){
	    	Collections.sort(handCards, new SortByNumber());
			Collections.sort(handCards, new SortByColor());
	    }
	    class SortByColor implements Comparator{
			public int compare(Object o1, Object o2) {
				Card c1 = (Card) o1;
				Card c2 = (Card) o2;
				
				return  c1.getColor().compareTo(c2.getColor());
			}
		}
		
		class SortByNumber implements Comparator{
			public int compare (Object o1, Object o2) {
				Card n1 = (Card) o1;
				Card n2 = (Card) o2;
				return n1.getNumber().compareTo(n2.getNumber());
			}
		}

	}