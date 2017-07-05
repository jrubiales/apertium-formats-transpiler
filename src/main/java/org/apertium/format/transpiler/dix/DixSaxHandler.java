package org.apertium.format.transpiler.dix;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

/**
 *
 * @author juanfran
 */
public class DixSaxHandler extends DefaultHandler {

    /* Traducciones parciales. */
    private StringBuilder pTrans;

    public DixSaxHandler() {
        pTrans = new StringBuilder();
    }

    @Override
    public void startDocument() {

    }

    @Override
    public void startElement(String uri, String localName, String name,
            Attributes attributes) throws SAXException {

    }

    @Override
    public void characters(char[] ch, int start, int length) {

    }

    @Override
    public void endElement(String uri, String localName, String name)
            throws SAXException {

    }

    @Override
    public void endDocument() {

    }
}
