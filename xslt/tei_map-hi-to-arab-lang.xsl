<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- xslt-Stylesheet to map attribute @dir to @lang="ar" -->
    <!-- author(s): Lena Hofmann, Till Grallert, 2018 -->
    
    <xsl:param name="p_editor">
        <tei:persName xml:id="pers_LH">Lena Hofmann</tei:persName>
    </xsl:param>
    <xsl:param name="p_id-change" select="generate-id(//tei:change[last()])"/>
    <xsl:variable name="v_id-editor" select="$p_editor/descendant-or-self::tei:persName/@xml:id"/>
    
    <!-- reproduce everything with identity transform -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- copy all attributes of the highlight to its parent node -->
    <xsl:template match="node()[tei:hi[@dir='rtl']]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- add documentation of change -->
            <xsl:choose>
                <xsl:when test="not(@change)">
                    <xsl:attribute name="change" select="concat('#', $p_id-change)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="m_documentation" select="@change"/>
                </xsl:otherwise>
            </xsl:choose>
            <!-- attributes of <hi> child -->
            <xsl:apply-templates select="tei:hi[@dir='rtl']/@*"/>
            <xsl:apply-templates/> 
        </xsl:copy>
    </xsl:template>
    
    <!-- remove the wrapping highlight from the output -->
    <xsl:template match="tei:hi[@dir='rtl']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- map @dir='rtl' to @xml:lang='ar' -->
    <xsl:template match="@dir['rtl']">
        <xsl:attribute name="xml:lang">
            <xsl:value-of select="'ar'"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- generate documentation of change -->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="change">
                <xsl:attribute name="when"
                    select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#', $v_id-editor)"/>
                <xsl:attribute name="xml:id" select="$p_id-change"/>
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:text>Generated </xsl:text><tei:att xml:lang="en">xml:lang</tei:att><xsl:text> attribute values based on </xsl:text><tei:tag xml:lang="en">tei:hi dir="rtl"</tei:tag><xsl:text> children. In the process these children were also removed from the output.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document changes on changed elements by means of the @change attribute linking to the @xml:id of the <tei:change> element -->
    <xsl:template match="@change" mode="m_documentation">
        <xsl:attribute name="change">
            <xsl:value-of select="concat(., ' #', $p_id-change)"/>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
