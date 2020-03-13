<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- xslt-Stylesheet to to group adjacent <l> into <lg>s-->
    <!-- author(s): Julia Dolhoff, 2017 -->
    
    <!-- We currently mix mapping a paragraph style for poetry lines and recognition of such lines via regex, which can result in nesting <l> tags -->
    <!-- multipass for grouping adjacent elements -->
    
    <xsl:param name="p_editor">
        <tei:persName xml:id="pers_JD">Julia Dolhoff</tei:persName>
    </xsl:param>
    
    <xsl:template match="/">
        <xsl:result-document href="_output/lg/{tokenize(base-uri(),'/')[last()]}">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    <!-- idendity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>