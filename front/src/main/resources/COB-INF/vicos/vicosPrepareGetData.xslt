<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:h="http://apache.org/cocoon/request/2.0" xmlns:lexus="http://www.mpi.nl/lexus"
    version="2.0">

    <xsl:include href="../util/identity.xslt"/>

    <xsl:template match="json">
        <lexus:get-data>
            <id>
                <xsl:value-of select="parameters/id"/>
            </id>
        </lexus:get-data>
    </xsl:template>

</xsl:stylesheet>
