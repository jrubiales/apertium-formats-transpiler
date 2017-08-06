# Apertium Formats Transpilers #

This repository provides some tools that arise aiming to design a simple text based format to write structural transfer rules and dictionaries. The provided tools consist of two transpilers which one of them is used to generate the translations between the transfer file formats and the other one to generate the translations between the dictionaries files, that is, exist one transpiler to convert from the actual format (XML) to the new format and vice versa both for  the Dictionaries files and Transfer files.

## Language Features ##

* High-Level language
* Easy to extend
* Fast and Efficient
* Portable compiler
* Semantic errors

## Transpilers ##

The name of the transpilers are Freya and Loki for the transfer files and dictionaries respectively.

Input                 | Transpiler     | Output
--------------------- | -------------- | -------------
XML Dictionary (.xml) | Loki           | Loki format (.lk)
Loki format (.lk)     | Loki           | XML Dictionary (.xml)
XML Transfer (.xml)   | Freya          | Freya format (.fy)
Freya format (.fy)    | Freya          | XML Transfer (.xml)

## Building from source ##

The project is developed using Netbeans IDE and Maven to manage it and simplify the use of third party dependencies.

## Using the transpilers ##

java -jar ApertiumFormatsTranspilers [Transpiler type] [File]  

Transpiler type:
  + loki: Transpile from XML to Loki format (filename.lk) or vice versa.
  + freya: Transpile from XML to Freya format (filename.fy) or vice versa.

File:  
  + If this argument is a XML file, the transpiler will convert from XML to Loki/Freya format. Otherwise it will covert from Loki/Freya format to XML.

The transpiler will detect the input file and will output the appropriate format automatically.

## Translations examples ##

### Dictionaries ###


```

<alphabet>·ÀÁÂÄÇÈÉÊËÌÍÎÏÑÒÓÔÖÙÚÛÜàáâäçèéêëìíîïñòóôöùúûüABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz</alphabet>

alphabet = "·ÀÁÂÄÇÈÉÊËÌÍÎÏÑÒÓÔÖÙÚÛÜàáâäçèéêëìíîïñòóôöùúûüABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz";

```

```
<sdefs>
  <sdef n="n" />
  <sdef n="GD" />
  <sdef n="det" />
</sdefs>

symbols = n, GD, det;
```

```
<section id="main" type="standard">

  <e r="LR">
    <p>
        <l>dog<s n="n"/></l>
        <r>gos<s n="n"/><s n="GD"/></r>
    </p>
  </e>

  <e r="RL">
      <p>
          <l>the<s n="det"/></l>
          <r>el<s n="det"/></r>
      </p>
  </e>

</section>

section main(type="standard")

  entry
    "dog" n > "gos" n GD";
  end /* end entry */

  entry
    "the" det < "e" det;
  end /* end entry */

end /* end section */
```

## Semantic errors ##
```

symbols = n, adj, ... , adj;

"Symbol adj is already defined (1:69)"
```

```
symbols = np;

section main(type ="standard")

  entry
          "dog" n < "gos" n ;
  end /* end entry */

end /* end section */

"Undefined symbol: n (6:18)"
"Undefined symbol: n (6:28)"
```