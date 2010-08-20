<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus/1.0" xmlns:util="java:java.util.UUID" 
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>
    <xsl:param name="users-collection"/>
    
    <xsl:template match="lexus:get-views">
        <lexus:query>
            
            <!--             
                Get views.
              -->
            <lexus:text>
                
                <xsl:call-template name="declare-namespace"/>
                <xsl:call-template name="view-permissions"/>
                <xsl:call-template name="log"/>
                
                let $userId := '<xsl:value-of select="/data/user/@id"/>'       
                let $request := <xsl:apply-templates select="." mode="encoded"/>
                let $lexus := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id eq $request/@lexicon]
                return
                    if (lexus:canReadViews($lexus/meta, $userId))
                        then $lexus/meta/views
                        else ()
            </lexus:text>
        </lexus:query>
    </xsl:template>
    
</xsl:stylesheet>
