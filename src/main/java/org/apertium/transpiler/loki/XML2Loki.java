package org.apertium.transpiler.loki;

import java.io.File;
import java.io.IOException;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 *
 * @author juanfran
 */
public class XML2Loki {
    
    String filePath;

    public XML2Loki() {
    }

    public XML2Loki(String filePath) {
        this.filePath = filePath;
    }    
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePath() {
        return filePath;
    }    
    
    public void parse() throws IOException, SAXException{           
        XMLReader reader = XMLReaderFactory.createXMLReader();
        reader.setContentHandler(new LokiSaxHandler());
        File f = new File(filePath);
        reader.parse(new InputSource(f.getAbsolutePath()));            
    }    
}
