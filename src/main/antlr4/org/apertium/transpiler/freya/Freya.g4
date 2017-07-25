grammar Freya;

/**
 * Syntactic specification.
 */

stat
    :
    {
        System.out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    } transfer EOF
    ;

// Root element containing the whole structural transfer rule file.
transfer
    :
    TRANSFER {
        System.out.print("<transfer ");
    } LPAR 'default' {
        System.out.print("default");
    } ASSIGN {
        System.out.print($ASSIGN.text);
    } defaultAttr = ('"lu"' | '"chunk"') {
        System.out.print($defaultAttr.text);
    } RPAR {
        System.out.print(">");
    } transferBody END {
        System.out.print("</transfer>");
    }
    ;

// Transfer body.
transferBody
    : sectionDefCats sectionDefAttrs? sectionDefVars? sectionDefLists? sectionDefMacros? sectionRules
    ;

sectionDefCats
    : {
        System.out.print("<section-def-cats>");
    } defCat+ {
        System.out.print("</section-def-cats>");
    }
    ;

defCat
    : CATLEX {
        System.out.print("<def-cat ");
    } ID {
        System.out.print("n=\"" + $ID.text + "\">");
    } ASSIGN catitem+ SEMI {
        System.out.print("</def-cat>");
    }
    ;

catitem
    : literal {
        String[] tokens = $literal.text.split(",");
        System.out.print("<cat-item ");
        if(tokens.length == 1){
            System.out.print("tags=" + tokens[0]);
        } else if(tokens.length > 1){
            System.out.print("lemma=" + tokens[0] + "\" tags=\"" + tokens[1]);
        }
        System.out.print("/>");
    } COMMA?
    ;

sectionDefAttrs
    : {
        System.out.print("<section-def-attrs>");
    } defAttr+ {
        System.out.print("</section-def-attrs>");
    }
    ;

defAttr
    : ATTR {
        System.out.print("<def-attr ");
    } ID {
        System.out.print("n=\"" + $ID.text + "\">");
    } ASSIGN attrItem+ SEMI {
        System.out.print("</def-attr>");
    }
    ;

attrItem
    : literal {
        System.out.print("<attr-item tags=" + $literal.text + "/>");
    } COMMA?
    ;

sectionDefVars
    : {
        System.out.print("<section-def-vars>");
    } defVar+ {
        System.out.print("</section-def-vars>");
    }
    ;

defVar
    : VAR ({
        System.out.print("<def-var ");
    }(ID {
        System.out.print("n=\"" + $ID.text + "\"");
    } | ID ASSIGN {
        System.out.print("n=\"" + $ID.text + "\"");
    } literal {
        System.out.print(" v=" + $literal.text + "");
    }) COMMA?)+ SEMI { System.out.print("/>"); }
    ;

sectionDefLists
    : {
        System.out.print("<section-def-lists>");
    } defList+ {
        System.out.print("</section-def-lists>");
    }
    ;

defList
    : LIST {
        System.out.print("<def-list ");
    } ID {
        System.out.print("n=\"" + $ID.text + "\">");
    } ASSIGN listItem+ SEMI {
        System.out.print("</def-list>");
    }
    ;

listItem
    : literal {
        System.out.print("<list-item v=" + $literal.text + "/>");
    } COMMA?
    ;

sectionDefMacros
    : defMacro+
    ;

defMacro
    : MACRO {
        System.out.print("<def-macro ");
    } ID {
        System.out.print("n=\"" + $ID.text + "\" ");
    } LPAR macroParams RPAR {
        System.out.print(">");
    }  macroContent END {
        System.out.print("</def-macro>");
    }
    ;

macroParams
    : NPAR ASSIGN INT {
        System.out.print($NPAR.text + "=\"" + $INT.text + "\"");
    }(C ASSIGN literal{
        System.out.print(" " + $C.text + "=" + $literal.text);
    })?
    ;

macroContent
    : sentence+
    ;

