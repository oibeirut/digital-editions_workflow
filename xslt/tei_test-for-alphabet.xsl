<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- author(s): Julia Dolhoff, 2017 -->
    
    <xsl:template match="/">
        <xsl:result-document href="_output/{tokenize(base-uri(),'/')[last()]}">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:param name="p_editor">
        <tei:persName xml:id="pers_JD">Julia Dolhoff</tei:persName>
    </xsl:param>
    
    <!-- initialization of variables -->
    <xsl:variable name="v_alphabet-arabic" select="'اأإبتثحخجدذرزسشصضطظعغفقكلمنهوؤيئىةء٠١٢٣٤٥٦٧٨٩'"/>
    <xsl:variable name="v_alphabet-english" select="'0123456789abcdefghijklmnopqrstuvwxyz'"/>
   
    <!-- idendity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- documentation -->
    <!-- must be done in revisionDesc -->
    
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$p_editor/tei:persName/@xml:id)"/>
                <xsl:text>Ran a script test on every word in the main body of this file and assigned relevant @xml:lang attributes.</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- actual transformation -->
    <xsl:template match="text()[ancestor::tei:text]">
        <xsl:analyze-string select="." regex="((\w)+)|([^\w+|\s])">
            <xsl:matching-substring>
                <xsl:choose>
                    <!-- check punctuation character-->
                    <xsl:when test="matches(.,'[^\w+|\s]')">
                        <pc>
                            <xsl:value-of select="regex-group(3)"/>
                        </pc>
                    </xsl:when>
                    <!-- check arabic words -->
                    <xsl:when test="matches(.,'\w+') and contains($v_alphabet-arabic, regex-group(2))">
                        <w xml:lang="ar">
                           <xsl:value-of select="regex-group(1)"/>
                        </w>
                    </xsl:when>
                    <!-- check english words -->
                  <xsl:when test="matches(.,'\w+') and contains($v_alphabet-english, regex-group(2))">
                        <w xml:lang="en">
                            <xsl:value-of select="regex-group(1)"/>
                        </w>
                    </xsl:when>
                    <!-- fall back option -->
                    <xsl:otherwise>
                        <w>
                            <xsl:value-of select="regex-group(1)"/>
                        </w>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>