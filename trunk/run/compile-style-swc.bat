set sdk=C:\Flex_sdk_3_2\bin\compc.exe
set buildfile=C:\www\projects\xmlhelpers\run\build-styles-swc.xml
set outputfile=C:\www\projects\xmlhelpers\bin\styles.swc
set exec=%sdk% -load-config+=%buildfile% -debug=true -incremental=true -benchmark=false -output=%outputfile% -keep-as3-metadata=CSS -strict=true
call %exec%
:: C:\Flex_sdk_3_2\bin\compc.exe -help compiler
pause