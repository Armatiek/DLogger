@echo off

rem ----------------------------------------------------------------------------------------
rem Transformeer één stylesheet, zo dat informatie over de plek waar een 
rem dlogger:save() voorkomt wordt toegevoegd aan die dlogger:save() functie.
rem Vervangt de stylesheet op de plek waar deze is aangetroffen door deze nieuwe
rem stylesheet. 
rem Typisch aan te roepen op lokale (ontwikkel) deployment, zodat dit geen impact op de 
rem beheerde code, die uiteindelijk wordt overgedragen heeft.
rem Aanroep:
rem DLogger-deploy.bat c:\mijn-pad\mijn-stylesheet.xsl
rem ----------------------------------------------------------------------------------------

rem TODO read these from environment variables:

	set webapp_dlogger_path=c:\tools\xslweb\home\webapps\DLogger-common
	set webapp_dlogger_tempfile=c:\temp\temp.xsl
	set saxon_processor=saxon-pe

set xsl_deploy=%webapp_dlogger_path%\xsl\DLogger-deploy.xsl

FIND "--[dlogger]" %1 >nul
if %errorlevel%.==0. goto end

echo Reflexion: %1
call %saxon_processor% -s:%1 -xsl:%xsl_deploy% -o:%webapp_dlogger_tempfile% stylesheet-path=%1
copy /b /y %webapp_dlogger_tempfile% %1 

:end
