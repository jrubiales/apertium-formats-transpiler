package org.apertium.transpiler;

import java.io.IOException;
import org.apertium.transpiler.freya.Freya2XML;
import org.apertium.transpiler.freya.Symbol;
import org.apertium.transpiler.freya.Type;
import org.apertium.transpiler.freya.XML2Freya;
import org.apertium.transpiler.loki.Loki2XML;
import org.apertium.transpiler.loki.XML2Loki;
import org.xml.sax.SAXException;

/**
 *
 * @author juanfran
 */
public class ApertiumFormatsTranspilers {

    private static void help(){ 
        System.out.println("##########################################################################################");
        System.out.println("Apertium Formats Transpilers (https://github.com/jrubiales/apertium-formats-transpilers)");
        System.out.println("usage: java -jar ApertiumFormatsTranspilers [Transpiler type] [File]");
        System.out.println("Transpiler type:");
        System.out.println("\tloki: Transpile from XML to Loki format (filename.lk) or vice versa.");
        System.out.println("\tfreya: Transpile from XML to Freya format (filename.fy) or vice versa.");
        System.out.println("File:");
        System.out.println("\tIf this argument is a XML file, the transpiler will convert from XML to Loki/Freya format. \n\tOtherwise it will covert from Loki/Freya format to XML.");
        System.out.println("###########################################################################################");
    }
    
    private void err(String msg){
        System.out.println(msg);
        help();
        System.exit(0);
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        ApertiumFormatsTranspilers app = new ApertiumFormatsTranspilers();
        
        if (args.length == 0) {
            
            app.err("Error. No arguments were given.");            
        
        } else if(args.length < 2){ 
            
            app.err("Error. Not enough arguments were given.");
            
        } else {
            
            String transpilerType = args[0];
            String filePath = args[1];
                        
            System.out.println("Transpiler selected: " + transpilerType);
            System.out.println("File: " + filePath);
            
            try{
            
                if(filePath.endsWith(".xml")){

                    if(transpilerType.equals("loki")){

                        System.out.println("Trying to parse from XML to Loki format...");
                        XML2Loki xml2Loki = new XML2Loki(filePath);
                        xml2Loki.parse();


                    } else if(transpilerType.equals("freya")){ 

                        System.out.println("Trying to parse from XML to Freya format...");
                        XML2Freya xml2Freya = new XML2Freya(filePath);
                        xml2Freya.parse();

                    } else {
                        app.err("Error. Transpiler " + transpilerType + " not recognized.");
                    }

                } else if(filePath.endsWith(".lk")){

                    if(transpilerType.equals("loki")){

                        System.out.println("Trying to parse from Loki format to XML...");
                        Loki2XML loki2Xml = new Loki2XML(filePath);
                        loki2Xml.parse();

                    } else {
                        app.err("Error. Transpiler " + transpilerType + " not recognized.");
                    }

                } else if(filePath.endsWith(".fy")){

                    if(transpilerType.equals("freya")){ 

                        System.out.println("Trying to parse from Freya format to XML...");
                        Freya2XML freya2Xml = new Freya2XML(filePath);
                        freya2Xml.parse();

                    } else {
                        app.err("Error. Transpiler " + transpilerType + " not recognized.");
                    }

                } else {
                    app.err("Error. File extension not recognized.");
                }
                
            } catch (IOException | SAXException ex) {
                ex.printStackTrace();
                // Logger.getLogger(FormatsTranspiler.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
    }
    
}
