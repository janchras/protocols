
#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

void _INIT ProgramInit(void)
{
	T1.PT=30000;
}

void _CYCLIC ProgramCyclic(void)
{
	TON(&T1); //Aufruf der Timerfunktion
	V1=Y1=Y2=H1=0;
	switch (Schritt) {
		case 0: if (S0)
			{
				Schritt=1;
			}
			break;
		case 1: 
			V1=1;
			Y1=1;
			if (S2)
			{
				Schritt=2;
			}
			break;
		case 2:
			T1.IN=1;
			V1=1;
			if (S1&&T1.Q==0)
			{
				Schritt=4;
				T1.IN=0;
				T1.Q=0;
				T1.M=0;
			}
			else if (T1.Q)
			{
				Schritt=3;
				T1.IN=0;
				T1.Q=0;
				T1.M=0;
			}
			break;
		case 3:
			V1=1;
			Y2=1;
			if (S3)
			{
				Schritt=0;
			}
			break;
		case 4:
			H1=1;
			V1=1;
			Y2=1;
			if (S3)
			{
				Schritt=5;
			}
			break;
		case 5:
			H1=1;
			if (Q1)
			{
				Schritt=0;
			}
			break;
	}
}
void _EXIT ProgramExit(void)
{
	
}

