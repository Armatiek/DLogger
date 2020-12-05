<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    xmlns:dlogger="http://www.armatiek.nl/functions/dlogger"
    
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">
    
    <xsl:include href="../../DLogger-common/xsl/DLogger.xsl"/>
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- process this dlogger get -->
    <xsl:template match="/">
        <xsl:variable name="key" select="/req:request/req:parameters/req:parameter[@name = 'key']"/>
        <xsl:sequence select="context:get-attribute($key)"/>
    </xsl:template>
    
</xsl:stylesheet>