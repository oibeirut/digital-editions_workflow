<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- author(s): Julia Dolhoff, 2017 -->
    
    <!-- missing: documentation of changes in the output document -->
    
    <!-- idendity transform -->
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Important note: in a first round we look solely at content of nodes and do NOT replace them entirely. This must be done in a second step -->
    <!-- add pb tag for pagebreak -->
    <xsl:template match="text()">
        <!-- searching for non-digits is probably not the best idea for most cases! it would be better to check for anything (.+?) between markers of deletions and additions -->
        <xsl:analyze-string select="." regex="\[(\d+\D)\]|\[(\.\.\.)\]|(\[)|(\])|(&lt;)|(&gt;)|(×)|(\d+)|(.+)//(.+)//(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)|(.+)//(.+)">
            <xsl:matching-substring>
                <xsl:message>
                    <xsl:text>regex found</xsl:text>
                </xsl:message>
                <xsl:choose>
                    <xsl:when test="matches(.,'\[(\d+\D)\]')">
                        <xsl:message>
                            <xsl:text>Found page break </xsl:text><xsl:value-of select="regex-group(1)"/>
                        </xsl:message>
                        <pb n="{regex-group(1)}"/>
                    </xsl:when>
                    <xsl:when test="matches(.,'\[\.\.\.\]')">
                        <xsl:message terminate="no">
                            <xsl:text>Found gap.</xsl:text>
                        </xsl:message>
                        <gap/>
                    </xsl:when>
                    <xsl:when test="matches(.,'\[')">
                        <xsl:message>
                            <xsl:text>Foung deleted object start</xsl:text>
                        </xsl:message>
                        <xsl:value-of disable-output-escaping="yes" select="string('&lt;del&gt;')"/>
                    </xsl:when>
                    <xsl:when test="matches(.,'\]')">
                        <xsl:message>
                            <xsl:text>Foung deleted object end</xsl:text>
                        </xsl:message>
                        <xsl:value-of disable-output-escaping="yes" select="string('&lt;/del&gt;')"/>
                    </xsl:when>
                    <xsl:when test="matches(.,'&lt;')">
                        <xsl:message terminate="no">
                            <xsl:text>Found added object start</xsl:text>
                        </xsl:message>
                        <xsl:value-of disable-output-escaping="yes" select="string('&lt;add&gt;')"/>
                    </xsl:when>
                    <xsl:when test="matches(.,'&gt;')">
                        <xsl:message terminate="no">
                            <xsl:text>Found added object end</xsl:text>
                        </xsl:message>
                        <xsl:value-of disable-output-escaping="yes" select="string('&lt;/add&gt;')"/>
                    </xsl:when> 
                    <xsl:when test="matches(.,'(×)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found graphic</xsl:text>
                        </xsl:message>
                        <graphic>
                            <xsl:value-of select="regex-group(7)"/>
                        </graphic>
                    </xsl:when>
                    <xsl:when test="matches(.,'\d+')">
                        <xsl:message terminate="no">
                            <xsl:text>Found number</xsl:text>
                        </xsl:message>
                        <num value="{translate(current(),'١٢٣٤٥٦٧٨٩٠', '1234567890')}">
                            <xsl:value-of select="regex-group(8)"/>
                        </num>
                    </xsl:when>  
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem</xsl:text>
                        </xsl:message>
                        <l type="">
                            <seg><xsl:value-of select="regex-group(9)"/></seg>
                            <seg><xsl:value-of select="regex-group(10)"/></seg>
                            <seg><xsl:value-of select="regex-group(11)"/></seg>
                            <seg><xsl:value-of select="regex-group(12)"/></seg>
                            <seg><xsl:value-of select="regex-group(13)"/></seg>
                            <seg><xsl:value-of select="regex-group(14)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem</xsl:text>
                        </xsl:message>
                        <l type="">
                            <seg><xsl:value-of select="regex-group(15)"/></seg>
                            <seg><xsl:value-of select="regex-group(16)"/></seg>
                            <seg><xsl:value-of select="regex-group(17)"/></seg>
                            <seg><xsl:value-of select="regex-group(18)"/></seg>
                            <seg><xsl:value-of select="regex-group(19)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem</xsl:text>
                        </xsl:message>
                        <l type="">
                            <seg><xsl:value-of select="regex-group(20)"/></seg>
                            <seg><xsl:value-of select="regex-group(21)"/></seg>
                            <seg><xsl:value-of select="regex-group(22)"/></seg>
                            <seg><xsl:value-of select="regex-group(23)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem</xsl:text>
                        </xsl:message>
                        <l type="">
                            <seg><xsl:value-of select="regex-group(24)"/></seg>
                            <seg><xsl:value-of select="regex-group(25)"/></seg>
                            <seg><xsl:value-of select="regex-group(26)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem</xsl:text>
                        </xsl:message>
                        <l type="">
                            <seg><xsl:value-of select="regex-group(27)"/></seg>
                            <seg><xsl:value-of select="regex-group(28)"/></seg>
                        </l>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <!-- insufficient solution -->
    <!--<xsl:template match="tei:p[matches(.,'\[\.\.\.\]')]">
        <xsl:element name="tei:gap"/>
    </xsl:template>-->
    
    <!-- Second step: replace all <p> that have only a single child which is a <tei:pb> with that child. -->
    <!-- moved to tei_map-word-styles-to-tei -->
    <!--<xsl:template match="tei:p[count(child::node())=1][tei:pb]">
        <xsl:element name="tei:pb">
            <xsl:attribute name="n" select="tei:pb/@n"/>
        </xsl:element>
    </xsl:template>-->
    
</xsl:stylesheet>
