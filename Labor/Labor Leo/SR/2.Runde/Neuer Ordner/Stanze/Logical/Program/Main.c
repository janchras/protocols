
#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _INIT ProgramInit(void)
{
	T1.PT=3000;
}

void _CYCLIC ProgramCyclic(void)
{
	Motor=Richtung=0; 
	 
	switch(Schritt)	 
	{ 
		case 0:	 

			if(Start == 1) 

			{ Schritt = 1; }  

			break; 

		case 1:  

			Motor = 1;  

			Richtung = 1;  

			if(Unten == 1)  

			{Schritt = 2;}  

			break; 

		case 2:  
			
			T1.IN=1;
			if(T1.Q)  

			{Schritt = 3;}  

			break; 

		case 3:  

			Motor = 1;  

			if(Oben == 1) 	 

			{ Schritt = 0;}  

			break; 

	} 
	 
} 

void _EXIT ProgramExit(void)
{

}

