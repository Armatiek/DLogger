<?xml version="1.0" encoding="UTF-8"?>
<!--$Id: request-dispatcher.xsl 608 2015-02-23 17:03:50Z arjanl $-->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"  
  xmlns:pipeline="http://www.armatiek.com/xslweb/pipeline"
  
  xmlns:dlogger="http://www.armatiek.nl/functions/dlogger"
  
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xsl:include href="../../DLogger-common/xsl/DLogger.xsl"/>
  
  <xsl:template match="/">
    <pipeline:pipeline>
      <xsl:sequence select="dlogger:init()"/>
      <pipeline:transformer name="sample" xsl-path="sample.xsl" log="false"/>
    </pipeline:pipeline>
  </xsl:template>
  
</xsl:stylesheet>