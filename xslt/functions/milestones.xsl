<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="local-function">
    <!-- Delivers the fragment between two milestones. Takes no care about namespaces. -->
    
    <xsl:function name="fn:contains">
        <xsl:param name="sequence" as="node()*"/> 
        <xsl:param name="node" as="node()?"/> 
        <xsl:sequence select="some $nodeInSequence in $sequence satisfies $nodeInSequence is $node"/>
    </xsl:function>
    
    <xsl:output method="xml" encoding="utf-8"/>
    
    <!-- ms1Name and ms2Name have to be given without namespace: e.g. "pb" -->
    <xsl:param name="ms1Name"></xsl:param>
    <xsl:param name="ms1Position"></xsl:param>
    <xsl:param name="ms2Name"></xsl:param>
    <xsl:param name="ms2Position"></xsl:param>
    
    <xsl:variable name="ms1XPath" select="concat('subsequence(//*:', $ms1Name, ', ', $ms1Position, ', 1)')"/>
    <xsl:variable name="ms2XPath" select="concat('subsequence(//*:', $ms2Name, ', ', $ms2Position, ', 1)')"/>
    <xsl:variable name="ms1" select="saxon:evaluate($ms1XPath)" xmlns:saxon="http://saxon.sf.net/"/>
    <xsl:variable name="ms2" select="saxon:evaluate($ms2XPath)" xmlns:saxon="http://saxon.sf.net/"/>
    <xsl:variable name="ms1Ancestors" select="$ms1/ancestor::*"/>
    <xsl:variable name="ms2Ancestors" select="$ms2/ancestor::*"/>
    
    <xsl:template match="element()[local-name() != $ms1Name and local-name() != $ms2Name]">
        <xsl:choose>
            <xsl:when test="(. >> $ms1 or fn:contains($ms1Ancestors, .)) and ($ms2 >> . or fn:contains($ms2Ancestors, .))">
                <xsl:element name="{local-name(.)}"><xsl:apply-templates/></xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="attribute()|text()|comment()|processing-instruction()">
        <xsl:choose>
            <xsl:when test=". >> $ms1 and $ms2 >> .">
                <xsl:copy><xsl:apply-templates/></xsl:copy>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="element()[local-name() = $ms1Name or local-name() = $ms2Name]">
        <xsl:choose>
            <xsl:when test=". is $ms1">
                <xsl:element name="{local-name(.)}"><xsl:copy-of select="@*"></xsl:copy-of></xsl:element>
            </xsl:when>
            <xsl:when test=". is $ms2">
                <xsl:element name="{local-name(.)}"><xsl:copy-of select="@*"></xsl:copy-of></xsl:element>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
