*Q1;
proc import 
	datafile="C:\Users\jluu\Downloads\HW_5_data.xlsx"
	out=p1
	DBMS = XLSX  
    replace;
	sheet="P1";
run;

proc glm data=p1 plots=all;
	class A B C;
	model Val = A | B | C / clparm;	
	estimate 'A0' intercept  1  A  1;
	estimate 'A1' intercept 1 A 0 1;
	estimate 'AB00' intercept 1 A 1 B 1 A*B 1 0 0 0;
	estimate 'AB01' intercept 1 A 1 B 0 1 A*B 0 1 0 0;
	estimate 'AB11' intercept 1 A 0 1 B 0 1 A*B 0 0 0 1;
	estimate 'AC00' intercept 1 A 1 C 1 A*C 1 0 0 0;
	estimate 'AC01' intercept 1 A 1 C 0 1 A*C 0 1 0 0;
	estimate 'AC11' intercept 1 A 0 1 C 0 1 A*C 0 0 0 1;
	estimate 'BC00' intercept 1 B 1 C 1 B*C 1 0 0 0;
	estimate 'BC01' intercept 1 B 1 C 0 1 B*C 0 1 0 0;
	estimate 'BC11' intercept 1 B 0 1 C 0 1 B*C 0 0 0 1;
	estimate 'ABC000' intercept 1 A 1 B 1 C 1 A*B 1 A*C 1 B*C 1 A*B*C 1;
	estimate 'ABC001' intercept 1 A 1 B 1 C 0 1 A*B 1 A*C 0 1 B*C 0 1 A*B*C 0 1 / E;
	estimate 'ABC010' intercept 1 A 1 B 0 1 C 1 A*B 0 1 A*C 1 B*C 0 0 1 A*B*C 0 0 1;
	estimate 'ABC011' intercept 1 A 1 B 0 1 C 0 1 A*B 0 1 A*C 0 1 B*C 0 0 0 1 A*B*C 0 0 0 1;
	estimate 'ABC100' intercept 1 A 0 1 B 1 C 1 A*B 0 0 1 A*C 0 0 1 B*C 1 A*B*C 0 0 0 0 1;
	estimate 'ABC101' intercept 1 A 0 1 B 1 C 0 1 A*B 0 0 1 A*C 0 0 0 1 B*C 0 1 A*B*C 0 0 0 0 0 1;
	estimate 'ABC110' intercept 1 A 0 1 B 0 1 C 1 A*B 0 0 0 1 A*C 0 0 1 B*C 0 0 1 A*B*C 0 0 0 0 0 0 1;
	estimate 'ABC111' intercept 1 A 0 1 B 0 1 C 0 1 A*B 0 0 0 1 A*C 0 0 0 1 B*C 0 0 0 1 A*B*C 0 0 0 0 0 0 0 1;
run;

proc print data=p1; run;

data p1_qc;
	set p1;

	NumDrug=A+B+C;
run;

proc glm data=p1_qc plots=all;
	class NumDrug;

	model Val = NumDrug;
	contrast 'Linear Trend' NumDrug -3 -1 1 3;
	contrast 'Quadratic Trend' NumDrug 1 -1 -1 1;
run;

proc glm data=p1 plots=all;
	class A B C;
	model Val = A B C;
run;

proc glm dta=p1 plots=all;
	class A B C;
	model Val = A | B | C;
run;


*Q2;
proc import 
	datafile="C:\Users\jluu\Downloads\HW_5_data.xlsx"
	out=p2
	DBMS = XLSX  
    replace;
	sheet="P2";
run;

proc print data=p2; run;


proc mixed data=p2 plots=none;
	class Goat Period Method;
	model Val = Period Method Method*Period / s;
	repeated / subject=Goat type=cs;  
run;

proc mixed data=p2 plots=none;
	class Goat Period Method;
	model Val = Period Goat Goat*Period / s;
	repeated / subject=Method type=cs;  
run;


*Q3;
proc import 
	datafile="C:\Users\jluu\Downloads\HW_5_data.xlsx"
	out=p3
	DBMS = XLSX  
    replace;
	sheet="P3";
run;

proc print data=p3; run;

proc glm data=p3; 
	class Pattern Subject T Recall_Num;
	model Recall = Pattern Subject(Pattern) T Recall_Num T*Recall_Num;
	Test H = Pattern E=SUBJECT(PATTERN) / HTYPE=1 ETYPE=1;
	means T / alpha=0.1 tukey cldiff;
run;

PROC SORT; BY T Recall_Num;
PROC MEANS MEAN NOPRINT;
 VAR Recall;
 BY T Recall_Num;
 OUTPUT OUT=A MEAN=MDUR; 
 run;

PROC PLOT DATA=A;
 PLOT MDUR*Recall_Num=T;
