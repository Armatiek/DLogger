<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    
    xmlns:file="http://expath.org/ns/file"
    
    xmlns:amf="http://www.armatiek.nl/functions" 
    
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    expand-text="yes"
    version="3.0">
    
    <xsl:import href="common.xsl"/>

    <xsl:template match="/">
        <resp:response status="200"> 
            <resp:headers>
                <resp:header name="Content-type">text/html;charset=UTF-8</resp:header>
            </resp:headers>  
            <resp:body>
                <html>
                    <body>
                        <table class="searchable">
                            <thead>
                                <th>nr</th>
                                <th>label</th>
                                <th>type</th>
                                <th>value</th>
                            </thead>
                            <tbody>
                                <xsl:for-each select="1 to xs:integer(context:get-attribute($webapp-name || '_recordnumber'))">
                                    <xsl:variable name="sheet" select="context:get-attribute($webapp-name || '_' || . || '_stylesheet')"/>
                                    <xsl:variable name="ctype" select="context:get-attribute($webapp-name || '_' || . || '_containertype')"/>
                                    <xsl:variable name="cname" select="context:get-attribute($webapp-name || '_' || . || '_containername')"/>
                                    
                                    <xsl:variable name="label" select="context:get-attribute($webapp-name || '_' || . || '_label')"/>
                                    <xsl:variable name="file"  select="context:get-attribute($webapp-name || '_' || . || '_file')"/>
                                    <xsl:variable name="ext"   select="context:get-attribute($webapp-name || '_' || . || '_ext')"/>
                                    <xsl:variable name="type"  select="context:get-attribute($webapp-name || '_' || . || '_type')"/>
                                    <xsl:variable name="dtype" select="context:get-attribute($webapp-name || '_' || . || '_datatype')"/>
                                    <xsl:variable name="value" select="context:get-attribute($webapp-name || '_' || . || '_value')"/>
                                    
                                    <xsl:variable name="label-toks" select="tokenize($label,':')"/>
                                    <xsl:variable name="label-class" select="if (empty($label-toks[2])) then () else $label-toks[1]"/><!-- any class, e.g. error, warning, info, etc. -->
                                    
                                    <xsl:variable name="ashtml" select="if ($type = ('parms','map')) then 'true' else 'false'"/>
                                    
                                    <tr class="info {$label-class}">
                                        <td class="nr">{.}</td>
                                        <td class="label">
                                            <a href="javascript:selectRecord('{$webapp-name}','{.}','{$file}.{$ext}','{$label}',{$ashtml})">{$label}</a>
                                        </td>
                                        <td class="type">{$dtype}</td>
                                        <td class="value">{$value}</td>
                                    </tr>
                                    <xsl:if test="$sheet">
                                        <tr class="context">
                                            <td/>
                                            <td colspan="3">
                                                <span class="context-stylesheet">
                                                    <xsl:value-of select="substring-after($sheet,'/' || $webapp-name || '/xsl/')"/>
                                                </span>
                                                <span class="context-containertype">
                                                    <xsl:value-of select="$ctype"/>
                                                </span>
                                                <span class="context-containername">
                                                    <xsl:value-of select="$cname"/>
                                                </span>
                                                <span class="context-label"><!-- for fast search -->
                                                    <xsl:value-of select="$label"/>
                                                </span>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    
                                </xsl:for-each>
                                <xsl:variable name="datetime-read" select="string(context:get-attribute($webapp-name || '_datetime'))"/><!-- gezet door de applicatie -->
                                <xsl:sequence select="context:set-attribute($webapp-name || '_datetimeread',$datetime-read)"/><!-- uitgelezen door "changed" -->
                            </tbody>
                        </table>
                    </body>
                </html>
            </resp:body>
        </resp:response>
        
    </xsl:template>
    
</xsl:stylesheet>