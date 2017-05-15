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
    : tDecl { 
        /*
            switch($tDecl::type){
                case "def-cat" : 
                    System.out.print("<section-def-cats>" + $tDecl.trans + "</section-def-cats>"); break;
                case "def-attr" : 
                    System.out.print("<section-def-attrs>" + $tDecl.trans + "</section-def-attrs>"); break;
                case "def-list" : 
                    System.out.print("<section-def-lists>" + $tDecl.trans + "</section-def-lists>"); break;
            }

        */
        System.out.print($tDecl.trans);
    } transferBody ?
    | { System.out.print("<section-def-vars>"); } varDecl { System.out.print("</section-def-vars>"); } transferBody?
    | mDecl transferBody?
    | rDecl
    ;

// Type declaration. Catlex, Attribute, List
tDecl returns [String trans = ""]
    
    locals [
        static String type = "",
    ]

    : t {
        $tDecl::type = $t.trans;
        $trans += "<" + $t.trans;
    } ID {
        $trans += " n=\"" + $ID.text + "\">";
    } ASSIGN multString[$t.text] {
        $trans += $multString.trans;
    } SEMI {
        $trans += "</" + $t.trans + ">";
    }
    ;

// Multi-string.
multString [String str] returns [String trans = ""]
    : literal {

        switch(str){
            case "Catlex" :
                String[] tokens = $literal.text.split(",");
                $trans += "<cat-item ";
                if(tokens.length == 1){
                    $trans += "tags=" + tokens[0];
                } else if(tokens.length > 1){
                    $trans += "lemma=" + tokens[0] + "\" tags=\"" + tokens[1];
                }
                $trans += "/>";
                break;
            case "Attribute" : $trans = "<attr-item tags=" + $literal.text + "/>"; break;
            case "List" : $trans += "<list-item v=" + $literal.text + "/>"; break;
            case "Pattern" : $trans += "<pattern-item n=" + $literal.text + "/>"; break;
        }
        
    } (COMMA multString[str] {
        $trans += $multString.trans;
    })?
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
    : instr { System.out.print($instr.trans); }
    ;

// Rule declaration.
rDecl
    : RULE {
        System.out.print("<rule ");
    } LPAR rParams RPAR {
        System.out.print(">");
    } rBody END {
        System.out.println("</rule>");
    }
    ;

// Rule params.
rParams
    : RCOMMENT ASSIGN literal {
        System.out.print("comment=" + $literal.text);
    } (COMMA rParams)?
    | C ASSIGN literal {
        System.out.print("c=" + $literal.text);
    } (COMMA rParams)?
    ;

// Rule body.
rBody
    : PATTERN {
        System.out.println("<pattern>");
    } ASSIGN multString[$PATTERN.text] {
        System.out.println($multString.trans);
    } SEMI {
        System.out.println("</pattern>");
    } rBody?
    | ruleAction {
        System.out.println("<action>" + $ruleAction.trans + "</action>");
    }
    ;

ruleAction returns [String trans = ""] 
        : instr { $trans += $instr.trans; } (ruleAction { $trans += $ruleAction.trans; })? 
        ;

// Instruction.
instr returns [String trans = ""]
    : CASE { $trans += "<choose>"; } (whenInstr {
        $trans += $whenInstr.trans;
    })+ otherwise? END { $trans += "</choose>"; }
    | {
        $trans += "<let>";
    } container ASSIGN value SEMI {
        $trans += $container.trans + $value.trans + "</let>";
    } (instr { $trans += $instr.trans; })?
    | ID {
        $trans += "<call-macro n=\"" + $ID.text + "\">";
    } LPAR callMacroParams {
        $trans += $callMacroParams.trans;
    } RPAR SEMI {        
        $trans += "</call-macro>";
    } (instr { $trans += $instr.trans; })?
    | container MODIFY_CASE stringValue {        
        $trans += "<modify-case>" + $container.trans + $stringValue.trans + "</modify-case>";
    } (instr { $trans += $instr.trans; })?
    | VAR APPEND ID {
        $trans += "<append n=\"" + $ID.text + "\">";
    } (value { $trans += $value.trans; })+ END {
        $trans += "</append>";
    } (instr { $trans += $instr.trans; })?
    | REJECT_CURRENT_RULE LPAR 'shifting' ASSIGN ('yes'|'no') RPAR SEMI
    | OUT {
        $trans += "<out>";
    } (mlu {
        $trans += $mlu.trans;
    } | lu {
        $trans += $lu.trans;
    } | b {
        $trans += $b.trans;
    } | chunk {
        $trans += $chunk.trans;
    } | ID {
        $trans += "<var n=\"" + $ID.text + "\"/>";
    } )+ END {
        $trans += "</out>";
    } (instr { $trans += $instr.trans; })?
    ;

callMacroParams returns [String trans = ""]
    : INT {
        $trans += "<with-param pos=\"" + $INT.text + "\"/>";
    } (COMMA callMacroParams {
        $trans += $callMacroParams.trans; 
    })?
    ;

