<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    
    <xsl:include href="../../util/identity.xslt"/>

    <xsl:param name="lexicon"/>
    
    <xsl:template match="data">
        <xsl:copy>
            <lexus:get-leview lexicon="{$lexicon}" />
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
