---
title: "Dokumentation: Auszeichnungen für TEI Editionen arabischer Manuskripte"
author:
	- Julia Dolhoff 
	- Till Grallert
date: 2017-11-06 10:22:16 +0200
---

<!-- # Besprechung benötigter Auszeichnungen für die digitale Edition der BI / BTS (26.10.2017) -->

# Generelle Anmerkungen:

- Word Datei liegt ohne Auszeichnungen vor
- Text später alles auf Arabisch (auch Fußnoten), nur Einleitung auf Englisch

# 1. Strukturelemente: block-level (z.B. Text, Paragraph, Gedicht)
## Einheiten im Text (einzelne Einträge) / Geschichten

Es bestehen grundsätzlich zwei verschiedene Möglichkeiten Sinneinheiten in einem Dokument zu modellieren: als Abschnitte innerhalb eines Textes oder als Kollation mehrere Texte in einem Dokument. Ersteres sollte einfach als `<div>` modelliert werden, letzteres lässt sich entweder mit `<floatingText>` oder `TEI/text/group/text` modellieren.

Beispiel 1:

```xml
<text>
	<body>
	<!-- Section on Alexander Pope starts -->
		<div>
		<!-- section on something completely different -->
		<floatingText>
			<text>
				<body>
					<div>
					</div>
				</body>
			</text>
		</floatingText>
		<!-- Section on Alexander Pope continues -->
		</div>
	</body>
</text>
```

Beispiel 3:

```xml
<text>
<!-- Section on Alexander Pope starts -->
	<front>
	<!-- biographical notice by editor -->
	</front>
	<group>
		<text>
		<!-- first poem -->
		</text>
		<text>
		<!-- second poem -->
		</text>
	</group>
</text>
```

+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/DS.html>
	
## Gedichte

Beispiel:

```xml
<text>
	<body>
		<head>My Alba</head>
		<lg>
			<l>Now that I've wasted</l>
			<l>five years in Manhattan</l>
			<l>life decaying</l>
			<l>talent a blank</l>
		</lg>
		<lg>
			<l>talking disconnected</l>
			<l>patient and mental</l>
			<l>sliderule and number</l>
			<l>machine on a desk</l>
		</lg>
	</body>
</text>
```
	
+ In arabischen Gedichten kommen oft Halbzeilen vor: `<seg>`

Beispiel:

```xml
<text>
	<body>
		<l type="bayt">
			<seg>Now that I've wasted</seg>
			<seg>five years in Manhattan</seg>
			<seg>life decaying</seg>
			<seg>talent a blank</seg>
		</l>
		<l>
			<seg>talking disconnected</seg>
			<seg>patient and mental</seg>
			<seg>sliderule and number</seg>
			<seg>machine on a desk</seg>
		</l>
	</body>
</text>
```


+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/VE.html>

## Tabellen
+ `<table>`
+ `<row>`
+ `<cell>`

Beispiel:

```xml
<table>
	<head>US State populations, 1990</head>
	<row role="label">
		<cell>state</cell>
		<cell>population</cell>
	</row>
	<row role="data">
		<cell>Wyoming</cell>
		<cell>453,588</cell>
	</row>
	<row role="data">
		<cell><placeName>Alaska</placeName></cell>
		<cell><num value="550043">550,043</num></cell>
	</row>
</table>
```

## Einschübe: `<floatingText>`
## Listen

Beispiel:

```xml
<list type="ordered">
	<item>a butcher</item>
	<item>a baker</item>
	<item>a candlestick maker, with
		<list type="bullets">
			<item>rings on his fingers</item>
			<item>bells on his toes</item>
		</list>
	</item>
</list>
```

+ Siehe: <http://web.uvic.ca/lancenrd/martin/guidelines/ref-list.html>

## Rechnungen (mit Ergebnis)

+ Zahlen: `<num>` können mit `@value` normalisiert werden.
+ Maße: `<measure>` und `<measureGrp>`
	* `<measure commodity="" unit="" quantity=""/>`


## 2. Strukturelemente: block level oder inline (z.B. Zitate, Auslassungen)
 	
## Zitate

+ 	Lexicography has shown little sign of being affected by the work of followers of J.R. Firth, probably best summarized in his slogan, `<quote>`You shall know a word by the company it keeps`</quote>`

	`<ref>`(Firth, 1957)`</ref>`

+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-quote.html>


## Koranverse

+ Könnten wir als Verse betrachten.

Beispiel:

```xml
<text>
	<front>
		<head>1755</head>
	</front>
	<body>
		<l>To make a prairie it takes a clover and one bee,</l>
		<l>One clover, and a bee,</l>
		<l>And revery.</l>
		<l>The revery alone will do,</l>
		<l>If bees are few.</l>
	</body>
</text>
```

+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/VE.html>

## Chronogram

+ Wir schlagen `<date>` vor. Datum kann dann mit `@when` und `@when-custom` normalisiert werden.

## Hadith

+ Bestandteile sind Überlieferungskette und Text.

# 2. Graphische Markierungen: inline (Überstriche, farbliche Hervorhebungen, Anführungszeichen)

## Überschriften

+ Das `<head>` Element wird für jede Art Überschrift verwendet
+ `<head place="margin">`Secunda conclusio`</head>`
+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-head.html>
	
## Überstriche

