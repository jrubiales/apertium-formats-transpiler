package org.apertium.transpiler.loki;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class LokiSaxHandler extends DefaultHandler {

    /* Traducciones parciales. */
    private final StringBuilder pTrans;
    
    private String rAttr;
    
    private boolean isAlphabetTag, isITag, isReTag, isParTag, isLeftTag, isRightTag;
            
    public LokiSaxHandler() {
        pTrans = new StringBuilder();
        rAttr = "";
        isAlphabetTag = false;
        isITag = false;
        isReTag = false;
        isParTag = false;
        isLeftTag = false;
        isRightTag = false;
    }

    @Override
    public void startDocument() {
        
    }

    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {
        if (localName.equals("alphabet")) {
            System.out.print("alphabet =");
            isAlphabetTag = true;
        } else if (localName.equals("sdefs")) {
            System.out.print("symbols =");
        } else if (localName.equals("sdef")) {
            String n = attributes.getValue("n");
            pTrans.append(" ").append(n).append(",");
        } else if (localName.equals("pardef")) {
            System.out.print("pardef ");
            String n = attributes.getValue("n");
            System.out.print(n);
            System.out.print("\n");
        } else if (localName.equals("e")) {
            System.out.print("entry");
            
            String r = attributes.getValue("r");
            if(r != null){
                
                if(r.equals("LR")){
                    rAttr = " >";
                } else if(r.equals("RL")){
                    rAttr = " <";
                } else {
                    rAttr = " <>";
                }
                
            } else {
                rAttr = " <>";
            }
            
            // TODO. Resto de atributos.
            
            System.out.println("");
        } else if (localName.equals("i")) {
            System.out.print("identity =");
            isITag = true;
        } else if (localName.equals("re")) {
            System.out.print("re = ");
            isReTag = true;
        } else if (localName.equals("l")) {
            isLeftTag = true;  
        } else if (localName.equals("r")) {
            isRightTag = true;      
        } else if (localName.equals("par")) {
            System.out.print("par-ref = ");
            String n = attributes.getValue("n");
            System.out.print(n);
        } else if (localName.equals("a")) {
            System.out.print(" _a");
        } else if (localName.equals("b")) {
            System.out.print(" \" \"");
        } else if (localName.equals("g")) {
            System.out.print(" (");
        } else if (localName.equals("j")) {
            System.out.print(" _j");
        } else if (localName.equals("s")) {
            String n = attributes.getValue("n");
            System.out.print(" ");
            System.out.print(n);
        } else if (localName.equals("section")) {
            System.out.print("section ");
            String id = attributes.getValue("id");
            System.out.print(id);
            String type = attributes.getValue("type");
            System.out.print("(type=\"");
            System.out.print(type);
            System.out.println("\")");            
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        if(isAlphabetTag || isITag || isReTag || isLeftTag || isRightTag){
            String s = new String(ch, start, length);
            if(!s.matches("[ \\t\\r\\n\\u000C]+")){
                System.out.print(" \"");
                System.out.print(s);
                System.out.print("\"");   
            }
        }
    }
        
    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {
        if (localName.equals("alphabet")) {
            System.out.println(";");
            isAlphabetTag = false;
        } else if (localName.equals("sdefs")) {
            System.out.print(pTrans.toString().replaceAll(",$", ";\n"));
            pTrans.setLength(0);
        } else if (localName.equals("pardef")) {
            System.out.println("end /* end paradigm */");
        } else if (localName.equals("e")) {
            System.out.println("end /* end entry */");
        } else if (localName.equals("i")) {
            System.out.println(";");
            isITag = false;
        } else if (localName.equals("re")) {
            System.out.println(";");
            isReTag = false;
        } else if (localName.equals("p")) {
            System.out.println(";");        
        } else if (localName.equals("l")) {
            System.out.print(rAttr);
            System.out.print(" ");
            isLeftTag = false;  
        } else if (localName.equals("r")) {
            isRightTag = false;      
        } else if (localName.equals("par")) {
            System.out.println(";");
        } else if (localName.equals("g")) {
            System.out.print(") ");
        } else if (localName.equals("section")) {
            System.out.println("end /* end section */");
        }
    }

    @Override
    public void endDocument() {

    }
}
