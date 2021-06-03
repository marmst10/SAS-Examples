/*
STAT 8020 HOMEWORK 1
CONNOR ARMSTRONG

DUE 1/13/2020
*/


/*
1.	Save your data in a location on your computer. Read the text file to SAS. 
*/
libname hw1 "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 1";
run;

proc import datafile = "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 1\baseball.txt"
	out = hw1.ball
	DBMS = csv
	Replace;
run;

/*Here I'm taking a look at the imported data to ensure it imported correctly*/
proc contents data = hw1.ball;
run;

/*
2.	Write a PROC SQL query to report the number of rows in the data.
*/
proc sql;
select count(*) as countrec 
from hw1.ball;
quit;
/*337*/

/*
3.	What PROC SQL code is used to get the complete list of columns on the SAS log?
*/
proc sql;
describe table hw1.ball;
quit;

/*
4.	Write a PROC SQL query to change the Label the variables as follows: 
*/
proc sql;
	create table hw1.ball as select 
		   X1 label='Batting average',
		   X2 label='On-base percentage',
		   X3 label='Number of runs',
		   X4 label='Number of hits',
		   X5 label='Number of doubles',
		   X6 label='Number of triples',
	 	   X7 label='Number of home runs',
		   X8 label='Number of walks',
		   X10 label='Number of strike-outs',
		   X11 label='Number of stolen bases',
		   X12 label='Number of errors',
		   X13 label='Indicator of "free agency eligibility"',
		   X14 label='Indicator of "free agent in 1991/2"',
	  	   X15 label='Indicator of "arbitration eligibility"',
		   X16 label='Indicator of "arbitration in 1991/2"',
		   Y label='Salary (in thousands of dollars)'
	from hw1.ball;
quit;

/*
5.	Write a PROC SQL query to subset the baseball data by selecting Batting average, 
Number of runs, Number of hits, Number of doubles, Number of triples and Salary. In 
the same PROC SQL query, create a new column name BONUS by using the rule: 
salary*.12. Further subset the data by selecting salary between 2000 and 2500. Sort 
your data by Batting average. Create a new column name TOTAL INCOME by adding SALARY 
and BONUS columns. Format the TOTAL INCOME column to two decimal places. Give the 
title of your query as “Total Income of Selected Baseball Players.” Write only one 
PROC SQL query for this.
*/
Title 'Total Income of Selected Baseball Players.';
proc sql;
	select x1, x3, x5, x6, y, y*.12 as bonus, y+y*.12 as total_income format=10.2 
	from hw1.ball
	where y between 2000 and 2500
	order by x1;
quit;

/*
6.	Write a PROC SQL query to find Total Salary, Minimum Salary, Maximum Salary, 
Average Salary & Median Salary by Number of Triples (X6). Format the Average salary
and Median salary to two decimal places. Subset the data by selecting total salary 
greater than 25000. Sort the data by Number of Triples. Write Only one PROC SQL 
query.
*/

title;
proc sql /*noremerge*/;
	select x6, sum(y) as Total_Salary label="Total Salary", min(y) as Minimum_Salary label="Minimum Salary",
		   max(y) as Maximum_Salary label="Maximum Salary", avg(y) as Average_Salary format=10.2 label="Average Salary",
		   median(y) as Median_Salary format=10.2 label="Median Salary"
	from hw1.ball/*hw1.test*/
	group by x6
	having sum(y)>25000
	order by x6;
quit;

/*
7.	In just a sentence or two, how does OUTOBS and INOBS work in SQL? 

Using OUTOBS in proc sql, processing stops once the desired number of observations 
has been output in the statement. INOBS controls the number of records that are 
read into the statement.
*/

/*
8.	Read the Name.txt data on SAS. Name.txt data contains last and first names of 
the 337 Baseball players. Merge this data to the right side of Baseball data by 
any SAS procedure.
*/
data hw1.name;
	infile "C:\Users\conno\OneDrive\Desktop\STAT 8020 - Advanced SAS\Homework 1\name.txt" 
	delimiter = '09'x
	missover dsd
	lrecl=32767;
	informat var1 $14.;
	informat var2 $14.;
	format var1 $14.;
	format var2 $14.;
	input 
		var1 $
		var2 $
	;
	rename var1 = lastname var2 = firstname;
	
run;

data hw1.name;
	set hw1.name;
	label lastname = "Last Name";
	label firstname = "First Name";
run;
/*Here I'm taking a look at the imported data to ensure it imported correctly*/
proc contents data = hw1.name;
run;

data hw1.merged;
	set hw1.ball;
	set hw1.name;
run;

/*
9.	 Write a PROC SQL query by selecting the number of runs, number of hits, number 
of Doubles and number of Triples so that first name or last name contains ‘An’ and 
number of home runs is between zero to ten.
*/
proc sql;
select x3, x4, x5, x6, firstname, lastname
from hw1.merged
where (firstname contains "An" or lastname contains "An") and (x7 between 0 and 10);
quit;

/*
10.	 How do you properly use CALCULATED keyword? How can the CALCULATED keyword be 
avoided? 

Calculated is used after the where keyword to refer to a calculated value. You can
avoid using the calculated keyword by repeating the calculation in the where clause.
This is what I have done in the problems above.
*/

/*
11.	 How do the LIKE operator and SOUNDLIKE OPERATOR (=*) work in PROC SQL? Give an 
example for each.

The like operator selects rows that have values that match a specific pattern of 
characters rather than a character string.
*/
proc sql;*example;
	select *
	from hw1.merged
	where firstname like '%Ant%ony';
quit;
/*
The sounds like operator selects rows that have values that contain a value that 
sounds like another value that you specify.
*/
proc sql;*example - selects the same as above because anthony sounds like anthuny;
	select *
	from hw1.merged
	where firstname =* 'Anthuny';
quit;

/*
12.	 Write a PROC SQL query so that only baseball players with number of TRIPLES 
salary are more than the average salary of Baseball players. (write a noncorrelated
sub query).
*/
proc means data = hw1.merged;
run;*Total average salary is 1248.53;

proc sql;
	select avg(y) as tripavg format=10.2 label="Average Salary", x6
	from hw1.merged
	group by x6
	having avg(y)>1248.53;
quit;

/*
13.	 What is done by the keywords VALIDATE and NOEXEC using PROC SQL?

Validate ensures that the correct syntax is present in the statement, and does not run the 
statement.

NOEXEC will prevent the statement from being executed, but will display errors if present.
*/
