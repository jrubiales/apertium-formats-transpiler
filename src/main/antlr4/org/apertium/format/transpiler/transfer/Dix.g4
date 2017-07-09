grammar Dix;

/**
 * Syntactic specification.
 */

stat
    :
    {
        System.out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        System.out.println("<dictionary>");
    } alphabet? sdefs? pardefs? section+ {
        System.out.println("</dictionary>");
    } EOF
    ;

alphabet
    : ALPHABET {
        System.out.print("<alphabet>");
    } ASSIGN literal {
        System.out.println($literal.text);
    } SEMI {
        System.out.println("</alphabet>");
    }
    ;

sdefs
    : SYMBOLS { System.out.println("<sdefs>"); } ASSIGN sdef+ SEMI { System.out.println("</sdefs>"); }
    ;

sdef
    : { System.out.print("<sdef n="); } literal { System.out.print($literal.text + " />");  } COMMA?
    ;

pardefs
    : { System.out.println("<pardefs>"); } pardef+ { System.out.println("</pardefs>"); }
    ;

pardef
    : PARDEF {
        System.out.print("<pardef");
    } literal {
        System.out.print(" n=" + $literal.text);
    } e+ END {
        System.out.println(" />");
    }
    ;

section
    : SECTION { System.out.print("<section>");} e+ END {System.out.println("</section>"); }
    ;

e
    : ENTRY { System.out.println("<e"); } LPAR (R ASSIGN literal)* RPAR { System.out.print(">"); } (i | p | par | re)+ END { System.out.println("</e>"); }
    ;

/* QUOTE (ID | b | s | g | j | a)* QUOTE */
i
    : I { System.out.print("<i>"); } ASSIGN literal {
        String litTrans = $literal.text;
        // TODO.
        litTrans = litTrans.replaceAll("{a}", "<a/>");
        litTrans = litTrans.replaceAll(" ", "<b/>");
        litTrans = litTrans.replaceAll("{j}", "<j/>");
        litTrans = litTrans.replaceAll("{", "<g>");
        litTrans = litTrans.replaceAll("}", "</g>");
        System.out.print(litTrans);
    } SEMI { System.out.println("</i>"); }
    ;

p
    : { System.out.print("<l>"); } l { System.out.println("</l>"); } '>' { System.out.print("<r>"); } r { System.out.println("</r>"); }
    ;

/* QUOTE { System.out.print($QUOTE.text); } (ID | a | b | g | j | s)* QUOTE */
l
    : literal { System.out.println(""); }
    ;

/* QUOTE { System.out.print($QUOTE.text); } (ID | a | b | g | j | s)* QUOTE */
r
    : literal { System.out.println(""); }
    ;

par
    : PREF { System.out.print("<par"); } ASSIGN ID { System.out.print("n=\"" + $ID.text + "\""); } SEMI { System.out.print("</par>"); }
    ;

re
    : RE { System.out.print("<re>"); } ASSIGN literal { System.out.print($literal.text); } { System.out.println("</re>"); }
    ;

/*

b
    : ' ' { System.out.print(" "); }
    ;

s
    : LBRACE ID RBRACE { System.out.print("<s n=\"" + $ID.text + "\" />"); }
    ;

g
    : LBRACE { System.out.print("<g>"); } (ID | a | b | j | s)* RBRACE { System.out.print("</g>"); }
    ;

j
    : LBRACE 'j' RBRACE { System.out.print("</j>"); }
    ;

a
    : LBRACE 'a' RBRACE { System.out.print("</a>"); }
    ;

*/

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
