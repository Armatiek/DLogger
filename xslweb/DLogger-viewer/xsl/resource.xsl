<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    xmlns:file="http://expath.org/ns/file"
    
    xmlns:amf="http://www.armatiek.nl/functions" 
    xmlns:config="http://www.armatiek.com/xslweb/configuration"
    
    xmlns:local="urn:local" 
   
    expand-text="yes"
    version="3.0">
    
    <xsl:import href="common.xsl"/>
    <xsl:param name="config:store-folder"/>
    
    <xsl:output omit-xml-declaration="true"/>
    
    <xsl:variable name="passed-record" select="amf:get-parameter('record')"/>
    <xsl:variable name="passed-mode" select="amf:get-parameter('mode')"/>
    
    <xsl:template match="/">
        <xsl:variable name="content" select="context:get-attribute($webapp-name || '_' || $passed-record)"/>
        <xsl:variable name="type" select="context:get-attribute($webapp-name || '_' || $passed-record || '_type')"/>
        <xsl:variable name="ext" select="context:get-attribute($webapp-name || '_' || $passed-record || '_ext')"/>
        <xsl:variable name="hljs-type" select="
            if ($ext = 'xml') then 'language-xml' else 
            if ($ext = 'json') then 'language-json' else 
            if ($ext = 'html') then 'language-html' else 
            if ($ext = 'xhtml') then 'language-xml' else 
            'plaintext'"/>
        <xsl:variable name="content-is-url" select="matches(string($content),'^(http(s)?|file|xslweb)://.*$')" as="xs:boolean"/>
        <xsl:choose>
            <xsl:when test="$passed-record and $passed-mode = 'ashtml' and $type = 'parms'">
                <xsl:variable name="xml" select="parse-xml($content)" as="document-node()"/>
                <xsl:choose>
                    <xsl:when test="$xml/dlogger-map">
                        <xsl:sequence select="local:get-map($xml)"/>
                    </xsl:when>
                    <xsl:when test="$xml/req:request">
                        <xsl:sequence select="local:get-parameters($xml)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$passed-record and $passed-mode = 'ashtml'">
                <xsl:sequence select="parse-xml($content)"/>
            </xsl:when>
            <xsl:when test="$passed-record and $passed-mode = 'content' and $content-is-url">
                <a href="{$content}" target="DLogger-load" xsl:exclude-result-prefixes="#all">
                    <code>
                        <xsl:sequence select="$content"/>
                    </code>
                </a>
            </xsl:when>
            <xsl:when test="$passed-record and $passed-mode = 'content'">
                <code class="hljs {$hljs-type}" xsl:exclude-result-prefixes="#all">
                    <xsl:sequence select="$content"/><!-- https://github.com/highlightjs/highlight.js/issues/866 -->
                </code>
            </xsl:when>
            <xsl:when test="$passed-record and $passed-mode = 'download'">
                <xsl:variable name="mime">
                    <xsl:choose>
                        <xsl:when test="$ext = 'xml'">application/xml</xsl:when>
                        <xsl:when test="$ext = 'json'">application/json</xsl:when>
                        <xsl:otherwise>text/plain</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <resp:response status="200">
                    <resp:headers>
                        <resp:header name="Content-type">{$mime};charset=UTF-8</resp:header>
                    </resp:headers>  
                    <resp:body>
                        <xsl:try>
                            <xsl:choose>
                                <xsl:when test="$ext = 'xml'">
                                    <xsl:sequence select="parse-xml($content)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:sequence select="$content"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:catch>
                                <xsl:sequence select="$content"/>
                            </xsl:catch>
                        </xsl:try>
                    </resp:body>
                </resp:response>  
            </xsl:when>
            <xsl:otherwise>
                <code>UNKNOWN RECORD ID</code>
            </xsl:otherwise>
        </xsl:choose>
       
    </xsl:template>
    
    <xsl:function name="local:get-parameters" as="element(html)">
        <xsl:param name="content" as="document-node(element(req:request))"/>
        <html>
            <head>
                <link href="{$webapp-loc}/assets/css/parms.css" rel="stylesheet"/>
            </head>
            <body>
                <xsl:variable name="parms" as="element(parm)*">
                    <xsl:for-each select="$content/req:request/req:parameters/req:parameter">
                        <parm name="{@name}">
                            <xsl:for-each select="req:value">
                                <val type="xs:string">{.}</val> 
                            </xsl:for-each>
                        </parm>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="local:parms-table('Parameters', $parms)"/>
                
                <xsl:variable name="parms" as="element(parm)*">
                    <xsl:for-each select="$content/req:request/req:attributes/req:attribute">
                        <parm name="{@name}">
                            <val type="xs:string">{.}</val> 
                        </parm>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="local:parms-table('Request attributes', $parms)"/>
            </body>
        </html>
    </xsl:function>
    
    <xsl:function name="local:get-map" as="element(html)">
        <xsl:param name="map" as="document-node(element(dlogger-map))"/>
        <html>
            <head>
                <link href="{$webapp-loc}/assets/css/parms.css" rel="stylesheet"/>
            </head>
            <body>
                <xsl:variable name="map" as="element(parm)*">
                    <xsl:for-each select="$map/dlogger-map/dlogger-map-entry">
                        <parm name="{@key}">
                            <xsl:for-each select="dlogger-map-value">
                                <val type="{@dlogger-type}">{.}</val> 
                            </xsl:for-each>
                        </parm>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:sequence select="local:parms-table('Map', $map)"/>
            </body>
        </html>
    </xsl:function>
    
    <xsl:function name="local:parms-table" as="element()*">
        <xsl:param name="title" as="xs:string"/>
        <xsl:param name="parms" as="element(parm)*"/>
        <h1>{$title}</h1>
        <xsl:choose>
            <xsl:when test="exists($parms)">
                <table class="parms">
                    <xsl:for-each select="$parms">
                        <xsl:sort select="@name"/>
                        <tr>
                            <td>{@name}</td>
                            <td>
                                <xsl:for-each select="val">
                                    <xsl:value-of select="."/>
                                    <span class="parms-type"> ({@type})</span>
                                    <xsl:if test="position() ne last()">
                                        <br/>
                                    </xsl:if>
                                </xsl:for-each>
                            </td>
                        </tr>    
                    </xsl:for-each>
                </table>
            </xsl:when>
            <xsl:otherwise>
                <p>None</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>