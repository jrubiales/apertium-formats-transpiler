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
    private String op, notTrans, varId;
    private final List<String> l1, l1Aux;

//    private int c = 0;
    public TransferSaxHandler() {
        sb = new StringBuilder();
        pTrans = new StringBuilder();
        l1 = new ArrayList<>();
        l1Aux = new ArrayList<>();
        notTrans = "";
        varId = "";
        op = "";
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
        } else if (localName.equals("var") || localName.equals("list")) {
            String n = attributes.getValue("n");
            varId = n;
            l1.add(varId);
        } else if (localName.equals("when")) {
            sb.append("when ");
        } else if (localName.equals("otherwise")) {
            sb.append("otherwise\n");
        } else if (localName.equals("not")) {
            notTrans = localName + " ";
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
        } else if (localName.equals("mlu")) {
            sb.append("mlu\n");
        } else if (localName.equals("equal")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "equalCaseless";
            } else {
                op = "equal";
            }
        } else if (localName.equals("begins-with") || localName.equals("begins-with-list")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "beginsWithCaseless";
            } else {
                op = "beginsWith";
            }
        } else if (localName.equals("ends-with") || localName.equals("ends-with-list")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "endsWithCaseless";
            } else {
                op = "endsWith";
            }
        } else if (localName.equals("contains-substring")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "containsSubstringCaseless";
            } else {
                op = "containsSubstring";
            }
        } else if (localName.equals("contains-substring")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "containsSubstringCaseless";
            } else {
                op = "containsSubstring";
            }
        } else if (localName.equals("in")) {
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                op = "inCaseless";
            } else {
                op = "in";
            }
        } else if (localName.equals("b")) {
            String pos = attributes.getValue("pos");
            sb.append("b(");
            if (pos != null && !pos.equals("")) {
                sb.append(pos);
            }
            sb.append(");\n");
        } else if (localName.equals("let")) {
            op = "=";
        } else if (localName.equals("modify-case")) {
            op = "modifyCase";
        } else if (localName.equals("append")) {
            op = "append";
        } else if (localName.equals("reject-current-rule")) {
            String shifting = attributes.getValue("shifting");
            sb.append("rejectCurrentRule(");
            if(shifting != null && !shifting.equals("")){
                sb.append("shifting=\"").append(shifting).append("\"");
            }
            sb.append(")");
        } else if (localName.equals("concat")) {
            l1Aux.clear();
            l1Aux.addAll(l1);
            l1.clear();
        }

    }

    @Override
    public void characters(char[] ch, int start, int length) {
    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

//        --c;
        if (localName.equals("equal")
                || localName.equals("begins-with") || localName.equals("begins-with-list")
                || localName.equals("ends-with") || localName.equals("ends-with-list")
                || localName.equals("contains-substring") || localName.equals("in")) {
            if (l1.size() > 1) {
                pTrans.append(l1.get(0)).append(" ").append(op).append(" ").append(l1.get(1));
            }
            op = "";
            l1.clear();
            // Meto en la lista auxilidar de forma temporal la traducción parcial
            l1Aux.add(pTrans.toString());
            pTrans.setLength(0);
        } else if (localName.equals("and") || localName.equals("or")) {
            l1Aux.forEach((string) -> {
                pTrans.append(string).append(" ").append(localName).append(" ");
            });
            // Quitar el and/or final
            // String str = pTrans.toString().replaceAll(boolOpTrans + " $", " ");
            //pTrans.setLength(0);
            //pTrans.append(str);
            l1Aux.clear();
            l1Aux.add(pTrans.toString());
        } else if (localName.equals("not")) {
//            pTrans.append(notTrans);
//            notTrans = "";
        } else if (localName.equals("test")) {
            sb.append(pTrans).append("then\n");
            pTrans.setLength(0);
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
                pTrans.append(string).append(";\n");
            });
            l1.clear();
            sb.append(pTrans).append("end /* tags */\n");
        } else if (localName.equals("lu")) {
            l1.forEach((string) -> {
                pTrans.append(string).append("\n");
            });
            l1.clear();
            sb.append(pTrans).append("end /* lu */\n");
        } else if (localName.equals("mlu")) {
            sb.append(pTrans).append("end /* mlu */\n");
        } else if (localName.equals("call-macro")) {
            String str = pTrans.toString().replaceAll(", $", ")");
            sb.append(str).append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("pattern")) {
            String str = pTrans.toString().replaceAll(", $", ";");
            sb.append(str).append("\n");
            pTrans.setLength(0);
        } else if (localName.equals("let") || localName.equals("modify-case") || localName.equals("append")) {
            if (l1.size() > 1) {
                pTrans.append(l1.get(0)).append(" ").append(op).append(" ").append(l1.get(1));
            }
            op = "";
            l1.clear();
            sb.append(pTrans).append(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("concat")) {
            l1.forEach((string) -> {
                pTrans.append(string).append(" concat ");
            });
            // Volvemos a dejar la lista como estaba antes de entrar a concat para que el let funcione correctamente.
            l1.clear();
            l1.addAll(l1Aux);
            // Le añadimos la nueva traducción parcial.
            String str = pTrans.toString().replaceAll(" concat $", "");
            l1.add(str);
            pTrans.setLength(0);
        }
    }

    @Override
    public void endDocument() {
        System.out.println(sb.toString());
    }

}
