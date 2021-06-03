/*
STAT 8020 - Homework 4
Due 4/27/2020
*/

/*Declaring Library for Homework 4 Files*/
libname hw4 "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 4";

/*
For this question, we want to calculate the proportion of players who were in the upper quartile (i.e., above the 75th 
percentile) for both career runs and career RBIs. To answer this question, using whichever procedure you’d like, determine
the 75th percentile for career runs and career RBIs. 
*/

/*What are variables actaully called?*/
proc contents data = sashelp.baseball;
run;
/*CrRbi & CrRuns*/

proc means data=sashelp.baseball StackODSOutput P75; 
var CrRbi CrRuns;
ods output summary=LongPctls;
run;
 
proc print data=LongPctls noobs;run;

/*
Variable Label P75 
CrRbi Career RBIs 462.000000 
CrRuns Career Runs 557.000000 
*/

data hw4.baseball;
	set sashelp.baseball;
	*"Above the 75th percentile";
	if CrRbi > 462 and CrRuns > 557;
run;

/*
1.	Using either the %LET method or using PROC SQL, create two separate macro variables for the 75th percentiles you just 
calculated. %PUT them to the SAS log to ensure they read properly.
*/
%let CrRbi75 = 462;
%let CrRuns75 = 557;
%put &CrRbi75;
%put &CrRuns75;

/*
2.	In the DATA step:
	a.	Create three separate arrays: one which contains the crruns and crrbi columns, one which is temporary and contains 
		the two macro variables you just calculated, and an empty categorical array.
*/
data hw4.q1a;
	set sashelp.baseball;
	array CrArray[2] CrRbi CrRuns;
	array Cr75[2] (&CrRbi75 &CrRuns75);
	array Cat[2];/*Cannot figure out how to make this categorical ($n?)*/
run;

/*
b.	Within the same DATA step, using a DO loop and IF-THEN logic, write code to place a value of “YES” in a column of the 
categorical array if a player’s career runs or RBIs is greater than the 75th percentile and a value of “NO” if not. You 
should end up with two new columns in your dataset.
*/
data hw4.q1a (drop = i);
	set sashelp.baseball;
	array CrArray[2] CrRbi CrRuns;
	array Cr75[2] (&CrRbi75 &CrRuns75);
	array Cat[2] $;
	do i = 1 to 2;
		if CrArray[i] > Cr75[i] then Cat[i] = "YES";
		else Cat[i] = "NO";
	end;	
run;

/*
3.	Using PROC FREQ, create a 2 x 2 contingency table which tabulates the number of “YES” and “NO” for the new columns you
created in (3). Report the proportion of players which fell into the “YES” category for both variables. (HINT: This should
be the overall proportion, not row or column proportion and you can just type it out in the comments). 
*/
proc sort data=hw4.q1a;
   by descending Cat1 descending Cat2;
run;

proc freq data=hw4.q1a order=data;
   tables Cat1*Cat2;
   title '2x2 Contingiency Table for CrRbi and CrRuns above 75th Percentile';
run;
/*Number of Observations above 75th percentile in CrRbi and CrRuns is 65 */

/*
For Part II, I want to replicate one of the questions from the MACROS exam using hash objects and the hash iterator. For a
given baseball statistic, we want to see the top few players for that given baseball statistic. But instead of using PROC 
SQL, we’ll use hash and hiter objects. 
*/

/*
1.	Using the %LET procedure for creating macro variables, create one called stat and assign it a value nHome (for 
homeruns in the 1986 season) and create another one called tops with an assigned value of 4. %PUT these to the SAS log 
just to double check that they read in correctly. 
*/
%let stat = nHome;
%let tops = 4;
%put &stat;
%put &tops;

/*
2.	In a single DATA step:
*/
data hw4.topstats;*a.	Create a new dataset called topstats. ;
	drop i;
	if _N_=1 then do;
	if 0 then set sashelp.baseball (keep = &stat Name);
	declare hash stats (dataset: "sashelp.baseball",ordered: 'descending');*b.	Following a similar set of procedures as shown in the Chapter 12 SAS code, declare a hash object called stats where you read in the SASHELP.BASEBALL dataset and order it in descending order (HINT: remember to use the if _N_ = 1 then do code to save memory).;
	stats.definekey("&stat", "Name");*c.	Define the key columns as the &stat and the player name. (HINT: Put double quotes around &stat like “&stat” and have &stat be the first column).;
	stats.definedata("Name", "&stat");*d.	Define the data columns as the player name and the &stat macro variable (HINT: Put these in opposite order of the key columns such that player name is first).;
	stats.definedone();*e.	Invoke the .DEFINEDONE() statement.;
	declare hiter order_stat("stats");*f.	Now, create a hiter object called order_stat.;
	end;
	order_stat.first();*g.	Find the first observation from the hash object.;
	do i = 1 to &tops;*h.	Using a DO loop (i.e., do i=1 to &tops) output the next 3 observations using the .NEXT() functionality. ;
		output hw4.topstats;
		order_stat.next();
	end;
	stop;
run;

proc print data = hw4.topstats;*3.	Print the resulting dataset with appropriate titles (HINT: Your players should be: Jesse Barfield, Mike Schmidt, Dave Kingman, & Gary Gaetti). ;
run;
