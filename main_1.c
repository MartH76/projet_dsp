#include <math.h>


float Oscilloscope[1024]={};

float Oscilloscope_2[10024]={};


int f_sin = 980;
int f_e = 8000;

int i=0;
int j=0;

int gene_sinus(float frequence, float freq_sampling,int N_sample){
	for(i=0;i<N_sample;i++){
		Oscilloscope[i] = sinf(i*2*3.14*frequence/freq_sampling);
	}
	return 1;
}


float LUT_sinus[512] = {
#include "LUT_512.dat"
} ;


int gene_sinus_LUT_C(float frequence, float freq_sampling,int N_sample, int j){
	 for(i=0;i<N_sample;i++){ 	
	 	int pas = (512*frequence/freq_sampling);	 		
		Oscilloscope_2[i+N_sample*j] = LUT_sinus[(int)(pas*i)%512];
	}
	return 1;
}

int FSK_Modulator (float freq_1, float freq_0, float f_sampling, int Data, int Baud ){
	if (Data & 1){
		int N_sample = f_sampling/Baud;
		
		for (j = 1; j <= 10; j++){
			if (Data & (1<<j)){
				gene_sinus_LUT_C( freq_1,  f_sampling, N_sample,j);		
			}
			else{
				gene_sinus_LUT_C( freq_0, f_sampling,N_sample,j);	
			}
		}
	}
	return 1;
}

int main(){
	//gene_sinus(f_sin, f_e, 267);
	//gene_sinus_LUT_C(f_sin, f_e, 267,0);
	//FSK_Modulator (980, 1180, 8000, 0x199, 300);
	
	
	return 0;	
}