sentence
    : CASE {
        System.out.print("<choose>");
    } whenInstr+ otherwise? END {
        System.out.print("</choose>");
    }
    | {
        System.out.print("<let>");
    } container ASSIGN value {
        System.out.print($value.trans);
    } SEMI {
        System.out.print("</let>");
    }
    | ID {
        System.out.print("<call-macro n=\"" + $ID.text + "\">");
    } LPAR callMacroParams RPAR SEMI {
        System.out.print("</call-macro>");
    }
    | container MODIFY_CASE {
        System.out.print("<modify-case>");
    } stringValue {
        System.out.print("</modify-case>");
    }
    | ID APPEND {
        System.out.print("<append n=\"" + $ID.text + "\">");
    } (value { System.out.print($value.trans); } APPEND?)+ SEMI {
        System.out.print("</append>");
    }
    | REJECT_CURRENT_RULE LPAR 'shifting' ASSIGN ('yes'|'no') RPAR SEMI
    | OUT {
        System.out.print("<out>");
    } (mlu {
        System.out.print($mlu.trans);
    } | lu {
        System.out.print($lu.trans);
    } | b {
        System.out.print($b.trans);
    } | chunk {
        System.out.print($chunk.trans);
    } | ID {
        System.out.print("<var n=\"" + $ID.text + "\"/>");
    })+ END {
        System.out.print("</out>");
    }
    ;

sectionRules
    : { System.out.print("<section-rules>"); } r+ { System.out.print("</section-rules>"); }
    ;

// Rule.
r
    : RULE {
        System.out.print("<rule ");
    } LPAR ruleParams RPAR {
        System.out.print(">");
    } ruleBody END {
        System.out.print("</rule>");
    }
    ;

// Rule params.
ruleParams
    : RCOMMENT ASSIGN literal {
        System.out.print("comment=" + $literal.text);
    } (COMMA ruleParams)?
    | C ASSIGN literal {
        System.out.print(" " + "c=" + $literal.text);
    } (COMMA ruleParams)?
    ;

// Rule body.
ruleBody
    : pattern action
    ;

// Rule pattern.
pattern
    : PATTERN {
        System.out.print("<pattern>");
    } ASSIGN patternItem+ SEMI {
        System.out.print("</pattern>");
    }
    ;

// Pattern item.
patternItem
    : literal {
        System.out.print("<pattern-item n=" + $literal.text + " />");
    } COMMA?
    ;

// Rule action.
action
    : {
        System.out.print("<action>");
    } sentence* {
        System.out.print("</action>");
    }
    ;

container
    : ID {
        System.out.print("<var n=\"" + $ID.text + "\" />");
    }
    | clip {
        System.out.print($clip.trans);
    }
    ;

