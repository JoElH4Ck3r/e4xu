set sdk=C:\Flex_sdk_3_2\bin\compc.exe
set buildfile=C:\www\projects\xmlhelpers\run\build.xml
set outputfile=C:\www\projects\xmlhelpers\bin\lib.swc
set exec=%sdk% -load-config+=%buildfile% -debug=true -incremental=true -benchmark=false -output=%outputfile% -includes=mx.managers.SystemManager -includes=mx.core.mx_internal
call %exec%
pause