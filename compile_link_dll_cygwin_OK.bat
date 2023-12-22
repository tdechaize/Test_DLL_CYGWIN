@echo off
REM
REM   	Script de génération de la DLL dll_core.dll et des programmee de test : "testdll_implicit.exe" (chargement implicite de la DLL),
REM 	"testdll_explicit.exe" (chargement explicite de la DLL), et enfin du script de test écrit en python.
REM		Ce fichier de commande est paramètrable avec deux paraamètres : 
REM			a) le premier paramètre permet de choisir la compilation et le linkage des programmes en une seule passe
REM 			soit la compilation et le linkage en deux passes successives : compilation séparée puis linkage,
REM 		b) le deuxième paramètre définit soit une compilation et un linkage en mode 32 bits, soit en mode 64 bits
REM 	 		pour les compilateurs qui le supportent.
REM     Le premier paramètre peut prendre les valeurs suivantes :
REM 		ONE (or unknown value, because only second value of this parameter is tested during execution) ou TWO.
REM     Et le deuxième paramètre peut prendre les valeurs suivantes :
REM 		32, 64 ou  ALL si vous souhaitez lancer les deux générations, 32 bits et 64 bits.
REM
REM 	Author : 						Thierry DECHAIZE
REM		Date creation/modification : 	24/11/2023
REM 	Reason of modifications : 	n° 1 - Blah, Blah, Blah ....
REM 	 							n° 2 - Blah, Blah, Blah ....	
REM 	 							n° 3 - ........
REM 	Version number :				1.1.1	          	(version majeure . version mineure . patch level)

echo. Lancement du batch de generation d'une DLL et deux tests de celle-ci avec Open Watcom 32 bits ou 64 bits
REM     Affichage du nom du système d'exploitation Windows :              			Microsoft Windows 11 Famille (par exemple)
REM 	Affichage de la version du système Windows :              					10.0.22621 (par exemple)
REM 	Affichage de l'architecture du processeur supportant le système Windows :   64-bit (par exemple)    
echo.  *********  Quelques caracteristiques du systeme hebergeant l'environnement de developpement.   ***********
WMIC OS GET Name
WMIC OS GET Version
WMIC OS GET OSArchitecture

REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
REM      Mandatory, add to PATH the binary directory of compiler GCC de CYGWIN64. You can adapt this directory at your personal software environment.
set PATH=C:\cygwin64\bin;%PATH%
echo. **********      Pour cette generation le premier parametre vaut "%1" et le deuxieme "%2".     ************* 
IF "%2" == "32" ( 
   call :complink32 %1
) ELSE (
   IF "%2" == "64" (
      call :complink64 %1
   ) ELSE (
      call :complink32 %1
	  call :complink64 %1
	)  
)

goto FIN

:complink32
echo. ******************            Compilation de la DLL en mode 32 bits        *******************
set "PAR1=%~1"
if "%PAR1%" == "TWO" (
REM     Options used by GCC compiler 32 bits of MingW64 included in CYGWIN64
REM 		-c       					Option to impose compile only
REM 		-Dxxxxx	 					Define variable xxxxxx used by precompiler
i686-w64-mingw32-gcc.exe -c src\dll_core.c -DBUILD_DLL -DNDEBUG -o dll_core.o
echo. *****************           Edition des liens .ie. linkage de la DLL.        ***************
REM     Options used by linker of gcc compiler
REM 		-static-libgcc 				Suppress dependance of cygwin1.dll to generate "portable" DLL (or executable)
REM 		-shared						Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					Define output file generated by GCC compiler, here dll file
REM 		-Wl,xxxxxxxx				Set options to linker : here, first option to generate windows compatible DLL, second option to generate lib file 
i686-w64-mingw32-gcc.exe -static-libgcc -shared -o dll_core.dll -Wl,--subsystem,windows -Wl,--out-implib,libdll_core.dll.a dll_core.o 
REM   Show list of exported symbols from a library/exe/obj/dll 
echo. ************     				 Dump des sysboles exportes de la DLL dll_core.dll      				  *************
gendef - dll_core.dll > dll_core.def
type dll_core.def
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
i686-w64-mingw32-gcc.exe -c -DNDEBUG -o testdll_implicit.o src\testdll_implicit.c
REM 	Options used by linker of Open Watcom compiler
REM 		-subsystem console 	Define subsystem to console, because generation of console application 
i686-w64-mingw32-gcc.exe -o testdll_implicit.exe -s testdll_implicit.o -L. dll_core.dll
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
i686-w64-mingw32-gcc.exe -c -DNDEBUG -o testdll_explicit.o src\testdll_explicit.c
i686-w64-mingw32-gcc.exe -o testdll_explicit.exe -s testdll_explicit.o
REM 	Run test program of DLL with explicit load
testdll_explicit.exe					
 ) ELSE (
REM     Options used by GCC compiler 32 bits of MingW64 included in CYGWIN64
REM 		-Dxxxxx	 					Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		-static-libgcc 				Suppress dependance of cygwin1.dll to generate "portable" DLL (or executable)
REM 		-shared						Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					Define output file generated by GCC compiler, here dll file
REM 		-Wl,xxxxxxxx				Set options to linker : here, first option to generate windows compatible DLL, second option to generate lib file 
i686-w64-mingw32-gcc.exe -DBUILD_DLL -DNDEBUG -static-libgcc -shared -o dll_core.dll -Wl,--subsystem,windows -Wl,--out-implib,libdll_core.dll.a src\dll_core.c 
REM    Show list of exported symbols from a library/exe/obj/dll 
echo. ************     				 Dump des sysboles exportes de la DLL dll_core.dll      				  *************
gendef - dll_core.dll > dll_core.def
type dll_core.def
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
i686-w64-mingw32-gcc.exe -DNDEBUG src\testdll_implicit.c -static-libgcc -L. -o testdll_implicit.exe dll_core.dll
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
i686-w64-mingw32-gcc.exe -DNDEBUG src\testdll_explicit.c -static-libgcc -o testdll_explicit.exe
REM 	Run test program of DLL with explicit load
testdll_explicit.exe
)
echo. ****************               Lancement du script python 32 bits de test de la DLL.               ********************
%PYTHON32% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON32% testdll_cdecl.py dll_core.dll 
exit /B 

