// INCLUDE SECTION ///////////////////////////////

#include <math.h>

// VISIBILITY SECTION //////////////////////////////////
extern int	test(int,int,float);
extern int gene_sinus_LUT_asm_v1(int);
extern int gene_sinus_LUT_asm_v2(float, float, float);
extern int FSK_Modulator_Opt (float freq_1, float freq_0, float f_sampling);
float Oscillo[512]={};
float Oscillo2[10024]={};
float pm LUT_sinus[512] = {
#include "LUT_512.dat"
};

int Data = 0;
float baud = 0;

int j = 1;
int i = 0;
int N_sample_buff = 0;
int addr_buff = LUT_sinus; 
int addr_buff_oscillo = Oscillo2;
float N_sampl_buf;


int FSK_Modulator (float freq_1, float freq_0, float f_sampling, int Data, int Baud ){
		float N_sample = f_sampling/Baud;		
		for (j = 1; j <= 10; j++){
			if (Data & (1<<j)){
				addr_buff = gene_sinus_LUT_asm_v2(freq_1,  f_sampling, N_sample);		
			}
			else{
				addr_buff = gene_sinus_LUT_asm_v2(freq_0, f_sampling,N_sample);
			}
			N_sample_buff = (int)(N_sample)+N_sample_buff;
		}
	return 1;
}


// CODE SECTION //////////////////////////////////

int pas = 25;
int a;
void	main()
{
	

	
while(1){	
	//	FSK_Modulator (980, 1120, 8000, 0x55, 300);
		Data = 0x55;
		baud = 100;
		FSK_Modulator_Opt (500,1500,8000);	
}
}	



	
