<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lat/lexus"
    xmlns:rest="http://org.apache.cocoon.transformation/rest/1.0"
    xmlns:json="http://apache.org/cocoon/json/1.0" xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:include href="../../util/identity.xslt"/>
    <xsl:include href="../../util/encodeXML.xslt"/>

    <xsl:param name="endpoint"/>
    <xsl:param name="lexica-collection"/>

    <xsl:template match="/">
        <xsl:variable name="uid" select="util:randomUUID()"/>
        <xsl:variable name="id" select="util:toString($uid)"/>
        
        <rest:request target="{$endpoint}/{$lexica-collection}/{$id}.xml" method="PUT">
            <rest:header name="Content-Type" value="application/xml"/>
            <rest:body>
                <lexus:lexus id="{$id}">
                    <xsl:apply-templates select="data/Lexicon" />
                    <lexus:meta>
                        <lexus:owner ref="{/data/user/@id}"/>
                        <lexus:users>
                            <lexus:user ref="{/data/user/@id}">
                                <lexus:permissions>
                                    <lexus:lexicon>
                                        <lexus:read>true</lexus:read>
                                        <lexus:write>true</lexus:write>
                                    </lexus:lexicon>
                                </lexus:permissions>
                            </lexus:user>
                        </lexus:users>
                    </lexus:meta>
                </lexus:lexus>
            </rest:body>
        </rest:request>
    </xsl:template>

</xsl:stylesheet>
