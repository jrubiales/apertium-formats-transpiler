
package org.apertium.transpiler.freya;

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
public class XML2Freya {
        
    String filePath;

    public XML2Freya() {
    }

    public XML2Freya(String filePath) {
        this.filePath = filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePath() {
        return filePath;
    }
    
    public void parse() throws IOException, SAXException {
        XMLReader reader = XMLReaderFactory.createXMLReader();
        reader.setContentHandler(new FreyaSaxHandler());
        File f = new File(filePath);
        reader.parse(new InputSource(f.getAbsolutePath()));
    }    
}