1. `<hi rendition="#apples"/>`, wie "apples" dann aussehen soll, wird woanders festgelegt; z.B. formalisiert im teiHeader mit `<rendition>` (<http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-rendition.html>).
2. `<hi rend="center"/>`, dann liegt keine maschinenlesbare Formalisierung vor.

## Seitenzahlen und Umbrüche 

Klassiserweise halten Herausgeber_innen Seitenzahlen als in eckigen Klammern fest, z.B. "[4b]" um Seite 4 verso anzugeben.

Beispiel:

```xml
	<body>
	<pb n="1" facs="page1.png"/>
	<!-- page1.png contains an image of the page;
    	the text it contains is encoded here -->
	<p>
	<!-- ... -->
	</p>
	<pb n="2" facs="page2.png"/>
	<!-- similarly, for page 2 -->
	<p>
	<!-- ... -->
	</p>
</body>
```

+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-pb.html>
	
## Gliedernde Querstriche
	+ Da Querstriche ein graphisches Element sind, könnten sie als `<graphic>` getaggt werden.

## Highlight (z.B. bei Überschriften oder farbig)
	+ `<hi rend="gothic">`And this Indenture further witnesseth`</hi>`
that the said `<hi rend="italic">`Walter Shandy`</hi>`, merchant,
in consideration of the said intended marriage ...
	+ indered a man's proceedings who `<hi rend="underline">`had obtained all the letters to Mr Boyd`</hi>`

	+ Beispiel @rendition:
	 
		```xml
			<head rendition="#ac #sc">
				<lb/>To The <lb/>Duchesse <lb/>of <lb/>Newcastle, <lb/>On Her<lb/>
				<hi rendition="#normal">New Blazing-World</hi>.
			</head>
			<!-- elsewhere... -->
			<rendition xml:id="sc" scheme="css">font-variant: small-caps</rendition>
			<rendition xml:id="normal" scheme="css">font-variant: normal</rendition>
			<rendition xml:id="ac" scheme="css">text-align: center</rendition>
			<rendition xml:id="red">color: red;</rendition>
		```
	
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-hi.html>
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-att.global.rendition.html>
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/HD.html>

## Fußnoten

	Beispiel:
	
		```xml
		<l>(Diff'rent our parties, but with equal grace</l>
		<l>The Goddess smiles on Whig and Tory race,</l>
		<l>
			<note type="imitation" place="bottom" anchored="false">
				<bibl>Virg. Æn. 10.</bibl>
				<quote>
					<l>Tros Rutulusve fuat; nullo discrimine habebo.</l>
					<l>—— Rex Jupiter omnibus idem.</l>
				</quote>
			</note>'Tis the same rope at sev'ral ends they twist,
		</l>
		```
	
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/SA.html>


## 3. Editorische Eingriffe

## Seiten fehlen: `<gap resp=""/>`
## Verbesserungen und Streichungen (meist: \<verbessert in> [ursprünglich])
	+ Streichungen

	Beispiel:
	
		```xml
		<l>
			<del rend="overtyped">Mein</del> Frisch
			<del rend="overstrike" type="primary">schwebt</del> weht der Wind
		</l>
		```
	
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-del.html>
	+ Hinzufügungen: `<add>`

	Beispiel:
	
		```xml
		<l>
			<del rend="overtyped">Mein</del> <add>Frisch</add>
			<del rend="overstrike" type="primary">schwebt</del> <add>weht</add> der Wind
		</l>
		```

	+ Beides zusammen lässt sich noch in ein `<choice>` element verpacken.

	Beispiel:
	
		```xml
		<l>
			<del rend="overtyped">Mein</del> <add>Frisch</add>
			<choice><del rend="overstrike" type="primary">schwebt</del> <add>weht</add></choice> der Wind
		</l>
		```

## 4. Named entities: Daten, Namen, Personen, Orte

## Datum als Datum markieren (egal ob Chronogram)
	+ `<date when="1807-06-09">`June 9th`</date>`
	+ `<residence from="1856-03" to="1858-04">`From sometime in March of
 1856 to sometime in April of 1858.`</residence>`
 	+ `<birth notBefore="1857-03-01"
 notAfter="1857-04-30">`Some time in
 March or April of 1857.`</birth>`
 	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html>
 	+ Für nicht-gregorianische Kalender siehe die Dokumentation von [OpenArabicPE](https://www.github.com/openarabicpe) bzw. [Digital Muqtabas](https://www.github.com/tillgraller/digital-muqtabas)

## Personen
	+ That silly man
`<name role="politician" type="person">`David Paul Brown`</name>` has suffered ...
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html> 

## Orte (auch Regionen usw.)
	+ I never fly from `<name key="LHR" type="place">`Heathrow Airport`</name>`
to
<name key="FR" type="place">France</name>
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html> 

## Namen
	+ `<persName>`
	+ `<surname>`
	+ `<forename>`
	+ `<roleName>`
	+ `<addName>`
	+ `<nameLink>`
	+ `<genName>`
	
	Bsp:
	
		```xml
		<persName>
			<forename type="first">Franklin</forename>
			<forename type="middle">Delano</forename>
			<surname>Roosevelt</surname>
		</persName>
		```
	 
	+ Siehe: <http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html>
	
## Gruppen von Leuten (z.B. Wenn oft Leute auf dem Markt)
	+ `<orgName>`

