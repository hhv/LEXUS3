<?xml version="1.0" encoding="UTF-8"?>
<!--
   Remove markers that do not exist in the schema. Yes, there are markers that are undefined. Really.
   Seriously. For real. No joke.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:parser="http://chaperon.sourceforge.net/schema/syntaxtree/2.0"
    xmlns:lexus="http://www.mpi.nl/lexus" xmlns:mdf="http://lexus.mpi.nl/datcat/mdf/"
    exclude-result-prefixes="#all" version="2.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="marker[not(@value)] | marker[@value eq '']">
        <!-- marker is container with children so copy it -->
        <xsl:if
            test="/toolbox-import/lexus:meta/lexus:schema//lexus:container[@mdf:marker eq current()/@name]/mdf:container">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
