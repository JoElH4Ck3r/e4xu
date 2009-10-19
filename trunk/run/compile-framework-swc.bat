SET sdk=C:\sdks\trunk\bin\compc.exe
SET buildfile=C:\bugs\run\build-framework.xml
SET outputfile=C:\bugs\bin\framework.swc
SET exec=%sdk% -load-config+=%buildfile% -debug=true -benchmark=false -output=%outputfile% -defaults-css-url C:\bugs\run\empty.css
CALL %exec%
:: C:\Flex_sdk_3_2\bin\compc.exe -help compiler
pause