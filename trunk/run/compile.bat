SET sdk=C:\flex_sdk_3_3\bin\mxmlc.exe
SET buildfile=C:\www\projects\xmlhelpers\run\build-project.xml
SET outputfile=C:\www\projects\xmlhelpers\bin\e4xu.swf
SET exec=%sdk% -load-config+=%buildfile% -debug=true -incremental=true -benchmark=false -output=%outputfile% -projector=true
REM C:\www\projects\xmlhelpers\bin\proj.exe
REM -output=%outputfile% 
REM call %sdk% -help projector
CALL %exec%
pause