@echo off

set owner=armatiek
set sourcefolder=%cd%
set masterdoc=DLogger

call documentor-respec %owner% %masterdoc% %sourcefolder% deploy

pause