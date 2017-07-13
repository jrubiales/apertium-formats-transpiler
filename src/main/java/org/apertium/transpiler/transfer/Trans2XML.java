package org.apertium.transpiler.transfer;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.antlr.v4.runtime.*;

/**
 *
 * @author juanfran
 */
public class Trans2XML {
    
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
            try {
                ANTLRFileStream in = new ANTLRFileStream(Trans2XML.class.getResource(filePath).getFile());
                TransferLexer lexer = new TransferLexer(in);
                CommonTokenStream tokens = new CommonTokenStream(lexer);
                TransferParser parser = new TransferParser(tokens);
                parser.stat();
            } catch (IOException ex) {
                Logger.getLogger(Trans2XML.class.getName()).log(Level.SEVERE, null, ex);
            }
            System.out.println("Finished.");
        }
    }

}