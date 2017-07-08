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
        System.out.println($literal.trans);
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
        System.out.print("<pardef n=");  
    } literal { 
        System.out.print($literal.text);  
    } e+ END {
        System.out.println(" />");  
    }
    ;

section
    : SECTION e+ END
    ;

e
    : (i | p | par | re)+
    ;

i
    : (literal | b | s | g | j | a)*
    ;

p 
    : l '>' r
    ;

l
    : (literal | a | b | g | j | s)
    ;

r
    : (literal | a | b | g | j | s)
    ;

par
    :
    ;

re 
    : literal
    ;

b
    :
    ;

s
    :
    ;

g
    : (literal | a | b | j | s)*
    ;

j
    :
    ;

a
    :
    ;

// Literal.
literal returns [String trans = ""]
    : StringLiteral { $trans = $StringLiteral.text.replaceAll("\"", ""); }
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

// Tags Attributres

N                           : 'n' ;
C                           : 'c' ;

// Separators.

LPAR                        : '(' ;
RPAR                        : ')' ;
SEMI                        : ';' ;
COMMA                       : ',' ;

// Identifiers.

ID                          : [a-zA-Z_][a-zA-Z_0-9]* ;
INT                         : [0-9]+ ;

// String Literals.

StringLiteral
    :   '"' StringCharacters? '"'
    ;

fragment
StringCharacters
    :   StringCharacter+
    ;

fragment
StringCharacter
    :   ~["\\]
    |   EscapeSequence
    ;

// Escape Sequences for Character and String Literals.
fragment
EscapeSequence
    :   '\\' [btnfr"'\\]
    |   OctalEscape
    |   UnicodeEscape
    ;

fragment
OctalEscape
    :   '\\' OctalDigit
    |   '\\' OctalDigit OctalDigit
    |   '\\' ZeroToThree OctalDigit OctalDigit
    ;

fragment
UnicodeEscape
    :   '\\' 'u' HexDigit HexDigit HexDigit HexDigit
    ;

fragment
ZeroToThree
    :   [0-3]
    ;

fragment
OctalDigit
    :   [0-7]
    ;

fragment
HexDigit
    :   [0-9a-fA-F]
    ;

// Whitespace and comments.

WS  :  [ \t\r\n\u000C]+ -> skip
    ;

COMMENT
    :   '/*' .*? '*/' -> skip
    ;

LINE_COMMENT
    :   '//' ~[\r\n]* -> skip
    ;