:complink64
echo. ******************          Compilation de la DLL en mode 64 bits        *******************
set "PAR1=%~1"
if "%PAR1%" == "TWO" (
REM     Options used by GCC compiler 64 bits of MingW64 included in CYGWIN64
REM 		-c       					Option to impose compile only
REM 		-Dxxxxx	 					Define variable xxxxxx used by precompiler
REM 		-o xxxxx 					Define output file generated by GCC compiler, here object file
x86_64-w64-mingw32-gcc.exe -c src\dll_core.c -DBUILD_DLL -DNDEBUG -o dll_core64.o
echo. *****************           Edition des liens .ie. linkage de la DLL.        ***************
REM     Options used by linker of gcc compiler
REM 		-static-libgcc 				Suppress dependance of cygwin1.dll to generate "portable" DLL (or executable)
REM 		-shared						Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					Define output file generated by GCC compiler, here dll file
REM 		-Wl,xxxxxxxx				Set options to linker : here, first option to generate windows compatible DLL, second option to generate lib file 
x86_64-w64-mingw32-gcc.exe -static-libgcc -shared -o dll_core64.dll -Wl,--subsystem,windows -Wl,--out-implib,libdll_core64.dll.a dll_core64.o 
REM   Show list of exported symbols from a library/exe/obj/dll 
echo. ************     				 Dump des sysboles exportes de la DLL dll_core64.dll      				  *************
gendef - dll_core64.dll > dll_core64.def
type dll_core64.def
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
x86_64-w64-mingw32-gcc.exe -c -DNDEBUG -o testdll_implicit64.o src\testdll_implicit.c
REM 	Options used by linker of Open Watcom compiler
REM 		-subsystem console 	Define subsystem to console, because generation of console application 
x86_64-w64-mingw32-gcc.exe -o testdll_implicit64.exe -s testdll_implicit64.o -L. dll_core64.dll
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
x86_64-w64-mingw32-gcc.exe -c -DNDEBUG -o testdll_explicit64.o src\testdll_explicit.c
x86_64-w64-mingw32-gcc.exe -o testdll_explicit64.exe -s testdll_explicit64.o
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe					
 ) ELSE (
REM     Options used by GCC compiler 64 bits of MingW64 included in CYGWIN64
REM 		-Dxxxxx	 					Define variable xxxxxx used by precompiler, here define to build dll with good prefix of functions exported (or imported)
REM 		-static-libgcc 				Suppress dependance of cygwin1.dll to generate "portable" DLL (or executable)
REM 		-shared						Set option to generate shared library .ie. on windows systems DLL
REM 		-o xxxxx 					Define output file generated by GCC compiler, here dll file
REM 		-Wl,xxxxxxxx				Set options to linker : here, first option to generate windows compatible DLL, second option to generate lib file 
x86_64-w64-mingw32-gcc.exe -DBUILD_DLL -DNDEBUG -static-libgcc -shared -o dll_core64.dll -Wl,--subsystem,windows -Wl,--out-implib,libdll_core64.dll.a src\dll_core.c 
REM    Show list of exported symbols from a library/exe/obj/dll 
echo. ************     				 Dump des sysboles exportes de la DLL dll_core.dll      				  *************
gendef - dll_core64.dll > dll_core64.def
type dll_core64.def
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
x86_64-w64-mingw32-gcc.exe -DNDEBUG src\testdll_implicit.c -static-libgcc -L. -o testdll_implicit64.exe dll_core64.dll
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
x86_64-w64-mingw32-gcc.exe -DNDEBUG src\testdll_explicit.c -static-libgcc -o testdll_explicit64.exe
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe
)					
echo. ****************               Lancement du script python 64 bits de test de la DLL.               ********************
%PYTHON64% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON64% testdll_cdecl.py dll_core64.dll
exit /B 

:FIN
echo.        Fin de la generation de la DLL et des tests avec GCC 32 bits ou 64 bits de MingW64 inclus dans CYGWIN64
REM 	Return in initial PATH
set PATH=%PATHINIT%

