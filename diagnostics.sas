proc import 
	datafile="C:\Users\jluu\Dropbox\School\PM513\Homework\HW_2_data(1).xlsx"
	out=q1
	DBMS=XLSX 
	replace;
run;

proc import 
	datafile="C:\Users\jluu\Dropbox\School\PM513\Homework\HW_3_data.xlsx"
	out=q2
	DBMS=XLSX 
	replace;
	sheet="Sheet1";
run;

proc import 
	datafile="C:\Users\jluu\Dropbox\School\PM513\Homework\HW_3_data.xlsx"
	out=q3
	DBMS=XLSX 
	replace;
	sheet="Sheet2";
run;

*Question 1;
proc glm data=q1 plots=all;
     class Group; 
	 model Value = Group; 
run;

*Question 2a;
proc glm data=q2 plots=all;
	model X=T;
run;

*Question 2b;
proc glm data=q2 plots=all;
	class T;
	model X=T;
run;

*Question 2c;
proc glm data=q2 plots=all;
	class T;
	model X=T;
	contrast 'linear'    T -3 -1  1 3;
 	contrast 'quadratic' T  1 -1 -1 1;
run;

*Question 3;
data q3;
	set q3;
	if (Y=999) then delete;

	logY=log(Y);
	X2=X*X;
	X3=X*X*X;
run;

proc glm data=q3 plots=all;
	model logY=X X2 X3;
run;
