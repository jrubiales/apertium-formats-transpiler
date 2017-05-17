package org.apertium.format.transpiler.transfer;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.antlr.v4.runtime.*;
//import org.apertium.format.transpiler.transfer.TransferLexer;
//import org.apertium.format.transpiler.transfer.TransferParser;

/**
 *
 * @author juanfran
 */
public class MorphTrans2XML {
    
    private static void help(){
        System.out.println("no arguments were given.");
    }
    
    public static void main(String[] args) {
                
        if (args.length == 0) {
            help();
        } else {
            String filePath = args[0];
            System.out.println("File: " + filePath);
            System.out.println("Parsing...");
            try {
                ANTLRFileStream in = new ANTLRFileStream(filePath);
                TransferLexer lexer = new TransferLexer(in);
                CommonTokenStream tokens = new CommonTokenStream(lexer);
                TransferParser parser = new TransferParser(tokens);
                parser.stat();
            } catch (IOException ex) {
                Logger.getLogger(MorphTrans2XML.class.getName()).log(Level.SEVERE, null, ex);
            }
            System.out.println("Finished.");
        }
    }

}