container returns [String trans = ""]
    : (ID | clip {
        $trans += $clip.trans;
    }) 
    ;

value returns [String trans = ""]
    : (b {
        $trans += $b.trans;
    } | clip {
        $trans += $clip.trans;
    } | literal { 
        $trans += "<lit v=" + $literal.text + "/>";
    } | litTag {
        $trans += $litTag.trans;
    } | ID {
        $trans += "<var n=\"" + $ID.text + "\"/>";
    } | concat {
        $trans += $concat.trans;
    } | lu {
        $trans += $lu.trans;
    } | mlu {
        $trans += $mlu.trans;
    } | chunk {
        $trans += $chunk.trans;
    })
    ;

stringValue returns [String trans = ""]
    : (clip { 
        $trans += $clip.trans; 
    } | literal { 
        $trans += "<lit v=" + $literal.text + "/>"; 
    } | ID {
        $trans += "<var n=" + $ID.text + "/>";
    } )
    ;

b returns [String trans = ""]
    : 'b' {
        $trans += "<b";
    } (LPAR INT RPAR {
        $trans += " pos=\"" + $INT.text + "\"";
    })? SEMI {
        $trans += "/>";
    }
    ;

concat returns [String trans = ""]
    : CONCAT {
        $trans += "<concat>";
    } (value { 
        $trans += $value.trans;
    })+ END
    ;

lu returns [String trans = ""]
    : LU {
        $trans += "<lu>";
    } (value {
        $trans += $value.trans;
    } SEMI)+ END {
        $trans += "</lu>";
    }
    ;

mlu returns [String trans = ""]
    : MLU {
        $trans += "<mlu>";
    } lu+ {
        $trans += $lu.trans;
    } END {
        $trans += "</mlu>";
    }
    ;

chunk returns [String trans = ""]
    : CHUNK {
        $trans += "<chunk";
    } ID? {
        $trans += " name=\"" + $ID.text + "\"";
    } (LPAR chunkParams* RPAR)? {
        $trans += $chunkParams.trans + ">";
    } tags {
        $trans += $tags.trans;
    } ( mlu { $trans += $mlu.trans; } 
        | lu { $trans += $lu.trans; } 
        | b { $trans += $b.trans; } 
        | ID { $trans += "<var n=\"" + $ID.text + "\"/>"; } 
    )+ END {
        $trans += "</chunk>";
    }
    ;

chunkParams returns [String trans = ""]
    : param = (NAME_FROM|CASE|C) ASSIGN literal {
        $trans += " " + $param.text + "=" + $literal.text;
    }
    ;

tags returns [String trans = ""]
    : TAGS {
        $trans += "<tags>";
    } (value {
        $trans += "<tag>" + $value.trans + "</tag>";
    } SEMI)+ END {
        $trans += "</tags>";
    }
    ;

// When instruction.
whenInstr returns [String trans = ""]
    : WHEN {
        $trans += "<when><test>";
    } expr { 
        $trans += $expr.trans + "</test>";
    } THEN instr {
        $trans += $instr.trans;
    } 
    /*(ELSE {
        $trans += "<otherwise>";
    } instr {
        $trans += $instr.trans + "</otherwise>";
    })? */
    END {
        { $trans += "</when>"; }
    }
    ;

// Otherwise instruction.
otherwise returns [String trans = ""] 
    : OTHERWISE { $trans += "<otherwise>"; } instr { $trans += $instr.trans + "</otherwise>"; }
    ;

// Expression.

