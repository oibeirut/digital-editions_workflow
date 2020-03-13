<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:html="http://www.w3.org/1999/xhtml" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.pnp-software.com/XSLTdoc"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd html"
    version="2.0">

    <!-- author(s): Till Grallert, 2017 -->
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>This stylesheet adds <tei:att>xml:lang</tei:att> to every node that lacks this attribute. The value is based on the descendant.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output encoding="UTF-8" indent="no" method="xml" name="xml" omit-xml-declaration="no" version="1.0"/>
    
    <!-- identify the author of the change by means of a @xml:id -->
    <xsl:param name="p_id-editor" select="'pers_TG'"/>
<!--    <xsl:include href="../../oxygen-project/OpenArabicPE_parameters.xsl"/>-->
    
<!--    <!-\- generate a new file -\->
    <xsl:template match="/">
        <!-\-<xsl:result-document href="{substring-before(base-uri(),'.TEIP5.xml')}_lang-codes.TEIP5.xml">-\->
            <xsl:copy>
                <xsl:apply-templates select="node()"/>
            </xsl:copy>
        <!-\-</xsl:result-document>-\->
    </xsl:template>-->

    <!-- reproduce everything -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <!-- document the changes -->
    <xsl:template match="tei:revisionDesc" priority="100">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$p_id-editor)"/>
                <xsl:text>Added the </xsl:text><tei:att>xml:lang</tei:att><xsl:text> attribute to all nodes that lacked this attribute. The value is based on the closest descendant.</xsl:text>
            </xsl:element>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- generate @xml:lang -->
    <xsl:template match="*[not(@xml:lang)][.!=''][ancestor::tei:text][child::*]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="xml:lang">
                <xsl:value-of select="descendant::node()[@xml:lang != ''][1]/@xml:lang"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>