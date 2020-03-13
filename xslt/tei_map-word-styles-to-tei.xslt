<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- xslt-Stylesheet to translate .docx-TEI to TEI-P5 XML -->
    <!-- author(s): Julia Dolhoff, Till Grallert, 2017 -->
    
    <!-- We currently mix mapping a paragraph style for poetry lines and recognition of such lines via regex, which can result in nesting <l> tags -->
    <!-- multipass for grouping adjacent elements -->
    <!-- param to document responsibility for changes -->
    <xsl:param name="p_editor">
        <tei:persName xml:id="pers_JD">Julia Dolhoff</tei:persName>
    </xsl:param>
    
    <!-- variables that quickly allow to change the mapping of styles or to adapt this stylesheet to changing input -->
    <xsl:variable name="v_add" select="'Hinzugefuegter_Text'"/>
    <xsl:variable name="v_date" select="'Datum1'"/>
    <xsl:variable name="v_del" select="'Gestrichener_Text'"/>
    <xsl:variable name="v_div" select="'Sinnabschnitt'"/>
    <xsl:variable name="v_floatingText" select="'Geschichte'"/>
    <xsl:variable name="v_gap" select="'Fehlender_Text'"/>
    <xsl:variable name="v_graphic" select="'Grafik'"/>
    <xsl:variable name="v_heading" select="'heading 4'"/>
    <xsl:variable name="v_l" select="'Gedicht'"/>
    <xsl:variable name="v_persName" select="'Person'"/>
    <xsl:variable name="v_placeName" select="'Ort'"/>
    <xsl:variable name="v_q" select="'Zitat'"/>
    <xsl:variable name="v_overline" select="'Ueberstrich'"/>
    <xsl:variable name="v_underline" select="'Unterstrich'"/>
    
    <xsl:template match="/">
        <xsl:result-document href="_output/{tokenize(base-uri(),'/')[last()]}">
            <xsl:variable name="v_pass-1">
                <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
            </xsl:variable>
            <xsl:apply-templates select="$v_pass-1" mode="m_pass-2"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- idendity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="node() | @*" mode="m_pass-2">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="m_pass-2"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- documentation -->
    <!-- first pass -->
    <!-- must be done in revisionDesc -->
    
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:element name="tei:change">
                <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                <xsl:attribute name="who" select="concat('#',$p_editor/tei:persName/@xml:id)"/>
                <xsl:text>Converted styles from a word template to TEI tags.</xsl:text>
            </xsl:element>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <!-- translate tags -->
    <!-- 1. block-level elements -->
    
    <xsl:template match="node()[@rend=$v_div]">
        <div type="section">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:div[not(@type)]">
        <xsl:copy>
            <xsl:attribute name="type" select="'section'"/>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_l]">
        <l>
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_heading]">
        <head>
            <xsl:apply-templates select="@* | node()"/>
        </head>
    </xsl:template>
    <!-- translating "overline" as <head> is specific to the Gotha114 MS -->
    <xsl:template match="node()[@rend=$v_overline]">
        <head>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="rend" select="'overline'"/>
            <xsl:apply-templates select="node()"/>
        </head>
    </xsl:template>
    
    <!-- replace <p> with a single <pb> child, which indicates a section break in the Word source file, with a <div> tag -->
    <xsl:template match="tei:p[child::node()][tei:pb]">
        <fw/>
    </xsl:template>
  
   <!-- floatingText might constitute tag abuse as we do not know whether the surrounding text continues afterwards, but it will always validate! -->
    <xsl:template match="node()[@rend=$v_floatingText]">
        <floatingText>
            <body>
                <div>
                    <xsl:copy>
                        <xsl:apply-templates/>
                    </xsl:copy>
                </div>
            </body>
        </floatingText>
    </xsl:template>
    
    <!-- 2. in-line elements -->
    <xsl:template match="node()[@rend=$v_add]">
        <add>
            <xsl:apply-templates/>
        </add>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_del] | node()[@rend='strikethrough']">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_date]">
        <date>
            <xsl:apply-templates/>
        </date>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_gap]">
        <!-- gaps must not contain anything by definition -->
        <gap/>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_graphic]">
        <!-- attention: graphic expects the mandatory attribute @url, which we cannot harvest from the Word input file  -->
        <figure type="inline">
            <graphic>
            <!-- link to a fake URL -->
            <xsl:attribute name="url" select="'../assets/x.png'"/>
            <xsl:apply-templates/>
        </graphic>
        </figure>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_persName]">
        <persName>
            <xsl:apply-templates/>
        </persName>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_placeName]">
        <placeName>
            <xsl:apply-templates/>
        </placeName>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_q]">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    <xsl:template match="node()[@rend=$v_underline]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="rend" select="'underline'"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- mapping page-break; numbers and half-line-->
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="\[(\d+\D)\]|(\d+)|(.+)//(.+)//(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)//(.+)|(.+)//(.+)//(.+)|(.+)//(.+)">
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
                    <xsl:when test="matches(.,'\d+')">
                        <xsl:message terminate="no">
                            <xsl:text>Found number</xsl:text>
                        </xsl:message>
                        <num value="{translate(current(),'١٢٣٤٥٦٧٨٩٠', '1234567890')}">
                            <xsl:value-of select="regex-group(2)"/>
                        </num>
                    </xsl:when>  
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem with sixe sections per line</xsl:text>
                        </xsl:message>
                        <l>
                            <seg><xsl:value-of select="regex-group(3)"/></seg>
                            <seg><xsl:value-of select="regex-group(4)"/></seg>
                            <seg><xsl:value-of select="regex-group(5)"/></seg>
                            <seg><xsl:value-of select="regex-group(6)"/></seg>
                            <seg><xsl:value-of select="regex-group(7)"/></seg>
                            <seg><xsl:value-of select="regex-group(8)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem with five sections per line</xsl:text>
                        </xsl:message>
                        <l>
                            <seg><xsl:value-of select="regex-group(9)"/></seg>
                            <seg><xsl:value-of select="regex-group(10)"/></seg>
                            <seg><xsl:value-of select="regex-group(11)"/></seg>
                            <seg><xsl:value-of select="regex-group(12)"/></seg>
                            <seg><xsl:value-of select="regex-group(13)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem with four sections per line</xsl:text>
                        </xsl:message>
                        <l>
                            <seg><xsl:value-of select="regex-group(14)"/></seg>
                            <seg><xsl:value-of select="regex-group(15)"/></seg>
                            <seg><xsl:value-of select="regex-group(16)"/></seg>
                            <seg><xsl:value-of select="regex-group(17)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem with three sections per line</xsl:text>
                        </xsl:message>
                        <l type="bayt">
                            <seg><xsl:value-of select="regex-group(18)"/></seg>
                            <seg><xsl:value-of select="regex-group(19)"/></seg>
                            <seg><xsl:value-of select="regex-group(20)"/></seg>
                        </l>
                    </xsl:when>
                    <xsl:when test="matches(.,'(.+)//(.+)')">
                        <xsl:message terminate="no">
                            <xsl:text>Found poem with two sections per line</xsl:text>
                        </xsl:message>
                        <l type="bayt">
                            <seg><xsl:value-of select="regex-group(21)"/></seg>
                            <seg><xsl:value-of select="regex-group(22)"/></seg>
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
    
    <!-- Second pass: -->
    <!-- group adjacent <l> elements into <lg> -->
    <!--<xsl:template match="tei:l[not(preceding-sibling::node()[2]=tei:l)]" mode="m_pass-2">
        <lg>
            <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
            <xsl:apply-templates select="following-sibling::tei:l[preceding-sibling::node()[2]=tei:l]"/>
        </lg>
    </xsl:template>-->
    <!-- replace all <p> that have only a single child which is a <tei:pb> with that child. -->
    <xsl:template match="tei:p[count(child::node())=1][tei:pb]" mode="m_pass-2">
        <xsl:copy-of select="tei:pb"/>
    </xsl:template>
    <!-- fix heads inside <p> by moving them outside -->
    <xsl:template match="tei:p[tei:head]" mode="m_pass-2">
        <xsl:copy-of select="tei:head"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()[not(self::tei:head)]" mode="m_pass-2"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- group everything between two <fw/> tags, signifying section breaks in Word, in <div>s -->
    <xsl:template match="node()[tei:fw | tei:head]" name="t_div-wrapper" mode="m_pass-2">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!-- copy nodes before the first <tei:fw> -->
            <!-- wrap all nodes between <tei:fw> in <div>s -->
            <xsl:for-each-group select="child::node()" group-starting-with="tei:fw | tei:head">
                <xsl:element name="tei:div">
                    <xsl:apply-templates select="current-group()[not(self::tei:fw)]" mode="m_pass-2"/>
                </xsl:element>
            </xsl:for-each-group>
            <!-- copy nodes after the last <tei:fw> -->
        </xsl:copy>
    </xsl:template>
    
    
    <!-- faulty attempts -->
    <xsl:template match="tei:fw" mode="m_test">
        <div type="section">
            <!-- the not(self::text) condition is necessary as otherwise the "tagged" node and the text node would be treated differently -->
            <!-- this solution is still partially wrong as it duplicates everything: 
                - once, according to the new structure wrapped in <div>,
                - followed by a replication of the previously existing content -->
            <xsl:apply-templates select="following::node()[not(self::text()) and .&lt;&lt; current()/following::tei:fw[1]]" mode="m_pass-2"/>
        </div>
    </xsl:template>

  </xsl:stylesheet>