expr returns [String trans = ""]

    locals [
        String startTag = "",
        String endTag = ""
    ]
    
    : v1 = value NOT? (EQUAL { $startTag = "<equal>"; $endTag = "</equal>"; } | EQUAL_CASELESS { $startTag = "<equal caseless=\"yes\">"; $endTag = "</equal>"; }) v2 = value {
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += $startTag + $v1.trans + $v2.trans + $endTag;
        if(hasNot){
            $trans += "</not>";
        }
    } /* Recursion base case */
    | v1 = value NOT? (EQUAL { $startTag = "<equal>"; $endTag = "</equal>"; } | EQUAL_CASELESS { $startTag = "<equal caseless=\"yes\">"; $endTag = "</equal>"; }) v2 = value (c = (AND|OR) expr {
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += "<" + $c.text + ">" + $startTag + $v1.trans + $v2.trans + $endTag + "</" + $c.text + ">";
        if(hasNot){
            $trans += "</not>";
        }
    })?
    | value NOT? (IN { $startTag = "<in>"; $endTag = "</in>"; } | IN_CASELESS { $startTag = "<in caseless=\"yes\">"; $endTag = "</in>"; } | BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }) ID {
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += $startTag + $value.trans + "<var n=\"" + $ID.text + "\"/>" + $endTag;
        if(hasNot){
            $trans += "</not>";
        }        
    }                                                                                                                                               
    | value NOT? (IN { $startTag = "<in>"; $endTag = "</in>"; } | IN_CASELESS { $startTag = "<in caseless=\"yes\">"; $endTag = "</in>"; } | BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }) ID (c = (AND|OR) expr {
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += "<" + $c.text + ">" + $startTag + $value.trans + "<var n=\"" + $ID.text + "\"/>" + $endTag + "</" + $c.text + ">";
        if(hasNot){
            $trans += "</not>";
        }
    })?
    | v1 = value NOT? (BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }| CONTAINS_SUBSTR { $startTag = "<contains-substring>"; $endTag = "</contains-substring>"; } | CONTAINS_SUBSTR_CASELESS { $startTag = "<contains-substring caseless=\"yes\">"; $endTag = "</contains-substring>"; }) v2 = value {
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += $startTag + $v1.trans + $v2.trans + $endTag;
        if(hasNot){
            $trans += "</not>";
        }
    }
    | v1 = value NOT? (BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }| CONTAINS_SUBSTR { $startTag = "<contains-substring>"; $endTag = "</contains-substring>"; } | CONTAINS_SUBSTR_CASELESS { $startTag = "<contains-substring caseless=\"yes\">"; $endTag = "</contains-substring>"; }) v2 = value ( c = (AND|OR) expr{
        boolean hasNot = $NOT!=null && !$NOT.text.equals("");
        if(hasNot){
            $trans += "<not>";
        }
        $trans += "<" + $c.text + ">" + $startTag + $v1.trans + $v2.trans + $endTag + "</" + $c.text + ">";
        if(hasNot){
            $trans += "</not>";
        }
    })?
    ;

// Clip function.
clip returns [String trans = ""]
    : CLIP { 
        $trans += "<clip ";
    } LPAR clipParams RPAR {
        $trans += $clipParams.trans + "/>";
    }
    ;

// Clip function params.
clipParams returns [String trans = ""]
    : POS ASSIGN INT COMMA SIDE ASSIGN side COMMA PART ASSIGN literal {
        $trans += "pos=\"" + $INT.text + "\" side=" + $side.text + " part=" + $literal.text;
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
t returns [String trans = ""]
    : CATLEX {
        $trans += "def-cat";
    }
    | ATTR? {
        $trans += "def-attr";
    }
    | LIST? {
        $trans += "def-list";
    }
    ;

// Literal.
literal
    : StringLiteral
    ;

litTag returns [String trans = ""]
    : LTAG LPAR literal RPAR {
        $trans += "<lit-tag v=" + $literal.text + "/>";
    }
    ;

/**
 * Lexical specification.
 */

// Keywords.

TRANSFER                    : 'Transfer' ;
CATLEX                      : 'Catlex' ;
ATTR                        : 'Attribute' ;
LIST                        : 'List' ;
MACRO                       : 'Macro' ;
RULE                        : 'Rule' ;

// Attributres

N                           : 'n' ;
NPAR                        : 'npar' ;
C                           : 'c' ;
END                         : 'end' ;
POS                         : 'pos' ;
SIDE                        : 'side' ;
PART                        : 'part' ;
QUEUE                       : 'queue' ;
LINK_TO                     : 'link-to' ;
RCOMMENT                    : 'comment' ;
PATTERN                     : 'Pattern' ;
CONCAT                      : 'concat' ;
LU                          : 'lu' ;
MLU                         : 'mlu' ;
TAGS                        : 'tags' ;
NAME                        : 'name' ;
NAME_FROM                   : 'namefrom' ;

// Condition.

AND                         : 'and' ;
OR                          : 'or' ;
NOT                         : 'not' ;
EQUAL                       : 'equal' ;
EQUAL_CASELESS              : 'equalCaseless' ;
BEGINS_WITH                 : 'beginsWith' ;
BEGINS_WITH_CASELESS        : 'beginsWithCaseless' ;
ENDS_WITH                   : 'endsWith' ;
ENDS_WITH_CASELESS          : 'endsWithCaseless' ;
CONTAINS_SUBSTR             : 'containsSubstring' ;
CONTAINS_SUBSTR_CASELESS    : 'containsSubstringCaseless' ;
IN                          : 'in' ;
IN_CASELESS                 : 'inCaseless' ;

// Container, value, stringvalue

VAR                         : 'Var' ;
CLIP                        : 'clip' ;
LTAG                        : 'litTag' ;
CONCAT                      : 'concat' ;
LU                          : 'lu' ;
MLU                         : 'mlu' ;
CHUNK                       : 'Chunk' ;

// sentence

ASSIGN                      : '=' ;
OUT                         : 'out' ;
CASE                        : 'case' ;
MODIFY_CASE                 : 'modifyCase' ;
APPEND                      : 'append' ;
REJECT_CURRENT_RULE         : 'rejectCurrentRule' ;

// Separators.

LPAR                        : '(' ;
RPAR                        : ')' ;
SEMI                        : ';' ;
COMMA                       : ',' ;

// Others

WHEN                        : 'when' ;
THEN                        : 'then' ;
OTHERWISE                   : 'otherwise' ;

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
