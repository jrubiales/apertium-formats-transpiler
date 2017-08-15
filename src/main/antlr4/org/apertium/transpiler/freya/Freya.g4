grammar Freya;

/**
 * Syntactic specification.
 */

stat

    /* List of symbols defined */
    locals [
	List<Symbol> symbols = new ArrayList<Symbol>(),
        List<String> errs = new ArrayList<String>()
    ]

    :
    {
        System.out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    } transfer EOF {
        if($errs.size() > 0){
            System.out.println("\n");
            System.out.println("#########################");
            System.out.println("Detected errors:");
            System.out.println("----------------");
            $errs.forEach((e) -> {
                System.err.println(e);
            });
            System.out.println("#########################");
        }
    }
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
        
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.CATLEX));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.ATTR));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.VAR));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
        System.out.print("n=\"" + $ID.text + "\"");

    } | ID ASSIGN {
        
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.VAR));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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

        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.LIST));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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

        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.MACRO));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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
    }
    ;

macroContent
    : instr+
    ;

instr
    : CHOOSE {
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
        
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }    
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

        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
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

        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        } 
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
        System.out.print("<rule>");
    } 

    /* LPAR ruleParams RPAR {
        System.out.print(">");
    } */
    
    ruleBody END {
        System.out.print("</rule>");
    }
    ;

// Rule params.
/*
ruleParams
    : RCOMMENT ASSIGN literal {
        System.out.print("comment=" + $literal.text);
    } (COMMA ruleParams)?
    | C ASSIGN literal {
        System.out.print(" " + "c=" + $literal.text);
    } (COMMA ruleParams)?
    ;
*/

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
    : ID {
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        System.out.print("<pattern-item n=\"" + $ID.text + "\" />");
    } COMMA?
    ;

// Rule action.
action
    : {
        System.out.print("<action>");
    } instr* {
        System.out.print("</action>");
    }
    ;

container
    : ID {
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        } 
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
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::symbols.add(new Symbol($ID.text, Type.CHUNK));
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += "<var n=\"" + $ID.text + "\"/>";
    })+ END {
        $trans += "</chunk>";
    }
    ;

chunkParams returns [String trans = ""]
    : param = (NAME_FROM|CASE) ASSIGN literal {
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
    } THEN instr+ END {
        System.out.print("</when>");
    }
    ;

// Otherwise instruction.
otherwise
    : OTHERWISE {
        System.out.print("<otherwise>");
    } instr+ END {
        System.out.print("</otherwise>");
    }
    ;

// Expression. 
// Es necesario devolver un string para generar la traducción correctamente.
// Ej. value equal value => <equal><value><value></equal>
expr returns [String trans = ""]
    : e1 = simpleExpr compop e2 = simpleExpr {

        $trans += "<" + $compop.tagName;    
        if($compop.caseless){
            $trans += " caseless=\"yes\"";
        }
        $trans += ">" + $e1.trans + $e2.trans + "</" + $compop.tagName + ">";
    
    } | simpleExpr {
        $trans += $simpleExpr.trans;
    }
    ;

// Simple expression.
simpleExpr returns [String trans = ""]
    : se1 = simpleExpr OR term {
        $trans += "<or>" + $se1.trans + $term.trans + "</or>";
    } | term {
        $trans += $term.trans;
    }
    ;

// Term.
term returns [String trans = ""]
    : t1 = term AND factor {
        $trans += "<and>" + $t1.trans + $factor.trans + "</and>";
    } | factor {
        $trans += $factor.trans;
    }
    ;

// Factor.
factor returns [String trans = ""]
    : ID {
        
        Symbol searchSymbol = new Symbol($ID.text);
        if(!$stat::symbols.contains(searchSymbol)){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        } else {
            Symbol s = searchSymbol.search($stat::symbols);
            // Var or list.
            if(s.getType() == Type.VAR){
                $trans += "<var";
            } else if(s.getType() == Type.LIST){
                $trans += "<list";
            }
            $trans += " n=\"" + $ID.text + "\"/>";
        }
        
    } | LPAR expr RPAR {
        $trans += $expr.trans;
    } | NOT f1 = factor {
        $trans += "<not>" + $f1.trans + "</not>";
    } | value {
        $trans += $value.trans;
    }
    ;

