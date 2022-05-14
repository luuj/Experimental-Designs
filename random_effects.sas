proc import 
	datafile="C:\Users\jluu\Dropbox\School\PM513\Homework\HW_4_data.xlsx"
	out=dataset
	DBMS = XLSX  
    replace;
run;

proc print data=dataset; run;

proc anova data=dataset;
	class T K;
	model _M = T K; 
run;

*Overall mean;
proc glm data=dataset;
	class T K; 
	model _M=T K ;
	output out=overall PREDICTED=yhat;
run;

data overall;
	set overall;
	interact = yhat**2;
run;

proc glm data=overall plots=all; 
	class T K;
	model _m=T K interact;
run;
