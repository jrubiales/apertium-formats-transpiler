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
    : SECTION { System.out.print("<section>");} e+ END {System.out.print("</section>"); }
    ;

e
    : ENTRY { System.out.print("<e"); } (LPAR R ASSIGN ('"LR"' | '"RL"') RPAR)? { System.out.print(">"); } (i | p | par | re)+ END { System.out.print("</e>"); }
    ;

i
    : I { System.out.print("<i>"); } ASSIGN literal {
        String litTrans = $literal.text;
        litTrans = litTrans.replaceAll("\\{a\\}", "<a/>");
        litTrans = litTrans.replaceAll(" ", "<b/>");
        litTrans = litTrans.replaceAll("\\{j\\}", "<j/>");
        litTrans = litTrans.replaceAll("\\{", "<g>");
        litTrans = litTrans.replaceAll("\\}", "</g>");
        litTrans = litTrans.replaceAll("\"", "");
        System.out.print(litTrans);
    } SEMI { System.out.print("</i>"); }
    ;

p
    : { System.out.print("<p><l>"); } l { System.out.print("</l>"); } '>' { System.out.print("<r>"); } r { System.out.print("</r>"); } SEMI { System.out.print("</p>"); }
    ;

l
    : literal {
        String litTrans = $literal.text;
        litTrans = litTrans.replaceAll("\\{a\\}", "<a/>");
        litTrans = litTrans.replaceAll(" ", "<b/>");
        litTrans = litTrans.replaceAll("\\{j\\}", "<j/>");
        litTrans = litTrans.replaceAll("\\{j\\}", "<j/>");
        litTrans = litTrans.replaceAll("\\{", "<g>");
        litTrans = litTrans.replaceAll("\\}", "</g>");
        litTrans = litTrans.replaceAll("\"", "");
        System.out.print(litTrans);
    }
    ;

r
    : literal {
        String litTrans = $literal.text;
        litTrans = litTrans.replaceAll("\\{a\\}", "<a/>");
        litTrans = litTrans.replaceAll(" ", "<b/>");
        litTrans = litTrans.replaceAll("\\{j\\}", "<j/>");
        litTrans = litTrans.replaceAll("\\{", "<g>");
        litTrans = litTrans.replaceAll("\\}", "</g>");
        litTrans = litTrans.replaceAll("\"", "");
        System.out.print(litTrans);
    }
    ;

par
    : PREF { System.out.print("<par"); } ASSIGN ID { System.out.print("n=\"" + $ID.text + "\""); } SEMI { System.out.print("</par>"); }
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
I                           : 'i';
ENTRY                       : 'entry';
RE                          : 're' ;

// Tags Attributres

N                           : 'n' ;
C                           : 'c' ;
R                           : 'r' ;

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
