
package org.apertium.format.transpiler.transfer;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class TransferSaxHandler extends DefaultHandler {
    
    private StringBuilder partialTrans;
    private StringBuilder sb;
        
    public TransferSaxHandler() {
        sb = new StringBuilder();
        partialTrans = new StringBuilder();
    }
    
    @Override
    public void startDocument (){

    }
    
    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {
        
        if (localName.equals("transfer")) {
            sb.append("Transfer");
            String def = attributes.getValue("default");
            if(def!=null){
                sb.append("(default=\"").append(def).append("\")");
            }
            sb.append("\n");
        } else if (localName.equals("def-cat")) {
            String n = attributes.getValue("n");
            sb.append("Catlex ").append(n).append(" = "); 
        } else if (localName.equals("cat-item")) {
            String lemma = attributes.getValue("lemma");
            String tags = attributes.getValue("tags");
            if(lemma!=null && !lemma.equals("")){
                partialTrans.append("\"").append(lemma).append(",").append(tags).append("\", ");
            } else {
                partialTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-attr")) {
            String n = attributes.getValue("n");
            sb.append("Attribute ").append(n).append(" = "); 
        } else if (localName.equals("attr-item")) {
            String tags = attributes.getValue("tags");
            if(tags!=null){
                partialTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-var")) {
            String n = attributes.getValue("n");
            sb.append("Var ").append(n); 
            String v = attributes.getValue("v");
            if(v!=null){
                sb.append(" = ");
                partialTrans.append("\"").append(v).append("\", ");
            } else {
                partialTrans.append(";");
            }
        } else if (localName.equals("def-list")) {
            String n = attributes.getValue("n");
            sb.append("List ").append(n).append(" = "); 
        } else if (localName.equals("list-item")) {
            String v = attributes.getValue("v");
            partialTrans.append("\"").append(v).append("\", ");
        }
    }
    
    @Override
    public void characters(char[] ch, int start, int length){
//        sb.append(String.valueOf(ch, start, length));
    }
    
    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {
        if (localName.equals("transfer")) {
            sb.append("end\n");
        } else if (localName.equals("def-cat") || localName.equals("def-attr") || localName.equals("def-var") || localName.equals("def-list")) {
            String str = partialTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            partialTrans.setLength(0);
        }

    }
    
    @Override
    public void endDocument (){
        System.out.println(sb.toString());
    }
    
}
