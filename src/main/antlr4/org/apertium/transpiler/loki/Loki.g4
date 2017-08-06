grammar Loki;

/**
 * Syntactic specification.
 */

stat
        
    /* List of symbols defined */
    locals [
	List<String> symbols = new ArrayList<String>(),
        List<String> errs = new ArrayList<String>()
    ]
    
    :
    {
        System.out.print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        System.out.print("<dictionary>");
    } alphabet? sdefs? pardefs? section+ {
        System.out.print("</dictionary>");
    } EOF {
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

alphabet
    : ALPHABET {
        System.out.print("<alphabet>");
    } ASSIGN literal {
        System.out.print($literal.text.replaceAll("\"", ""));
    } SEMI {
        System.out.print("</alphabet>");
    }
    ;

sdefs
    : SYMBOLS { System.out.print("<sdefs>"); } ASSIGN sdef+ SEMI { System.out.print("</sdefs>"); }
    ;

sdef
    : { System.out.print("<sdef n=\""); } ID { 
        if(!$stat::symbols.contains($ID.text)){
            $stat::symbols.add($ID.text);
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
        System.out.print($ID.text + "\" />");  
    } COMMA?
    ;

pardefs
    : { System.out.print("<pardefs>"); } pardef+ { System.out.print("</pardefs>"); }
    ;

pardef
    : PARDEF {
        System.out.print("<pardef");
    } ID {
        if(!$stat::symbols.contains($ID.text)){
            $stat::symbols.add($ID.text);
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
        System.out.print(" n=\"" + $ID.text + "\">");
    } e+ END {
        System.out.print("</pardef>");
    }
    ;

section
    : SECTION {
        System.out.print("<section");
    } ID {
        if(!$stat::symbols.contains($ID.text)){
            $stat::symbols.add($ID.text);
        } else {
            $stat::errs.add("Symbol " + $ID.text + " is already defined (" + $ID.line + ":" + $ID.pos + ")");
        }
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
        if($p.rAttr != null && !$p.rAttr.equals("")){
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
    : IDENTITY { $trans += "<i>"; } ASSIGN (literal {
               
        if($literal.text.equals(" ")){
            $trans += "<b/>";
        } else {
            String result = $literal.text;
            result = result.replaceAll("\"", "");
            result = result.replaceAll(" ", "<b/>");
            $trans += result;
        }

    } | ID {
        $trans += "<s n=\"" + $ID.text + "\"/>";
    } | g {
        $trans += $g.trans;
    } | j {
        $trans += $j.trans;
    } | a {
        $trans += $a.trans;
    })* SEMI { $trans += "</i>"; }
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
    : { 
        $trans += "<l>";
    } (literal {
        
        if($literal.text.equals(" ")){
            $trans += "<b/>";
        } else {
            String result = $literal.text;
            result = result.replaceAll("\"", "");
            result = result.replaceAll(" ", "<b/>");
            $trans += result;
        }

    } | a {
        $trans += $a.trans;
    } | g {
        $trans += $g.trans;
    } | j {
        $trans += $j.trans;
    } | ID {
        if(!$stat::symbols.contains($ID.text)){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += "<s n=\"" + $ID.text + "\"/>";
    })* {
        $trans += "</l>";
    }
    ;

r returns [String trans = ""]
    : { 
        $trans += "<r>";
    } (literal {
        
        if($literal.text.equals(" ")){
            $trans += "<b/>";
        } else {
            String result = $literal.text;
            result = result.replaceAll("\"", "");
            result = result.replaceAll(" ", "<b/>");
            $trans += result;
        }

    } | a {
        $trans += $a.trans;
    } | g {
        $trans += $g.trans;
    } | j {
        $trans += $j.trans;
    } | ID {
        if(!$stat::symbols.contains($ID.text)){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += "<s n=\"" + $ID.text + "\"/>";
    })* {
        $trans += "</r>";
    }
    ;

a returns [String trans = ""]
    : A_MARK {
        $trans += "<a/>";
    }
    ;

j returns [String trans = ""]
    : JOIN {
        $trans += "<j/>";
    }
    ;

g returns [String trans = ""]
    : LPAR {
        $trans += "<g>";
    } (literal {
        
        if($literal.text.equals(" ")){
            $trans += "<b/>";
        } else {
            String result = $literal.text;
            result = result.replaceAll("\"", "");
            result = result.replaceAll(" ", "<b/>");
            $trans += result;
        }

    } | a {
        $trans += $a.trans;
    } | j {
        $trans += $j.trans;
    } | ID {
        if(!$stat::symbols.contains($ID.text)){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += "<s n=\"" + $ID.text + "\"/>";
    })* RPAR {
        $trans += "</g>";
    }
    ;

par returns [String trans = ""]
    : PREF { 
        $trans += "<par"; 
    } ASSIGN ID { 
        if(!$stat::symbols.contains($ID.text)){
            $stat::errs.add("Undefined symbol: " + $ID.text + " (" + $ID.line + ":" + $ID.pos + ")");
        }
        $trans += " n=\"" + $ID.text + "\""; 
    } SEMI { 
        $trans += "/>"; 
    }
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

JOIN                        : '_j';
A_MARK                      : '_a';

// Operators

CONCAT                      : '+' ;

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