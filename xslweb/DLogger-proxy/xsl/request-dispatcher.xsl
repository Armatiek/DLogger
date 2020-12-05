<?xml version="1.0" encoding="UTF-8"?>
<!--$Id: request-dispatcher.xsl 608 2015-02-23 17:03:50Z arjanl $-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"  
  xmlns:req="http://www.armatiek.com/xslweb/request"
  xmlns:pipeline="http://www.armatiek.com/xslweb/pipeline"
  
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:template match="/">
    
    <pipeline:pipeline>
      <xsl:apply-templates/>
    </pipeline:pipeline>
  
  </xsl:template>
  
  <xsl:template match="/req:request[req:method = 'GET']">
    <pipeline:transformer name="get" xsl-path="get.xsl" log="true"/>
  </xsl:template>
  
  <xsl:template match="/req:request[req:method = 'POST']">
    <pipeline:transformer name="put" xsl-path="put.xsl" log="true"/>
  </xsl:template>
  
</xsl:stylesheet>