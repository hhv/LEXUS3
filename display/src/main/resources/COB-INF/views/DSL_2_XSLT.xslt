<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:target="target-namespace" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:display="http://www.mpi.nl/lexus/display/1.0" xmlns:lexus="http://www.mpi.nl/lexus"
	xmlns:rr="http://nl.mpi.lexus/resource-resolver"
	exclude-result-prefixes="#all" version="2.0">

	<xsl:namespace-alias stylesheet-prefix="target"
		result-prefix="xsl" />
	<xsl:strip-space elements="*" />
	<xsl:preserve-space elements="text" />
	<xsl:output indent="yes" />

	<xsl:param name="lexicon-id" select="''" />

	<xsl:template match="lexus:display">
		<target:stylesheet version="1.0">

			<target:strip-space elements="*" />
			<target:preserve-space elements="text" />

			<target:output indent="yes" />

			<target:template match="/">
				<display:page>
					<xsl:copy-of select="@*" />
					<display:style>
						<xsl:value-of select="style" />
						&#160;
					</display:style>
					<display:structure>
						<xsl:apply-templates select="structure" />
					</display:structure>
				</display:page>
			</target:template>

			<!--
				Display a data element that has a resource/multimedia element, use
				child element <value/>. <resource
				value="409dff22-1629-44b6-a294-687355d52ca4.jpg" archive="local"
				mimetype="image/jpeg" type="image"/>
			-->
			<target:template match="data[resource[@type = 'image']]"
				priority="1">
				<div dsl_class="resource">
					<div style="clear:left;" block="true">
						<target:attribute name="id">
							<target:value-of select="@id" />
						</target:attribute>
						<img>
							<target:attribute name="alt">
								<target:value-of select="concat(value, ' (the resource is currently unreacheble)')" />
							</target:attribute>
							<target:attribute name="src">
								<target:value-of
									select="concat('resource:',resource/@archive,':',resource/@value)" />
							</target:attribute>
							<target:element name="resource-id-to-url"
								namespace="http://nl.mpi.lexus/resource-resolver">
								<target:copy-of select="resource/@*" />
								<target:attribute name="lexiconId">
									<target:value-of select="'{$lexicon-id}'" />
								</target:attribute>
							</target:element>
						</img>
					</div>
					<div dsl_class="caption" block="true">
						<text>
							<target:value-of select="value" />
						</text>
					</div>
				</div>
			</target:template>

			<!--
				Display a data element, use child element <value/>.
			-->
			<target:template match="data">
				<text>
					<target:value-of select="value" />
				</text>
			</target:template>

			<!--
                Copy text not explicitly matched.
            -->
			<target:template match="text()" priority="2">
				<target:copy />
			</target:template>
		</target:stylesheet>
	</xsl:template>
	<xsl:template match="show[@type = 'dsl_show'][@optional = 'true']"
		priority="1">
		<xsl:choose>
			<xsl:when test="(not(@optional) or @optional eq 'true') and .//data">
				<target:if>
					<xsl:attribute name="test">
                <xsl:for-each select=".//data">
                    <xsl:variable name="d" select="." />
                    <xsl:text>.//data[@schema-ref='</xsl:text>
                    <xsl:value-of select="$d/@id" />
                    <xsl:text>']</xsl:text>
                    <xsl:if test="position() ne last()">
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
					<div>
						<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
						<xsl:apply-templates />
					</div>
				</target:if>
			</xsl:when>
			<xsl:otherwise>
				<div>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
					<xsl:apply-templates />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="show[@type = 'dsl_show']">
		<div>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
			<xsl:apply-templates />
		</div>
	</xsl:template>
	<xsl:template match="text">
		<xsl:copy>
			<xsl:copy-of select="@dsl_class" />
			<xsl:value-of select="translate(@value, ' ', '&#160;')" />
		</xsl:copy>
	</xsl:template>
	<!--
		A <data/> element in the DSL matches data elements in the LE based on
		their @schema-ref attribute.
	-->
	<xsl:template match="data">
		<div>
			<xsl:copy-of
				select="@*[local-name(.) != 'isBranch' and local-name(.) != 'id' and local-name(.) != 'type' and local-name(.) != 'name']" />
			<target:apply-templates select=".//data[@schema-ref = '{@id}']" />
		</div>
	</xsl:template>
	<!-- Process lists -->
	<xsl:template match="list">
		<target:for-each select=".//container[@schema-ref = '{@id}']">
			<xsl:apply-templates />
		</target:for-each>
	</xsl:template>
	<xsl:template match="container[@id]">
		<target:template match="container[@schema-ref eq '{@id}']">
			<xsl:apply-templates mode="apply" />
		</target:template>
	</xsl:template>




	<!--
		<table type="dsl_table" name="Table" isBranch="true"> <thead
		name="Heading" type="dsl_table_heading" isBranch="true"> <row
		type="dsl_table_row" isBranch="true" name="Table row"> <col
		type="dsl_table_column" name="Table column" isBranch="true"> <text
		name="text" value="Subentry" isBranch="false" type="dsl_text"/> </col>
		<col type="dsl_table_column" name="Table column" isBranch="true">
		<text name="text" value="Homonym number" isBranch="false"
		type="dsl_text"/> </col> </row> </thead> <tbody name="Table body"
		type="dsl_table_body" isBranch="true"> <list
		id="uuid:2c9090a21a6d44e9011a714ccb140253" name="SubentryGroup"
		type="container" isBranch="true"> <row type="dsl_table_row"
		name="Table row" isBranch="true"> <col type="dsl_table_column"
		name="Table column" isBranch="true"> <data
		id="uuid:2c9090a21a6d44e9011a714ccb1c027f" name="Subentry" type="data
		category" isBranch="false"/> </col> <col type="dsl_table_column"
		name="Table column" isBranch="true"> <data
		id="uuid:2c9090a21a6d44e9011a714ccb1c027b" name="Homonym number"
		type="data category" isBranch="false"/> </col> </row> </list> </tbody>
		</table>