// Relational operators
relop returns [String tagName = "", boolean caseless = false]
    : EQUAL {
        $tagName += "equal";
    } | EQUAL_CASELESS {
        $tagName += "equal";
        $caseless = true;
    }
    ;

// Comparison operators
compop returns [String tagName = "", boolean caseless = false]
    : relop {
        $tagName = $relop.tagName;
        $caseless = $relop.caseless;
    } | BEGINS_WITH {
        $tagName = "begins-with";
    } | BEGINS_WITH_CASELESS {
        $tagName = "begins-with";
        $caseless = true;
    } | ENDS_WITH {
        $tagName = "ends-with";
    } | ENDS_WITH_CASELESS {
        $tagName = "ends-with";
        $caseless = true;
    } | CONTAINS_SUBSTR {
        $tagName = "contains-substring";
    } | CONTAINS_SUBSTR_CASELESS {
        $tagName = "contains-substring";
        $caseless = true;
    } | IN {
        $tagName = "in";
    } | IN_CASELESS {
        $tagName = "in";
        $caseless = true;
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
    : POS ASSIGN INT {
        $trans += "pos=\"" + $INT.text + "\"";
    } COMMA SIDE ASSIGN side {
        $trans += " side=" + $side.text + "";
    } COMMA PART ASSIGN {
        $trans += " part=";
    } (ID {    
        if(!$stat::symbols.contains(new Symbol($ID.text))){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += "\"" + $ID.text + "\"";
    } | part = ('"lem"' | '"lemh"' | '"lemq"' | '"whole"' ){                
        $trans += $part.text;
    }) (COMMA clipParam = (QUEUE|LINK_TO) ASSIGN literal{
        $trans += " " + $clipParam.text + "=" + $literal.text;
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

TRANSFER                    : 'transfer' ;
CATLEX                      : 'catlex' ;
ATTR                        : 'attribute' ;
LIST                        : 'list' ;
MACRO                       : 'macro' ;
RULE                        : 'rule' ;
END                         : 'end' ;
PATTERN                     : 'pattern' ;
TAGS                        : 'tags' ;

// Attributres

NPAR                        : 'npar' ;
POS                         : 'pos' ;
SIDE                        : 'side' ;
PART                        : 'part' ;
QUEUE                       : 'queue' ;
LINK_TO                     : 'link-to' ;

NAME                        : 'name' ;
NAME_FROM                   : 'namefrom' ;
CASE                        : 'case' ;

AND                         : 'and' ;
OR                          : 'or' ;
NOT                         : 'not' ;

EQUAL                       : '==' ;
EQUAL_CASELESS              : '===' ;

BEGINS_WITH                 : 'beginsWith' ;
BEGINS_WITH_CASELESS        : 'beginsWithCaseless' ;
ENDS_WITH                   : 'endsWith' ;
ENDS_WITH_CASELESS          : 'endsWithCaseless' ;
CONTAINS_SUBSTR             : 'containsSubstring' ;
CONTAINS_SUBSTR_CASELESS    : 'containsSubstringCaseless' ;
IN                          : 'in' ;
IN_CASELESS                 : 'inCaseless' ;

// Container, value, stringvalue

VAR                         : 'var' ;
CLIP                        : 'clip' ;
LTAG                        : 'litTag' ;
CONCAT                      : 'concat' ;
LU                          : 'lu' ;
MLU                         : 'mlu' ;
CHUNK                       : 'chunk' ;

// sentence

ASSIGN                      : '=' ;
OUT                         : 'out' ;
CHOOSE                      : 'choose' ;
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

ID                          : [a-zA-Z_/][a-zA-Z0-9_/]* ;
INT                         : [0-9]+ ;

// String Literals.

STRING                      : '"' ('\\"' | ~'"')* '"' ;

// Whitespace and comments.

WS                          :  [ \t\r\n\u000C]+ -> skip ;

COMMENT                     :   '/*' .*? '*/' -> skip ;

LINE_COMMENT                :   '//' ~[\r\n]* -> skip ;