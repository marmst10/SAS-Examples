/*
STAT 8020 - Final Exam
Due 5/4/2020
Connor Armstrong
*/

libname final "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Final Exam";
run;

/*
Part I
*/

/*
1.	Using whichever SAS procedure you’d like, subset the SASHELP.HEART dataset such that only participants who died are 
	included in the new dataset
*/
proc contents data = sashelp.heart;
run;

data final.q1;
	set sashelp.heart;
	if status = "Dead";
run;

/*
2.	Create four macro variables using the %LET statement: 

cs = “High”
bp = “High”
wt = “Overweight”
sk = “Very Heavy (> 25)”
*/
%let cs = High;
%let bp = High;
%let wt = Overweight;
%let sk = Very Heavy (> 25);

/*
3.	Create a new dataset setting the dataset created in (1) and in the same DATA step:
	a.	Create an array called indicators and include the variables: Chol_Status, BP_Status, Weight_Status, and 
		Smoking_Status
	b.	Create a character ($) and temporary array using the macro variables created in (2) and call it indicators1. 
		NOTE: be sure to specify the length of the character array by putting the numeric length after the $ sign.
	c.	Create a third empty numeric array called risk_factors
	d.	Using a DO loop:
		i.	Create IF-THEN-ELSE logic where if the ith element of the array indicators is equal to the ith element of the 
			array indicators1, then the ith value in the risk_factors array will be the number 1. Otherwise, the number 
			should be 0. 
	e.	Still within the same DATA step, sum up the total number of risk factors each participant had and then drop the 
		risk_factors1 – risk_factors4 variables and end the DATA step.
*/
data final.q3 (drop = i j risk_factors1 risk_factors2 risk_factors3 risk_factors4);
	set final.q1;
	sum = 0;
	array indicators[4] Chol_Status BP_Status Weight_Status Smoking_Status;
	array indicators1[4] $24. i1 i2 i3 i4 ("&cs" "&bp" "&wt" "&sk");
	array risk_factors[4];
	do i = 1 to 4;
		if indicators[i] = indicators1[i] then risk_factors[i] = 1;
		else risk_factors[i] = 0;
	end;	
	do j = 1 to 4;
		if risk_factors[j] = 1 then sum = sum+1;
	end;
run;

/*
4.	Using whichever SAS procedure you’d like:
	a.	Find the average age of death for each unique number of risk factors. The unique number of risk factors are 0, 
		1, 2, 3, and 4.
*/
proc sort data = final.q3;
by sum;
run;

proc means data = final.q3 mean;
by sum;
var AgeAtDeath;
run;
	
/*
4.b.  Find the frequency of participants who had 0, 1, 2, 3, and 4 risk factors. 
*/
proc freq data = final.q3;
tables sum;
run;

/*
Part II: Now, we want to determine that of those participants who died, who were the youngest 5 at their age of death as 
well as their cause of death and biological sex. 
1.	Create a new macro variable called youngest and assign it a value of 5.
*/
%let youngest = 5;

/*
2.	Create a new dataset called young and:
	a.	Use the IF-THEN-DO logic mentioned in the notes and previous homework assignment to save memory.
	b.	Set the dataset of deceased participants created in Part I and keep the variables sex, ageatdeath, and 
		deathcause.
	c.	Declare a hash object called age where you read in the dataset of deceased participants and order it in 
		descending order. 
	d.	Define the key component to be ageatdeath
	e.	Define the data components to be ageatdeath, sex, and deathcause
	f.	End defining the hash object.
	g.	Define a hiter object called order_age and read-in the age hash object.
	h.	Read the last observation (the youngest person). 
	i.	Using a DO loop and your macro variable created in part (a), read the previous 5 observations.
	j.	End the DATA step.
*/
data final.young;
	drop i;
	if _N_=1 then do;
	if 0 then set final.q1 (keep = sex  ageatdeath deathcause);
	declare hash age (dataset: "final.q1",ordered: 'descending');
	age.definekey("ageatdeath");
	age.definedata("ageatdeath", "sex", "deathcause");
	age.definedone();
	declare hiter order_age("age");
	end;
	order_age.last();
	do i = 1 to 5;
		output final.young;
		order_age.prev();
	end;
	stop;
run;

/*
3.	Print out your new dataset of the youngest 5 deceased participants from the Framingham Heart Study with an 
	appropriate descriptive title
*/
title "Youngest 5 Deceased Participants from the Framingham Heart Study";
proc print data = final.young;
run;
