set sdk=C:\Flex_sdk_3_2\bin\compc.exe
set buildfile=C:\www\projects\xmlhelpers\run\build-avm1bridge-swc.xml
set outputfile=C:\www\projects\xmlhelpers\bin\avm1bridge.swc
set exec=%sdk% -load-config+=%buildfile% -debug=true -incremental=true -benchmark=false -output=%outputfile% -strict=true
call %exec%
:: C:\Flex_sdk_3_2\bin\compc.exe -help compiler
pause