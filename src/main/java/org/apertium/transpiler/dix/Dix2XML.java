package org.apertium.transpiler.dix;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 *
 * @author juanfran
 */
public class Dix2XML {
 
    private static void help(){
        System.out.println("No arguments were given.");
    }
    
    public static void main(String[] args) {
                
        if (args.length == 0) {
            help();
        } else {
            String filePath = args[0];
            System.out.println("File: " + filePath);
            System.out.println("Parsing...");
            try{
                ANTLRFileStream in = new ANTLRFileStream(Dix2XML.class.getResource(filePath).getFile());
                DixLexer lexer = new DixLexer(in);
                CommonTokenStream tokens = new CommonTokenStream(lexer);
                DixParser parser = new DixParser(tokens);
                parser.stat();
            } catch (IOException ex) {
                Logger.getLogger(org.apertium.transpiler.transfer.Trans2XML.class.getName()).log(Level.SEVERE, null, ex);
            }
            System.out.println("Finished.");
        }
    }
    
}
