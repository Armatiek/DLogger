<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xslo="http://www.w3.org/1999/XSL/TransformAlias"
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    
    expand-text="yes"
    version="3.0"
    >
    <xsl:param name="stylesheet-path">unknown!</xsl:param>
    <xsl:param name="log-path">false</xsl:param>
    <xsl:param name="log-template">false</xsl:param>
    
    <xsl:namespace-alias stylesheet-prefix="xslo" result-prefix="xsl"/>
    
    <xsl:variable name="stylesheet-short-path" select="tokenize(replace($stylesheet-path,'\\','/'),'/xsl/')[last()]"/>
    
    <!-- stylesheet die wordt uitgevoerd op iedere xsl bij deployment naar de ontwikkelomgeving -->
    
    <xsl:template match="/xsl:stylesheet"><!-- reflexion see https://www.xml.com/pub/a/2003/11/05/xslt.html -->
        <xsl:choose>
            <xsl:when test="starts-with(comment()[1],'[dlogger]')">
                <xsl:sequence select="."/>
            </xsl:when>
            <xsl:when test="$log-path ne 'true' and $log-template ne 'true'">
                <xsl:sequence select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:copy-of select="@*"/>
                    <xsl:namespace name="dlogger-impl">http://www.armatiek.nl/xslweb/functions/dlogger</xsl:namespace>
                    <xsl:comment>[dlogger] This stylesheet has been deployed with dlogger-reflexion at {current-dateTime()}</xsl:comment>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- process constructs like: <xsl:sequence select="debug:save('regeling-doc', $regeling-doc)"/> -->
    <xsl:template match="xsl:*[@select]">
        <xsl:variable name="container" select="(ancestor::xsl:*[name(.) = ('xsl:function','xsl:template','xsl:stylesheet')])[last()]"/>
        <xsl:choose>
            <xsl:when test="$log-path = 'true' and starts-with(@select,'dlogger:save(')">
                <xsl:copy>
                    <xsl:attribute name="select">dlogger-impl:save-reflexion('{$stylesheet-short-path}','{local-name($container)}','{$container/@name}',{substring-after(@select,'dlogger:save(')}</xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'select')]"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$log-path = 'true' and starts-with(@select,'dlogger:init(')">
                <xsl:copy>
                    <xsl:attribute name="select">dlogger-impl:init({substring-after(@select,'dlogger:init(')}</xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'select')]"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$log-template = 'true' and starts-with(@select,'dlogger:comment(')">
                <xsl:copy>
                    <xsl:variable name="label">{substring-after(@select,'dlogger:comment(')}</xsl:variable>
                    <xsl:variable name="frag" select="($container/@name,$container/@match)[1]"/>
                    <xsl:variable name="mode" select="if ($container/@mode) then ' (' || $container/@mode || ')' else ()"/>
                    <xsl:attribute name="select">dlogger-impl:comment-reflexion('{$stylesheet-short-path}','{name($container)}{$mode}','{$frag} ',{$label}</xsl:attribute>
                    <xsl:apply-templates select="@*[not(name() = 'select')]"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>