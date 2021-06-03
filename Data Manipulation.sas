/******************************************
STAT 7020 - HOMEWORK 3
******************************************/

/*
1. Create a permanent library called airline. 
*/
libname airline 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 3\Airline';
run;

/*
Giving pilots and navigators easier import names
*/
filename pilots 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 3\pilots.txt';
run;

filename nav 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 3\navigators.txt';
run;

/*
2a. Import the first 10 obs of pilots.txt in this order
	ID, last name, first name, city, state, gender, job code, and salary
*/
data airline.pilots1;
	infile pilots obs =10;
	input ID 1-4 lastname $ 5-14 firstname $ 15-23 city $ 24-35 state $ 36-37 gender $ 38 jobcode $ 39-41 salary 48-53;
run;

/*
2b. Import the first 10 obs of pilots.txt in this order
	Last name, first name, id, city, state, job code, salary and gender.
*/
data airline.pilots2;
	infile pilots obs =10;
	input lastname $ 5-14 firstname $ 15-23 ID 1-4 city $ 24-35 state $ 36-37 jobcode $ 39-41 salary 48-53 gender $ 38;
run;


/*
2c. Once your code is correct, import all of the records.
*/
data airline.pilots3;
	infile pilots;
	input ID 1-4 lastname $ 5-14 firstname $ 15-23 city $ 24-35 state $ 36-37 gender $ 38 jobcode $ 39-41 salary 48-53;
run;

/*
3a. Import navigators.txt in this order
		ID, last name, first name, city, state, gender, job code, and salary
*/
data airline.nav1;
	infile nav;
	input ID 1-4 lastname $ 5-14 firstname $ 15-23 city $ 24-35 state $ 36-37 gender $ 38 jobcode $ 39-41 salary 48-53;
run;

/*
3b. Import navigators.txt in this order
		Last name, first name, id, city, state, job code, salary and gender.
*/
data airline.nav2;
	infile nav;
	input lastname $ 5-14 firstname $ 15-23 ID 1-4 city $ 24-35 state $ 36-37 jobcode $ 39-41 salary 48-53 gender $ 38;
run;

/*
4. Print out the first 5 observations of the pilots dataset
*/
proc print data = airline.pilots3 (obs=5);
run;

/*
5. Print out observations from 6 to the end from the navigators dataset.
*/
proc print data = airline.nav1 (firstobs = 6);
run;

/*
6. Sort both datasets in descending order.
*/
proc sort data = airline.pilots3;
	by descending ID;
run;
proc sort data = airline.nav1;
	by descending ID;
run;

/*
7. There are 20 observations in the pilots.txt file. Suppose that each pair of
records represent a team with a pilot in command and a co-pilot.  Create a 
dataset using line point control that sends the first observation to variables
prefixed with captain (i.e. captainid, captainlastname, etc…) and the 2nd 
records to variables prefixed with copilot.  
*/
data airline.pilots4;
	infile 'C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 3\pilots.txt';
	input PILOT_ID 1-4 PILOT_lastname $ 5-14 PILOT_firstname $ 15-23 PILOT_city $ 24-35 PILOT_state $ 36-37 PILOT_gender $ 38 PILOT_jobcode $ 39-41 PILOT_salary 48-53
	/ COPILOT_ID 1-4 COPILOT_lastname $ 5-14 COPILOT_firstname $ 15-23 COPILOT_city $ 24-35 COPILOT_state $ 36-37 COPILOT_gender $ 38 COPILOT_jobcode $ 39-41 COPILOT_salary 48-53;
run;

/*
Create and a new variable called teamsalary which is the sum of the captain 
salary and the copilot salary.  
*/
data airline.pilots4;
	set airline.pilots4;
	teamsalary = PILOT_salary + COPILOT_salary;
run;

/*
Suppose each team averages 1500 flight hours a year. Divide the team salary by 
1500 to get the per flight hour salary. 
*/
data airline.pilots4;
	set airline.pilots4;
	pfhsalary = teamsalary / 1500;
	format pfhsalary dollar16.2;
run;

/*
Checking to see if the dollar format has worked
*/
proc print data = airline.pilots4;
run;

/*
8. Sort the dataset created in step 7 by “per flight hour salary.” 
*/
proc sort data = airline.pilots4;
	by descending pfhsalary;
run;

/*
9. Bonus question: Create a new dataset from the raw text files that includes 
both the pilots and the navigators. 
*/
data airline.pilots3;/*inserting flag for pilot*/
	set airline.pilots3;
	pilot=1;
run;
data airline.nav1;/*inserting flag for pilot*/
	set airline.nav1;
	pilot=0;
run;
proc sort data = airline.pilots3;/*It made me sort by ID in order to merge this way.*/
	by ID;
run;
proc sort data = airline.nav1;
	by ID;
run;
data airline.both;
   merge airline.pilots3 airline.nav1;
   by ID;
run;

/*
10. Bonus question: Sort the dataset created in question 9 that contains both 
navigators and the pilots by job code and salary.  
*/
proc sort data = airline.both;
	by jobcode salary;
run;

/*
11.	Bonus question: Print out only the navigators from the sorted dataset 
discussed in question 10. Using separate code, print out only the pilots.  
*/
proc print data = airline.both;
	where pilot=0;
run;
proc print data = airline.both;
	where pilot=1;
run;
