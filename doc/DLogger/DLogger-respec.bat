echo off

set debug=false
set documentname=DLogger
set mswordtransformerfolder=D:\Projects\arjan\Development\MsWordTransformation

if not exist %documentname%.docx goto error

call %mswordtransformerfolder%\tool\pre-work.bat %mswordtransformerfolder%\work

rem copy the files from "zip" to the work folder
xcopy /e/s/y *.*  %mswordtransformerfolder%\work\*.*
		
call %mswordtransformerfolder%\tool\respec.bat ^
    %documentname% ^
    %debug% ^
    %mswordtransformerfolder%\tool ^
    %mswordtransformerfolder%\work ^
	Armatiek ^
	java

goto done

:error
echo In deze folders staat geen document %documentname%.docx (%cd%\%documentname%.docx)
goto end

:done
echo Resultaat staat in %mswordtransformerfolder%\work
goto end

:end
pause