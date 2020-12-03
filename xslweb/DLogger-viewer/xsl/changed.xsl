<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    
    xmlns:file="http://expath.org/ns/file"
    
    xmlns:amf="http://www.armatiek.nl/functions" 
    xmlns:config="http://www.armatiek.com/xslweb/configuration"
    
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    expand-text="yes"
    version="3.0">
    
    <xsl:import href="common.xsl"/>
    
    <xsl:output method="text"/>
    
    <xsl:template match="/">
        <resp:response status="200">
            <resp:headers>
                <resp:header name="Content-type">text/plain;charset=UTF-8</resp:header>
            </resp:headers>  
            <resp:body>
                <xsl:variable name="datetime" select="context:get-attribute($webapp-name || '_datetime')"/><!-- gezet door de applicatie -->
                <xsl:variable name="datetime-read" select="context:get-attribute($webapp-name || '_datetimeread')"/><!-- gezet bij het uitlezen van de resources -->
                <xsl:value-of select="if (exists($datetime) and not($datetime = $datetime-read)) then amf:format-dateTime($datetime) else ''"/>
            </resp:body>
        </resp:response>
    </xsl:template>
    
    
</xsl:stylesheet>