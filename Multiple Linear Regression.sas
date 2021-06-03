/*
STAT 8210 - Homework 3
Due 2/11/2020
Connor Armstrong
*/


libname hw3 "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 3";
run;

/*Importing Problem 1 Data*/
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 3\anscombe1.csv"
	out = hw3.p1
	DBMS = csv
	Replace;
run;

/*
Anscombe (1973) created four famous data sets, each of which is saved in anscombe.csv in the 
Datasets folder.  For each pair of variables (x1,y1), (x2,y2), (x3,y3), (x4,y4), fit the simple 
linear regression model (using xj to predict yj).  
1.	a.   What is the estimated regression line and what is R2?  
*/
ods rtf;
ods graphics on;
proc reg data=hw3.p1;
model y1 = x1;
model y2 = x2;
model y3 = x3;
model y4 = x4;
run;
ods graphics off;
ods rtf close;
/*outlier test for y3*/
proc univariate data=hw3.p1 robustscale plot;
var  y3;
run; 


/*Input data for part 2*/
DATA hw3.p2;
  INPUT temp visc;
CARDS;
24.9	1.1330
35.0	0.9772
44.9	0.8532
55.1	0.7550
65.2	0.6723
75.2	0.6021
85.2	0.5420
95.2	0.5074
;
RUN;

/*Calculate x^2 as another independent variable*/
data hw3.p2;
	set hw3.p2;
	temp2 = temp**2;
run;

ods rtf;
ods graphics on;
proc reg data = hw3.p2;
model visc = temp temp2;
output out = hw3.p2res r=res p=pred;
run;
quit;
ods graphics off;
ods rtf close;

proc print data = hw3.p2res;
var res;
run;

/*Import Problem 3.7 Table B.4 Data*/
proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 3\Property_Value_Table_B_4.csv"
	out = hw3.p3
	DBMS = csv
	Replace;
run;

ods rtf;
ods graphics on;
proc reg data = hw3.p3;
model y = x1 x2 x3 x4 x5 x6 x7 x8 x9/ VIF TOL;
output out = hw3.p3res r=res p=pred;
run;
quit;
ods graphics off;
ods rtf close;

ods rtf;
ods graphics on;
proc reg data = hw3.p3;
model y = x1 x2 x3 x4 x7 x8/ VIF TOL;
output out = hw3.p3res r=res p=pred;
run;
quit;
ods graphics off;
ods rtf close;