value returns [String trans = ""]
    : (b {
        $trans += $b.trans;
    } | clip {
        $trans += $clip.trans;
    } | literal {
        $trans += "<lit v=" + $literal.text + " />";
    } | litTag {
        $trans += $litTag.trans;
    } | ID {
        $trans += "<var n=\"" + $ID.text + "\" />";
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

stringValue
    : (clip {
        System.out.print($clip.trans);
    } | literal {
        System.out.print("<lit v=" + $literal.text + "/>");
    } | ID {
        System.out.print("<var n=" + $ID.text + "/>");
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
    } (value SEMI)+ {
        $trans += $value.trans;
    } END {
        $trans += "</concat>";
    }
    ;

lu returns [String trans = ""]
    : LU {
        $trans += "<lu>";
    } (value SEMI {
        $trans += $value.trans;
    })+ END {
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
    } (ID {
        $trans += " name=\"" + $ID.text + "\"";
    })? (LPAR chunkParams* {
        $trans += $chunkParams.trans;
    } RPAR)? {
        $trans += ">";
    } tags {
        $trans += $tags.trans;
    } (mlu {
        $trans += $mlu.trans;
    } | lu {
        $trans += $lu.trans;
    } | b {
        $trans += $b.trans;
    } | ID {
        $trans += "<var n=\"" + $ID.text + "\"/>";
    })+ END {
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
    } ({
        $trans += "<tag>";
    } value {
        $trans += $value.trans;
    } SEMI {
        $trans += "</tag>";
    })+ END {
        $trans += "</tags>";
    }
    ;

// When instruction.
whenInstr
    : WHEN {
        System.out.print("<when><test>");
    } expr {
        System.out.print($expr.trans);
        System.out.print("</test>");
    } THEN sentence+ END {
        System.out.print("</when>");
    }
    ;

// Otherwise instruction.
otherwise
    : OTHERWISE {
        System.out.print("<otherwise>");
    } sentence+ END {
        System.out.print("</otherwise>");
    }
    ;

// Expression. 
// Es necesario devolver un string para generar la traducción correctamente.
// Ej. value equal value => <equal><value><value></equal>
expr returns [String trans = ""]

    locals [
        String startTag = "",
        String endTag = "",
        String startNot = "",
        String endNot = "",
    ]

    : v1 = value (NOT { 
        $startNot="<not>"; $endNot = "</not>"; 
    })? (EQUAL { 
        $startTag = "<equal>"; $endTag = "</equal>"; 
    } | EQUAL_CASELESS { 
        $startTag = "<equal caseless=\"yes\">"; $endTag = "</equal>"; 
    }) v2 = value {
        $trans = $startNot + $startTag + $v1.trans + $v2.trans + $endTag + $endNot ;
    }
    | v1 = value (NOT { $startNot="<not>"; $endNot = "</not>"; })? (EQUAL { $startTag = "<equal>"; $endTag = "</equal>"; } | EQUAL_CASELESS { $startTag = "<equal caseless=\"yes\">"; $endTag = "</equal>"; }) v2 = value c = (AND|OR) expr {
        $trans = "<" + $c.text + ">" + $startNot + $startTag + $v1.trans + $v2.trans + $endTag + $endNot + $expr.trans + "</" + $c.text + ">";
    }
    | value (NOT { $startNot="<not>"; $endNot = "</not>"; })? (IN { $startTag = "<in>"; $endTag = "</in>"; } | IN_CASELESS { $startTag = "<in caseless=\"yes\">"; $endTag = "</in>"; } | BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }) ID {
        $trans = $startNot + $startTag + $value.trans + "<var n=\"" + $ID.text + "\"/>" + $endTag + $endNot;
    }
    | value (NOT { $startNot="<not>"; $endNot = "</not>"; })? (IN { $startTag = "<in>"; $endTag = "</in>"; } | IN_CASELESS { $startTag = "<in caseless=\"yes\">"; $endTag = "</in>"; } | BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }) ID c = (AND|OR) expr {
        $trans = "<" + $c.text + ">" + $startNot + $startTag + $value.trans + "<var n=\"" + $ID.text + "\"/>" + $endTag + $endNot + $expr.trans + "</" + $c.text + ">";
    }
    | v1 = value (NOT { $startNot="<not>"; $endNot = "</not>"; })? (BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }| CONTAINS_SUBSTR { $startTag = "<contains-substring>"; $endTag = "</contains-substring>"; } | CONTAINS_SUBSTR_CASELESS { $startTag = "<contains-substring caseless=\"yes\">"; $endTag = "</contains-substring>"; }) v2 = value {
        $trans = $startNot + $startTag + $v1.trans + $v2.trans + $endTag + $endNot;
    }
    | v1 = value (NOT { $startNot="<not>"; $endNot = "</not>"; })? (BEGINS_WITH { $startTag = "<begins-with>"; $endTag = "</begins-with>"; } | BEGINS_WITH_CASELESS { $startTag = "<begins-with caseless=\"yes\">"; $endTag = "</begins-with>"; } | ENDS_WITH { $startTag = "<ends-with>"; $endTag = "</ends-with>"; } | ENDS_WITH_CASELESS { $startTag = "<ends-with caseless=\"yes\">"; $endTag = "</ends-with>"; }| CONTAINS_SUBSTR { $startTag = "<contains-substring>"; $endTag = "</contains-substring>"; } | CONTAINS_SUBSTR_CASELESS { $startTag = "<contains-substring caseless=\"yes\">"; $endTag = "</contains-substring>"; }) v2 = value c = (AND|OR) expr{
        $trans = "<" + $c.text + ">" + $startNot + $startTag + $v1.trans + $v2.trans + $endTag + $endNot + $expr.trans + "</" + $c.text + ">";
    }
    ;

// Clip function.
clip returns [String trans = ""]
    : CLIP {
        $trans = "<clip ";
    } LPAR clipParams {
        $trans += $clipParams.trans;
    } RPAR {
        $trans += " />";
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

callMacroParams
    : INT {
        System.out.print("<with-param pos=\"" + $INT.text + "\" />");
    } (COMMA callMacroParams)?
    ;

// Literal.
literal
    : STRING
    ;

litTag returns [String trans = ""]
    : LTAG LPAR literal RPAR {
        $trans = "<lit-tag v=" + $literal.text + "/>";
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
END                         : 'end' ;
PATTERN                     : 'Pattern' ;
TAGS                        : 'tags' ;

// Tags Attributres

N                           : 'n' ;
NPAR                        : 'npar' ;
C                           : 'c' ;
POS                         : 'pos' ;
SIDE                        : 'side' ;
PART                        : 'part' ;
QUEUE                       : 'queue' ;
LINK_TO                     : 'link-to' ;
RCOMMENT                    : 'comment' ;


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

STRING                      : '"' ('\\"' | ~'"')* '"' ;

// Whitespace and comments.

WS                          :  [ \t\r\n\u000C]+ -> skip ;

COMMENT                     :   '/*' .*? '*/' -> skip ;

LINE_COMMENT                :   '//' ~[\r\n]* -> skip ;