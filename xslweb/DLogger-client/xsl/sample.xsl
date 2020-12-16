<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:amf="http://www.armatiek.nl/functions"
 
    xmlns:dlogger="http://www.armatiek.nl/xslweb/functions/dlogger"
    
    exclude-result-prefixes="#all"
    expand-text="yes"
    version="3.0">
    
    <xsl:include href="../../DLogger-common/xsl/DLogger.xsl"/>

    <xsl:variable name="hello" as="element()">
        <hello galaxy="Milkyway">Wide world</hello>
    </xsl:variable>
    
    <xsl:variable name="hello-world" as="element()">
        <p><i>Hello,</i> world!</p>
    </xsl:variable>
    
    <xsl:variable name="week" as="map(xs:string, item()*)">
        <xsl:map>
            <xsl:map-entry key="'Mo'" select="'Monday'"/>
            <xsl:map-entry key="'Tu'" select="'Tuesday'"/>
            <xsl:map-entry key="'We'" select="'Wednesday'"/>
            <xsl:map-entry key="'Th'" select="'Thursday'"/>
            <xsl:map-entry key="'Fr'" select="'Friday'"/>
            <xsl:map-entry key="'Sa'" select="'Saturday'"/>
            <xsl:map-entry key="'Su'" select="('Sunday',1)"/>
        </xsl:map>
    </xsl:variable>
    
    <xsl:template name="main" match="/">
        <result>
            This app produces no serious output.
            Just DLogs.
            
            <xsl:sequence select="dlogger:save('string','Hello!')"/>
            <xsl:sequence select="dlogger:save('hello variable',$hello)"/>
            <xsl:sequence select="dlogger:save('hello variable (native)',$hello,'native.xml')"/>
            <xsl:sequence select="dlogger:save('hello variable (content)',$hello/node())"/>
            <xsl:sequence select="dlogger:save('hello variable (attribute)',$hello/@galaxy)"/>
            <xsl:sequence select="dlogger:save('sequence (of integer)',(1, 3, 5))"/>
            <xsl:sequence select="dlogger:save('sequence (of item)',(1, $hello))"/>
            <xsl:sequence select="dlogger:save('HTML fragment',$hello-world)"/>
            <xsl:sequence select="amf:my-function()"/>
            <xsl:sequence select="dlogger:save('Request',/)"/>
            <xsl:sequence select="dlogger:save('Request parameters',/,'parms')"/>
            <xsl:sequence select="dlogger:save('Map',$week)"/>
            <xsl:sequence select="dlogger:save('Map (as html)',$week,'parms')"/>
        </result>
    </xsl:template>
    
    <xsl:function name="amf:my-function">
        <xsl:sequence select="dlogger:save('string within function','Hello again!')"/>
    </xsl:function>
    
</xsl:stylesheet>
