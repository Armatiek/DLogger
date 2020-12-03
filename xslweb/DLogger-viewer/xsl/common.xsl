<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    
    xmlns:file="http://expath.org/ns/file"

    xmlns:amf="http://www.armatiek.nl/functions" 
    
    expand-text="yes"
    version="3.0">
    
    <xsl:param name="webapp-name" as="xs:string?"/> <!-- wordt opgehaald in request dispatcher uit formaat /init/xxx -->
    
    <xsl:variable name="request" select="req:get-attribute('request')/req:request" as="element(req:request)"/>
    <xsl:variable name="webapp-loc" select="$request/req:context-path || $request/req:webapp-path"/>
    
    <!-- 
        return the parameter value if set, or an empty sequence. Clean up the parameter value. There may be several parameter values! 
    -->
    <xsl:function name="amf:get-parameter" as="item()*">
        <xsl:param name="name"/>
        <xsl:sequence select="$request/req:parameters/req:parameter[@name = $name]/req:value/node()"/>
    </xsl:function>
    
    <xsl:function name="amf:format-dateTime">
        <xsl:param name="datetime" as="xs:dateTime"/>
        <xsl:value-of select="format-dateTime($datetime, '[Y0001]-[M01]-[D01] at [H01]:[m01]:[s01]')"/>
    </xsl:function>
    
</xsl:stylesheet>