-->
	<xsl:template match="table[@type = 'dsl_table']">
		<xsl:choose>
			<xsl:when test="(not(@optional) or @optional eq 'true') and .//data">
				<target:if>
					<xsl:attribute name="test">
                <xsl:for-each select=".//data">
                    <xsl:variable name="d" select="." />
                    <xsl:text>.//data[@schema-ref='</xsl:text>
                    <xsl:value-of select="$d/@id" />
                    <xsl:text>']</xsl:text>
                    <xsl:if test="position() ne last()">
                        <xsl:text> | </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:attribute>
					<xsl:copy>
						<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
						<xsl:apply-templates />
					</xsl:copy>
				</target:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
					<xsl:apply-templates />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template
		match="thead[@type eq 'dsl_table_heading'] | tbody[@type eq 'dsl_table_body']">
		<xsl:copy>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="row[@type eq 'dsl_table_row']">
		<xsl:choose>
			<xsl:when test="(not(@optional) or @optional eq 'true') and .//data">
				<target:if>
					<xsl:attribute name="test">
                        <xsl:for-each select=".//data">
                            <xsl:variable name="d" select="." />
                            <xsl:text>.//data[@schema-ref='</xsl:text>
                            <xsl:value-of select="$d/@id" />
                            <xsl:text>']</xsl:text>
                            <xsl:if test="position() ne last()">
                                <xsl:text> | </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:attribute>

					<tr>
						<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
						<xsl:apply-templates />
					</tr>
				</target:if>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
					<xsl:apply-templates />
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="thead//col[@type eq 'dsl_table_column']"
		priority="1">
		<th>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
			<xsl:apply-templates />
		</th>
	</xsl:template>
	<xsl:template match="col[@type eq 'dsl_table_column']">
		<td>
			<xsl:copy-of select="@*[local-name(.) != 'isBranch']" />
			<xsl:apply-templates />
		</td>
	</xsl:template>


	<xsl:template match="text()">
		<text>
			<xsl:copy />
		</text>
	</xsl:template>
	<xsl:template match="@*" mode="apply #default">
		<xsl:copy />
	</xsl:template>
</xsl:stylesheet>
