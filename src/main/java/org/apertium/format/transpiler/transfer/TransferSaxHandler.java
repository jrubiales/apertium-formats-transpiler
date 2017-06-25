package org.apertium.format.transpiler.transfer;

import com.google.common.base.CaseFormat;
import java.util.Stack;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class TransferSaxHandler extends DefaultHandler {

    /* Traducción final. */
    private final StringBuilder trans;

    /* Traducciones parciales. */
    private StringBuilder pTrans;

    private String condition, sentence, refId;

    private final Stack<String> stack;

    public TransferSaxHandler() {
        trans = new StringBuilder();
        pTrans = new StringBuilder();
        refId = "";
        condition = "";
        sentence = "";
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
        } else if (localName.equals("def-cat")) {
            String n = attributes.getValue("n");
            trans.append("Catlex ").append(n).append(" = ");
        } else if (localName.equals("cat-item")) {
            String lemma = attributes.getValue("lemma");
            pTrans.append("\"");
            if (lemma != null) {
                pTrans.append(lemma).append(", ");
            }
            String tags = attributes.getValue("tags");
            pTrans.append(tags).append("\", ");
        } else if (localName.equals("def-attr")) {
            String n = attributes.getValue("n");
            trans.append("Attribute ").append(n).append(" = ");
        } else if (localName.equals("attr-item")) {
            String tags = attributes.getValue("tags");
            if (tags != null) {
                pTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-var")) {
            String n = attributes.getValue("n");
            trans.append("Var ").append(n);
            String v = attributes.getValue("v");
            if (v != null) {
                trans.append(" = ");
                trans.append("\"").append(v).append("\"");
            }
        } else if (localName.equals("def-list")) {
            String n = attributes.getValue("n");
            trans.append("List ").append(n).append(" = ");
        } else if (localName.equals("list-item")) {
            String v = attributes.getValue("v");
            pTrans.append("\"").append(v).append("\", ");
        } else if (localName.equals("def-macro")) {
            String n = attributes.getValue("n");
            String nPar = attributes.getValue("npar");
            trans.append("Macro ").append(n).append("(npar=").append(nPar).append(")\n");
        } else if (localName.equals("rule")) {
            trans.append("Rule(");
            String c = attributes.getValue("c");
            if (c != null) {
                trans.append("c=\"").append(c).append("\", ");
            }
            String comment = attributes.getValue("comment");
            if (comment != null) {
                trans.append("comment=\"").append(comment).append("\"");
            }
            trans.append(")\n");
        } else if (localName.equals("pattern")) {
            trans.append("Pattern = ");
        } else if (localName.equals("pattern-item")) {
            String n = attributes.getValue("n");
            pTrans.append(n).append(", ");
        } /* sentence (dtd) */ else if (localName.equals("choose")) {
            trans.append("case\n");
        } else if (localName.equals("when")) {
            trans.append("when ");
        } else if (localName.equals("otherwise")) {
            trans.append("otherwise ");
        } else if (localName.equals("and") || localName.equals("or")) {
            stack.push(localName);
        } else if (localName.equals("equal")
                || localName.equals("begins-with") || localName.equals("begins-with-list")
                || localName.equals("ends-with") || localName.equals("ends-with-list")
                || localName.equals("contains-substring") || localName.equals("in")) {
            String caseless = attributes.getValue("caseless");
            condition = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, localName.replaceAll("-", "_"));
            if (caseless != null && caseless.equals("yes")) {
                condition += "Caseless";
            }
        } else if (localName.equals("let")) {
            sentence = "=";
        } else if (localName.equals("append")) {
            sentence = "append";
        } else if (localName.equals("out")) {
            trans.append("out\n");
        } else if (localName.equals("modify-case")) {
            sentence = "modifyCase";
        } else if (localName.equals("call-macro")) {
            String n = attributes.getValue("n");
            trans.append(n).append("(");
        } else if (localName.equals("with-param")) {
            String pos = attributes.getValue("pos");
            pTrans.append(pos).append(", ");
        } else if (localName.equals("clip")) {

            String pos = attributes.getValue("pos");
            String side = attributes.getValue("side");
            String part = attributes.getValue("part");

            pTrans.append("clip(pos=").append(pos)
                    .append(", side=").append(side)
                    .append(", part=").append(part);
            String queue = attributes.getValue("queue");
            if (queue != null) {
                pTrans.append(", queue=").append(queue);
            }
            String linkTo = attributes.getValue("link-to");
            if (linkTo != null) {
                pTrans.append(", link-to=").append(linkTo);
            }
            String c = attributes.getValue("c");
            if (c != null) {
                pTrans.append(", c=").append(c);
            }
            pTrans.append(")");
            stack.push(pTrans.toString());
            // pTrans.setLength(0);
            pTrans = new StringBuilder();

        } else if (localName.equals("lit")) {
            
            String v = attributes.getValue("v");
            pTrans.append("\"").append(v).append("\"");
            stack.push(pTrans.toString());
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
            
        } else if (localName.equals("lit-tag")) {
            
            String v = attributes.getValue("v");
            pTrans.append("litTag(\"").append(v).append("\")");
            stack.push(pTrans.toString());
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
            
        } else if (localName.equals("var") || localName.equals("list")) {
            
            String n = attributes.getValue("n");
            refId = n;
            stack.push(refId);
            
        } else if (localName.equals("concat")) {
            trans.append("concat\n");
        } else if (localName.equals("mlu")) {
            trans.append("mlu\n");
        } else if (localName.equals("lu")) {
            trans.append("lu\n");
        } else if (localName.equals("chunk")) {
            trans.append("Chunk\n");
        } else if (localName.equals("tags")) {
            trans.append("tags\n");
        } else if (localName.equals("b")) {
            String pos = attributes.getValue("pos");
            trans.append("b(");
            if (pos != null && !pos.equals("")) {
                trans.append(pos);
            }
            trans.append(");\n");
        } else if (localName.equals("reject-current-rule")) {
            String shifting = attributes.getValue("shifting");
            trans.append("rejectCurrentRule(");
            if (shifting != null && !shifting.equals("")) {
                trans.append("shifting=\"").append(shifting).append("\"");
            }
            trans.append(")");
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {

    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

        if (localName.equals("transfer")) {
            trans.append("end /* transfer */\n");
        } else if (localName.equals("def-cat")) {
            trans.append(pTrans.toString().replaceAll(", $", ";")).append("\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("def-attr")) {
            trans.append(pTrans.toString().replaceAll(", $", ";")).append("\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("def-var")) {
            trans.append(";\n");
        } else if (localName.equals("def-list")) {
            trans.append(pTrans.toString().replaceAll(", $", ";")).append("\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("def-macro")) {
            trans.append("end /* macro */\n");
        } else if (localName.equals("rule")) {
            trans.append("end /* rule */\n");
        } else if (localName.equals("pattern")) {
            trans.append(pTrans.toString().replaceAll(", $", ";")).append("\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } /* sentence (dtd) */ else if (localName.equals("choose")) {
            trans.append("end /* choose */\n");
        } else if (localName.equals("when")) {
            trans.append("end /* when */\n");
        } else if (localName.equals("test")) {
            trans.append(stack.pop()).append(" then\n");
            stack.clear();
        } else if (localName.equals("otherwise")) {
            trans.append("end /* otherwise */\n");
        } else if (localName.equals("and") || localName.equals("or")) {

            // Desapilar n elementos y generar traducción.
            boolean found = false;
            while (!stack.empty() && !found) {
                String e = stack.pop();
                if (!e.equals(localName)) {
                    pTrans.append(e).append(" ").append(localName).append(" ");
                } else {
                    found = true;
                }
            }

            // Alamacenar la traducción parcial en la pila.
            stack.push(pTrans.toString().replaceAll(" " + localName + " $", ""));
            // pTrans.setLength(0);
            pTrans = new StringBuilder();

        } else if (localName.equals("not")) {
            String c = stack.pop();
            pTrans.append("not ").append(c);
            stack.push(trans.toString());
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("equal")
                || localName.equals("begins-with") || localName.equals("begins-with-list")
                || localName.equals("ends-with") || localName.equals("ends-with-list")
                || localName.equals("contains-substring") || localName.equals("in")) {

            // Desapilar 2 elementos.
            String v1 = stack.pop();
            String v2 = stack.pop();

            // Generar traducción añadiendo el operador condicional.
            pTrans.append(v2).append(" ").append(condition).append(" ").append(v1);

            // Alamacenar la traducción parcial en la pila.
            stack.push(pTrans.toString());
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("let") || localName.equals("append") || localName.equals("modify-case")) {

            stack.forEach((e) -> {
                pTrans.append(e).append(" ").append(sentence).append(" ");
            });
            stack.clear();

            trans.append(pTrans.toString().replaceAll(" " + sentence + " $", "")).append(";\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();

        } else if (localName.equals("out")) {
            trans.append("end /* out */\n");
        } else if (localName.equals("call-macro")) {
            trans.append(pTrans.toString().replaceAll(", $", ")")).append(";\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("concat")) {
            while (!stack.empty()) {
                pTrans.append(stack.pop()).append(";\n");
            }
            trans.append(pTrans).append("end /* concat */\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        } else if (localName.equals("mlu")) {
            trans.append(pTrans).append("end /* mlu */\n");
        } else if (localName.equals("lu")) {
            while (!stack.empty()) {
                pTrans.append(stack.pop()).append(";\n");
            }
            trans.append(pTrans).append("end /* lu */\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();

        } else if (localName.equals("chunk")) {
            trans.append("end /* chunk */\n");
        } else if (localName.equals("tags")) {
            while (!stack.empty()) {
                pTrans.append(stack.pop()).append(";\n");
            }
            trans.append(pTrans).append("end /* tags */\n");
            // pTrans.setLength(0);
            pTrans = new StringBuilder();
        }
    }

    @Override
    public void endDocument() {
        System.out.println(trans.toString());
    }
}
