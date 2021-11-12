import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

class Watcher {
    public static void main(String[] args) {
        System.out.println("Watcher: obtaining reference to object " + args[0]); 
        
        try {
           Context context = new InitialContext(); 
           context.lookup(args[0]);
        } 
        catch (NamingException e) {
            System.out.println("Watcher: error obtaining reference to object " + args[0]);
            System.exit(1); 
        }
        System.exit(0);
    }
}
