<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:http="http://expath.org/ns/http-client"
    xmlns:config="http://www.armatiek.com/xslweb/configuration"
    
    xmlns:dlogger-impl="http://www.armatiek.nl/xslweb/functions/dlogger"
    >
    
    <!-- 
        For this external app, set all config:* parameters in webapp.xml 
    -->
    <xsl:param name="config:dlogger-mode" as="xs:boolean" select="false()"/>
    <xsl:param name="config:dlogger-proxy" as="xs:boolean" select="true()"/>
    
    <xsl:param name="config:dlogger-proxy-url" as="xs:string" select="'/set-in-webapp'"/>
    <xsl:param name="config:dlogger-viewer-url" as="xs:string" select="'/set-in-webapp'"/>
    <xsl:param name="config:dlogger-proxy-webapp-name" as="xs:string" select="'/set-in-webapp'"/>
    
    <!-- 
        import the DLogger code, which is distributed and should not be altered within the settings of the client app. 
        
        In this sample webapp, a reference is made to the webapp holding the Dlogger code; in other apps this should be a local copy.
    -->
    <xsl:import href="../../DLogger-common/xsl/DLogger.xsl"/>
    
    <xsl:variable name="dlogger-impl:webapp-name" select="$config:dlogger-proxy-webapp-name"/>
    
     <!-- 
        Implement a dlogger put. Pass key and value, return empty sequence. 
    -->
    <xsl:function name="dlogger-impl:put" as="empty-sequence()">
        <xsl:param name="atts" as="element(atts)"/>
        <xsl:variable name="request" as="element(http:request)">
            <http:request
                href="{$config:dlogger-proxy-url}"
                method="POST"
                send-authorization="false"
                >
                <http:body media-type="application/xml">
                    <xsl:sequence select="$atts"/>
                </http:body>
            </http:request>
        </xsl:variable>
        <xsl:variable name="response" select="http:send-request($request)"/>
        <xsl:sequence select="$response[3]"/><!-- empty at all times -->    
    </xsl:function>
    
    <!-- 
        Implement a dlogger get. Pass key, return optional string result. 
    -->
    <xsl:function name="dlogger-impl:get" as="xs:string?">
        <xsl:param name="key" as="xs:string"/>
        <xsl:variable name="request" as="element(http:request)">
            <http:request
                href="{$config:dlogger-proxy-url}?app={encode-for-uri($config:dlogger-proxy-webapp-name)}&amp;key={encode-for-uri($key)}"
                method="GET"
                send-authorization="false"
                override-media-type="text/plain"
                />
        </xsl:variable>
        <xsl:variable name="response" select="http:send-request($request)"/>
        <xsl:sequence select="if ($response[1]/@status ne '200') then ('#' || $response[1]/@status) else $response[2]"/>
    </xsl:function>
    
</xsl:stylesheet>