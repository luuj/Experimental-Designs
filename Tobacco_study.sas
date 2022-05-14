*PM513 Project - Part 2 - Jonathan Luu;

*Import dataset;
proc import OUT=mydata DATAFILE="C:\Users\jluu\Dropbox\School\Previous Semesters\PM513\Final Project PM513\data.xlsx" DBMS=xlsx REPLACE; SHEET="Data"; GETNAMES=YES; run;

*Update dataset;
data mydata;
	set mydata;

	*Normalize number of students as it varies between categories;
	norm_CS=CS/Students;
run;

*Table 1;
proc sort data=mydata; by EDUC SUPP; run;
proc report data=mydata;
	by EDUC SUPP;
run;

*Run base analysis;
proc glm data=mydata;
	class DN EDUC SUPP;
	model norm_CS = DN|EDUC EDUC|SUPP;
run;

*Point estimates and 95% CI;
proc glm data=mydata;
	class DN EDUC SUPP;
	model norm_CS = DN|EDUC EDUC|SUPP;
	lsmeans EDUC*SUPP / cl;
run;

*Multiple comparisons for support group;
proc glm data=mydata;
	class DN EDUC SUPP;
	model norm_CS = DN|EDUC EDUC|SUPP;
	lsmeans SUPP / adjust=Scheffe;
run;

*Contrast to compare the effectiveness of video;
proc glm data=mydata;
	class DN EDUC SUPP;
	model norm_CS = DN|EDUC EDUC|SUPP;
	contrast 'Video Effectiveness' SUPP 1 -1 1 -1;
	contrast 'Interview Effectiveness' SUPP -1 -1 1 1;
run;

