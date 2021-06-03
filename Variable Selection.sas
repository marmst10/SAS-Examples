/*
STAT 8210
Homework 6
Connor Armstrong
*/

libname hw6 "C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 6";

proc import datafile="C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 6\boston1.csv"
out = hw6.boston;
getnames = yes;
datarow = 2;
run;

/*
Splitting dataset into training and test data sets
*/
data hw6.hw;
	set hw6.boston;
	IDnum = _N_;
run;

proc surveyselect data = hw6.hw
	method = srs rep = 1 sampsize = 280 seed = 347017
	out=hw6.traindata;
run;

proc sort data = hw6.traindata;
	by IDnum;
run;

proc sort data = hw6.hw;
	by IDnum;
run;

data hw6.testdata;
	merge hw6.hw (in = inO) hw6.traindata (in = inT);
	by IDnum;
	if inO and inT then delete;
run;

/*
Problem 1 - Fit full model
*/
ods rtf;
ods graphics on;
proc reg data=hw6.traindata;
	model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / partial vif collin ;
	output out = stdres p = predict r = resid;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;

*the residuals are not normally distributed, having failed the AD normality test;
*this is sufficient justification for transformation of those variables of concern;
*addition of natural log of crim, dis, black, and lstat will be evaluated;
*because zn has values of 0, we will evaluate an addition of a square root term;
*transforming just the response will also be tested;
*note to professor: I don't know the best method for transforming the data, so all three
	methods will be tested against eachother visually to determine the best method;

data hw6.traintrans;
set hw6.traindata;
logmedv = log(medv);
logcrim = log(crim);
sqrtzn = sqrt(zn);
logdis = log(dis);
logblack = log(black);
loglstat = log(lstat);
drop logzn;
run;

*evaluating the transformed model with non-transformed terms included;
ods rtf;
ods graphics on;
proc reg data=hw6.traintrans;
	model medv = logcrim crim sqrtzn zn indus chas nox rm age logdis dis rad tax ptratio logblack black loglstat lstat / partial vif collin ;
	output out = stdres p = predict r = resid;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;
/*conclusion - failed AD test*/

*evaluating the transformed model with non-transformed terms excluded;
ods rtf;
ods graphics on;
proc reg data=hw6.traintrans;
	model medv = logcrim sqrtzn indus chas nox rm age logdis rad tax ptratio logblack loglstat / partial vif collin ;
	output out = stdres p = predict r = resid;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;
/*conclusion - failed AD test*/

*evaluating the transformed model having only log-transformed the response variable;
ods rtf;
ods graphics on;
proc reg data=hw6.traintrans;
	model logmedv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / partial vif collin ;
	output out = stdres p = predict r = resid;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;
/*conclusion - failed AD test*/

*It would seem that while none of the transformations entirely resolved the AD test failure,
the first transformed model with all terms included had the lowest AD statistic and will be 
utilized in further evaluations;

/*Dr Taasoobshirazi recommended removing the 10 "especially extreme and problematic" values*/
ods rtf;
ods graphics on;
proc reg data=hw6.traindata;
	model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / partial vif collin;
	output out = stdres p = predict r = resid dffits = dffits rstudent = rstudent;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;

data newset;
	set stdres;
	studabs = abs(rstudent);
run;

proc sort data = newset;
by descending studabs;
run;

data delset;
	set newset;
	if _n_ < 11 then delete;
run;

/*print 10 worst stdres (absolute value)*/
ods rtf;
ods graphics on;
proc print data = newset (obs=10);
run;
ods graphics off;
ods rtf close;

/*Regression without the 10 most influential points (with largest studentized residuals)*/
ods rtf;
ods graphics on;
proc reg data=delset;
	model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / partial vif collin;
	output out = stdres p = predict r = resid dffits = dffits rstudent = rstudent;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;

/*Regression without the 10 most influential points with interaction*/
ods rtf;
ods graphics on;
proc reg data=delset;
	model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / partial vif collin;
	output out = stdres p = predict r = resid dffits = dffits rstudent = rstudent;
run;
*evaluating normality of residuals;
proc univariate data = stdres normal;
var resid;
run;
ods graphics off;
ods rtf close;

/*export modified dataset to perform analysis using minitab*/
proc export data = delset
	outfile = 'C:\Users\conno\OneDrive\Desktop\STAT 8210 - Applied Regression Analysis\Homework 6\out.csv' 
	dbms = csv
	replace;
run;

/*box cox transformation did not improve the normality test,
including second order interactions and quadratic terms did 
not significantly improve the normality test.*/

/*
Problem 2
*/

*perform forward selection with sle=0.2;
ods rtf;
ods graphics on;
title 'Forward selection (sle=0.2)';
proc reg data = delset;
model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / selection=forward sle=0.2 vif;
run;
ods graphics off;
ods rtf close;


*perform backward selection with sls=0.15;
ods rtf;
ods graphics on;
title 'Backward selection (sls=0.15)';
proc reg data = delset;
model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / selection=backward sls=0.15 vif;
run;
ods graphics off;
ods rtf close;

*perform stepwise selection with sle=0.15 and sls=0.15;
ods rtf;
ods graphics on;
title 'Stepwise selection (sls=0.15, sle=0.15)';
proc reg data = delset;
model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / selection=stepwise sls=0.15 sle=0.15 vif;
run;
quit;
ods graphics off;
ods rtf close;

/*
Problem 3
*/
/*
testing all possible regressions
*/

*best 3 models in terms of adj r squared;
ods rtf;
ods graphics on;
title '3 Best models in terms of adjusted r^2';
proc reg data = delset;
model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / selection=adjrsq best=3 vif;
run;
quit;
ods graphics off;
ods rtf close;

*best 3 models in terms of AIC/BIC;
ods rtf;
ods graphics on;
title '3 Best models in terms of AIC/BIC';
proc reg data = delset;
model medv = crim zn indus chas nox rm age dis rad tax ptratio black lstat / selection=adjrsq aic bic cp best=20 vif;
run;
quit;
ods graphics off;
ods rtf close;
*Showing top 20 because I am not certain about the relationship between adjrsq and aic/bic;
/*Sorted in Excel to save time - top 3 for each shown in submission and tested below*/

/*
Problem 4
*/
ods rtf;
ods graphics on;
title 'Testing Model 1';
proc reg data=hw6.testdata;
	model medv=crim zn nox rm age dis rad tax ptratio black lstat / partial vif collin ;
run;
title 'Testing Model 2';
proc reg data=hw6.testdata;
	model medv=crim zn chas nox rm age dis rad tax ptratio black lstat / partial vif collin ;
run;
title 'Testing Model 3';
proc reg data=hw6.testdata;
	model medv=crim zn indus nox rm age dis rad tax ptratio black lstat / partial vif collin ;
run;
title 'Testing Model 4';
proc reg data=hw6.testdata;
	model medv=crim zn nox rm dis rad tax ptratio black lstat / partial vif collin ;
run;
ods graphics off;
ods rtf close;
