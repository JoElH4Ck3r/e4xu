set sdk=C:\Flex_4_SDK\bin\mxmlc.exe
set buildfile=C:\www\projects\xmlhelpers\run\build.xml
set outputfile=C:\www\projects\xmlhelpers\bin\e4xu.swf
set exec=%sdk% -load-config+=%buildfile% -debug=true -incremental=true -benchmark=false -output=%outputfile%
call %exec%
pause