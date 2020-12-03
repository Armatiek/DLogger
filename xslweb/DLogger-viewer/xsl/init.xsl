<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    
    xmlns:file="http://expath.org/ns/file"
    
    xmlns:amf="http://www.armatiek.nl/functions" 
    
    xmlns:config="http://www.armatiek.com/xslweb/configuration"
    
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    expand-text="yes"
    version="3.0">
    
    <xsl:import href="common.xsl"/>
   
    <xsl:param name="config:webapp-dir" as="xs:string"/>
    <xsl:param name="config:store-folder" as="xs:string"/>
    
    <xsl:template match="/">
        <result webapp="{$webapp-name}">
            <xsl:try>
                <!-- haal het huidige record nummer op. Verwijder vervolgens alle attributen tot en met de laatste record. -->
                <xsl:variable name="last-recordnumber" select="(context:get-attribute($webapp-name || '_recordnumber'),0)[1]"/>
                <xsl:for-each select="1 to $last-recordnumber">
                    <xsl:variable name="recordnumber" select="."/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber, ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_stylesheet', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_containertype', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_containername', ())"/>
                    
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_label', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_file', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_ext', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_type', ())"/>
                    <xsl:sequence select="context:set-attribute($webapp-name || '_' || $recordnumber || '_value', ())"/>
                </xsl:for-each>
                <xsl:sequence select="context:set-attribute($webapp-name || '_recordnumber',0)"/>
                <xsl:value-of select="0"/>
                <xsl:catch>
                    <!-- TODO waarom geeft dit soms problemen?  -->
                    <xsl:value-of select="1"/>
                </xsl:catch>
            </xsl:try>
        </result>
    </xsl:template>
    
   
    
</xsl:stylesheet>