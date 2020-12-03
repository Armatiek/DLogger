@echo off

echo DEPLOYING -- DLOGGER FROM GITLAB -- 
  
set webapps_develop=D:\Projects\gitprojects\DLogger\xslweb
set webapps_deploy=c:\tools\xslweb\home\webapps

xcopy /E /S /Y /D ^
  "%webapps_develop%\DLogger-viewer\*.*" ^
  "%webapps_deploy%\DLogger-viewer"
  
xcopy /E /S /Y /D ^
  "%webapps_develop%\DLogger-common\*.*" ^
  "%webapps_deploy%\DLogger-common"
	
xcopy /E /S /Y /D ^
  "%webapps_develop%\DLogger-client\*.*" ^
  "%webapps_deploy%\DLogger-client"

rem FORFILES /p "%webapps_deploy%\DLogger-client\xsl" /m "*.xsl" /s /c "cmd /c %webapps_deploy%\DLogger-common\xsl\DLogger-deploy.bat @path"

echo done
