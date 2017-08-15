package org.apertium.transpiler;

import java.io.IOException;
import org.apertium.transpiler.freya.Freya2XML;
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
        System.out.println("\n##########################################################################################\n");
        System.out.println("Apertium Formats Transpilers (https://github.com/jrubiales/apertium-formats-transpilers)\n");
        System.out.println("usage: java -jar ApertiumFormatsTranspilers [Transpiler type] [File]");
        System.out.println("Transpiler type:");
        System.out.println("\tloki (Dictionaries): Transpile from XML (.dix) to Loki format (filename.lk) or vice versa.");
        System.out.println("\tfreya (Transfer): Transpile from XML (.t1x/.t2x/.t3x) to Freya format (filename.fy) or vice versa.");
        System.out.println("File:");
        System.out.println("\tIf this argument is a XML file, the transpiler will convert from XML (.dix or .t1x/.t2x/.t3x) to Loki/Freya format (.lk/.fy). \n\tOtherwise it will covert from Loki/Freya format to XML.");
        System.out.println("\n-------------------------------------------------------------------------------------------\n");
        System.out.println("Usage example: ");
        System.out.println("\tjava -jar ApertiumFormatsTranspilers loki apertium-eng.eng.dix => it will convert from XML (.dix) format to Loki (.lk) format");
        System.out.println("\tjava -jar ApertiumFormatsTranspilers loki apertium-eng.eng.lk => it will convert from Loki (.lk) format to XML (.dix) format");
        System.out.println("\tjava -jar ApertiumFormatsTranspilers freya apertium-eng-spa.eng-spa.t1x => it will convert from XML (.t1x) format to Freya (.fy) format");
        System.out.println("\tjava -jar ApertiumFormatsTranspilers freya apertium-eng-spa.eng-spa.fy => it will convert from Freya (.fy) format to XML (.t1x) format");
        System.out.println("\n###########################################################################################\n");
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
                        
            // System.out.println("Transpiler selected: " + transpilerType);
            // System.out.println("File: " + filePath);
            
            try{
                                          
                if(filePath.endsWith(".dix") && transpilerType.equals("loki")){
                    
                        // Trying to parse from XML to Loki format...
                        XML2Loki xml2Loki = new XML2Loki(filePath);
                        xml2Loki.parse();                    
                    
                } else if((filePath.endsWith(".t1x") || filePath.endsWith(".t2x") || filePath.endsWith(".t3x")) && transpilerType.equals("freya")){
                    
                        // Trying to parse from XML to Freya format...
                        XML2Freya xml2Freya = new XML2Freya(filePath);
                        xml2Freya.parse();
                    
                } else if(filePath.endsWith(".lk") && transpilerType.equals("loki")){
                        
                        // Trying to parse from Loki format to XML...
                        Loki2XML loki2Xml = new Loki2XML(filePath);
                        loki2Xml.parse();

                } else if(filePath.endsWith(".fy") && transpilerType.equals("freya")){

                        // Trying to parse from Freya format to XML...
                        Freya2XML freya2Xml = new Freya2XML(filePath);
                        freya2Xml.parse();

                } else {
                    app.err("Error. File extension or transpiler not recognized.");
                }
                
            } catch (IOException | SAXException ex) {
                ex.printStackTrace();
                // Logger.getLogger(FormatsTranspiler.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
    }
    
}
