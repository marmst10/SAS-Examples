/*
STAT 8020 - Exam 2
Connor Armstrong
*/

libname exam2 "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Exam 2";

/*
PROBLEM 1
*/

/*
(a) Use a %LET statement to create a macro variable that will represent a particular player name, so that the 
user can specify any player name and retrieve the statistics for the player(s) with that name. NOTE: It should 
also work if the user specifies part of a name. Use this macro variable in a short program to print the 
statistics for any player whose name contains the character string "Don".  Have the program also put a 
descriptive title on the output that includes the chosen value of the macro variable. 
*/

/*To figure out variable name for "Player's Name"*/
proc contents data = sashelp.baseball;
run;
/*It's "name"*/

%let namesearch = Don;
%put &namesearch;
/*This code returns all values of name from sashelp.baseball which contain &namesearch - case insensitive*/
data exam2.q1a;
	set sashelp.baseball;
	where upcase(name) contains upcase(&namesearch);
run; 
Title "Observations of sashelp.baseball Which Contain the Character String '&namesearch'";
proc print data = exam2.q1a;
run;

/*
(b) Write a SAS macro called descripstat that will calculate a descriptive statistic for a variable, in an 
arbitrary SAS data set.  The statistic, the variable, and the name of the data set should be macro parameters.  
The descriptive statistic should be one that can be calculated by PROC MEANS.  Have the macro include a title on 
the output that describes exactly what is being calculated. [Hint: You may want to look at the PROC MEANS help 
files in the online SAS help documentation.]
*/

%macro descripstat(statistic, variable, dataset);
proc means data=&dataset &statistic;
   var &variable;
   title "Parameter '&statistic' of Variable '&variable' in Dataset '&dataset'";
run;
Title;
%mend descripstat;

/*
(c) Invoke the macro created in (b) in such a way that it will calculate the mean number of hits (nHits) for the 
players in the sashelp.baseball data set.  Then invoke the macro in such a way that it will calculate the total 
(summed) number of home runs (nHome) for the players in the sashelp.baseball data set.
*/
%descripstat(mean, nhits, sashelp.baseball);
%descripstat(sum, nhome, sashelp.baseball);

/*
(d) Write a macro that will calculate the mean for an arbitrary number of numeric variables (where the set of 
variables is provided by the user), for the sashelp.baseball data set. The variable(s) should be macro 
parameters.
*/
%let var1 = nhits;
%let var2 = nhome;

%macro baseballmean(variables);
proc means data = sashelp.baseball mean;
var &variables;
run;
%mend baseballmean;

%baseballmean(&var1 &var2); /*Could be more than 2, if needed.*/
 
/*
(e) Write the macro so that it will print the top few highest-ranking players in the sashelp.baseball data, of a 
certain position, in a certain league, based on a certain baseball statistic. Highest-ranking here means having 
the largest values of the baseball statistic. The number of players printed, the baseball statistic, the 
position, and the league should be macro parameters. [Hint: You can use some PROC SQL tools to help with this, 
although you don't have to.]
*/
%macro best(number, position, league, statistic);
data tempsubset;
	set sashelp.baseball;
	if position = "&position" and league = "&league";
run;
proc sort data = tempsubset out = tempsort;
by descending &statistic;
run;
proc print data = tempsort (obs = &number);
var name team division &statistic;
Title "Top &number Players with most &statistic in Position &Position in the &League League in 1986";
run;
Title;
%mend best;

/*
(f) Invoke the macro in (e) to print the top 4 first basemen ("1B") in the American league based on their number 
of runs batted in (nRBI).
*/
%best(4, 1B, American, nRBI);

/*
(g) Use the %IF-%THEN-%ELSE operators to perform any conditional operation of your choosing within a macro that 
works with the sashelp.baseball data set.  Be sure to use comments to carefully explain what the conditional 
operation does.
*/

/*This code generates a dataset which contains observations wherein nRBI > 100. It also generates a global
accumulator variable, "&global100", which can be referenced by the global %if-%then-%else statement later*/
data exam2.global;
	set sashelp.baseball;
	if nRBI > 100 then 
	over100 = 1;
		else DELETE;
	sumover100 + over100;
	call symput('global100',sumover100);
run;

/*Checking that &global100 generated successfully*/
%put &global100;

/*If more than or equal to 10 players had nRBI greater than 100, then run this code.*/
%if &global100 ge 10 %then %do;
proc print data = exam2.global;
	var name nRBI;
	title "Players whose nRBI was over 100";
	Footnote "10 or more players have nRBI over 100";
run;
%end;

/*Otherwise, run this code.*/
%else %do;
proc print data = exam2.global;
	var name nRBI;
	title "Players whose nRBI was over 100";
	Footnote "Less than 10 players have nRBI over 100";
run;
%end;

/*The only difference in the two sets of code is the footnote, but this demonstrates a successful implementation
of the global conditional processing in %if-%then-%else statements.*/
