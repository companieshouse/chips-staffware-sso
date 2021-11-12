import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

/**
* This Watcher class provides a way to check whether an object is available in a remote JNDI tree.
* It takes a single parameter which is the name/path of an object in the JNDI tree
* It then obtains a context using connection details defined externally via jndi.properties
* It then uses the context to obtain a reference to the remote object, using the supplied name/path
* If there is any error whilst obtaing the reference or creating the context then it exits with a return code of 1
* If there is no error and the object reference is obtained, it exits with a return code of 0
*/

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
