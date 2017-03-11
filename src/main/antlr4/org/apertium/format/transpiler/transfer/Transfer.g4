grammar Transfer;

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

T : CATLEX;

/* Tokens */

INT : [0-9]+ ;

ID : [a-z][a-z0-9]* ;

CATLEX : 'catlex' ;

SEMICOLON : ';' ;

WS : [ \r\t\n]+ -> skip;

ASSIGNOP : '=' ;

STRING : '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\'' ;

ESC_SEQ : '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
        | UNICODE_ESC
        | OCTAL_ESC 
;

OCTAL_ESC : '\\' ('0'..'3') ('0'..'7') ('0'..'7')
          | '\\' ('0'..'7') ('0'..'7')
          | '\\' ('0'..'7')
;

UNICODE_ESC : '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;

HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

COMMENT : '/*' .*? '*/' -> skip ;

LINE_COMMENT : '//' ~[\r\n]* -> skip ;