<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lexus="http://www.mpi.nl/lexus" version="2.0">
    <!--
        
        Input is:
        <data>
        <get-lexical-entry>
        <lexicon>1</lexicon>
        <id>25</id>
        </get-lexical-entry>
        <user>...</user>
        </data>
        
        Generate the following information from the database:
        
        <lexical-entry id="uuid:d99c60dd-f316-4919-b18e-0e50556c45ec" schema-id="uuid:9e1dbc3c-55d1-4ba2-96b8-391f779a16ab">
        <container id="uuid:dac9139b-17cb-4c02-be63-bb6977b12775" schema-id="uuid:6b9f1ff4-6349-4c08-96ad-d04d29533813"/>
        <container id="uuid:6fa1e63a-8c07-46cf-bacc-f3ebe37fa6e4" schema-id="uuid:c27cd277-9852-4fd8-94bb-7909e25fdd8c">
            ....
        </lexical-entry>
    -->
    <xsl:include href="../util/identity.xslt"/>
    <xsl:include href="../util/encodeXML.xslt"/>
    <xsl:include href="../util/xquery-components.xslt"/>
    
    <xsl:param name="lexica-collection"/>

    <xsl:template match="lexus:get-lexical-entry">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <lexus:query>
                <lexus:text>
                    <xsl:call-template name="declare-namespace"/> 
                    
                    let $data := <xsl:apply-templates select="." mode="encoded"/>
                    let $id := $data/id
                    let $user-id := '<xsl:value-of select="/data/user/@id"/>'
                    let $lexus :=
                        if ($data/lexicon ne '')
                            then collection('<xsl:value-of select="$lexica-collection"/>')/lexus[@id = $data/lexicon]
                            else
                                let $lexica := collection('<xsl:value-of select="$lexica-collection"/>')/lexus[meta/users/user/@ref = $user-id]
                                return $lexica[lexicon/lexical-entry[@id = $id]] 
                    let $lexiconId := $lexus/@id
                    let $lexicalEntry := $lexus/lexicon/lexical-entry[@id = $id]
                    
                    return element result {
                        attribute lexicon { $lexiconId },
                        $lexicalEntry,
                        $lexus/meta/users/user[@ref = $user-id]/permissions,
                        $lexus/meta/schema
                    }
                </lexus:text>
            </lexus:query>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
