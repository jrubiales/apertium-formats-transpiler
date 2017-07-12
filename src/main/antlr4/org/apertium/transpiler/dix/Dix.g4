grammar Dix;

/**
 * Syntactic specification.
 */

stat
    :
    {
        System.out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        System.out.print("<dictionary>");
    } alphabet? sdefs? pardefs? section+ {
        System.out.print("</dictionary>");
    } EOF
    ;

alphabet
    : ALPHABET {
        System.out.print("<alphabet>");
    } ASSIGN literal {
        System.out.print($literal.text);
    } SEMI {
        System.out.print("</alphabet>");
    }
    ;

sdefs
    : SYMBOLS { System.out.print("<sdefs>"); } ASSIGN sdef+ SEMI { System.out.print("</sdefs>"); }
    ;

sdef
    : { System.out.print("<sdef n="); } literal { System.out.print($literal.text + " />");  } COMMA?
    ;

pardefs
    : { System.out.print("<pardefs>"); } pardef+ { System.out.print("</pardefs>"); }
    ;

pardef
    : PARDEF {
        System.out.print("<pardef");
    } literal {
        System.out.print(" n=" + $literal.text + ">");
    } e+ END {
        System.out.print("</pardef>");
    }
    ;

section
    : SECTION {
        System.out.print("<section");
    } ID {
        System.out.print(" n=\"" + $ID.text + "\"");
    } LPAR 'type' ASSIGN type = ('"standard"' | '"inconditional"' | '"postblank"' | '"preblank"') { 
        System.out.print(" type=" + $type.text + ">"); 
    } RPAR e+ END {
        System.out.print("</section>"); 
    }
    ;

e
    : ENTRY { 
        System.out.print("<e"); 
    } (LPAR att = ('r'|'lm'|'a'|'c'|'i'|'slr'|'srl'|'alt'|'v'|'vl'|'vr') { 
        System.out.print(" " + $att.text); 
    } ASSIGN {
        System.out.print("=");
    } (value = ('"LR"' | '"RL"') {
        System.out.print($value.text);
    } | literal {
        System.out.print($literal.text);
    }) RPAR)? { 
        System.out.print(">"); 
    } (i | p | par | re)+ END { 
        System.out.print("</e>"); 
    }
    ;

i
    : IDENTITY { System.out.print("<i>"); } ASSIGN literal {
        String result = $literal.text;
        result = result.replaceAll("\"", "");
        // TODO. Contemplar mas entidades html.
        result = result.replaceAll("&", "&amp;");
        // TODO. Solucionar problema \{ ([\w\{\} ]*)\}
        result = result.replaceAll("\\{ ([\\w\\{\\} ]*)\\}", "<g>$0</g>");
        result = result.replaceAll("\\{a\\}", "<a/>");
        result = result.replaceAll(" ", "<b/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{(\\w*)\\}", "<s n=\"$0\" />");
        result = result.replaceAll("[\\{\\}]", "");
        System.out.print(result);
    } SEMI { System.out.print("</i>"); }
    ;

p
    : { System.out.print("<p><l>"); } l { System.out.print("</l>"); } '>' { System.out.print("<r>"); } r { System.out.print("</r>"); } SEMI { System.out.print("</p>"); }
    ;

l
    : literal {
        String result = $literal.text;
        result = result.replaceAll("\"", "");
        // TODO. Contemplar mas entidades html.
        result = result.replaceAll("&", "&amp;");
        // TODO. Solucionar problema \{ ([\w\{\} ]*)\}
        result = result.replaceAll("\\{ ([\\w\\{\\} ]*)\\}", "<g>$0</g>");
        result = result.replaceAll("\\{a\\}", "<a/>");
        result = result.replaceAll(" ", "<b/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{(\\w*)\\}", "<s n=\"$0\" />");
        result = result.replaceAll("[\\{\\}]", "");
        System.out.print(result);
    }
    ;

r
    : literal {
        String result = $literal.text;
        result = result.replaceAll("\"", "");
        result = result.replaceAll("&", "&amp;");
        // TODO. Solucionar problema \{ ([\w\{\} ]*)\}
        result = result.replaceAll("\\{ ([\\w\\{\\} ]*)\\}", "<g>$0</g>");
        result = result.replaceAll("\\{a\\}", "<a/>");
        result = result.replaceAll(" ", "<b/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{j\\}", "<j/>");
        result = result.replaceAll("\\{(\\w*)\\}", "<s n=\"$0\" />");
        result = result.replaceAll("[\\{\\}]", "");
        System.out.print(result);
    }
    ;

par
    : PREF { System.out.print("<par"); } ASSIGN literal { System.out.print(" n=" + $literal.text); } SEMI { System.out.print("/>"); }
    ;

re
    : RE { System.out.print("<re>"); } ASSIGN literal { System.out.print($literal.text.replaceAll("\"", "")); } SEMI { System.out.print("</re>"); }
    ;

// Literal.
literal
    : STRING
    ;

/**
 * Lexical specification.
 */

// Keywords.

ALPHABET                    : 'alphabet' ;
SYMBOLS                     : 'symbols' ;
PARDEF                      : 'pardef' ;
SECTION                     : 'section' ;
ASSIGN                      : '=' ;
END                         : 'end' ;
PREF                        : 'par-ref' ;
IDENTITY                    : 'identity';
ENTRY                       : 'entry';
RE                          : 're' ;

// Tags Attributres

N                           : 'n' ;
C                           : 'c' ;

// Separators.

LPAR                        : '(' ;
RPAR                        : ')' ;
SEMI                        : ';' ;
COMMA                       : ',' ;
QUOTE                       : '"' ;
LBRACE                      : '{' ;
RBRACE                      : '}' ;

// Identifiers.

ID                          : [a-zA-Z_][a-zA-Z_0-9]* ;
INT                         : [0-9]+ ;

// String Literals.

STRING                      : '"' ('\\"' | ~'"')* '"';

// Whitespace and comments.

WS                          :  [ \t\r\n\u000C]+ -> skip ;

COMMENT                     :   '/*' .*? '*/' -> skip ;

LINE_COMMENT                :   '//' ~[\r\n]* -> skip ;
