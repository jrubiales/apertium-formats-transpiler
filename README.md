Apertium Formats Transpilers
============================

Este repositorio proporciona unas herramientas que surgen con el objetivo de diseñar un lenguaje de texto sencillo para las reglas de transferencia estructural y los diccionarios. Las herramientas proporcionadas constan de 4 transpiladores de los cuales 2 sirven para generar las traducciones entre formatos de los diccionarios y los otros 2 restantes para generar las traducciones entre formatos de los ficheros transfer, es decir existe un transpilador para generar la traducción del actual formato (xml) al nuevo formato propuesto y otro para realizar el proceso contrario tanto para los diccionarios como para los ficheros transfer.

XML Dix -> [XML2MorphDix] -> Nuevo formato  
Nuevo formato -> [MorphDix2XML] -> XML Dix    

XML Transfer -> [XML2MorphTrans] -> Nuevo formato  
Nuevo formato -> [MorphTrans2XML] -> XML Transfer
