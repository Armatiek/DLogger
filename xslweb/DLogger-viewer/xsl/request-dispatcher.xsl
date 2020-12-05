<?xml version="1.0" encoding="UTF-8"?>
<!--$Id: request-dispatcher.xsl 608 2015-02-23 17:03:50Z arjanl $-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"  
  xmlns:req="http://www.armatiek.com/xslweb/request"
  xmlns:pipeline="http://www.armatiek.com/xslweb/pipeline"
  xmlns:config="http://www.armatiek.com/xslweb/configuration"
  xmlns:auth="http://www.armatiek.com/xslweb/auth"

  xmlns:ext="http://www.armatiek.com/xslweb/functions/custom" 
  
  xmlns:amf="http://www.armatiek.nl/functions" 
  
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:template match="/">
    
    <pipeline:pipeline>
      <xsl:sequence select="req:set-attribute('request',/)"/>
      <xsl:apply-templates/>
    </pipeline:pipeline>
  
  </xsl:template>
  
  <xsl:template match="/req:request[req:method = 'GET']">
    
    <xsl:choose>
      <xsl:when test="req:path = '/'"><!-- build the browser -->
        <pipeline:transformer name="GET-index" xsl-path="index.xsl" log="true"/>
      </xsl:when>
      <xsl:when test="starts-with(req:path,'/resources/')"><!-- get all resources/record, fills the index (ajax) --> 
        <pipeline:transformer name="GET-resources" xsl-path="resources.xsl" log="true">
          <pipeline:parameter name="webapp-name" type="xs:string">
            <pipeline:value >
              <xsl:value-of select="substring-after(req:path,'/resources/')"/>
            </pipeline:value>
          </pipeline:parameter>
        </pipeline:transformer>
      </xsl:when>
      <xsl:when test="starts-with(req:path,'/resource/')"><!-- fetch a single source (ajax)-->
        <pipeline:transformer name="GET-resource" xsl-path="resource.xsl" log="true">
          <pipeline:parameter name="webapp-name" type="xs:string">
            <pipeline:value >
              <xsl:value-of select="substring-after(req:path,'/resource/')"/>
            </pipeline:value>
          </pipeline:parameter>
        </pipeline:transformer>
      </xsl:when>
      <xsl:when test="starts-with(req:path,'/init/')"><!-- initialize dlogger -->
        <pipeline:transformer name="GET-init" xsl-path="init.xsl" log="true">
          <pipeline:parameter name="webapp-name" type="xs:string">
            <pipeline:value >
              <xsl:value-of select="substring-after(req:path,'/init/')"/>
            </pipeline:value>
          </pipeline:parameter>
        </pipeline:transformer>
      </xsl:when>
      <xsl:when test="starts-with(req:path,'/changed/')"><!-- has something changed in the webapp, must reload? (ajax) -->
        <pipeline:transformer name="GET-changed" xsl-path="changed.xsl" log="true">
          <pipeline:parameter name="webapp-name" type="xs:string">
            <pipeline:value >
              <xsl:value-of select="substring-after(req:path,'/changed/')"/>
            </pipeline:value>
          </pipeline:parameter>
        </pipeline:transformer>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  
</xsl:stylesheet>