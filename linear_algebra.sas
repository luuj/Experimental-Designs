*Import data;
proc import 
	datafile="C:\Users\jluu\Dropbox\School\PM513\Homework\HW_2_data(1).xlsx"
	out=hw2
	DBMS=XLSX 
	replace;
run;

*Question 2a;
proc anova data=hw2 plots=none;
     class Group; /* PROC ANOVA will not run if you don't declare categorical variables using the CLASS statement. */
	 model Value = Group; /* Response on left, explanatory on right */
run;

*Question 2b;
proc glm data=hw2 plots=none;
    class Group;
	model Value = Group / clparm alpha=0.05; /* CLPARM gives CIs for the estimates */
	estimate 'Mean' intercept 4 Group 1 1 1 1 / E divisor=4; 
	estimate 'G1' Group 3 -1 -1 -1 / E divisor=4; 
	estimate 'G2' Group -1 3 -1 -1 / E divisor=4; 
	estimate 'G3' Group -1 -1 3 -1 / E divisor=4;
 	estimate 'G4' Group -1 -1 -1 3 / E divisor=4; /* Compare to Lecture 4, bottom of pg. 3 */ 
	estimate 'G1-G2' Group -1 1 0 0 / E; 
	estimate 'G1-G3' Group -1 0 1 0 / E; 
	estimate 'G1-G4' Group -1 0 0 1 / E; 
	estimate 'G1-(G2,G3,G4)' Group -3 1 1 1 / E;
	estimate '(G2,G4)-(G1,G3)' Group 1 -1 1 -1 / E;
	estimate '(G3,G4)-(G1,G2)' Group 1 1 -1 -1 / E;
run;

*Question 2c;
proc mixed data=hw2 plots=none;
    class Group;
	model Weight_loss__gain_ = Group / solution; 

	lsmestimate Group 
			 '(G2,G4)-(G1,G3)' 1 -1 1 -1, 
		     '(G3,G4)-(G1,G2)' -1 -1 1 1,
			 '(G2,G3)-(G1,G4)' 1 -1 -1 1, 
			 'G1-G2' -1 1 0 0, 
			 'G1-G3'  -1 0 1 0,
			 'G1-G4'  -1 0 0 1 /  E cl adjust=Scheffe alpha=0.05; 
run;

*Question 2d/e;
proc glm data=hw2 plots=none;
    class Group;
	model Weight_loss__gain_ = Group / p;
	means Group / dunnett cldiff;
	means Group / tukey cldiff;
	means Group / bon cldiff alpha=0.05;
run;
