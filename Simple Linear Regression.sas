/*
STAT 8210 - Applied Regression Analysis
Homework 1
Due 1/21/2020 - I think
Connor Armstrong
*/


libname hw1 "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Data";
run;

proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Data\mtcars.csv"
	out = hw1.car
	DBMS = csv
	Replace;
run;

/*Problem 1*/
ods rtf;
ods graphics on;
proc sgplot data=hw1.car;
   title 'mpg vs wt';
   scatter x=wt y=mpg;
run;
ods graphics off;
ods rtf close;

/*Problem 2*/
data test;
do i=1 to 100;
    x1 = rannor(123);
    x2 = rannor(123)*2 + 1;
    y = 1*x1 + 2*x2 + 4*rannor(123);
    output;
end;
run;

data test;
set test end=last;
output;
if last then do;
    y = .;
    x1 = 1.5;
    x2 = -1;
    output;
end;
run;

proc reg data=test alpha=.01;
model y = x1 x2;
output out=test_out(where=(y=.)) p=predicted ucl=UCL_Pred lcl=LCL_Pred;
run;
quit;

data hw1.car;
set hw1.car end=last;
output;
if last then do;
    mpg = .;
    wt = 3;
    output;
end;
run;

ods rtf;
ods graphics on;
proc Reg data=hw1.car;
title "Simple Linear Regression Model with wt as Explanatory Variable, mpg as Response Variable";
model mpg=wt/ p clb cli;
Output out=hw1.test_out(where=(mpg=.)) p=predicted ucl=UCL_Pred lcl=LCL_Pred upl=UPL_Pred ;
run;
ods graphics off;
ods rtf close;
quit;
