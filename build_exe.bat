REM  build_exe.bat
REM 
REM Demonstrates compiling and running calculator app using a batch file

gcc -c -o calc.o calc.c
gcc -o calc.exe -s calc.o -L. -lcalcdll
calc.exe