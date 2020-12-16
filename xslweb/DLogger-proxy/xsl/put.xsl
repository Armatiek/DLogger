<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    xmlns:dlogger="http://www.armatiek.nl/xslweb/functions/dlogger"
    
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">
    
    <xsl:include href="../../DLogger-common/xsl/DLogger.xsl"/>
    
    <!-- process this dlogger put -->
    <xsl:template match="/">
        <xsl:for-each select="/req:request/req:body/atts/att">
            <xsl:sequence select="context:set-attribute(@key,string(.))"/>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>