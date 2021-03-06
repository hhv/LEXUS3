<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lexus="http://www.mpi.nl/lexus"
    xmlns:zip="http://expath.org/ns/zip" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
    xmlns:java="java:org.expath.saxon.Zip" version="2.0">
    <xsl:param name="zipFile"/>
    <xsl:function name="zip:entries" as="element(zip:file)">
        <xsl:param name="href" as="xs:string"/>
        <xsl:sequence select="java:entries($href)"/>
    </xsl:function>

    <xsl:function name="zip:xml-entry" as="document-node()">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:xml-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:html-entry" as="document-node()">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:html-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:text-entry" as="xs:string">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:text-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:binary-entry" as="xs:base64Binary">
        <xsl:param name="href" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:sequence select="java:binary-entry($href, $path)"/>
    </xsl:function>

    <xsl:function name="zip:zip-file">
        <!-- as="empty()" -->
        <xsl:param name="zip" as="element(zip:file)"/>
        <xsl:sequence select="java:zip-file($zip)"/>
    </xsl:function>

    <xsl:function name="zip:update-entries">
        <!-- as="empty()" -->
        <xsl:param name="zip" as="element(zip:file)"/>
        <xsl:param name="output" as="xs:string"/>
        <xsl:sequence select="java:update-entries($zip, $output)"/>
    </xsl:function>

    <xsl:output indent="yes"/>

    <xsl:variable name="zipFileId" select="/data/json/parameters"/>
    <xsl:variable name="zip" select="concat('file:/tmp/',$zipFileId,'.zip')"/>
    <xsl:variable name="zipDir" select="zip:entries(resolve-uri($zip))"/>
    <xsl:param name="format" select="''"/>
    
     <!-- --> <xsl:include href="format/RELISH-LL-LMF-to-LEXUS-mode.xsl"/> <!-- -->
	 <xsl:template match="/" >
    
     <xsl:element name="data">
       <xsl:copy-of select="data/user"/>
       <xsl:choose>  
       <xsl:when test="$format = 'Lexus3XML'">
	        <xsl:apply-templates select="$zipDir" mode="LEXUS3XML"/>
		</xsl:when>
		<xsl:when test="$format = 'relish-ll-lmf-to-lexus'">
			<xsl:message>DBG: welcome to RELISH-LL-LMF to LEXUS</xsl:message>
			<xsl:apply-templates select="$zipDir" mode="relish-ll-lmf"/>
		</xsl:when>
    </xsl:choose>
 	</xsl:element>
    </xsl:template>
    
    <!--  LEXUS3XML -->
    
   <xsl:template match="zip:file" mode="LEXUS3XML">
          <xsl:variable name="schema_file" select="zip:entry[ends-with(@name, 'internal_schema.xml')]"/>
          <xsl:variable name="data_file" select="(zip:entry except $schema_file)[1]"/>
          <xsl:apply-templates select="zip:xml-entry($zip,$schema_file/@name)//lexus:meta" mode="LEXUS3XML"/> 
          <xsl:apply-templates select="zip:xml-entry($zip,$data_file/@name)//lexus:lexicon" mode="LEXUS3XML"/>
    </xsl:template>

    <xsl:template match="lexus:lexicon" mode="LEXUS3XML">
            <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="lexus:meta" mode="LEXUS3XML">
      	<xsl:copy-of select="."/>        
    </xsl:template>
    
    <!-- relish-ll-lmf -->
    
    <xsl:template match="zip:file" mode="relish-ll-lmf">
    	<xsl:message>DBG: zip:file[<xsl:value-of select="string-join(zip:entry/@name,', ')"/>][<xsl:value-of select="string-join(zip:entry/zip:xml-entry($zip,@name)/name(*),', ')"/>]</xsl:message>
    	<!-- <xsl:variable name="xsl" select="saxon:compile-stylesheet(doc('format/RELISH-LL-LMF-to-LEXUS.xsl'))"/> -->
    	<xsl:message>DBG: compiled stylesheet</xsl:message>
    	<xsl:for-each select="zip:entry">
    	    <xsl:message>DBG: entry[<xsl:value-of select="@name"/>]</xsl:message>
    	    <xsl:variable name="doc" select="zip:xml-entry($zip,@name)"/>
    	    <xsl:message>DBG: root[<xsl:value-of select="$doc/name(*)"/>]</xsl:message>
    		<xsl:if test="$doc/name(*)='lmf:LexicalResource'">
    			<xsl:message>DBG: found a RELISH-LL-LMF lexicon</xsl:message>
    			<!-- <xsl:copy-of select="saxon:transform($xsl,$doc/*)/data/*"/> -->
    			<xsl:apply-templates select="$doc/*" mode="relish-ll-lmf"/>
    			<xsl:message>DBG: converted a RELISH-LL-LMF lexicon</xsl:message>
   			</xsl:if>
    	</xsl:for-each>
    </xsl:template>
   
</xsl:stylesheet>