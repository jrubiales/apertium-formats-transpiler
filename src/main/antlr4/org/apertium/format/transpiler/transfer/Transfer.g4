grammar Transfer;

/**
 * Especificación sintáctica.
 */

/*

stat : T {

            if($T.text.equals("catlex")){
                System.out.print("<def-cat");
            };

        } ID {

            System.out.println(" n=\"" + $ID.text + "\">");

        } ASSIGNOP STRING {

            System.out.println("<cat-item tags=\"" + $STRING.text + "\"/>");

        } SEMICOLON {

            System.out.println("</def-cat>");

        }
;

*/

stat
    : bDcl EOF;

// Block delarations.
bDcl
    : tDecl (bDcl)?
    | varDecl (bDcl)?
    | mDecl (bDcl)?
    ;

// Type declare
tDecl
    : t ID ASSIGN multString SEMI
    ;

// Multi-string definition.
multString
    : literal COMMA multString
    | literal
    ;

// Var declare.
varDecl
    : VAR varExpr SEMI
    ;

// Var expression.
varExpr
    : assiExpr COMMA varExpr
    | assiExpr
    ;

// Macro declare.
mDecl
    : MACRO ID LPAR mParams RPAR IS mBody END
    ;

// Macro params.
mParams
    : ID COMMA mParams
    | ID
    ;

// Macro body.
mBody
    :
    | CASE caseBlock END
    ;

// Case block.
caseBlock
    : caseInstr
    ;

// Case instruction.
caseInstr
    : whenInst (caseInstr)?
    ;

whenInst
    : WHEN expr THEN instr (ELSE instr)? END
    ;

instr
    : caseInstr
    | ID ASSIGN clipFunc SEMI (instr)?
    ;

// Expression.
expr    
    : clipFunc EQUAL literal
    ;

// Clip instruction.
clipFunc
    : CLIP LPAR ID COMMA literal COMMA literal RPAR 
    ;

// Assignment expression
assiExpr
    : ID
    | ID ASSIGN literal
    ;

t
    : CATLEX
    | ATTR
    | LIST
    ;

literal
    :   CharacterLiteral
    |   StringLiteral
    ;


/**
 * Especificación léxica.
 */

// Keywords.

CATLEX          : 'catlex' ;
ATTR            : 'attribute' ;
LIST            : 'list';
VAR             : 'var' ;
MACRO           : 'macro';
IS              : 'is';
CASE            : 'case';
END             : 'end';
WHEN            : 'when';
THEN            : 'then';
ELSE            : 'else';
CLIP            : 'clip';

// Identifiers.

ID              : [a-zA-Z_][a-zA-Z_0-9]*;
INT             : [0-9]+ ;

// Operators.

ASSIGN          : '=';
NOT             : '!';
COLON           : ':';
EQUAL           : '==';
NOTEQUAL        : '!=';
AND             : '&&';
OR              : '||';

// Separators.

LPAR            : '(';
RPAR            : ')';
SEMI            : ';';
COMMA           : ',';

// Character Literals.

CharacterLiteral
    :   '\'' SingleCharacter '\''
    |   '\'' EscapeSequence '\''
    ;

fragment
SingleCharacter
    :   ~['\\]
    ;

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
