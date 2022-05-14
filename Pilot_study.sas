proc import OUT=PS1 DATAFILE="C:\Users\jluu\Downloads\Final Project PM513\Smoking data.xlsx" DBMS=xlsx REPLACE; SHEET="Pilot 1"; GETNAMES=YES; run;
proc import OUT=PS2 DATAFILE="C:\Users\jluu\Downloads\Final Project PM513\Smoking data.xlsx" DBMS=xlsx REPLACE; SHEET="Pilot 2"; GETNAMES=YES; run;

*Pilot study 1;
proc glm data=PS1;
	class INV;
	model RES=INV / solution;
run;

proc means data=PS1; by INV; var RES; run;


*Pilot study 2;
proc glm data=PS2;
	class TRT;
	model RES=TRT;
run;

proc mixed data=PS2;
	class BLOCK TRT;
	model RES = TRT;
	random BLOCK BLOCK*TRT;
	lsmeans TRT/ cl diff;
run;

proc sort data=PS2; by TRT; run;
proc means data=PS2; by TRT; var RES; run;
proc means data=PS2; var RES; run;
