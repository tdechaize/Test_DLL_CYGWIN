REM build_dll.bat
REM 
REM Demonstrates compiling a DLL using a batch file

gcc -c -o calcdll.o calcdll.c -D CALCDLL_EXPORTS
gcc -o calcdll.dll calcdll.o -s -shared -Wl,--subsystem,windows