---
title: "Ediarum@OIB"
author: Till Grallert
date: 2018-11-28 09:50:05 +0200
---

# Components and installation

1. Download and installation of [oXygen XML editor](https://www.oxygenxml.com/download_oxygenxml_editor.html)
2. Download and installation of [eXistDB](https://exist-db.org/)
3. Download of the latest stable version of [ediarum](https://github.com/ediarum) and its components:
    1. [ediarum.DB](https://github.com/ediarum/ediarum.DB)
    2. [ediarum.BASE.edit](https://github.com/ediarum/ediarum.BASE.edit)
    3. [ediarum.REGISTER.edit](https://github.com/ediarum/ediarum.REGISTER.edit)
    4. [ediarum.JAR](https://github.com/ediarum/ediarum.JAR): this is the basic component of and included in "ediarum.BASE.edit" and "ediarum.REGISTER.edit"
 
## 1. [oXygen XML editor](https://www.oxygenxml.com/download_oxygenxml_editor.html)

- tested with:
    + v19.1
    + v20.1
    
### v20.1

It is important to change the standard font settings for the Editor and the "Author" view to some font that supports Arabic script. Somehow standard Unicode fonts do not work! Since version 15, I used Helvetica Neue (13) for the Editor and Gentium Plus (14) for the Author view. Neither works with Arabic in v20.1. 

I am in contact with oXygen support over this matter but in the meantime the only font that somewhat works properly for Arabic is Lucida Sans, which however, does NOT include all necessary code points for IJMES transliteration of Arabic.


## 2. XML data base [eXistDB](https://exist-db.org/)

- tested with: v4.4.0
- users:
    + admin: OIB_goes_digital

- web interface: <http://localhost:8080/exist/apps/dashboard/>

### installation

Did work without a glitch on both my private and work Macs

### Connection to oXygen

I followed the basic steps in this [eXist tutorial](https://exist-db.org/exist/apps/doc/oxygen) and it worked with oXygen v19.1 and v20.1 on both Macs. (2018-11-15).


## 3. [ediarum](https://github.com/ediarum)
##  3.1 [ediarum.DB](https://github.com/ediarum/ediarum.DB)

This is the first component of ediarum that needs installing. It will configure the local eXistDB. It worked without a glitch.

- web interface: <http://localhost:8080/exist/apps/ediarum/>

### Installation

An installation guide can be found [here](https://github.com/ediarum/ediarum.DB/blob/master/INSTALLATION.md)

>With an existing eXist-db installation the ediarum.DB app can be accessed via the package manager. To do this, run the package manager fom the eXist-dashboard. Click the symbol at the top left to open "Upload Packages" dialog. Add your current ediarum.xar.

>The resources of the ediarum.DB app are added to the eXist installation. Then the xQuery pre-install.xql is automatically called and executed. It creates the user groups "website" and "oxygen", as well as the standard users "exist-bot", "oxygen-bot" and "website-user" with identical passwords.

>After the app has been installed post-install.xql is called and executed. This sets up access permissions to the different system directories and necessary routines.

The relevant `ediarum.xar` can be found in `ediarum.DB/release/`. Use the latest one, which is currently (2018-11-15) `ediarum.db-3.2.1.437.xar`. Installation worked as expected and after restarting the eXist Server, ediarum is accessible from the Dashboard.

### Configuration

#### authority files / registers/ indexes



## 3.2 Ediarum add-on / framework for oXygen

I have successfully tried installing the Ediarum frameworks following the steps below in oXygen 19.1 and 20.1 on macOS. It really only needs to be copied into the relevant folders. 

### 3.2.1 [ediarum.BASE.edit](https://github.com/ediarum/ediarum.BASE.edit)
#### Description:

>ediarum.BASE.edit is an oXygen framework designed for the Author mode of the oXygen XML-Editor (http://www.oxygenxml.com). It is optimized for oXygen XML version 20.1. With the help of ediarum.BASE.edit, scholars can create and edit TEI-XML based transcriptions of historical documents. The transcriptions can be enriched in ediarum.BASE.edit with text critic, comments and links to an index. ediarum.BASE.edit is largely based on the TEI-XML subset "DTA Base format" of the German Text Archive.

- components:
    + framework files (.framework) for oXygen XML Author
    + two JAVA files `ediarum.jar` and `tei.jar`
    + Cascading Stylesheets
    + icons for the toolbar
    + resources, i.e. XSLT-Stylesheets
    + XML file templates

#### Installation

Since development has moved to GitHub, one should clone [ediarum.BASE.edit](https://github.com/ediarum/ediarum.BASE.edit) for the latest version. To install this version, one needs to copy everything to the `frameworks/` folder of the local oXygen installation.

#### Set-up

- ediarum.BASE.edit was developped in the context of the Schleiermacher Briefedition and it comes with certain settings that prevent a display of buttons etc. if your files do not conform to the specificities of the Schleiermacher project. These settings can be found in `Oxygen > Settings > Document Type Association > ediarum.BASE.edit > Association rules`
- in order to display tool

#### depreciated method

- Go to `Help > Install new add-ons...`
- install add-on from <http://telotadev.bbaw.de/oxygen/ediarum_basis/update.xml>

### 3.2.2 [ediarum.REGISTER.edit](https://github.com/ediarum/ediarum.REGISTER.edit)

#### Installation

Since development has moved to GitHub, one should clone [ediarum.REGISTER.edit](https://github.com/ediarum/ediarum.REGISTER.edit) for the latest version. To install this version, one needs to copy everything to the `frameworks/` folder of the local oXygen installation.

### 3.2.3 [ediarum.JAR](https://github.com/ediarum/ediarum.JAR)

This is the basic Java file to enable Ediarum functions in oXygen. It needs to be present in every Ediarum framework one wants to set up and is also part of `ediarum.BASE.edit`.

### set-up authority files

The ediarum [web GUI](http://localhost:8080/exist/apps/ediarum/) provides two ways of setting up authority files (de: Register).

1. Generate a new authority file: "Ediarum Register"

    The options are pretty self-explanatory (although in German). One can set up

    - Personenregister
        + path: `Register/Personen.xml`
    - Ortsregister
        + path: `Register/Orte.xml`
    - Sachbegriffe
    - Körperschaftsregister
    - Werkregister
    - Briefregister
    - Anmerkungsregister
    
2. Access existing registers: "Register verfügbar machen"

# Adaptation to OIB's needs

1. work from a fork of "ediarum.BASE.edit": [ediarum.BI](https://github.com/oibeirut/ediarum.BI)
    - association rules need to be changed to [our schema](https://github.com/oibeirut/oibeirut_odd)
    - the CSS has been changed to load a specific font for Arabic material etc. 
2. translation of the interface from German into English: `ediarum.BI.framework`
    - all settings are maintained in an oXygen `.framework`, which is just an XML file and can be edited thus (which is easier than through the oXygen settings pane).
    - these files do not allow for multilingual versions, but one can easily produce one, using `@xml:lang` on all nodes and then compiling a monolingual version via XSLT.
3. adapt CSS to needs of Arabic script
    - one can assign fonts on the basis of `@xml:lang` values. I have currently opted for the AmiriWeb font for Arabic script, which mimicks early twentieth-century typefaces from Bulāq. However, rendering of AmiriWeb is extremely slow in oXygen.
4. selection of phenomena to be presented in the mark-up
5. adaptation to the mark-up of our authority files