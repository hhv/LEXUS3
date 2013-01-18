<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:display="http://www.mpi.nl/lexus/display/1.0" exclude-result-prefixes="xd" version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 5, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> huiver</xd:p>
            <xd:p>Create an entire XSL-FO document. Include all lexical entries.</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:preserve-space elements="*"/>
    
    <xsl:variable name="margin-left" select="'1cm'"/>
    <xsl:variable name="margin-right" select="'1cm'"/>

    <xsl:template match="/data">
        <fo:root>

            <fo:layout-master-set>
                <fo:simple-page-master master-name="frontpage">
                    <fo:region-body margin="5cm" region-name="front-body"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="lexical-entries-odd">
                    <fo:region-body margin-top="2cm" margin-bottom="2cm"
                        margin-left="{$margin-left}" margin-right="{$margin-right}"
                        region-name="body"/>
                    <fo:region-after region-name="odd-after" extent="2cm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="lexical-entries-even">
                    <fo:region-body margin-top="2cm" margin-bottom="2cm"
                        margin-left="{$margin-left}" margin-right="{$margin-right}"
                        region-name="body"/>
                    <fo:region-after region-name="even-after" extent="2cm"/>
                </fo:simple-page-master>


                <fo:page-sequence-master master-name="lexical-entries">
                    <fo:repeatable-page-master-alternatives>
<!--                        <fo:conditional-page-master-reference master-reference="frontpage" page-position="first"/>-->
                        <fo:conditional-page-master-reference master-reference="lexical-entries-odd" page-position="first" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="lexical-entries-odd" page-position="rest" odd-or-even="odd"/>
                        <fo:conditional-page-master-reference master-reference="lexical-entries-even" page-position="rest" odd-or-even="even"/>
                    </fo:repeatable-page-master-alternatives>
                    
                </fo:page-sequence-master>
            </fo:layout-master-set>


            <fo:page-sequence master-reference="frontpage">
                <fo:flow flow-name="front-body">
                    <fo:block font-family="sans-serif" font-size="20pt" padding-before="6cm">
                        <xsl:value-of select="lexicon/meta/name"/>
                    </fo:block>
                    <fo:block font-family="sans-serif" font-size="10pt" padding-before="1cm">
                        <xsl:value-of select="lexicon/meta/description"/>
                    </fo:block>
                    <fo:block font-family="sans-serif" font-size="12pt" padding-before="2cm">
                        <xsl:value-of select="user/name"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>

            <fo:page-sequence master-reference="lexical-entries" initial-page-number="1" force-page-count="even">
                <fo:static-content flow-name="odd-after">
                    <fo:block margin-left="{$margin-left}" margin-right="{$margin-right}"
                        text-align-last="justify">
                        <fo:block margin-left="{$margin-left}" margin-right="{$margin-right}"
                            text-align-last="justify">
                            <fo:leader leader-pattern="rule" leader-length="100%"/>
                        </fo:block>
                        <fo:block text-align-last="justify" font-size="6pt">
                            Generated by <fo:inline font-size="8pt"
                                    color="red">Lexus</fo:inline> of The Language Archive at the Max Plank Institute for
                                Psycholinguistics (http://www.lat-mpi.eu/tools/lexus).<fo:leader leader-pattern="space" />
                            
                            <fo:inline font-size="12pt"><fo:page-number/></fo:inline>
                            
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                
                <fo:static-content flow-name="even-after">
                    <fo:block margin-left="{$margin-left}" margin-right="{$margin-right}"
                        text-align-last="justify">
                        <fo:block margin-left="{$margin-left}" margin-right="{$margin-right}"
                            text-align-last="justify">
                            <fo:leader leader-pattern="rule" leader-length="100%"/>
                        </fo:block>
                        <fo:block text-align-last="justify" font-size="6pt">
                            
                            <fo:inline font-size="12pt"><fo:page-number/></fo:inline>
                            <fo:leader leader-pattern="space" />
                            Generated by <fo:inline font-size="8pt"
                                color="red">Lexus</fo:inline> of The Language Archive at the Max Plank Institute for
                            Psycholinguistics (http://www.lat-mpi.eu/tools/lexus).
                            
                        </fo:block>
                    </fo:block>
                </fo:static-content>
                
                <fo:flow flow-name="body">
                	<fo:block>
                    	<xsl:apply-templates select="//display:lexicon/lexical-entries/lexical-entry"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>

    <xsl:template match="lexical-entry">
        <fo:inline>
            <xsl:copy-of select="*"/>
        </fo:inline>
    </xsl:template>
</xsl:stylesheet>
