package org.apertium.format.transpiler.transfer;

import java.util.ArrayList;
import java.util.List;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class TransferSaxHandler extends DefaultHandler {

    private StringBuilder sb, pTrans;
//                            transQ0,
//                            transQ1,
//                            transQ2,
//                            transQ3,
//                            transQ4;

    private List<String> l1, l2, l3;

    public TransferSaxHandler() {
        sb = new StringBuilder();
        pTrans = new StringBuilder();
        l1 = new ArrayList<>();
        l2 = new ArrayList<>();
        l3 = new ArrayList<>();
//        transQ0 = new StringBuilder();
//        transQ1 = new StringBuilder();
//        transQ2 = new StringBuilder();
//        transQ3 = new StringBuilder();
//        transQ4 = new StringBuilder();
    }

    @Override
    public void startDocument() {

    }

    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {

        if (localName.equals("transfer")) {
            sb.append("Transfer");
            String def = attributes.getValue("default");
            if (def != null) {
                sb.append("(default=\"").append(def).append("\")");
            }
            sb.append("\n");
        } else if (localName.equals("def-cat")) {
            String n = attributes.getValue("n");
            sb.append("Catlex ").append(n).append(" = ");
        } else if (localName.equals("cat-item")) {
            String lemma = attributes.getValue("lemma");
            String tags = attributes.getValue("tags");
            if (lemma != null && !lemma.equals("")) {
                pTrans.append("\"").append(lemma).append(",").append(tags).append("\", ");
            } else {
                pTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-attr")) {
            String n = attributes.getValue("n");
            sb.append("Attribute ").append(n).append(" = ");
        } else if (localName.equals("attr-item")) {
            String tags = attributes.getValue("tags");
            if (tags != null) {
                pTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-var")) {
            String n = attributes.getValue("n");
            sb.append("Var ").append(n);
            String v = attributes.getValue("v");
            if (v != null) {
                sb.append(" = ");
                pTrans.append("\"").append(v).append("\", ");
            } else {
                pTrans.append(";");
            }
        } else if (localName.equals("def-list")) {
            String n = attributes.getValue("n");
            sb.append("List ").append(n).append(" = ");
        } else if (localName.equals("list-item")) {
            String v = attributes.getValue("v");
            pTrans.append("\"").append(v).append("\"");
        } else if (localName.equals("def-macro")) {
            String n = attributes.getValue("n");
            String nPar = attributes.getValue("npar");
            sb.append("Macro ").append(n).append("(npar=").append(nPar).append(")\n");
        } else if (localName.equals("choose")) {
            sb.append("case\n");
        } else if (localName.equals("clip")) {
            l1.add("clip()");
        } else if (localName.equals("lit-tag")) {
            l1.add("litTag()");
        } else if (localName.equals("when")) {
            sb.append("when ");
        } else if (localName.equals("otherwise")) {
            sb.append("otherwise\n");
        }
//            sb.append("when ");
//            transQ4.append("then\n");
//        } else if(localName.equals("otherwise")){  
//            sb.append("otherwise\n");
//        } else if(localName.equals("equal")){   
//            String caseless = attributes.getValue("caseless");
//            if(caseless!=null){
//                transQ1.append("equalCaseless");
//            } else {
//                transQ1.append("equal");
//            }            
//        } else if(localName.equals("and")){           
//            transQ3.append("and");            
//        } else if(localName.equals("clip")){   
//            
//            StringBuilder auxTrans = new StringBuilder();            
//            String pos = attributes.getValue("pos");
//            String side = attributes.getValue("side");
//            String part = attributes.getValue("part");
//                        
//            auxTrans.append("clip(pos=").append(pos)
//                        .append(", side=").append(side)
//                        .append(", part=").append(part);
//            String queue = attributes.getValue("queue");
//            if(queue!=null){
//                auxTrans.append(", queue=").append(queue);
//            }
//            String linkTo = attributes.getValue("link-to");
//            if(linkTo!=null){
//                auxTrans.append(", link-to=").append(linkTo);
//            }
//            String c = attributes.getValue("c");
//            if(c!=null){
//                auxTrans.append(", c=").append(c);
//            }
//            auxTrans.append(")");
//            
//            if(transQ0.toString().equals("")) { 
//               transQ0 = new StringBuilder(auxTrans);
//            } else {
//               transQ2 = new StringBuilder(auxTrans);
//            }
//        } else if(localName.equals("lit")){
//            StringBuilder auxTrans = new StringBuilder();            
//            String v = attributes.getValue("v");
//            auxTrans.append("\"").append(v).append("\"");
//            
//            if(transQ0.toString().equals("")) { 
//               transQ0 = new StringBuilder(auxTrans);
//            } else {
//               transQ2 = new StringBuilder(auxTrans);
//            }
//            
//        } else if(localName.equals("lit-tag")){            
//            StringBuilder auxTrans = new StringBuilder();            
//            String v = attributes.getValue("v");
//            auxTrans.append("litTag(\"").append(v).append("\")");
//            
//            if(transQ0.toString().equals("")) { 
//               transQ0 = new StringBuilder(auxTrans);
//            } else {
//               transQ2 = new StringBuilder(auxTrans);
//            }            
//        } else if (localName.equals("let")) {
//            transQ1.append("=");
//        } else if(localName.equals("var")){
//            
//            StringBuilder auxTrans = new StringBuilder();            
//            String n = attributes.getValue("n");
//                        
//            auxTrans.append(n);
//            
//            if(transQ0.toString().equals("")) { 
//               transQ0 = new StringBuilder(auxTrans);
//            } else {
//               transQ2 = new StringBuilder(auxTrans);
//            }
//        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
//        sb.append(String.valueOf(ch, start, length));
    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

        if (localName.equals("equal")) {
            if (l1.size() > 2) {
                pTrans.append(l1.get(0)).append(" equal ").append(l1.get(1)).append("\n");
            }
            l2.add(pTrans.toString());
            pTrans.setLength(0);
            l1.clear();
        } else if (localName.equals("and")) {
            l2.forEach((trans) -> {
                pTrans.append(trans).append("and ");
            });
            l3.add(pTrans.toString());
            pTrans.setLength(0);
            l2.clear();
        } else if (localName.equals("test")) {
            l3.forEach((trans) -> {
                pTrans.append(trans).append("and ");
            });
            sb.append(pTrans).append("then\n");
            pTrans.setLength(0);
            l3.clear();
        } else if (localName.equals("when")) {
            sb.append("end\n");
        } else if (localName.equals("otherwise\n")) {
            sb.append("end\n");
        } else if (localName.equals("cat-item")) {
            sb.append(pTrans); // .append(", ");
            pTrans.setLength(0);
        } else if (localName.equals("def-attr")) {
            sb.append(pTrans); // .append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("def-var")) {
            sb.append(pTrans); // .append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("list-item")) {
            sb.append(pTrans); // .append(", ");
            pTrans.setLength(0);
        }

//        if (localName.equals("transfer") || localName.equals("def-macro") || localName.equals("choose") || localName.equals("when") || localName.equals("otherwise")) {
//            sb.append("end\n");
//        } else if (localName.equals("def-cat") || localName.equals("def-attr") || localName.equals("def-var") || localName.equals("def-list")) {
//            String str = transQ0.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            transQ0.setLength(0);
//        } else if(localName.equals("equal")){  
//            sb.append(transQ0).append(" ").append(transQ1).append(" ").append(transQ2).append(" ");
//            if(!transQ3.toString().equals("")) {
//                sb.append(transQ3);
//            }
//            sb.append(transQ4).append("\n");
//            transQ0.setLength(0);
//            transQ1.setLength(0);
//            transQ2.setLength(0);
//            transQ3.setLength(0);
//            transQ4.setLength(0);
//        } else if(localName.equals("let")){
//            sb.append(transQ0).append(" ").append(transQ1).append(" ").append(transQ2).append(";\n");
//            transQ0.setLength(0);
//            transQ1.setLength(0);
//            transQ2.setLength(0);
//        }
    }

    @Override
    public void endDocument() {
        System.out.println(sb.toString());
    }

}
