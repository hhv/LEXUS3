<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:util="java:java.util.UUID" version="2.0">

    <xsl:template match="data">
        <xsl:copy>
            <lexus:delete-view>
                <xsl:copy-of select="view"/>
            </lexus:delete-view>
            <xsl:copy-of select="view"/>
            <xsl:copy-of select="user"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
