<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mei="http://www.music-encoding.org/ns/mei"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 17, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b> bwb</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" media-type="text/xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
    
    <xsl:variable name="work.id" select="substring-after(//mei:work/mei:relationList/mei:relation[@rel='isReconfigurationOf']/@target,'#')"/>
    <xsl:variable name="work.doc.uri" select="concat(substring-before(base-uri(),tokenize(base-uri(),'/')[last()]),$work.id,'.xml')"/>
    
    <xsl:variable name="work.doc" select="doc($work.doc.uri)"/>
    
    <xsl:template match="@*|*">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/><!-- normalize-space(.) -->
    </xsl:template>
    
    <xsl:template match="@rend">
        <xsl:attribute name="rend">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:element name="TEI">
            <!--<xsl:comment><xsl:value-of select="$work.doc"/></xsl:comment>-->
            <xsl:element name="teiHeader">
                <xsl:element name="fileDesc">
                    <xsl:element name="titleStmt">
                        <xsl:for-each select="//mei:fileDesc/mei:titleStmt/mei:title">
                            <xsl:element name="title">
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:element>
                            <xsl:element name="title">
                                <xsl:text>TEI Output</xsl:text>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                    <xsl:element name="publicationStmt">
                        <xsl:element name="p"></xsl:element>
                    </xsl:element>
                    <xsl:element name="sourceDesc">
                        <xsl:element name="p">Transformed from <xsl:value-of select="base-uri()"/> using MEI frameworks stylesheet <xsl:value-of select="static-base-uri()"/> on <xsl:value-of select="current-dateTime()"/></xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="text">
                <xsl:element name="front">
                    <!-- Titelei -->
                    <xsl:element name="titlePage">
                        <xsl:element name="docTitle">
                            <xsl:for-each select="//mei:workDesc/mei:work">
                                <xsl:for-each select="mei:titleStmt/mei:title">
                                    <xsl:element name="titlePart">
                                        <xsl:apply-templates select="@*|node()"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:element name="docImprint">
                            <xsl:apply-templates select="//mei:fileDesc/mei:editionStmt/node()"></xsl:apply-templates>
                        </xsl:element>
                    </xsl:element>
                    <!-- Widmung -->
                    <!-- Kompositionsauftrag -->
                    <!-- Inhaltsverzeichnis -->
                    <xsl:element name="pb"/>
                    <xsl:element name="divGen">
                        <xsl:attribute name="type">toc</xsl:attribute>
                    </xsl:element>
                    <!-- // Inhaltsverzeichnis -->
                    <!-- Generalvorvort der Editionsleitung -->
                    <xsl:element name="pb"/>
                    <xsl:element name="div">
                        <xsl:element name="head">Generalvorvort der Editionsleitung</xsl:element>
                        <xsl:apply-templates select="//mei:projectDesc/node()"/>
                        <xsl:apply-templates select="//mei:div[@type='preface' and @subtype='edition']/node()"/>
                    </xsl:element>
                    <!-- // Generalvorvort der Editionsleitung -->
                    <!-- Vorwort des Bandherausgebers -->
                    <xsl:element name="pb"/>
                    <xsl:element name="div">
                        <xsl:element name="head">Vorwort des Bandherausgebers</xsl:element>
                        <xsl:apply-templates select="//mei:div[@type='preface' and @subtype='edition']/node()"/>
                    </xsl:element>
                    
                    <!-- // Vorwort des Bandherausgebers -->
                    <xsl:comment>more to come</xsl:comment>
                    <!-- Abkürzungsverzeichnis -->
                    <xsl:element name="pb"/>
                    <div><!-- allgemein für alle Bände bzw Werke in einem Band -->
                        <head>Abkürzungen und Siglen</head>
                        <div>
                            <head>Diakritische Zeichen und Symbole im Notentext</head>
                        </div>
                        <div>
                            <head>Diakritische Zeichen und Symbole im Kritischen Bericht</head>
                        </div>
                        <div>
                            <head>Quellenkürzel</head>
                        </div>
                        <div>
                            <head>Quellenfundorte</head>
                            <p>Soweit möglich wird für die Angabe von Quellenfundorten das RISM-Bibliothekssigel gemäß des <ref type="bibl" target="#rism_bib-sig">Online Katalog der RISM-Bibliothekssigel</ref> angegeben, gefolgt von der Signatur. Bei nicht von RISM verzeichneten Fundorten erfolgt die Angabe nach dem Muster: Ort-Besitzer Signatur</p>
                        </div>
                        <div>
                            <head>Literaturkürzel</head>
                            <!--<listBibl>
                                <label><abbr>WeV</abbr></label>
                                <bibl><expan>Werkverzeichnis</expan></bibl>
                            </listBibl>-->
                            <list>
                                <label><abbr>WeV</abbr></label>
                                <item><bibl><expan>Werkverzeichnis</expan></bibl></item>
                            </list>
                        </div>
                        <div>
                            <head>Kürzel für die Bezeichnung von Partiturstimmen</head>
                            <?TODO fomr excel ?>
                        </div>
                        <div>
                            <head>Sonstige Abkürzungen</head>
                            <p>Im Nachfolgenden nicht aufgelistet sind Abkürzungen nach Duden sowie Kürzel in Signaturen bzw. Abkürzungen, die von anderer Stelle übernommen wurden, etwa in Zitaten oder bei der Beschreibung von Quellen.</p>
                            <list>
                                <label>fol.</label>
                                <item>folio</item>
                            </list>
                        </div>
                    </div>
                    <!--<xsl:element name="div">
                        <xsl:element name="head">Abkürzungsverzeichnis</xsl:element>
                    </xsl:element>-->
                    <!-- // Abkürzungsverzeichnis -->
                    <!-- Ggf. Edition des vertonten Textes -->
                    <xsl:element name="pb"/>
                    <xsl:element name="div">
                        <xsl:element name="head">Edition des vertonten Textes</xsl:element>
                    </xsl:element>
                    <!-- // Ggf. Edition des vertonten Textes -->
                    <!-- Bei Orchesterwerken Besetzungsangabe und ggf. Grafik zur Orchesteraufstellung -->
                    <xsl:element name="pb"/>
                    <xsl:element name="div">
                        <xsl:element name="head">Orchester</xsl:element>
                        <xsl:element name="div">
                            <xsl:element name="head">Besetzung</xsl:element>
                        </xsl:element>
                        <xsl:element name="div">
                            <xsl:element name="head">Aufstellung</xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <!-- // Bei Orchesterwerken Besetzungsangabe und ggf. Grafik zur Orchesteraufstellung -->
                </xsl:element>
                <xsl:comment>text bearing elements</xsl:comment>
                <xsl:comment>
                    <xsl:value-of select="distinct-values(for $node in //text() return local-name($node/parent::*))"></xsl:value-of>
                </xsl:comment>
                <xsl:element name="body">
                    <!-- Notentext -->
                    <xsl:element name="div">
                        <xsl:element name="head">Notentext</xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="back">
                    <xsl:comment>more to come</xsl:comment>
                    <!-- Notenanhang -->
                    <xsl:element name="div">
                    </xsl:element>
                    <!-- Kurzfassung des Kritischen Berichts -->
                    <xsl:element name="div">
                        <xsl:element name="head">Beschreibung von Entstehung und Überlieferung</xsl:element>
                    </xsl:element>
                    <xsl:if test="//mei:back/mei:div[@type='generated' and @subtype='sources.list']">
                        <xsl:element name="div">
                            <xsl:element name="head">
                                <xsl:text>Quellenverzeichnis</xsl:text>
                            </xsl:element>
                            <xsl:element name="table">
                                <xsl:variable name="columns" select="('Sigle', 'Standort (RISM Sigel)/ Signatur', 'Datierung', 'Kurzbeschreibung')"/>
                                <xsl:element name="row">
                                    <xsl:attribute name="role">label</xsl:attribute>
                                    <xsl:for-each select="$columns">
                                        <xsl:element name="cell">
                                            <xsl:value-of select="."/>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                                <xsl:for-each select="//mei:fileDesc/mei:sourceDesc/mei:source">
                                    <xsl:variable name="source" select="current()"/>
                                    <xsl:element name="row">
                                        <xsl:attribute name="role">data</xsl:attribute>
                                        <xsl:for-each select="$columns">
                                            <xsl:element name="cell">
                                                <xsl:choose>
                                                    <xsl:when test="current() = 'Sigle'">
                                                        <xsl:apply-templates select="$source/mei:identifier[@type='siglum']"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:comment>retrieve from referenced file</xsl:comment>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="//mei:back/mei:div[@type='generated' and @subtype='sources.desc']">
                        <xsl:element name="div">
                            <xsl:element name="head">Quellenbeschreibung</xsl:element>
                            <xsl:for-each select="//mei:fileDesc/mei:sourceDesc/mei:source">
                                <xsl:variable name="source" select="current()"/>
                                <xsl:variable name="source.doc.uri" select="concat(substring-before(base-uri(),tokenize(base-uri(),'/')[last()]),'Quellencodierung/',substring-after(tokenize($source/@target,'/')[last()],'#'),'.xml')"/>
                                <xsl:variable name="source.doc.available" select="doc-available($source.doc.uri)"/>
                                <xsl:variable name="source.doc" select="if($source.doc.available)then(doc($source.doc.uri))else()"/>
                                <xsl:element name="div">
                                    <xsl:element name="head">
                                        <xsl:apply-templates select="$source/mei:identifier[@type='siglum']"/>
                                        <xsl:text> – </xsl:text>
                                        <xsl:comment>TITLE retrieved from referenced file</xsl:comment>
                                        <xsl:comment> source doc available? <xsl:value-of select="$source.doc.available"/></xsl:comment>
                                        <xsl:choose>
                                            <xsl:when test="$source.doc.available">
                                                <xsl:value-of select="$source.doc//mei:sourceDesc/mei:source/mei:titleStmt/mei:title[@type='main']"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('unable to access file at: ',$source.doc.uri)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
    <!--                                <xsl:element name="p">-->
                                        <xsl:comment>SOURCEDESC retrieved from referenced file</xsl:comment>
                                        <xsl:apply-templates select="$source.doc//mei:source" mode="sourceDesc"/>
                                    <!--</xsl:element>-->
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="div">
                        <xsl:element name="head">Quellenbewertung und Filiation</xsl:element>
                        <xsl:element name="p">
                            <xsl:comment>process from edition file</xsl:comment>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:element name="head">Editionsbericht</xsl:element>
                        <xsl:element name="table">
                            <xsl:variable name="columns" select="('Stimme', 'Takt', 'Zeichen im Takt', 'Quelle', 'Kategorie', 'Bemerkung')"/>
                            <xsl:element name="row">
                                <xsl:attribute name="role">label</xsl:attribute>
                                <xsl:for-each select="$columns">
                                    <xsl:element name="cell">
                                        <xsl:value-of select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                            <xsl:for-each select="//mei:work/mei:notesStmt/mei:annot[@type='criticalCommentary']/mei:annot[@type='editorialComment']">
                                <xsl:variable name="source" select="current()"/>
                                <xsl:variable name="mei.version" select="root()/mei:mei/@meiversion"/>
                                <xsl:variable name="head.tokens" select="tokenize($source/mei:title,',')">
                                    <!--<xsl:choose>
                                        <xsl:when test="$mei.version = '3.0.0'">
                                            <xsl:comment>TODO</xsl:comment>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="tokenize($source/mei:title,',')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>-->
                                </xsl:variable>
                                <xsl:element name="row">
                                    <xsl:attribute name="role">data</xsl:attribute>
                                    <xsl:for-each select="$columns">
                                        <xsl:element name="cell">
                                            <xsl:choose>
                                                <xsl:when test="current() = 'Stimme'">
                                                    <xsl:value-of select="$head.tokens[2]"/>
                                                </xsl:when>
                                                <xsl:when test="current() = 'Takt'">
                                                    <xsl:value-of select="$head.tokens[1]"/>
                                                </xsl:when>
                                                <xsl:when test="current() = 'Zeichen im Takt'">
                                                    <?TODO evaluate supplying @tstamp and @tstamp2 ?>
                                                </xsl:when>
                                                <xsl:when test="current() = 'Sigle'">
                                                    <xsl:apply-templates select="$source/mei:identifier[@type='siglum']"/>
                                                </xsl:when>
                                                <xsl:when test="current() = 'Bemerkung'">
                                                    <xsl:apply-templates select="$source/mei:p"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>TODO</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                    <xsl:comment>more to come</xsl:comment>
                    <!-- Register für Namen-->
                    <!-- Register für Werke -->
                    <!-- Register für Quellen -->
                    <!-- Ggf. Tonträger bei Verwendung von Zuspielbändern -->
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:corpName">
        <xsl:element name="orgName">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:div|mei:event|mei:geogName|mei:head|mei:list|mei:p">
        <xsl:variable name="element.name" select="local-name()"/>
        <xsl:element name="{$element.name}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:eventList">
        <xsl:element name="listEvent">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:history">
        <xsl:element name="div">
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:identifier">
        <xsl:element name="idno">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:identifier[parent::mei:p]">
        <xsl:element name="rs">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:identifier[@type='siglum']">
        <xsl:element name="rs">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:li">
        <xsl:element name="item">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:rend">
        <xsl:element name="span">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:source" mode="sourceDesc">
        <xsl:element name="list">
            <xsl:attribute name="type">gloss</xsl:attribute>
            <xsl:apply-templates mode="sourceDescLabel"/>
        </xsl:element>
        <!--<xsl:element name="div">-->
            <!--<xsl:for-each select="*">
                <xsl:element name="div">
                    <xsl:element name="head">
                        <xsl:value-of select="local-name(.)"/>
                    </xsl:element>
                    <xsl:element name="list">
                        <xsl:attribute name="type">gloss</xsl:attribute>
                        <xsl:for-each select="*">
                            <xsl:element name="label">
                                <xsl:value-of select="local-name(.)"/>
                            </xsl:element>
                            <xsl:element name="item">
                                <xsl:apply-templates mode="#default"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>-->
        <!--</xsl:element>-->
    </xsl:template>
    
    <xsl:template match="mei:title/@level">
        <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test=".='j'">journal</xsl:when>
                <xsl:when test=".='s'">series</xsl:when>
                <xsl:when test=".='a'">article</xsl:when>
                <xsl:when test=".='m'">monograph</xsl:when>
                <xsl:when test=".='u'">unpublished</xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="mei:title[parent::mei:annot]"><!-- potentiall not applicable, at least when converting critical notes to tei:table as tei:cell/tei:head not allowed -->
        <xsl:element name="head" >
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:*" mode="sourceDescLabel">
        <xsl:element name="label">
            <xsl:value-of select="local-name()"/>
        </xsl:element>
        <xsl:element name="item">
            <xsl:apply-templates select="." mode="listItem"/>
        </xsl:element>
    </xsl:template>
    
    <!-- mode listItem -->
    
    <xsl:template match="mei:classification" mode="listItem">
        <xsl:value-of select="mei:classCode" separator=", "/>
    </xsl:template>
    
    <xsl:template match="mei:itemList" mode="listItem">
        <xsl:element name="listWit">
            <xsl:for-each select="mei:item">
                <xsl:element name="witness">
                    <!-- IDNO -->
                    <!--<xsl:element name="head">
                        <xsl:value-of select="'item'"/>
                    </xsl:element>
                    <xsl:element name="msDesc">
                        <xsl:apply-templates mode="#default"/>
                    </xsl:element>-->
                    <xsl:element name="eg"></xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:physDesc">
        <xsl:element name="physDesc">
            <xsl:apply-templates select="@*|*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="mei:titleStmt" mode="listItem">
        
    </xsl:template>
    
    <xsl:template match="mei:unpub" mode="listItem">
        <xsl:value-of select="local-name()"/>
    </xsl:template>
    
</xsl:stylesheet>