package java_learning_class_create;

public class DogTestDrive {
	public static void change(){
		Dog dog2=new Dog();
		dog2.name="123";
		
	}
	public static void main(String args[]){
		Dog dog = new Dog();
		dog.size=40;
		dog.bark();
		Dog dog2=new Dog();
		change();
		System.out.println(dog2.name);
	}
}
