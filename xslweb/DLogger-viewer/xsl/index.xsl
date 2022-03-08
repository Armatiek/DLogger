<xsl:stylesheet
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    xmlns:basex="http://basex.org/rest"
    xmlns:basex-proxy="http://www.armatiek.nl/basex-proxy"
    
    xmlns:http="http://expath.org/ns/http-client"
    
    xmlns:req="http://www.armatiek.com/xslweb/request"
    xmlns:session="http://www.armatiek.com/xslweb/session"
    xmlns:resp="http://www.armatiek.com/xslweb/response" 
    
    xmlns:amf="http://www.armatiek.nl/functions" 
    xmlns:cb="http://www.armatiek.nl/componenten-bibliotheek" 
    
    xmlns:file="http://expath.org/ns/file"
    
    xmlns:saxon="http://saxon.sf.net/"
    xmlns:query="http://www.armatiek.nl/xquery-store"
    
    xmlns:config="http://www.armatiek.com/xslweb/configuration"
    xmlns:context="http://www.armatiek.com/xslweb/functions/context"
    
    expand-text="yes"
    version="3.0">
    
    <xsl:output 
        exclude-result-prefixes="#all" 
        encoding="UTF-8"
        method="html" 
        html-version="5"
    />
    
    <xsl:import href="common.xsl"/>
    
    <xsl:variable name="passed-visual" select="amf:get-parameter('visual')"/>
    
    <xsl:variable name="background-color" select="
        if ($passed-visual = 'yellow') then '#ffffcf' else 
        if ($passed-visual = 'blue') then '#e6faf7' else 
        if ($passed-visual = 'red') then '#ffe6de' else 
        if ($passed-visual = 'green') then '##e3ffde' else 
        if ($passed-visual = 'orange') then '#fbdeb2' else 
        'white'"/>
    
    <xsl:template match="/">
        
        <xsl:variable name="dlogger-release" select="doc('../static/release/release.xml')/release-info/release[artifact = 'DLogger viewer']"/>
      
        <xsl:variable name="active-webapps" select="for $w in tokenize(context:get-attribute('dlogger_webapps'),';') return if (normalize-space($w)) then $w else ()" as="xs:string*"/>
        
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>DLogger</title>
                <link href="{$webapp-loc}/assets/css/bootstrap.min.css" rel="stylesheet"/><!-- https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css -->
                <link href="{$webapp-loc}/assets/css/local.css" rel="stylesheet"/>
                <link href="{$webapp-loc}/assets/css/two-pane.css" rel="stylesheet"/>
            </head>
            <body style="background: {$background-color};">
                <!--<form  autocomplete="on">-->
                <div id="dlogger-header">Dlogger (C) Armatiek BV | Version {$dlogger-release/major-minor}.{$dlogger-release/bugfix}</div>
                <div class="container wrapper">
                    <div id="index-pane" >
                        <nav class="index-nav">
                            <h4><a href="https://armatiek.nl/respec/doc/report/armatiek/respec/DLogger/DLogger.html" target="DLogger-doc">DLogger</a> - <span id="span-run">(no run yet)</span></h4>
                            
                            <div class="dropdown" style="display: inline;">
                                <button id="field-webapp-name" name="field-webapp-name" class="btn btn-outline-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <xsl:value-of select="if (count($active-webapps) = 1) then $active-webapps else 'Choose a client'"/>
                                </button>
                                <div class="dropdown-menu" aria-labelledby="field-webapp-name">
                                    <xsl:for-each select="$active-webapps">
                                        <a class="dropdown-item" href="#">{.}</a>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <button id="index-button" class="btn btn-primary btn-sm mx-2" >Refresh</button>
                            <input id="check-refresh" class="refresh" type="checkbox" value="dezewaarde" checked="checked"/>
                            <label class="refresh" for="check-refresh">Live</label>
                            <button id="restart-button" class="btn btn-warning btn-sm mx-2" >Restart</button>
                        </nav>
                        <div id="index-search-wrapper">
                            <input type="text" id="search-records" placeholder="Search..."/>
                        </div>
                        <div id="index-pane-wrapper">
                            <div id="index-pane-body">
                                <div id="index">
                                    <!-- hook here -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="content-pane">
                        <nav class="content-nav">
                            <h4>&#160;</h4>
                            <input id="field-dlogger-label" name="field-dlogger-label" type="text" autocomplete="off" value=""/>
                            <a id="html-button" href="#" class="btn btn-primary btn-sm mx-2 disabled" aria-disabled="true" role="button">Show HTML</a>
                            <a id="load-button" href="#" class="btn btn-primary btn-sm mx-2 disabled" aria-disabled="true" role="button" target="DLogger-load">load</a>
                            <a id="download-button" href="#" class="btn btn-primary btn-sm mx-2 disabled" aria-disabled="true" role="button">download</a>
                        </nav>
                        <div id="content-search-wrapper">
                            <input type="text" id="search-content" placeholder="Search..."/>
                        </div>
                        <div id="content-pane-wrapper">
                            <div id="content-pane-body" style="display: block;">
                                <pre id="content">
                                    <!-- hook here -->
                                </pre>    
                            </div>
                            <div id="content-pane-body-ashtml" style="display: none;">
                                <iframe/>
                                <!-- set src attribute here -->
                            </div>
                            
                        </div>
                    </div>
                </div>
                <div aria-live="polite" aria-atomic="true" class="d-flex justify-content-center align-items-center toast-wrapper">
                    <div id="toast-reloaded" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-delay="1000">
                        <div class="toast-body">
                            <xsl:sequence select="'Reloaded!'"/>
                        </div>
                    </div>
                </div>
                <!--</form>-->
                <!-- jquery -->
                <script src="{$webapp-loc}/assets/js/jquery.min.js"/><!-- https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js -->
               
                <!-- dropdown bootstrap requirement -->
                <script src="{$webapp-loc}/assets/js/popper.min.js"/><!-- https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js -->
                
                <!-- bootstrap itself -->
                <script src="{$webapp-loc}/assets/js/bootstrap.min.js"/><!-- https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js -->
                
                <!-- text highlighting -->
                <script src="{$webapp-loc}/assets/js/jquery.highlight-5.js"/><!-- https://johannburkard.de/blog/programming/javascript/highlight-javascript-text-higlighting-jquery-plugin.html -->

                <!-- hljs -->
                <link rel="stylesheet" href="{$webapp-loc}/assets/css/hljs.default.min.css"/>
                <script src="{$webapp-loc}/assets/js/hljs.highlight.min.js"/>
                <script>hljs.initHighlightingOnLoad();</script>
                
                <script>
                    <!-- expanded text; initialisatie van variabelen --> 
                    
                    var webappContext = "{$webapp-loc}";
                    var ashtml = false;
                </script>

                <script type="text/javascript" xsl:expand-text="no"><![CDATA[
                    // call built by xslweb stylesheet
                    function selectRecord(webapp,nr,filename,label,initAshtml) {
                        ashtml = initAshtml;
                        var url = webappContext + '/resource/' + webapp + '?record=' + nr;
                        $("#download-button").attr("href",url + "&mode=download");
                        $("#download-button").attr("download",filename);
                        $("#download-button").attr("aria-disabled",false);
                        $("#download-button").removeClass("disabled");
                        $("#download-button").text("Download " + filename);
                        $("#load-button").attr("href",url + "&mode=download");
                        $("#load-button").attr("aria-disabled",false);
                        $("#load-button").removeClass("disabled");
                        $("#html-button").attr("aria-disabled",false);
                        $("#html-button").removeClass("disabled");
                        if (ashtml) {
                            $('#content-pane-body').hide();
                            $('#content-pane-body-ashtml').show();
                            $('#field-dlogger-label').val(label);
                            $('#html-button').text("Show code");
                            $("#html-button").attr("href","javascript:selectRecord('" + webapp + "'," + nr + ",'" + filename + "','" + label + "', false);");
                            $('#html-button').click();
                            $("iframe").attr("src",url + "&mode=ashtml")
                        } else {
                            $('#content-pane-body-ashtml').hide();
                            $('#content-pane-body').show();
                            $.ajax({
                                url : url + "&mode=content",
                                type: 'GET'
                            }).done(function(response){
                                $('#field-dlogger-label').val(label);
                                $('#html-button').text("Show HTML");
                                $("#html-button").attr("href","javascript:selectRecord('" + webapp + "'," + nr + ",'" + filename + "','" + label + "', true);");
                                $('#html-button').click();
                                $("#content").html(response);
                                $('#content-pane-wrapper').scrollTop(0);
                                document.querySelectorAll('code').forEach((block) => {
                                  hljs.highlightBlock(block);
                                });
                            });
                        }
                    };
                ]]></script>
                
                <script type="text/javascript" xsl:expand-text="no"><![CDATA[
                    $(document).ready(function(){
                      // refresh button
                      $("#index-button").click(function(){
                        $.ajax({
                            url : webappContext + "/resources/" + $("#field-webapp-name").text(),
                            type: 'GET'
                        }).done(function(response){
                            $('#index').html(response);
                            $("#index table tr.info").click(function() {
                                var selected = $(this).hasClass("highlight");
                                $("#index table tr").removeClass("highlight");
                                if (!selected)
                                    $(this).addClass("highlight");
                            });
                        });
                      });
                      // restart button
                      $("#restart-button").click(function(){
                        $.ajax({
                            url : webappContext + "/init/" + $("#field-webapp-name").text(),
                            type: 'GET'
                        }).done(function(response){
                            $('#index').html("<b>Restarted</b>");
                            $("#download-button").attr("aria-disabled",true);
                            $("#download-button").addClass("disabled");
                            $("#load-button").attr("aria-disabled",true);
                            $("#load-button").addClass("disabled");
                            $("#html-button").attr("aria-disabled",true);
                            $("#html-button").addClass("disabled");
                        });
                      });
                      
                      // reread the resources, effective when the list has changed.
                      function reRead() {
                          if ($('#check-refresh').prop('checked')) { 
                               $.ajax({
                                    url : webappContext + "/changed/" + $("#field-webapp-name").text(),
                                    type: 'GET'
                                }).done(function(response){
                                     if (response != '') {
                                       $('#span-run').text(response);
                                       $('#index-button').click();
                                       $('#content').html('<i>Please select a record in left pane to view its value</i>')
                                       $('#toast-reloaded').toast('show');
                                    } 
                                    //else
                                    //   $('#span-run').text('idle');
                                    
                                });
                          }
                      }
                      setInterval(reRead,3000);
                     
                      // searchbox, search the labels
                      $("#search-records").on("keyup", function() {
                        var value = $(this).val().toLowerCase();
                        $("#index table tr.info").filter(function() {
                          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                        });
                      });
                      // searchbox, search the content of the preview pane
                      $("#search-content").on("keyup", function() {
                        var value = $(this).val().toLowerCase();
                        $("#content").removeHighlight();
                        $("#content").highlight(value);
                      });
                      // webapp selection dropdown:shen selected, set text to name of webapp.
                      $(".dropdown-item").on("click", function() {
                          $("#field-webapp-name").text($(this).text());
                      });
                     
                    });
                   ]]>
                </script>
                  
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>