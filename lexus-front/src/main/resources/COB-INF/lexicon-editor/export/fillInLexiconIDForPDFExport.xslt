<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    version="2.0">
    
    <xsl:param name="id" select="''"/>
    
    <xsl:include href="../../util/identity.xslt"/>
    
    <xsl:template match="json/parameters/lexicon">
        <xsl:copy>
            <xsl:value-of select="$id"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
