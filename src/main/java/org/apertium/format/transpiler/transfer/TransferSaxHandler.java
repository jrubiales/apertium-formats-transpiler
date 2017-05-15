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

    private final StringBuilder sb, pTrans;
    private String equalsTrans, notTrans, boolOpTrans;
    private final List<String> l1;

//    private int c = 0;
    public TransferSaxHandler() {
        sb = new StringBuilder();
        pTrans = new StringBuilder();
        l1 = new ArrayList<>();
        notTrans = "";
        boolOpTrans = "";
    }

    @Override
    public void startDocument() {

    }

    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {

//        for(int i=0; i<c;++i){
//            sb.append(" ");
//        }        
//        ++c;
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
            if (lemma != null && !lemma.equals("")) {
                pTrans.append("\"").append(lemma).append("\", ");
            }
            String tags = attributes.getValue("tags");
            pTrans.append("\"").append(tags).append("\", ");
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
            pTrans.append("\"").append(v).append("\", ");
        } else if (localName.equals("def-macro")) {
            String n = attributes.getValue("n");
            String nPar = attributes.getValue("npar");
            sb.append("Macro ").append(n).append("(npar=").append(nPar).append(")\n");
        } else if (localName.equals("choose")) {
            sb.append("case\n");
        } else if (localName.equals("clip")) {
            StringBuilder auxTrans = new StringBuilder();
            String pos = attributes.getValue("pos");
            String side = attributes.getValue("side");
            String part = attributes.getValue("part");

            auxTrans.append("clip(pos=").append(pos)
                    .append(", side=").append(side)
                    .append(", part=").append(part);
            String queue = attributes.getValue("queue");
            if (queue != null) {
                auxTrans.append(", queue=").append(queue);
            }
            String linkTo = attributes.getValue("link-to");
            if (linkTo != null) {
                auxTrans.append(", link-to=").append(linkTo);
            }
            String c = attributes.getValue("c");
            if (c != null) {
                auxTrans.append(", c=").append(c);
            }
            auxTrans.append(")");
            l1.add(auxTrans.toString());
        } else if (localName.equals("lit")) {
            StringBuilder auxTrans = new StringBuilder();
            String v = attributes.getValue("v");
            auxTrans.append("\"").append(v).append("\"");
            l1.add(auxTrans.toString());
        } else if (localName.equals("lit-tag")) {
            StringBuilder auxTrans = new StringBuilder();
            String v = attributes.getValue("v");
            auxTrans.append("litTag(\"").append(v).append("\")");
            l1.add(auxTrans.toString());
        } else if (localName.equals("var")) {
            StringBuilder auxTrans = new StringBuilder();
            String n = attributes.getValue("n");
            auxTrans.append(n);
            l1.add(auxTrans.toString());
        } else if (localName.equals("when")) {
            sb.append("when ");
        } else if (localName.equals("otherwise")) {
            sb.append("otherwise\n");
        } else if (localName.equals("not")) {
            notTrans = localName + " ";
        } else if (localName.equals("and") || localName.equals("or")) {
            boolOpTrans = " " + localName;
        } else if (localName.equals("rule")) {
            pTrans.append("Rule(");
            String c = attributes.getValue("c");
            if (c != null && !c.equals("")) {
                pTrans.append("c=\"").append(c).append("\", ");
            }
            String comment = attributes.getValue("comment");
            if (comment != null && !comment.equals("")) {
                pTrans.append("comment=\"").append(comment).append("\"");
            }
            String str = pTrans.toString().replaceAll(", $", "");
            sb.append(str).append(")\n");
            pTrans.setLength(0);
        } else if (localName.equals("pattern")) {
            sb.append("Pattern = ");
        } else if (localName.equals("pattern-item")) {
            String n = attributes.getValue("n");
            pTrans.append(n).append(", ");
        } else if (localName.equals("action")) {
            sb.append("action\n");
        } else if (localName.equals("call-macro")) {
            String n = attributes.getValue("n");
            sb.append(n).append("(");
        } else if (localName.equals("with-param")) {
            String pos = attributes.getValue("pos");
            pTrans.append(pos).append(", ");
        } else if (localName.equals("out")) {
            sb.append("out\n");
        } else if (localName.equals("chunk")) {
            sb.append("Chunk\n");
        } else if (localName.equals("tags")) {
            sb.append("tags\n");
        } else if (localName.equals("lu")) {
            sb.append("lu\n");
        } else if (localName.equals("equal")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null) {
                equalsTrans = "equalCaseless";
            } else {
                equalsTrans = "equal";
            }
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {
    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

//        --c;
        if (localName.equals("equal")) {
            if (l1.size() > 1) {
                pTrans.append(l1.get(0)).append(" ").append(equalsTrans).append(" ").append(l1.get(1)).append(boolOpTrans).append(" ");
            }
            sb.append(pTrans);
            pTrans.setLength(0);
            equalsTrans = "";
            boolOpTrans = "";
            l1.clear();
        } else if (localName.equals("test")) {
            sb.append(pTrans).append("then\n"); // .append(notTrans)
            pTrans.setLength(0);
            notTrans = "";
        } else if (localName.equals("when")) {
            sb.append("end /* when */\n");
        } else if (localName.equals("otherwise")) {
            sb.append("end /* otherwise */\n");
        } else if (localName.equals("def-cat")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        } else if (localName.equals("def-attr")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        } else if (localName.equals("def-var")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        } else if (localName.equals("def-list")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        } else if (localName.equals("let")) {
            if (l1.size() > 1) {
                pTrans.append(l1.get(0)).append(" = ").append(l1.get(1));
            }
            l1.clear();
            sb.append(pTrans).append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("transfer")) {
            sb.append("end /* transfer */\n");
        } else if (localName.equals("def-macro")) {
            sb.append("end /* macro */\n");
        } else if (localName.equals("choose")) {
            sb.append("end /* choose */\n");
        } else if (localName.equals("rule")) {
            sb.append("end /* rule */\n");
        } else if (localName.equals("action")) {
            sb.append("end /* action */\n");
        } else if (localName.equals("out")) {
            sb.append("end /* out */\n");
        } else if (localName.equals("chunk")) {
            sb.append("end /* chunk */\n");
        } else if (localName.equals("tags")) {
            l1.forEach((string) -> {
                pTrans.append(string).append("\n");
            });
            l1.clear();
            sb.append(pTrans).append("end /* tags */\n");
        } else if (localName.equals("lu")) {
            l1.forEach((string) -> {
                pTrans.append(string).append("\n");
            });
            l1.clear();
            sb.append(pTrans).append("end /* lu */\n");
        } else if (localName.equals("call-macro")) {
            String str = pTrans.toString().replaceAll(", $", ")");
            sb.append(str).append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("pattern-item")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        }
    }

    @Override
    public void endDocument() {
        System.out.println(sb.toString());
    }

}
