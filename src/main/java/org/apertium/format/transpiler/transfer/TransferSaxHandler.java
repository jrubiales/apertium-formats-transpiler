package org.apertium.format.transpiler.transfer;

import java.util.Stack;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class TransferSaxHandler extends DefaultHandler {

    private final StringBuilder trans, pTrans;
    private String op, varId;

    private final Stack<String> stack;

    public TransferSaxHandler() {
        trans = new StringBuilder();
        pTrans = new StringBuilder();
        varId = "";
        op = "";
        stack = new Stack<>();
    }

    @Override
    public void startDocument() {

    }

    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {

        if (localName.equals("transfer")) {
            trans.append("Transfer");
            String def = attributes.getValue("default");
            if (def != null) {
                trans.append("(default=\"").append(def).append("\")");
            }
            trans.append("\n");
        }
        
//        if (localName.equals("transfer")) {
//            sb.append("Transfer");
//            String def = attributes.getValue("default");
//            if (def != null) {
//                sb.append("(default=\"").append(def).append("\")");
//            }
//            sb.append("\n");
//        } else if (localName.equals("def-cat")) {
//            String n = attributes.getValue("n");
//            sb.append("Catlex ").append(n).append(" = ");
//        } else if (localName.equals("cat-item")) {
//            String lemma = attributes.getValue("lemma");
//            if (lemma != null && !lemma.equals("")) {
//                pTrans.append("\"").append(lemma).append("\", ");
//            }
//            String tags = attributes.getValue("tags");
//            pTrans.append("\"").append(tags).append("\", ");
//        } else if (localName.equals("def-attr")) {
//            String n = attributes.getValue("n");
//            sb.append("Attribute ").append(n).append(" = ");
//        } else if (localName.equals("attr-item")) {
//            String tags = attributes.getValue("tags");
//            if (tags != null) {
//                pTrans.append("\"").append(tags).append("\", ");
//            }
//        } else if (localName.equals("def-var")) {
//            String n = attributes.getValue("n");
//            sb.append("Var ").append(n);
//            String v = attributes.getValue("v");
//            if (v != null) {
//                sb.append(" = ");
//                pTrans.append("\"").append(v).append("\", ");
//            } else {
//                pTrans.append(";");
//            }
//        } else if (localName.equals("def-list")) {
//            String n = attributes.getValue("n");
//            sb.append("List ").append(n).append(" = ");
//        } else if (localName.equals("list-item")) {
//            String v = attributes.getValue("v");
//            pTrans.append("\"").append(v).append("\", ");
//        } else if (localName.equals("clip")) {
//            StringBuilder auxTrans = new StringBuilder();
//            String pos = attributes.getValue("pos");
//            String side = attributes.getValue("side");
//            String part = attributes.getValue("part");
//
//            auxTrans.append("clip(pos=").append(pos)
//                    .append(", side=").append(side)
//                    .append(", part=").append(part);
//            String queue = attributes.getValue("queue");
//            if (queue != null) {
//                auxTrans.append(", queue=").append(queue);
//            }
//            String linkTo = attributes.getValue("link-to");
//            if (linkTo != null) {
//                auxTrans.append(", link-to=").append(linkTo);
//            }
//            String c = attributes.getValue("c");
//            if (c != null) {
//                auxTrans.append(", c=").append(c);
//            }
//            auxTrans.append(")");
//            stack.push(auxTrans.toString());
//        } else if (localName.equals("lit")) {
//            StringBuilder auxTrans = new StringBuilder();
//            String v = attributes.getValue("v");
//            auxTrans.append("\"").append(v).append("\"");
//            stack.push(auxTrans.toString());
//        } else if (localName.equals("lit-tag")) {
//            StringBuilder auxTrans = new StringBuilder();
//            String v = attributes.getValue("v");
//            auxTrans.append("litTag(\"").append(v).append("\")");
//            stack.push(auxTrans.toString());
//        } else if (localName.equals("var") || localName.equals("list")) {
//            String n = attributes.getValue("n");
//            varId = n;
//            stack.push(varId);
//        } else if (localName.equals("choose")) {
//            sb.append("case\n");
//        } else if (localName.equals("when")) {
//            sb.append("when ");
//        } else if (localName.equals("otherwise")) {
//            sb.append("otherwise ");
//        } else if (localName.equals("and") || localName.equals("or")) {
//            stack.push(localName);
//        } else if (localName.equals("equal")) {
//            String caseless = attributes.getValue("caseless");
//            if (caseless != null && caseless.equals("yes")) {
//                op = "equalCaseless";
//            } else {
//                op = "equal";
//            }
//        } else if (localName.equals("def-macro")) {
//            String n = attributes.getValue("n");
//            String nPar = attributes.getValue("npar");
//            sb.append("Macro ").append(n).append("(npar=").append(nPar).append(")\n");
//        } else if (localName.equals("rule")) {
//            pTrans.append("Rule(");
//            String c = attributes.getValue("c");
//            if (c != null && !c.equals("")) {
//                pTrans.append("c=\"").append(c).append("\", ");
//            }
//            String comment = attributes.getValue("comment");
//            if (comment != null && !comment.equals("")) {
//                pTrans.append("comment=\"").append(comment).append("\"");
//            }
//            String str = pTrans.toString().replaceAll(", $", "");
//            sb.append(str).append(")\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("pattern")) {
//            sb.append("Pattern = ");
//        } else if (localName.equals("pattern-item")) {
//            String n = attributes.getValue("n");
//            pTrans.append(n).append(", ");
//        } else if (localName.equals("action")) {
//            sb.append("action\n");
//        } else if (localName.equals("call-macro")) {
//            String n = attributes.getValue("n");
//            sb.append(n).append("(");
//        } else if (localName.equals("with-param")) {
//            String pos = attributes.getValue("pos");
//            pTrans.append(pos).append(", ");
//        } else if (localName.equals("out")) {
//            sb.append("out\n");
//        } else if (localName.equals("chunk")) {
//            sb.append("Chunk\n");
//        } else if (localName.equals("tags")) {
//            sb.append("tags\n");
//        } else if (localName.equals("lu")) {
//            sb.append("lu\n");
//        } else if (localName.equals("concat")) {
//            sb.append("concat\n");
//        } else if (localName.equals("mlu")) {
//            sb.append("mlu\n");
//        } else if (localName.equals("begins-with") || localName.equals("begins-with-list")) {
//            String caseless = attributes.getValue("caseless");
//            if (caseless != null && caseless.equals("yes")) {
//                op = "beginsWithCaseless";
//            } else {
//                op = "beginsWith";
//            }
//        } else if (localName.equals("ends-with") || localName.equals("ends-with-list")) {
//            String caseless = attributes.getValue("caseless");
//            if (caseless != null && caseless.equals("yes")) {
//                op = "endsWithCaseless";
//            } else {
//                op = "endsWith";
//            }
//        } else if (localName.equals("contains-substring")) {
//            String caseless = attributes.getValue("caseless");
//            if (caseless != null && caseless.equals("yes")) {
//                op = "containsSubstringCaseless";
//            } else {
//                op = "containsSubstring";
//            }
//        } else if (localName.equals("in")) {
//            String caseless = attributes.getValue("caseless");
//            if (caseless != null && caseless.equals("yes")) {
//                op = "inCaseless";
//            } else {
//                op = "in";
//            }
//        } else if (localName.equals("b")) {
//            String pos = attributes.getValue("pos");
//            sb.append("b(");
//            if (pos != null && !pos.equals("")) {
//                sb.append(pos);
//            }
//            sb.append(");\n");
//        } else if (localName.equals("let")) {
//            op = "=";
//        } else if (localName.equals("modify-case")) {
//            op = "modifyCase";
//        } else if (localName.equals("append")) {
//            op = "append";
//        } else if (localName.equals("reject-current-rule")) {
//            String shifting = attributes.getValue("shifting");
//            sb.append("rejectCurrentRule(");
//            if (shifting != null && !shifting.equals("")) {
//                sb.append("shifting=\"").append(shifting).append("\"");
//            }
//            sb.append(")");
//        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {

    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

        if (localName.equals("transfer")) {
            trans.append("end /* transfer */\n");
        } 
        
//        if (localName.equals("equal")
//                || localName.equals("begins-with") || localName.equals("begins-with-list")
//                || localName.equals("ends-with") || localName.equals("ends-with-list")
//                || localName.equals("contains-substring") || localName.equals("in")) {
//
//            // Desapilar 2 elementos.
//            String v1 = stack.pop();
//            String v2 = stack.pop();
//            StringBuilder trans = new StringBuilder();
//            // Generar traducción añadiendo el operador condicional.
//            trans.append(v2).append(" ").append(op).append(" ").append(v1);
//            // Alamacenar la traducción parcial en la pila.
//            stack.push(trans.toString());
//
//        } else if (localName.equals("and") || localName.equals("or")) {
//
//            StringBuilder trans = new StringBuilder();
//
//            // Desapilar n elementos y generar traducción.
//            boolean found = false;
//            while (!stack.empty() && !found) {
//                String e = stack.pop();
//                if (!e.equals(localName)) {
//                    trans.append(e).append(" ").append(localName).append(" ");
//                } else {
//                    found = true;
//                }
//            }
//
//            String t = trans.toString().replaceAll(" " + localName + " $", "");
//
//            // Alamacenar la traducción parcial en la pila.
//            stack.push(t);
//
//        } else if (localName.equals("test")) {
//            sb.append(stack.pop()).append(" then\n");
//            stack.clear();
//        } else if (localName.equals("when")) {
//            sb.append("end /* when */\n");
//        } else if (localName.equals("otherwise")) {
//            sb.append("end /* otherwise */\n");
//        } else if (localName.equals("not")) {
//            StringBuilder trans = new StringBuilder();
//            String c1 = stack.pop();
//            trans.append("not ").append(c1);
//            stack.push(trans.toString());
//        } else if (localName.equals("def-cat")) {
//            String str = pTrans.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("def-attr")) {
//            String str = pTrans.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("def-var")) {
//            String str = pTrans.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("def-list")) {
//            String str = pTrans.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("transfer")) {
//            sb.append("end /* transfer */\n");
//        } else if (localName.equals("def-macro")) {
//            sb.append("end /* macro */\n");
//        } else if (localName.equals("choose")) {
//            sb.append("end /* choose */\n");
//        } else if (localName.equals("rule")) {
//            sb.append("end /* rule */\n");
//        } else if (localName.equals("action")) {
//            sb.append("end /* action */\n");
//        } else if (localName.equals("out")) {
//            sb.append("end /* out */\n");
//        } else if (localName.equals("chunk")) {
//            sb.append("end /* chunk */\n");
//        } else if (localName.equals("tags")) {
//            while (!stack.empty()) {
//                pTrans.append(stack.pop()).append(";\n");
//            }
//            sb.append(pTrans).append("end /* tags */\n");
//            pTrans.setLength(0);
//
//        } else if (localName.equals("lu")) {
//            while (!stack.empty()) {
//                pTrans.append(stack.pop()).append(";\n");
//            }
//            sb.append(pTrans).append("end /* lu */\n");
//            pTrans.setLength(0);
//
//        } else if (localName.equals("mlu")) {
//            sb.append(pTrans).append("end /* mlu */\n");
//        } else if (localName.equals("call-macro")) {
//            String str = pTrans.toString().replaceAll(", $", ")");
//            sb.append(str).append(";\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("pattern")) {
//            String str = pTrans.toString().replaceAll(", $", ";");
//            sb.append(str).append("\n");
//            pTrans.setLength(0);
//        } else if (localName.equals("let") || localName.equals("modify-case") || localName.equals("append")) {            
//            StringBuilder trans = new StringBuilder();
//            stack.forEach((e)->{
//                trans.append(e).append(" ").append(op).append(" ");
//            });
//            stack.clear();
//            String t = trans.toString().replaceAll(" " + op + " $", "");
//            sb.append(t).append(";\n");
//
//        } else if (localName.equals("concat")) {
//            while (!stack.empty()) {
//                pTrans.append(stack.pop()).append(";\n");
//            }
//            sb.append(pTrans).append("end /* concat */\n");
//            pTrans.setLength(0);
//        }
    }

    @Override
    public void endDocument() {
//        System.out.println(sb.toString());
    }

}
