grammar Loki;

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
    locals [
        String trans = "";
    ]
    : ENTRY { 
        System.out.print("<e"); 
    } (LPAR (att = ('r' | 'lm' | 'a' | 'c' | 'i' | 'slr' | 'srl' | 'alt' | 'v' | 'vl' | 'vr' ) ASSIGN literal)* {
        
        System.out.print(" ");
        System.out.print($att.text);
        System.out.print("=");

        if($att.text.equals("l")){

            if($literal.text.equals("LR") || $literal.text.equals("RL")){
                System.out.print($literal.text);
            } else {
                // Error.
            }

        } else {
            System.out.print($literal.text);
        }

    } RPAR)? (i {
        $trans += $i.trans;
    } | p {
        if(!$p.rAttr.equals("")){
            System.out.print(" r=\"" + $p.rAttr + "\"");
        }
        $trans += $p.trans;
    } | par {
        $trans += $par.trans;
    } | re {
        $trans += $re.trans;
    })+ END {
        System.out.print(">");
        System.out.print($trans);
        System.out.print("</e>"); 
    }
    ;

i returns [String trans = ""]
    : IDENTITY { $trans += "<i>"; } ASSIGN literal {
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
        $trans += result;
    } SEMI { $trans += "</i>"; }
    ;

p returns [String trans = "", String rAttr = ""]
    : { $trans += "<p>"; } l { $trans += $l.trans; } (op = ('<' | '>' | '<>') { 
        if($op.text.equals(">")){
            $rAttr = "LR"; 
        } else if($op.text.equals("<")) {
            $rAttr = "RL";
        }
    }) r { $trans += $r.trans; } SEMI { $trans += "</p>"; }
    ;

l returns [String trans = ""]
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
        $trans += "<l>" + result + "</l>";
    }
    ;

r returns [String trans = ""]
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
        $trans += "<r>" + result + "</r>";
    }
    ;

par returns [String trans = ""]
    : PREF { $trans += "<par"; } ASSIGN literal { $trans += " n=" + $literal.text; } SEMI { $trans += "/>"; }
    ;

re returns [String trans = ""]
    : RE { $trans += "<re>"; } ASSIGN literal { $trans += $literal.text.replaceAll("\"", ""); } SEMI { $trans += "</re>"; }
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