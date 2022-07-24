#include<asm_sprt.h>
.extern _LUT_sinus; // Déclaration d'une variable gloable déclarer dans le main

.extern _Oscillo;
.extern _N_sample_buff;
.extern _addr_buff;
.extern _Oscillo2;
.extern _Data;
.extern _baud;
.extern _N_sampl_buf;
.extern _addr_buff_oscillo;

.SEGMENT/PM   seg_pmco;
///////////////////////////////////////////////////////
//  float gene_sinus_LUT(int pas)
///////////////////////////////////////////////////////

.GLOBAL _gene_sinus_LUT_asm_v1;
 _gene_sinus_LUT_asm_v1:
	bit set mode1 0x01000000; //enable circular buffer
	
	//init dag1 sinus
	b8=_LUT_sinus; // set buffer base address
	L8=512; //Set the length of our circular buffer to 512
    m8=r4; //Set the M1 modify register to two.
 	// init dag1 oscillo
    b1 = _Oscillo;
    L1 = 512;
    m1 = 1;
    //boucle
    f1=PM(i8,m8);
    lcntr=512, do (pc,1) until lce;   
         DM(i1,m1)=f1, f1=PM(i8,m8);
    DM(i1,m1)=f1;
    R0 = 1;
 	exit;
_gene_sinus_LUT_asm_v1.end :


.GLOBAL _gene_sinus_LUT_asm_v2;
 _gene_sinus_LUT_asm_v2:
	bit set mode1 0x01000000; //enable circular buffer
	//	pas = (512*frequence/freq_sampling);
	// F0=numerator, F12=denominator, F11=2.0.
	
	F0 = R4;
	F1 = R12;
	F12 = R8;	

	
	F11= 2.0; // 	
	F0= RECIPS F12,F7=F0; // Get 8 bit seed R0=1/D
	F12=F0*F12; // D' = D*R0
	F7=F0*F7, F0=F11-F12; // F0=R1=2-D', F7=N*R0
	F12=F0*F12; // F12=D'-D'*R1
	F7=F0*F7, F0= F11-F12; // F7=N*R0*R1, F0=R2=2 -D'
	F12=F0*F12; // F12=D'=D'*R2
	F7=F0*F7 , F0=F11-F12; // F7=N*R0*R1*R2, F0=R3=2-D'
	F0=F0*F7; // F7=N*R0*R1*R2*R3	
	
	F0 = F1*F0;
	R0 = fix F0;
	//init dag1 sinus
	
	b8 = _LUT_sinus; // set buffer base address  
	i8 = dm(_addr_buff);
	L8=512; //Set the length of our circular buffer to 512
    m8=R0; //Set the M1 modify register to two.
 	// init dag1 oscillo 
 	R9 = _Oscillo2;
 	R10 = dm(_N_sample_buff);
 	R13 = R9+R10;
 	b1 = _Oscillo2;	
    i1 = R13;
    L1 = 10024;
    m1 = 1;
    //boucle
    f14=PM(i8,m8);
    R1 = fix F1; //pb pas i�i
    lcntr = R1, do (pc,1) until lce;   
         DM(i1,m1)=f14, f14=PM(i8,m8);
    DM(i1,m1)=f14;
    R0 = i8; //buffer for final address
 	exit;
_gene_sinus_LUT_asm_v2.end :


.GLOBAL _FSK_Modulator_Opt;
 _FSK_Modulator_Opt:
	
	F0 = R12; //on assigne f_sampling au reg R0
	F15 = R12; //buffer f_sampling
	F12 = dm(_baud);
	// division : N_sample = f_sampling/Baud;
	//F0 : f_sampling
	//F12 : baud (a assigner)
	F11= 2.0; // 	
	F0= RECIPS F12,F7=F0; // Get 8 bit seed R0=1/D
	F12=F0*F12; // D' = D*R0
	F7=F0*F7, F0=F11-F12; // F0=R1=2-D', F7=N*R0
	F12=F0*F12; // F12=D'-D'*R1
	F7=F0*F7, F0= F11-F12; // F7=N*R0*R1, F0=R2=2 -D'
	F12=F0*F12; // F12=D'=D'*R2
	F7=F0*F7 , F0=F11-F12; // F7=N*R0*R1*R2, F0=R3=2-D'
	F0=F0*F7; // F7=N*R0*R1*R2*R3
	dm(_N_sampl_buf) = F0; //buffer N_sample 
	//while loop
	R10 = 0;
	R1=10;	
    lcntr=R1, do (pc,40) until lce;
	R12 = dm(_Data);
	;
	//if
	btst R12 by R10; //first if : Data (R9) & 1 (R11)
	if sz jump (pc, 3); //sz if Data & R11 == 0
		R9 = R4;
		jump (pc,2);
	//else
		R9 = R8;
	
	
	// function gene_sinus	
		bit set mode1 0x01000000; //enable circular buffer
	//	pas = (N_sample*frequence/freq_sampling);
	// F0=numerator, F12=denominator, F11=2.0.
	
	F0 = R9;
	F12 = R15;	//f_sampling

	
	F11= 2.0; // 	
	F0= RECIPS F12,F7=F0; // Get 8 bit seed R0=1/D
	F12=F0*F12; // D' = D*R0
	F7=F0*F7, F0=F11-F12; // F0=R1=2-D', F7=N*R0
	F12=F0*F12; // F12=D'-D'*R1
	F7=F0*F7, F0= F11-F12; // F7=N*R0*R1, F0=R2=2 -D'
	F12=F0*F12; // F12=D'=D'*R2
	F7=F0*F7 , F0=F11-F12; // F7=N*R0*R1*R2, F0=R3=2-D'
	F0=F0*F7; // F7=N*R0*R1*R2*R3	
	F13 = dm(_N_sampl_buf);
	F0 = F13*F0;
	R0 = fix F0;
	//init dag1 sinus
	
	b8 = _LUT_sinus; // set buffer base address  
	i8 = dm(_addr_buff);
	L8=512; //Set the length of our circular buffer to 512
    m8=R0; //Set the M1 modify register to two.
 	// init dag1 oscillo 
 	b1 = _Oscillo2;	
    i1 = dm(_addr_buff_oscillo);
    L1 = 10024;
    m1 = 1;
    
    //boucle
    f14=PM(i8,m8);
    R13 = fix F13; 
    lcntr = R13, do (pc,1) until lce;   
         DM(i1,m1)=f14, f14=PM(i8,m8);
    DM(i1,m1)=f14;
    dm(_addr_buff) = i8; //buffer for final address	
    dm(_addr_buff_oscillo) = i1;
	//end gene_sinus
				
	R10 = R10 + 1;
	R1=R1-1;
	
	
	R0=1; //return 1  
	exit;

_FSK_Modulator_Opt.end :

.ENDSEG;

/*
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
	}
	return 1;
}

R9 = dm(_Data); 
	 
	
      
      
*/
