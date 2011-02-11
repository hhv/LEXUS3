<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>
    <xsl:include href="../../util/xquery-components.xslt"/>
    
    <xsl:param name="users-collection"/>

    <xsl:template match="/">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
            <lexus:text>
                <xsl:call-template name="declare-namespace"/>                        
                
                declare function lexus:deleteSortOrder($sortOrder as node(), $user as node()) as node() {
                    let $dummy := (
                        update delete $user/workspace/sortorders/sortorder[@id eq $sortOrder/@id]
                    )
                    return element result { $user }
                };

                let $userId := '<xsl:value-of select="/data/user/@id"/>'                        
                let $sortOrder := <xsl:apply-templates select="/data/sortorder" mode="encoded"/>
                let $user := collection('<xsl:value-of select="$users-collection"/>')/user[@id eq $userId]
                return lexus:deleteSortOrder($sortOrder, $user)
            </lexus:text>
            </lexus:query>
            </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
