
/* Example showing two factor ANNOVA - With and Without Interaction*/

/* Import Data */
/* Here we have used in column 2 represent plating (-1 -> phosphate),(0 -> cadmium) ( 1-> no plating)*/
/* COlumn 3 represent medium - ( 1-> Bolt and 0 -> Mandrel )*/ 


data Locknut;
	input Torque plating threaded;
	cards;
10 -1 1
13 -1 1
17 -1 1
16 -1 1
15 -1 1
14 -1 1
11 -1 1
14 -1 1
15 -1 1
16 -1 1
25 -1 0
40 -1 0
30 -1 0
17 -1 0
16 -1 0
45 -1 0
49 -1 0
33 -1 0
30 -1 0
20 -1 0
24 0 1
18 0 1
17 0 1
17 0 1
15 0 1
23 0 1
14 0 1
18 0 1
12 0 1
11 0 1
20 0 0
16 0 0
17 0 0
18 0 0
15 0 0
16 0 0
19 0 0
14 0 0
15 0 0
24 0 0
32 1 1
22 1 1
30 1 1
35 1 1
32 1 1
28 1 1
27 1 1
28 1 1
30 1 1
30 1 1
26 1 0
40 1 0
28 1 0
38 1 0
38 1 0
30 1 0
26 1 0
38 1 0
45 1 0
38 1 0
;

	/* Factor Effects Model */
	/*----------------------*/
	/* Two-Factor ANOVA including interaction term */
	/* USING SOLUTION: */
proc glm data=Locknut  alpha= 0.01 ;
	class plating threaded;
	model Torque=plating|threaded/ solution;
	means plating*threaded;

	/*output out=temp r=resid p=predict;*/
	run;
	
	
	
   /* Two-Factor ANOVA without interaction term */
proc glm data=Locknut;
	class plating threaded;
	model Torque=plating threaded/ solution;
	

    /*output out=temp r=resid p=predict;*/
	run;
