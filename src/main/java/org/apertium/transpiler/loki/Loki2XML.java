package org.apertium.transpiler.loki;

import java.io.IOException;
import org.antlr.v4.runtime.ANTLRFileStream;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 *
 * @author juanfran
 */
public class Loki2XML {
 
    String filePath;

    public Loki2XML() {
    }

    public Loki2XML(String filePath) {
        this.filePath = filePath;
    }
    
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePath() {
        return filePath;
    }
    
    public void parse() throws IOException{
        ANTLRFileStream in = new ANTLRFileStream(Loki2XML.class.getResource(filePath).getFile());
        LokiLexer lexer = new LokiLexer(in);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        LokiParser parser = new LokiParser(tokens);
        parser.stat();
    }
    
}
