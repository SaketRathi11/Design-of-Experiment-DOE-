/*Part 1 - One way Annova */
data Hsale;
	infile '"/home/saketr20/sales.txt"';
	input id SaleP FinsishedSqF noofbed noofbath aircond garagesize pool yearbuilt 
		quality style lotsize adjhighway;

	/* Definition of new variable for 'No of Bedroom' */
	if noofbed<=2 then
		newnNbed=1;

	if noofbed=3 then
		newnNbed=2;

	if noofbed=4 then
		newnNbed=3;

	if noofbed>=5 then
		newnNbed=4;

	/* First ANOVA testing without transformation and checking the assumptions*/
	/* One-way ANOVA: Sales Price vs. No of bedrooms */
	/* Also checks for variance using Bartlet test */
	/* Also gives confidence intervals for all pairwise comparisons among the four number-of-bedroom
	categories.*/
	/* 1way ANOVA */
proc glm data=Hsale alpha=0.05 plots=all;
	class newnNbed;
	model SaleP=newnNbed;

	/* Tests for constant variance */
	means newnNbed / hovtest=bartlett;
	means newnNbed/tukey;
	output out=Demo1 r=resid p=fitted;
	run;

	/* Testy for Normality */
proc univariate data=Demo1 normal plot;
	var resid;
run;

/* Dataset containing all residuals */
data residuals;
	set Demo1;
run;

/* Plot all 4 levels of residuals*/
goptions reset=all hsize=10cm vsize=5cm;
title "Residuals vs Fitted (Overall)";

proc gplot data=residuals;
	plot resid*fitted;
	run;

	/* Based on above ANNOVA results and tests we realize residuals are not normal and have variance problem*/
	/* Heuristic test to find the right transformation*/
	/* Save mean & sd in a dataset */
data test;
	input id n mean sd;
	cards;
1 74 192056.081 100361.383
2 202 243330.515 110379.962
3 179 312530.341 146265.348
4 67 384371.642 132443.817
;

	/* Compute the ratios to graphically
	check which transformation is appropriate */
data test2;
	set test;
	x1=mean/sd;
	x2=(mean*mean)/sd;
	x3=mean/(sd*sd);
run;

/* Plot! */
goptions reset=all hsize=10cm vsize=5cm;
title "Y/s";

proc gplot data=test2;
	plot x1*id;
	run;
	goptions reset=all hsize=10cm vsize=5cm;
	title "Y^2/s";

proc gplot data=test2;
	plot x2*id;
	run;
	goptions reset=all hsize=10cm vsize=5cm;
	title "Y/s^2";

proc gplot data=test2;
	plot x3*id;
	run;

	/* From Heuristic test we found that variance is still not constant for general transformation*/
	/* Box-Cox transformation */
proc transreg data=Hsale maxiter=0 nozeroconstant;
	model BoxCox(SaleP)=identity(newnNbed);
	output;
run;

/* lambda selected close to -.75 as per the box cox result
we can use the reciprocal power .75 to keep it simple*/
data newHsale;
	set Hsale;
	newSaleP=((SaleP)**(-.75));
run;

/* Check result for new transformation */
/* Residuals & Residual Plots for transformed response for 1way ANOVA */
proc glm data=newHsale alpha=0.05 plots=all;
	class newnNbed;
	model newSaleP=newnNbed;

	/* Tests for constant variance */
	means newnNbed / hovtest=bartlett;
	means newnNbed/tukey;
	output out=Demo2 r=resid1 p=fitted1;
	run;
	title 'Histrogram of Residuals';

proc univariate data=Demo2 noprint;
	var resid1;
	histogram resid1/normal;
	qqplot resid1/normal (L=1 mu=est sigma=est);
run;

/* Conclusion- Although even after transformation Varaince and normality assumptions are not met
but one can see they have improved a lot . Based on increase in P valuen */
/* In this case we have to go back to NON parametri test which does not take into account this
consideration */
/* Nonparametric Test */
proc npar1way data=Hsale;
	class newnNbed;
	var SaleP;
run;

/* Conclusion */
/* Based on Kruskal Wallis test also we came to same conclusion that for alpha=0.05
we reject the null hypothesis and conclude that infact there is difference in sale based on noofbed*/
/* 2 Way Annova */
data Hsale;
	infile '"/home/saketr20/my_courses/achronop/c_8944/IE 400/sales.txt"';
	input id SaleP FinsishedSqF noofbed noofbath aircond garagesize pool yearbuilt 
		quality style lotsize adjhighway;

	/* Definition of new variable for 'No of Bedroom' */
	if style=1 then
		style1=1;

	if style>1 then
		style1=2;

	if style1=1 and Quality=1 then
		SQ=11;

	if style1=1 and Quality=2 then
		SQ=12;

	if style1=1 and Quality=3 then
		SQ=13;

	if style1=2 and Quality=1 then
		SQ=21;

	if style1=2 and Quality=2 then
		SQ=22;

	if style1=2 and Quality=3 then
		SQ=23;
