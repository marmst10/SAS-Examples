/*
STAT 7020 - HOMEWORK 8
DUE 11/11/2019

This assignment uses 6 SAS data sets which each contain information about employees of a company who work in three
separate departments. The SAS data sets Dept2, and Dept3 give the name and salary of each employee working in departments
2 and 3 within the company. The data sets Dept1Names and Dept1Salaries also give this information (as well as the 
employee ID number) for employees working in department 1, but in 2 separate data sets. The employees are all encouraged 
to take the base level and advanced level SAS certification tests. Those who have active certifications in both tests are
given annual bonuses equal to 1% of their salary. The SAS data sets Base and Advanced give the names of the employees who
passed each certification test as well as the date they were certified. 

Using the information in these data sets, your task is to determine the employees who are currently actively certified in
both the base and advanced level SAS tests as well as the amounts of their bonus. 
*/

libname hw8 "C:\Users\conno\OneDrive\Desktop\STAT 7020 - SAS Programming\Homework 8\homework 8 data";

/*
1) Use one-to-one merging to combine the information in the data sets Dept1Names and Dept1Salaries into a new temporary 
SAS data set called Dept1 which only lists the employee’s name and salary (do not include the ID). Be aware that the 
employee ID variables are named differently in the two data sets and that the two data sets may not list the employees in
the same order! 
*/

/*rename empid to id so it will merge correctly*/
data hw8.dept1names;
	set hw8.dept1names;
	rename empid = id;
run;

/*Sorting the two datasets by id*/
proc sort data = hw8.dept1names;
	by id;
	
proc sort data = hw8.dept1salaries;
	by id;
run;

data hw8.dept1;
	set hw8.dept1names; /*one to one*/
	set hw8.dept1salaries;
	drop id;
run;


/*
2) Use concatenation to create a temporary data set which lists the employees in all three departments combined as well 
as their salaries. Call this data set Employee. 
*/
data hw8.employee;
	set hw8.dept1 hw8.dept2 hw8.dept3;/*concatenating*/
run;

/*
3) Use match-merging to create a temporary SAS data set called Both which lists only those employees that passed both the
base and advanced SAS certification tests. (Be aware that the date variables in the Base and Advanced data sets are both 
named “date”!) The data set Both should contain the employees’ names, both certification dates, and their salaries (Hint:
You will need to merge 3 data sets.) 
*/

/*first rename the dates*/
data hw8.advanced;
	set hw8.advanced;
	rename date = adv_date;
data hw8.base;
	set hw8.base;
	rename date = base_date;
run;

/*sort salaries and test datasets by name*/
proc sort data = hw8.employee;
	by name;
proc sort data = hw8.base;
	by name;
proc sort data = hw8.advanced;
	by name;
run;		

/*NEED TO MERGE TEST DATA FIRST*/
data hw8.both;
	merge hw8.base hw8.advanced hw8.employee;
	by name;
run;

/*DELETE OBSERVATIONS WITHOUT */
data hw8.both;
	set hw8.both;
	if adv_date ~= . and base_date ~= . ;
run;


/*
4) Use the certification dates in the data set Both to determine which of these employees is eligible for the 1% bonus. 
SAS certifications are only valid for seven years. Any certification tests passed over seven years ago from today’s date 
are expired. Eliminate those employees that have expired certifications in either Base or Advanced tests. Then output the
remaining employees’ names, certification dates, and their bonuses to the output window using appropriate date and dollar
formats.
*/
data hw8.notexpired (drop = expired);
	set hw8.both;
	if yrdif(adv_date, today(), 'act/act') > 7 
		then expired = 1;
	else if yrdif(base_date, today(), 'act/act') > 7 
		then expired = 1;
	else expired = 0;
	
	if expired = 0;
run;/*all are expired, change to 10 just for exercise*/

data hw8.notexpired (drop = expired);
	set hw8.both;
	if yrdif(adv_date, today(), 'act/act') > 10 
		then expired = 1;
	else if yrdif(base_date, today(), 'act/act') > 10 
		then expired = 1;
	else expired = 0;
	
	bonus = salary*0.01;
	format bonus dollar8.2;

	if expired = 0;
run;

proc print data = hw8.notexpired;
	var name adv_date base_date bonus;
run;
