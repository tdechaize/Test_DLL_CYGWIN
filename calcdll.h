/* calcdll.h

   Declares the functions to be imported by our application, and exported by our
   DLL.
*/

#ifdef CALCDLL_EXPORTS /*  define ADD_EXPORTS *only* when building the DLL. */
  #define CALCDLL_API __declspec(dllexport)
#else
  #define CALCDLL_API __declspec(dllimport)
#endif

/* Define calling convention in one place, for convenience. */
#define CALL __cdecl

/* Make sure functions are exported with C linkage under C++ compilers. */

#ifdef __cplusplus
extern "C"
{
#endif

/* Declare our Add function using the above definitions. */
CALCDLL_API int CALL Add(int a, int b);
CALCDLL_API int CALL Subtract(int a, int b);
CALCDLL_API int CALL Divide(int a, int b);
CALCDLL_API int CALL Multiply(int a, int b);

#ifdef __cplusplus
} // __cplusplus defined.
#endif