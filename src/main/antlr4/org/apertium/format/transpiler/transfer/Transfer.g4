grammar Transfer;

/**
 * Syntactic specification.
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

// Block delaration.
bDcl
    : tDecl bDcl?
    | varDecl bDcl?
    | mDecl bDcl?
    | rDecl bDcl?
    ;

// Type declaration.
tDecl
    : t ID ASSIGN multString SEMI
    ;

// Multi-string.
multString
    : literal (COMMA multString)?
    ;

// Var declaration.
varDecl
    : VAR varExpr SEMI
    ;

// Var expression.
varExpr
    : assiExpr (COMMA varExpr)?
    ;

// Macro declaration.
mDecl
    : MACRO ID LPAR mParams RPAR mBody END
    ;

// Macro params.
mParams
    : NPAR ASSIGN INT (C ASSIGN literal)?
    ;

// Macro body.
mBody
    : instr
    ;

// Rule declaration.
rDecl
    : RULE LPAR rParams RPAR rBody END
    ;

// Rule params.
rParams
    : RCOMMENT ASSIGN literal (COMMA rParams)?
    | C ASSIGN literal (COMMA rParams)?
    ;

// Rule body.
rBody
    : PATTERN ASSIGN multString SEMI rBody?
    | instr rBody?
    ;

// Instruction.
instr
    : CASE whenInstr+ END                                       /* choose */
    | container ASSIGN value SEMI instr?                        /* let */
    | ID LPAR POS ASSIGN INT RPAR SEMI instr?                   /* call-macro */
    | MODIFY_CASE container stringValue instr?                  /* modify-case */
    | container APPEND value instr?                             /* append */
    | REJECT_CURRENT_RULE LPAR 'shifting' ASSIGN ('yes'|'no')   /* reject-current-rule */
    | OUT (mlu|lu|b|chunk|ID)+ END                              /* out */
    ;

container 
    : (ID|clip) 
    ;

value
    : (b|clip|literal|ID|getCaseFrom|caseOf|concat|lu|mlu|chunk)
    ;

stringValue
    : (clip|literal|ID|getCaseFrom|caseOf)
    ;

b: 'b' (LPAR POS ASSIGN INT RPAR)? SEMI
 ;

concat
    : CONCAT (value SEMI)+ END
    ;

lu
    : LU (value SEMI)+ END
    ;

mlu
    : MLU lu+ END
    ;

chunk
    : CHUNK ID (LPAR chunkParams* RPAR)? tags (mlu|lu|b|ID)+ END
    ;

chunkParams
    : (NAME|NAME_FROM|CASE|C) ASSIGN literal
    ;

tags
    : TAGS (value SEMI)+ END
    ;

getCaseFrom
    : GET_CASE_FROM LPAR POS ASSIGN INT RPAR (clip|literal|ID)
    ;

caseOf
    : CASE_OF LPAR POS ASSIGN INT COMMA SIDE ASSIGN side COMMA PART ASSIGN literal RPAR (clip|literal|ID)
    ;

// When instruction.
whenInstr
    : WHEN expr THEN instr (ELSE instr)? END
    ;

// Expression.
expr    
    : clip NOT? (EQUAL|EQUAL_CASELESS) literal (AND|OR expr)?
    | clip NOT? (IN|IN_CASELESS|BEGINS_WITH|BEGINS_WITH_CASELESS|ENDS_WITH|ENDS_WITH_CASELESS|CONTAINS_SUBSTR|CONTAINS_SUBSTR_CASELESS) ID (AND|OR expr)?
    ;

// Clip function.
clip
    : CLIP LPAR clipParams RPAR 
    ;

// Clip function params.
clipParams
    : POS ASSIGN INT COMMA SIDE ASSIGN side COMMA PART ASSIGN literal (COMMA (QUEUE|LINK_TO|C) ASSIGN literal)?
    ;

// Side param (clip function).
side
    : '"sl"'
    | '"tl"'
    ;

// Assignment expression.
assiExpr
    : ID
    | ID ASSIGN literal
    ;

// Type.
t
    : CATLEX
    | ATTR
    | LIST
    ;

// Literal.
literal
    : StringLiteral
    ;

/**
 * Lexical specification.
 */

// Keywords.

CATLEX                      : 'Catlex' ;
ATTR                        : 'Attribute' ;
LIST                        : 'List' ;
VAR                         : 'Var' ;
MACRO                       : 'Macro' ;
N                           : 'n' ;
NPAR                        : 'npar' ;
C                           : 'c' ;
CASE                        : 'case' ;
END                         : 'end' ;
WHEN                        : 'when' ;
THEN                        : 'then' ;
ELSE                        : 'else' ;
CLIP                        : 'clip' ;
POS                         : 'pos' ;
SIDE                        : 'side' ;
PART                        : 'part' ;
QUEUE                       : 'queue' ;
LINK_TO                     : 'linkTo' ;
RULE                        : 'Rule' ;
RCOMMENT                    : 'comment' ;
PATTERN                     : 'pattern' ;
IN_CASELESS                 : 'inCaseless' ;
BEGINS_WITH                 : 'beginsWith' ;
BEGINS_WITH_CASELESS        : 'beginsWithCaseless' ;
ENDS_WITH                   : 'endsWith' ;
ENDS_WITH_CASELESS          : 'endsWithCaseless' ;
CONTAINS_SUBSTR             : 'containsSubstring' ;
CONTAINS_SUBSTR_CASELESS    : 'containsSubstringCaseless' ;
MODIFY_CASE                 : 'modifyCase' ;
APPEND                      : 'append' ;
REJECT_CURRENT_RULE         : 'rejectCurrentRule' ;
OUT                         : 'out' ;
GET_CASE_FROM               : 'get case from' ;
CASE_OF                     : 'case of' ;
CONCAT                      : 'concat' ;
LU                          : 'lu' ;
MLU                         : 'mlu' ;
CHUNK                       : 'Chunk';
TAGS                        : 'tags';
NAME                        : 'name';
NAME_FROM                   : 'nameFrom';

// Operators.

ASSIGN                      : '=' ;
NOT                         : 'not' ;
EQUAL                       : 'equal' ;
EQUAL_CASELESS              : 'equalCaseless' ;
AND                         : 'and' ;
OR                          : 'or' ;
IN                          : 'in' ;


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
