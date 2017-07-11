
import java.util.Stack;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author juanfran
 */
public class NewMain {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Stack<String> s = new Stack<>();
        s.add("uno");
        s.add("dos");
        s.add("tres");
        
        for(int i = 0; i < s.size();){
            String e = s.remove(i);
            System.out.println(e);
        }
        
        System.out.print(s);
        
        
    }
    
}
