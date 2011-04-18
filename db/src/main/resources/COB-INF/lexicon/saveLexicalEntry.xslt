<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:xquery="xquery-dialect"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:save-lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
                <lexus:query>
                
                <!--             
                    Save or create a Lexical Entry.                
                  -->
                <lexus:text>
                    
                    <xsl:call-template name="declare-namespace"/>
                    <xsl:call-template name="permissions"/>
                    
                    (: replace the lexical entry in the db :)
                    <xquery:declare-updating-function/> lexus:updateLexicalEntry($lexus, $newLE as node(), $lexicalEntry as node()*) {
                        if (not(empty($newLE)))
                        then if (empty($lexicalEntry))
                                then
                                    <xquery:insert-into>
                                        <xquery:node>$newLE</xquery:node>
                                        <xquery:into>$lexus/lexicon</xquery:into>
                                    </xquery:insert-into>
                                else
                                    <xquery:replace>
                                        <xquery:node>$lexicalEntry</xquery:node>
                                        <xquery:with>$newLE</xquery:with>
                                    </xquery:replace>
                        else ()
                    };
                    
    
                    let $user := <xsl:apply-templates select="/data/user" mode="encoded"/>
                    let $request := <xsl:apply-templates select="." mode="encoded"/>
                    let $lexiconId:= $request/@lexicon
                    let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $lexiconId]
                    let $lexicalEntry := $lexus/lexicon/lexical-entry[@id eq $request/lexical-entry/@id]
                    return 
                        if (lexus:canWrite($lexus/meta, $user))
                            then lexus:updateLexicalEntry($lexus, $request/lexical-entry, $lexicalEntry) 
                            else ()
                </lexus:text>
                </lexus:query>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
