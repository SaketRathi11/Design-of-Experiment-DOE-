 /* Import Data */

data Servicetime;
input Time Technician Make Job;
cards;
  62.0  1  1  1
  48.0  1  1  2
  63.0  1  1  3
  57.0  1  1  4
  69.0  1  1  5
  57.0  1  2  1
  45.0  1  2  2
  39.0  1  2  3
  54.0  1  2  4
  44.0  1  2  5
  59.0  1  3  1
  53.0  1  3  2
  67.0  1  3  3
  66.0  1  3  4
  47.0  1  3  5
  51.0  2  1  1
  57.0  2  1  2
  45.0  2  1  3
  50.0  2  1  4
  39.0  2  1  5
  61.0  2  2  1
  58.0  2  2  2
  70.0  2  2  3
  66.0  2  2  4
  51.0  2  2  5
  55.0  2  3  1
  58.0  2  3  2
  50.0  2  3  3
  69.0  2  3  4
  49.0  2  3  5
  59.0  3  1  1
  65.0  3  1  2
  55.0  3  1  3
  52.0  3  1  4
  70.0  3  1  5
  58.0  3  2  1
  63.0  3  2  2
  70.0  3  2  3
  53.0  3  2  4
  60.0  3  2  5
  47.0  3  3  1
  56.0  3  3  2
  51.0  3  3  3
  44.0  3  3  4
  50.0  3  3  5
  ;
  run;
  
  
  	/* Factor Effects Model */
	/*----------------------*/
	/* Two-Factor ANOVA including interaction term */
	/* USING SOLUTION:  */
proc glm data=Servicetime;
	class Technician Make;
	model Time=Technician|Make/ solution;
	means Technician*Make;
	/*means percent / hovtest=bartlett hovtest=levene;*/

	output out=temp r=resid p=predict;
	run;
	
	
	  /* Stores Residuals in a Data set */
data resids;
    set temp;
run;

/* Print Residuals */
proc print data=resids;
run;


/* Residuals vs. Predicted values */
proc sort; 
by predict;
symbol1 v=circle i=sm50; 
title1 'Residual Plot';

proc gplot; 
plot resid*predict/frame; 
run;



/* QQ-plot & Histogram */
proc univariate data=temp noprint;
var resid; 
qqplot resid / normal (L=1 mu=est sigma=est);
histogram resid / normal; 
run;



/* Sequence plot of residuals. 
Will use different smoothing levels */
proc sort; by job;
symbol1 v=circle i=sm75;
title1 'Plot of residuals vs oder';

proc gplot; 
plot resid*job / vref=0 vaxis=-6 to 6 by 1;
run;

	