run;

/* Converting ANOVA model to a balnced deign by making no of observation in cell same i.e.25)*/
PROC SORT data=Hsale out=demo2;
	BY SQ ID;
RUN;

proc print data=demo2;
run;

data abc;
	set demo2;
	where ((SQ=11 and id<=132) or (SQ=12 and id<=141) or (SQ=13 and id<=396) 
		or (SQ=21 and id <=104)or (SQ=22 and id<=147) or (SQ=23 and id<=422));
run;

proc print data=abc;
	/* Two-Factor ANOVA with interaction term for balanced design */
proc glm data=abc plots=all;
	class quality style1;
	model SaleP=quality style1 quality*style1/solution;

	/*means quality*style1 / hovtest=bartlett;*/
	output out=temp r=resid p=predict;
	run;

proc univariate data=temp normal plot;
	var resid;
run;

/*To check for variance we need to check for each variable seperately */
proc glm data=abc plots=All;
	class SQ;
	model SaleP=SQ;
	means SQ / hovtest=BARTLETT;
	run;

	/* Conclusion - Neither the residuals are noramlly distributed nor is the vraince constant */
	/* Box-Cox transformation */
proc transreg data=abc maxiter=0 nozeroconstant;
	model BoxCox(SaleP)=identity(quality*Style1);
	output;
run;

/* lambda selected close to 0 as per the box cox result
we can use the logarathim to keep it simple*/
data demo3;
	set abc;
	newSaleP1=(log(SaleP));
run;

/* verfiy normality and variance for transformed variable */
proc glm data=demo3 plots=all;
	class quality style1;
	model newSaleP1=quality style1 quality*style1/solution;

	/*means quality*style1 / hovtest=bartlett;*/
	output out=temp4 r=resid4 p=predict4;
	run;

proc univariate data=temp4 normal plot;
	var resid4;
run;

/*To check for variance we need to check for each variable seperately */
proc glm data=demo3;
	class SQ;
	model newSaleP1=SQ;
	means SQ / hovtest=BARTLETT;
	run;

	/* Even Our transformation we find that normality assumption and variance are not constant */
	/* Nonparametric Test */
proc npar1way data=abc;
	class SQ;
	var SaleP;
run;

/* Even NON Parametric Test suggest that there is adifference between 6 factor levels */
/* Q2- Part - we need conduct unbalance ANNOVA and report the finding */
/* We do not need to fix the number of variables in each cell to 25*/
/* Two-Factor ANOVA with interaction term for unbalanced design */
proc glm data=Hsale plots=all;
	class quality style1;
	model SaleP=quality style1 quality*style1/solution;

	/*means quality*style1 / hovtest=bartlett;*/
	output out=temp6 r=resid6 p=predict6;
	run;

proc univariate data=temp6 normal plot;
	var resid6;
run;

/*To check for variance we need to check for each variable seperately */
proc glm data=Hsale plots=All;
	class SQ;
	model SaleP=SQ;
	means SQ / hovtest=BARTLETT;
	run;

	/* Conclusion - Neither the residuals are noramlly distributed nor is the vraince constant */
	/* Box-Cox transformation */
proc transreg data=Hsale maxiter=0 nozeroconstant;
	model BoxCox(SaleP)=identity(quality*Style1);
	output;
run;

/* lambda selected close to -.5 as per the box cox result
we can use the reciprocal power .5 to keep it simple*/
data demo4;
	set Hsale;
	newSaleP1=(1/sqrt(SaleP));
run;

/* verfiy normality and variance for transformed variable */
proc glm data=demo4 plots=all;
	class quality style1;
	model newSaleP1=quality style1 quality*style1/solution;

	/*means quality*style1 / hovtest=bartlett;*/
	output out=temp5 r=resid5 p=predict5;
	run;

proc univariate data=temp5 normal plot;
	var resid5;
run;

/*To check for variance we need to check for each variable seperately */
proc glm data=demo4;
	class SQ;
	model newSaleP1=SQ;
	means SQ / hovtest=BARTLETT;
	run;

	/* Residuals are normal but variance effect is still significant*/
	/* Nonparametric Test */
proc npar1way data=HSale;
	class SQ;
	var SaleP;
run;

/* reject null and conclude there is difference between all 6 levels */