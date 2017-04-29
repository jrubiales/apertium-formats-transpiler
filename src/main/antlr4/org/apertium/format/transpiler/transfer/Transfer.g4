grammar Transfer;

/*
@members {
    String trans = "";
}
*/

/**
 * Syntactic specification.
 */

stat
    : 
    { 
        System.out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"); 
    } transfer EOF
    ;

// Root element containing the whole structural transfer rule file.
transfer
    :
    TRANSFER {
        System.out.print("<transfer");
    } LPAR 'default' {
        System.out.print(" default");
    } ASSIGN {
        System.out.print($ASSIGN.text);
    } group = ('"lu"' | '"chunk"') { 
        System.out.print($group.text); 
    } RPAR {
        System.out.print(">");
    } transferBody END {
        System.out.print("</transfer>");
    }
    ;

// Transfer body.
transferBody
    : tDecl transferBody?
    | varDecl transferBody?
    | mDecl transferBody?
    | rDecl
    ;

// Type declaration. Catlex, Attribute, List
tDecl
    : t ID {
        System.out.print("n=\"" + $ID.text + "\">");
    } ASSIGN multString[$t.text] SEMI
    ;

// Multi-string.
multString [String str]
    : literal {

        switch(str){
            case "Catlex" :
                String[] tokens = $literal.text.split(",");
                System.out.print("<cat-item ");
                if(tokens.length == 1){
                    System.out.print("tags=" + tokens[0]);
                } else if(tokens.length > 1){
                    System.out.print("lemma=" + tokens[0] + "\" tags=\"" + tokens[1]);
                }
                System.out.print("/>");
                break;
            case "Attribute" : System.out.print("<attr-item tags=" + $literal.text + "/>"); break;
            case "List" : System.out.print("<list-item v=" + $literal.text + "/>"); break;
            case "Pattern" : System.out.print("<pattern-item n=" + $literal.text + "/>"); break;
        }
        
    } (COMMA multString[str])?
    ;

// Var declaration.
varDecl
    : VAR varExpr+ SEMI
    ;

// Var expression.
varExpr
    : { 
        System.out.print("<def-var ");
    }(ID { 
        System.out.print("n=\"" + $ID.text + "\"/>");
    } | ID ASSIGN { 
        System.out.print("n=\"" + $ID.text + "\" ");
    } literal {
        System.out.print("v=" + $literal.text + "/>");
    }) COMMA?
    ;

// Macro declaration.
mDecl
    : MACRO {
        System.out.print("<def-macro ");
    } ID {
        System.out.print("n=\"" + $ID.text + "\" ");  
    } LPAR mParams RPAR mBody END {
        System.out.println("</def-macro>");
    }
    ;

// Macro params.
mParams
    : NPAR ASSIGN INT {
        System.out.print($NPAR.text + "=\"" + $INT.text + "\"");
    }(C ASSIGN literal{
        System.out.print(" " + $C.text + "=" + $literal.text);
    })? { 
        System.out.print(">"); 
    }
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
    : PATTERN ASSIGN multString[$PATTERN.text] SEMI rBody?
    | instr rBody?
    ;

// Instruction.
instr
    : CASE { 
        System.out.print("<choose>");
    } whenInstr+ END {
        System.out.print("</choose>");
    }                                                           /* choose */
    | {
        System.out.print("<let>");
    } container ASSIGN value SEMI {
        System.out.print($container.trans + $value.trans + "</let>");
    } instr?                                                    /* let */
    | ID LPAR POS ASSIGN INT RPAR SEMI instr?                   /* call-macro */
    | MODIFY_CASE container stringValue instr?                  /* modify-case */
    | container APPEND value instr?                             /* append */
    | REJECT_CURRENT_RULE LPAR 'shifting' ASSIGN ('yes'|'no')   /* reject-current-rule */
    | OUT (mlu|lu|b|chunk|ID)+ END                              /* out */
    ;

container returns [String trans]
    : (ID| clip {
        $trans = $clip.trans;
    }) 
    ;

value returns [String trans]
    : (b|clip|literal { 
        $trans = "<lit v=" + $literal.text + "/>";
    }|ID|getCaseFrom|caseOf|concat|lu|mlu|chunk)
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
    : WHEN {
        System.out.print("<when><test>");
    } expr { 
        System.out.print($expr.trans + "</test>");
    } THEN instr {
        System.out.print("</when>");
    } (ELSE {
        System.out.print("<otherwise>");
    } instr {
        System.out.print("</otherwise>");
    })? END {
        
    }
    ;

// Expression.
expr returns [String trans]
    : v1 = value NOT? c1 =(EQUAL|EQUAL_CASELESS) v2 = value {
        $trans = "";
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        String caselessAttr = ($c1.text.equals("equalCaseless")) ? " caseless=\"yes\"" : "";
        if(hasNot){
            $trans += "<not>";
        }
        $trans += "<equal" + caselessAttr + ">" +$v1.text + $v2.text + "</equal>";
        if(hasNot){
            $trans += "</not>";
        }
    } /* Recursion base case */
    | v1 = value NOT? c1 = (EQUAL|EQUAL_CASELESS) v2 = value (c2 = (AND|OR) expr {
        $trans = "";
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        String caselessAttr = ($c1.text.equals("equalCaseless")) ? " caseless=\"yes\"" : "";
        if(hasNot){
            $trans += "<not>";
        }
        $trans += "<" + $c2.text + "><equal" + caselessAttr + ">" +$v1.text + $v2.text + "</equal>" + $expr.trans + "</" + $c2.text + ">";
        if(hasNot){
            $trans += "</not>";
        }
    })?                                                                                                                                             /* value value */
    | value NOT? (IN|IN_CASELESS|BEGINS_WITH|BEGINS_WITH_CASELESS|ENDS_WITH|ENDS_WITH_CASELESS) ID (AND|OR expr)?                                   /* value list */
    | value NOT? (BEGINS_WITH|BEGINS_WITH_CASELESS|ENDS_WITH|ENDS_WITH_CASELESS|CONTAINS_SUBSTR|CONTAINS_SUBSTR_CASELESS) value (AND|OR expr)?      /* value value */
    ;

// Clip function.
clip returns [String trans]
    : CLIP { 
        $trans = "<clip ";
    } LPAR clipParams RPAR {
        $trans += $clipParams.trans + "/>";
    }
    ;

// Clip function params.
clipParams returns [String trans]
    : POS ASSIGN INT COMMA SIDE ASSIGN side COMMA PART ASSIGN literal {
        $trans = "pos=\"" + $INT.text + "\" side=" + $side.text + " part=" + $literal.text;
    } (COMMA clipParam = (QUEUE|LINK_TO|C) ASSIGN literal{
        $trans += $clipParam.text + "=" + $literal.text;
    })?
    ;

// Side param (clip function).
side
    : '"sl"'
    | '"tl"'
    ;

// Type.
t
    : CATLEX {
        System.out.print("<def-cat ");
    }
    | ATTR? {
        System.out.print("<def-attr ");
    }
    | LIST? {
        System.out.print("<def-list ");
    }
    ;

// Literal.
literal
    : StringLiteral
    ;

/**
 * Lexical specification.
 */

// Keywords.

TRANSFER                    : 'Transfer' ;
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
LINK_TO                     : 'link-to' ;
RULE                        : 'Rule' ;
RCOMMENT                    : 'comment' ;
PATTERN                     : 'Pattern' ;
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

ID                          
                            : [a-zA-Z_][a-zA-Z_0-9]* ;
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
