package org.apertium.transpiler.freya;

import java.io.IOException;
import org.antlr.v4.runtime.*;

/**
 *
 * @author juanfran
 */
public class Freya2XML {
 
    String filePath;

    public Freya2XML() {
    }

    public Freya2XML(String filePath) {
        this.filePath = filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFilePath() {
        return filePath;
    }
       
    public void parse() throws IOException {
        ANTLRFileStream in = new ANTLRFileStream(Freya2XML.class.getResource(filePath).getFile());
        FreyaLexer lexer = new FreyaLexer(in);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        FreyaParser parser = new FreyaParser(tokens);
        parser.stat();
    }

}
