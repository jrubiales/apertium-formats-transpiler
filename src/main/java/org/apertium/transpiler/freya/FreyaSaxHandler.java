package org.apertium.transpiler.freya;

import com.google.common.base.CaseFormat;
import java.util.Stack;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class FreyaSaxHandler extends DefaultHandler {

    /* Traducciones parciales. */
    private final StringBuilder pTrans;

    private String condition, sentence, refId;

    private final Stack<String> stack;

    public FreyaSaxHandler() {
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
            System.out.print("transfer");
            String def = attributes.getValue("default");
            if (def != null) {
                System.out.print("(default=\"");
                System.out.print(def);
                System.out.print("\")");
            }
            System.out.println();
        } else if (localName.equals("def-cat")) {
            String n = attributes.getValue("n");
            System.out.print("catlex ");
            System.out.print(n);
            System.out.print(" = ");
        } else if (localName.equals("cat-item")) {
            String lemma = attributes.getValue("lemma");
            pTrans.append("\"");
            if (lemma != null) {
                pTrans.append(lemma).append(",");
            }
            String tags = attributes.getValue("tags");
            pTrans.append(tags).append("\", ");
        } else if (localName.equals("def-attr")) {
            String n = attributes.getValue("n");
            System.out.print("attribute ");
            System.out.print(n);
            System.out.print(" = ");
        } else if (localName.equals("attr-item")) {
            String tags = attributes.getValue("tags");
            if (tags != null) {
                pTrans.append("\"").append(tags).append("\", ");
            }
        } else if (localName.equals("def-var")) {
            String n = attributes.getValue("n");
            System.out.print("var ");
            System.out.print(n);
            String v = attributes.getValue("v");
            if (v != null) {
                System.out.print(" = ");
                System.out.print("\"");
                System.out.print(v);
                System.out.print("\"");
            }
        } else if (localName.equals("def-list")) {
            String n = attributes.getValue("n");
            System.out.print("list ");
            System.out.print(n);
            System.out.print(" = ");
        } else if (localName.equals("list-item")) {
            String v = attributes.getValue("v");
            pTrans.append("\"").append(v).append("\", ");
        } else if (localName.equals("def-macro")) {
            String n = attributes.getValue("n");
            String nPar = attributes.getValue("npar");
            System.out.print("macro ");
            System.out.print(n);
            System.out.print("(npar=");
            System.out.print(nPar);
            System.out.print(")\n");
        } else if (localName.equals("rule")) {
            System.out.print("rule(");
            String c = attributes.getValue("c");
            if (c != null) {
                System.out.print("c=\"");
                System.out.print(c);
                System.out.print("\", ");
            }
            String comment = attributes.getValue("comment");
            if (comment != null) {
                System.out.print("comment=\"");
                System.out.print(comment);
                System.out.print("\"");
            }
            System.out.print(")\n");
        } else if (localName.equals("pattern")) {
            System.out.print("pattern = ");
        } else if (localName.equals("pattern-item")) {
            String n = attributes.getValue("n");
            pTrans.append("\"").append(n).append("\", ");
        } /* sentence (dtd) */ else if (localName.equals("choose")) {
            System.out.print("choose\n");
        } else if (localName.equals("when")) {
            System.out.print("when ");
        } else if (localName.equals("otherwise")) {
            System.out.println("otherwise ");
        } else if (localName.equals("and") || localName.equals("or")) {
            stack.push(localName);
        } else if (localName.equals("equal")){
            String caseless = attributes.getValue("caseless");
            if (caseless != null && caseless.equals("yes")) {
                condition = "===";
            } else {
                condition = "==";
            }
        } else if (localName.equals("begins-with") || localName.equals("begins-with-list")
                || localName.equals("ends-with") || localName.equals("ends-with-list")
                || localName.equals("contains-substring") || localName.equals("in")) {
            String caseless = attributes.getValue("caseless");
            condition = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, localName.replaceAll("-", "_"));
            if (caseless != null && caseless.equals("yes")) {
                condition += "caseless";
            }
        } else if (localName.equals("let")) {
            sentence = "=";
        } else if (localName.equals("append")) {
            sentence = "append";
            String n = attributes.getValue("n");
            stack.push(n);
        } else if (localName.equals("out")) {
            System.out.print("out\n");
        } else if (localName.equals("modify-case")) {
            sentence = "modifyCase";
        } else if (localName.equals("call-macro")) {
            String n = attributes.getValue("n");
            System.out.print(n);
            System.out.print("(");
        } else if (localName.equals("with-param")) {
            String pos = attributes.getValue("pos");
            pTrans.append(pos).append(", ");
        } else if (localName.equals("clip")) {

            String pos = attributes.getValue("pos");
            String side = attributes.getValue("side");
            String part = attributes.getValue("part");

            pTrans.append("clip(pos=").append(pos)
                    .append(", side=\"").append(side).append("\"")
                    .append(", part=\"").append(part).append("\"");
            String queue = attributes.getValue("queue");
            if (queue != null) {
                pTrans.append(", queue=\"").append(queue).append("\"");
            }
            String linkTo = attributes.getValue("link-to");
            if (linkTo != null) {
                pTrans.append(", link-to=\"").append(linkTo).append("\"");
            }
            String c = attributes.getValue("c");
            if (c != null) {
                pTrans.append(", c=\"").append(c).append("\"");
            }
            pTrans.append(")");
            stack.push(pTrans.toString());
            pTrans.setLength(0);

        } else if (localName.equals("lit")) {

            String v = attributes.getValue("v");
            pTrans.append("\"").append(v).append("\"");
            stack.push(pTrans.toString());
            pTrans.setLength(0);

        } else if (localName.equals("lit-tag")) {

            String v = attributes.getValue("v");
            pTrans.append("litTag(\"").append(v).append("\")");
            stack.push(pTrans.toString());
            pTrans.setLength(0);

        } else if (localName.equals("var") || localName.equals("list")) {

            String n = attributes.getValue("n");
            refId = n;
            stack.push(refId);

        } else if (localName.equals("concat")) {
            System.out.print("concat\n");
        } else if (localName.equals("mlu")) {
            System.out.print("mlu\n");
        } else if (localName.equals("lu")) {
            System.out.print("lu\n");
        } else if (localName.equals("chunk")) {

            System.out.print("chunk");
            String attName = attributes.getValue("name");
            String attNamefrom = attributes.getValue("namefrom");
            String attCase = attributes.getValue("case");
            String attC = attributes.getValue("c");

            if (attName != null) {
                System.out.print(" " + attName + " ");
            }

            StringBuilder attTrans = new StringBuilder();

            if (attNamefrom != null) {
                attTrans.append("namefrom=\"").append(attNamefrom).append("\", ");
            }

            if (attCase != null) {
                attTrans.append("case=\"").append(attCase).append("\", ");
            }

            if (attC != null) {
                attTrans.append("c=\"").append(attC).append("\", ");
            }

            if (!attTrans.toString().equals("")) {
                System.out.print("(");
                System.out.print(attTrans.toString().replaceAll(", $", ""));
                System.out.print(")");
            }
            System.out.println("");

        } else if (localName.equals("tags")) {
            System.out.print("tags\n");
        } else if (localName.equals("b")) {
            String pos = attributes.getValue("pos");
            System.out.print("b");
            if (pos != null) {
                System.out.print("(");
                System.out.print(pos);
                System.out.print(")");
            }
            System.out.print(";\n");
        } else if (localName.equals("reject-current-rule")) {
            String shifting = attributes.getValue("shifting");
            System.out.print("rejectCurrentRule(");
            if (shifting != null && !shifting.equals("")) {
                System.out.print("shifting=\"");
                System.out.print(shifting);
                System.out.print("\"");
            }
            System.out.print(")");
        }
    }

    @Override
    public void characters(char[] ch, int start, int length) {

    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

        if (localName.equals("transfer")) {
            System.out.print("end /* transfer */\n");
        } else if (localName.equals("def-cat")) {
            System.out.print(pTrans.toString().replaceAll(", $", ";"));
            System.out.println();
            pTrans.setLength(0);
        } else if (localName.equals("def-attr")) {
            System.out.print(pTrans.toString().replaceAll(", $", ";"));
            System.out.println();
            pTrans.setLength(0);
        } else if (localName.equals("def-var")) {
            System.out.print(";\n");
        } else if (localName.equals("def-list")) {
            System.out.print(pTrans.toString().replaceAll(", $", ";"));
            System.out.println();
            pTrans.setLength(0);
        } else if (localName.equals("def-macro")) {
            System.out.print("end /* macro */\n");
        } else if (localName.equals("rule")) {
            System.out.print("end /* rule */\n");
        } else if (localName.equals("pattern")) {
            System.out.print(pTrans.toString().replaceAll(", $", ";"));
            System.out.println();
            pTrans.setLength(0);
        } /* sentence (dtd) */ else if (localName.equals("choose")) {
            System.out.print("end /* choose */\n");
        } else if (localName.equals("when")) {
            System.out.print("end /* when */\n");
        } else if (localName.equals("test")) {
            System.out.print(stack.pop());
            System.out.print(" then\n");
            stack.clear();
        } else if (localName.equals("otherwise")) {
            System.out.print("end /* otherwise */\n");
        } else if (localName.equals("and") || localName.equals("or")) {

            // Desapilar n elementos y generar traducción.
            boolean found = false;
            pTrans.append("(");
            while (!stack.empty() && !found) {
                String e = stack.pop();
                if (!e.equals(localName)) {
                    pTrans.append(e).append(" ").append(localName).append(" ");
                } else {
                    found = true;
                }
            }
            
            // Alamacenar la traducción parcial en la pila.
            stack.push(pTrans.toString().replaceAll(" " + localName + " $", ")"));
            
            pTrans.setLength(0);

        } else if (localName.equals("not")) {
            String c = stack.pop();
            pTrans.append("not (").append(c).append(")");
            stack.push(pTrans.toString());
            pTrans.setLength(0);
        } else if (localName.equals("equal")
                || localName.equals("begins-with") || localName.equals("begins-with-list")
                || localName.equals("ends-with") || localName.equals("ends-with-list")
                || localName.equals("contains-substring") || localName.equals("in")) {

            // Desapilar 2 elementos.
            String v2 = stack.pop();
            String v1 = stack.pop();

            // Generar traducción añadiendo el operador condicional.
            pTrans.append("(").append(v1).append(" ").append(condition).append(" ").append(v2).append(")");

            // Alamacenar la traducción parcial en la pila.
            stack.push(pTrans.toString());
            pTrans.setLength(0);
        } else if (localName.equals("let") || localName.equals("append") || localName.equals("modify-case")) {

            stack.forEach((e) -> {
                pTrans.append(e).append(" ").append(sentence).append(" ");
            });
            stack.clear();

            System.out.print(pTrans.toString().replaceAll(" " + sentence + " $", ""));
            System.out.print(";\n");
            pTrans.setLength(0);

        } else if (localName.equals("out")) {
            System.out.print("end /* out */\n");
        } else if (localName.equals("call-macro")) {
            System.out.print(pTrans.toString().replaceAll(", $", ")"));
            System.out.print(";\n");
            pTrans.setLength(0);
        } else if (localName.equals("concat")) {

            stack.forEach((e) -> {
                pTrans.append(e).append(";\n");
            });
            stack.clear();

            System.out.print(pTrans);
            System.out.print("end /* concat */\n");
            pTrans.setLength(0);
        } else if (localName.equals("mlu")) {
            System.out.print(pTrans);
            System.out.print("end /* mlu */\n");
        } else if (localName.equals("lu")) {

            stack.forEach((e) -> {
                pTrans.append(e).append(";\n");
            });
            stack.clear();
            System.out.print(pTrans);
            System.out.print("end /* lu */\n");
            pTrans.setLength(0);

        } else if (localName.equals("chunk")) {
            System.out.print("end /* chunk */\n");
        } else if (localName.equals("tags")) {

            stack.forEach((e) -> {
                pTrans.append(e).append(";\n");
            });
            stack.clear();
            System.out.print(pTrans);
            System.out.print("end /* tags */\n");
            pTrans.setLength(0);
        }
    }

    @Override
    public void endDocument() {

    }
}
