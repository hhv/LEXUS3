<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:zip="http://apache.org/cocoon/zip-archive/1.0"
    version="2.0">

    <xsl:template match="/">
        <xsl:copy-of select="//zip:archive"/>
    </xsl:template>

</xsl:stylesheet>
