package org.apertium.format.transpiler.dix;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 *
 * @author juanfran
 */
public class XML2MorphTrans {
    
    private static void help(){
        System.out.println("no arguments were given.");
    }
        
    public static void main(String[] args) {
        if (args.length == 0) {
            help();
        } else {
            String filePath = args[0];
            try {
                XMLReader reader = XMLReaderFactory.createXMLReader();
                reader.setContentHandler(new DixSaxHandler());
                reader.parse(new InputSource(new FileInputStream(filePath)));
            } catch (SAXException | IOException ex) {
                Logger.getLogger(org.apertium.format.transpiler.dix.XML2MorphTrans.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
}
