import java.util.*;

public class TypeMap extends HashMap<Variable, Type> { 

// TypeMap is implemented as a Java HashMap.  
// Plus a 'display' method to facilitate experimentation.
// Display elements 
public void display(){
	Set set = this.entrySet();
	Iterator i = set.iterator();
	while(i.hasNext()) { 
		Map.Entry me = (Map.Entry)i.next();
		System.out.print("Identifier: " + me.getKey() + " type: "); 
		System.out.println(me.getValue().toString() ); 
	}
}
}
